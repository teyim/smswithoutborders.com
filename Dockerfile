# use node alpine as base image
FROM node:14-alpine as base
# install system build dependencies
RUN apk add make
# import work files
WORKDIR /app
COPY . .
# build production files
ARG SWOB_BE_HOST
ARG SWOB_GS_HOST
ARG SWOB_RECAPTCHA_ENABLE
ARG SWOB_RECAPTCHA_SITE_KEY
ARG SWOB_SSL_ENABLE
ARG SWOB_SSL_CRT_FILE
ARG SWOB_SSL_KEY_FILE

RUN export SWOB_BE_HOST=${SWOB_BE_HOST} \
SWOB_GS_HOST=${SWOB_GS_HOST} \
SWOB_RECAPTCHA_ENABLE=${SWOB_RECAPTCHA_ENABLE} \
SWOB_RECAPTCHA_SITE_KEY=${SWOB_RECAPTCHA_SITE_KEY} \
SWOB_SSL_ENABLE=${SWOB_SSL_ENABLE} \
SWOB_SSL_CRT_FILE=${SWOB_SSL_CRT_FILE} \
SWOB_SSL_KEY_FILE=${SWOB_SSL_KEY_FILE} \
SWOB_SSL_ENABLE=${SWOB_SSL_ENABLE} 

RUN make

# base image for apache
FROM httpd:2.4 as apache
WORKDIR /usr/local/apache2

# production build with ssl
FROM apache as production

ARG SWOB_SSL_CRT_FILE
ARG SWOB_SSL_KEY_FILE

# copy custom apache config with ssl enabled
COPY configs/httpd.ssl.conf ./conf/httpd.conf

# copy ssl keys
# COPY ${SWOB_SSL_CRT_FILE} ./conf/server.crt
# COPY ${SWOB_SSL_KEY_FILE} ./conf/server.key
# import built files
COPY --from=base /app/build ./htdocs

EXPOSE 443

# dev build without ssl
FROM apache as development
# copy custom apache config
COPY configs/httpd.conf ./conf/httpd.conf
# import built files
COPY --from=base /app/build ./htdocs

EXPOSE 80


