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
COPY --chown=gitpod:gitpod /root/config/.bashrc /home/gitpod/.bashrc.d/999-datastax
#COPY --chown=gitpod:gitpod /root/config/extensions/gabrielgrinberg.auto-run-command-1.5.0 /home/gitpod/.gitpod-code/extensions/
#COPY --chown=gitpod:gitpod /root/config/extensions/auchenberg.vscode-browser-preview-0.7.1 /home/gitpod/.gitpod-code/extensions/
COPY --chown=gitpod:gitpod /root/config/extensions/vsls-contrib.codetour-0.0.58 /home/gitpod/.gitpod-code/extensions/

USER gitpod

# Pull in repo
RUN git clone https://github.com/synedra/appdev-week2-tiktok /workspace/tik-tok-full

RUN pip3 install httpie-astra

EXPOSE 8888
EXPOSE 8443
EXPOSE 3000
