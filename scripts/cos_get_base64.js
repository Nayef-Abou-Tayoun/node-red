const COS = require("ibm-cos-sdk");

async function main() {
  const key = process.argv[2];
  if (!key) {
    console.error("Missing object key");
    process.exit(1);
  }

const cos = new COS.S3({
  endpoint: "https://s3.us-south.cloud-object-storage.appdomain.cloud",
  accessKeyId: "aaba9617589c4b8f965d554a2cd66347",
  secretAccessKey: "572616223d2f533dad15ad6ab033ddce6d0e3424a39cb981",
  signatureVersion: 'v4'
});

  const data = await cos.getObject({
    Bucket: "node-red-flows",
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
