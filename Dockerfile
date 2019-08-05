FROM meelis82/base-debian-bionic-for-docker:latest

MAINTAINER Meelis Valgeväli <meelis82@gmail.com>

LABEL vendor=adm.ee

ENV TERM xterm

ADD ./src /src

RUN /src/entrypoint.sh build

EXPOSE 9000

ENTRYPOINT ["/src/entrypoint.sh", "run"]
