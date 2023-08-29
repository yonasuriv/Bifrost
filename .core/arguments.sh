# Function to print the version
print_version() {
    echo
    echo "Bifrost Bridge Version: $version"
}

tmp_folder="zzz_BifrostEphemeral.tmp"

tmp() {
    rm -r "./projects/$tmp_folder" > /dev/null 2>&1
    mkdir -p "./projects/$tmp_folder"
    cd "projects/$tmp_folder" #|| exit
    cp "../../.core/create_target.sh" "../../projects/$tmp_folder/TARGET"
}

list_projects() {
    local project_index=1
    local found_projects=false

    for project_dir in projects/*/; do
        if [ -d "$project_dir" ] && [ "$(basename "$project_dir")" != "$tmp_folder" ]; then
            project_name=$(basename "$project_dir")
            echo "  $project_index) $dim[PROJECT]$end $green2$project_name$end"
            project_index=$((project_index + 1))
            found_projects=true
        fi
    done

    if [ "$found_projects" = false ]|| [ ! -d "projects/$tmp_folder" ]; then
        echo " $red [NO PROJECTS FOUND]$end$dim Once created, they will appear here.$end"
    fi
}

# Function to display the project menu
projects_menu() {
    local project_name="$1"

    while true; do
        echo
        echo "$negative BIFROST PROJECT LINK $end"
        echo
        list_projects
        echo 
        echo "  N) Create New Project"
        echo "  T) Create New Temporary Project"
        echo
        echo -n "     Enter your choice: $white" && read choice
        echo "$end"
        projects_menu_select
        done
        }

projects_menu_select() {
    counter=1

    # Loop through each folder in the current directory
    for project_dir in ./projects/*/; do
        project_name=$(basename "$project_dir")  # Remove trailing slash and path
        #echo "$counter. $project_name"  # Print the option
        counter=$((counter + 1))  # Increment the counter
    done

    if [ "$choice" = "t" ] || [ "$choice" = "T" ]; then
        tmp
        echo " $yellow2[EPHEMERAL]$end Initializing$white Temporary Project$end."
        sleep 3
        target_prompt
        start
    elif [ "$choice" = "n" ] || [ "$choice" = "N" ]; then
        echo -n "     Enter project name: $green" && read project_name
        mkdir -p "projects/$project_name"
        cd "projects/$project_name" || exit
        echo "$end"
        cp "../../.core/create_target.sh" "../../projects/$project_name/TARGET"
        echo " $green2[PROJECT CREATED]$end Initializing $white$project_name$end."
        sleep 3
        target_prompt
        start
    elif [ "$choice" = "0" ]; then
        credits
        exit
    else
        if [ "$choice" -ge 1 ] && [ "$choice" -lt "$counter" ]; then
            counter=1
            for project_dir in ./projects/*/; do
                if [ "$counter" -eq "$choice" ]; then
                    selected_folder=$(basename "$project_dir")
                    break
                fi
                counter=$((counter + 1))
            done
            echo " $cyan2[PROJECT FOUND]$end Initializing $white$selected_folder$end."
            sleep 3
            cd "projects/$selected_folder"
            target_prompt
            start
        else
            echo
            echo -n "\033[2A\033[0K $red    Incorrect selection. Aborting. $end"
            exit
        fi
    fi
}

no_project() {
    echo
    echo "  No Project Selected. Entering Ephemeral mode.."
    sleep 2
    echo
    echo "  $yellow2[EPHEMERAL]$end Initializing$white Temporary Project$end."
    sleep 3
    tmp
    target_prompt
}

# Function to handle command-line arguments
handle_arguments() {
    if [ $# -eq 0 ]; then
        no_project
        return
    fi

    while [ $# -gt 0 ]; do
        case "$1" in
            -V|-v|-version)
                print_version
                exit 0
                ;;
            -U|-u|-update)
                echo
                git clone https://github.com/yonasuriv/bifrost.git > /dev/null 2>&1 && cd bifrost && sh BuildBifrostBridge > /dev/null 2>&1
                echo "\033[1;32m Bifrost Link successfully updated to the last version: $version\033[0m"
                exit 0
                ;;
            -P|-p)
                shift  # Consume the -p flag
                if [ $# -eq 0 ]; then
                    projects_menu
                fi
                project_name="$1"
                
                # Check if the folder already exists
                if [ -d "projects/$project_name" ]; then
                    echo
                    echo " $cyan2[PROJECT FOUND]$end Initializing $white$project_name$end."
                    sleep 3
                    cd "projects/$project_name"
                    target_prompt
                    start
                else
                    mkdir -p "projects/$project_name"
                    cd "projects/$project_name" || exit
                    echo "$green"
                    cp "../../.core/create_target.sh" "../../projects/$project_name/TARGET"
                    echo " $green2[PROJECT CREATED]$end Initializing $white$project_name$end."
                    sleep 2
                    target_prompt
                    start
                fi
                ;;
            -X|-x)
                echo
                dependencies
                exit 1
                ;;
            *)
                echo
                echo "Invalid argument. Use the $yellow2-h$end flag to see all the available commands."
                exit 1
                ;;
        esac
        shift
    done
}