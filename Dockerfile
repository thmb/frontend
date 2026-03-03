# syntax=docker/dockerfile:1

FROM docker.io/node:lts-slim AS libs

ARG HOME=/opt/frontend
WORKDIR ${HOME}

ENV PATH=${HOME}/node_modules/.bin:$PATH

COPY package*.json tsconfig*.json eslint.config.js ${HOME}/
COPY apps/web/package.json ${HOME}/apps/web/package.json
COPY packages/components/package.json ${HOME}/packages/components/package.json

RUN npm install

FROM libs AS bins

COPY apps/web ${HOME}/apps/web
COPY packages/components ${HOME}/packages/components

RUN npm run build

FROM docker.io/nginx:stable-alpine-slim AS dist

COPY --from=bins /opt/frontend/apps/web/dist /usr/share/nginx/html
