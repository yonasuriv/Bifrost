#!/bin/bash

# Read the version from CONTROL file
version=$(awk -F ' ' '$1 == "Version:" { print $2 }' CONTROL)

# Ask for user input for REASON and level
read -p "Enter the REASON for the update: " reason
read -p "Enter the level of the update (1-3): " level

# Increment the version based on the specified level
case $level in
    1)
        # Increment the first row by 1
        new_version=$((version + 1))
        ;;
    2)
        # Increment the second row by 1 and reset the third row to 0
        new_version=$((version / 100 * 100 + (version % 100) + 1))
        ;;
    3)
        # Increment the first row by 1 and reset the second and third rows to 0
        new_version=$((version / 10000 * 10000 + (version % 10000) + 1))
        ;;
    *)
        echo "Invalid level specified. Level must be 1, 2, or 3."
        exit 1
        ;;
esac

# Update the CONTROL file with the new version
sed -i "s/Version: $version/Version: $new_version/" CONTROL

# Commit changes to Git
git add . && git commit -m "$reason" && git push
