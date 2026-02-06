import os
import re

# --- CONFIGURATION ---
MATLAB_FOLDER = r'C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/code'
OBSIDIAN_FOLDER = r'C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/thesis_notes/Info/code files'
INDEX_FOLDER = r'C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/thesis_notes/Info/'
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

def generate_index(obsidian_folder, index):
    index_path = os.path.join(index, "Matlab Script Index.md")
    all_files = sorted([f for f in os.listdir(obsidian_folder) if f.endswith(".md")])
    
    with open(index_path, 'w', encoding='utf-8') as f:
        f.write("| Script Name | Link |\n")
        f.write("| --- | --- |\n")
        for md_file in all_files:
            display_name = md_file.replace(".m.md", "").replace(".md", "")
            f.write(f"| {display_name} | [[{md_file[:-3]}]] |\n")


if not os.path.exists(OBSIDIAN_FOLDER):
    os.makedirs(OBSIDIAN_FOLDER)


valid_md_files = []

for filename in os.listdir(MATLAB_FOLDER):
    if filename.endswith(".m"):
        script_path = os.path.join(MATLAB_FOLDER, filename)
        info = extract_matlab_info(script_path)
        
        md_filename = f"{filename}.md"
        valid_md_files.append(md_filename)
        
        md_path = os.path.join(OBSIDIAN_FOLDER, md_filename)
        content = f"## Description\n\n{info}\n\n---\n**Source Path:** `{script_path}`"
        
        with open(md_path, 'w', encoding='utf-8') as f:
            f.write(content)


for existing_file in os.listdir(OBSIDIAN_FOLDER):
    if existing_file.endswith(".md") and existing_file not in valid_md_files:
        os.remove(os.path.join(OBSIDIAN_FOLDER, existing_file))
        print(f"Deleted orphaned note: {existing_file}")

generate_index(OBSIDIAN_FOLDER, INDEX_FOLDER)
print(f"Success! Processed files in {OBSIDIAN_FOLDER} and updated index.")