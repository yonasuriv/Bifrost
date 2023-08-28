#!/bin/bash

target_domain() {
    # Check if the target variable is empty
    if [ -z "$target_domain" ]; then
        printf " Enter the target domain or IP address/range: $red" && read target_domain
        echo "$end"
        case "$target_domain" in
            http://*|https://*)
                url="$target_domain"
                ;;
            *)
                while true; do
                    printf " Does the target use a secure protocol (https)? $dim[Y/n]$end: " && read input
                    case "$input" in
                        "y" | "Y" | "1" | "")
                            url="https://$target_domain"
                            break
                            ;;
                        "n" | "N" | "2" | "")
                            url="http://$target_domain"
                            break
                            ;;
                        *)
                            echo "Please enter 'y' for yes or 'n' for no."
                            ;;
                    esac
                done
                ;;
        esac
    fi

    echo
    echo "$yellow Establishing the bridge with the target"
    echo

    # Rest of your code for pinging and establishing the link
    ping -c 3 "$target_domain" > /dev/null 2>&1

    # Check the exit status of the ping command
    if [ $? -eq 0 ]; then
        echo "$green Link Established"
        sleep 4
        refresh_cp
    else
        echo "$red Link Failed. Trying again.."
        sleep 4
        #target=""
        refresh
        target
    fi
}

target_username() {
    echo "$cyan2"

    # Check if the target username variable is empty
    if [ -z "$target_username" ]; then
        printf "$cyan Enter the target username (if any), press [ENTER] to skip: $end" && read target_username
        echo
    fi
}

target_password() {
    echo "$cyan2"

    # Check if the target password variable is empty
    if [ -z "$target_password" ]; then
        printf "$cyan Enter the target password (if any), press [ENTER] to skip: $end" && read target_password
        echo
    fi
}

target_data() {
    # Check if the TARGET file exists
    if [ -f "./TARGET" ]; then
        # Source (include) the TARGET file to set the variables
        . "./TARGET"
        echo
        project_folder="$(basename "$PWD")"

        if [ "$project_folder" = "tmp" ]; then
            echo " Project:  $yellow2$project_folder$end"
        else
            echo " Project:  $green2$project_folder$end"
        fi

        # Check if target_domain exists and print it
        if [ -n "$target_domain" ]; then
            echo " Domain:   $red$target_domain$end"
        fi

        # Check if target_username exists and print it
        if [ -n "$target_username" ]; then
            echo " Username: $red$target_username$end"
        fi

        # Check if target_password exists and print it
        if [ -n "$target_password" ]; then
            echo " Password: $red$target_password$end"
        fi
    else
        # If TARGET file doesn't exist, print a message
        tmp    
        target_data 
    fi
}
