FROM ubuntu:15.04
MAINTAINER fdeguilhen@gmail.com

ENV PATH $PATH:/home/go/bin
ENV GOPATH /home/go
ENV MOUNTDIR /opt/dv

# All the installation here
# Reducing the image size with --no-install-recommends and rm /var/lib/apt/lists
RUN apt-get update && \
	apt-get install -y --no-install-recommends ca-certificates golang git python mediainfo exiftool && \
	rm -rf /var/lib/apt/lists

# Installation of siegfried 
# RUN apt-get install -y golang git
RUN mkdir /home/go ;\
	go get github.com/richardlehane/siegfried/cmd/sf ;\
	sf -update 

# Installation of Fido
# RUN apt-get install -y python
RUN mkdir /home/fido
ADD fido /home/fido
RUN chmod +x /home/fido/fido.py

# Installation of mediainfo & exiftool
# RUN apt-get install -y mediainfo exiftool
RUN locale-gen fr_FR.UTF-8

# Add and Compile code inspectFile
ADD inspectfile /home/go/src/inspectfile
RUN go build -o /home/go/bin/inspectFile /home/go/src/inspectfile/*.go

#Add HTML file
ADD demo /home/demo

EXPOSE 8080


CMD ["inspectFile","--server","0.0.0.0:8080"]

