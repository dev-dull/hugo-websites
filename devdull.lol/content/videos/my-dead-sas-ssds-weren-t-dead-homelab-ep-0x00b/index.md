---
title: "My \"dead\" SAS SSDs weren't dead (Homelab – Ep. 0x00B)"
date: 2026-11-14T04:12:00+00:00
draft: false
showHeadingAnchors: true
showReadingTime: false
showDate: false
---

{{< youtube ZRoEfJai0kg >}}

## Description
I've got a pile of enterprise SAS SSDs that I wrote off as dead after installing them in my TrueNAS server. Time to find out how many still work.

My plan was to use a test rig out of spare parts, run every drive through an HBA, and if that failed, try some Dell interposers. If none of that worked, I'd open them up and go looking for a fuse to bridge. The plan fell flat when reality hit. Stick around for the six piles at the end, and for the part where I try to work out why I thought these were dead in the first place.

Chapters:
0:00 The TrueNAS server and a drive that isn't SATA
1:01 SAS vs SATA and the backplane gotcha
2:11 The plan: test, interposers, then surgery
2:50 Building the test rig
4:10 Power supply problems
6:24 Linux is up, known-good drives in
7:39 Montage: testing the pile
8:24 Six piles and a verdict
10:30 Why did I think they were dead?
13:32 Wrap up
13:55 Bloopers

What's in the box:
- TrueNAS: https://www.truenas.com/
- Pop!_OS on the test rig: https://pop.system76.com/
- sg3_utils (sg_format, sg_readcap): https://sg.danny.cz/sg/sg3_utils.html
- LSI SAS HBA in IT mode: https://www.broadcom.com/products/storage/host-bus-adapters
- Samsung SM1625 200 GB SAS SSDs (the pile): https://www.servethehome.com/samsung-sm1625-200gb-sas-ssd-quick-benchmarks/
- Dell drive sleds with interposers
- One 200 W power supply doing more than it should

Have you ever written off hardware that turned out to be fine? And if you know the real story about old HBAs and UNMAP on SAS SSDs, I want to hear it. Let me know in the comments.

Subscribe for more homelab builds, bad plans, and the occasional good outcome.

❤️ Patreon: https://www.patreon.com/cw/Questionable_Commands

#homelab #truenas #sas #ssd #zfs #selfhosted
