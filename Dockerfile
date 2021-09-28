FROM gitpod/workspace-full

USER root
RUN set -ex; \ 
	apt-get update -y; \
    apt-get upgrade -y && \
	curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && \
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
		patch \
		unzip \
		xz-utils \
		zlib1g-dev \
	    tzdata \
        chromium-chromedriver \
        vim \
        python3

RUN apt-get clean
RUN nvm install node

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
RUN mkdir -p /home/gitpod/.gitpod-code/extensions
COPY /root/config/.bashrc /home/gitpod/.bashrc.d/999-datastax
COPY /root/config/extensions/* /home/gitpod/.gitpod-code/extensions
