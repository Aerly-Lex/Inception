FROM debian:bullseye

RUN apt update && apt upgrade && apt install -y nginx openssl

# Create SSL-Certificate
RUN	mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt \
	-keyout /etc/nginx/ssl/inception.key \
	-subj "/C=DE/ST=Baden Wurttemberg/L=Heilbronn/O=42/CN=dscheffn.42.fr"

#dependencies
RUN mkdir -p /var/run/nginx

# Copy NGINX-Configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]