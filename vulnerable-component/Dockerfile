FROM node:lts-jessie

# Create app directory
WORKDIR /root/app

COPY package.json .
RUN npm install

COPY . .

EXPOSE 3000
ENTRYPOINT ["npm", "start"]
