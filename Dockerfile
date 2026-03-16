FROM rdev:base

ARG RUSER

ARG cmake_version=4.2.3

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /opt

RUN wget https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}.tar.gz \
    && tar zxvf cmake-${cmake_version}.tar.gz \
    && cd cmake-${cmake_version} \
    && ./bootstrap \
    && make \
    && make install \
    && cd ../; rm -rf cmake-${cmake_version}*

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm -f get_helm.sh

RUN curl -fsSL https://get.opentofu.org/opentofu.gpg | tee /etc/apt/keyrings/opentofu.gpg >/dev/null \
    && curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null \
    && chmod a+r /etc/apt/keyrings/opentofu.gpg \
    && echo 'deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main \n \
       deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main' | \
       tee /etc/apt/sources.list.d/opentofu.list > /dev/null \
    && apt update \
    && apt-get install -y tofu


RUN apt-get clean \
    && rm -vf /opt/lib*.deb \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY sshd_config /etc/ssh/sshd_config

# gen ssh keys
RUN ssh-keygen -A

# Replace your user id
RUN export uid=1000 \
    && useradd --create-home -u 1000 -s /bin/bash $RUSER \
    && echo "$RUSER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$RUSER \
    && chmod 0440 /etc/sudoers.d/$RUSER

COPY authorized_keys /opt/.

# copy the dependencies file
COPY pip-packages.txt /opt/.

COPY boot.sh /opt/boot.sh
RUN sed -i "s/replace_user/$RUSER/" /opt/boot.sh \
    && chmod +x /opt/boot.sh

# debug output
RUN echo  "debian version:  $(cat /etc/debian_version) \n" \
          "user:            $(whoami) \n"

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/opt/boot.sh"]
