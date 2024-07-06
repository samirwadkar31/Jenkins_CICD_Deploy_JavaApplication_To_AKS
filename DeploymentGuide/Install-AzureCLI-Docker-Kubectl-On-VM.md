# Install Docker, Kubectl, & Azure CLI On Azure Ubuntu 20.04 VM where Jenkins is configured

## 1. Install Docker 

Follow this official link to install docker on the Ubuntu 20.04 VM: https://docs.docker.com/engine/install/ubuntu/


Add Docker's official GPG key:
```
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```
Add the repository to Apt sources:
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
Install latest docker:
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
Add Ubuntu system user to docker group:
```
sudo usermod -aG docker $USER
```

Start the docker: 
```
sudo systemctl start docker
```
```
sudo systemctl enable docker
```
```
sudo systemctl status docker
```
## 2. Install Kubectl

Follow this official link to install kubectl on the Ubuntu 20.04 VM: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/ (Install using native package management)

## 3. Install Azure CLI

Follow this official link to install azure-cli on the Ubuntu 20.04 VM: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt (Option 2)
