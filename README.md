# Node-RED on IBM Code Engine

This repository deploys Node-RED as a cloud integration layer using IBM Code Engine.

## Architecture
Watson Orchestrate → HTTP API → Node-RED → Enterprise Systems

## Deploy Steps
1. Push this repo to GitHub
2. IBM Cloud → Code Engine → Create Application
3. Select "Build container image from source code"
4. Paste repo URL
5. Use Dockerfile build strategy
6. Expose port 1880
7. Create

## Default URL
https://<app-name>.us-south.codeengine.appdomain.cloud
