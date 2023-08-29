find_dc_ip() {
    echo "$negative Find DC IP $end"
    echo
    echo "  1) $command Show domain name & DNS$dim nmcii dev show etc0$end"
    echo "  2) $command$dim nslookup -type=SRV _ldap.tcp.dc._msdcs. <domain>$end"
    echo
    echo "  9)    Exit$end"
    echo
    echo -n "  Choose one of the above options: "
    find_dc_ip_select
    }


find_dc_ip_select() {
    read selection
    echo "$white"
    case $selection in
        1) nmcii dev show etc0 ; echo "$end"; menu_return ;;
        2) nslookup -type=SRV _ldap.tcp.dc._msdcs. "$ip" ; echo "$end"; menu_return ;;
        9) credits;;
        0) legend;;
        *) incorrect_selection_number ; menu_return ;;
    esac
    }
