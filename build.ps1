# Get list of .adoc files (excluding index.adoc)
$files = Get-ChildItem -Path "modules\ROOT\pages\*.adoc" | Where-Object { $_.Name -ne "index.adoc" }

# Display available files
Write-Host "Available .adoc files:"
for ($i = 0; $i -lt $files.Count; $i++) {
    Write-Host "$($i+1). $($files[$i].Name)"
}

# Get user input
$selections = Read-Host "Enter the numbers of the files you want to include (separated by spaces)"

# Convert selections to filenames
$selected_files = @()
foreach ($num in $selections.Split(' ')) {
    if ([int]$num -le $files.Count) {
        $selected_files += $files[[int]$num-1].Name
    }
}

# Join filenames with commas
$env:SELECTED_FILES = $selected_files -join ','

# Debug output
Write-Host "Selected files: $env:SELECTED_FILES"

# Clean previous build if exists
$buildDir = "build"
if (Test-Path $buildDir) {
    Remove-Item -Path $buildDir -Recurse -Force
}

# Run Antora
npx antora antora-playbook.yml

# Specify the desired output directory
$customOutputDir = "C:\Nexeed\Docs-output"
if (-Not (Test-Path $customOutputDir)) {
    New-Item -ItemType Directory -Path $customOutputDir
}

# Clean previous build if exists
$buildDir1 = $customOutputDir
if (Test-Path $buildDir1) {
    Remove-Item -Path $buildDir1 -Recurse -Force
}

# Move the build output to the custom directory
Move-Item -Path "$buildDir/*" -Destination $customOutputDir -Force

