FROM centos:latest
MAINTAINER arthurkiller "arthur-lee@qq.com"
# this docker file is used to try building a work environment

RUN sed -i "s/^tsflags=nodocs//" /etc/yum.conf
RUN rpm -ivh http://fr2.rpmfind.net/linux/dag/redhat/el6/en/x86_64/dag/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

# Install development tools
RUN yum groupinstall -y "Development Tools" && yum install -y cmake

# Install fishshell
RUN curl -L http://download.opensuse.org/repositories/shells:fish:release:2/CentOS_7/shells:fish:release:2.repo \
    -o /etc/yum.repos.d/shells:fish:release:2.repo \
        && yum install -y fish \
            && chsh -s /usr/bin/fish root

RUN yum install -y man man-pages \
        build-essential vim sudo unzip libtool \
        autotools-dev automake autoconf \
        curl tar locales wget python python-dev libxml2-dev libxslt-dev \
        git gcc tmux golang \
        openssh-server apt-transport-https ca-certificates

RUN cd /root && git clone https://github.com/arthurkiller/VIMrc.git \
    && cd /root/VIMrc/ && yum install -y python-devel && ./install

#set the time && add alias into profile
RUN echo 'alias ll="ls -lah --color=auto"' >> /etc/profile
RUN echo "Asia/shanghai" > /etc/timezone
RUN cp /usr/share/zoneinfo/PRC /etc/localtime

# I have used others dockerfile and do not know what will take place
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN mkdir /var/run/sshd

RUN yum install -y openssh-server \
    && sed -i "s/^#PermitRootLogin yes/PermitRootLogin yes/" /etc/ssh/sshd_config \
        && ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key

# Set root password to 'toor'
RUN echo arthur | passwd root --stdin

# Install the_silver_searcher. It is an awesome code-searching tool similar to ack, but faster
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

ENV LC_ALL en_US.utf8

RUN git config --global alias.list "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
RUN git config --global user.email "arthur-lee@qq.com"
RUN git config --global user.name "arthur"

EXPOSE 22

#start the sshd server
CMD ["/usr/sbin/sshd", "-D"]
