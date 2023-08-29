legend() {
        echo "$negative Legends $end"
        echo
        echo "  $hot$green2 Very common and efficient technique (quick win)"
        echo "  $dangerous$red2  Dangerous (could break stuff)$end"
        echo "  $dim$command Command"
        echo 
        echo "  $bloodhound Bloodhound"
        echo "  $powerview PowerView"
        echo "  $impacket Impacket"
        echo "  $crackmapexec CrackMapExec"
        echo "  $certipy Certipy"
        echo "  $metasploit Metasploit"
        echo "  $windows_tool Windows Tool$end"
        echo
        echo -n "  You can still interact with the menu. Choose one of the menu options to continue: "
    }

legend_visual () {
    hot="🔥"
    dangerous="⚠️"
    command="⚪"
    bloodhound="🔴"
    powerview="🟡"
    impacket="🟣"
    crackmapexec="🟢"
    certipy="🔵"
    metasploit="🦠"
    windows_tool="🪟"

    skip="  "
    }

legend_banner () {
    hot="🔥"
    dangerous="⚠️"
    command="⚪"
    bloodhound="$greybgred BloodHound $end"
    powerview="$greybgyellow PowerView $end"
    impacket="$greybgpurple Impacket $end"
    crackmapexec="$greybggreen CrackMapExec $end"
    certipy="$greybgblue Certipy $end"
    metasploit="$greybgwhite Metasploit $end"
    windows_tool="$greybgcyan WindowsTool $end"

    skip="  "
    }

# Activate the version of the legend you want to see [visual/banner]
#legend_visual
legend_banner 
