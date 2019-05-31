FROM alpine:3.9.3

# PACKAGES #####################################################################
RUN apk --no-cache add \
    gawk \
    bash \
    ca-certificates \
    git \
    openssh \
    sqlite \
    wget && \
  update-ca-certificates

# ENV ##########################################################################
ENV GITEA_WORK_DIR=/gitea
ENV USER git

# USER AND GROUPS ##############################################################
RUN \
  addgroup -S git && \
  adduser \
    --system \
    -s /bin/bash \
    -G git \
    -h $GITEA_WORK_DIR \
    git && \
  echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd

# ARGS #########################################################################
ARG ARCH=amd64
ARG VERSION=1.8

# GET BINARY ###################################################################
ENV GITEA_BINARY=gitea-$VERSION-linux-$ARCH
ENV GITEA_DL_URL=https://dl.gitea.io/gitea/$VERSION/$GITEA_BINARY

RUN wget $GITEA_DL_URL $GITEA_DL_URL.sha256

# SHA256 sum is of the form 'HASH filename'. This will purge the filename so we don't
# fail the build if the filename was different for some reason
RUN awk '{ print $1 }' $GITEA_BINARY.sha256 > expected.sha256 && \
    sha256sum $GITEA_BINARY | awk '{ print $1 }' > downloaded.sha256 && \
    echo -ne "Downloaded binary's SHA256\n\t" && \
    cat downloaded.sha256 && \
    echo -ne "Expected SHA256\n\t" && \
    cat expected.sha256

# VERIFY THE CHECKSUM ##########################################################
RUN echo "Validating checksum" && \
    cmp downloaded.sha256 expected.sha256 && \
    rm downloaded.sha256 expected.sha256 $GITEA_BINARY.sha256

# CREATE DIRECTORIES ###########################################################
RUN mkdir -p $GITEA_WORK_DIR $GITEA_WORK_DIR/etc/gitea && \
    chown -R git:git $GITEA_WORK_DIR && \
    chmod -R 750 $GITEA_WORK_DIR && \
    ln -s $GITEA_WORK_DIR/etc/gitea /etc/gitea

# MOVE BINARY ##################################################################
RUN cp $GITEA_BINARY /usr/local/bin/gitea && \
    rm $GITEA_BINARY && \
    chmod +x /usr/local/bin/gitea

# Share directory for accessing backups
RUN mkdir /mount
VOLUME /mount
COPY backup.sh $GITEA_WORK_DIR/backup.sh

USER git

EXPOSE 22 3000

VOLUME $GITEA_WORK_DIR

ENTRYPOINT ["gitea"]
CMD ["web", "-c", "/etc/gitea/app.ini"]
