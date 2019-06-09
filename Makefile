ARCH ?= arm64
# ubuntu or rhel
OS ?= ubuntu
# bionic or 7
OS_VERSION ?= bionic
CONTAINER_SERVER = quay.io
# Container image prefix
IMAGE_PREFIX = $(CONTAINER_SERVER)/gogut/yamp:$(ARCH)-$(OS)-$(OS_VERSION)-
CWD = $(shell pwd)

default : help
.PHONY : default

help :
	@echo "Usage: make <target>"
	@echo
	@echo "targets"
	@echo "  qemu       Configure QEMU container to run multi-architecture"
	@echo "             container on x86_64"
	@echo "  login      Login to the container by gogut user"
	@echo "  login-root Login to the container by root user"
.PHONY : help

qemu :
	docker run --rm --privileged multiarch/qemu-user-static:register --reset
.PHONY : qemu

pull :
	docker pull "$(IMAGE_PREFIX)10-deb-pkgs" || true
	docker pull "$(IMAGE_PREFIX)10-rpm-pkgs" || true
	docker pull "$(IMAGE_PREFIX)20-bowtie2" || true
	docker pull "$(IMAGE_PREFIX)21-pip-pkgs" || true
	docker pull "$(IMAGE_PREFIX)22-other-deps" || true
	docker pull "$(IMAGE_PREFIX)30-prod" || true
	docker pull "$(IMAGE_PREFIX)40-dev" || true
.PHONY : pull

build : build-$(OS)
.PHONY : build-$(OS)

build-ubuntu : 10-deb-pkgs 20-bowtie2 21-pip-pkgs 22-other-deps 30-prod 40-dev
.PHONY : build-ubuntu

build-rhel : 10-rpm-pkgs 20-bowtie2 21-pip-pkgs 22-other-deps 30-prod 40-dev
.PHONY : build-rhel

10-deb-pkgs :
	docker build --rm \
		--build-arg ARCH="$(ARCH)" \
		--build-arg OS_VERSION="$(OS_VERSION)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 10-deb-pkgs

10-rpm-pkgs :
	docker build --rm \
		--build-arg ARCH="$(ARCH)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 10-rpm-pkgs

20-bowtie2 :
	docker build --rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 20-bowtie2

21-pip-pkgs :
	docker build --rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 21-pip-pkgs

22-other-deps :
	docker build --rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 22-other-deps

30-prod :
	docker build --rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 30-prod

40-dev :
	docker build --rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 40-dev

container-login :
	docker login "$(CONTAINER_SERVER)"
.PHONY : container-login

push : push-$(OS)
.PHONY : push-$(OS)

push-ubuntu : push-10-deb-pkgs push-20-bowtie2 push-21-pip-pkgs push-22-other-deps push-30-prod push-40-dev
.PHONY : build-ubuntu

push-10-deb-pkgs :
	docker push "$(IMAGE_PREFIX)10-deb-pkgs"
.PHONY : push-10-deb-pkgs

push-20-bowtie2 :
	docker push "$(IMAGE_PREFIX)20-bowtie2"
.PHONY : push-20-bowtie2

push-21-pip-pkgs :
	docker push "$(IMAGE_PREFIX)21-pip-pkgs"
.PHONY : push-21-pip-pkgs

push-22-other-deps :
	docker push "$(IMAGE_PREFIX)22-other-deps"
.PHONY : push-22-other-deps

push-30-prod :
	docker push "$(IMAGE_PREFIX)30-prod"
.PHONY : push-30-prod

push-40-dev :
	docker push "$(IMAGE_PREFIX)40-dev"
.PHONY : push-40-dev

test :
	# Use testing Dockerfile for the Shippable CI issue.
	# https://github.com/Shippable/support/issues/4824
	docker build \
		--rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" \
		-f containers/50-test/Dockerfile \
		.
	docker run --rm -t -u gogut "$(IMAGE_PREFIX)$@" tests/sample_test.sh
.PHONY : test

# Run the container interactively.
login-root :
	docker run -it -u root -w /build "$(IMAGE_PREFIX)40-dev"
.PHONY : login-root

login :
	docker run -it -u gogut -w /home/gogut -v "$(CWD):/home/gogut/yamp-arm" "$(IMAGE_PREFIX)40-dev"
.PHONY : login

clean :
	docker system prune -a -f
.PHONY : clean
