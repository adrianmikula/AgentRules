# Efficiency Rules

1. Agents should install useful or relevant MCP tools/servers which would allow for faster development, fast linting, better visibility of errors, integration with external dev systems, or easier debugging of test/CI errors. Examples:
- Github MCP
- Github Actions MCP
- Railway MCP

2. Agents should install useful or relevant MCP tools/servers which provide better understanding of the codebase, documentation, and requirements. Examples:
- Codebase indexing MCP
- Persistent memory MCP
- Code/API Documentation MCP

2. Project should be set up with a command catalogue or indexing tool, to ensure agents can use consistent CLI commands, easily add commands to whitelists/allowlists, and avoid wasting time with incorrect CLI arguments, paths, OS or commands. Examples:
- Mise-en-place
- Proton

3. Project should have a fast linting tool or command configured for each language, to quicly spot code syntax errors without requiring a full build.

4. Projects should configure a subset of unit tests as 'fast tests', which should have a very quick runtime, and should always run them after making code changes to ensure nothing is broken.

5. All CLI tools and build/test commands should be configured for optimal startup time and speed. 

6. If the runtime of the build, compile or fast-test tasks frequently times out or is excessively slow, then the agent should pause coding tasks, and first review these rules to ensure we have an efficient dev environment and tooling set up.