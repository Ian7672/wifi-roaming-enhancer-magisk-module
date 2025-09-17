# WiFi Roaming Enhancer Ultimate

**Description:**
This Magisk module enhances your WiFi experience by enabling automatic **smart roaming**. It intelligently selects the best Access Point (AP) based on **RSSI** (signal strength), **latency**, and **bandwidth**, ensuring a **seamless** connection without dropping your internet. Perfect for **gaming**, **streaming**, and any activity that requires a stable connection.

**Key Features:**
- **Automatic Compatibility:** Auto-detects the WiFi interface for broad device compatibility.
- **Smart Roaming:** Automatically connects to the best available AP from your saved networks.
- **Optimized Selection:** Prioritizes APs with **high RSSI**, **low latency**, and **high throughput**.
- **Seamless Handoff:** Maintains your active connection while switching between APs.
- **Lightweight:** Runs as a shell daemon; no Xposed Framework required.
- **Customizable:** Features adjustable RSSI threshold and scanning intervals.

**Installation & Usage:**
1. Copy the `wifi-roaming-enhancer.zip` file to your device.
2. Open **Magisk Manager → Modules → Install from storage**.
3. Select the module's zip file → Install → Reboot.
4. The module will run automatically in the background, connecting to the best AP based on its calculated score.

**Configuration (Optional):**
- Modify `THRESHOLD` in `/data/adb/modules/wifi-roaming-enhancer/service.sh` to set the minimum RSSI level required to trigger a switch.
- Modify `SLEEP_TIME` in the same file to set the delay (in seconds) between scans.

**Important Notes:**
- This module only works with **saved networks** (networks your device has previously connected to).
- No logging is used to maximize performance and protect your privacy.
- A stable internet connection is recommended during initial testing.