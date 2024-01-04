FROM amd64/ubuntu:18.04 AS base

EXPOSE 8788/tcp
EXPOSE 9978/tcp

ENV DEBIAN_FRONTEND=noninteractive

#Add ppa:bitcoin/bitcoin repository so we can install libdb4.8 libdb4.8++
RUN apt-get update && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:bitcoin/bitcoin

#Install runtime dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	bash net-tools libminiupnpc10 \
	libevent-2.1 libevent-pthreads-2.1 \
	libdb4.8 libdb4.8++ \
	libboost-system1.65 libboost-filesystem1.65 libboost-chrono1.65 \
	libboost-program-options1.65 libboost-thread1.65 \
	libzmq5 && \
	apt-get clean

FROM base AS build

#Install build dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	bash net-tools build-essential libtool autotools-dev automake git \
	pkg-config libssl-dev libevent-dev bsdmainutils python3 \
	libboost-system1.65-dev libboost-filesystem1.65-dev libboost-chrono1.65-dev \
	libboost-program-options1.65-dev libboost-test1.65-dev libboost-thread1.65-dev \
	libzmq3-dev libminiupnpc-dev libdb4.8-dev libdb4.8++-dev && \
	apt-get clean


#Build Cl from source
COPY . /home/cl/build/Cl/
WORKDIR /home/cl/build/Cl
RUN ./autogen.sh && ./configure --disable-tests --with-gui=no && make

FROM base AS final

#Add our service account user
RUN useradd -ms /bin/bash cl && \
	mkdir /var/lib/cl && \
	chown cl:cl /var/lib/cl && \
	ln -s /var/lib/cl /home/cl/.cl && \
	chown -h cl:cl /home/cl/.cl

VOLUME /var/lib/cl

#Copy the compiled binaries from the build
COPY --from=build /home/cl/build/Cl/src/cld /usr/local/bin/cld
COPY --from=build /home/cl/build/Cl/src/cl-cli /usr/local/bin/cl-cli

WORKDIR /home/cl
USER cl

CMD /usr/local/bin/cld -datadir=/var/lib/cl -printtoconsole -onlynet=ipv4
