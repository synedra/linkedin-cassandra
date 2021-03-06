FROM gitpod/workspace-full

USER root

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

RUN set -ex; \
	apt-get update; \
    apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
        chromium-chromedriver \
        vim \
        python3 \
        python3-pip \
        curl \
        gh

RUN apt-get clean
RUN curl -L https://deb.nodesource.com/setup_16.x | bash \
    && apt-get update -yq \
	&& apt-get install nodejs
RUN npm install -g netlify-cli axios astra-setup@0.2.12
RUN sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
RUN chmod 777 /usr/lib/node_modules/astra-setup/node_modules/node-jq/bin/jq
RUN mkdir /home/gitpod/.cassandra
RUN chown -R gitpod:gitpod /workspace
RUN chown -R gitpod:gitpod /home/gitpod/.cassandra

COPY --chown=gitpod:gitpod /root/config/.bashrc /home/gitpod/.bashrc.d/999-datastax
USER gitpod
WORKDIR /home/gitpod

RUN rm -rf /home/gitpod/.pyenv
RUN wget https://downloads.datastax.com/enterprise/cqlsh-astra.tar.gz
RUN tar xzf cqlsh-astra.tar.gz

RUN curl https://pyenv.run | bash
RUN pyenv update
RUN pyenv install 3.8.12
RUN pip install cassandra-driver cql six httpie-astra 

EXPOSE 8888
EXPOSE 8443
EXPOSE 3000
