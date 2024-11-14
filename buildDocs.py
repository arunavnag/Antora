import os
import shutil
import subprocess

# Get list of .adoc files (excluding index.adoc)
adoc_files_path = "modules/ROOT/pages"
files = [f for f in os.listdir(adoc_files_path) if f.endswith('.adoc') and f != "index.adoc"]

# Display available files
print("Available .adoc files:")
for i, file in enumerate(files):
    print(f"{i + 1}. {file}")

# Get user input
#selections = input("Enter the numbers of the files you want to include (separated by spaces): ")
selections = "1 2 3 4 5 6 7"
# Convert selections to filenames
selected_files = []
for num in selections.split():
    try:
        index = int(num) - 1
        if 0 <= index < len(files):
            selected_files.append(files[index])
    except ValueError:
        print(f"Invalid selection: {num}")

# Join filenames with commas
selected_files_str = ','.join(selected_files)
os.environ["SELECTED_FILES"] = selected_files_str

# Debug output
print("Selected files:", os.environ["SELECTED_FILES"])

# Clean previous build if exists
build_dir = "build"
#if os.path.exists(build_dir):
#    shutil.rmtree(build_dir)

# Run Antora
subprocess.run(["npx", "antora", "antora-playbook.yml"])

# Specify the desired output directory
custom_output_dir = "/home/demo/output"
os.makedirs(custom_output_dir, exist_ok=True)

# Clean previous output if exists
if os.path.exists(custom_output_dir):
    shutil.rmtree(custom_output_dir)

# Move the build output to the custom directory
shutil.copytree(build_dir, custom_output_dir, dirs_exist_ok=True)
shutil.rmtree(build_dir)

print(f"Build output moved to {custom_output_dir}")
