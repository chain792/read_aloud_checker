FROM node:16.16.0-alpine

ARG WORKDIR

ENV HOME=/${WORKDIR}

WORKDIR ${HOME}

RUN apk update && npm install -g npm

CMD ["npm", "run", "dev"]