legend() {
        echo "$negative Legends $end"
        echo
        echo "  🔥$green2 Very common and efficient technique (quick win)"
        echo "  ⚠️$red2  Dangerous (could break stuff)$end"
        echo "  ⚪$dim Command"
        echo 
        echo "  $bloodhound " # Bloodhound
        echo "  $powerview " # PowerView
        echo "  $impacket " # Impacket
        echo "  $crackmapexec " # CrackMapExec
        echo "  $certipy " # Certipy
        echo "  $metasploit " # Metasploit
        echo "  $windows_tool $end" # Windows Tool
        echo
        echo -n "  You can still interact with the menu. Choose one of the menu options to continue: "
    }

legend_banner () {
    hot="🔥"
    dangerous="⚠️"
    command="⚪"
    bloodhound="🔴$greybgred BloodHound $end"
    powerview="🟡$greybgyellow PowerView $end"
    impacket="🟣$greybgpurple Impacket $end"
    crackmapexec="🟢$greybggreen CrackMapExec $end"
    certipy="🔵$greybgblue Certipy $end"
    metasploit="🦠$greybgwhite Metasploit $end"
    windows_tool="🪟$greybgcyan WindowsTool $end"

    skip="  "
    }

# Activate the legend (visual)
legend_banner 
