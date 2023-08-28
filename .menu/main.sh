#!/bin/bash

refresh() {
    clear
    logo
    }

refresh_cp() { # refresh but with data kept
    refresh
    data
    menu
    }

menu () {
    echo
    echo
    echo "$negative Menu $end"
    echo
    echo "  1) Network Scan"
    echo "  2)$dim Find DC IP $end"
    echo "  3)$dim Zone Transfer $end"
    echo "  4)$dim List Guest Access on SMB Share $end"
    echo "  5)$dim Enumerate LDAP $end"
    echo "  6)$dim Find User List $end"
    echo "  7)$dim Poisoning $end"
    echo "  8)$dim Coerce $end"
    echo
    echo "  0) Exit"
    echo
    echo "  L) Show Legend"
    echo "  X) Install Dependencies"
    echo
    echo -n "     Choose one of the above options: "
    menu_select
    }

menu_select  () {
    read selection
    echo
    case $selection in
    1) network_scan;;
    2) refresh_cp;;
    3) refresh_cp;;
    4) refresh_cp;;
    5) refresh_cp;;
    6) refresh_cp;;
    7) refresh_cp;;
    8) refresh_cp;;
    0) credits; exit;;
    [Ll]) legend;;
    [Xx]) dependencies; menu_return;;
    *) error_menu ; menu_return;;
    esac
    }

menu_return (){
    while true; do
        read -p " Would you like to go back to the main menu? [Y/n] "  input
        case $input in
            "y" | "Y" | "1" | "")
                refresh_cp
                break
                ;;
            "n" | "N" | "2" | "")
                credits
                exit 1
                ;;
            *)
                echo
                error
                echo
                menu_select
        esac
    done
    }

error_argument() {
        echo -n "\033[2A\033[0K $red    Incorrect selection. Try again: $end"
        while true; do
            read -p ""  input
            case $input in
                [yY]*)
                    clear
                    logo
                    menu
                    break
                    ;;
                [nN]*)
                    clear
                    credits
                    exit 1
                    ;;
                *)
                    echo
                    error
                    menu
            esac
        done
        echo
        }

error_menu() {
        echo -n "\033[2A\033[0K $red    Incorrect selection. Try again: $end"
        menu_select
        echo
        }