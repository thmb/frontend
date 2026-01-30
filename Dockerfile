# syntax=docker/dockerfile:1

FROM docker.io/node:lts-slim AS libs

ARG HOME=/opt/frontend

WORKDIR ${HOME}

ENV PATH=${HOME}/node_modules/.bin:$PATH

COPY package*.json *config.* ${HOME}/

RUN npm install

FROM libs AS bins

COPY ./src ${HOME}/src

RUN npm run build

FROM docker.io/nginx:stable-alpine-slim AS dist

ARG HOME=/opt/frontend

COPY --from=bins ${HOME}/dist /usr/share/nginx/html