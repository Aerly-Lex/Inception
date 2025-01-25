FROM debian:bullseye

#RUN apt-get update && apt-get upgrade -y && apt-get install -y php php7.4-fpm php-gd wget php-mysqli
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y php-fpm php-mysqli && \
    apt-get install -y mariadb-client && \
    apt-get install -y wget


RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf && \
	mkdir -p /run/php /var/www /var/log/php	

COPY ./tools/script.sh /usr/local/bin/wordpress_setup.sh

RUN chmod +x /usr/local/bin/wordpress_setup.sh

CMD [ "/usr/local/bin/wordpress_setup.sh" ]