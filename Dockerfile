FROM nodered/node-red:3.1.10

USER root

RUN npm install \
    node-red-dashboard \
    node-red-node-ui-table \
    ibm-cos-sdk

# Copy bootstrap + settings
COPY bootstrap.sh /usr/local/bin/bootstrap.sh
COPY settings.js /data/settings.js

RUN chmod +x /usr/local/bin/bootstrap.sh \
 && chown -R node-red:node-red /data

USER node-red

EXPOSE 1880

ENTRYPOINT ["/usr/local/bin/bootstrap.sh"]
