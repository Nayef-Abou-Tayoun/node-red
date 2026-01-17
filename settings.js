module.exports = {
    uiPort: process.env.PORT || 1880,

    // 👇 IMPORTANT FIX
    flowFile: 'flow-1.json',

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
