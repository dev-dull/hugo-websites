---
title: 'DevOps Your Job Hunt with GitHub Actions and the Google Gemini API as a Fast-Feedback Loop'
date: 2025-03-26T00:00:00-08:00
draft: false
showHeadingAnchors: true
showReadingTime: true
showDate: true
---

## Start at the beginning: DevOps Your Résumé
Back in 2016, I had just moved to the Portland Oregon area and was looking to reboot my tech career after taking about a year to explore other opportunities creating video content. I was still fairly new to the city and as a result, I didn't have much of a job network yet, so when a friend of mine who had also relocated from Chicago put out the word that he was looking for people to help organize [DevOpsDays: Portland](https://devopsdays.org/events/2016-portland/welcome/), I jumped at the chance.

While some folks on the team had experience organizing events in the past, we didn't have any established relationships with vendors, we didn't have a venue identified yet, and most importantly we didn't know if we'd land any event sponsors. We were very much starting from scratch, and there was an unspoken agreement that we would operate as though we had a shoestring budget. With some recent video editing experience under my belt, I volunteered to run the camera to record the talks, edit the videos, and get them posted to [YouTube](https://www.youtube.com/watch?v=ajT90pC3ris&list=PLxOMkEM8CUn_JSfwj_DJJhOYOZp72NoQv) (my apologies for the audio quality on the linked 2016 videos). I had volunteered to help organize knowing that it was an amazing opportunity to build my local network, and bolster my resume, which were somewhat selfish reasons, and volunteering to handle the recording of all the talks had the side effect of making me watch _all_ the talks, even the ones I might have otherwise skipped. I was _NOT_ prepared for just how eye opening some of the talks would be (enormous kudos to all the speakers, and the event organizers who selected the speakers that year). My experience deserves to be an entire post on its own, but I'll say this much: If you think burnout is caused by working too hard, you're not wrong, but there are also bundle of other causes, and knowing what those causes are will only serve to help you in your career.

One of our speakers gave a short, five minute "lightning talk" by [Emily Dunham](https://edunham.net/) titled, "DevOpsing Your Resume" where she walked through her process of managing her resume using [LaTeX](https://en.wikipedia.org/wiki/LaTeX) and Git.

{{< youtube 71IPe7VnRbE >}}

I landed a position not long after helping to run the DevOpsDays: Portland event, but the talk and ideas stuck with me. Fast forward to 2021 and I found myself on the job hunt again and decided that getting my resume into a Git repository would go a very, _very_ long way to keeping all the variations on my resume organized. Following Emily's pattern, I started to learn LaTeX, but quickly realized that for a document as important as a resume, I needed to stick with technologies I know I'm comfortable with, so that when an opportunity suddenly pops up, I can crank out a variation on my resume tailored to that opening. As a result, I ended up formatting my resume in YAML and used Jinja templating to generate HTML files. This method had the distinct advantage of being able to register custom methods with Jinja to do operations like date math and enforcing consistent date formatting. Rendering the file as HTML allowed me to use plenty of `<div>` tags with `class="foo"` identifiers to manage the appearance with CSS. If for no other reason than its a good talking point in interviews, I'm of the opinion that you should find a workflow that works for you, and as a result, I hesitate to share my code that renders the HTML (and frankly, it needs an overhaul), but here's a scaffold of the YAML formatting I landed on which can give you a solid starting point.

```yaml
- html:
  - head:
    - title: Resume - Jeffrey "The Dude" Lebowski
    - style: '{{ add_style("style.css") }}'
  - body.resume:
    - div.whoami:
      - div.whoami_name: Jeffrey "The Dude" Lebowski
      - div.whoami_address: 609 Venezia Ave, Los Angeles, CA 90291
      - div.whoami_contact: (310)555-5309 - dude@LebowskiFoundation.org
    - div.summary:
      - div.section_title: Summary
      - div.summary_text: |
          Man, I'm like, a private investigator, you know? I've got skills, dude and have been fighting, like, crimes and stuff
          from {{ date_range("1998-03-06", "now") }} I can, like, solve mysteries and stuff. Okay, so maybe I don't always solve
          them on purpose, but I'm good at, you know, rolling with it. I've got experience with, uh, mistaken identities, ransom
          demands, and, like, really weird dudes.
    - div.experience:
      - div.section_title: Professional Experience
      - div.company_experience:
        - div.company_header:
          - div.company_name: Lebowski Foundation
          - div.company_location: Los Angeles, CA
          - div.company_dates: '{{ date_range("1998-03-06", "now") }}'
        - div.position:
          - div.position_header:
            - div.position_title: Private Investigator
            - div.company_dates: '{{ date_range("1998-03-06", "now") }}'
          - div.position_summary: Like, figured some stuff out like how that girl that ran away, like, she wasn't kidnapped man. Or, like how she actually just kidnapped herself, man.
          - ul.position_achievements:
            - li: Acquired new floor covering as, like, an interior design kind of thing.
            - li: Like, figured out that toe deal wasn't actually the toe of Lebowski's wife, man.
            - li: Got, like, almost second place in the First Annual Hollywood Star Lanes bowling tournament.
          - div.position_tools_header: Technology & Applications
          - div.position_tools:
            - div.position_tool: Brunswick's Vector Scoring System
            - div.position_tool: 14lb Brunswick Bowling Ball
            - div.position_tool: 1973 Gran Torino
    - div.education:
      - div.section_title: Education
      - div.education_details: 'Venice High School, Venice, CA'
      - div.education_dates: '{{ date_range("1994-09-01", "1995-10-11") }}'
```

## The now that's now now
Here we are in 2025
