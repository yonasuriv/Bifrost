#!/bin/bash
. ./.core/assembler.sh

# Bifrost Start
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

# Function to print the version
print_version() {
    echo
    echo "Bifrost Bridge Version: $version"
}

# Function to list available projects (excluding tmp)
list_projects() {
    local project_index=1
    for project_dir in projects/*/; do
        if [ -d "$project_dir" ] && [ "$project_dir" != "projects/tmp/" ]; then
            project_name=$(basename "$project_dir")
            echo "  $project_index) Project $green2$project_name$end"
            project_index=$((project_index + 1))
        fi
    done
}

tmp() {
    rm -r "./projects/tmp"
    mkdir -p "./projects/tmp"
    cd "projects/tmp" #|| exit
    cp "../../.core/create_target.sh" "../../projects/tmp/TARGET"
}

# Function to display the project menu
projects_menu() {
    local project_name="$1"

    while true; do
        echo
        list_projects
        echo 
        echo "  T) Temporary Project"
        echo "  N) New Project"
        echo
        echo -n "     Enter your choice: $white" && read choice
        echo "$end"

        if [ "$choice" = "t" ] || [ "$choice" = "T" ]; then
            tmp
            echo "$yellow2     Starting a temporary project..$end"
            sleep 2
            start
        elif [ "$choice" = "n" ] || [ "$choice" = "N" ]; then
            echo -n "     Enter project name: $green" && read project_name
            mkdir -p "projects/$project_name"
            cd "projects/$project_name" #|| exit
            echo "$end"
            cp "../../.core/create_target.sh" "../../projects/$project_name/TARGET"
            echo "$green2     Project $project_name Created. Starting..$end"
            sleep 2
            start
        elif [[ "$choice" =~ ^[0-9]+$ && "$choice" -ge 0 && "$choice" -lt ${#directory_list[@]} ]]; then
            selected_directory="${directory_list[choice]}"
            echo "You selected directory: $selected_directory"

        elif [ "$choice" = "0" ]; then
            credits
            exit
        else
            echo
            error_argument
        fi
    done
}

# Function to handle command-line arguments
handle_arguments() {
    while [ $# -gt 0 ]; do
        case "$1" in
            -v|--version)
                print_version
                exit 0
                ;;
            -p)
                projects_menu
                ;;
            *)
                echo "Invalid argument: $1"
                exit 1
                ;;
        esac
        shift
    done
}

handle_arguments "$@" # Pass all command-line arguments to the handle_arguments function
start "$@"
