FROM nodered/node-red:3.1.10

USER root

RUN npm install \
    node-red-dashboard \
    node-red-node-ui-table \
    ibm-cos-sdk

# Create Node-RED writable dirs
RUN mkdir -p /data/images \
 && chown -R node-red:node-red /data

# COPY MUST MATCH FILE NAME EXACTLY
COPY bootstrap.sh /data/bootstrap.sh
RUN chmod +x /data/bootstrap.sh

USER node-red

EXPOSE 1880

ENTRYPOINT ["sh", "/data/bootstrap.sh"]
