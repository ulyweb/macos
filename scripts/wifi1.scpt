-- Function to get Wi-Fi info
on getWifiInfo()
    try
        set ssid to do shell script "networksetup -getairportnetwork en0 | awk -F': ' '{print $2}'"
    on error
        set ssid to "Unknown"
    end try
    
    try
        set signal to do shell script "system_profiler SPAirPortDataType | grep 'agrCtlRSSI' | awk '{print $2}'"
    on error
        set signal to "Unknown"
    end try
    
    try
        set linkSpeed to do shell script "system_profiler SPAirPortDataType | grep 'lastTxRate' | awk '{print $2}'"
    on error
        set linkSpeed to "Unknown"
    end try
    
    return {SSID:ssid, Signal:signal, LinkSpeed:linkSpeed}
end getWifiInfo

-- Get Wi-Fi info and display it
set currentWifi to getWifiInfo()
set wifiMessage to "SSID: " & currentWifi's SSID & return & "Signal Strength: " & currentWifi's Signal & return & "Link Speed: " & currentWifi's LinkSpeed
display dialog wifiMessage buttons {"OK"} default button "OK"
