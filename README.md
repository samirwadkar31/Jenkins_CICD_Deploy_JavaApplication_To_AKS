## SpringBoot application deployment to Azure Kubernetes Service Using Jenkins Pipelines.

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/1feaaf11-0347-495a-8a93-7d901d994092)


#### Step 1: Create Azure VM for Jenkin's Configuration, ACR & AKS
Azure Ubuntu 20.04:

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/ecd0c56f-aa8b-4292-938c-dc07518654c5)

ACR:

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/fdbe24ec-285d-429c-b394-aecb6c3b2b18)

AKS:

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/8fb0c510-6aea-4369-8caa-c25d71687a2d)

#### Step 2: [Jenkins Configuration on Azure VM Ubuntu 20.04](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/blob/3850ca2e77779476ae04947944321f862c6f55bf/DeploymentGuide/Jenkins-Configuration-On-Azure-Ubuntu-VM.md)
#### Step 3: [Install Docker, Kubectl & Azure-CLI On Azure VM Ubuntu 20.04](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/blob/cde8fff27763b0a287a6167aa2bf313303460bd2/DeploymentGuide/Install-Docker-Kubectl-AzureCLI-On-VM.md)
#### Step 4: [Add Jenkins User To Docker Group](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/blob/cde8fff27763b0a287a6167aa2bf313303460bd2/DeploymentGuide/Add-Jenkins-User-To-Docker-Group.md)

#### Step 5: [Install Required Jenkins Plugins ](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/blob/cde8fff27763b0a287a6167aa2bf313303460bd2/DeploymentGuide/Install-Jenkins-Plugins.md)

#### Step 6: Create Jenkins Credentials

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
Overview: We are using different stages to perform each task.<br> 
1. Checking out the source code from github SCM<br>
2. Build the java project using maven to get jar file<br>
3. Build the docker image
4. Push the image to ACR
5. Deploy manifest file to AKS

We can generate these code snippets from pipeline syntax tool.<br>
When we install the required plugins like docker plugin, docker pipeline plugin, kubeernetes CLI plugin, we get the option to generate code snippets in pipeline syntax tool. Here, is one of the examples,

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/2bffabcb-f9bb-4840-a4aa-fe15ca627982)
 
Click Apply and Save.

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/94acd828-4057-488e-9e09-f4c16a8a162b)

Click On Biuld now:

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/d29b89dc-f3ae-4a25-a359-9691bf8ab3f9)

Build is succeeded,

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/d8ab6107-f003-4524-848d-28811244576b)

Showing end part of the logs,

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/6e1e2b65-0bbb-4101-a03b-3a18a19da5a7)

Let's verify the pushed image on ACR,<br>
ACR repo contains our latest pushed image :)

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/f946097e-40b9-48b0-8a9c-2881ead08fa3)

Now, let's verify if it has deployed on AKS or not,<br>
It's deployed, and our pods are running :)

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/683ec2c0-017e-4121-b574-a270a4808b88)

Let's copy the springboot-app load balancer external ip and test it on the browser,<br>
Hurray, springboot-app is successfully deployed on AKS.

![image](https://github.com/samirwadkar31/Jenkins_CICD_Deploy_JavaApplication_To_AKS/assets/74359548/d633f3e3-ee42-4a78-9c53-f85b1d236388)



