#!/bin/sh
set -e

export PORT=${PORT:-8080}

echo "🚀 Bootstrapping Node-RED on Code Engine..."

# 🔥 FORCE RESET Node-RED STATE ON EVERY START
echo "🧹 Clearing existing Node-RED flows"
rm -f /data/flows.json
rm -f /data/flows_cred.json

echo "📂 Ensuring folders exist"
mkdir -p /data/images

echo "📂 /data contents before bootstrap:"
ls -la /data

# Load flows.json from COS (if configured)
if [ -n "$COS_ENDPOINT" ] && [ -n "$COS_BUCKET" ] && [ -n "$COS_FLOWS_OBJECT" ]; then
  echo "⬇️ Loading flows.json from COS..."

  node <<'EOF'
const COS = require("ibm-cos-sdk");
const fs = require("fs");

(async () => {
  try {
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

    const data = await cos.getObject(params).promise();
    fs.writeFileSync("/data/flows.json", data.Body.toString("utf-8"));

    console.log("✅ flows.json loaded from COS");
  } catch (err) {
    console.error("❌ Failed to load flows.json", err);
    process.exit(1);
  }
})();
EOF
else
  echo "⚠️ COS env vars not set — starting without flows.json"
fi

echo "📂 /data contents after bootstrap:"
ls -la /data

echo "▶️ Starting Node-RED with custom settings on port $PORT"
exec npm start -- \
  --userDir /data \
  --settings /data/settings.js
