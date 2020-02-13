# Containers and Docker (Part one)

## Understanding Images and Containers

Images are zipped files with the software we want to run and metadata that explains how to run it.
Containers are isolated processes running the software that is distributed in images.

Samples about running containers are in `session2.sh`

## Building Images with DockerFiles

Building images is an automated process described in an script file called DockerFile.
- Create a Dockerfile for the 'kurl' application.
- Show how layers are created during the build process.
- Show other modern options to build images: `export DOCKER_BUILDKIT=1`