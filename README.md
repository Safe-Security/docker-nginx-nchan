# Nchan Docker Image

A dockerized Nginx image with Nchan module added

Nchan Documentation at: [Nchan.io](https://nchan.io/)

## Usage

- Create the required routes configured as publisher an subscribers. Refer to [nchan-example.conf](./nchan-example.conf)

```nginxconf
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    location /publish {
        nchan_publisher;
        
        nchan_channel_id example;
        nchan_message_buffer_length 2000;
    }

    location /subscribe {
        nchan_subscriber;

        nchan_channel_id example;
        nchan_subscriber_timeout 30;
    }

}
```

- Build the image copying the configuration file(s)

```docker
FROM safesecurity/nginx-nchan:latest

RUN rm -f /etc/nginx/conf.d/default.conf

COPY nchan-example.conf /etc/nginx/conf.d/
```

- Build the image

`docker build -t my-nginx-image:latest .`

- Run the image using

`docker run -d --name rsyslog -p 80:80 my-nginx-image:latest`

- Publishing a message

```shell
$ curl -d "hello=1" http://localhost/publish
queued messages: 1
last requested: -1 sec. ago
active subscribers: 0
last message id: 1627379093:0
```

- Subscribing the message

```shell
$ curl http://localhost/subscribe  
hello=1
```
