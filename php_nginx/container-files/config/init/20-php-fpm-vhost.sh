#!/bin/sh

#
# Configure default vhost, if NGINX_GENERATE_DEFAULT_VHOST is set to TRUE
# See README for more info.
#

VHOSTS_DEFAULT_SOURCE_CONF="/config/init/vhost-default.conf"
VHOSTS_DEFAULT_TARGET_CONF="/etc/nginx/hosts.d/default.conf"

echo "========================================================================"
echo "Creating hosting directory &  Fixing permission as per drupal standards"
echo "========================================================================"

cat $VHOSTS_DEFAULT_SOURCE_CONF > $VHOSTS_DEFAULT_TARGET_CONF

drupal_path="/data/www/default"
drupal_user="dawg"
httpd_group="www"
if ! id "$drupal_user" >/dev/null 2>&1; then
  useradd $drupal_user
fi
if [ ! -d "${drupal_path}" ]; then
  mkdir -p "${drupal_path}"
fi

cd $drupal_path
printf "Changing ownership of all contents of "${drupal_path}":\n user => "${drupal_user}" \t group => "${httpd_group}"\n"
chown -R ${drupal_user}:${httpd_group} .

printf "Changing permissions of all directories inside "${drupal_path}" to "rwxr-x---"...\n"
find . -type d -exec chmod u=rwx,g=rx,o= '{}' \;

printf "Changing permissions of all files inside "${drupal_path}" to "rw-r-----"...\n"
find . -type f -exec chmod u=rw,g=r,o= '{}' \;

printf "Changing permissions of "files" directories in "${drupal_path}/sites" to "rwxrwx---"...\n"
cd sites
find . -type d -name files -exec chmod ug=rwx,o= '{}' \;

printf "Changing permissions of all files inside all "files" directories in "${drupal_path}/sites" to "rw-rw----"...\n"
printf "Changing permissions of all directories inside all "files" directories in "${drupal_path}/sites" to "rwxrwx---"...\n"
for x in ./*/files; do
  find ${x} -type d -exec chmod ug=rwx,o= '{}' \;
  find ${x} -type f -exec chmod ug=rw,o= '{}' \;
done
echo "Done setting proper permissions on files and directories"
