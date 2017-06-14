# Copyright (C) 2016 PerfectlySoft Inc.
# Copyright (C) 2017 dh Software
# Author: Shao Miller <swiftcode@synthetel.com>
# Author: Dinesh Harjani <dinesharjani@gmail.com>

FROM perfectlysoft/perfectassistant

RUN apt-get update && apt-get install -y \
    libssl-dev \
    uuid-dev \
    libgeoip-dev \
    dh-autoreconf \
    libncursesw5-dev

# Install GoAcess
RUN git clone https://github.com/allinurl/goaccess.git
WORKDIR /goaccess
RUN autoreconf -fiv
RUN ./configure --enable-geoip --enable-utf8
RUN make
RUN make install

# Install our Swift Server
ADD . /PerfectServerTest
WORKDIR /PerfectServerTest
RUN cp goaccess.conf /usr/local/etc/
RUN swift build
RUN chmod +x entrypoint.sh
ENTRYPOINT [ "/PerfectServerTest/entrypoint.sh" ]

# Build release version
#RUN swift build --configuration release
