FROM ubuntu:22.04 
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    nginx \
    software-properties-common \
    openssh-server \
    php-fpm
CMD service ssh start  && service nginx start && service php8.1-fpm start && exec sh -c 'while true ;do wait ;done';
