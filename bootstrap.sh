#!/bin/sh
set -e

echo "🚀 Bootstrapping Node-RED on Code Engine..."

# Ensure image folder exists
mkdir -p /data/images

# Load flows.json from COS (if configured)
if [ -n "$COS_ENDPOINT" ] && [ -n "$COS_BUCKET" ] && [ -n "$COS_FLOWS_OBJECT" ]; then
  echo "⬇️ Loading flows.json from COS..."

  node <<'EOF'
const COS = require("ibm-cos-sdk");
const fs = require("fs");

const cos = new COS.S3({
  endpoint: process.env.COS_ENDPOINT,
  accessKeyId: process.env.COS_ACCESS_KEY_ID,
  secretAccessKey: process.env.COS_SECRET_ACCESS_KEY,
  signatureVersion: "v4"
});

const params = {
  Bucket: process.env.COS_BUCKET,
  Key: process.env.COS_FLOWS_OBJECT
};

cos.getObject(params).promise()
  .then(data => {
    fs.writeFileSync("/data/flows.json", data.Body);
    console.log("✅ flows.json loaded from COS");
  })
  .catch(err => {
    console.error("❌ Failed to load flows.json", err);
    process.exit(1);
  });
EOF
else
  echo "⚠️ COS env vars not set — starting without flows.json"
fi

echo "▶️ Starting Node-RED"
exec npm start -- --userDir /data
