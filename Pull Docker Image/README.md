# Pull Docker Image
Nautilus project developers are planning to start testing on a new project. As per their meeting with the DevOps team, they want to test containerized environment application features.  
As per details shared with DevOps team, we need to accomplish the following task:  
- a. Pull busybox:musl image on App Server 3 in Stratos DC and re-tag (create new tag) this image as busybox:media.  



## 1. Login on to app server
```
ssh banner@stapp03  # BigGr33n
ssh tony@stapp01    # Ir0nM@n
```
`sudo -i`

## 2. Check existing docker images
`docker images`
```console
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
```

## 3. Pull the docker image on the server
`docker pull busybox:musl`
```console
musl: Pulling from library/busybox
0e5a11429b0e: Pull complete 
Digest: sha256:2a3b33f1604b2bfb464761c3f6ca059b801491943606d9c3d67bc64d56b9a11d
Status: Downloaded newer image for busybox:musl
docker.io/library/busybox:musl
```

## 4. Create new tag
`docker image tag busybox:musl busybox:media`

## 5. Check docker images
`docker images`
```console
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
busybox      media     368ac696baa1   2 weeks ago   1.4MB
busybox      musl      368ac696baa1   2 weeks ago   1.4MB
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62b6f999c8f39ab094d26385
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:636545fedba7fe621cbc5673
```
