#!/usr/bin/env zsh

# This script creates a new Typst project directory structure.
#
# Usage: ./non_boring_notes.zsh <new_project_name>
# Example: ./non_boring_notes.zsh linear-algebra

# --- Input Validation ---

# Check if a directory name was provided
new_dir_name="$1"
if [ -z "$new_dir_name" ]; then
  echo "Error: Please provide a directory name as an argument."
  echo "Usage: $0 <new_project_name>"
  exit 1
fi

# Prevent overwriting an existing folder
if [ -d "$new_dir_name" ]; then
  echo "Error: Directory '$new_dir_name' already exists. Choose a different name."
  exit 1
fi

# Get the directory where the script is located
readonly SCRIPT_DIR="${0:A:h}"

readonly FULL_TEMPLATE="$SCRIPT_DIR/starters/full"
readonly MINIMAL_TEMPLATE="$SCRIPT_DIR/starters/minimal"
readonly SHARED_TEMPLATE="$SCRIPT_DIR/shared"

read "format?Choose a style (0: Full, 1: Minimal): "

if [[ "$format" == "0" ]]; then
  template_dir=$FULL_TEMPLATE
elif [[ "$format" == "1" ]]; then
  template_dir=$MINIMAL_TEMPLATE
else
  echo "Invalid format selected. Defaulting to Minimal."
  template_dir=$MINIMAL_TEMPLATE
fi

# Check if the template directory exists
if [[ ! -d "$template_dir" || ! -d "$SHARED_TEMPLATE" ]]; then
  echo "Error: Template folders not found at $SCRIPT_DIR"
  exit 1
fi

# --- Project Creation ---

# Create the new main project directory
mkdir -p "$new_dir_name" || {
  echo "Error: Failed to create directory. Check your permissions."
  exit 1
}

# Copy template
cp -a "$template_dir"/. "$new_dir_name/"
cp -a "$SHARED_TEMPLATE"/. "$new_dir_name/"

# Create the .typst_main_file
echo "main.typ" >"$new_dir_name/.typst_main_file"

echo "Successfully created project in: ${new_dir_name:a:t3}"

exit 0
