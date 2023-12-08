

### Install WSL and turn on WSL2

### Install Latest CUDA Drivers

https://developer.nvidia.com/cuda-downloads?target_os=Windows&target_arch=x86_64&target_version=11&target_type=exe_local

### Install Docker

https://docs.docker.com/desktop/install/windows-install/

### Install nvdidia-container-toolkit

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

```
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg   && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |     sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |     sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y Nvidia-container-toolkit
```

### Configure NVIDIA x Docker 

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#configuring-docker

```
sudo nvidia-ctk runtime configure --runtime=docker
```
Restart docker via the Windows docker engine

### Test 

```
sudo docker run --GPUs all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -GPU -benchmark
docker run -it --rm --GPUs all ubuntu Nvidia-smi
#Test
sudo docker run --rm --gpus=all --GPUs all ubuntu nvidia-smi
```

### Make a container 


```
sudo docker image ls

docker pull ubuntu:jammy-20231128

#View a summary of image vulnerabilities and recommendations
docker scout Quickview ubuntu:jammy-20231128

# View vulnerabilities
docker scout covers ubuntu:jammy-20231128

#  View base image update recommendations
docker scout recommendations ubuntu:jammy-20231128

sudo docker container ls --all

```

















