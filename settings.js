module.exports = {
    uiPort: process.env.PORT || 1880,
    flowFile: 'flows.json',
    adminAuth: null,
    functionGlobalContext: {},
    logging: {
        console: {
            level: "info",
            metrics: false,
            audit: false
        }
    }
}
