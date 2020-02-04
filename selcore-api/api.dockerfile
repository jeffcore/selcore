# create a file named Dockerfile
FROM node:erbium
# v12.14.1
# https://nodejs.org/en/download/releases/

RUN mkdir -p /src
WORKDIR /src

COPY package.json /src

RUN npm install -g nodemon@2.0.2 --quiet
RUN npm install bson@4.0.3 --quiet

RUN npm install
RUN npm update
COPY . /src

CMD ["npm", "start"]
