FROM nodered/node-red:3.1.10

# Switch to root for installs and filesystem prep
USER root

# Install extra Node-RED nodes + COS SDK
RUN npm install \
    node-red-dashboard \
    node-red-node-ui-table \
    ibm-cos-sdk

# Prepare Node-RED writable directories
RUN mkdir -p /data/images \
 && chown -R node-red:node-red /data

# Copy bootstrap script into writable path
COPY bootstrap.sh /data/bootstrap.sh
RUN chmod +x /data/bootstrap.sh

# Switch back to non-root user
USER node-red

EXPOSE 1880

# Bootstrap loads flows.json, then starts Node-RED
ENTRYPOINT ["/data/bootstrap.sh"]
