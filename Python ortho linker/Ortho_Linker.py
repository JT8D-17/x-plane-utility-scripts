# -----------------------------------------------------------------------------------------
#
# This is a very experimental ortho folder link creator that will create symbolic links
# to reference multiple "zOrtho4XP_" folders from a single scenery folder to massively
# reduce scenery_packs.ini clutter!
#
# Written in Python 3.12, may work in older Python releases
#
# Credits: Whatever site threw up usable bits of code after googling, mostly Stackoverflow
#
# RandomUser, 2024/07/03
#
# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------
# DANGER ZONE BELOW, STAY AWAY UNLESS YOU HAVE PYTHON SKILLS!
# -----------------------------------------------------------

# Modules
import os,logging,sys,time

# Variables
TargetFolders=["Earth nav data", "terrain", "textures"] # List of subfolders within each scenery directory; leave as is
Start_Time = int(time.time()) # Used for calculating program run time
Source_OK = False
Dest_OK = False

# Configure logging
log = logging.getLogger(__name__) # Logger namespace
logfile = 'Ortho_Linker_Log.txt'
if sys.argv[3] != "": # Check if log file name was passed via argument...
    logfile = sys.argv[3] #...and change it
log2file = logging.FileHandler(filename=logfile,mode='w',encoding='utf-8') # Configure log file
log2file.setFormatter(logging.Formatter(fmt='%(levelname)s %(asctime)-8s: %(message)s',datefmt='%Y-%m-%d %H:%M:%S')) # Format log for log file
log2stdout = logging.StreamHandler(stream=sys.stdout) # Configure console/stdout
log2stdout.setFormatter(logging.Formatter(fmt='%(levelname)s %(asctime)-8s: %(message)s',datefmt='%H:%M:%S')) # Format log for stdout
handlers = [log2file,log2stdout] # Add log handlers to list
logging.basicConfig(level=logging.DEBUG,format='[%(asctime)s] {%(filename)s:%(lineno)d} %(levelname)s - %(message)s',handlers=handlers) # Configure logging

# Function: Create symbolic links
def Symbolic_Link(target,link):
    if not os.path.islink(link): # Check if symbolic link exists
        os.symlink(target,link) # Create symbolic link for file
        if os.path.islink(link): # Verify link creation
            log.info("Linked "+target) # Log message
        else: # If not...
            log.error("FAILED linking "+target) # Log message
    #else: # If it does...
        #log.info("Already exists: "+link) # Log message

# 0: Check arguments
Dir_Orthos = sys.argv[1] # Use argument 1 as the source folder for orthos, i.e. where the "zOrtho4XP_" folders are
Dir_Target = sys.argv[2] # Use argument 2 as the destination folder for the symbolic links

if Dir_Orthos == None or not os.path.exists(Dir_Orthos): # Check for unsuccessful passing of argument to variable and nonexisting path
    log.error("The source "+Dir_Orthos+" does not exist.") # Display error message
else: # Variable OK, path OK
    Source_OK = True # Set check variable to true

if Dir_Target == None or not os.path.exists(Dir_Target): # Check for unsuccessful passing of argument to variable and nonexisting path
    log.error("The destination "+Dir_Target+" does not exist.") # Display error message
else: # Variable OK, path OK
    Dest_OK = True # Set check variable to true

if Source_OK == True and Dest_OK == True: # Only continue when correct source and destination paths were specified
    # 1: Basic directories
    log.info("Stage 1: Basic Directories")
    for x in TargetFolders: # Iterate through target folder array
        if not os.path.exists(os.path.join(Dir_Target,x)): # Check if the target path does not exist
            os.makedirs(os.path.join(Dir_Target,x)) # Create target directory
            if os.path.exists(os.path.join(Dir_Target,x)): # Verify successful creation
                log.info("Created "+os.path.join(Dir_Target,x)) # Log message
        else: # If it does...
            log.info(x+" folder exists") # Log message

    # 2: Folder and file operations
    log.info("Stage 2: Symbolic links")
    for item in reversed(os.listdir(Dir_Orthos)): # Iterate through ortho folder last to first to dampen overlapping tile conflicts
        for x in TargetFolders: # Target 'Earth nav data', 'terrain', 'textures'
            log.info("Working in "+os.path.join(Dir_Orthos,item,x)) # Log message
            path1 = os.path.join(Dir_Orthos,item,x) # Assemble path
            if os.path.exists(path1): # Check that the folders exist
                for content in os.listdir(path1): # Iterate through content of "Earth nav data", etc. folders
                    path2 = os.path.join(path1,content) # Assemble path
                    if os.path.isdir(path2): # "Earth nav data" has subdirectories for tile groups, so consider this
                        tile_parent = os.path.basename(path2) # Tile parent folder, e.g. +50+010
                        for files in os.listdir(path2): # For each file in the subfolder
                            if files.endswith(".dsf"): # Check that we're dealing with DSFs
                                #print(os.path.join(path2,files)+" --> "+os.path.join(Dir_Target,x,tile_parent,files)) # Debug
                                if not os.path.exists(os.path.join(Dir_Target,x,tile_parent)): # Check if the tile parent folder exists
                                    os.makedirs(os.path.join(Dir_Target,x,tile_parent)) # Create tile parent folder
                                Symbolic_Link(os.path.join(path2,files),os.path.join(Dir_Target,x,tile_parent,files)) # Create symbolic link for dsf files
                    else: # Otherwise, assume we're dealing with files
                        tgt_file = os.path.basename(path2) # Get filename
                        if tgt_file.endswith(".ter") or tgt_file.endswith(".png") or tgt_file.endswith(".dds"): # Only handle .ter, .png or .dds files
                            #print(path2+" --> "+os.path.join(Dir_Target,x,tgt_file)) # Debug
                            Symbolic_Link(path2,os.path.join(Dir_Target,x,tgt_file)) # Create symbolic link for ter, png or dds file

    # 3: Check for broken symbolic links
    log.info("Stage 3: Symbolic link integrity")
    for directory, subdirectory, files in os.walk(Dir_Target): # Walk through the structure of the target folder to find all subfolders and files
        for name in files: # Get names of files from list
            filepath = os.path.join(directory,name)
            if not os.path.exists(os.readlink(filepath)): # Check if the symbolic links work
                log.error("BROKEN link to "+filepath) # Error message if one does not
                os.unlink(filepath) # Remove symbolic link
                if not os.path.islink(filepath): # Verify that the link was removed
                    log.info("REMOVED link to "+filepath)

    # Program end
    End_Time = int(time.time()) - Start_Time # Calculate running time
    log.info("Process completed in "+str(End_Time)+" s") # Log running time
