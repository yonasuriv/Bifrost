#!/bin/sh

# Check if there are no arguments provided
if [ $# -eq 0 ]; then
    continue
fi

. ./projects/tmp/TARGET

create_project_folder() {
    mkdir -p "projects/$1"
}

create_tmp_project_folder() {
    mkdir -p "projects/tmp"
}

list_projects() {
    local project_index=1
    for project_dir in projects/*/; do
        if [ -d "$project_dir" ]; then
            project_name=$(basename "$project_dir")
            echo "$project_index. Select Project: $project_name"
            project_index=$((project_index + 1))
        fi
    done
}

projects() {
    while true; do
        echo "Menu:"
        echo "1. Create a Project"
        echo "2. Create a Temporary Project (tmp)"

        list_projects

        echo "0. Exit"

        echo -n "Enter your choice: "
        read choice

        if [ "$choice" = "1" ]; then
            echo -n "Enter project name: "
            read project_name
            create_project_folder "$project_name"
            echo "Created project: $project_name"
        elif [ "$choice" = "2" ]; then
            create_tmp_project_folder
            echo "Created temporary project (tmp)"
        elif [ "$choice" -ge 3 ] && [ "$choice" -le "$(($project_index - 1))" ]; then
            selected_project=$(list_projects | sed -n "$choice p" | awk '{print $NF}')
            echo "Selected project: $selected_project"
        elif [ "$choice" = "0" ]; then
            echo "Exiting..."
            break
        else
            echo "Invalid choice. Please select a valid option."
        fi
    done
}

projects
