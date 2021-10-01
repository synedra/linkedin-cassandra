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

RUN rm -rf /var/lib/apt/lists/*

RUN curl -L https://deb.nodesource.com/setup_16.x | bash \
    && apt-get update -yq \
	&& apt-get install nodejs
RUN npm install -g astra-setup netlify-cli axios

RUN chown -R gitpod:gitpod /usr/lib/node_modules
RUN chmod 777 /usr/bin
RUN sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
RUN chown -R gitpod /workspace
USER gitpod

# Pull in repo
RUN git clone https://github.com/synedra/appdev-week2-tiktok /workspace/tik-tok-full

RUN pip3 install httpie-astra
RUN unset HOME

COPY --chown=gitpod:gitpod /root/config/.bashrc /home/gitpod/.bashrc.d/999-datastax
COPY --chown=gitpod:gitpod /root/config/extensions /home/gitpod/.gitpod-code/extensions
COPY --chown=gitpod:gitpod /root/config/data/User/settings.json /workspace/appsembler-tiktok/.vscode/settings.json

EXPOSE 8888
EXPOSE 8443
EXPOSE 3000