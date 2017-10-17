# docker-php-builtin-server

Built image:
<code>docker build -t php-builtin-server:latest https://github.com/pawelkorus/docker-php-builtin-server.git</code>

Run container:
<code>
docker run -e "LOCAL_USER_ID=1000" -v /root/.wordpress:/root-dir -d -p 127.0.0.1:8000:8000 php-builtin-server:latest
</code>