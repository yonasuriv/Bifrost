#!/bin/sh

origin=~/.local/share/Bifrost # Bifrost Path
. $origin/.core/assembler.sh # Assemble 

handle_arguments "$@" # Pass all command-line arguments to the handle_arguments function
bifrost_link "$@" # Bifrost Start
