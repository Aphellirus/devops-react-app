# devops-react-app

A project made with [React](https://reactjs.org/) and [Docker](https://www.docker.com/).


## Prerequisites

Here are the prerequisites required for this project: 
- [React](https://reactjs.org/)
- [Docker](https://www.docker.com/)

## Creating the app

To start, we can use the officially supported [create-react-app.dev](https://create-react-app.dev/docs/getting-started/) to create a single-page React application with no configuration.

- Install create-react-app
```bash
npm install -g create-react-app
```
- Quick Start
```bash
npx create-react-app my-app && cd my-app
npm start
```

## Dockerize the React app.
First step is to add a Dockerfile to the project root:
```docker
FROM node:13.1-alpine

WORKDIR /usr/src/app
COPY package*.json ./
RUN yarn cache clean && yarn --update-checksums
COPY . ./
EXPOSE 3000
CMD ["yarn", "start"]

```
> `yarn cache clean` running this command will clear the global cache.
> `yarn --update-checksums` lock lockfile if there's a mismatch between them and their package's checksum. Both are optional, cleaning cache won't break the docker process, but both can cause some issues during the build process tho, so delete both lines if you run into any.

Now we can build and tag our docker image
```bash
docker build -t my-app:dev .
```
Run the container once the build is done
```bash
docker run -it -p 3000:3000 my-app:dev 
```

And voilá! The react app is now running on [http://localhost:3000](http://localhost:3000/)

To make it easier, we can create a Dockerfile-prod to the project root. We will use this file in production. 

*Dockerfile-prod:*
```docker
FROM node:13.1-alpine as build

WORKDIR /usr/src/app
COPY package*.json ./
RUN yarn cache clean && yarn --update-checksums
COPY . ./
RUN yarn && yarn build

# Stage - Production
FROM nginx:1.17-alpine
COPY --from=build /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
> In this *Dockerfile-prod* we create a production build for our app and then copy the build file to nginx html directory.

To finish it up, we'll build and run our production image in port 80 with the help of nginx.
```bash
docker build -f Dockerfile-prod -t my-app:prod .
```
```bash
docker run -itd -p 80:80 --rm my-app:prod
```
> And the app is now running on port 80.
