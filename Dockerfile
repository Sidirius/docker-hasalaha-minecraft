FROM ubuntu:14.04
MAINTAINER Sven Hartmann <sid@sh87.net>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
RUN dpkg-divert --local --rename --add /sbin/initctl && \
    	ln -s /bin/true /sbin/initctl || true
### Install Java 8 and JNA
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update -y
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y --force-yes oracle-java8-installer
RUN apt-get install -y --force-yes oracle-java8-set-default
VOLUME /mcserver/Hasalaha_Welt
WORKDIR /mcserver/
ADD files/mcserver/ /mcserver/
EXPOSE 25565
EXPOSE 8123
CMD ["java", "-jar", "forge-1.7.10-10.13.2.1291-universal.jar", "nogui"]
