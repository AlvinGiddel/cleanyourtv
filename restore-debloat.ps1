# Restoration script for TCL G10 Android TV debloat
$tv_host = if ($env:TV_HOST) { $env:TV_HOST } else { "192.168.0.103" }
$env:TV_HOST = $tv_host

$packages = @(
    "com.tcl.exhibit",
    "com.tcl.esticker",
    "com.tcl.ocean.instructions",
    "com.tcl.repairguide",
    "com.tcl.hearaid",
    "com.tcl.UpdatePeripheral",
    "com.tcl.hotelmenu",
    "com.tcl.channelplus",
    "com.tcl.tv.tclhome_passive",
    "com.tcl.partnercustomizer",
    "com.tcl.interactive",
    "com.tcl.smartlink.core",
    "com.tcl.waterfall.overseas",
    "com.tcl.usercenter",
    "com.tcl.useragreement",
    "com.tcl.messagebox",
    "com.tcl.smartalexa",
    "com.tcl.magiconnectfree",
    "com.tcl.t_solo",
    "com.tcl.guard",
    "android.autoinstalls.config.google.gtvpai",
    "com.google.android.feedback",
    "com.google.android.marvin.talkback",
    "com.google.android.apps.tv.dreamx",
    "com.google.android.tv.remote.service",
    "com.google.android.katniss",
    "com.google.android.apps.mediashell",
    "com.tcl.miracast",
    "com.tcl.airplay2",
    "com.realtek.airplay2",
    "com.google.android.apps.tv.launcherx",
    "com.google.android.tungsten.setupwraith"
)

Write-Host "Restoring packages on $tv_host..."
foreach ($pkg in $packages) {
    Write-Host "Enabling $pkg..."
    tools\venv\Scripts\python tools/tv.py "pm enable $pkg"
}

Write-Host "Restoring default screensaver and private DNS..."
tools\venv\Scripts\python tools/tv.py "settings put global private_dns_mode opportunistic"
tools\venv\Scripts\python tools/tv.py "settings put secure screensaver_components com.google.android.apps.tv.dreamx/.service.Backdrop; settings put secure screensaver_default_component com.google.android.apps.tv.dreamx/.service.Backdrop"
tools\venv\Scripts\python tools/tv.py "cmd package set-home-activity --user 0 com.google.android.apps.tv.launcherx/.home.HomeActivity"
Write-Host "Done! All debloated packages re-enabled and stock launcher restored."
