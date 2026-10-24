---
title: "24/7 Halloween Movies on My Own Cable Channel (Homelab - Ep. 0x00A)"
date: 2026-10-24T10:55:03+00:00
draft: false
showHeadingAnchors: true
showReadingTime: false
showDate: false
---

{{< youtube Rtzp09ajE6E >}}

## Description
KTTY is back. Last time my homelab cable station was a loop: the Plex server watching its
own HDMI output come back through a tuner card. This time it gets a real channel with a
real schedule, something that plays at 3am whether or not anyone is watching.

The plan is over-engineered on purpose: ErsatzTV in a Podman container on a Proxmox VM
(my first Quadlet file), streaming to an Intel N100 mini PC, whose HDMI goes into the QAM
modulator, whose RF goes into the tuner card in Plex. Along the way the movies refuse to
show up, the filler needs a fallback for its fallback, a systemd service fails for the
dumbest possible reason, and halfway through the modulator config I find out which
frequencies the thing has been sitting on this whole time. That part is not a joke.

Also: the faceplate comes off in the first thirty seconds. Stick around to see why.

Chapters
0:00 Why the faceplate is coming off
0:25 Pulling KTTY out of the rack
5:50 The plan (yes, it is over-engineered)
6:57 Prepping the VM: apt, Podman, timezone, spoopy movies
10:14 My first Quadlet file
15:51 Starting ErsatzTV under Podman
20:10 FFmpeg profile: copy, don't transcode
22:21 "Path must exist" (it does)
25:33 Movies want subfolders: a shell loop
29:08 Collections, channel 2, and KTTY 2 Spoopy
31:29 Schedules, ads as filler, fallback filler
34:14 First playout, tested in QuickTime
35:04 The head end: an N100 named ktty-rx-n100
38:02 mpv: which HDMI port, which mode, which audio device
39:39 Into the DataTronix GUI
40:28 "I should not be doing this"
42:36 Moving to channels 8 and 9
43:42 Virtual channel 222.2 and a 7-character name
45:45 The ktty-head systemd service
50:40 Debugging the service
54:15 Plex rescan, and a guide in Spanish
55:34 It's playing. It's Metropolis. It's a paternoster.
57:09 Right on the half hour
58:10 Why the faceplate came off
59:31 Wrap up
1:00:09 Bloopers

What's in the box
- ErsatzTV (legacy v26.11.3): https://ersatztv.org
- Podman and Quadlet: https://podman.io
- mpv: https://mpv.io
- DataTronix DT-IPTV-QAM-ASI-4HC encoder/modulator: https://www.northamericancable.com
- Intel N100 mini PC as the head end
- Proxmox VE: https://www.proxmox.com
- Plex Live TV & DVR with a Hauppauge WinTV-HVR-1265 tuner card
- RabbitEars, for finding empty TV channels in your market: https://www.rabbitears.info
- Public domain features and ads from the Internet Archive and the Prelinger collection: https://archive.org

Have you ever found out a default setting was a lot worse than you thought? Tell me in the
comments so I feel better about this one.

If you enjoyed this, consider subscribing. There are three more HDMI inputs on that box.

❤️ Patreon: https://www.patreon.com/cw/Questionable_Commands

#homelab #ErsatzTV #Podman #Plex #QAM #cabletv #selfhosted #Halloween
