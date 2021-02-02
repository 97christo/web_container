FROM ubuntu:20.04

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Install apache2

RUN apt-get update && apt-get -y install apt-utils && apt-get -y install apache2

# This removes the warning
RUN echo 'ServerName web-server' >> /etc/apache2/apache2.conf

# enable apache modules
RUN a2enmod proxy && a2enmod proxy_http

#
RUN touch /etc/apache2/sites-available/login-site.conf

RUN \
echo '<VirtualHost *:80>' >> /etc/apache2/sites-available/login-site.conf && \
echo 'ServerName example.com' >> /etc/apache2/sites-available/login-site.conf && \
echo 'ServerAlias www.example.com' >> /etc/apache2/sites-available/login-site.conf && \
echo 'ServerAdmin webmaster@example.com' >> /etc/apache2/sites-available/login-site.conf && \
echo 'DocumentRoot /var/www/login_app' >> /etc/apache2/sites-available/login-site.conf && \
echo 'ErrorLog ${APACHE_LOG_DIR}/error.log' >> /etc/apache2/sites-available/login-site.conf && \
echo 'CustomLog ${APACHE_LOG_DIR}/access.log combined' >> /etc/apache2/sites-available/login-site.conf && \
echo 'ProxyRequests Off' >> /etc/apache2/sites-available/login-site.conf && \
echo '<Proxy >' >> /etc/apache2/sites-available/login-site.conf && \
echo 'Order deny,allow' >> /etc/apache2/sites-available/login-site.conf && \
echo 'Allow from all' >> /etc/apache2/sites-available/login-site.conf && \
echo '</Proxy>' >> /etc/apache2/sites-available/login-site.conf && \
echo 'ProxyPass /login_app http://3.36.76.201:8080/login_app/' >> /etc/apache2/sites-available/login-site.conf && \
echo 'ProxyPassReverse /login_app http://3.36.76.201:8080/login_app/' >> /etc/apache2/sites-available/login-site.conf && \
echo '<Location /login_app>' >> /etc/apache2/sites-available/login-site.conf && \
echo 'Order allow,deny' >> /etc/apache2/sites-available/login-site.conf && \
echo 'Allow from all' >> /etc/apache2/sites-available/login-site.conf && \
echo '</Location>' >> /etc/apache2/sites-available/login-site.conf && \
echo '</VirtualHost>' >> /etc/apache2/sites-available/login-site.conf
  
RUN mkdir /var/www/login_app

RUN touch /var/www/login_app/index.html

RUN echo '<!DOCTYPE html>' >> /var/www/login_app/index.html && \
echo '<html>' >> /var/www/login_app/index.html && \
echo '<head>' >> /var/www/login_app/index.html && \
echo '<meta charset="UTF-8">' >> /var/www/login_app/index.html && \
echo '<title>로그인 (Web)</title>' >> /var/www/login_app/index.html && \
echo '</head>' >> /var/www/login_app/index.html && \
echo '<body>' >> /var/www/login_app/index.html && \
echo '<h1>로그인 화면 (Web)</h1>' >> /var/www/login_app/index.html && \
echo '<form action="login_app/login" method="post">' >> /var/www/login_app/index.html && \
echo '<input type="text" name="id" style="width: 100px;">' >> /var/www/login_app/index.html && \
echo '<input type="password" name="pw" style="width: 100px;">' >> /var/www/login_app/index.html && \
echo '<input type="submit" name="btn_sign_in" value="Sign In">' >> /var/www/login_app/index.html && \
echo '</form>' >> /var/www/login_app/index.html && \
echo '</body>' >> /var/www/login_app/index.html && \
echo '</html>' >> /var/www/login_app/index.html

RUN a2ensite login-site.conf
RUN a2dissite 000-default.conf


# port for apache server
EXPOSE 80

# start apache on image start
CMD ["/usr/sbin/apache2ctl","-DFOREGROUND"]



