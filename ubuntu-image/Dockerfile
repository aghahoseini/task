FROM ubuntu:22.04 
ARG DEBIAN_FRONTEND=noninteractive


RUN apt-get update && \
    apt-get install -y -q curl gnupg2
RUN curl http://nginx.org/keys/nginx_signing.key | apt-key add -

RUN apt-get update && \
    apt-get install -y -q nginx


RUN apt install software-properties-common -y
RUN apt install sudo 
RUN apt update && apt install openssh-server sudo -y


RUN apt-get install php-fpm -y



#COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

#CMD ["nginx", "-g", "daemon off;"]
#CMD [”/bin/bash”, “-c”, “sudo service ssh start  ;  sudo service nginx start ” ]
CMD service ssh start  && service nginx start && service php8.1-fpm start && exec sh -c 'while true ;do wait ;done';
#sudo service ssh start 
#sudo service ssh status  
#sudo systemctl status ssh  -->System has not been booted with systemd as init system (PID 1). Can't operate
#which sshd
