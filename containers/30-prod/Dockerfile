ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}20-bowtie2 AS bowtie2

FROM ${IMAGE_PREFIX}22-other-deps

# Do not set $IMAGE_PREFIX to "COPY --from",
# as it does not allow an environment variable.
# https://github.com/moby/moby/issues/34482
COPY --from=bowtie2 /usr/local/bin/bowtie2* /usr/local/bin/
