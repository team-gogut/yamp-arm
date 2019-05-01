ARCH ?= arm64
TAG = "quay.io/gogut/yamp:arm64"
CWD = $(shell pwd)

default : help
.PHONY : default

help :
	@echo "Usage: make <target>"
	@echo
	@echo "targets"
	@echo "  login        login to the container by gogut user"
	@echo "  login-root   login to the container by root user"
.PHONY : help

qemu :
	docker run --rm --privileged multiarch/qemu-user-static:register --reset
.PHONY : qemu

pull :
	docker pull "$(TAG)-base" || true
	docker pull "$(TAG)-bowtie2" || true
	docker pull "$(TAG)-pip-pkgs" || true
	docker pull "$(TAG)-other-deps" || true
	docker pull "$(TAG)-dev" || true
.PHONY : pull

build : build-base build-bowtie2 build-pip-pkgs build-other-deps build-prod build-dev
.PHONY : build

build-base :
	docker build --rm -f containers/Dockerfile-$(ARCH)-base -t "$(TAG)-base" .
.PHONY : build-base

build-bowtie2 :
	docker build --rm -f containers/Dockerfile-$(ARCH)-bowtie2 -t "$(TAG)-bowtie2" .
.PHONY : build-bowtie2

build-pip-pkgs :
	docker build --rm -f containers/Dockerfile-$(ARCH)-pip-pkgs -t "$(TAG)-pip-pkgs" .
.PHONY : build-pip-pkgs

build-other-deps :
	docker build --rm -f containers/Dockerfile-$(ARCH)-other-deps -t "$(TAG)-other-deps" .
.PHONY : build-other-deps

build-prod :
	docker build --rm -f containers/Dockerfile-$(ARCH) -t "$(TAG)" .
.PHONY : build-prod

build-dev :
	docker build --rm -f containers/Dockerfile-$(ARCH)-dev -t "$(TAG)-dev" .
.PHONY : build-dev

push :
	# docker push "$(TAG)-base"
	# docker push "$(TAG)-bowtie2"
	docker push "$(TAG)-pip-pkgs"
	docker push "$(TAG)-other-deps"
	docker push "$(TAG)"
	docker push "$(TAG)-dev"
.PHONY : push

test :
	docker run --rm -t "$(TAG)" ./sample_test.sh
.PHONY : test

# Run the container interactively.
login-root :
	docker run -it -t -u root -w /build "$(TAG)-dev"
.PHONY : login-root

login :
	docker run -it -t -u gogut -w /home/gogut -v "$(CWD)/work:/home/gogut/work" "$(TAG)-dev"
.PHONY : login
