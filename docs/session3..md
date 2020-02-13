# Containers and Docker (Part two)

## Stateless/Immutable Pipelines

In the first session we saw the problems of creating what we called stateful pipelines, where is really hard to know what is the state of the system before and after the pipeline runs, leading to bugs and "it works on my machine".
Ideally we would like to create a new machine every time we run our pipeline and that is really easy to achieve with images and containers.

- Rewrite the stateful pipeline for the voting application from first session to an stateless immutable pipeline with docker.

### Docker Multistage Builds

- Create a Multistage Dockerfile for the 'votingapp' application.
    - Create image for both ubuntu and alpine 
    - Use .dockerignore to filter the sent context to the docker daemon.
    - Optimize cache layering to avoid go modules dependencies download.


### Docker Networking

- Create a Dockerfile for the bash integration tests.
- Create a docker network attaching both the votingapp and integration tests containers.
