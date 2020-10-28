# This file creates a Docker image configured as a dev environment for a Craft CMS website.
#
# Build the image with (replace USER accordingly):
#   docker build --build-arg USER=USER --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t craft-cms-demo .
#   docker build -t craft-cms-demo .
#
# Run a container based on the image:
#   docker run -d --name craft_cms_demo --network host -v ${PWD}:/var/www craft-cms-demo
#
# Connect to the container:
#   docker exec -it craft_cms_demo bash

FROM ubuntu

ARG USER=kevin
ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND=noninteractive

# === Packages ===
RUN apt update && apt install -y \
    git bash-completion tzdata vim curl apache2 php mysql-client \
    php-xdebug php-mysql php-xml php-intl php-curl php-bcmath \
    php-imagick php-mbstring php-soap php-zip

# === Xdebug ===
RUN echo "xdebug.remote_enable=on" >> /etc/php/7.4/mods-available/xdebug.ini
RUN echo "xdebug.remote_autostart=on" >> /etc/php/7.4/mods-available/xdebug.ini

# === Composer ===
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=bin --filename=composer

# === Apache ===
# Enable rewrite module.
RUN a2enmod rewrite

# The inlcuded apache configuration file to points the document root to the
# correct location.
COPY apache_config/000-default.conf /etc/apache2/sites-enabled/000-default.conf

# Set global server name for apache to prevent warning.
RUN echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf

# === User ===
# Set up a non root user with sudo access
RUN groupadd --gid $GID $USER \
    && useradd -s /bin/bash --uid $UID --gid $GID -m $USER \
    # Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER\
    && chmod 0440 /etc/sudoers.d/$USER

# Use the non root user to log in as into the container
USER ${UID}:${GID}

WORKDIR /var/www

# CMD ["sudo", "apachectl", "-X"]
CMD ["sleep", "infinity"]
