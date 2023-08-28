#!/bin/sh

# Function to print the version
print_version() {
    echo
    echo "Bifrost Bridge Version: $version"
}

create_target_file() {
    echo """
# IP range allowed on target. For domains please include the full domain address (http:// or https://)
target="127.0.0.1" 
target_username="admin"
target_password="root"

# Do not modify below here
ip="$target"
ip_range="$target"
""" > TARGET
}

# Function to create a project folder or check if it exists
create_project_folder() {
    local project_name="$1"
    
    if [ "$project_name" = "tmp" ]; then
        mkdir -p "projects/tmp"
        cd "projects/tmp" || exit
        echo
        echo "Starting a temporary project.."
    else
        mkdir -p "projects/$project_name"
        cd "projects/$project_name" || exit
        echo
        echo "Project '$project_name' found. Starting project.."
    fi

    create_target_file
    echo
    sleep 2
}

# Function to list available projects (excluding tmp)
list_projects() {
    local project_index=3
    for project_dir in projects/*/; do
        if [ -d "$project_dir" ] && [ "$project_dir" != "projects/tmp/" ]; then
            project_name=$(basename "$project_dir")
            echo "  $project_index) Select Project: $yellow$project_name$end"
            project_index=$((project_index + 1))
        fi
    done
}

# Function to display the project menu
projects_menu() {
    while true; do
        echo 
        echo "  T) Start a Temporary Project (tmp)"
        echo "  N) Create a New Project"
        echo
        list_projects
        echo 
        echo "  0) Exit"
        echo
        echo -n "     Enter your choice: " && read choice

        if [ "$choice" = "t" ] || [ "$choice" = "T" ]; then
            create_project_folder "tmp"
            echo "Created temporary project (tmp)"
        elif [ "$choice" = "n" ] || [ "$choice" = "N" ]; then
            echo
            echo -n "     Enter project name: " && read project_name
            create_project_folder "$project_name"
            echo "Created project: $project_name"
        elif [ "$choice" -ge "1" ] && [ "$choice" -le "$(($project_index - 1))" ]; then
            selected_project=$(list_projects | sed -n "$choice p" | awk '{print $NF}')
            echo "Selected project: $selected_project"
            
            # Change to the selected project folder
            cd "projects/$selected_project" || { echo "Error changing to project folder: $selected_project"; exit 1; }
            echo "Changed to project folder: $selected_project"
            
            # Create the TARGET file
            create_target_file
            echo "Created TARGET file in project: $selected_project"
            
            # Add your code to continue script operations here
            # For example, you can call other functions or run commands specific to the project.
            
            # For debugging, you can add an echo statement here to ensure the script continues within the project folder.
            echo "Continuing within project folder: $selected_project"
        elif [ "$choice" = "0" ]; then
            echo "Exiting..."
            exit 0 # Exit the entire script with success
        else
            echo -n "Invalid choice. Please select a valid option."
        fi
    done
}

# Function to handle the -p argument
handle_p_argument() {
    if [ -n "$1" ]; then
        project_name="$1"
        create_project_folder "$project_name"
        cd "projects/$project_name" || exit
        #echo "Created and moved to project: $project_name"
        echo "wawa"
        sleep 2
    else
        # No project name provided with -p option, go straight to the menu
        projects_menu
    fi
}

# Handle command-line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -v|--version)
            print_version
            exit 0 # Exit the entire script with success
            ;;
        -p)
            shift
            handle_p_argument "$1"
            #projects_menu
            exit 0
            ;;
        *)
            echo "Invalid argument: $1"
            ;;
    esac
    shift
done

# Start the project menu
projects_menu
