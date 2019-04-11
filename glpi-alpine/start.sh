#!/bin/ash

GLPI_DIR="/usr/share/webapps/glpi"
GLPIVERSION="9.4.2"

### INSTALL GLPI IF NOT INSTALLED ALREADY ######################################

if [ "$(ls -A ${GLPI_DIR})" ]; then
  echo "GLPI is already installed at ${GLPI_DIR}"
else
  echo '-----------> Install GLPI'
  echo "Using ${GLPIVERSION}"
  mkdir -p /usr/share/webapps/
  cd /usr/share/webapps/
  wget https://github.com/glpi-project/glpi/releases/download/${GLPIVERSION}/glpi-${GLPIVERSION}.tgz
  tar zxvf glpi-${GLPIVERSION}.tgz
  rm glpi-${GLPIVERSION}.tgz  
  sed -i 's/^.*mod_fastcgi.conf.*$/include "mod_fastcgi.conf"/' /etc/lighttpd/lighttpd.conf
  sed -i -e 's|/usr/bin/php-cgi|/usr/bin/php-cgi7|g' /etc/lighttpd/mod_fastcgi.conf  
  sed -i 's|"/run/lighttpd/lighttpd-fastcgi-php-" + PID + ".socket"|"/tmp/php-fastcgi.socket"|' /etc/lighttpd/mod_fastcgi.conf
  chown -R lighttpd:lighttpd /usr/share/webapps/glpi  
  chown -R lighttpd:lighttpd /var/log/lighttpd
  chmod -R 755 /usr/share/webapps/glpi/  
  rm -R /var/www/localhost/htdocs
  ln -s /usr/share/webapps/glpi /var/www/localhost/htdocs
  (crontab -l && echo "*       *       *       *       *       /usr/bin/php7 /usr/share/webapps/glpi/front/cron.php &>/dev/null") | crontab -
fi

tail -F /var/log/lighttpd/access.log 2>/dev/null &
tail -F /var/log/lighttpd/error.log 2>/dev/null 1>&2 &
lighttpd -D -f /etc/lighttpd/lighttpd.conf && tail -f /var/log/lighttpd/error.log
