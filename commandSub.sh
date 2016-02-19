#!/bin/bash
files="$(ls)"
shell_files=`ls *.sh`
echo "$files"      # we need the quotes to preserve embedded newlines in $files
echo "$shell_files"  # we need the quotes to preserve newlines 
X=`expr 3 \* 2 + 4` # expr evaluate arithmatic expressions. man expr for details.
echo "$X"

