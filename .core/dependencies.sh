#!/bin/bash

sudoreq() {
    # Updates the OS packages repositories and asks for the sudo password to run all the dependencies
    if sudo -n true 2>/dev/null; then
    sudo apt update > /dev/null 2>&1
    else
        #echo
        echo -n "    $red2 This action requires elevated privileges.$end Please enter the " && sudo apt update > /dev/null 2>&1
        echo
    fi
    }

dependencies() {
    install="sudo apt install -y"

    # List of all commands needed.
    # Usage [Command Display Name]:[Command Install Name]
    command="Python 3: python3,
    Golang: golang-go,
    Network Mapper: nmap,
    CrackMapExec: cme,
    Server Message Block Client: smbclient,
    Network Manager Command-line Tool: network-manager,
    DNS Utils: dnsutils,
    Enum 4 Linux: enum4linux"


    # Function to print a progress bar
    print_progress_bar() {
        progress="$1"
        width="$2"

        # Ensure progress doesn't exceed 100%
        if [ "$progress" -gt 100 ]; then
            progress=100
        fi

        # Calculate the number of characters for the progress bar
        current=$((progress * width / 100))
        bar=$(printf "%0.s=" $(seq 1 "$current"))
        space=$(printf "%0.s " $(seq 1 "$((width - current))"))

        # Print the progress bar
        printf "\r  [ %s%s] %d%%" "$bar" "$space" "$progress"
    }

    # Function to install packages and update progress
    install_packages() {
        total_commands=$(echo "$command" | tr ',' '\n' | wc -l)
        current_command=1
        total_progress=0

        echo "$command" | tr ',' '\n' | while IFS=: read -r package_name install_name; do
            # Print the description
            echo
            echo "$cyan2  Setting up $package_name$end"
            echo

            if [ "$debug" = "true" ]; then
                # Execute the installation command and display its output
                $install "$install_name" 2>/dev/null | sed 's/^/  /'  # Added sed to display installation output with indentation
            else
                # Print the progress bar
                #echo -n "   "
                #print_progress_bar " $total_progress" 50

                # Execute the installation command in the background
                $install "$install_name" > /dev/null 2>&1 &

                # Capture the PID of the background process
                pid=$!

                # Monitor the background process and update progress
                while kill -0 "$pid" > /dev/null 2>&1; do
                    sleep 0.1
                    completed=$(ps -o pcpu= -p "$pid" | awk '{print int($1)}')
                    command_progress=$((completed / 2))
                    print_progress_bar "$command_progress" 50
                done

                # Wait for the process to complete
                wait "$pid"

                # Calculate the completion percentage for the current command
                command_progress=100
                print_progress_bar "$command_progress" 50

                # Print a newline to move the cursor to the next line
                echo
            fi

            # Update the total progress
            total_progress=$((current_command * 100 / total_commands))
            current_command=$((current_command + 1))
        done

        # Print "All dependencies (x) installed successfully" at the end
        echo
        echo "$green  All $green2($total_commands)$green dependencies were installed/updated successfully.$end"
        echo
    }

    # Ask for sudo password
    sudoreq

    # Ask for installation mode
    printf "  Choose installation mode (normal/debug) $white[default=normal]$end: "
    read -r mode

    # Set debug flag based on user's choice (default to normal)
    case "$mode" in
        "normal" | "1" | "n" | "N" | "")
            debug="false"
            selected_mode="Normal Mode"
            ;;
        "debug" | "2" | "d" | "D")
            debug="true"
            selected_mode="Debug Mode"
            ;;
        *)
            echo "Invalid mode. Choosing 'normal' as default."
            debug="false"
            selected_mode="Normal Mode"
            ;;
    esac

    # Print the selected mode
    echo " $cyan"
    echo "  [$selected_mode Selected]" | tr '[:lower:]' '[:upper:]$end'
    echo " $end"
    echo " $dim Starting to Install Bifrost Dependencies...$end"
    sleep 2

    # Install packages and show progress
    install_packages
 }