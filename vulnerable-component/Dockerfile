FROM node:alpine
LABEL maintainer="Vivek Gite webmater@cyberciti.biz"
RUN apk add --update --no-cache openssh
RUN ssh-keygen -A
RUN mkdir /root/.ssh
RUN chmod 700 -R /root/.ssh

# Create app directory
WORKDIR /root/app

COPY package.json .
RUN npm install
RUN touch flag-{4d8377a8-cc92-4208-bfec-21a0d984d949}.txt

COPY . .

EXPOSE 3000
EXPOSE 22

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
