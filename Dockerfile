FROM linuxserver/code-server

# apt-get install
RUN apt-get update
RUN apt-get install -y -q python3 python3-pip chromium-chromedriver
RUN apt-get clean

ENV SUDO_PASSWORD=password

RUN chown -R abc:abc /usr/lib/node_modules
RUN chmod 777 /usr/bin

# Pull in repo
RUN git clone https://github.com/synedra/appdev-week2-tiktok /opt/workspace/tik-tok
RUN chown -R abc:abc /opt/workspace

USER abc
ENV HOME=/opt/workspace
WORKDIR /opt/workspace/tik-tok
RUN npm install -g astra-setup netlify-cli axios
RUN pip3 install httpie-astra
RUN unset HOME
RUN echo "if test -f \"/config/workspace/astra-tik-tok\"" >> /opt/workspace/.bashrc
RUN echo "then" >> /opt/workspace/.bashrc
RUN echo "  cd /config/workspace/astra-tik-tok" >> /opt/workspace/.bashrc
RUN echo "fi" >> /opt/workspace/.bashrc

USER root
COPY /root /
EXPOSE 8443