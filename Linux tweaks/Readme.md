# Tools to tweak your Linux install of X-Plane 12

## fix_lua-jit.sh: 

**Fix aircraft xlua plugin performance**

**(This is a workaround for an issue that will probably be solved within xlua)**

It has been observed that the jit compiler in lua implementations using luajit for X-Plane (e.g. xlua and SASL) can cause random and severe performance issues.
Even default aircraft can be affected because of their xlua plugin (A330-300, Citation X, B737-800).  
A tested and reliable workaround is to disable the jit compiler in affected aircraft/scripts. Luajit will then use it's 'normal' interpreter, which is still faster than vanilla lua.  

This shell script helps you insert the command *jit.off()* as the first line of xlua scripts of chosen aircraft automatically.

### Features

- **Aircraft whitelist:**  
Generate a list of all aircraft that use xlua. Store their paths in the file 

        ./Z_fix_lua-jit_files/acft-using-xlua.txt

    You can edit this list and remove aircraft that you don't want tweaked.
- **Script whitelist:**  
Generate a list of all scripts (filtered by **aircraft whitelist**). Store their paths in the file

        ./Z_fix_lua-jit_files/xlua-scripts.txt

    You can edit this list and remove scripts that you don't want tweaked.
- **Back up and restore scripts**  
Create a backup of all scripts for aircraft in **aircraft whitelist**. This backup is created in

        aircraft-folder/plugins/xlua/scripts_backup.tar
        
    Restoring will unpack the backup, overwriting existing scripts, and then delete the backup
- **Apply and remove jit.off() tweak**  
Add or delete the line

        jit.off()

    as the first line of every script in **script whitelist**
- **Scan tweak status**  
List scripts in **script whitelist** that have the *jit.off()* applied

### Usage

- Place the script in your X-Plane 12 root folder and run it from the command line
- **Optionally** provide the path to your own **scripts whitelist** as argument to the script like this:

       $ ./fix_lua-jit.sh path-to-my-scripts-whitelist.txt

- Create and customize **aicraft whitelist** to use the backup/restore functionality and to generate the **scripts whitelist**
- Create and customize **scripts whitelist** (skip, if you have provided your own scripts whitelist)
- **Optionally** back up scripts
- Review **scripts whitelist**
- Add or remove the *jit.off()* tweak in scripts in **scripts whitelist**
- Restore scripts backup to restore default scripts (for whitelisted aircraft)