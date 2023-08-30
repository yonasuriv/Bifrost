#!/bin/bash

#. $origin/.core/CONTROL
. /home/kali/.xfiles/projects/bifrost/.core/CONTROL



version_fetch() {
    # Load the local version from the CONTROL file
    local_version=$(grep -o 'version="[^"]*"' /home/kali/.xfiles/projects/bifrost/.core/CONTROL | sed 's/version="//;s/"//')

    # Define the URL of the remote CONTROL file
    remote_url="https://raw.githubusercontent.com/yonasuriv/Bifrost/main/.core/CONTROL"

    # Function to fetch the remote version
    get_remote_version() {
        # Use curl to fetch the remote CONTROL file and extract the version value
        remote_version=$(curl -s "$remote_url" | grep -o 'version="[^"]*"' | sed 's/version="//;s/"//')
        echo "$remote_version"
    }

    # Compare the local and remote versions
    compare_versions() {
        local_version="$1"
        remote_version="$2"

        if [ "$local_version" = "$remote_version" ]; then
            echo "Local version ($local_version) is up to date."
        else
            echo "Local version ($local_version) is different from remote version ($remote_version)."
        fi
    }

    # Fetch the remote version
    remote_version=$(get_remote_version)

    # Compare the versions
    compare_versions "$local_version" "$remote_version"
    }