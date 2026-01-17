FROM nodered/node-red:3.1.10

# Switch to root to install packages & set permissions
USER root

# Install additional Node-RED nodes + COS SDK
RUN npm install \
    node-red-dashboard \
    node-red-node-ui-table \
    ibm-cos-sdk

# Copy bootstrap script and make it executable
COPY bootstrap.sh /usr/local/bin/bootstrap.sh
RUN chmod +x /usr/local/bin/bootstrap.sh

# Switch back to non-root user (important)
USER node-red

# Expose Node-RED port
EXPOSE 1880

# Run bootstrap first, then Node-RED
ENTRYPOINT ["/usr/local/bin/bootstrap.sh"]
