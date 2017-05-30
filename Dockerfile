# Copyright (C) 2016 PerfectlySoft Inc.
# Copyright (C) 2017 dh Software
# Author: Shao Miller <swiftcode@synthetel.com>
# Author: Dinesh Harjani <dinesharjani@gmail.com>

FROM perfectlysoft/perfectassistant
RUN apt-get update && apt-get install -y \
    libssl-dev \
    uuid-dev \
    libxml2-dev \
    pkg-config
ADD . /PerfectServerTest
WORKDIR /PerfectServerTest
RUN swift build
ENTRYPOINT [".build/debug/PerfectServerTest"]

# Build release version
#RUN swift build --configuration release

# If you wanted to base this off the official Swift docker
#FROM swiftdocker/swift

# Not necessary when using pperfectlysoft/perfectassistant
#RUN /usr/src/Perfect-Ubuntu/install_swift.sh --sure
