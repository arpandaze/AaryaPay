FROM docker.io/library/nginx:1.20-alpine

COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /profile

RUN mkdir -p /static

COPY ./static/logo.svg /static/logo.svg

EXPOSE 80
