# Copyright (C) 2016 PerfectlySoft Inc.
# Copyright (C) 2017 dh Software
# Author: Shao Miller <swiftcode@synthetel.com>
# Author: Dinesh Harjani <dinesharjani@gmail.com>

FROM perfectlysoft/perfectassistant

RUN apt-get update && apt-get install -y \
    libssl-dev \
    uuid-dev \
    goaccess

ADD . /PerfectServerTest
WORKDIR /PerfectServerTest
RUN swift build
RUN cp goaccess.conf /etc/
#Doesn't work :(
#ENTRYPOINT ["/bin/sh /PerfectServerTest/entrypoint.sh"]

# Build release version
#RUN swift build --configuration release
