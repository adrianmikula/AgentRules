# Documentation Rules

1. All code implementations should be documented in Markdown files under the docs folder, with the following folder structure:

docs
- research/
- investigations/
- requirements/
- standards/
- decisions/
- ARCHITECTURE.md
- FEATURES.md
- SETUP.md
- CICD.md
- TESTING.md
- TASKS.md
- ROADMAP.md

2. Treat documentation as named, reusable entities. Whenever possible, we should prefer to update existing documentation and avoid duplication, rather than creating new Markdown files.

3. Once-off documentation, market research, decisions or bug investigations, should be dated. These types of docs aren't treated as named entities.

4. Requirements and standards should never be modified by the agent, only by humans.