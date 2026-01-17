#!/bin/sh
set -e

echo "🚀 Bootstrapping Node-RED from COS..."

REQUIRED_VARS="
COS_ENDPOINT
COS_BUCKET
COS_ACCESS_KEY_ID
COS_SECRET_ACCESS_KEY
"

for var in $REQUIRED_VARS; do
  if [ -z "$(eval echo \$$var)" ]; then
    echo "❌ Missing env var: $var"
    exit 1
  fi
done

echo "✅ Environment variables validated"

node <<'EOF'
const COS = require("ibm-cos-sdk");
const fs = require("fs");
const path = require("path");

const cos = new COS.S3({
  endpoint: process.env.COS_ENDPOINT,
  accessKeyId: process.env.COS_ACCESS_KEY_ID,
  secretAccessKey: process.env.COS_SECRET_ACCESS_KEY,
  signatureVersion: "v4"
});

const BUCKET = process.env.COS_BUCKET;
const FLOW_KEY = process.env.COS_OBJECT || "flows/test.json";
const IMAGE_PREFIX = "images/";

async function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

async function downloadFlows() {
  console.log("⬇️ Downloading flows...");
  const data = await cos.getObject({
    Bucket: BUCKET,
    Key: FLOW_KEY
  }).promise();

  fs.writeFileSync("/data/flows.json", data.Body);
  console.log("✅ flows.json written");
}

async function syncImages() {
  console.log("🖼️ Syncing images from COS...");
  await ensureDir("/data/images");

  const listed = await cos.listObjectsV2({
    Bucket: BUCKET,
    Prefix: IMAGE_PREFIX
  }).promise();

  for (const obj of listed.Contents || []) {
    if (obj.Key.endsWith("/")) continue;

    const localPath = path.join("/data", obj.Key);
    await ensureDir(path.dirname(localPath));

    const file = await cos.getObject({
      Bucket: BUCKET,
      Key: obj.Key
    }).promise();

    fs.writeFileSync(localPath, file.Body);
    console.log("⬇️ Synced", obj.Key);
  }
}

(async () => {
  try {
    await downloadFlows();
    await syncImages();
    console.log("✅ COS bootstrap complete");
  } catch (err) {
    console.error("❌ COS bootstrap failed", err);
    process.exit(1);
  }
})();
EOF

echo "▶️ Starting Node-RED"
exec npm start -- --userDir /data
