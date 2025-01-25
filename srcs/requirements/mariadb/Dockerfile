FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY ./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/

COPY ./tools/init_mariadb.sh /init_mariadb.sh

#EXPOSE 3306

RUN chmod +x /init_mariadb.sh

CMD [ "/init_mariadb.sh"]
