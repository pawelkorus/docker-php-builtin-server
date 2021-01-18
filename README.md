# docker-php-builtin-server

docker container providing php builtin server with mysql, pdo and xdebug modules.

## building
Built image:
<code>docker build -t php-builtin-server:latest https://github.com/pawelkorus/docker-php-builtin-server.git</code>

You may use ```--build-arg PHP_IMAGE=<version>``` to specify base php image version.

## running
If you want to run php builtin server that serves content in current working directory then excute:
<code>
docker run --rm -v "$PWD":/root-dir -d -p 127.0.0.1:8000:8000 php-builtin-server:latest
</code>

You can specify document root for built-in web server using the `docroot` environment parameter.
<code>
docker run --rm -v "$PWD":/root-dir -d -p 127.0.0.1:8000:8000 -e docroot=public_html php-builtin-server:latest
</code>

Use --user option to setup user/group id for php builtin server process
<code>
docker run --rm -v "$PWD":/root-dir -d -p 127.0.0.1:8000:8000 --user $(id -u):$(id -g) php-builtin-server:latest
</code>

## xdebug
PHP in this container is preconfigured with XDebug. This configuration enables "remote connect back mode" (see https://xdebug.org/docs/remote). In this mode XDebug detects 'debugger' ip address from incoming HTTP request headers. It also assumes that 'debugger' is listening on port 9000. With this setup you have few options that allow you to debug your application.

You can use default docker bridge network. In this case you have to use docker bridge host ip address when making HTTP request to php container.

Another options is to use docker host network driver by executing `docker run` command with additional `--net host` parameter. In this case container and host share the same network and 'debugger' port (9000) is visible from php container. You can use any ip address assigned to host when making HTTP request to php container. 
