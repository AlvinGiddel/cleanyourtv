# TV Debloat & Custom Launcher Guide (TCL Smart TV - G10)

This guide documents the changes made to your TCL Smart TV (Model: G10, Android 12 Google TV) and how to manage, customize, or restore everything.

---

## 1. Summary of Changes

- **Debloating**:
  - Disabled background telemetry, store demos, and unused TCL system services (`com.tcl.exhibit`, `com.tcl.channelplus`, `com.tcl.interactive`, `com.tcl.smartlink.core`, etc.).
  - Disabled advertising, preloaded prompts, and voice analytics (`com.google.android.katniss`, `com.google.android.feedback`, `gtvpai`).
  - Switched private DNS to AdGuard DNS (`dns.adguard-dns.com`) for network-wide ad blocking.
  - Configured screensaver to Apple Dark Clock (`com.gathin.tvhome/.ClockDream`): minimal drifting clock and date on OLED-safe black background with ambient glow, waking up immediately on any remote key press.
- **Apple TV-Style Launcher**:
  - Replaced stock Google TV launcher (`com.google.android.apps.tv.launcherx`) and setup wizard (`com.google.android.tungsten.setupwraith`) with `com.gathin.tvhome`.
  - Configured 4 dock slots: **Apple TV**, **Netflix**, **YouTube**, **Spotify**.
  - Enabled dynamic ambient glow, translucent frosted glass dock band, and top bar pills for Inputs, Wi-Fi, and Settings.
  - Retained Live TV input framework integration (`com.tcl.tv`).

---

## 2. How to Re-enable Any App or Service

All packages were **disabled, never uninstalled**. To re-enable any package individually, run via PowerShell:

```powershell
$env:TV_HOST = "192.168.0.103"
tools\venv\Scripts\python tools/tv.py "pm enable <package-name>"
```

### Examples:
- **Chromecast / Media Shell**:
  ```powershell
  tools\venv\Scripts\python tools/tv.py "pm enable com.google.android.apps.mediashell"
  ```
- **Google Assistant / Voice Search**:
  ```powershell
  tools\venv\Scripts\python tools/tv.py "pm enable com.google.android.katniss"
  ```
- **Miracast / Screen Mirroring**:
  ```powershell
  tools\venv\Scripts\python tools/tv.py "pm enable com.tcl.miracast"
  ```
- **AirPlay 2**:
  ```powershell
  tools\venv\Scripts\python tools/tv.py "pm enable com.tcl.airplay2"
  tools\venv\Scripts\python tools/tv.py "pm enable com.realtek.airplay2"
  ```
- **TCL Media Center (USB Drive Player)**:
  ```powershell
  tools\venv\Scripts\python tools/tv.py "pm enable com.tcl.ui_mediaCenter"
  ```

---

## 3. How to Restore Everything Back to Stock

To completely revert all changes, restore all debloated packages, and switch back to the stock Google TV launcher, simply run:

### On Windows (PowerShell):
```powershell
.\restore-debloat.ps1
```

### On macOS / Linux (Bash):
```bash
TV_HOST=192.168.0.103 ./restore-debloat.sh
```

---

## 4. How to Change Dock Apps, Order, or Layout

1. Open [launcher/app/src/main/res/values/config.xml](file:///c:/Users/mutuk/OneDrive/Desktop/tv%20debugging/launcher/app/src/main/res/values/config.xml).
2. Edit the `<string-array name="dock_apps">` section to add, remove, or reorder app package names:
   ```xml
   <string-array name="dock_apps">
       <item>com.apple.atve.androidtv.appletv</item>
       <item>com.netflix.ninja</item>
       <item>com.google.android.youtube.tv</item>
       <item>com.spotify.tv.android</item>
   </string-array>
   ```
3. To change the number of columns, change `<integer name="columns">4</integer>`.
4. Rebuild and install:
   ```powershell
   cd launcher
   .\build-and-install.ps1 -TvHost 192.168.0.103 -HomeKeyService -RestoreKeyServices
   ```

---

## 5. How to Change Themes or Wallpapers

You can apply ready-made themes from the `themes/` directory without rebuilding the APK:

### Apply a theme (e.g., Aurora or Glass):
```powershell
tools\venv\Scripts\python tools/theme.py themes/glass
```
or reset back to the built-in configuration:
```powershell
tools\venv\Scripts\python tools/theme.py --reset
```

To set a custom wallpaper, drop a 1920x1080 JPEG image named `wallpaper.jpg` into your theme folder or push directly using `theme.py`.

---

## 6. Closing ADB / Securing Your TV

Now that setup is complete, it is recommended to turn off ADB debugging on your TV for security:
1. On your TV remote, go to **Settings → System → About**.
2. Go to **Developer options**.
3. Turn **OFF** **USB debugging** and **Network/ADB debugging**.
4. Select **Revoke USB debugging authorizations**.
5. Restart your TV.
6. Verify that port 5555 is closed by running:
   ```powershell
   tools\venv\Scripts\python tools/adb-closed.py 192.168.0.103
   ```
