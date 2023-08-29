#!/bin/sh
. $origins/.core/assembler.sh

start() {
    #sudoreq
    clear
    logo
    #target_domain
    #target_username
    #target_password
    target_data
    menu
    menu_select
}

# Bifrost Start
handle_arguments "$@" # Pass all command-line arguments to the handle_arguments function
start "$@"
