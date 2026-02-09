# Testing Rules

1. TDD - Test Driven Development. Write tests as we code, to match the requirements and spec. Keep re-running the tests while we code to verify that our new code works.

2. Projects should configure a subset of unit tests as 'fast tests', which should have a very quick runtime, and should always run them after making code changes to ensure nothing is broken.  Add agent rules to always prefer the fast tests when making frequent code changes, and only run the full test suite when tasks are complete or just before pushing commits.

3. If the runtime of the build, compile or fast-test tasks frequently times out or is excessively slow, then the agent should pause coding tasks, and first review these rules to ensure we have an efficient dev environment and tooling set up.

4. Code coverage. The tests should be set up with the option to track code coverage, so we can find gaps in our coverage and fill them. In early POC or prototype stages of development, we should aim for 50% code coverage. When preparing for a production release, we should aim for 80% code coverage or higher.

5. Test pyramid. In early POC stages, unit tests are sufficient. For production code, we should add mocked component tests, API tests, and a small number of multi-system integration or E2E tests. 

6. Performance tests. Production systems should have a load/performance test framework set up, so we can simulate anticipated production scaling and loads, with production-like datasets. Performance targets should be based on the project's requirements.