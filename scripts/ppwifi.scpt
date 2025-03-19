use framework "CoreWLAN"
use scripting additions

set ssid to "Not Available"
set ipAddress to "Not Available"
set macAddress to "Not Available"
set signalStrength to "Not Available"
set txRate to "Not Available"
set phyMode to "Not Available"
set channelNumber to "Not Available"

try
    -- Get Wi-Fi interface
    set wifiInterface to current application's CWWiFiClient's sharedWiFiClient()'s interface()
    
    if wifiInterface is not missing value then
        -- Get SSID
        try
            set ssid to (do shell script "networksetup -getairportnetwork en0 | cut -d ':' -f2 | sed 's/^ //'")
        end try
        
        -- Get other Wi-Fi information
        set signalStrength to (wifiInterface's rssiValue() as integer) & " dBm"
        set txRate to (wifiInterface's transmitRate() as integer) & " Mbps"
        set phyMode to wifiInterface's phyMode() as text
        set channelNumber to (wifiInterface's wlanChannel()'s channelNumber()) as integer
        
        -- Get IP and MAC addresses
        try
            set ipAddress to do shell script "ipconfig getifaddr en0"
            set macAddress to do shell script "ifconfig en0 | awk '/ether/{print $2}'"
        end try
    end if
end try

-- Build display text
set infoText to "SSID: " & ssid & return & ¬
    "IP Address: " & ipAddress & return & ¬
    "MAC Address: " & macAddress & return & ¬
    "Signal Strength: " & signalStrength & return & ¬
    "Tx Rate: " & txRate & return & ¬
    "PHY Mode: " & phyMode & return & ¬
    "Channel: " & channelNumber

display dialog infoText buttons {"OK"} default button "OK" with title "Wi-Fi Info"
