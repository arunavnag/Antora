'use strict'

const fs = require('fs')
const path = require('path')

module.exports.register = function () {
  // Handle content events to modify headers
  this.on('content', ({content}) => {
    if (content.src.extname !== '.adoc') return
    
    // Read the content
    let text = content.toString()
    
    // Regular expressions for matching headers
    const mainHeaderRegex = /^= (.+)$/m          // Matches level 1 header
    const thirdLevelRegex = /^=== (.+)$/gm       // Matches all level 3 headers
    
    // Modify main header (level 1)
    text = text.replace(mainHeaderRegex, (match, headerText) => {
      // Only add prefix if it's not already there
      if (!headerText.startsWith('custom ')) {
        return `= custom ${headerText}`
      }
      return match
    })
    
    // Modify third level headers
    text = text.replace(thirdLevelRegex, (match, headerText) => {
      // Only add prefix if it's not already there
      if (!headerText.startsWith('custom ')) {
        return `=== custom ${headerText}`
      }
      return match
    })
    
    // Update the content
    content.asString = text
  })

  // Original file selection logic
  this.once('contentClassified', ({ contentCatalog }) => {
    // Get selected files from environment variable
    const selectedFiles = process.env.SELECTED_FILES 
      ? process.env.SELECTED_FILES.split(',').map(f => f.trim())
      : []
    
    console.log('Selected files:', selectedFiles)
    
    // Get all files that are pages
    const allFiles = contentCatalog.getFiles()
    allFiles.forEach((file) => {
      if (file.src.family === 'page') {
        const fileName = path.basename(file.src.path)
        
        // Keep file only if it's index.adoc or in the selected files list
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
