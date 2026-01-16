FROM nodered/node-red:3.1.10

# Optional: install extra Node-RED nodes
RUN npm install     node-red-dashboard     node-red-node-ui-table

EXPOSE 1880
