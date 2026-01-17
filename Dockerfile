FROM nodered/node-red:3.1.10

USER root

# Install required packages
RUN npm install \
    node-red-dashboard \
    node-red-node-ui-table \
    ibm-cos-sdk

# Create data dirs
RUN mkdir -p /data/images \
 && chown -R node-red:node-red /data

# COPY bootstrap.sh FROM REPO → INTO IMAGE
COPY bootstrap.sh /data/bootstrap.sh

# Verify at build time (CRITICAL)
RUN ls -la /data && chmod +x /data/bootstrap.sh

USER node-red

EXPOSE 1880

ENTRYPOINT ["/bin/sh", "/data/bootstrap.sh"]
