FROM solr:9.2
MAINTAINER dkd Internet Service GmbH <solr-eb-support@dkd.de>
ENV TERM linux

ARG SOLR_UNIX_UID="8983"
ARG SOLR_UNIX_GID="8983"


USER root
RUN rm -fR /opt/solr/server/solr/* \
  && usermod --non-unique --uid "${SOLR_UNIX_UID}" solr \
  && groupmod --non-unique --gid "${SOLR_UNIX_GID}" solr \
  && chown -R solr:solr /var/solr /opt/solr \
  && apt update && apt upgrade -y && apt install sudo -y \
  && echo "solr ALL=NOPASSWD: /docker-entrypoint-initdb.d/as-sudo/*" > /etc/sudoers.d/solr
USER solr

COPY --chown=solr:solr Resources/Private/Solr/ /var/solr/data
RUN mkdir -p /var/solr/data/data
