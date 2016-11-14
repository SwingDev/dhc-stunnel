FROM alpine:edge
MAINTAINER Tomek Kopczuk <tkopczuk@gmail.com>

RUN apk --no-cache --update add \
                            bash \
                            gettext \
                            stunnel && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

RUN mkdir -p /var/run/stunnel /var/log/stunnel
RUN chown -R stunnel:stunnel /etc/stunnel /var/run/stunnel /var/log/stunnel

COPY stunnel.conf.template /etc/stunnel

ENV STUNNEL_DEBUG=info \
  STUNNEL_SERVICE_NAME=service1 \
  STUNNEL_SERVICE_VERIFY_LEVEL=4

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

USER stunnel
CMD ["stunnel"]