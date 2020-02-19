# Session 1: Basic scripting and Pipelines (stateful)

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

# Session 2: Containers and Docker (Part one)

## Understanding Images and Containers

Images are zipped files with the software we want to run and metadata that explains how to run it.
Containers are isolated processes running the software that is distributed in images.

## Building Images with DockerFiles

Building images is an automated process described in an script file called DockerFile.

- Create a Dockerfile for the 'kurl' application.
    - Show how layers are created during the build process.
    - Show how to version an image.
    - Show how to push to a public registry (DockerHub).
    - Show other modern options to build images: `export DOCKER_BUILDKIT=1`
    - Use alpine to create smaller images.
    - Create an alias to `kurl` to show that running a container is the same as running a command/process.

- Create a Dockerfile for the 'votingapp' application.
- Running the votingapp in a container exposing a port.

All Samples about running containers and building images are in `commands/docker-build.sh`

# Session 3: Containers and Docker (Part two)

## Stateless/Immutable Pipelines

In the first session we saw the problems of creating what we called stateful pipelines, where is really hard to know what is the state of the system before and after the pipeline runs, leading to bugs and "it works on my machine".
Ideally we would like to create a new machine every time we run our pipeline and that is really easy to achieve with images and containers.

- Rewrite the stateful pipeline for the voting application from first session to an stateless immutable pipeline with docker.

### Docker Multistage Builds

- Create a Multistage Dockerfile for the 'votingapp' application.
    - Create different images based on ubntu and alpine.
    - Use .dockerignore to filter the sent context to the docker daemon.
    - Optimize cache layering to avoid go modules dependencies download.

### Docker Networking

- Create a Dockerfile for the bash integration tests.
- Create a docker network attaching both the votingapp and integration tests containers.
- Create a redis container attached to the same network configuring the votingapp container for using redis.

There are 3 samples in the repo showing how to refactor towards immutable pipeline with docker
- `pipelines-docker-samples.sh`
- `pipelines-docker.sh`

# Session 4: Docker compose and networking (Part three)

- Refactoring of the imperative docker pipeline using a declarative file (yaml of course) and `docker-compose`
- Add an ingress reverse proxy to the votingapp solution.
- Use a docker volume to configure nginx.

There are 3 files with samples for that session:
- `pipelines-compose.sh`
- `docker-compose.yml`
- `commands/docker-networking.sh`
