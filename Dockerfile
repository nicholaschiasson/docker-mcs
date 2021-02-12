FROM alpine:3

RUN apk update \
	&& apk add \
		bash \
		curl \
		openjdk8

WORKDIR /usr/local/share/java

RUN curl -L https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar -o mcs

WORKDIR /root

RUN echo "eula=true" > eula.txt

ENTRYPOINT cp /etc/mcs/server.properties server.properties \
	&& java -Xmx1024M -Xms1024M -jar /usr/local/share/java/mcs --nogui --universe /run/mcs
