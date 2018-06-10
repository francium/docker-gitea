EXPOSE 22 3000

RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    gettext \
    git \
    linux-pam \
    openssh \
    s6 \
    sqlite \
    su-exec \
    tzdata

RUN addgroup \
    -S -g 1000 \
    git && \
  adduser \
    -S -H -D \
    -h /data/git \
    -s /bin/bash \
    -u 1000 \
    -G git \
    git && \
  echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd

RUN git clone --depth=1 https://github.com/go-gitea/gitea && \
    cp -r gitea/docker/* / && \
    rm -rf gitea

RUN apk update \
    && apk add ca-certificates wget \
    && update-ca-certificates

RUN wget https://dl.gitea.io/gitea/1.4.1/gitea-1.4.1-linux-arm-7 && \
    sha256sum gitea-1.4.1-linux-arm-7 > downloaded.sha256
RUN wget https://dl.gitea.io/gitea/1.4.1/gitea-1.4.1-linux-arm-7.sha256

RUN ls -lh

# Verify the checksum
RUN echo "Validating checksum" && \
    cmp downloaded.sha256 gitea-1.4.1-linux-arm-7.sha256

RUN mkdir -p /app/gitea && \
    mv /gitea-1.4.1-linux-arm-7 /app/gitea/gitea && \
    rm downloaded.sha256 gitea-1.4.1-linux-arm-7.sha256

RUN chmod +x /app/gitea/gitea

ENV USER git
ENV GITEA_CUSTOM /data/gitea

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]
