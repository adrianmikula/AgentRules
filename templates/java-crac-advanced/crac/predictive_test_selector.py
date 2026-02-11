#!/usr/bin/env python3
# crac/predictive_test_selector.py
# Google JiGaSi-inspired predictive test selection
# Uses heuristics to predict which tests will fail

import os
import sys
import json
import subprocess
import hashlib
from datetime import datetime
from pathlib import Path

class PredictiveTestSelector:
    """
    Predicts which tests are likely to fail based on code changes.
    
    This is a simplified implementation inspired by Google's JiGaSi.
    In production, this would use a trained ML model.
    """
    
    def __init__(self, project_root: str = "."):
        self.project_root = Path(project_root)
        self.cache_dir = self.project_root / "build" / "cache" / "predictive"
        self.test_history_file = self.cache_dir / "test_history.json"
        self.change_cache_file = self.cache_dir / "changes.json"
        
        # Ensure cache directory exists
        self.cache_dir.mkdir(parents=True, exist_ok=True)
        
        # Load historical data
        self.test_history = self._load_test_history()
    
    def _load_test_history(self) -> dict:
        """Load historical test results."""
        if self.test_history_file.exists():
            with open(self.test_history_file, 'r') as f:
                return json.load(f)
        return {"runs": []}
    
    def _save_test_history(self):
        """Save test history."""
        with open(self.test_history_file, 'w') as f:
            json.dump(self.test_history, f, indent=2)
    
    def _get_changed_files(self) -> list:
        """Get list of changed files since last commit."""
        try:
            # Get staged files
            result = subprocess.run(
                ['git', 'diff', '--cached', '--name-only', '--diff-filter=ACM'],
                cwd=self.project_root,
                capture_output=True,
                text=True
            )
            staged = result.stdout.strip().split('\n') if result.stdout.strip() else []
            
            # Get modified files
            result = subprocess.run(
                ['git', 'diff', '--name-only', '--diff-filter=ACM'],
                cwd=self.project_root,
                capture_output=True,
                text=True
            )
            modified = result.stdout.strip().split('\n') if result.stdout.strip() else []
            
            return list(set(staged + modified))
        except Exception as e:
            print(f"Warning: Could not get changed files: {e}")
            return []
    
    def _calculate_file_risk(self, file_path: str) -> float:
        """
        Calculate risk score for a file based on heuristics.
        Returns 0.0 (low risk) to 1.0 (high risk).
        """
        risk = 0.0
        
        # High-risk patterns
        high_risk_patterns = [
            'controller', 'service', 'repository',
            'security', 'auth', 'payment',
            'transaction', 'workflow'
        ]
        
        file_lower = file_path.lower()
        
        # Check for high-risk patterns
        for pattern in high_risk_patterns:
            if pattern in file_lower:
                risk += 0.2
        
        # File extension risk
        if file_path.endswith('.java'):
            risk += 0.1
        
        # Recently modified files are higher risk
        try:
            result = subprocess.run(
                ['git', 'log', '-1', '--format=%ai', '--', file_path],
                cwd=self.project_root,
                capture_output=True,
                text=True
            )
            if result.stdout.strip():
                commit_date = datetime.fromisoformat(result.stdout.strip().split(' ')[0])
                days_ago = (datetime.now() - commit_date).days
                if days_ago < 7:
                    risk += 0.1
        except:
            pass
        
        return min(risk, 1.0)
    
    def _find_related_tests(self, file_path: str) -> list:
        """Find tests related to a changed file."""
        tests = []
        
        # Convert file path to test path
        # src/main/java/com/example/Foo.java -> src/test/java/com/example/FooTest.java
        if '/main/' in file_path:
            test_path = file_path.replace('/main/', '/test/')
            test_path = test_path.replace('.java', 'Test.java')
            
            # Also check for alternative patterns
            alternatives = [
                test_path,
                test_path.replace('Test.java', 'Tests.java'),
                test_path.replace('Test.java', 'IT.java'),
            ]
            
            for alt in alternatives:
                if Path(self.project_root / alt).exists():
                    tests.append(alt)
        
        return tests
    
    def _select_tests(self, changed_files: list) -> list:
        """
        Select tests likely to fail based on changed files.
        
        Strategy:
        1. Calculate risk for each changed file
        2. Find related tests
        3. Prioritize high-risk tests
        4. Limit to reasonable number (max 20% of total tests)
        """
        selected_tests = []
        file_risks = []
        
        for file_path in changed_files:
            risk = self._calculate_file_risk(file_path)
            related_tests = self._find_related_tests(file_path)
            
            for test in related_tests:
                file_risks.append((test, risk))
        
        # Sort by risk (highest first)
        file_risks.sort(key=lambda x: x[1], reverse=True)
        
        # Get all tests
        all_tests = self._get_all_tests()
        
        # Limit selection to 20% of total tests
        max_tests = max(1, int(len(all_tests) * 0.2))
        
        # Select tests
        for test, risk in file_risks:
            if len(selected_tests) >= max_tests:
                break
            if test not in selected_tests and risk > 0:
                selected_tests.append(test)
        
        return selected_tests
    
    def _get_all_tests(self) -> list:
        """Get list of all test files."""
        test_dir = self.project_root / "src" / "test" / "java"
        if not test_dir.exists():
            return []
        
        tests = []
        for java_file in test_dir.rglob("*Test.java"):
            tests.append(str(java_file.relative_to(self.project_root)))
        
        return tests
    
    def _get_test_result_history(self, test_name: str) -> dict:
        """Get historical results for a test."""
        for run in reversed(self.test_history.get("runs", [])):
            if test_name in run.get("tests", {}):
                return run["tests"][test_name]
        return None
    
    def select(self) -> list:
        """
        Main method: Select tests likely to fail.
        
        Returns:
            List of test class names to run
        """
        print("Analyzing changes...")
        
        # Get changed files
        changed_files = self._get_changed_files()
        print(f"Changed files: {len(changed_files)}")
        
        if not changed_files:
            print("No changes detected, running all tests")
            return self._get_all_tests()
        
        # Calculate risks and select tests
        selected = self._select_tests(changed_files)
        
        # If no related tests found, run tests for changed packages
        if not selected:
            print("No direct test matches, using package-based selection")
            selected = self._select_by_package(changed_files)
        
        print(f"Selected {len(selected)} tests for execution")
        
        if selected:
            print(f"  First 5: {selected[:5]}")
        
        return selected
    
    def _select_by_package(self, changed_files: list) -> list:
        """Select tests by package of changed files."""
        selected = []
        all_tests = self._get_all_tests()
        
        for file_path in changed_files:
            # Extract package from main source
            if '/main/' in file_path:
                parts = file_path.split('/main/java/')[-1].replace('/', '.').replace('.java', '')
            else:
                continue
            
            # Find tests in same package or subpackages
            for test in all_tests:
                if parts in test or any(part in test for part in parts.split('.')):
                    if test not in selected:
                        selected.append(test)
        
        return selected[:20]  # Limit to 20 tests
    
    def record_results(self, test_results: dict):
        """Record test results for future predictions."""
        self.test_history["runs"].append({
            "timestamp": datetime.now().isoformat(),
            "tests": test_results
        })
        
        # Keep only last 100 runs
        if len(self.test_history["runs"]) > 100:
            self.test_history["runs"] = self.test_history["runs"][-100:]
        
        self._save_test_history()


def main():
    """Main entry point."""
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Predictive test selector for CRaC"
    )
    parser.add_argument(
        '--project', '-p',
        default='.',
        help='Project root directory'
    )
    parser.add_argument(
        '--output', '-o',
        help='Output file for selected tests'
    )
    parser.add_argument(
        '--run',
        action='store_true',
        help='Run selected tests immediately'
    )
    
    args = parser.parse_args()
    
    selector = PredictiveTestSelector(args.project)
    selected_tests = selector.select()
    
    if args.output:
        with open(args.output, 'w') as f:
            json.dump(selected_tests, f, indent=2)
        print(f"Selected tests written to {args.output}")
    
    if args.run:
        print("Running selected tests...")
        cmd = ['./gradlew', 'test', '--tests', ' '.join(selected_tests)]
        subprocess.run(cmd, cwd=args.project)
    
    return selected_tests


if __name__ == "__main__":
    main()
