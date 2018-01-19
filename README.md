# docker-php-builtin-server

## building
Built image:
<code>docker build -t php-builtin-server:latest https://github.com/pawelkorus/docker-php-builtin-server.git</code>

## running
<code>
docker run -e "LOCAL_USER_ID=1000" -v "$PWD":/root-dir -d -p 127.0.0.1:8000:8000 php-builtin-server:latest
</code>

## xdebug
PHP in thi container is preconfigured with xdebug. It expects listening xdebug server on port 9093. The key for xdebug session is phpstorm.

XDebug session is not started automatically. You need to enter url with ```XDEBUG_SESSION_START``` parameter, e.g. ```http://127.0.0.1:80000/index.php?XDEBUG_SESSION_START=phpstorm```



