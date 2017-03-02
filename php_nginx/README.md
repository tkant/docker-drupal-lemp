# Nginx + PHP-FPM xbillo webserver

#### Things included:

#### Nginx

This image is based on [million12/nginx](https://github.com/million12/docker-nginx) - go there for more details.  
**Default vhost** is configured and served from `/data/www/default`. Add .php file to that location to have it executed with PHP.

#### - PHP-FPM

**PHP 5.6** is up & running for default vhost. As soon as .php file is requested, the request will be redirected to PHP upstream. See [/etc/nginx/conf.d/php-location.conf](container-files/etc/nginx/conf.d/php-location.conf).

File [/etc/nginx/fastcgi_params](container-files/etc/nginx/fastcgi_params) has improved configuration to avoid repeating same config options for each vhost. This config works well with most PHP applications (e.g. Symfony2, TYPO3, Wordpress, Drupal).

Custom PHP.ini directives are inside [/etc/php.d](container-files/etc/php.d/).

#### Directory structure
```
/data/www # meant to contain web content
/data/www/default # root directory for the default vhost
/data/logs/ # Nginx, PHP logs
/data/tmp/php/ # PHP temp directories
```

#### Error logging

PHP errors are forwarded to stderr (by leaving empty value for INI error_log setting) and captured by supervisor. You can see them easily via `docker logs [container]`. In addition, they are captured by parent Nginx worker and logged to `/data/logs/nginx-error.log'. PHP-FPM logs are available in `/data/logs/php-fpm*.log` files. 

##### - pre-defined FastCGI cache for PHP backend

It's not used until specified in location {} context. In your vhost config you can add something like this:  
```
location ~ \.php$ {
    # Your standard directives...
    include               fastcgi_params;
    fastcgi_pass          php-upstream;
    
    # Use the configured cache (adjust fastcgi_cache_valid to your needs):
    fastcgi_cache         APPCACHE;
    fastcgi_cache_valid   60m;
}
```

## Usage

```
sudo docker build . -t rda-local-web
sudo docker run -d -p=80:80 -d -e LOCAL_USER_ID=`id -u $USER` \
 -v /home/dawg/Documents/docker_rda/desiadda:/data/www/default rda_local_web
```


---