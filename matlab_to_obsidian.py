import os
import re

#
# This script extracts descriptions from MATLAB .m files and creates corresponding .md files for Obsidian.
#

# --- CONFIGURATION ---
MATLAB_FOLDER = r'C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/code'
OBSIDIAN_FOLDER = r'C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/thesis_notes/Info/code files'
# ---------------------

def extract_matlab_info(filepath):
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
        
    comment_block = []
    separator_indices = []
    
    for i, line in enumerate(lines):
        clean_line = line.strip()
        
        if clean_line.startswith('%'):
            content = clean_line.lstrip('%').strip()
            if re.match(r'^[\=\-\*\_]{3,}$', content):
                separator_indices.append(len(comment_block))
            
            comment_block.append(content)
        elif not clean_line and not comment_block:
            continue
        elif not clean_line:
            comment_block.append("")
        else:
            break

    if len(separator_indices) >= 2:
        start = separator_indices[0] + 1
        end = separator_indices[-1]
        final_lines = comment_block[start:end]
    else:
        final_lines = [l for l in comment_block if not re.match(r'^[\=\-\*\_ ]+$', l)]

    description = "\n".join(final_lines).strip()
    return description if description else "No description found."

if not os.path.exists(OBSIDIAN_FOLDER):
    os.makedirs(OBSIDIAN_FOLDER)

for filename in os.listdir(MATLAB_FOLDER):
    if filename.endswith(".m"):
        script_path = os.path.join(MATLAB_FOLDER, filename)
        info = extract_matlab_info(script_path)
        
        # Create MD file (Script_Name.m.md)
        md_filename = f"{filename}.md"
        md_path = os.path.join(OBSIDIAN_FOLDER, md_filename)
        
        content = f"## Description\n\n{info}\n\n---\n**Source Path:** `{script_path}`"
        
        with open(md_path, 'w', encoding='utf-8') as f:
            f.write(content)

print(f"Success! Processed files are in {OBSIDIAN_FOLDER}")

indexfolder = r'C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/thesis_notes/Info/'

def generate_index(obsidian_folder, index):
    index_path = os.path.join(index, "Matlab Script Index.md")
    all_files = sorted([f for f in os.listdir(obsidian_folder) if f.endswith(".md") and f != "Matlab Script Index.md"])
    
    with open(index_path, 'w', encoding='utf-8') as f:
        #f.write("# MATLAB Script Index\n\n")
        f.write("| Script Name | Link |\n")
        f.write("| --- | --- |\n")
        
        for md_file in all_files:
            # Create a pretty name by removing .m.md
            display_name = md_file.replace(".m.md", "").replace(".md", "")
            f.write(f"| {display_name} | [[{md_file[:-3]}]] |\n")

generate_index(OBSIDIAN_FOLDER,indexfolder)
print("Index updated!")