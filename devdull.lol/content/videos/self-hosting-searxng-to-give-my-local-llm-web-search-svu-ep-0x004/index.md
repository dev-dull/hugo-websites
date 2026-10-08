---
title: "Self-Hosting SearXNG to Give My Local LLM Web Search (SVU – Ep. 0x004)"
date: 2026-10-07T13:00:37+00:00
draft: false
showHeadingAnchors: true
showReadingTime: false
showDate: false
---

{{< youtube gs2mLL3FmiU >}}

## Description
The LLM I host in my homelab is completely cut off from the outside world. It’s a dual-Xeon box with an RTX 2080 running a local model I use every day, but it has no tools, so it’s basically frozen at its training cutoff.

So I fixed that. In this one I self-host **SearXNG** which is a private, keyless metasearch engine. I then wire it into **Open WebUI** so my local model can actually search the web while keeping my search history disconnected from my accounts.

It’s a from-scratch build: a locked-down `nologin` service user, Docker Compose, a systemd unit, and a config file or two that fought back. I fumble my way through an error parade near the end before finally getting it to tell me what the best Swiss cheese is.

⏱️ Chapters
0:00 My daily-driver AI has no tools
0:53 A Debian server on my Proxmox server
1:17 SSH in and fix the repos
2:02 Installing Docker
3:48 A locked-down (nologin) user
7:56 Writing the Compose file
16:41 settings.yml + a secret key
21:45 Wait, YAML *and* TOML?
23:30 A proper systemd service
25:33 The error parade
29:30 It’s alive: my own private search
30:15 Teaching Open WebUI to search
31:45 The Swiss cheese stress test
35:40 Victory (cheese + a drink)
37:22 Bloopers

📂 Example configurations: https://github.com/dev-dull/questionable_commands/tree/main/svu/06102026-0x004-searxng

🧰 What’s in the box
- SearXNG (self-hosted metasearch) - https://github.com/searxng/searxng
- Valkey (the cache/limiter backend) - https://valkey.io
- Open WebUI (the chat front-end) - https://github.com/open-webui/open-webui
- Qwen 3.6 35B (the local model) - https://qwenlm.github.io
- Proxmox VE - https://www.proxmox.com
- Debian - https://www.debian.org
- Docker Compose - https://docs.docker.com/compose/
- The host (“clode”): dual Xeon V4 (LGA 2011), 128GB RAM, RTX 2080

💬 What tool are you trying to give your local model next — web search, code execution, something weirder? Tell me in the comments.

👍 If you self-host and like watching things *almost* go smoothly, subscribe — your support buys the parts for the next build.

❤️ Patreon: https://www.patreon.com/cw/Questionable_Commands

#homelab #selfhosted #SearXNG #LocalLLM #Proxmox #Qwen #OpenWebUI #Docker #privacy
