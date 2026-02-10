# Java Tomcat Boilerplate - Command Catalogue

.PHONY: fast-test typecheck test-full run build clean

# Agent-fast command (seconds) - ALWAYS run this
fast-test:
	@mvn test -Dtest=FastTests -DfailIfNoTests=false -q

# Type check only (instant feedback)
typecheck:
	@mvn compile -q

# Full test suite (CI only - slow)
test-full:
	@mvn test

# Run Tomcat (CI/deploy only)
run:
	@mvn tomcat7:run

# Build WAR
build:
	@mvn package -DskipTests -q

# Clean
clean:
	@mvn clean

# Full compile
compile:
	@mvn compile
