# Create a Docker Network

The Nautilus DevOps team needs to set up several docker environments for different applications. One of the team members has been assigned a ticket where he has been asked to create some docker networks to be used later. Complete the task based on the following ticket description:  
a. Create a docker network named as ecommerce on App Server 2 in Stratos DC.  
b. Configure it to use bridge drivers.  
c. Set it to use subnet 172.168.0.0/24 and iprange 172.168.0.2/24.  



## 1. Login on app server 2
`ssh steve@stapp02`  
`sudo -i`


## 2. Check existing docker network
`docker network ls`
```console
NETWORK ID     NAME      DRIVER    SCOPE
a2df0c448495   bridge    bridge    local
15706bd74031   host      host      local
97c98d671136   none      null      local
```


## 3. Create new docker network
`docker network create -d bridge --subnet=172.168.0.0/24 --ip-range=172.168.0.2/24 ecommerce`
```console
dd1143c71a0bc4db2155c9079970ae52051e207fc1b3ea9b6642e25e4200cf4d
```

`docker network create -d macvlan --subnet=192.168.0.0/24 --ip-range=172.168.0.1/24 media`  
```console
a88ed1a8618f7a9868e6a2955b17cbe78c2e2e4f755700ef84a203fc4a24ed4a
```

`docker network create -d bridge --subnet=10.10.1.0/24 --ip-range=10.10.1.3/24 beta`  
```console
21c452560c735a5d113153d1568b4714a28fb3f629adc637b9ce04e25e5e2c86
```


## 4. Validate the task
`docker network ls`
```console
NETWORK ID     NAME        DRIVER    SCOPE
a2df0c448495   bridge      bridge    local
dd1143c71a0b   ecommerce   bridge    local
15706bd74031   host        host      local
97c98d671136   none        null      local
```


`docker network inspect ecommerce`
```console
[
    {
        "Name": "ecommerce",
        "Id": "dd1143c71a0bc4db2155c9079970ae52051e207fc1b3ea9b6642e25e4200cf4d",
        "Created": "2022-07-17T20:52:47.227999458Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.168.0.0/24",
                    "IPRange": "172.168.0.2/24"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

---

## A job well-done congratulations:


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62d319a1d2ba2eafe14b1d9c
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:638a764ef49b2faf50d4da9b
```
