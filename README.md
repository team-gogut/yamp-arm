# YAMP ARM Edition

[![Travis Build Status](https://travis-ci.org/team-gogut/yamp-arm.svg?&branch=master)](https://travis-ci.org/team-gogut/yamp-arm)
[![Shippable Build Status](https://api.shippable.com/projects/5c80093833944406009b4dd2/badge?branch=master)](https://app.shippable.com/github/team-gogut/yamp-arm/runs?branchName=master)
[![Docker Repository on Quay](https://quay.io/repository/gogut/yamp/status "Docker Repository on Quay")](https://quay.io/repository/gogut/yamp)

[YAMP](https://github.com/alesssia/YAMP) [ARM](https://en.wikipedia.org/wiki/ARM_architecture) Edition enables to build the ARM 64-bit container images, push those to a [container repository](https://quay.io/repository/gogut/yamp), then run the containers by pulling from the repository.

## Quick start for a development

Install `docker` and `make`, then run

```
$ make qemu
$ make login
```

See [docs/development.md](docs/development.md) for detail.
