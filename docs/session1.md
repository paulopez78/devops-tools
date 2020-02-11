# Basic scripting and Pipelines

Main goal is to understand the basics of [bash scripting](https://devhints.io/bash) for creating a simple pipeline for the votingapp application.

- `Stdin`, `Stdout` and `Stderr`
- `@?` and program exit code
- Create custom pipeline for voting app with the following steps:
    * Cleanup
    * Build 
    * Unit Tests
    * Integration Tests (with retries)
 
The most important part is checking if the pipeline **stops** when there is an **error exit code** when building or running tests.
