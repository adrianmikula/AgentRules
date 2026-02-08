# Coding Rules

1. SDD - Spec Driven Development.  Always write logical/symbolic spec files for new features first, before implementing the actual code.  Code comments should refernece the spec that the coe implements. After writing new code, check that it matches the spec we wrote. Use tools like:
- TypeScpec
- Agint

2. TDD - Test Driven Development. Write tests as we code, to match the requirements and spec. Code comments should reference the spec that the test tests. Keep re-running the tests while we code to verify that our new code works.

3. KISS - Keep It Simple Stupid. Code should be kept as simple as possible.  Source files should be kept under 500 lines, and split into multiple files/classes if they get too large.

4. DRY. Don't Repeat Yourself. Check for and re-use existing code wherever possible, especially for common utils etc. Don't duplicate exisiting code functions/features.

5. Use industry best-practices for software development.  OOP, SOLID, etc.

6. Common code issues or gotchas should be documented in docs/COMMON_ISSUES.md so we can quickly diagnose errors and avoid re-occurrences of known issues or flawed patterns.