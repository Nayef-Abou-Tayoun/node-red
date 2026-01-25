module.exports = {
  uiPort: process.env.PORT || 8080,

  flowFile: "flows.json",
  flowFilePretty: true,

  editorTheme: {
    projects: {
      enabled: false
    }
  },

  runtimeState: {
    enabled: false
  },

  disableEditor: true
}
