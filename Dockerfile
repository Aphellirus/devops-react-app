FROM node:12.1-alpine

WORKDIR /usr/src/app
COPY package*.json ./
COPY . ./
EXPOSE 3000
CMD ["yarn", "start"]
