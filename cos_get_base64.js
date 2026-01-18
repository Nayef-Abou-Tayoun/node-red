const COS = require("ibm-cos-sdk");

async function main() {
  const key = process.argv[2];
  if (!key) {
    console.error("Missing object key");
    process.exit(1);
  }

  const cos = new COS.S3({
    endpoint: process.env.COS_ENDPOINT,
    accessKeyId: process.env.COS_ACCESS_KEY_ID,
    secretAccessKey: process.env.COS_SECRET_ACCESS_KEY,
    signatureVersion: "v4"
  });

  const data = await cos.getObject({
    Bucket: process.env.COS_BUCKET,
    Key: key
  }).promise();

  console.log(JSON.stringify({
    image_name: key.split("/").pop(),
    image_base64: data.Body.toString("base64")
  }));
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
