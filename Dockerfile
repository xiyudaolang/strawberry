# Install Centos 7
FROM centos:7
MAINTAINER xiyudaolang "993970196@qq.com"
# this docker file is used to try building a work environment

# Install fishshell
RUN curl -L http://download.opensuse.org/repositories/shells:fish:release:2/CentOS_7/shells:fish:release:2.repo \
    -o /etc/yum.repos.d/shells:fish:release:2.repo \
    && yum install -y fish \
    && chsh -s /usr/bin/fish root

# Install dependences
RUN yum install -y man man-pages cmake make \
        build-essential vim sudo unzip libtool \
        autotools-dev automake autoconf \
        curl tar locales wget python python-dev libxml2-dev libxslt-dev \
        git gcc tmux openssh-server\
        openssh-server apt-transport-https ca-certificates

# Install golang from source
RUN curl -s -o go.tar.gz https://dl.google.com/go/go1.12.14.linux-amd64.tar.gz
RUN tar --remove-files -C /usr/local/ -zxf go.tar.gz
RUN ln -sv /usr/local/go/bin/go /usr/bin

# Install SSHD
RUN sed -i "s/^#PermitRootLogin yes/PermitRootLogin yes/" /etc/ssh/sshd_config \
    && ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN mkdir /var/run/sshd
RUN git config --global alias.list "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN cd /root && git clone https://github.com/xiyudaolang/vimrc.git && cd vimrc && make install &
RUN git clone https://github.com/tony/tmux-config.git ~/.tmux && ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN echo "export VISIBLE=now" >> /etc/profile

# Set root password to 'xiyudaolang'
RUN echo xiyudaolang | passwd root --stdin

# Configure golang environment
RUN mkdir /root/golang && mkdir /root/golang/src && mkdir /root/golang/bin
RUN mkdir /root/.config && mkdir /root/.config/fish && touch /root/.config/fish/config.fish
ENV GOPATH=/root/golang
RUN echo "set -x GOPATH $HOME/golang" >> /root/.config/fish/config.fish
RUN echo "set -x PATH $GOPATH/bin $PATH" >> c

#set the time && add alias into profile
ENV LC_ALL en_US.utf8
RUN echo 'alias ll="ls -lah --color=auto"' >> /etc/profile
RUN echo "Asia/shanghai" > /etc/timezone
RUN cp /usr/share/zoneinfo/PRC /etc/localtime

EXPOSE 22

#start the sshd server
CMD ["/usr/sbin/sshd", "-D"]
