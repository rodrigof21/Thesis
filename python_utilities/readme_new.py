import os

# --- CONFIGURATION ---
SOURCE_FILE = r'C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/thesis_notes/Info/README.md'
DEST_FILE = r'C:/Users/r7fon/OneDrive - Universidade de Lisboa/MEMec/Thesis/README.md'
# ---------------------

def copy_md_content(src, dst):
    try:
        # 1. Read the content from the source
        with open(src, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 2. Ensure the destination directory exists
        dest_dir = os.path.dirname(dst)
        if not os.path.exists(dest_dir):
            os.makedirs(dest_dir)
            
        # 3. Write (overwrite) to the destination
        with open(dst, 'w', encoding='utf-8') as f:
            f.write(content)
            
        print(f"Successfully copied content from {os.path.basename(src)} to {os.path.basename(dst)}")
        
    except FileNotFoundError:
        print(f"Error: Could not find the file at {src}")
    except Exception as e:
        print(f"An error occurred: {e}")

# Run the function
copy_md_content(SOURCE_FILE, DEST_FILE)