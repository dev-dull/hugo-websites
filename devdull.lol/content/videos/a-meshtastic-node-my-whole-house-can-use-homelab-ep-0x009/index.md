---
title: "A Meshtastic node my whole house can use (Homelab – Ep. 0x009)"
date: 2026-09-30T17:26:40+00:00
draft: false
showHeadingAnchors: true
showReadingTime: false
showDate: false
---

{{< youtube S18-JOuA4zA >}}

## Description
My Heltec T114's Bluetooth module died, so instead of tossing it out, I connected it to a Raspberry Pi via USB and installed Meshyface so I could use the mesh from a web browser. I then installed UPS hat for the Pi so the node never goes offline, and crammed the whole mess into a 3D-printed case that looks a lot tidier than its insides.

Featuring a box of half forgotten SBCs, a wiki that lied about a GPIO pin, and a dramatic re-enactment.

⏱ Chapters
0:00 The "magic smoke" reveal & the plan
1:28 Digging through the SBC box
4:36 Flashing the Pi
6:04 Booting up & finding the node over USB
6:55 Finding a web client (Meshyface)
8:23 Checking the prerequisites
9:51 Installing Meshyface
13:10 First run & the connection-refused fix
16:08 It works — messaging the mesh
17:00 Building the X728 UPS hat
20:23 Enabling I2C & the UPS service
23:47 Soft power-off & the wiki's wrong pin
26:04 Closing thoughts
27:00 Bloopers

🔧 What's in the box
- Heltec Mesh Node T114 (nRF52840)
- Meshyface (self-hosted web UI): https://github.com/jaronmcd/meshyface
- Meshtastic: https://meshtastic.org
- Geekworm X728 UPS hat: https://wiki.geekworm.com/X728

💬 Running a mesh node headless over USB too? Tell me what web UI you landed on.

#meshtastic #homelab #raspberrypi #selfhosted #lora #meshyface #homeserver
