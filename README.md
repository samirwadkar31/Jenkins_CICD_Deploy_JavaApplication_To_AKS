## SpringBoot application deployment to Azure Kubernetes Service Using Jenkins Pipelines.

#### Step 1: [Jenkins Configuration on Azure VM Ubuntu 20.04](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/blob/3850ca2e77779476ae04947944321f862c6f55bf/DeploymentGuide/Jenkins-Configuration-On-Azure-Ubuntu-VM.md)
#### Step 2: [Install Docker, Kubectl & Azure-CLI On Azure VM Ubuntu 20.04](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/blob/cde8fff27763b0a287a6167aa2bf313303460bd2/DeploymentGuide/Install-Docker-Kubectl-AzureCLI-On-VM.md)
#### Step 3: [Add Jenkins User To Docker Group](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/blob/cde8fff27763b0a287a6167aa2bf313303460bd2/DeploymentGuide/Add-Jenkins-User-To-Docker-Group.md)

#### Step 4: [Install Required Jenkins Plugins ](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/blob/cde8fff27763b0a287a6167aa2bf313303460bd2/DeploymentGuide/Install-Jenkins-Plugins.md)

#### Step 5: Create Jenkins Credentials

1. We need to connect with our GitHub Repo, where our source code is present. To check out the SCM in jenkins we need GitHub PAT token for the authentication in case of private repository. Create PAT token on github and add it in jenkins credentials.
2. We need to push the docker image to private container registry on Azure (ACR). For this authentication, we need to enable admin user in ACR and create the username & password credentails in jenkins.
3. Lastly, we need to pull the image from ACR & deploy it to AKS using manifest.yaml file. To deploy manifest file on AKS and to perform kubectl commands we need permission/authentication. Kubeconfig can help us to achieve that. Add kubeconfig context to your Ubuntu VM. cat kube.config file, copy the entire key/token and paste it into txt file. Further, we can use this kube.config txt file as a secret file in jenkins credentails.

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/937cb48d-eac4-42df-a164-b68332c137f2)
