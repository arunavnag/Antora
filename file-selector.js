// file-selector.js
'use strict'

const fs = require('fs')
const path = require('path')

module.exports.register = function () {
  this.once('contentClassified', ({ contentCatalog }) => {
    // Get selected files from environment variable
    const selectedFiles = process.env.SELECTED_FILES 
      ? process.env.SELECTED_FILES.split(',').map(f => f.trim())
      : []
    
    console.log('Selected files:', selectedFiles) // Debug log
    
    // Get all files that are pages
    const allFiles = contentCatalog.getFiles()
    allFiles.forEach((file) => {
      if (file.src.family === 'page') {
        const fileName = path.basename(file.src.path)
        
        // Keep file only if it's index.adoc or in the selected files list
        if (fileName !== 'index.adoc' && !selectedFiles.includes(fileName)) {
          console.log('Removing file:', fileName) // Debug log
          contentCatalog.removeFile(file)
        } else {
          console.log('Keeping file:', fileName) // Debug log
        }
      }
    })
  })
}