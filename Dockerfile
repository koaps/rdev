FROM python:3.9-slim-buster

ARG RUSER=rdev
ARG mongo_url

RUN apt-get update \
 && apt-get install -y locales \
 && dpkg-reconfigure -f noninteractive locales \
 && locale-gen C.UTF-8 \
 && /usr/sbin/update-locale LANG=C.UTF-8 \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /usr/share/man/man1

RUN apt-get update \
    && apt-get install -y \
        bc \
        bison \
        build-essential \
        curl \
        flex \
        gcc \
        git \
        html2text \
        imagemagick \
        jq \
        kmod \
        less \
        libxtst-dev libev-dev libxext-dev libxrender-dev libfreetype6-dev \
        libffi-dev libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
        libgmp-dev libisl-dev libmpfr-dev libmpc-dev libpq-dev libncurses5-dev \
        libncurses-dev libssl-dev \
        lilypond \
        man \
        neovim \
        openssh-client openssh-server \
        python3 python3-pip python3-setuptools \
        rsync \
        software-properties-common \
        sudo \
        timidity timidity-daemon \
        tini \
        tk \
        tmux \
        unzip \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY sshd_config /etc/ssh/sshd_config
COPY vimrc /etc/vim/vimrc.tiny

# NPM
WORKDIR /root
COPY setup_ndodejs_16.x.sh .
RUN /bin/bash setup_ndodejs_16.x.sh \
    && apt-get update

# gen ssh keys
RUN ssh-keygen -A && mkdir /run/sshd

# Replace your user id
RUN export uid=1000 \
    && useradd --create-home -u 1000 -s /bin/bash $RUSER \
    && echo "$RUSER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$RUSER \
    && chmod 0440 /etc/sudoers.d/$RUSER

# custom env vars
RUN echo "export MONGO_URL=$mongo_url" >/etc/profile.d/mongo.sh

# use local pip repo
COPY pip.conf /etc/.

# copy the dependencies file
COPY npm-packages.txt /opt/.
COPY pip-packages.txt /opt/.

COPY boot.sh /opt/boot.sh
RUN chmod +x /opt/boot.sh

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/opt/boot.sh"]
