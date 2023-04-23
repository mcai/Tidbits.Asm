#!/bin/bash

# # Update package list and install necessary dependencies
# sudo apt-get update
# sudo apt-get install -y dosbox

rm -rf HELLO.EXE HELLO.OBJ
dosbox compile.bat
dosbox run.bat