FROM node:18.16.0-alpine

RUN apk add --no-cache tini

ENTRYPOINT ["/sbin/tini", "--"]

RUN apk add --no-cache fortune

RUN mkdir -p /app
WORKDIR /app

COPY package.json /app/
RUN npm --silent install
RUN mkdir /deps && mv node_modules /deps/node_modules

ENV NODE_PATH=/deps/node_modules \
PATH=/deps/node_modules/.bin:$PATH

COPY . /app

RUN chown -R node:node /app /deps
USER node

EXPOSE 3000

CMD ["npm", "start" ]