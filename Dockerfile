FROM debian:jessie-backports
MAINTAINER Hendrik Adam <hendrik.adam@smail.th-koeln.de>

### SET UP

# BASE wheezy-backports O/S with some helpful tools
RUN echo "deb http://ftp.us.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -qqy install sudo wget lynx telnet nano curl

# OXPATH Dependencies
RUN apt-get -qqy install libasound2-dev libgtk-3-0
RUN apt-get -qqy install libxmuu-dev libxmuu1-dbg libxtst6-dbg libxt6-dbg libxmu6-dbg libxext6-dbg libxmuu1 libxkbfile1-dbg libxt-dev libxmu-dev libxext-dev libxmu6 libxtst6 libxt6 libxext6 libxtst-dev
RUN apt-get -qqy install iceweasel
RUN apt-get -qqy install openjdk-7-jre xvfb

# PYTHON 2.7 for the wrapper
RUN apt-get -qqy install python2.7

# Add oxpath
RUN mkdir /usr/src/oxpath
ADD ./oxpath /usr/src/oxpath
WORKDIR /usr/src/oxpath

# Set the enviroment
ENV DISPLAY=:0

CMD [ "python2.7", "./wrapper.py"]
