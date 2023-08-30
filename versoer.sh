#!/bin/sh

end="\033[0m"
dim="\033[2m"
white="\033[0;37m"
green2="\033[1;32m"
red2="\033[1;31m"
cyan2="\033[1;36m"
yellow2="\033[1;33m"

# User-Defined path to the control file
control_file_path="CONTROL.sh"

# Check if the control file exists at the specified path
if [ ! -f "$control_file_path" ]; then
    echo "$red2 Control file not found at: $control_file_path$end"
    exit 1
fi

# Read the version from the control file
version=$(grep 'version=' "$control_file_path" | awk -F '"' '{print $2}')

current_version () {
    echo
    echo " Bifrost Link version $version"
    echo
}
current_version
# Ask for user input for REASON and level
printf " Commit Message    : $yellow2" && read reason
echo
printf "$end Update Level $dim[3-1]$end: $cyan2" && read level
printf "$end"
echo
#echo "$end"

# Split the version into its three components
IFS='.' read -ra version_parts <<< "$version"
third_level="${version_parts[0]}"
second_level="${version_parts[1]}"
first_level="${version_parts[2]}"

# Update the version based on the specified level (swapped assignments)
case $level in
    1)
        # Increment the first level by 1
        first_level=$((first_level + 1))
        ;;
    2)
        # Increment the second level by 1 and reset the first level to 0
        second_level=$((second_level + 1))
        first_level=0
        ;;
    3)
        # Increment the third level by 1 and reset the second and first levels to 0
        third_level=$((third_level + 1))
        second_level=0
        first_level=0
        ;;
    *)
        echo "Invalid level specified. Level must be 1, 2, or 3."
        exit 1
        ;;
esac

# Check for overflow and increment rows on the left
if [ "$first_level" -ge 100 ]; then
    second_level=$((second_level + 1))
    first_level=0
fi
if [ "$second_level" -ge 100 ]; then
    third_level=$((third_level + 1))
    second_level=0
fi

# Construct the new version as a string
new_version="${third_level}.${second_level}.${first_level}"

# Update the version in the control file
sed -i "s/version=\"$version\"/version=\"$new_version\"/" "$control_file_path"



# Commit changes to Git
git add . && git commit -m "$reason" && git push > /dev/null 2>&1

echo $version
