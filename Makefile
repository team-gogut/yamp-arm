ARCH ?= arm64
TAG = quay.io/gogut/yamp:arm64
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
	docker push "$(TAG)-base"
	docker push "$(TAG)-bowtie2"
	docker push "$(TAG)-pip-pkgs"
	docker push "$(TAG)-other-deps"
	docker push "$(TAG)"
	docker push "$(TAG)-dev"
.PHONY : push

test-env :
	docker run --rm -t -u gogut -w /home/gogut -v "$(CWD)/tests:/home/gogut/tests" "$(TAG)-dev" uname -a
	docker run --rm -t -u gogut -w /home/gogut -v "$(CWD)/tests:/home/gogut/tests" "$(TAG)-dev" pwd
	docker run --rm -t -u gogut -w /home/gogut -v "$(CWD)/tests:/home/gogut/tests" "$(TAG)-dev" ls -l
	docker run --rm -t -u gogut -w /home/gogut -v "$(CWD)/tests:/home/gogut/tests" "$(TAG)-dev" ls -lR
	docker run --rm -t -u gogut -w /home/gogut -v "$(CWD)/tests:/home/gogut/tests" "$(TAG)-dev" ls -l /home/gogut/tests
	docker run --rm -t -u gogut -w /home/gogut -v "$(CWD)/tests:/home/gogut/tests" "$(TAG)-dev" ls -l tests
.PHONY : test-env

test :
	# Use testing Dockerfile-test for the Shippable CI issue.
	# https://github.com/Shippable/support/issues/4824
	# docker run --rm -t -u gogut -w /home/gogut -v "$(CWD)/tests:/home/gogut/tests" "$(TAG)-dev" tests/sample_test.sh
	docker build --rm -t "$(TAG)-test" --build-arg IMAGE=$(TAG)-dev -f containers/Dockerfile-test .
	docker run --rm -t -u gogut "$(TAG)-test" tests/sample_test.sh
.PHONY : test

# Run the container interactively.
login-root :
	docker run -it -u root -w /build "$(TAG)-dev"
.PHONY : login-root

login :
	docker run -it -u gogut -w /home/gogut -v "$(CWD):/home/gogut" "$(TAG)-dev"
.PHONY : login

clean :
	docker system prune -a -f
.PHONY : clean
