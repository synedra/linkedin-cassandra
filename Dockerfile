FROM gitpod/workspace-full:latest

USER root
RUN set -ex; \ 
	apt-get update -y; \
    apt-get upgrade -y && \
	curl -sL https://deb.nodesource.com/setup_16.x | sudo bash - && \
	apt-get install -y --no-install-recommends \
		autoconf \
		automake \
		build-essential \
		bzip2 \
		dpkg-dev \
		file \
		g++ \
		gcc \
		imagemagick \
		libbz2-dev \
		libc6-dev \
		libcurl4-openssl-dev \
		libdb-dev \
		libevent-dev \
		libffi-dev \
		libgdbm-dev \
		libglib2.0-dev \
		libgmp-dev \
		libjpeg-dev \
		libkrb5-dev \
		liblzma-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmaxminddb-dev \
		libncurses5-dev \
		libncursesw5-dev \
		libpng-dev \
		libpq-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libtool \
		libwebp-dev \
		libxml2-dev \
		libxslt-dev \
		libyaml-dev \
		make \
		nodejs \
		patch \
		unzip \
		xz-utils \
		zlib1g-dev \
	    tzdata \
        chromium-chromedriver \
        vim \
        python3

RUN apt-get clean

RUN chown -R gitpod:gitpod /usr/lib/node_modules
RUN chown -R gitpod:gitpod /workspace
RUN git clone https://github.com/synedra/appdev-week2-tiktok /workspace/tik-tok

WORKDIR /workspace/tik-tok

RUN chmod 777 /usr/bin
RUN sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
RUN npm install -g astra-setup netlify-cli axios
RUN pip3 install httpie-astra

# Pull in repo
USER gitpod
WORKDIR /workspace
ENV HOME=/workspace
RUN cp -r /home/gitpod /workspace/gitpod

RUN echo "cd /workspace"> gitpod/.bashrc.d/999-datatax.rc
RUN echo "if test -d \"/workspace/astra-tik-tok\"" >> gitpod/.bashrc.d/999-datatax.rc
RUN echo "then" >> gitpod/.bashrc.d/999-datatax.rc
RUN echo "  cd /workspace/astra-tik-tok" >> gitpod/.bashrc.d/999-datatax.rc
RUN echo "fi" >> gitpod/.bashrc.d/999-datatax.rc
RUN echo "alias git-remote=\"/bin/bash /workspace/resources/git-remote\"" >> gitpod/.bashrc.d/999-datatax.rc
RUN echo "alias netlify-site=\"/bin/bash /workspace/resources/netlify-site\"" >> gitpod/.bashrc.d/999-datatax.rc

