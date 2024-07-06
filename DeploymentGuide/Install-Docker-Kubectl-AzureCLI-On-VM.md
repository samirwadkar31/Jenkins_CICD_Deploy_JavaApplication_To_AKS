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
Add Ubuntu system user to docker group:(With this, current user can perform docker commands on VM without using prefix 'sudo')
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

Get packages needed for the installation process:

```
sudo apt-get update
```
```
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
```

Download the public signing key for the Kubernetes package repositories:

```
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```
```
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```
Add the appropriate Kubernetes apt repository:

```
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```
```
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
```
Update apt package:
```
sudo apt-get update
```
install kubectl:
```
sudo apt-get install -y kubectl
```
Add kubeconfig context and validate installation od kubectl by running some kubectl commands.
## 3. Install Azure CLI

Follow this official link to install azure-cli on the Ubuntu 20.04 VM: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt (Option 2)

```
sudo apt-get install azure-cli
```

If above command doesn't work then follow below way,

Get packages needed for the installation process:

```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release
```

Download and install the Microsoft signing key:

```
sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
  gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
```
Add the Azure CLI software repository:

```
AZ_DIST=$(lsb_release -cs)
echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources
```

Update repository information and install the azure-cli package:

```
sudo apt-get update
sudo apt-get install azure-cli
```
