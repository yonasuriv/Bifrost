folder_menu() {
    counter=1

    # Loop through each folder in the current directory
    for project_dir in ./projects/*/; do
        project_name=$(basename "$project_dir")  # Remove trailing slash and path
        #echo "$counter. $project_name"  # Print the option
        counter=$((counter + 1))  # Increment the counter
    done

    # Prompt the user for their choice
    #printf "Select an option (1-%d): " "$((counter - 1))"
    read choice

    # Validate the user's choice
    if [ "$choice" -ge 1 ] && [ "$choice" -lt "$counter" ]; then
        counter=1
        for project_dir in ./projects/*/; do
            if [ "$counter" -eq "$choice" ]; then
                selected_folder=$(basename "$project_dir")
                break
            fi
            counter=$((counter + 1))
        done
        echo "You selected: $selected_folder"
    else
        echo "Invalid selection."
    fi
}

folder_menu
