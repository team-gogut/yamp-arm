ARCH ?= arm64
# ubuntu or rhel
OS ?= ubuntu
# bionic or 7
OS_VERSION ?= bionic
CONTAINER_SERVER = quay.io
# Container image prefix
IMAGE_PREFIX = $(CONTAINER_SERVER)/gogut/yamp:$(ARCH)-$(OS)-$(OS_VERSION)-
DOCKER = $(shell scripts/find_docker.sh)
QEMU_SUDO =
CWD = $(shell pwd)

ifeq ($(OS), ubuntu)
	TARGETS = 10-deb-pkgs 20-bowtie2 21-pip-pkgs 22-other-deps 30-prod 40-dev
else
	TARGETS = 10-rpm-pkgs 20-bowtie2 21-pip-pkgs 22-other-deps 30-prod 40-dev
endif

ifeq ($(DOCKER), podman)
	QEMU_SUDO = sudo
endif

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

env :
	@echo "IMAGE_PREFIX=$(IMAGE_PREFIX)"
	@echo "DOCKER=$(DOCKER)"
	@echo "CWD=$(CWD)"
	@echo "TARGETS=$(TARGETS)"
	@echo "QEMU_SUDO=$(QEMU_SUDO)"
.PHONY : env

qemu-build-push : container-login qemu pull build push
.PHONY : qemu-build-push

qemu :
	$(QEMU_SUDO) "$(DOCKER)" run --rm --privileged multiarch/qemu-user-static:register --reset
.PHONY : qemu

pull :
	for target in $(TARGETS); do \
		"$(DOCKER)" pull "$(IMAGE_PREFIX)$$target" || true; \
	done
.PHONY : pull

build : $(TARGETS)
.PHONY : build

10-deb-pkgs :
	"$(DOCKER)" build --rm \
		--build-arg ARCH="$(ARCH)" \
		--build-arg OS_VERSION="$(OS_VERSION)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 10-deb-pkgs

10-rpm-pkgs :
	"$(DOCKER)" build --rm \
		--build-arg ARCH="$(ARCH)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 10-rpm-pkgs

20-bowtie2 :
	"$(DOCKER)" build --rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 20-bowtie2

21-pip-pkgs :
	"$(DOCKER)" build --rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 21-pip-pkgs

22-other-deps :
	"$(DOCKER)" build --rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 22-other-deps

30-prod :
	"$(DOCKER)" build --rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 30-prod

40-dev :
	"$(DOCKER)" build --rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" containers/$@
.PHONY : 40-dev

container-login :
	"$(DOCKER)" login "$(CONTAINER_SERVER)"
.PHONY : container-login

push : push-$(OS)
.PHONY : push-$(OS)

push-ubuntu : push-10-deb-pkgs push-20-bowtie2 push-21-pip-pkgs push-22-other-deps push-30-prod push-40-dev
.PHONY : build-ubuntu

push-10-deb-pkgs :
	"$(DOCKER)" push "$(IMAGE_PREFIX)10-deb-pkgs"
.PHONY : push-10-deb-pkgs

push-20-bowtie2 :
	"$(DOCKER)" push "$(IMAGE_PREFIX)20-bowtie2"
.PHONY : push-20-bowtie2

push-21-pip-pkgs :
	"$(DOCKER)" push "$(IMAGE_PREFIX)21-pip-pkgs"
.PHONY : push-21-pip-pkgs

push-22-other-deps :
	"$(DOCKER)" push "$(IMAGE_PREFIX)22-other-deps"
.PHONY : push-22-other-deps

push-30-prod :
	"$(DOCKER)" push "$(IMAGE_PREFIX)30-prod"
.PHONY : push-30-prod

push-40-dev :
	"$(DOCKER)" push "$(IMAGE_PREFIX)40-dev"
.PHONY : push-40-dev

test :
	# Use testing Dockerfile for the Shippable CI issue.
	# https://github.com/Shippable/support/issues/4824
	"$(DOCKER)" build \
		--rm \
		--build-arg IMAGE_PREFIX="$(IMAGE_PREFIX)" \
		-t "$(IMAGE_PREFIX)$@" \
		-f containers/50-test/Dockerfile \
		.
	"$(DOCKER)" run --rm -t -u gogut "$(IMAGE_PREFIX)$@" tests/sample_test.sh
.PHONY : test

# Run the container interactively.
login-root :
	"$(DOCKER)" run -it -u root -w /build "$(IMAGE_PREFIX)40-dev"
.PHONY : login-root

login :
	"$(DOCKER)" run -it -u gogut -w /home/gogut -v "$(CWD):/home/gogut/yamp-arm" "$(IMAGE_PREFIX)40-dev"
.PHONY : login

clean :
	"$(DOCKER)" system prune -a -f
.PHONY : clean
