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

#### Step 6: Create Jenkins Pipelines
Go to New Item -> Select Pipeline-> Enter name of your pipeline->Ok

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/34ce456d-efc6-4d54-bcca-9e6cb17864cb)

Write your own pipeline script or select the path where your jenkins file is stored from SCM.

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/8c7cc4e7-2aa7-4b31-ba26-12b5db57cd41)
 
Here, I have written the pipelinescript on my own (Have added same script in jenkinsfile for the future reference)

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/6fab5939-1975-4c60-ac33-c4f1a80f6ee7)

Pipeline Script:

```
pipeline {
    agent any
    

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven 'Maven'
    }
    
    environment {
        imagename = "myspringbootapp"
        imagetag = "latest"
        dockerimage =""
        credentialsId ="ACR"
        
    }

    stages {
        
        stage('checkout scm') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'PAT', url: 'https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS.git']])
            }
        }
        stage('Build Using Maven') {
            steps {
                sh 'mvn -f pom.xml clean install'
            }

        }
        
        stage('Build Docker Image') {
            steps {
                script{
                  dockerimage = docker.build imagename
                }
                
            }

        }
        
        stage('Push Docker Image To ACR') {
            steps {
                script{
                    
                    docker.withRegistry("https://sameeracr101.azurecr.io", credentialsId ) {
                        dockerimage.push()
                    }
                }
                
            }

        }
        
         stage('DeployToAKS') {
            steps {
                script{
                   withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'KubeConfigAKS', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                        sh 'kubectl apply -f springboot_manifest.yaml'
                    }
                }
                
            }

        }
        
    }
}

```
Click Apply and Save.
