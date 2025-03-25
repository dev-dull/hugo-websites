---
title: 'Policy Statement on AI Usage'
date: 2025-03-05T17:00:00-08:00
draft: false
showHeadingAnchors: true
showReadingTime: false
showDate: false
---

<div style="width: auto; height: 25em; overflow: hidden;">
  <img style="width: 100%; height: auto; top: -25px;" src="ai.svg">
</div>

## AI and my job application process:
Hello! This document exists for transparency around how I use AI in my job application process. If you're here you probably saw a blurb at the end of my résumé stating that I've used AI while applying for a position. The note should have included a link to a completed GitHub Actions Workflow that used Gemini Flash 2.0 to compare the job description of the opening to which I applied against a version of my résumé which includes the entirety of my career. If for some reason a link was not included, please see [this link to a list of recently completed workflow runs](https://github.com/dev-dull/job-search-automations/actions) and click the successful 'Score Resume' jobs until you have found the relevant comparison.

Additionally, I have used Gemini 2.0 Flash to format and shorten my résumé with [strict instructions to never add new or misleading information](https://github.com/dev-dull/job-search-automations/blob/9fc945ab4de5f403debca5f1acb4eb6e5139d709/gemini-rewrite/action.yaml#L74). The instructions also require that a [comment be added to the body of the résumé stating that Gemini Flash was used](https://github.com/dev-dull/job-search-automations/blob/9fc945ab4de5f403debca5f1acb4eb6e5139d709/gemini-rewrite/action.yaml#L86-L89) in creation of the file. Once the résumé has been modified, it is re-scored by a new 'Score Resume' job which is stored in a private GitHub repository due to the inclusion of personal information. Although the new score is kept private, I'm happy to share the results at any stage in an interview process. Following this, I perform a manual review and iterative refinement of the generated résumé before finally modifying the document to include links to the original 'Score Resume' results and to this AI Policy page.

In the course of applying to the position, I may have also used one or more of the following AI tools:
- GitHub Copilot
- Perplexity.ai

## My general appraoch to the use of AI
I generally take two, largely similar approaches to my use of AI. The first, which is already familiar to most, is that I see it as another tool in a toolbox akin to a Google search or reading through responses on StackOverflow. My second approach is to treat it like the person who _purports_ themselves as _THE_ expert in the room who is often right, but just as often wrong. I find this second approach helps me treat AI as a, "rubber duck" to help me identify silly mistakes I can't quite spot (e.g. "Do you see a syntax error on line 9?") or to generate an example data structure I don't readily have handy (e.g. "Generate an `IngressRoute` configuration for the service `foo` on port `8080` in the namespace `bar`). Additionally, I lean on AI to help me with the tasks I know I'm bad at (such as abbreviating my résumé as I frequently fail to consider that more information isn't always better), and tasks that I'm new to (such as learning the equivalent pattern to subclassing in Golang).
