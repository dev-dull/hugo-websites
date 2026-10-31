---
title: "I wired Claude Code to a SNES controller and it played SimCity (Classic Computing - Ep. 0x002)"
date: 2026-10-31T11:05:01+00:00
draft: false
showHeadingAnchors: true
showReadingTime: false
showDate: false
---

{{< youtube f2cLBiSWRyY >}}

## Description
Can an LLM play SimCity? Not through an emulator, not on a PC: the actual SNES cartridge, through
an actual controller. I have had this idea stuck in my head for weeks, so this episode is the whole
build: a field trip for the cart, a Retro Duo that smells like a thrift store, controller surgery
with ten NPN transistors, an HDMI-to-CSI bridge that died on the bench, and Claude Code installed
on a Raspberry Pi 4 and told to write every tool it needs. Then I hit reset and let it play.

It does play. How well, where it puts the power plant, and why it decided it was finished are all
in the back half. Stick around for the verdict, and for Dr. Wright.

Chapters:
0:00 The idea that would not go away
0:36 Spooky season field trip
2:11 The game plan
3:57 Unboxing the Retro Duo
5:54 Does the controller even work?
9:32 Controller surgery: test pads and ten transistors
11:14 Pressing Start with a wire
12:53 Dead bridge, spare bridge, blinky lights
14:18 Teaching the Pi to see
17:03 Installing Claude Code on a Raspberry Pi
19:30 Claude, build your own tools
29:05 Twelve minutes of cooking
30:11 The prep-game and play-game skills
34:45 Blinky lights and an RTSP stream into OBS
36:42 Claude plays SimCity
41:06 The verdict
43:43 What game should it play next?
44:44 Bloopers

What's in the box:
- SimCity (SNES, 1991) on cartridge, from the local retro game store
- Retro-Bit Retro Duo (NES + SNES clone console, composite out): https://retro-bit.com
- Benfei composite-to-HDMI adapter, set to 720p
- Raspberry Pi 4 Model B: https://www.raspberrypi.com/products/raspberry-pi-4-model-b/
- Auvidea B101 HDMI-to-CSI-2 bridge (TC358743): https://auvidea.eu
- Ten NPN transistors (2N3904 / PN2222A), ten 1kΩ resistors, LEDs, a breadboard, and a clone SNES controller that did not survive intact
- Claude Code: https://claude.com/claude-code
- OBS Studio, pulling the Pi's RTSP stream: https://obsproject.com
- All the code and notes: https://github.com/dev-dull/questionable_commands

Which game should the rig play next, and which model should play it? NES or SNES, turn-based or
slow, shoulder buttons are coming. Tell me in the comments.

If cheap hardware doing things it should not is your idea of a good time, subscribe.

❤️ Patreon: https://www.patreon.com/cw/Questionable_Commands

🕹️ GitHub Repo: https://github.com/dev-dull/questionable_commands/tree/main/cc/30102026-0x002-AI_plays_snes

#SimCity #SNES #RaspberryPi #ClaudeCode #AI #Homelab #RetroGaming #Electronics
