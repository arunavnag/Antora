const fs = require('fs');
const path = require('path');

function loadConfig() {
  const configPath = path.join(__dirname, 'config.json');
  if (fs.existsSync(configPath)) {
    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    return config;
  }
  return {
    outputDir: process.env.DOCS_OUTPUT_DIR || './output'
  };
}

module.exports = { loadConfig };