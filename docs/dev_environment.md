# How to prepare development environment

## Prepare requrement softwares

### docker

Install docker.

### make

Install make command if it is not installed.

```
$ brew install make
```

## How to start

1. Run docker daemon

In case of Mac OSX, run "Applications > Docker > Docker Quickstart Terminal".

2. Run QEMU container to run arm64 container on it. This operation is only for first time.

```
$ make qemu
```

3. Login to the development container by gogut user.

```
$ make login
```

3. When exit the container, type "exit".

```
$ make login
docker run -it -t -u gogut -w /home/gogut -v "/Users/jun.aruga/git/gogut/yamp-arm/work:/home/gogut/work" ""quay.io/gogut/yamp:arm64"-dev"
[gogut]$ uname -a
Linux 99152f218689 4.4.74-boot2docker #1 SMP Mon Jun 26 18:01:14 UTC 2017 aarch64 aarch64 aarch64 GNU/Linux
[gogut]$ exit
exit
$
```
