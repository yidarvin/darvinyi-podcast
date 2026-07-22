---
slug: brynjolfsson-2017-machine-learning-workforce
title: "What Can Machine Learning Do? Workforce Implications"
description: "An optimist, a skeptic, and a guest scholar dig into the 2017 Science essay that reframed automation as a task-by-task question, not a job-by-job one — and ask how well its eight-item checklist survives the large language model era."
date: 2026-07-19
guest_name: "Priya"
guest_voice: af_bella
---
[O] Here's the pitch that got argued to death back in twenty seventeen: the robots are coming for your job.
[S] Except that's not actually the paper's claim. It says something stranger — ask about the job, and you get the wrong answer every time.
[O] Right, the real question isn't "does a lawyer's job survive machine learning," it's "which five things a lawyer does on a Tuesday survive machine learning."
[S] And the task the paper flags as the one that doesn't survive is almost insulting to the profession — reading a document and sorting it into a pile.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a guest scholar take apart one paper at a time.
[S] Today's paper is "What Can Machine Learning Do? Workforce Implications," by Erik Brynjolfsson and Tom Mitchell, published in Science in December of twenty seventeen.
[O] Joining us is Priya, who knows this paper and its citation lineage cold. Priya, welcome.
[G] Glad to be here — this is a paper people cite constantly and, I'd argue, read carelessly in about equal measure.
[O] So set the scene. Why did an economist and a computer scientist feel like they needed to write this, in Science of all venues?
[G] Because the existing vocabulary for "which jobs get automated" was built for a different technology. Going into twenty seventeen, the standard framework was Autor, Levy, and Murnane's routine-versus-nonroutine distinction — computers replace tasks you can write explicit rules for, full stop.
[S] Which made sense for payroll software and spreadsheets. It doesn't explain what deep learning was suddenly doing to reading a chest X-ray or recognizing a face.
[G] Exactly, because those aren't rule-based tasks. Nobody can write down the explicit rule for "this mole is melanoma." The paper leans on the philosopher Michael Polanyi's line, that we know more than we can tell.
[O] Polanyi's paradox. I love that framing — it's basically why expert systems in the nineteen eighties never worked. You can't get the rule out of the expert's head.
[G] Right, and the authors' point is that supervised machine learning sidesteps that problem entirely. It doesn't need a human to articulate the rule. It needs enough labeled examples to infer the rule statistically.
[S] Okay, but that's a mechanism, not a labor forecast. What's the actual gap the paper is filling?
[G] The gap is: if routine-versus-nonroutine no longer predicts what gets automated, what does? And the authors are explicit that they are not forecasting a number of jobs lost. That is deliberately not the paper's claim.
[O] Which is almost more interesting — they refuse to do the thing everyone wanted, which is put a scary number on the cover of Science.
[G] They give you a rubric instead — a checklist for whether one specific task, not a job, is a good fit for the current machine learning paradigm.
[S] Let's get concrete. What's actually in this rubric?
[G] It's called Suitability for Machine Learning, or S-M-L for short. The full version, in the supplementary materials, runs to twenty-one items, but the main text condenses it to eight headline criteria, all aimed at the paradigm dominant in twenty seventeen — supervised learning plus deep neural networks.
[O] Walk us through them.
[G] First, the task has to learn a function from well-defined inputs to well-defined outputs — classification, prediction, that shape of problem. Second, a large digital dataset of those input-output pairs has to exist or be creatable. Third, the task needs clear feedback against a clearly definable goal.
[S] So far that's just "supervised learning works when you have supervision." Not exactly a shocking insight.
[G] Fair — but the next two are where it gets sharper. Fourth: no long chains of logic or reasoning that lean on diverse background knowledge or common sense. Fifth: no need for a detailed explanation of how the decision was made.
[O] Those two are going to matter a lot later in this conversation.
[G] They will. Sixth, tolerance for error — the task doesn't require a provably correct or optimal answer. Seventh, the underlying phenomenon doesn't change rapidly over time. And eighth, no specialized dexterity, physical skill, or mobility required.
[S] Eight criteria, and if a task clears all eight, it counts as S-M-L, suitable for machine learning.
[G] Right. And the crucial move is insisting the unit of analysis is the task, not the job. Their own example is a lawyer. Classifying documents as relevant to a case is highly S-M-L — tons of labeled precedent, a clean feedback signal. Developing courtroom strategy, interviewing a witness, is not S-M-L at all under this rubric.
[O] Which means "is the legal profession automatable" is just the wrong question. It's a bundle of tasks, and you score them one at a time.
[G] And that's why the authors argue you cannot simply extrapolate from the previous automation wave. Business computing and the S-M-L rubric slice jobs along different axes. A task that survived the earlier wave, reading a medical image, holding a sales conversation, is not automatically safe from this one. And a task everyone assumed needed human judgment, something "creative," can turn out to be S-M-L if you can specify what a good outcome looks like and score it automatically.
[S] Okay, so that's the task rubric. You mentioned there's also an economic half to this paper, because scoring a task as S-M-L doesn't by itself tell you what happens to employment or wages in that job.
[G] Right, that's the second half. On top of the task rubric, they lay out six economic factors that determine what a newly S-M-L task does to labor demand once it's actually automated: substitution, meaning direct replacement of the worker doing that task; the price elasticity of demand for whatever the task produces; complementarities with the other, still-human tasks in that job; income elasticity; the elasticity of labor supply for that task; and business-process redesign.
[O] Business-process redesign is the one people skip past, and it might be the most important.
[G] It's the Le Chatelier's-principle point. Firms don't hold their production process fixed once a task gets automated — they re-architect around the new cost structure, and that redesign effect gets larger the longer the time horizon you look at.
[S] So the honest answer to "does automating this task raise or lower employment in this occupation" is —
[G] It depends, and the paper says so explicitly. The net effect is the sum of six factors that can point in different directions, even inside the same firm.
[O] Give us the parts that actually surprised you the first time you read this.
[G] The first is a genuine inversion of intuition. The authors argue some aspects of sales and customer interaction are, quote, "a very good fit" for machine learning, despite looking like they need real emotional intelligence, because you have enormous transcript datasets of salesperson-customer exchanges, and you can train a system on which responses actually lead to a sale.
[S] And the contrast case?
[G] Physicians. Specifically the unstructured task of a doctor talking with other doctors, and what the paper calls the "potentially emotionally fraught task of communicating with and comforting patients" — those, in their words, are "much less suitable for M-L approaches." So inside one of the highest-status, most technical jobs in the economy, there's a sub-task that scores worse on this rubric than cold-calling.
[O] That's the whole thesis landing in one sentence — status and technical difficulty don't predict an S-M-L score. Data availability and feedback clarity do.
[S] I'll admit that's a good gut-check against the lazy "white-collar work is safe" assumption a lot of people carried into this debate.
[G] The second surprise is about creativity. The paper treats it as a gradient, not a binary. Their example is generative-design software producing a heat exchanger that meets weight, strength, and cooling-rate requirements, and they specifically note it does this "more effectively than anything designed by a human, and with a very different look and feel."
[O] Which sounds like a creative act to me.
[G] It does, but the requirement isn't that the design process itself be specified step by step, only that the properties of a good solution be well specified and automatically checkable. So the scarce human contribution shifts from searching for the design to defining what "good" even means.
[S] And the third piece is the direct argument against extrapolating the previous wave forward.
[G] Right. The earlier wave's effects, in their words, fell on "a relatively narrow swath of routine, highly structured and repetitive tasks." That's why labor demand fell in the middle of the skill and wage spectrum, clerks and factory workers, while demand held up at the bottom, janitors and home health aides, and at the top, physicians.
[O] And the S-M-L rubric predicts a different cut.
[G] A different, overlapping cut. It can reach inside high-status professional jobs, task by task, document classification for lawyers, image reading for radiologists, rather than sparing those occupations wholesale the way the older framework implied. The authors are blunt about it: simply extrapolating past trends "will be misleading, and a new framework is needed."
[S] That's falsifiable, at least in hindsight — it predicts a specific, different occupational pattern than the routine-nonroutine story would.
[G] And it's exactly the claim that "GPTs are GPTs," six years later, goes and tests directly, by building a large-language-model-scored O-net exposure measure. That paper is this one's direct methodological descendant.
[O] Let's do the actual debate, because I think this paper holds up remarkably well for something written before the current wave of large language models.
[S] I want to push back hard on exactly that, so let's go.
[O] My case: the framework's core move, score the task rather than the job against an explicit rubric, is now just how everyone in labor economics talks about A-I exposure. "GPTs are GPTs" inherits it wholesale, and so does a twenty eighteen follow-up paper the same authors wrote with Daniel Rock, which actually quantifies the rubric against real occupational data.
[S] Sure, the "task not job" framing survived. What I don't think survived is the actual checklist. Look at criteria four and five: no long chains of reasoning that need common sense, and no need to explain how the decision was made. Chain-of-thought prompting is a language model doing exactly the explicit, multi-step reasoning trace this rubric assumed was out of reach for machine learning.
[O] That's fair, but —
[S] And it's not only criterion four. Criterion two assumes you need a large digital dataset of input-output pairs for the specific task. Modern instruction-following language models get adapted to brand-new, open-ended tasks with orders of magnitude less task-specific labeled data than that criterion assumes is necessary. Half this checklist describes limitations of twenty-seventeen supervised deep learning that just don't apply to today's dominant paradigm.
[O] Priya, adjudicate. Is that fatal to the paper?
[G] It's not fatal, but it is a real limitation, and I'd call it the sharpest available critique. The core empirical claim, that the twenty-seventeen machine learning paradigm is fundamentally shaped by supervised learning and strongest on well-labeled, feedback-rich, slowly drifting, dexterity-free tasks, was directionally correct for the deep-learning application wave the paper was actually describing, roughly twenty eighteen through twenty twenty-two.
[S] But not for what came after.
[G] Not for what came after. The eight criteria are calibrated to supervised deep-neural-network classifiers circa twenty seventeen, and two of them, no long reasoning chains, no need to explain the decision, describe exactly the capabilities that chain-of-thought and instruction-tuned language models added within about five years. The framework's insight outlived its own checklist.
[O] Which I'd still call a win. Most conceptual frameworks don't even get the insight right, let alone have it survive one paradigm shift.
[S] I'll take that as a fair scoring. I still think if you handed someone this checklist today and told them to use it to predict which of their job's tasks are safe, they'd get several answers wrong for exactly the reasons I just gave.
[G] That's the honest reading. It's a reasonable limitation for a forward-looking twenty-seventeen essay to have — nobody was predicting instruction-tuned transformers that December — but it means you shouldn't apply the eight criteria unmodified today. Treat it as a historical marker of what "A-I" meant at that moment, not a timeless test.
[O] One more thing worth flagging while we're being careful about the record — the twenty eighteen follow-up I mentioned a minute ago is co-authored with Daniel Rock, but Rock is not an author on this twenty-seventeen piece. It's just Brynjolfsson and Mitchell.
[G] Right, he's thanked in the acknowledgments for discussion, not credited as a co-author — worth knowing if you're tracing the citation lineage, since the two papers get conflated constantly.
[S] Zoom out for us — why does a paper like this matter to people who spend their day building or grading evals rather than writing labor economics?
[G] Because the exposure-measurement literature this paper kicked off runs on the same discipline good evals need: score something task by task, against explicit, falsifiable criteria, rather than assigning a fuzzy verdict to the whole system. That's exactly what "GPTs are GPTs" does when it turns the S-M-L idea into an O-net-based exposure score.
[O] It's basically an eval rubric for "is this task automatable," and eval rubrics have the same failure mode this one had. They get calibrated to the current model generation and go stale the moment the paradigm shifts.
[S] Which is a good argument for re-running this kind of rubric periodically instead of treating any one version of it as settled, the same way you'd distrust a benchmark nobody's updated in five years.
[G] That's exactly right, and it's the most useful lesson to take from watching this particular framework age in public.
[O] On that note, let's close it out — one line each, starting with you, Priya.
[G] If I had to leave you with the paper's own takeaway: stop asking whether a job survives machine learning, and start asking which of its tasks pass an explicit suitability test. That reframe outlasted the specific eight-item checklist.
[O] My takeaway is that "creative" and "safe from automation" were never the same claim, and this paper said so in twenty seventeen, years before most people needed convincing.
[S] Mine is a caution — any suitability rubric is a snapshot of one model generation, and this one shows exactly how fast that snapshot can go stale, so read the eight criteria as history, not as a test to run today. Find the full writeup, the exact quotes, and the rest of this paper's citation lineage at litsearch dot darvinyi dot com.
