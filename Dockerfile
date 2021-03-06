# https://github.com/sonatype/docker-nexus3
FROM sonatype/nexus3

ENV SONATYPE_DIR="/opt/sonatype"
ENV NEXUS_VERSION="3.22.1" \
    NEXUS_HOME="${SONATYPE_DIR}/nexus" \
    NEXUS_DATA="/nexus-data" \
    SONATYPE_WORK=${SONATYPE_DIR}/sonatype-work \
    JAVA_MIN_MEM="1200M" \
    JAVA_MAX_MEM="1200M" \
    JKS_PASSWORD="changeit"

ENV NEXUS_PLUGINS ${NEXUS_HOME}/system

# https://github.com/flytreeleft/nexus3-keycloak-plugin
ENV KEYCLOAK_PLUGIN_VERSION 0.4.0-SNAPSHOT
ENV KEYCLOAK_PLUGIN_RELEASE 0.4.0-prev2-SNAPSHOT
ENV KEYCLOAK_PLUGIN /org/github/flytreeleft/nexus3-keycloak-plugin/${KEYCLOAK_PLUGIN_RELEASE}/nexus3-keycloak-plugin-${KEYCLOAK_PLUGIN_VERSION}

USER root

ADD https://github.com/flytreeleft/nexus3-keycloak-plugin/releases/download/${KEYCLOAK_PLUGIN_RELEASE}/nexus3-keycloak-plugin-${KEYCLOAK_PLUGIN_VERSION}.jar \
     ${NEXUS_PLUGINS}${KEYCLOAK_PLUGIN}.jar

RUN chmod 644 ${NEXUS_PLUGINS}/org/github/flytreeleft/nexus3-keycloak-plugin/${KEYCLOAK_PLUGIN_RELEASE}/nexus3-keycloak-plugin-${KEYCLOAK_PLUGIN_VERSION}.jar
RUN echo "reference\:file\:${KEYCLOAK_PLUGIN}.jar = 200" >> ${NEXUS_HOME}/etc/karaf/startup.properties

# setup permissions
RUN chown nexus:nexus -R /opt/sonatype/nexus

USER nexus
