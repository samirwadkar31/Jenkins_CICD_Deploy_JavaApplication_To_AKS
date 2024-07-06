We are going to perform docker commands using jenkins pipeline. To avoid the prefix sudo everytime, we will be adding the jenkins user to docker group. 

```
sudo usermod -a -G docker jenkins
```
Now, jenkins can run docker commands without sudo as a prefix. In above command -a : append jenkins user -G: To group called docker <br>

Restart Jenkins:

```
sudo service restart jenkins
```
Reload system daemon files:

```
sudo systemctl daemon-reload
```

Restart Docker:

```
sudo service docker stop
```
```
sudo service docker start
```
