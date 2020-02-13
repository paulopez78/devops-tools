# Containers and Docker (Part one)

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

All Samples about running containers and building images are in `session2.sh`
