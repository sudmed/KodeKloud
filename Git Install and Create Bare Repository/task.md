# Git Install and Create Bare Repository

The Nautilus development team shared requirements with the DevOps team regarding new application development.  
Specifically, they want to set up a Git repository for that project.  
Create a Git repository on Storage server in Stratos DC as per details given below:  
Install git package using yum on Storage server.  
After that create a bare repository /opt/beta.git (make sure to use exact name).  



### 1. Logon to server
`SSH natasha@172.16.238.15`
```console
Password: Bl@kW
```

### 2. Install git
`sudo yum install -y git`

### 3. Create repo
`sudo mkdir -p /opt/beta.git && cd $_`

### 4. Initialize git
`sudo git init --bare`
  
###  

---

###  

```console
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62aae3f52c9825e8810c9631
```
