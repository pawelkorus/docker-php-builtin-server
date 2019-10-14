# docker-php-builtin-server

This docker container is built so that it is possible to define user id for the php process when running container. This way it is easier to exchange files between container and host.

## building
Built image:
<code>docker build -t php-builtin-server:latest https://github.com/pawelkorus/docker-php-builtin-server.git</code>

You may use ```--build-arg PHP_IMAGE=<version>``` to specify base php image version.

## running
If you want to run php builtin server that serves content in current working directory then excute:
<code>
docker run --rm -v "$PWD":/root-dir -d -p 127.0.0.1:8000:8000 php-builtin-server:latest
</code>

Use --user option to setup user/group id for php builtin server process
<code>
docker run --rm -v "$PWD":/root-dir -d -p 127.0.0.1:8000:8000 --user $(id -u):$(id -g) php-builtin-server:latest
</code>

## xdebug
PHP in this container is preconfigured with xdebug. It expects listening xdebug server on port 9093. The key for xdebug session is phpstorm.

XDebug session is not started automatically. You need to enter url with ```XDEBUG_SESSION_START``` parameter, e.g. ```http://127.0.0.1:80000/index.php?XDEBUG_SESSION_START=phpstorm```



