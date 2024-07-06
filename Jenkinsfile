pipeline {
    agent any
    

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven 'Maven'
    }
    
    environment {
        imagename = "myspringbootapplication"
        imagetag = "1"
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
                  dockerimage = docker.build("${imagename}:${imagetag}")
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
