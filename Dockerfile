FROM ubuntu:14.04
MAINTAINER Sven Hartmann <sid@sh87.net>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
RUN dpkg-divert --local --rename --add /sbin/initctl && \
    	ln -s /bin/true /sbin/initctl || true
RUN apt-get update -y && apt-get install -y curl

RUN curl http://repogen.simplylinux.ch/txt/sources_fb53949e40c90614e35484cccf834a33c5811420.txt | tee /etc/apt/sources.list

RUN apt-get update -y && apt-get upgrade -y --force-yes && apt-get dist-upgrade -y --force-yes
RUN apt-get -qq -y install \
	openssh-server screen sudo nano supervisor zip unzip htop bmon git curl mono-complete wget python-pip apt-utils && \
	apt-get clean

RUN pip install speedtest-cli

RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN mkdir -p /var/run/sshd && \
    	echo "root:root" | chpasswd

### Install Java 8 and JNA
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update -y
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y --force-yes oracle-java8-installer
RUN apt-get install -y --force-yes oracle-java8-set-default
RUN mkdir /tmp/jna-4.0.0 && \
	cd /tmp/jna-4.0.0 && \
	wget --no-check-certificate 'https://maven.java.net/content/repositories/releases/net/java/dev/jna/jna/4.0.0/jna-4.0.0.jar' && \
	wget --no-check-certificate 'https://maven.java.net/content/repositories/releases/net/java/dev/jna/jna-platform/4.0.0/jna-platform-4.0.0.jar' && \
	cd /tmp/jna-4.0.0 && \
	cd /usr/share/java && \
	[ -f jna.jar ] && rm jna.jar || \
	cp /tmp/jna-4.0.0/*.jar . && \
	ln -s jna-4.0.0.jar jna.jar && \
	ln -s jna-platform-4.0.0.jar jna-platform.jar && \
	java -jar jna.jar

ADD files/scripts/supervisord.conf /
ADD files/scripts/startup.sh /
ADD files/mcserver/ /mcserver/
EXPOSE 25565
EXPOSE 8123
EXPOSE 22
ENTRYPOINT ["/startup.sh"]
