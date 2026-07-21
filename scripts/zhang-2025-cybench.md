---
slug: zhang-2025-cybench
title: "Cybench: A Framework for Evaluating Cybersecurity Capabilities and Risks of Language Models"
description: "Forty professional-grade capture-the-flag challenges, graded for partial credit and calibrated against how long real human teams took to crack them, turn the vague fear of AI hacking into a number regulators and labs can actually track."
date: 2026-07-19
guest_name: "Ignatius"
guest_voice: "bm_george"
---
[S] Here is a question nobody wants to answer with a shrug anymore, how good, exactly, is a language model at breaking into a computer system.
[O] Not a vibe, not a headline, an actual number, tracked over time, the way we track anything else we're worried about.
[S] And the paper we're covering today builds that number out of forty capture-the-flag puzzles and how fast human teams solved them, which sounds rigorous until you ask what forty data points can really tell you.
[O] I say it's the most disciplined attempt yet at measuring this risk instead of just gesturing at it, and I think by the end of this episode you'll lean that way too.
[O] Welcome to Litsearch Audio, I'm your optimist host.
[S] And I'm the skeptic, here to keep the optimism honest.
[O] Today's paper is Cybench, A Framework for Evaluating Cybersecurity Capabilities and Risks of Language Models, from Andy Zhang and a large team of colleagues at Stanford, published at ICLR twenty twenty-five.
[S] Joining us is Ignatius, a visiting scholar who has studied this benchmark closely. Ignatius, welcome to the show.
[G] Thanks for having me, this is a paper worth spending real time on, because it's less about any one model and more about how you'd even measure this category of risk at all.
[O] Let's start with the gap, Ignatius, why did anyone need a new benchmark here.
[G] The trigger was policy, not just research curiosity. The twenty twenty-three US Executive Order on AI named cybersecurity as one of the headline risks and explicitly called for benchmarks to quantify it.
[G] Government safety institutes and model providers had already started running capture-the-flag evaluations internally, distinguishing high-school, university, and professional-level difficulty.
[S] But internal and closed, which means nobody outside those organizations could check the methodology or reproduce a single number.
[G] Exactly right, and that's the first hole Cybench tries to close, an open, professional-level evaluation anyone can actually run.
[O] What existed publicly before this, though, it's not like nobody had tried.
[G] Two efforts, mainly. InterCode-CTF draws entirely from PicoCTF, a high-school-oriented competition where the tasks took the benchmark's own authors an average of about three and a half minutes to solve.
[G] And the NYU CTF Dataset draws entirely from CSAW, which is university-level, harder, but still one competition.
[S] Single competition is the tell there, it caps how many recent, hard tasks you can pull, and it raises contamination risk, because older tasks from a recurring competition are more likely to have leaked into pretraining data.
[G] Right, and both of those datasets also rated difficulty subjectively, with point values assigned before anyone actually competed, rather than grounding it in how real teams performed.
[O] So Cybench's pitch is doing four things at once that nobody had combined, professional-level, open-source, objectively difficulty-rated, and gradable for partial credit.
[G] That's exactly the authors' framing, and it's why the paper spends real effort on task sourcing rather than just the agent design.
[S] Let's get into how they actually built it, then, before we get to whether it works.
[G] Every task in Cybench is fully specified by three things, a task description, a set of starter files, some readable locally and some served only over a network connection, and an evaluator that checks whether the agent's submitted answer matches a secret flag string.
[G] The forty tasks are pulled from four real competitions run between twenty twenty-two and twenty twenty-four, and they span six categories, named at a high level, cryptography, web security, reverse engineering, forensics, exploitation, and a miscellaneous bucket.
[O] And deliberately recent, to fight contamination.
[G] Nearly half the tasks were released after December twenty twenty-three, which is the pretraining cutoff for every model they test except one. Every task also ships a verified solution script, checked continuously so the task is guaranteed to actually be solvable and not broken.
[S] What I find clever, and I don't say that lightly about a benchmark, is the difficulty axis. Talk about first solve time.
[G] First solve time, or F S T, is simply how long the fastest human team took to crack a given task during the original competition. Across the forty tasks it ranges from two minutes up to twenty-four hours and fifty-four minutes.
[O] That's a seven hundred forty-seven times spread, and it scales roughly log-linearly, which gives the benchmark real headroom above anything prior CTF datasets offered.
[S] It's a genuinely better difficulty label than a point value some organizer guessed at, I'll grant that immediately, it's grounded in actual competitive outcomes.
[G] The second big design move is subtasks, since many tasks are simply beyond what current agents can finish outright, a subset gets decomposed into an ordered chain of intermediate questions, each gradable on its own.
[O] So instead of a flat zero when a model can't fully crack a professional-grade challenge, you get a gradient, how far did it get.
[G] Precisely, and that gives three separate metrics, unguided performance, which is the binary pass or fail with no help, subtask-guided performance, which scores only the final step but after being walked through the earlier ones, and subtask performance, the fraction of intermediate steps solved.
[S] I want to flag something now and come back to it, providing those intermediate steps is itself giving the model information it wouldn't otherwise have, so subtask-guided numbers and unguided numbers are not measuring quite the same thing.
[G] Hold that thought, it matters a lot for reading the results table, and the authors themselves flag it as a limitation.
[O] Walk us through the agent itself, how does a model actually attempt one of these tasks.
[G] It's a three-step loop the authors call act, execute, update. Each turn the agent's memory produces a response containing an action, almost always a shell command, that action runs inside a sandboxed Kali Linux container connected to the task's files and servers, and the resulting output folds back into memory for the next turn.
[G] Memory is deliberately narrow, just the initial prompt plus the last three response-and-observation pairs, and the default response has five structured fields, a reflection, a running plan and status, a thought before acting, a log, and finally the action, inspired by prior agent-prompting work like Reflexion and ReAct.
[O] And they didn't just test one model against this harness.
[G] Eight models, closed and open-weight, GPT-4o, OpenAI's o1-preview, Claude 3 Opus, Claude 3.5 Sonnet, Mixtral 8x22b Instruct, Gemini 1.5 Pro, Llama 3 70B Chat, and Llama 3.1 405B Instruct, each capped at fifteen iterations unguided and five per subtask, with tight token budgets per turn.
[S] How tight are we talking.
[G] Six thousand input tokens and two thousand output tokens per turn, raised to roughly thirty-three thousand only for o1-preview, because at two thousand it kept returning empty responses.
[O] Let's get to what they actually found, because this is where the story gets interesting.
[G] With a single attempt on the default agent, Claude 3.5 Sonnet leads unguided performance at seventeen point five percent of tasks solved outright. OpenAI's o1-preview leads subtask performance at forty-six point eight percent, the partial-credit metric.
[S] That gap between ten percent unguided and forty-six point eight percent subtask performance for the same model, o1-preview, is the whole argument for why subtasks exist.
[G] Right, it shows the model is making real, measurable progress on problems it ultimately can't close out, rather than just failing uniformly.
[O] And GPT-4o and Claude 3 Opus land in between, GPT-4o at twelve point five percent unguided but seventeen point five percent on subtask-guided, Claude 3 Opus at ten percent unguided with thirty-six point eight percent subtask performance.
[S] The open-weight models trail clearly, Llama 3.1 405B at seven point five percent unguided, Mixtral 8x22b also seven point five, Gemini 1.5 Pro seven point five, and Llama 3 70B Chat at five percent, the smallest model here in every sense.
[G] Now here's the sharpest finding in the paper, and it's really a cliff, not a gradient. Unguided, models have a non-zero success rate on seventy-three percent of tasks with a first solve time of eleven minutes or less, and solve exactly zero tasks above that threshold.
[O] Including the hardest task in the set, whose first solve time is that twenty-four hour, fifty-four minute outlier, one hundred thirty-six times harder than the longest first solve time any model cracked unguided.
[S] With subtask guidance the ceiling barely moves, one model, GPT-4o, solves a task with a fifty-two minute first solve time, but the paper itself notes that task comes from a different competition, so it's not a clean apples-to-apples comparison.
[G] They also ran a scaffold ablation on the two top models, adding a pseudoterminal for managing interactive state and a web search tool, with three attempts and the best of three kept.
[O] And the effect flips depending on the model, which I think is underrated as a finding on its own.
[G] It does. The pseudoterminal pushes Claude 3.5 Sonnet's unguided score from seventeen point five percent up to twenty percent, but the identical change drags GPT-4o's score down from seventeen point five percent to ten percent. Web search shows the same split, a small gain for Claude, a small loss for GPT-4o.
[S] So more tool access isn't universally better, it's a double-edged sword that depends on whether the model can manage the added complexity.
[G] One more result worth naming, safety refusals were rare and concentrated, only Claude 3 Opus and Claude 3.5 Sonnet ever declined a task on ethical grounds, which pushed the authors to add an explicit framing line clarifying this was an authorized security assessment.
[O] Okay, time for the debate, and I want to make the strongest case first. This is a genuinely serious methodological upgrade over what existed. Grounding difficulty in real human solve times instead of a subjective point scale, and using subtasks to extract signal from tasks that would otherwise register as a flat, uninformative zero, that's real benchmark craftsmanship.
[S] I don't disagree with the design, I disagree with how much weight the headline percentages deserve. Forty tasks means unguided performance moves in two-point-five percentage point increments, Claude 3.5 Sonnet's seventeen point five percent is exactly seven out of forty tasks solved, reported with zero confidence intervals or repeated-seed variance anywhere in the main results, despite a single attempt per model for that headline comparison.
[O] Fair, but it's not hidden, it's a first release of an evolving benchmark, and they say explicitly they intend to keep expanding the task pool.
[S] Sure, but a second issue compounds the first, the subtasks were written by the Cybench team, not the original competition organizers, so partial-credit numbers reflect the authors' own decomposition choices, not an objective property of the challenge the way flag-only first solve time is. Ignatius, does the paper own that gap anywhere.
[G] It does, in a footnote right where they discuss first solve time under subtask guidance, they note plainly that subtask-guided comparisons are noisier because competitors never had access to those subtasks when the original clock was running.
[O] Fine, point to Ignatius and Skeptic. But contamination is the one I actually want to defend the paper on, because most authors bury this, and here they put it front and center.
[G] They do. Nearly half the tasks were released after the training cutoff for every model except Claude 3.5 Sonnet, whose cutoff falls later, and they say outright it's difficult to determine how much train-test overlap affected that model's results, rather than asserting it away.
[S] Which is generous of them, and also a little alarming, because Claude 3.5 Sonnet is the model that tops the unguided leaderboard. An honest asterisk on your best number is still an asterisk on your best number.
[O] Here's where I'll push back on you for once. The scaffold result actually cuts toward my optimism, because it shows these numbers aren't a fixed ceiling on any model, they're a function of engineering effort you can keep improving, which means labs have real levers to both raise and monitor capability.
[S] I'll take the other half of that same fact. If a pseudoterminal alone swings a score by two and a half points and flips direction by model, the headline number says as much about the harness as about the model underneath it. Citing these percentages as "what language models can and can't do" is over-claiming.
[G] Going a little beyond the paper, but staying close to it, treat every number in Table 2 as a lower bound scoped to this exact harness and token budget, not a stable property of the model. The appendix says as much, calling their scaffolding "far from the capability frontier," and points to a later joint pre-deployment test the US and UK AI Safety Institutes ran on a newer Claude 3.5 Sonnet release, using a hundred iterations instead of fifteen, which reached twenty-six and a half percent mean performance and solved a task with a seventy-five minute first solve time, well past the eleven-minute wall this paper hit.
[O] That's a striking data point, the exact same benchmark, more iteration budget, and the frontier moves substantially.
[S] Which actually strengthens my case, not yours, because it means Cybench's headline numbers are a snapshot of one harness's limits, and anyone using this paper's specific percentages to argue "language models can't do dangerous things yet" is reading a harness constraint as a capability constraint.
[G] There's a related limitation the authors name themselves, about the benchmark's realism rather than the model. Capture-the-flag tasks are solved in a short, bounded window, involve small codebases, and are deliberately constructed rather than naturally occurring, so even a perfect Cybench score wouldn't automatically transfer to a sprawling, real production system.
[O] Though they note some tasks incorporate real, publicly known vulnerabilities, it's not pure puzzle-box abstraction.
[S] Granted, but "mimics" carries a lot of weight there, the gap between a weekend puzzle and a genuine multi-week intrusion into a live enterprise network stays enormous.
[O] Last point I want on the table, and it's the uncomfortable one, this whole benchmark is dual-use by the authors' own admission. A tool that measures offensive capability is also, almost by definition, a map of what to go build toward.
[G] The ethics statement addresses that head-on, comparing the release decision to existing open-source penetration testing tools the security community already accepts, and arguing that responsible regulation needs public evidence, not opacity, to work from.
[S] I find that argument mostly persuasive, but it carries a second-order cost, once forty tasks and their solutions sit on a public GitHub repository, public since August twenty twenty-four, they become fair game for pretraining data, so the benchmark's own shelf life as a clean measurement tool is limited.
[G] A real tension for any public capability benchmark, not just this one, once it's useful enough to matter, it's public enough to decay.
[O] So where does that leave us on why this actually matters beyond the leaderboard.
[G] The honest use case is risk tracking over time and across organizations, not a definitive verdict on any one model. Because it's open and reproducible, a safety institute, a model provider, and an independent lab can all run the identical evaluation and compare notes, which the US and UK joint test already demonstrates happening in practice.
[S] That reproducibility is genuinely the strongest thing about this paper, whatever the noise in any single percentage, an evaluation that outside parties can actually rerun beats one nobody outside the lab can check, every time.
[O] And it plugs into the same conversation as responsible disclosure more broadly, if you can watch a specific, quantified capability cliff move over successive model generations, you get an early warning system instead of a surprise.
[G] The paper's own conclusion is worth repeating, cybersecurity agents are dual-use, they can find bugs before deployment or exploits after it, and continuous, transparent evaluation is how policymakers, providers, and researchers stay coordinated on where that line sits.
[S] My caveat for every one of these evaluation conversations, a benchmark score is only as trustworthy as its contamination story and its confidence intervals, and this one is honest about lacking both in places, which is more than most papers manage.
[O] Let's close it out, one line each. Ignatius, the paper's own headline first.
[G] First solve time turns a vague notion of "hard" into an actual number, and subtasks rescue real signal from problems that would otherwise just look like a flat zero, that's the contribution that outlives this particular leaderboard.
[O] My takeaway is that this is a rare example of a safety-relevant benchmark built with real methodological seriousness instead of marketing, and that alone deserves credit.
[S] Mine is to read every future headline about a model's "cybersecurity score" and immediately ask which harness, which token budget, and which training cutoff produced it, because this paper proves those choices move the number as much as the model does.
[O] That's Cybench, from Andy Zhang and colleagues at Stanford. Thanks for joining us, Ignatius.
[G] My pleasure, thanks for having me.
[O] And thank you for listening to Litsearch Audio, the full writeup with figures and the results tables is on litsearch dot darvinyi dot com.
