FROM centos:centos8
ADD _output /usr/local/bin
COPY redis-client.py /
RUN dnf install -y python3 \
python3-pip
RUN pip3 install redis
ENTRYPOINT ["/bin/sh"]
