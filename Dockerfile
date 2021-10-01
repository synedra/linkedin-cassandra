FROM gitpod/workspace-full

USER root

RUN set -ex; \
	apt-get update; \
    apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
        chromium-chromedriver \
        vim \
        python3

RUN apt-get clean

RUN curl -L https://deb.nodesource.com/setup_16.x | bash \
    && apt-get update -yq \
	&& apt-get install nodejs
RUN npm install -g astra-setup netlify-cli axios

RUN sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
RUN chown -R gitpod:gitpod /workspace
USER gitpod

# Pull in repo
RUN git clone https://github.com/synedra/appdev-week2-tiktok /workspace/tik-tok-full

RUN pip3 install httpie-astra

