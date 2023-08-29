#!/bin/sh

# Bifrost Default Location
origins=~/.local/share/Bifrost

# Assemble 
. $origins/.core/assembler.sh

# Bifrost Start
handle_arguments "$@" # Pass all command-line arguments to the handle_arguments function
bifrost_link "$@"
