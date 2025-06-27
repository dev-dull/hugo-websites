---
title: 'DevOps Your Job Hunt with GitHub Actions and the Google Gemini API For Fast-Feedback'
date: 2025-03-26T00:00:00-08:00
draft: false
showHeadingAnchors: true
showReadingTime: true
showDate: true
---

## Start at the beginning: DevOps Your Résumé
Back in 2016, I had just moved to the Portland Oregon area and was looking to reboot my tech career after taking about a year to explore other opportunities in video production. I was still fairly new to the city and as a result, I didn't have much of a job network yet, so when a friend of mine who had also relocated from Chicago put out the word that he was looking for people to help organize [DevOpsDays: Portland](https://devopsdays.org/events/2016-portland/welcome/), I jumped at the chance.

While some folks on the team had experience organizing events in the past, we didn't have any established relationships with vendors, we didn't have a venue identified, and most importantly, we didn't know if we'd land any event sponsors. We were very much starting from scratch, and there was an unspoken agreement that we would operate as though we had a shoestring budget. With some recent video editing experience under my belt, I volunteered to record the talks, edit the videos, and get them posted to [YouTube](https://www.youtube.com/watch?v=ajT90pC3ris&list=PLxOMkEM8CUn_JSfwj_DJJhOYOZp72NoQv) (my apologies for the audio quality on the linked 2016 videos).

<!-- I had volunteered to help organize knowing that it was a huge opportunity to build my local network and volunteering to handle the recording of all the talks had the side effect of requiring me watch _all_ the talks, even the ones I might have otherwise skipped. I was _NOT_ prepared for just how eye opening some of the talks would be (enormous kudos to all the speakers, and my peers on the organizing team who selected the speakers that year). My experience deserves to be an entire post on its own, but I'll say this much: If you think burnout is caused by working too hard, you're not wrong, but there are also a bundle of other causes, and knowing what those causes are will only serve to help you in your career. -->

<!-- Note 1: Emily was kind enough to review the post and submitted a revision to remove she/her, so if you're in the future and you're looking to update something, try to keep that preference in mind -->
One of our speakers was [Emily Dunham](https://edunham.net/) who gave a short, five minute "lightning talk" titled, "DevOpsing Your Resume" which walked through the process of managing a resume using [LaTeX](https://en.wikipedia.org/wiki/LaTeX) and Git.

{{< youtube 71IPe7VnRbE >}}

Now, I had landed a job not long after helping to run the DevOpsDays: Portland event, but the talk and ideas in it stuck with me. Fast forward to 2021 and I found myself on the job hunt again and decided that getting my resume into a Git repository would go a very, _very_ long way to keeping all the variations on my resume organized. Initially, I was following what Emily had done and to that end, I started to learn LaTeX. I quickly realized, however, that for a document as important as a resume, I needed to stick with technologies I was already comfortable with. This way, when an opportunity suddenly pops up, I can quickly modify my resume to target that specific opening. As a result, I ended up formatting my resume in YAML so it can be parsed by Python into HTML, and finally rendered by Jinja. This method had the distinct advantage of being able to register Python functions with Jinja to do operations like date math, and to enforcing consistent formatting for things like dates. The use of HTML allowed me to use `<div>` tags with `class="foo"` identifiers so I could manage the appearance with CSS.

Although I believe in open source and sharing code, I hesitate to share my code that renders the HTML. I believe that this is one of the rare instances where the experience of designing and using your own workflow will force you to iterate into a pattern that best suits you. If nothing else, it can be a good talking point in interviews. So, instead of giving you all the code for my end-to-end process, here's a scaffold of the YAML formatting I landed on, which I hope can be a good launch pad to figuring out a process that fits your needs.

{{% notice tip %}}
Update (June, 2025): For more an established standard, Check out the [JSON Resume schema website](https://jsonresume.org/schema), or visit their [GitHub page](https://github.com/jsonresume/jsonresume.org).
{{% /notice %}}

```yaml
- html:
  - head:
    - title: Resume - Jeffrey "The Dude" Lebowski
    - style: '{{ "style.css"|include_file }}'
  - body.resume:
    - div.whoami:
      - div.whoami_name: Jeffrey "The Dude" Lebowski
      - div.whoami_address: 609 Venezia Ave, Los Angeles, CA 90291
      - div.whoami_contact: (310)555-5309 - dude@LebowskiFoundation.org
    - div.summary:
      - div.section_title: Summary
      - div.summary_text: |
          Man, I'm like, a private investigator, you know? I've got skills, dude, and have been fighting, like, crimes and stuff
          for {{ (1998, 3, 6)|years_since }} years, man. I can, like, solve mysteries and stuff. Okay, so maybe I don't always solve
          them on purpose, but I'm good at, you know, rolling with it. I've got experience with, uh, mistaken identities, ransom
          demands, and, like, really weird dudes.
    - div.experience:
      - div.section_title: Professional Experience
      - div.company_experience:
        - div.company_header:
          - div.company_name: Lebowski Foundation
          - div.company_location: Los Angeles, CA
          - div.company_dates: '{{ (1998, 2)|date_range("Current") }}'
        - div.position:
          - div.position_header:
            - div.position_title: Private Investigator
            - div.company_dates: '{{ (1998, 3)|date_range("Current") }}'
          - div.position_summary: |
              Like, figured some stuff out like how that girl that ran away, like, she wasn't kidnapped man. Or, like how she actually just
              kidnapped herself, man.
          - ul.position_achievements:
            - li: Acquired new floor covering as, like, an interior design kind of thing.
            - li: Figured out that, like, the toe thing wasn't actually the toe of that girl, man.
            - li: Got, like, almost second place in the regional bowling tournament.
          - div.position_tools_header: Technology & Applications
          - div.position_tools:
            - div.position_tool: 14lb Brunswick Bowling Ball
            - div.position_tool: 1973 Gran Torino
            - div.position_tool: Brunswick's Vector Scoring System
        - div.position:
          - div.position_header:
            - div.position_title: Leisure Consultant
            - div.company_dates: '{{ (1998, 2)|date_range((1998, 3)) }}'
          - div.position_summary: |
              Told people, like, where to find the best burgers and places to bowl, man. And, like, how to score some, uh, sweet herbals.
          - ul.position_achievements:
            - li: Like, helped that artist lady with her, like, art project.
            - li: Got creative and made a, "White Russian" out of some stuff I found in the fridge.
          - div.position_tools_header: Technology & Applications
          - div.position_tools:
            - div.position_tool: 14lb Brunswick Bowling Ball
            - div.position_tool: 1973 Gran Torino
            - div.position_tool: Brunswick's Vector Scoring System
            - div.position_tool: Cream
            - div.position_tool: Kahlua
            - div.position_tool: Vodka
    - div.company_experience:
        - div.company_header:
          - div.company_name: In-N-Out Burger
          - div.company_location: Los Angeles, CA
          - div.company_dates: '{{ (1963, 2)|date_range((1963, 4)) }}'
        - div.position:
          - div.position_header:
            - div.position_title: Short Order Cook
            - div.company_dates: '{{ (1963, 2)|date_range((1963, 4)) }}'
          - div.position_summary: |
              Like, I don't CARE what Walter thinks, man. I had that fry station down to a science.
          - ul.position_achievements:
            - li: Cooked fries, to, like, absolute perfection, man.
            - li: Flipped burgers
            - li: Like, always skipped the ketchup unless they asked for it because, like, this is LA, not Pittsburgh.
          - div.position_tools_header: Technology & Applications
          - div.position_tools:
            - div.position_tool: Offset, high heat, laser-cut, Japanese steel spatula
    - div.education:
      - div.section_title: Education
      - div.education_details: 'Venice High School, Venice, CA - {{ (1960, 9)|date_range((1962, 10)) }}'
```

## The now that's now now: DevOps Your Job Hunt
<!-- When does now happen? Not until later. -->
Here we are in 2025, I'm on the job hunt again, and there's been a wave of impressive new technologies that have been labeled as Artificial Intelligence that are capable of evaluating natural language, and can be used in ways that enable me to apply DevOps principles to help me tackle some of the tasks I struggle with when applying to open positions. To understand how I'm fitting these principles and AI into my job search, it is helpful to look at a diagram of a DevOps workflow. Let's go through each of the steps in the diagram and apply them to the application process.

<!-- Perplexity wrote (most of) this CSS for me -->
<img style="width: 100%; height: auto; border-radius: 40%; object-fit: cover; background: radial-gradient(circle, rgba(255,255,255,0.5) 0%, rgba(255,255,255,0) 70%); filter: brightness(1.2);" src="devoops.png">

### Plan
<!-- See note 1p -->
So, there's CaC, Configuration as Code as well as IaC, Infrastructure as Code, and although the exact phrase is never quite said, I think we can credit Emily for RaC, or Resume as Code, and just like any codebase, you'll need to figure out what language and technologies you want to use as your code base. For Emily, that was LaTeX. For myself, the initial iteration on my process was YAML and Python which generated HTML and then used headless Chrome to render a PDF. Whatever workflow you might be envisioning as your process, I would encourage you to pick technologies you're already familiar with. You don't want to find yourself missing out on an amazing opportunity because you were struggling to get your resume updated.

Because I'm now on my second iteration of DevOps-ing my resume, I have a strong starting point to build off of, but I also know all the pain points and areas that need improvement. To understand my plan for my 2025 job hunt and why I chose to adopt AI, it's helpful to look at my old process.

#### My old build process
<!-- Is, "My Old Automation" anything like the TV show "This Old House" ??? -->
1. **Edit my RaC:** This usually involved abbreviating my oldest experience down to the company name, my title, and the dates I was in that position. I would then update the details of my more recent positions to highlight experience I thought was most relevant for the job I was applying to, and finally change the ordering in the `position_achievements` sections so that the ones most applicable to the role came first.
1. **Render an HTML file:** In this step, I would run my Python script which parsed my YAML file into an HTML file, and used the [PySpellChecker](https://pypi.org/project/pyspellchecker/) library to flag any spelling issues.
1. **Review and repeat:** I found that seeing the file as rendered HTML instead of YAML gave me a perspective shift which allowed me to see punctuation and grammar errors which I had overlooked in the YAML file, so I would make revisions and re-render the HTML.
1. **PDF-ify:** Once I was happy with the results, I would use a shell script that invoked [headless Chrome with the `--print-to-pdf` flag](https://developer.chrome.com/docs/chromium/headless#--print-to-pdf) to render a PDF file.

This process might sound pretty good, but in practice, I found it very cumbersome. It involved a lot of manual edits to the YAML and I eventually got to the point where it was easier to maintain two variants of my RaC, `resume_details.yaml` which was a complete list of my job history, and `resume_short.yaml` which was truncated as describe above. Of course, whenever you have two versions of something they are eventually going to suffer from a certain amount of "drift" and keeping the two files in sync became a task of its own.

Resumes are also a somewhat short-lived document, and although I had been good about keeping old copies of my resume, I hardly ever put them in the same place twice, and I had been inconsistent with my naming conventions. The result was that the files were scattered, disorganized, and offered no system for me to track the role I had applied to or the date that I had applied to it.

The most painful part of this process, however, was that I found myself constantly switching between different sources of information so I can build a cover letter that best reflected the overlap of my career experience with the position requirements and their company values. I would find myself mentally exhausted from a cycle of re-evaluating information from these sources just to make the subtle tweaks that gets me to a result I was satisfied with, and would often find myself either hitting a, "just ship it" moment or abandoning where I was at so I could revisit everything with fresh eyes the following day.

#### Goals for my new build process
My main goals with my 2025 job hut were this:
1. **Use AI to _outline_ a cover letter, and be a single point of reference:** Normally, we give AI a prompt to get information back, but in this instance, My plan was to prompt the AI to give me a prompt in return. All too often, I find myself often getting stuck figuring how how to begin a cover letter. It isn't unusual for me to stare at a blank document until my monitor goes into power save, or for me to start by writing a paragraph that I know will go somewhere in the middle of the letter. I also end up with similar struggles while trying to type up a conclusion. I've seen smart people land jobs better than mine with cover letters that are little more than a single paragraph, but apparently my brain doesn't work like that, so asking AI to outline some points I should be sure to hit by having it build the outline from the three sources I outlined (resume, job description, and company values), could go a *long*, long way to making the process easier.
2. **Use AI for a fast-feedback loop:** I never feel comfortable asking friends and former coworkers to look over my resume because I know it would require an investment of their time. It's one of those things that I know I _should_ do, but I usually skip <!-- you know, just like taxes and flossing --> and in the instances where I _have_ asked for a review, I've found that they typically can't get to it right away, which creates a window for me to miss out on an opportunity I'm excited for. Although far from being a perfect solution, AI could help me fill this gap in my process; it has immediate availability, it can perform the review quickly, it can respond programmatically, and having the AI score me numerically to the job description will help me quickly gauge if my changes are trending towards an improvement.
3. **Get more organized (build the code with build code):** A big part of my organizational issues stemmed from the fact that large portions of my process remained without automation. Getting my resume into source control had been a huge step in the right direction, but I was still invoking my scripts manually which resulted in inconsistent naming, scattered storage, and a lack of organization. Since my RaC was already source controlled in GitHub and because most of my issues with my current process stemmed from a lack of consistency, leveraging the large ecosystem had built up around GitHub Actions made a lot of sense for solving my pain points.

### Code
If you're building your Resume as Code from scratch, it'll likely take you a couple of iterations before you land on a format that you like. You might go all-in with Markdown or even double down on the "code" aspect and go with a fully object-oriented approach where every position you've held is an instance of a class in Java. Regardless of your format, I recommend you do a few things:
1. Dig in and find every old copy of your resume you can scrounge up. When I started this process, I searched through my email, looked in Google Docs, logged into job platforms I hadn't touched in years (e.g. Dice.com), blew the dust off of old computers I still had kicking around, and checked anyplace else I could think of.
1. Start with a short version of your resume, write some test code and experiment with tooling. Get some proof-of-concept work done to verify that the strategy you identified from the "Plan" step will meet your needs. It's better to find yourself having to go back to the planning stage than discovering that the structure of your RaC or the required workflow around that structure, doesn't suit you.
2. Once you've proven out your plan, write your RaC. I took all the best parts from each version of my resume I had been able to dig up and created a monolithic `resume_details.yaml` version. Knowing for a fact that I had a single source of truth to use as a starting point for all my future job hunts boosted my confidence that I would always be putting forward my best effort for every job application.

Since I had already had a strong starting point to build off, I could focus on meeting the goals I had identified in my planning phase, and I wanted to tackle them in the order that had the largest positive impact first. So, my first step was to improve my cover letter writing process which meant finding an AI platform that has an easy to approach API and, being that I'm unemployed, has a generous free tier. I did a cursory check of other popular platforms, but Google Gemini not only had a generous free tier, they made it easy to [get an api key](https://ai.google.dev/gemini-api/docs/api-key), and had clear documentation on how to get [started with text generation](https://ai.google.dev/gemini-api/docs/text-generation#rest). After a quick test where I gave it my resume and a job description, and received a reasonable looking response back, it became a defacto winner.

With my Gemini picked as my AI platform of choice and a proof-of-concept under my belt that proved my plan was generally possible, I next wanted to determine if Gemini was actually going to be helpful, or if the response I had previously gotten was only reasonable _looking_ but nonsense, or if it was genuinely offering helpful insights. So, I set out to create the [GitHub Action `gemini-qualified`](https://github.com/dev-dull/job-search-automations?tab=readme-ov-file#dev-dulljob-search-automationsgemini-qualified) to act as "barometer" to prove out the usefulness of Gemini by having it confirm my perception of a job listing by asking for a few things. First, I wanted Gemini to give me a second opinion on how qualified I appear to be for the role and to get some initial feedback on strengths I could play to and shortcomings I should try to make up for when applying. Second, because I've seen some wild stuff in job descriptions on LinkedIn, and because my first pass reading a job description is usually just a quick read of the candidate requirements, I wanted to know if Gemini thought a job description was well written. Third, I wanted to get some initial impressions about the company and what they are like to work for, because if an AI knows its bad, it must be pretty darn bad. <!--Can AI companies be liable for defamation if their platform says something mean about your company? --> One of my [early tests](https://github.com/dev-dull/job-search-automations/actions/runs/13338493030) compared my resume to an open position at HashiCorp and listed, "Could provide more specific information about the tools and technologies used by the team." as one of the deficiencies of the job description which has been one of my frustrations with their job descriptions FOR YEARS, and I took as a sign that I was on the right track.

<!-- side-bar: if someone at Hashicorp is reading this, I understand that ya'll want to make everyone feel like they've got a shot at the position, but with me, it backfires every time. I sit and read the job description multiple times, can't make up my mind if I'm a fit or not, and move on. Between my last three job hunts, I've literally lost days getting frustrated with your job listings. -->

With the `gemini-qualified` action working, a pattern was emerging on how the finer details of my job application workflow would look, and the early signs of using Gemini were showing that there was value I could yet incorporate. I used the pattern I had established with the fist action to tackle my largest pain point of writing cover letters, and built the [`gemini-cover-outline` action](https://github.com/dev-dull/job-search-automations#dev-dulljob-search-automationsgemini-cover-outline) which makes use of my resume, the job description, and the text from the company's careers page to list the points I should be sure to hit. I've only used the action a handful of times since creating it, and I'm not necessarily any faster at writing my cover letters, but the reduced cognitive load has been a tremendous help by keeping me fresh eyed enough to start tackling the next job application.

Now that I had effectively unblocked myself by making it easier to write cover letters, it was time to tackle the process of getting fast-feedback on my resume. My initial plan was give Gemini the YAML version with the [strict instruction to, "not add ... misleading information"](https://github.com/dev-dull/job-search-automations/blob/bb9099c4dd435081ddd39f60ff058d75fd40e561/gemini-rewrite/action.yaml#L74), told it to [make it look nice](https://github.com/dev-dull/job-search-automations/blob/bb9099c4dd435081ddd39f60ff058d75fd40e561/gemini-rewrite/action.yaml#L83-L84), and to generate an HTML document. There was a lot about this action that worked well. It understood on its own that each key/value pair in the YAML file represented an HTML tag and a class name, it generally made a nice looking resume, it generated some CSS styling that I have since tweaked and permanently adopted, and I never saw it lie about my qualifications. However, it came with significant issues as well. It generally eliminated so much text it left my resume feeling very sparse, it occasionally evaluated dates incorrectly, it would correctly infer information about my resume that I deliberately omitted because they don't align with my career goals, and worst of all, I found that I would have to read and validate every aspect of my resume to verify its accuracy which hampered my process. Overall, the [`gemini-rewrite` action](https://github.com/dev-dull/job-search-automations?tab=readme-ov-file#dev-dulljob-search-automationsgemini-rewritev030) was a net-negative to my process and I deprecated it, but I also spent some time asking myself, "_Why_ did this fail?" and the conclusion that I came to is right there in the DevOps diagram: I was trying to go straight from the code step to the release step, virtually skipping the build step by having Gemini do the build for me, which then required me to step backwards _manually_ do the "test" step. <!-- Even as a proponent of the DevOps model, I know better than to think that the pattern is always applicable, but in this case, >> it feels like I should finish this last sentence, but it also feels like it wouldn't add value for the reader << -->

One of the things about the DevOps model that I think doesn't get enough discussion is that when you complete the "Dev" loop or the "Ops" loop, there's always the option to repeat that side, and having implemented a plan that arguably skipped build and test, it was time to revisit the planning stage. Using lessons from what worked so well for me with the `gemini-cover-outline` action, I decided to ask Gemini to _recommend_ changes instead of trying to have it make the changes for me, and built the [`gemini-tailor` action](https://github.com/dev-dull/job-search-automations?tab=readme-ov-file#dev-dulljob-search-automationsgemini-tailor). It's hard for me to express just how enormous of an improvement this was. It highlighted items that I could validly frame with industry buzz words like, "observability," "DevSecOps," and "GitOps." It made great recommendations on things to cut, and things to add. Combining `gemini-tailor` with `gemini-qualified` allowed me to identify revisions to my resume, make and commit changes, and promptly get feedback that helped me gauge if my changes were trending me in the right direction.

### Build
This is where we need to turn a RaC into a format that can be used to apply to jobs. Since using Gemini to build an HTML file for me had proven to be a very bad plan<!--™️-->, I fell back onto my previous Python tooling to process the YAML into HTML, but I learned from my previous job hunt that processing the files on my local machine was going to leave me wildly disorganized, so I build a GitHub Workflow that rendered the YAML into HTML and then used the command line tool `wkhtmltopdf` to render the HTML out as a PDF. I would link to the workflow here, but it is currently locked away in my private `resume` git repository. There's generally nothing unexpected in it: check out the repo, set up Python, install requirements, run my script to render the YAML to HTML using the branch name as part of the file name, use `wkhtmltopdf` to convert the file to a PDF, and archive both files as artifacts to the run of the workflow.

Having this resume generation process automated is meant to be my gateway towards organization. So long as I can keep my branch names clear and concise, then all the various versions will have a clear purpose on a searchable platform.

### Test
The only testing I'm currently doing is giving everything one last look before moving onto the next step, so there's room for a lot of improvement here. Maybe you have a friend on standby to give things a quick look for any obvious mistakes. You might even want to test your process by applying to a few jobs you know you don't want, but might help you find pain points in your process. After all, if you end up with a call-back on one of those positions, it could end up being a good practice interview. You can test your process as an opportunity to send out some "moonshot" applications where you would love to have the job, but don't really expect to get. Remember that if there's ever anything about your process that isn't working for you, now is great time to make a second loop through the "Dev" side of the DevOps diagram and circle back to the plan phase.

### Release
I like to think of this similar to creating a "Release" on GitHub where I'm more or less doing all the steps necessary to mark things as done. For me, this means opening up a GitHub issue where I track a link to the job posting, any salary information, the date I applied, and links to the GitHub Workflow(s) that helped me write my cover letter and revise my resume.

### Deploy
Deploying in this case is really is nothing more than submitting your application.

### Operate
For us, this is effectively just waiting for some recruiter to take on the task of reading your submitted application, but hopefully you identified changes or improvements to your resume that you want to make permanent and this is a good opportunity to identify those changes and commit those back into the default branch of your resume repository while those changes are still fresh in your mind.

### Monitor
Now that we have a RaC and an established process, the "monitor" step is now the point were we begin and end each iteration of the job hunt process, and it has two elements.

1. **Look for open positions:** I really wanted to automate much of this step, but it proved non-trivial. Most job listing aggregators have have locked down their pages. Web scraping is still a potential avenue of automation, but likely violates terms of service, and even if that doesn't bother you, you'll probably end up having to figure out how to get around a CAPTCHA or two. All of that is probably more work than just sifting through some job listings, or better yet, spending some time talking to people.
1. **Watch for responses to applications (and for requests for you to apply):** Although you could likely create some automation around email monitoring and maybe even phone call screening, you're probably not getting such a high volume of messages that you need special tooling to handle it. The worst you'll get likely get here are messages from 3rd party recruiters, and even then, the risk of [alert fatigue](https://en.wikipedia.org/wiki/Alarm_fatigue) is low.

Overall, my attitude here is that there's room for automation, but about the best I'd be able to create is effectively reply bot, and even if I added some AI dark magic to that bot, responding myself seems much more likely to get me to the next step of an interview process.

## My end-to-end RaC workflow
[<img src="resume-workflow-diagram7.svg" />](resume-workflow-diagram7.svg)

I'll quickly walk through the diagram. I start by making a new branch in the git repository for my RaC which includes the file `job.txt` that contains the text from the job description. This triggers two GitHub Actions Workflows where one runs the `gemini-tailor` action, and the other workflow runs the `gemini-qualified` action. I use the output from `gemini-tailor` to revise my resume and committing those changes back to the repository re-triggers the two workflows. I can then compare the outputs of the two `gemini-qualified` runs to evaluate if I've made meaningful improvements. I continue this loop of revision and evaluation until I'm ready to apply to the open position and once I am, I manually trigger another workflow which renders the PDF document and runs the `gemini-cover-outline` action to generate a prompt that will help me create a cover letter.

## Iterate (do it all again)
There's still a lot of room for improvement in my workflow. Since I don't have a great way of deciding when a branch becomes stale, I can already envision my future self having a repository cluttered with a lot of branches. I also don't have a great way of getting small improvements to my resume out of a job application branch and back into the `main` branch because any given branch will have many changes, not all of which belong back in my base, `main` branch resume. Additionally, there's a number of improvements I'd like to add in the future. First and foremost, Gemini isn't really regarded as the best AI platform, so I'd like to test out platforms. I'm currently manually opening a GitHub Issue to track my application status, and that is a step that can easily be automated when I render my PDF. I also think there's room for automation in the monitoring step by building a workflow that will automatically close a GitHub Issue when AI recognizes a rejection letter.

There's no way around it, job hunting is an awful experience, but applying the DevOps model has enabled me to improve my job hunt experience by taking advantage of the skills I've built in my career while I search to find my next chapter of it.

### Thanks and acknowledgements:
Special thank you to [Emily Dunham](https://edunham.net/) for the talk and inspiration, but also for taking a quick look before I published this post.
