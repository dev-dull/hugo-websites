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

I landed a position not long after helping to run the DevOpsDays: Portland event, but the talk and ideas stuck with me. Fast forward to 2021 and I found myself on the job hunt again and decided that getting my resume into a Git repository would go a very, _very_ long way to keeping all the variations on my resume organized. Initially, I was following what Emily had done and to that end, I started to learn LaTeX. But I quickly realized that for a document as important as a resume, I needed to stick with technologies I know I'm comfortable with, so that when an opportunity suddenly pops up, I can crank out a variation on my resume tailored to that opening. As a result, I ended up formatting my resume in YAML to generate a Jinja template, and then and used Python generate an HTML from the template. This method had the distinct advantage of being able to register custom methods with Jinja to do operations like date math and enforcing consistent date formatting. Rendering the file as HTML allowed me to use plenty of `<div>` tags with `class="foo"` identifiers to manage the appearance with CSS. Similar to CaC (Configuration as Code) and IaC (Infrastructure as Code), I like to think of this process as, RaC, or Resume as Code.

I hesitate to share my code that renders the HTML partly because its been replaced by a step now performed by Gemini, and partly because having your own process can be a good talking point in interviews. But mostly, I'm of the opinion that you should find a workflow that works for you instead of trying to force yourself into my shoes. Instead, here's a scaffold of the YAML formatting I landed on which I hope can be a good launch pad to figuring out your process.

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
            - li: Placed, like, almost second in the First Annual Hollywood Star Lanes bowling tournament.
          - div.position_tools_header: Technology & Applications
          - div.position_tools:
            - div.position_tool: Brunswick's Vector Scoring System
            - div.position_tool: 14lb Brunswick Bowling Ball
            - div.position_tool: 1973 Gran Torino
    - div.education:
      - div.section_title: Education
      - div.education_details: 'Venice High School, Venice, CA'
      - div.education_dates: '{{ date_range("1960-09-01", "1962-10-11") }}'
```

## The now that's now now: DevOps Your Job Hunt
<!-- When does now happen? Not until later. -->
Here we are in 2025, I'm on the job hunt again, and there's been a wave of impressive new Artificial Intelligence technologies that are capable of interacting using natural language and can (appear to) intuit context. These tools have the ability to aid me in tackling some of the tasks I struggle with when applying to open positions by enabling me to apply DevOps principles to the job application process. To understand how I'm fitting these principles into my job search, it is helpful to look at a diagram of a DevOps workflow. Let's go through each of the steps in the diagram and apply them to my job hunt process.

<!-- Perplexity wrote (most of) this CSS for me -->
<img style="width: 100%; height: auto; border-radius: 40%; object-fit: cover; background: radial-gradient(circle, rgba(255,255,255,0.5) 0%, rgba(255,255,255,0) 70%); filter: brightness(1.2);" src="devoops.png">

### Plan
So, there's CaC, Configuration as Code as well as IaC, Infrastructure as Code. To use that as inspiration for what Emily stated in her talk, I suppose what we're doing here is RaC, or Resume as Code, and just like any codebase, you'll need to figure out what language and technologies you want to use as your code base. For Emily, that was LaTeX. For myself, the initial iteration on my process was YAML and Python which generated HTML and then used headless Chrome to render a PDF. Whatever workflow you might be envisioning as your process, I would encourage you to pick technologies you're already familiar with. You don't want to find yourself missing out on an amazing opportunity because you struggling to get your resume updated.

### Code
This is the step where you are going to write your resume in the format that best suits you and your chosen workflow. Because it is easier for me to pair down a resume than add new content to it, I dug deep and pulled out every version of my resume I could find in my email, in Google Docs, on job search platforms like Dice or LinkedIn, and anyplace else I could think of. I took all the best parts from each resume to create a monolithic version of my resume which

### Build
This is where we need to turn your RaC into a useable format and the first step where I've adopted AI into my workflow and to understand why I picked that route, it helps to take a look at my old process.

#### My _old_ automation
1. **Edit my RaC:** This usually involved abbreviating my oldest experience down to the company name, my title, and the dates I was in that position. I would then update position summaries to highlight relevant experience, and finally change the ordering in the `position_achievements` sections so that the most relevant ones were first.
1. **Render an HTML file:** In this step, I would run my Python script which parse my YAML file into an HTML file, and use the [PySpellChecker](https://pypi.org/project/pyspellchecker/) library to flag any issues.
1. **Review and repeat:** I found that seeing the file as rendered HTML instead of YAML gave me a perspective shift which allowed me to see a different kinds of punctuation and grammar errors which I would overlook as a YAML file, so I would make revisions and re-render the HTML.
1. **PDF-ify:** Once I was happy with the results, I would use a shell script that invoked [headless Chrome with the `--print-to-pdf` flag](https://developer.chrome.com/docs/chromium/headless#--print-to-pdf) to render a PDF file.

This process probably sounds pretty good, but in practice, it was a cumbersome side. It involved a lot of manual edits to the YAML and I eventually got to the point where it was easier to maintain two variants of my RaC, `resume_details.yaml` which was a complete list of my job history, and `resume_short.yaml` which was truncated as describe above. Of course, whenever you have two versions of something they are eventually going to suffer from a certain amount of "drift" and keeping the two files in sync became a task of its own.

### Test
There's multiple things that need to be tested here
Gemini looks things over (fast feedback -- go back to "Plan" if you're not happy with the results)

Use this as an opportunity to circle through a second iteration of the 'Dev' side in the 'DevOps' diagram, but don't forget that you also need to test (or practice) applying to positions as well. Your workflow might prove to be perfect for you, but if an online application form doesn't accept the format your resume is in, then you know that further changes need to be made to the workflow. Use these test applications as an opportunity to apply to submit some "moonshot" applications for jobs you want but don't expect to get, and to apply to places where you can get some practice interviews under your belt.

### Release
Depending on your workflow, this might mean a merge to the mainline branch. For me, this means opening an Issue to my resume repository for me to track my job application process.

### Deploy
Submit your application

### Operate
Put the changes you liked into your base resume

### Monitor
In my mind, this is the first and last step of the job hunt process and has two elements.

1. **Look for open positions --** Automating this step is difficult if for no other reason than most job listing aggregators have have locked down their pages. From my research, the most popular job aggregation websites removed the option to fetch a list of open roles starting in the year 2015 with LinkedIn, and one of the last being Dice in 2020 (note that the latest year I found was Jooble in 2022, but until the writing of this, I had never heard of the platform). Web scraping is still a potential avenue of automation, but likely violates terms of service, and even if that doesn't bother you, you'll probably end up having to figure out how to get around a CAPTCHA or two. All of that is probably more work than just sifting through some job listings, or better yet spending some time talking to people.
1. **Watch for responses to applications --** and for requests for you to apply
Although you could likely create some automations around email monitoring or even phone call screening, you're probably not getting such a high volume of messages that you need special tooling to handle it. The worst you'll get likely get here are messages from 3rd party recruiters and even then the risk of, [alert fatigue](https://en.wikipedia.org/wiki/Alarm_fatigue) is low.

Overall, my attitude here is that there's room for automation, but about the best I'd be able to create is effectively reply bot, and even if I added some AI dark magic to bot, responding myself seems much more likely to get me to the next step of the interview process.
