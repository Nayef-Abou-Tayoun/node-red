# Node-RED Integration with IBM watsonx Orchestrate (Key-Value Connection)

This guide explains how to configure an **IBM watsonx Orchestrate key-value connection**
and use it inside a **Python tool** to securely communicate with a **Node-RED HTTP API**
without usernames, passwords, or OAuth.

---

## Architecture Overview

- **IBM watsonx Orchestrate**: Agent + tool execution
- **Connection Type**: `key_value`
- **Target System**: Node-RED (running on IBM Code Engine)
- **Auth**: None (URL only, governed via Orchestrate connection)
- **Use Case**: Send Maximo Work Orders (`WO-XXXX`) to Node-RED

---

## Step 1 — Configure the Connection

Create a connection that stores only the Node-RED base URL.

```bash
orchestrate connections configure \
  -a node_red_api \
  --env live \
  -t team \
  -k key_value \
  --server-url https://node-red-flow.253ry1q9ellv.us-south.codeengine.appdomain.cloud

```bash
orchestrate connections set-credentials \
  -a node_red_api \
  --env live \
  -e 'url=https://node-red-flow.253ry1q9ellv.us-south.codeengine.appdomain.cloud'

```bash 
orchestrate connections list

