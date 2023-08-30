#!/bin/sh

origin=~/.local/share/Bifrost

# Styles
. $origin/.assets/style.sh

# Menu
. $origin/.menu/main.sh
. $origin/.menu/network-scan.sh
. $origin/.menu/find-dc-ip.sh
. $origin/.menu/zone-transfer.sh
. $origin/.menu/list-guest-access-smb-share.sh
. $origin/.menu/find-user-list.sh
. $origin/.menu/poisoning.sh
. $origin/.menu/coerce.sh

# Info
. $origin/.info/logo.sh
. $origin/.info/credits.sh
. $origin/.info/legend.sh

# Core
. $origin/.core/dependencies.sh
. $origin/.core/target.sh
. $origin/.core/arguments.sh

. $origin/.core/CONTROL

bifrost_link() {
    #sudoreq
    clear
    logo
    target_data
    menu
    menu_select
}
