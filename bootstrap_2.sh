#!/bin/sh
set -e

echo "🚀 Bootstrapping Node-RED from COS..."

# ---- Hard validation (FAIL FAST) ----
REQUIRED_VARS="
COS_ENDPOINT
COS_BUCKET
COS_OBJECT
COS_ACCESS_KEY_ID
COS_SECRET_ACCESS_KEY
"

for var in $REQUIRED_VARS; do
  if [ -z "$(eval echo \$$var)" ]; then
    echo "❌ ERROR: Environment variable $var is NOT set"
    exit 1
  fi
done

echo "✅ All required COS environment variables are set"
echo "⬇️ Downloading flows from COS..."

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
      Key: process.env.COS_OBJECT
    };

    console.log("📡 Fetching object from COS...");
    const data = await cos.getObject(params).promise();

    if (!data || !data.Body) {
      throw new Error("COS object downloaded but body is empty");
    }

    fs.writeFileSync("/data/flows.json", data.Body);
    console.log("✅ flows.json written to /data/flows.json");

  } catch (err) {
    console.error("❌ COS BOOTSTRAP FAILED");
    console.error(err);
    process.exit(1);
  }
})();
EOF

echo "▶️ Starting Node-RED"
exec npm start -- --userDir /data
