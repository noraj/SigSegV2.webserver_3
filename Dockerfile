# Author: noraj

# Official verified image
FROM php:7.3.11-alpine3.10

# date
RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime

# copy files
COPY ./website/ /usr/src/app/

WORKDIR /usr/src/app

## INSTALL ##
# Print out php version for debugging
RUN php --version
# Hide the flag
RUN echo "flag:x:9999:9999:sigsegv{S0_you_4re_4_XXE_m4st3r_t00}:/home/flag:/sbin/nologin" >> /etc/passwd

## BUILD ##

# drop privileges
RUN adduser -s /bin/true -u 1337 -D -H noraj
USER noraj

EXPOSE 9999

CMD php -S 0.0.0.0:9999