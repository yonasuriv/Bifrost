#!/bin/sh

# Assemble 
. $origin/.core/assembler.sh
. $origin/BuildBifrostBridge

# Bifrost Start
handle_arguments "$@" # Pass all command-line arguments to the handle_arguments function
bifrost_link "$@"
