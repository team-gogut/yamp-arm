# How to start a development environment

## Quick start

Install `docker` and `make`, then run

```
$ make qemu
$ make login
```

## Instruction

### Install required softwares

#### docker

Install `docker` or a compatible software.

Docker: https://docs.docker.com/

#### make

Install `make` command if it is not installed.

Mac

```
$ brew install make
```

Windows

[This?](https://stackoverflow.com/questions/32127524/how-to-install-and-use-make-in-windows)

Linux (Ubuntu)

```
$ apt-get install make
```

### Download a source code

Download the repository source code by `git clone`.

```
$ git clone git@github.com:team-gogut/yamp-arm.git

$ cd yamp-arm
```

This repository has sub module `YAMP`.
Download the sub module by `git submodule`.

As initial status, YAMP directory is empty.

Run below command to download.

```
$ git submodule update --init --recursive
```

You see there are files under `YAMP` directory.

### Start the development environment

Run docker daemon

* Mac: Run "Applications > Docker > Docker Quickstart Terminal".
* Windows: I am not sure.

Run QEMU container to run arm64 container on it on the opened terminal. This operation is only for first time.

```
$ make qemu
```

Login to the development container by gogut user on the opened terminal. It takes a few minutes for only first time, downloading the container image to local.

```
$ make login
```

The environment is like this. **work directory is shared on your host os's work directory `yamp-arm/work`. Put necessary files there**. Please take care the files except `work` directory is **NOT** saved when logout the container.

```
[gogut]$ whoami
gogut

[gogut]$ uname -a
Linux 99152f218689 4.4.74-boot2docker #1 SMP Mon Jun 26 18:01:14 UTC 2017 aarch64 aarch64 aarch64 GNU/Linux

[gogut]$ pwd
/home/gogut

[gogut]$ ls
.bash_logout  .bashrc  .nextflow/  .profile  work/
```

### Stop the development environment

When exit the container, type `exit`.

```
[gogut]$ exit
exit
$
```

### Clean the development enviornment

Used containers' file size is very big (around 1.4GB). When you want to remove those, type `make clean` to remove all the container image.

```
$ docker image ls
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
quay.io/gogut/yamp           arm64-dev           31188244bdb0        About an hour ago   1.39GB
multiarch/qemu-user-static   register            9f0335919cf3        6 days ago          1.23MB
```

```
$ make clean
```

The container images are removed.

```
$ docker image ls
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
```
