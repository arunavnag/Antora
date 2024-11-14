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
#build_dir = "build"
#if os.path.exists(build_dir):
#    shutil.rmtree(build_dir)
#print("test1")
# Run Antora
subprocess.run(["npx", "antora", "antora-playbook.yml"])
print("test2")
# Specify the desired output directory
#custom_output_dir = "/home/demo/output"
#os.makedirs(custom_output_dir, exist_ok=True)
#print("test3")
# Clean previous output if exists
#if os.path.exists(custom_output_dir):
#    shutil.rmtree(custom_output_dir)
#print("test4")
# Move the build output to the custom directory
#shutil.move(build_dir, custom_output_dir)
#print("test5")
# Remove the original build_dir to complete the "move" operation
 
#print(f"Build output moved to {custom_output_dir}")
