---
title: "I let an AI take over my new Proxmox server (It went badly) (Homelab - Ep. 0x008)"
date: 2026-09-24T02:44:00+00:00
draft: false
showHeadingAnchors: true
showReadingTime: false
showDate: false
---

{{< youtube UZ8tD8UJQRU >}}

## Description
A chill build with a not-so-chill payoff.

I put together a tiny Minisforum Proxmox box, tell a few stories from a recent trip to Berlin, and then hand the keys to the new server to Stakpak, an open-source AI "DevOps agent" that promises to run your infrastructure on autopilot. I didn't realize that the build was the easy part.

⏱ Chapters (timestamps pinned to ~±15s from a frame sweep — spot-check before publishing)
0:00  The plan: one chill build
0:25  Building the Minisforum Proxmox box (with Berlin stories)
8:15  Enter Stakpak — installed in a sandbox VM
10:00 Wiring it up (and a local-model cameo)
12:20 Letting it loose on the VM
17:45 The errors start
20:00 Fighting it: PATH conflicts, tokens, terraform
24:00 The "autopilot" never becomes healthy
26:20 The reckoning
28:40 Their pitch vs my reality
30:40 Verdict & outro

🔧 What's in the box
- Minisforum board (Ryzen mobile, soldered) → Proxmox VE 9
- Stakpak (open-source agent), run contained in a VM: https://github.com/stakpak/agent
- Proxmox VE: https://www.proxmox.com/
- Pointed at hosted models (Groq, Gemini); the local box (clode running Qwen3.6-35B) makes a cameo

💬 Did you get an AI agent to actually DO something useful in your homelab? Tell me
what I should've tried differently? I'm genuinely curious if I was using Stakpak wrong somehow.

👉 Subscribe for more questionable commands: cheap hardware, self-hosting, and dev tooling pushed past where it wants to go.

🎶 Music:
In The Morning, by The Grey Room / Clark Sims
https://www.youtube.com/channel/UCGm39mho4T9_A8X3EshV7fg
https://www.youtube.com/channel/UCGm39mho4T9_A8X3EshV7fg
