FROM linuxserver/code-server

# apt-get install
RUN apt-get update
RUN apt-get install -y -q python3 python3-pip
RUN apt-get clean

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

USER root
COPY /root /
EXPOSE 8443