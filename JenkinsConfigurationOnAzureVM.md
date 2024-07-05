# Jenkins Configuration On Azure VM

## First, give permission to your key file.

```
chmod 400 <path-to-your-key.pem>
```

## Connect to your Azure VM using key.pem file.

```
sudo ssh -i <path-to-your-ssh-key.pem> username@ip-address-of-your-vm
```

## Update the system.

```
sudo apt-get update
```
```
sudo apt-get upgrade
```

## Install Java

```
sudo apt-get install openjdk-17-jdk 
```

Verify the Java version,

```
sudo java --version
```

## Add Jenkins Repository Key to your system

```
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \ https://pkg.jenkins.io/debian/jenkins.io-2023.key
```
## Add Jenkins Repository to your package manager

```
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \ https://pkg.jenkins.io/debian binary/ | sudo tee  /etc/apt/sources.list.d/jenkins.list > /dev/null
```

## Update Package Manager & Install Jenkins

```
sudo apt-get update
```
```
sudo apt-get install jenkins
```

## Start & enable Jenkins

```
sudo systemctl start jenkins
```
```
sudo systemctl enable jenkins
```

## Access Jenkins

```
http://<vm-ip-address>:8080
```

## Unlock Jenkins

```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

## Install suggested plugins

## Create First Admin User

And you are done!! :)
