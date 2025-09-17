#!/system/bin/sh

# Auto detect WiFi interface
WIFI_IFACE=$(ip link show | grep -E 'wl|wlan' | awk -F: '{print $2}' | head -n1 | tr -d ' ')
[ -z "$WIFI_IFACE" ] && WIFI_IFACE="wlan0"

THRESHOLD=-70
SLEEP_TIME=10
PING_TARGET="8.8.8.8"

while true; do
    SCAN_RESULTS=$(wpa_cli -i $WIFI_IFACE scan_results 2>/dev/null)
    [ $? -ne 0 ] && sleep $SLEEP_TIME && continue

    BEST_SCORE=-999
    BEST_NET_ID=""
    BEST_SSID=""

    echo "$SCAN_RESULTS" | tail -n +2 | while read line; do
        BSSID=$(echo $line | awk '{print $1}')
        LEVEL=$(echo $line | awk '{print $3}')
        SSID=$(echo $line | awk '{print $5}')

        NET_ID=$(wpa_cli -i $WIFI_IFACE list_networks | grep "$SSID" | awk '{print $1}')
        [ "$NET_ID" = "" ] && continue

        # Latency test
        LATENCY=$(ping -c 1 -W 1 $PING_TARGET 2>/dev/null | tail -1 | awk -F '/' '{print $5}')
        [ "$LATENCY" = "" ] && LATENCY=999

        # Bandwidth mini test (1MB download)
        START=$(date +%s)
        curl -s --max-time 3 -o /dev/null http://speedtest.tele2.net/1MB.zip
        END=$(date +%s)
        DIFF=$((END-START))
        [ $DIFF -eq 0 ] && DIFF=1
        THROUGHPUT=$((1024 / DIFF)) # KB/s

        SCORE=$((LEVEL*2 - LATENCY + THROUGHPUT))

        [ $SCORE -gt $BEST_SCORE ] && BEST_SCORE=$SCORE && BEST_NET_ID=$NET_ID && BEST_SSID=$SSID
    done

    CURRENT_SSID=$(wpa_cli -i $WIFI_IFACE status | grep "^ssid=" | cut -d= -f2)

    if [ "$BEST_SSID" != "" ] && [ "$BEST_SSID" != "$CURRENT_SSID" ] && [ $BEST_SCORE -gt 0 ]; then
        wpa_cli -i $WIFI_IFACE select_network $BEST_NET_ID
    fi

    sleep $SLEEP_TIME
done
