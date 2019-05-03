# How to prepare development environment

## Prepare requrement softwares

### docker

Install docker.

### make

Install make command if it is not installed.

```
$ brew install make
```

## Get this repository source on local.

Download the repository source by `git clone`.

```
$ git clone git@github.com:team-gogut/yamp-arm.git

$ cd yamp-arm
```

This repository has sub module `YAMP`.
Download the sub module by `git submodule`.

As initial status, YAMP directory is empty.

```
$ git submodule
-51591221f0374d0e90ae3755dea0ff5bff595f05 YAMP
```

Run below command to download.

```
$ git submodule update --init --recursive
```

You see there are files under `YAMP` directory.

```
$ git submodule
 51591221f0374d0e90ae3755dea0ff5bff595f05 YAMP (heads/master)
```

## How to start

1. Run docker daemon

In case of Mac OSX, run "Applications > Docker > Docker Quickstart Terminal".

2. Run QEMU container to run arm64 container on it. This operation is only for first time.

```
$ make qemu
```

3. Login to the development container by gogut user. It takes a few minutes for only first time, downloading the container image to local.

```
$ make login
```

4. The environment is like this. **work directory is shared on your host os's work directory `yamp-arm/work`. Put necessary files there**. Please take care the files except `work` directory is **NOT** saved when logout the container.

```
[gogut]$ whoami
gogut

[gogut]$ pwd
/home/gogut

[gogut]$ ls
.bash_logout  .bashrc  .nextflow/  .profile  work/
```

5. When exit the container, type `exit`.

```
$ make login
docker run -it -t -u gogut -w /home/gogut -v "/Users/jun.aruga/git/gogut/yamp-arm/work:/home/gogut/work" ""quay.io/gogut/yamp:arm64"-dev"
[gogut]$ uname -a
Linux 99152f218689 4.4.74-boot2docker #1 SMP Mon Jun 26 18:01:14 UTC 2017 aarch64 aarch64 aarch64 GNU/Linux
[gogut]$ exit
exit
$
```

6. Used containers' size is very big (around 1.4GB). When you want to remove those, type `make clean` to remove all the containers on local.

```
$ docker image ls
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
quay.io/gogut/yamp           arm64-dev           31188244bdb0        About an hour ago   1.39GB
multiarch/qemu-user-static   register            9f0335919cf3        6 days ago          1.23MB
```

```
$ make clean
```
