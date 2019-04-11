FROM debian:stable-slim
LABEL maintainer "OpenSea Tecnologia u.nu/opn CREDITS TO Gustavo Lichti <gustavo.lichti@gmail.com>"

ADD https://raw.githubusercontent.com/openseatecnologia/dockerfiles/master/warsaw-debian/locale.gen /etc/locale.gen
ADD https://raw.githubusercontent.com/openseatecnologia/dockerfiles/master/warsaw-debian/local.conf /etc/fonts/local.conf
ADD https://cloud.gastecnologia.com.br/bb/downloads/ws/warsaw_setup64.deb /warsaw_setup64.deb

ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
&& apt install -qqy \
locales \
python2.7 \
libpython2.7-minimal \
libpython2.7-stdlib \
python-openssl \
zenity \
libgtk2.0-0 \
ssh \
x11-utils \
x11-apps \
openssl \
libcurl3 \
libnss3-tools \
apt-transport-https \
ca-certificates \
sudo \
gnupg \
hicolor-icon-theme \
libgl1-mesa-dri \
libgl1-mesa-glx \
libpango1.0-0 \
libpulse0 \
libv4l-0 \
fonts-symbola \
xauth \
firefox-esr \
--no-install-recommends

RUN apt clean \
&& locale-gen pt_BR.UTF-8 \
&& dpkg-reconfigure locales \
&& update-locale LANG=pt_BR.UTF-8 \
&& rm -rf /var/lib/apt/lists/* \
&& groupadd -g 1000 -r bank \
&& useradd -u 1000 -r -g bank -G audio,video,ssh bank \
&& mkdir -p /home/bank/.ssh \
&& chown -R bank:bank /home/bank \
&& echo "bank ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
&& chmod 0440 /etc/sudoers \
&& passwd -d root \
&& mkdir /var/run/sshd \
&& sudo ssh-keygen -A \
&& sed -i "s/^.*PasswordAuthentication.*$/PasswordAuthentication yes/" /etc/ssh/sshd_config \
&& sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
&& sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
&& grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
&& echo "AllowUsers bank" >> /etc/ssh/sshd_config \
&& echo "bank:teste" | chpasswd

RUN sudo dpkg -i /warsaw_setup64.deb

USER bank
ENV HOME /home/bank

ENTRYPOINT ["sh", "-c", "sudo /etc/init.d/ssh start ; sudo /etc/init.d/warsaw start && tail -f /dev/null"]
