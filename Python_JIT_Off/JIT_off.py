# This Python script adds "jit.off()" to all Lua files in this folder and any subfolders.
# Usage: Place e.g. in "plugins/xlua/scripts" and run it.
#
# cc0/public domain

import os

def add_jit_off_to_lua_files(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.lua'):
                file_path = os.path.join(root, file)

                with open(file_path, 'r') as f:
                    content = f.readlines()
                content.insert(0, 'jit.off()\n')
                with open(file_path, 'w') as f:
                    f.writelines(content)
                print(file+" modified.")

add_jit_off_to_lua_files('.')
