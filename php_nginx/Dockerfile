FROM million12/nginx:latest
MAINTAINER Tushar Kant <tushar91delete@gmail.com>

# Setup gosu for easier command execution
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm -f /usr/local/bin/gosu.asc \
    && rm -rf /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

# Install yum-utils (provides yum-config-manager) + some basic web-related tools...
RUN \
  rpm --rebuilddb && yum update -y && \
  yum install -y yum-utils wget patch mysql tar bzip2 unzip openssh-clients rsync telnet vim

# Install PHP 5.6
RUN \
  rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
  yum-config-manager -q --enable remi && \
  yum-config-manager -q --enable remi-php56 && \
  yum install -y php-fpm php-bcmath php-cli php-gd php-intl php-mbstring \
                 php-xml php-mbstring php-pecl-imagick php-mcrypt php-mysql php-opcache php-pdo && \
  yum install -y --disablerepo=epel php-pecl-redis php-pecl-yaml && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
  chown www /usr/local/bin/composer

# Install libs required to build some gem/npm packages (e.g. PhantomJS requires zlib-devel, libpng-devel)
RUN \
  yum install -y ImageMagick GraphicsMagick gcc gcc-c++ libffi-devel libpng-devel zlib-devel

# Install common tools needed/useful during Web App development
# Install ffmpeg
RUN \
  rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && \
  rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm && \
  yum install ffmpeg ffmpeg-devel -y

RUN yum clean all

# Disable SSH strict host key checking: needed to access git via SSH in non-interactive mode
RUN \
  echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ADD container-files/config/install* /config/

# Install/compile other software (Git, NodeJS)
RUN source /config/install.sh

# Define mountable directories.
# This is where you sync your code!
VOLUME ["/data/www/default"]

ADD container-files /

# COPY container-files/entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]
# CMD ["supervisorctl","reload"]

ENV STATUS_PAGE_ALLOWED_IP=127.0.0.1
