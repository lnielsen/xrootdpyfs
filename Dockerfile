# This file is part of xrootdfs
# Copyright (C) 2015 CERN.
#
# xrootdfs is free software; you can redistribute it and/or modify it under the
# terms of the Revised BSD License; see LICENSE file for more details.
#
# Dockerfile for running XRootDFS tests.
#
# Usage:
#   docker build -t xrootd . && docker run -h xrootdfs -it xrootd

FROM centos:7

# Install xrootd
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

RUN yum install -y xrootd xrootd-server xrootd-client xrootd-client-devel xrootd-python

RUN yum install -y python-pip

RUN adduser --uid 1001 xrootdfs

# Install some prerequisites ahead of `setup.py` in order to profit
# from the docker build cache:
RUN pip install coveralls \
                ipython \
                pep257 \
                pytest \
                pytest-pep8 \
                pytest-cache \
                pytest-cov \
                Sphinx
RUN pip install fs

# Add sources to `code` and work there:
WORKDIR /code
ADD . /code

RUN pip install -e .

RUN chown -R xrootdfs:xrootdfs /code && chmod a+x /code/run-docker.sh && chmod a+x /code/run-tests.sh

USER xrootdfs

RUN mkdir /tmp/xrootdfs && touch /tmp/xrootdfs/test.txt

CMD ["bash", "/code/run-docker.sh"]
