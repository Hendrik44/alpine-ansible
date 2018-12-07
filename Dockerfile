FROM alpine:3.8

ENV ANSIBLE_VERSION 2.7.4
ENV ANSIBLE_LINT 3.5.1
ENV DOCKER_PY_VERSION 1.10.6

RUN apk add --update python py-pip openssl ca-certificates bash git sudo zip \
    && apk --update add --virtual build-dependencies python-dev libffi-dev openssl-dev build-base \
    && pip install --upgrade pip cffi \
    && echo "Installing Ansible..." \
    && pip install ansible==$ANSIBLE_VERSION ansible-lint==$ANSIBLE_LINT docker-py==$DOCKER_PY_VERSION \
    && pip install --upgrade pycrypto pywinrm  \
    && apk --update add sshpass openssh-client rsync \
    && echo "Removing package list..." \
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* \

RUN echo "Adding hosts for convenience..." \
    && mkdir -p /etc/ansible \
    && echo 'localhost' > /etc/ansible/hosts

RUN addgroup -S myusergroup && adduser -S myuser -G myusergroup
USER myuser

WORKDIR /home/myuser

CMD [ "ansible-playbook", "--version" ]