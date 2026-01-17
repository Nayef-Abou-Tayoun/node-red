FROM nodered/node-red:3.1.10

# Install additional Node-RED nodes
RUN npm install \
    node-red-dashboard \
    node-red-node-ui-table

# Node-RED default user directory is /data
# Flows, credentials, and settings will be loaded from the mounted volume

EXPOSE 1880
