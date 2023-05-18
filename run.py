import os
import sys
import subprocess

# Variables
TOOLS_DIR = "TOOLS"
DOSBOX_CONF = "dosbox.conf"

# Check if the first argument is provided
if len(sys.argv) < 2:
    print("No input file provided. Using 'program.asm' as the default.")
    ASM_FILE = "program.asm"
else:
    ASM_FILE = sys.argv[1]

OBJ_FILE = os.path.splitext(ASM_FILE)[0] + ".obj"
EXE_FILE = os.path.splitext(ASM_FILE)[0] + ".exe"

# Create dosbox.conf with the required commands
with open(DOSBOX_CONF, "w") as conf_file:
    conf_file.write("[autoexec]\n")
    conf_file.write("mount c .\n")
    conf_file.write("c:\n")
    conf_file.write(f"{TOOLS_DIR}\\MASM {ASM_FILE};\n")
    conf_file.write(f"{TOOLS_DIR}\\LINK {OBJ_FILE};\n")
    conf_file.write(f"{EXE_FILE}\n")
    # conf_file.write("exit\n")

# Run DOSBox with the custom configuration
subprocess.run(["dosbox", "-conf", DOSBOX_CONF])

# Delete the intermediate files and DOSBox configuration
os.remove(OBJ_FILE)
os.remove(DOSBOX_CONF)