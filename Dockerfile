FROM nodered/node-red:3.1.10

# Install additional Node-RED nodes + COS SDK
RUN npm install \
    node-red-dashboard \
    node-red-node-ui-table \
    ibm-cos-sdk

# Copy bootstrap script (loads flows from COS)
COPY bootstrap.sh /usr/local/bin/bootstrap.sh
RUN chmod +x /usr/local/bin/bootstrap.sh

# Node-RED default port
EXPOSE 1880

# Run bootstrap first, then start Node-RED
ENTRYPOINT ["/usr/local/bin/bootstrap.sh"]
