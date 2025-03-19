use framework "CoreWLAN"
use scripting additions

try
    set wifiClient to current application's CWWiFiClient's sharedWiFiClient()
    set wifiInterface to wifiClient's interface()
    
    if wifiInterface is missing value then error "No Wi-Fi interface"
    
    -- Get Wi-Fi information from CoreWLAN
    set ssid to "Not Connected"
    try
        if (wifiInterface's ssid() is not missing value) then
            set ssid to wifiInterface's ssid() as text
        end if
    end try
    
    set signalStrength to wifiInterface's rssiValue() as integer
    set txRate to wifiInterface's transmitRate() as integer
    set phyMode to wifiInterface's phyMode() as text
    set channelNumber to (wifiInterface's wlanChannel()'s channelNumber()) as integer
    
    -- Get network addresses using shell commands
    try
        set ipAddress to do shell script "ipconfig getifaddr en0"
    on error
        set ipAddress to "N/A"
    end try
    
    try
        set macAddress to do shell script "ifconfig en0 | awk '/ether/{print $2}'"
    on error
        set macAddress to "N/A"
    end try
    
    -- Build display text
    set infoText to "SSID: " & ssid & return & ¬
        "IP Address: " & ipAddress & return & ¬
        "MAC Address: " & macAddress & return & ¬
        "Signal Strength: " & signalStrength & " dBm" & return & ¬
        "Tx Rate: " & txRate & " Mbps" & return & ¬
        "PHY Mode: " & phyMode & return & ¬
        "Channel: " & channelNumber
    
    display dialog infoText buttons {"OK"} default button "OK" with title "Wi-Fi Info"
    
on error errorMsg
    display dialog errorMsg buttons {"OK"} default button "OK" with title "Wi-Fi Error"
end try
