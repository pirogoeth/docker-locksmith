FROM ubuntu:trusty
MAINTAINER Sean Johnson <pirogoeth@maio.me>

ADD build /build
RUN run-parts --report --exit-on-error /build/parts && rm -rf /build

VOLUME ["/app", "/log"]
EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/bin/bash", "/run.sh"]
