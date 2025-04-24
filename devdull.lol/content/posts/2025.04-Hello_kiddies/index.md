---
title: 'Hello, Skiddie. I will never give you up'
date: 2025-04-24T17:00:00-08:00
draft: false
showHeadingAnchors: true
showReadingTime: true
showDate: true
---

## We're no strangers to ~~love~~ PHP
I don't currently have any kind of stats or log analysis for this website, but I was getting curious if I was getting any kind of traffic to my site and I wasn't ready to dive into the world of website analysis tooling since I'm sure there's a whole mess of options out there, so I did the lazy thing and just did a `cat` on the log and _oh. my. lord._ I was NOT ready for what I found.

Just in a short `tail` of my log there were multiple entries of people trying to hit a variety of PHP endpoints. "I'm not running PHP." I thought to myself, as I briefly panicked, wondering how these endpoints could possibly exist. I very promptly realized, however, that the log was showing a `404` status code being returned for every PHP endpoint attempting to being accessed. Squinting a bit harder at the paths a common pattern emerged where the URLs also contained two letters many readers will know: W and P.

## You know ~~the rules~~ WordPress and so do I
The first thing I wanted to know was how much of my traffic are [script kiddies](https://en.wikipedia.org/wiki/Script_kiddie) (or skiddies) trying to alter my website so did a couple of quick line counts to get some back-of-the-napkin math.

```bash
user@bash$ cat web.log | grep -i php | wc -l
4100

user@bash$ cat web.log | wc -l
41994

user@bash$ awk "BEGIN {print 4100*100/41994}"
9.7633
```

Almost 10%. Big yikes.

## A full commitment's what I'm thinkin' of
I have absolutely zero qualms with trolling bad actors. My thinking is that the more time they waste on me, the less time they have disrupting the life of someone else. If you haven't caught on to my plan yet, let me fill you in: I'm going to rickroll the crap out of these skiddies.

## You wouldn't get this from any other guy
My first thought was to just change my `404` page to redirect, but hat has the complication of accidentally rickrolling folks if I ever screw up a link somewhere.

My next thought was to parse the logs, write a script that built all the paths, and symlink to an HTML file that contains a redirect, but my goodness, that would be an ugly mess of files that serve very little function.

## I just wanna tell ~~you~~ skiddies how I'm feeling
The common thread here is the nginx web server. Can I just configure it to handle all the PHP requests for me? A quick ask to [Perplexity](https://www.perplexity.ai/) says yes:

```
if ($request_uri ~ "\.php") {
  rewrite ^ https://rick.nerial.uk/? permanent;  # 301 redirect to homepage
}
```

## Gotta make you understand
I reloaded the configuration and went to my website. No ill effects! That's a good start. I picked the WordPress endpoint `/wp-includes/style-engine/about.php` at random and dropped it in at the end of my website's URL and promptly threw back my head and laughed. Success!

Don't give up! You can try it yourself. Just thrown an `index.php` at the end of my URL. It won't let you down, this isn't a run-around or a lie, and it can't hurt you.
