FROM linuxserver/code-server

RUN apt-get update
RUN git clone https://github.com/synedra/appdev-week2-tiktok /config/workspace/tik-tok
ENV SUDO_PASSWORD=password
RUN apt-get install -y -q python3 python3-pip
RUN apt-get clean

# WORKDIR /config/workspace/tik-tok

# chown the node_modules dir so we can install there.
RUN chown -R abc:abc /usr/lib/node_modules/

# Set the abc user, so installed node_modules will have the same 
# owner as the code-server app.
USER abc
RUN npm install -g netlify-cli astra-setup axios

# Install Python stuff.
RUN pip3 install httpie-astra

COPY /root /
EXPOSE 8443