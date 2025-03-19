use framework "CoreWLAN"
use scripting additions

set wifiInterface to current application's CWWiFiClient's sharedWiFiClient()'s interface()

if wifiInterface is not missing value then
    set ssid to (wifiInterface's ssid() as text) or "Not Available"
    set signalStrength to wifiInterface's rssiValue() as integer
    set linkSpeed to wifiInterface's transmitRate() as integer
    
    set infoText to "SSID: " & ssid & return
    set infoText to infoText & "Signal Strength: " & signalStrength & " dBm" & return
    set infoText to infoText & "Link Speed: " & linkSpeed & " Mbps"
    
    display dialog infoText buttons {"OK"} default button "OK" with title "Wi-Fi Connection Info"
else
    display dialog "No Wi-Fi connection available." buttons {"OK"} default button "OK" with title "Wi-Fi Connection Info"
end if
