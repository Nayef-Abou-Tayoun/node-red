FROM nodered/node-red:3.1.10

USER root

# Install required packages
RUN npm install \
    node-red-dashboard \
    node-red-node-ui-table \
    ibm-cos-sdk

# Create Node-RED data folders
RUN mkdir -p /data/images

# Copy bootstrap script to a STANDARD binary path
COPY bootstrap.sh /usr/local/bin/bootstrap.sh

# Make sure it exists and is executable (hard fail if missing)
RUN ls -la /usr/local/bin \
 && chmod +x /usr/local/bin/bootstrap.sh

USER node-red

EXPOSE 1880

ENTRYPOINT ["/bin/sh", "/usr/local/bin/bootstrap.sh"]
