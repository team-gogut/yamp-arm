ARCH ?= arm64
GOGUT_INSTALL_DEPS ?= 0

default : qemu build
.PHONY : default

qemu :
	docker run --rm --privileged multiarch/qemu-user-static:register --reset
.PHONY : qemu

build :
	docker build \
		--build-arg INSTALL_DEPS=$(GOGUT_INSTALL_DEPS) \
		--rm \
		-f Dockerfile-$(ARCH) \
		-t gogut \
		.
.PHONY : build

test :
	docker run --rm -t gogut ./sample_test.sh
.PHONY : test

# Run the container interactively.
login :
	docker run -it -t gogut
.PHONY : login

login-u :
	docker run -it -t -u gogut gogut
.PHONY : login-u
