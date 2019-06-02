ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}30-prod

# Create non-root user
RUN useradd -m gogut

USER gogut
WORKDIR /home/gogut
COPY gogut_bashrc .bashrc

# Install initial apps for nextflow
RUN nextflow -version

CMD ["bash"]
