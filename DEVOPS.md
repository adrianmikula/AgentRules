# DevOps Rules

1. The human should set up environment variables with API keys for Github, Github Actions, and Railway.

2. The project should have a fast CICD pipeline for Pull Requests which runs the compile, all of the tests, calculates the code coverage, and deploys to the staging environment on Railway.

3. The project should have a full CICD pipeline for the main branch, which runs the compile, all of the tests, containerisation, packaging, load tests, and deploys to the production/demo environment on Railway.

4. If running on Linux, the agent should test any CI changes locally using the Act MCP tool.