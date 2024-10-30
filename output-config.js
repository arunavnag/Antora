'use strict'

const fs = require('fs')
const path = require('path')

module.exports.register = function () {
  this.once('beforeStart', ({ playbook }) => {
    // Create timestamp string
    const now = new Date()
    const timestamp = now.toISOString()
      .replace(/[:\.-]/g, '_')
      .replace(/[T]/g, '-')
      .slice(0, 19) // Gets format like: 2024_10_28-14_30_00

    // Create output directory path
    const outputDir = path.join('./output', timestamp)

    // Ensure the output directory exists
    fs.mkdirSync(outputDir, { recursive: true })

    // Set the output directory in the playbook
    playbook.output = { dir: outputDir }

    console.log(`Output will be generated in: ${outputDir}`)
  })
}