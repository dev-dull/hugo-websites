#!/usr/bin/env python3
"""Sync new videos from a YouTube channel RSS feed into the Hugo site.

For every video in the feed that isn't already on the site, write a new page
bundle at devdull.lol/content/videos/<slug>/index.md matching the existing
front-matter schema. Idempotent: videos are matched by their YouTube ID (the
argument to the `{{< youtube ID >}}` shortcode), NOT by slug or title, so
re-running only ever adds genuinely-new videos and never disturbs the slugs,
titles, or descriptions you've curated by hand.

The generated entries are a *starting draft* -- slug, title, description, and
date are all things you typically curate -- so they're marked `draft: true`.
(Note: this site sets buildDrafts=true, so that flag does NOT hide them once
merged; the real gate is reviewing the PR before it reaches main.)

Usage:
    bin/yt-sync.py [--feed URL] [--dry-run]
"""

import argparse
import os
import re
import sys
import urllib.request
import xml.etree.ElementTree as ET

DEFAULT_FEED = (
    "https://www.youtube.com/feeds/videos.xml"
    "?channel_id=UCEQngyGaouaoleaXcjd2iog"
)

NS = {
    "atom": "http://www.w3.org/2005/Atom",
    "yt": "http://www.youtube.com/xml/schemas/2015",
    "media": "http://search.yahoo.com/mrss/",
}

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
VIDEOS_DIR = os.path.join(REPO_ROOT, "devdull.lol", "content", "videos")

# Matches the ID in `{{< youtube ID >}}` (and the paired `{{</ youtube >}}` form).
SHORTCODE_RE = re.compile(r"{{<\s*youtube\s+([A-Za-z0-9_-]+)")


def fetch_feed(url):
    req = urllib.request.Request(url, headers={"User-Agent": "yt-sync/1.0"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return resp.read()


def existing_video_ids():
    """Every YouTube ID already referenced anywhere under content/videos."""
    ids = set()
    for dirpath, _dirs, files in os.walk(VIDEOS_DIR):
        for name in files:
            if not name.endswith(".md"):
                continue
            with open(os.path.join(dirpath, name), encoding="utf-8") as fh:
                ids.update(SHORTCODE_RE.findall(fh.read()))
    return ids


def slugify(text):
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    return text.strip("-") or "video"


def yaml_quote(text):
    """A YAML double-quoted scalar (titles can contain quotes/colons)."""
    return '"' + text.replace("\\", "\\\\").replace('"', '\\"') + '"'


def parse_entries(xml_bytes):
    root = ET.fromstring(xml_bytes)
    entries = []
    for entry in root.findall("atom:entry", NS):
        vid = entry.findtext("yt:videoId", namespaces=NS)
        if not vid:
            continue
        title = (entry.findtext("atom:title", namespaces=NS) or "").strip()
        published = (entry.findtext("atom:published", namespaces=NS) or "").strip()
        desc = entry.findtext("media:group/media:description", namespaces=NS) or ""
        entries.append(
            {"id": vid, "title": title, "published": published, "desc": desc.strip()}
        )
    return entries


def render(entry):
    return (
        "---\n"
        f"title: {yaml_quote(entry['title'])}\n"
        f"date: {entry['published']}\n"
        "draft: true\n"
        "showHeadingAnchors: true\n"
        "showReadingTime: false\n"
        "showDate: false\n"
        "---\n\n"
        f"{{{{< youtube {entry['id']} >}}}}\n\n"
        "## Description\n"
        f"{entry['desc']}\n"
    )


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--feed", default=os.environ.get("YT_FEED_URL", DEFAULT_FEED))
    ap.add_argument(
        "--dry-run",
        action="store_true",
        help="List what would be added without writing any files.",
    )
    args = ap.parse_args()

    try:
        feed = fetch_feed(args.feed)
    except Exception as exc:  # noqa: BLE001 - surface any fetch/parse failure clearly
        print(f"error: could not fetch feed: {exc}", file=sys.stderr)
        return 1

    have = existing_video_ids()
    entries = parse_entries(feed)
    new = [e for e in entries if e["id"] not in have]

    if not new:
        print("No new videos. Site is up to date with the feed.")
        write_summary("No new videos. Site is up to date with the feed.")
        return 0

    taken = set()
    report = [f"Added {len(new)} new video(s):"]
    for entry in new:
        base = slugify(entry["title"])
        slug = base
        n = 2
        while slug in taken or os.path.exists(os.path.join(VIDEOS_DIR, slug)):
            slug = f"{base}-{n}"
            n += 1
        taken.add(slug)

        bundle = os.path.join(VIDEOS_DIR, slug)
        report.append(f"  - {slug}  ({entry['id']})  {entry['title']}")
        if args.dry_run:
            continue
        os.makedirs(bundle, exist_ok=True)
        with open(os.path.join(bundle, "index.md"), "w", encoding="utf-8") as fh:
            fh.write(render(entry))

    text = "\n".join(report)
    print(text + ("\n\n(dry run -- nothing written)" if args.dry_run else ""))
    write_summary(text)
    return 0


def write_summary(text):
    path = os.environ.get("GITHUB_STEP_SUMMARY")
    if path:
        with open(path, "a", encoding="utf-8") as fh:
            fh.write(text + "\n")


if __name__ == "__main__":
    sys.exit(main())
