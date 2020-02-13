# Basic scripting and Pipelines (stateful)

Main goal is to understand the basics of [bash scripting](https://devhints.io/bash) for creating a simple pipeline for the votingapp application.

- `Stdin`, `Stdout` and `Stderr`
- `@?` and program exit code
- Create custom pipeline for voting app with the following steps:
    * Cleanup
    * Build 
    * Unit Tests
    * Integration Tests (with retries)
 
The most important part is checking if the pipeline **stops** when there is an **error exit code** after building or running tests.

There are 2 samples in the repo showing the main problems when building an stateful pipelines in a not immutable environment:
- `pipelines-samples.sh`
- `pipelines.sh`