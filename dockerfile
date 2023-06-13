# Set the base image to Ubuntu 20.04 LTS
FROM ubuntu:bionic-20230530

# My authorship
LABEL maintainer="ehill@iolani.org"
LABEL version="1.0.0"
LABEL description="decona_plus for the Iolani School"

# Disable prompts during package installation
ENV DEBIAN_FRONTEND noninteractive

# Convenience packages
RUN apt update
RUN apt install -y curl git g++ zlib1g-dev make bsdmainutils gawk bcftools libopenblas-base wget nano

# R installation
RUN apt install -y --no-install-recommends software-properties-common dirmngr
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN apt install -y r-base
RUN add-apt-repository ppa:c2d4u.team/c2d4u4.0+
RUN R -e "install.packages(c('ggplot2', 'stringr'))"

# Conda/Mamba installation
RUN cd tmp
RUN curl https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-x86_64.sh --output miniconda.sh
RUN bash miniconda.sh -bu
ENV PATH="/root/miniconda3/bin:$PATH"
RUN conda update -y conda

# Install base decona
RUN mkdir /home/github && \
    cd /home/github && \
    git clone https://github.com/Saskia-Oosterbroek/decona.git
RUN sed -i -e "s/\r$//" /home/github/decona/install/install.sh
RUN bash /home/github/decona/install/install.sh
SHELL ["conda", "run", "-n", "decona", "/bin/bash", "-c"]
RUN conda install -c "bioconda/label/cf201901" blast

# Install decona_plus
RUN conda init && \
    conda install -y pandas=1.4.1 && \
    cd /home/github/  && \
    git clone https://github.com/ehill-iolani/decona_plus.git  && \
    cd decona_plus && \
    cp blast_processing.R decona decona_local_blast decona_pro decona_pro.R decona_remote_blast decona_remote_pro /bin && \
    chmod 755 /bin/decona /bin/decona_local_blast /bin/decona_pro /bin/decona_pro.R /bin/decona_remote_blast /bin/decona_remote_pro /bin/blast_processing.R && \
    echo "conda activate decona" >> ~/.bashrc && \
    mkdir /home/data

# Clean up installation
RUN rm miniconda.sh
