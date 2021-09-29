FROM linuxserver/code-server AS builder

FROM gitpod/workspace-full:latest

USER root
COPY --from=builder /init /init
COPY /root/patch /tmp/patch


# set version for s6 overlay
ARG OVERLAY_VERSION="v2.2.0.3"
ARG OVERLAY_ARCH="amd64"

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}-installer /tmp/
RUN chmod +x /tmp/s6-overlay-${OVERLAY_ARCH}-installer && /tmp/s6-overlay-${OVERLAY_ARCH}-installer / && rm /tmp/s6-overlay-${OVERLAY_ARCH}-installer

# apt-get install


RUN set -ex; \
	apt-get update; \
    apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
		autoconf \
		automake \
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

RUN mkdir -p \
	/app \
    /patch \
    /config \
	/defaults && \
 mv /usr/bin/with-contenv /usr/bin/with-contenvb 

RUN patch -u /etc/s6/init/init-stage2 -i /tmp/patch/etc/s6/init/init-stage2.patch



RUN rm -rf /var/lib/apt/lists/*

# environment settings
#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - &&\
# echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list &&\
RUN npm install -g yarn
RUN  yarn config set network-timeout 600000 -g 
RUN  yarn --verbose global add code-server
RUN  yarn cache clean

RUN dpkg-divert --local --rename --add /sbin/initctl && \
 cp -a \
	/usr/sbin/policy-rc.d \
	/sbin/initctl && \
 sed -i \
	's/^exit.*/exit 0/' \
	/sbin/initctl
  
ENV SUDO_PASSWORD=password

RUN mkdir /usr/lib/node_modules
RUN chown -R gitpod:gitpod /usr/lib/node_modules
RUN chmod 777 /usr/bin
RUN sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

# Pull in repo
RUN git clone https://github.com/synedra/appdev-week2-tiktok /opt/workspace/tik-tok
RUN chown -R gitpod /opt/workspace

USER gitpod
ENV HOME=/opt/workspace
WORKDIR /opt/workspace/tik-tok
RUN npm install -g astra-setup netlify-cli axios
RUN pip3 install httpie-astra
RUN unset HOME
RUN echo "if test -d \"/config/workspace/astra-tik-tok\"" >> /opt/workspace/.bashrc
RUN echo "then" >> /opt/workspace/.bashrc
RUN echo "  cd /config/workspace/astra-tik-tok" >> /opt/workspace/.bashrc
RUN echo "fi" >> /opt/workspace/.bashrc
RUN echo "alias git-remote=\"/bin/bash /config/workspace/resources/git-remote\"" >> /opt/workspace/.bashrc
RUN echo "alias netlify-site=\"/bin/bash /config/workspace/resources/netlify-site\"" >> /opt/workspace/.bashrc