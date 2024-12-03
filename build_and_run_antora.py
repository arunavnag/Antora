import os
import shutil
import subprocess
import sys
import glob

# Ensure required libraries are installed
try:
    import blockdiag
except ImportError:
    print("blockdiag not found, installing...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "blockdiag"])
    print("blockdiag installed successfully.")

def find_adoc_files(input_dir):
    """Find all .adoc files in the input directory, excluding index.adoc"""
    files = [f for f in os.listdir(input_dir) 
             if f.endswith('.adoc') and f != "index.adoc"]
    return files

def select_files(files):
    """Dynamically select files from environment variable"""
    # Check if SELECTED_FILES is set in environment
    selected_files_env = os.environ.get('SELECTED_FILES')
    
    if selected_files_env:
        # Split the environment variable and validate files
        selected_files = [f for f in selected_files_env.split(',') if f in files]
    else:
        # If no environment variable, use all files
        selected_files = files
    
    return selected_files

def prepare_build_environment(input_dir, selected_files):
    """Prepare build environment by copying selected files"""
    # Ensure modules/ROOT/pages directory exists
    os.makedirs('modules/ROOT/pages', exist_ok=True)
    
    # Copy selected files to the pages directory
    for file in selected_files:
        src_path = os.path.join(input_dir, file)
        dest_path = os.path.join('modules/ROOT/pages', file)
        shutil.copy(src_path, dest_path)

def run_antora_build(output_dir):
    """Run Antora build process"""
    # Ensure output directory exists
    #os.makedirs(output_dir, exist_ok=True)
    
    # Clean previous build
    #build_dir = "build"
    #if os.path.exists(build_dir):
    #   shutil.rmtree(build_dir)
    
    # Run Antora build
    subprocess.run(["npx", "antora", "antora-playbook.yml"])
    
    # Move build to output directory
    #if os.path.exists(build_dir):
     #   shutil.move(build_dir, output_dir)
      #  print(f"Build output moved to {output_dir}")

def main():
    # Input directory mounted by Docker
    input_dir = os.environ.get('INPUT_DIR', '/home/demo/input')
    
    # Output directory for documentation
    output_dir = os.environ.get('OUTPUT_DIR', '/home/demo/output')
    
    # Find .adoc files in input directory
    adoc_files = find_adoc_files(input_dir)
    
    # Display available files
    print("Available .adoc files:")
    for i, file in enumerate(adoc_files):
        print(f"{i + 1}. {file}")
    
    # Select files to include
    selected_files = select_files(adoc_files)
    
    # Prepare build environment
    prepare_build_environment(input_dir, selected_files)
    
    # Run Antora build
    run_antora_build(output_dir)
    print("output .adoc files:")

if __name__ == "__main__":
    main()
