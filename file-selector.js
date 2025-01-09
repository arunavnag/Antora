'use strict'

const fs = require('fs')
const path = require('path')

module.exports.register = function () {
  // Handle content events to modify headers
  this.once('content', ({content}) => {
    console.log('Content event fired for file:', content.src.path);
    
    if (content.src.extname !== '.adoc') {
      console.log('Skipping non-adoc file:', content.src.path);
      return;
    }
    
    // Read the content
    let text = content.toString();
    console.log('Original content:', text.slice(0, 200)); // Log first 200 chars
    
    // Regular expressions for matching headers
    const mainHeaderRegex = /^= (.+)$/m          // Matches level 1 header
    const thirdLevelRegex = /^=== (.+)$/gm       // Matches all level 3 headers
    
    // Modify main header (level 1)
    let mainHeaderFound = false;
    text = text.replace(mainHeaderRegex, (match, headerText) => {
      mainHeaderFound = true;
      console.log('Found main header:', match);
      // Only add prefix if it's not already there
      if (!headerText.startsWith('custom ')) {
        const newHeader = `= custom ${headerText}`;
        console.log('Modified to:', newHeader);
        return newHeader;
      }
      console.log('Header already has custom prefix');
      return match;
    });
    
    if (!mainHeaderFound) {
      console.log('No main header found in file');
    }
    
    // Modify third level headers
    let thirdLevelFound = false;
    text = text.replace(thirdLevelRegex, (match, headerText) => {
      thirdLevelFound = true;
      console.log('Found third level header:', match);
      // Only add prefix if it's not already there
      if (!headerText.startsWith('custom ')) {
        const newHeader = `=== custom ${headerText}`;
        console.log('Modified to:', newHeader);
        return newHeader;
      }
      console.log('Third level header already has custom prefix');
      return match;
    });
    
    if (!thirdLevelFound) {
      console.log('No third level headers found in file');
    }
    
    // Update the content
    content.asString = text;
    console.log('Modified content:', text.slice(0, 200)); // Log first 200 chars
  })

  // Original file selection logic remains the same
  this.once('contentClassified', ({ contentCatalog }) => {
    const selectedFiles = process.env.SELECTED_FILES 
      ? process.env.SELECTED_FILES.split(',').map(f => f.trim())
      : []
    
    console.log('Selected files:', selectedFiles)
    
    const allFiles = contentCatalog.getFiles()
    allFiles.forEach((file) => {
      if (file.src.family === 'page') {
        const fileName = path.basename(file.src.path)
        
        if (fileName !== 'index.adoc' && !selectedFiles.includes(fileName)) {
          console.log('Removing file:', fileName)
          contentCatalog.removeFile(file)
        } else {
          console.log('Keeping file:', fileName)
        }
      }
    })
  })
}
