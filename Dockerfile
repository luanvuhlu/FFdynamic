FROM jrottenberg/ffmpeg:4.0-ubuntu

RUN apt update -y
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
####################################################
# build protobuf 3
RUN  \
	apt-get install -y pkg-config libgoogle-glog-dev libboost-all-dev
RUN  \
	apt-get install autoconf automake libtool curl make cmake g++ unzip git -y && \
       DIR=$(mktemp -d) && cd ${DIR}
RUN  \
        git clone https://github.com/protocolbuffers/protobuf.git && cd protobuf && \
        git submodule update --init --recursive && ./autogen.sh && ./configure && \
	make && make check && make install && ldconfig
#################
# build FFdynamic
RUN  \
        git clone https://github.com/luanvuhlu/FFdynamic.git && cd FFdynamic && \
        cd apps/interactiveLive && ./build.sh
RUN mkdir /opt/ialService
RUN cp FFdynamic/apps/interactiveLive/build/ialService /opt/ialService/
RUN cp FFdynamic/apps/interactiveLive/ialConfig.json /opt/ialService/
WORKDIR /opt/ialService
#ENTRYPOINT "/bin/bash"
#CMD ["./ialService", "ialConfig.json"]
EXPOSE 8080
ENTRYPOINT ["./ialService", "ialConfig.json"]
