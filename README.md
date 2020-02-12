# Devops tools workshop
## Scripting, Pipelines, Containers, Docker and Kubernetes

### **Cross Platform Setup (Windows, Mac or Linux)**

### Download and install

* [Visual Studio Code](https://code.visualstudio.com/download)
  - Plugins: Go, Python, Docker, Kubernetes
* [Git](https://git-scm.com/downloads)
* [Docker](https://www.docker.com/products/docker-desktop)
* [Golang](https://golang.org/dl/)
* [Python](https://www.python.org/downloads/)
* [jq](https://stedolan.github.io/jq/download/)
* [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
* [Kind](https://kind.sigs.k8s.io/docs/user/quick-start)

#### Note for Linux users 
- Docker for desktop is not available in Linux but docker can be installed natively [here](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- As Docker for desktop is not available one of the easiest ways to run kubernetes in linux is using [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)

#### Note for Windows users 
- It is highly recommended to setup [WSL configured for connecting to Docker for Desktop](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly).
- The best option but still in preview is the new [Docker for Desktop WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl-tech-preview/)
- It is also really interesting the option of running VSCode inside [WSL](https://code.visualstudio.com/remote-tutorials/wsl/run-in-wsl) or [WSL2](https://code.visualstudio.com/blogs/2019/09/03/wsl2) to have fully linux experience in Windows.

### Signup for

* [Dockerhub](https://hub.docker.com)
* [Github](https://github.com)

### Pull all the needed images

Start docker and pull images running the script `pull.sh`


### Slide Deck
[Slides for the workshop](https://docs.google.com/presentation/d/19jxpdzmK2SjL3mBAEcCXHRXi1Y1wgw0bjDMdd1KzvOE/edit?usp=sharing)