FROM debian:buster

EXPOSE 5000-5001

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    php7.3 \
    php7.3-gd \
    php7.3-mysql \
    php7.3-curl \
    php7.3-mbstring \
    libapache2-mod-php7.3

# Copy setup script and Wuhu files
COPY setup.sh /setup.sh
COPY www_admin /var/www/www_admin
COPY www_party /var/www/www_party

# Run setup script (confiure apache etc.)
RUN bash /setup.sh

CMD chown -R www-data:www-data /var/www/* && apachectl -D FOREGROUND
