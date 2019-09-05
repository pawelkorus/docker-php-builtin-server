# docker-php-builtin-server

This docker container is built so that it is possible to define user id for the php process when running container. This way it is easier to exchange files between container and host.

## building
Built image:
<code>docker build -t php-builtin-server:latest https://github.com/pawelkorus/docker-php-builtin-server.git</code>

You may use ```--build-arg PHP_IMAGE=<version>``` to specify base php image version.

## running
<code>
docker run -e "LOCAL_USER_ID=1000" -v "$PWD":/root-dir -d -p 127.0.0.1:8000:8000 php-builtin-server:latest
</code>

## xdebug
PHP in thi container is preconfigured with xdebug. It expects listening xdebug server on port 9093. The key for xdebug session is phpstorm.

XDebug session is not started automatically. You need to enter url with ```XDEBUG_SESSION_START``` parameter, e.g. ```http://127.0.0.1:80000/index.php?XDEBUG_SESSION_START=phpstorm```



