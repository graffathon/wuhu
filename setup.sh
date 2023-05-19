# Most of the stuff is from https://gist.github.com/Gargaj/2a8cb8c015244b6431b9

rm -rf /var/www/html
chmod -R g+rw /var/www
chown -R www-data:www-data /var/www

mv /var/www/www_party/template.html.dist /var/www/www_party/template.html
mkdir /var/www/entries_private
mkdir /var/www/entries_public
mkdir /var/www/screenshots
mkdir /var/www/exports

chmod -R g+rw /var/www/*
chown -R www-data:www-data /var/www/*

# -------------------------------------------------
# set up PHP

for i in /etc/php/7.3/*/php.ini
do
  sed -i -e 's/^upload_max_filesize.*$/upload_max_filesize = 128M/' $i
  sed -i -e 's/^post_max_size.*$/post_max_size = 256M/' $i
  sed -i -e 's/^memory_limit.*$/memory_limit = 512M/' $i
  sed -i -e 's/^session.gc_maxlifetime.*$/session.gc_maxlifetime = 604800/' $i
  sed -i -e 's/^short_open_tag.*$/short_open_tag = On/' $i
done

# -------------------------------------------------
# set up Apache

rm /etc/apache2/sites-enabled/*

echo -e \
  "<VirtualHost *:5000>\n" \
  "\tDocumentRoot /var/www/www_party\n" \
  "\t<Directory />\n" \
  "\t\tOptions FollowSymLinks\n" \
  "\t\tAllowOverride All\n" \
  "\t</Directory>\n" \
  "\tErrorLog \${APACHE_LOG_DIR}/party_error.log\n" \
  "\tCustomLog \${APACHE_LOG_DIR}/party_access.log combined\n" \
  "\t</VirtualHost>\n" \
  "\n" \
  "<VirtualHost *:5001>\n" \
  "\tDocumentRoot /var/www/www_admin\n" \
  "\t<Directory />\n" \
  "\t\tOptions FollowSymLinks\n" \
  "\t\tAllowOverride All\n" \
  "\t</Directory>\n" \
  "\tErrorLog \${APACHE_LOG_DIR}/admin_error.log\n" \
  "\tCustomLog \${APACHE_LOG_DIR}/admin_access.log combined\n" \
  "</VirtualHost>\n" \
  > /etc/apache2/sites-available/wuhu.conf

echo -e \
  "Listen 80\n" \
  "Listen 5000\n" \
  "Listen 5001\n" \
  > /etc/apache2/ports.conf

a2ensite wuhu
