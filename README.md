# Custom Lighttpd Image
* Runs as www-data user after taking file ownership
* Also includes some useful tools such as htop and nano
* Defines 2 volumes (/etc/lighttpd for the configuration files and the log files and /var/www for the content)
* Runs on port 3000 by default but can be overridden by setting a HTTP_PORT environment variable
* For PHP will use port 9000 by default but can be overridden by setting the PHP_PORT environment variable
* Sets UTC as timezone by default but can be changed by setting the TIMEZONE environment variable