---
slug: gautam-2025-refactorbench
title: "RefactorBench: Evaluating Stateful Reasoning in Language Agents Through Code"
description: "A hundred handcrafted multi-file refactors expose the real bottleneck in coding agents: not writing code, but remembering what you already changed."
date: 2026-07-19
guest_name: "Ffion"
guest_voice: "bf_emma"
---
[S] Here's a strange result to open on: give an agent three refactoring tasks in the same code base, one at a time, and it solves all three.
[O] Concatenate those exact same three tasks into a single combined instruction, and it solves zero of them.
[S] Not a partial score, not a dip — zero, on tasks it had just proven it could do individually.
[O] That gap is the whole paper in miniature: the code was never the hard part, remembering what it had already done was.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the litsearch dot darvinyi dot com map.
[S] Today's paper is RefactorBench: Evaluating Stateful Reasoning in Language Agents Through Code, from Dhruv Gautam and colleagues at UC Berkeley and Microsoft, published at ICLR twenty twenty-five.
[O] Joining us is Ffion, a researcher who's spent real time with this benchmark. Welcome, Ffion.
[G] Glad to be here. This is one of the more clarifying agent benchmarks I've read this year, precisely because it isolates one failure so cleanly instead of just reporting one more aggregate score.
[S] Let's set up the gap first. Every coding-agent benchmark anyone actually reports numbers on is basically SWE-bench shaped.
[O] Pull a GitHub issue, reproduce the bug, write a patch, run the hidden test.
[G] And that shape is partly a filtration artifact, not just a design choice. SWE-bench pulls from real GitHub snapshots, which are noisy, so its pipeline filters hard for issues with clean reproduction scripts and passing test suites.
[G] The authors argue that filtration skews the surviving tasks toward localized, reproducible bug fixes, and that skew quietly hides whole categories of everyday software work.
[S] Refactoring being the obvious one.
[G] Exactly. A refactor has no failing test to chase and no stack trace pointing at the one broken line. The correct answer is a structural transformation that ripples across many files, and prior benchmarks either skip that entirely or, like function-level benchmarks such as HumanEval, only test single-function versions of it — the part models are already decent at.
[O] So the bet is that the interesting capability was never "can you write the right code," it's "can you hold the whole plan in your head while you execute it."
[G] That's their term for it: stateful reasoning. They formalize the agent as a partially observable Markov decision process, a POMDP — it only sees fragments of the repository through its tools, and their claim is that after enough actions, its internal model of what state the code is actually in drifts from reality.
[S] That's a strong claim to make before you've even built the benchmark. How do you isolate "losing track of state" from "the model just isn't good enough to write this diff" at all?
[G] That's the design problem the whole paper solves, and it's worth walking through, because the answer lives in the construction process, not just the scoring.
[O] So walk us through it. What actually is a RefactorBench task?
[G] One hundred handcrafted multi-file refactoring tasks, spread across nine popular open-source Python repositories — Django, Salt, Scrapy, Celery, Ansible, Tornado, Requests, Flask, and FastAPI. Each one asks the agent to produce a patch that makes the repository obey a specified refactor: rename a helper everywhere it's used, extract a shared abstraction, that kind of change.
[S] And grading is all-or-nothing per task?
[G] For the headline number, yes — every test crafted for that instance has to pass. But the tests are split into subtasks, two to twenty-seven of them per task, so a failure is interpretable. You can see exactly which file or which structural change the agent missed instead of one opaque fail.
[O] How were the tasks actually built? That sounds expensive to do well.
[G] Deliberately so, in four steps. First, localization: they prompted GPT-4o with whole files plus Martin Fowler's refactoring catalog to suggest opportunities, then humans filtered down to changes that genuinely span multiple files. Second, reference solutions: experienced Python programmers handcrafted the edits, while GPT-4o separately verified each core sub-edit was tractable for a frontier model.
[S] So the difficulty ceiling was set by whatever one particular model could verify at construction time.
[G] Correct, and that's a real design choice worth sitting with — I'll come back to it. Third, AST-based unit tests: for every verified sub-edit, a test walks the file's abstract syntax tree, an AST, and checks the resulting structure, deliberately not exact line matching, so an agent gets credit for any correct realization of the change.
[G] Fourth, instructions — a human-written base instruction, plus an auto-generated lazy version that's terse and underspecified like a real user, and a descriptive version that's exhaustive and names the files to touch, functioning as a near upper bound.
[O] Three difficulty settings on the exact same underlying task. That's a nice knob for separating instruction-following from raw capability.
[S] What do the tasks look like at scale — toy repos, or the real thing?
[G] Real and large. Mean codebase size is around twenty-three hundred files, up to sixty-eight hundred, hundreds of thousands of lines. But the edits themselves are modest — two to thirty-one files touched, four point three on average. So the hard part isn't code volume, it's localization and composition.
[O] And every task is multi-file by construction — they filtered out single-file refactors entirely.
[G] Right, and that matters mechanically. It defeats single-shot generation outright and forces any agent to reason across files through a feedback loop rather than one completion.
[S] What's the actual agent under test?
[G] SWE-agent, the strongest open-source agent framework on SWE-bench at the time. The authors had to retune its internal prompts away from bug-fixing — off the shelf, it kept treating a simple rename as a bug and drafting a reproduction script for it. So what gets reported is already a best-case, prompt-adjusted version.
[O] Meaning the raw off-the-shelf numbers would look even worse.
[G] The paper says exactly that, and calls this version an upper bound on what current systems can do.
[S] Let's get to numbers, then. What did the baseline actually score?
[G] SWE-agent with GPT-4 solves twelve percent of lazy-instruction tasks, twenty-two percent of base, and twenty-seven percent of descriptive.
[O] And swapping in a stronger model?
[G] Claude three point five Sonnet on the descriptive set reaches thirty-five percent — the best baseline number reported in the paper.
[S] Against what human baseline?
[G] A single proficient developer, given IDE access and five minutes per task on the base instructions, solves eighty-seven percent.
[O] Twenty-two versus eighty-seven. That's the number that's going to end up in every summary of this paper.
[S] It's also the one I'd flag hardest, but let's hold that for the debate. What else did they find?
[G] Two structural results make the case that the bottleneck is specifically state, not code-writing skill. First, no baseline ever solved a single task requiring edits in more than six files — performance doesn't degrade gradually there, it collapses to zero. Second, the concatenation experiment from our cold open: three already-solved descriptive tasks in the same repo, combined into one instance, solved zero times by an agent that could solve each alone.
[O] The floor didn't move, but the ceiling did.
[G] That's exactly the frame the authors want you to take from it.
[S] Did they actually diagnose why, beyond the aggregate numbers?
[G] Large-scale manual trajectory review first, then scaled up with GPT-4 classifying unresolved runs against the reference diffs — covering about fifty-eight percent of failures, with a human reviewer agreeing about seventy-four percent of the time on a held-out check. Three failure modes came out of that.
[O] Go through them.
[G] First: even with descriptive instructions that name every file to change, agents left the target file completely untouched on about forty-four percent of the tests checking for a specific change. That's notable, because prior SWE-bench-style findings usually show agents finding the right location and failing on implementation — here it's closer to the opposite pattern.
[S] So it's not that they write bad code, it's that they don't even show up to the right file.
[G] Right. Second: seventy-eight point four percent of trajectories error at some code-editing step. Real refactors often require passing through a temporarily broken intermediate state — you rename in one file before fixing its callers — and both the agents and the linting guardrails most open-source systems rely on reject those edits outright.
[O] So the safety rail built for bug-fixing actively sabotages refactoring.
[G] That's the paper's read. Third: context flooding. A single linting-error edit dumps an average of about fourteen hundred sixty-six tokens of error-handling boilerplate into the trajectory, crowding out the original goal — in some runs the agent simply ends the session once the local editing error resolves, having lost the refactor it was sent to do.
[S] That's a real-world version of in-context reward hacking — optimizing the proxy objective staring you in the face instead of the real one.
[G] The authors use that exact term, citing the prior work that coined it, and frame this as a real-world instance rather than a synthetic one.
[O] So that's the diagnosis. What's the fix?
[G] They confirm the mechanism outside of code first, in a clean synthetic setup — a simulated web agent tracking fifteen preference categories, fed a growing list of updates, and asked to report the final state. Across a hundred twenty-five random runs, accuracy in reconstructing that end state decays close to linearly as actions accumulate.
[S] Which supports the POMDP story directly — the more the agent acts, the worse its grip on the current state.
[G] Right. Their fix is an interface change, not a bigger model: an externally computed state variable added to the trajectory — a cached, continuously updated natural-language summary of every edit made so far — injected before each function call, so the agent never has to reconstruct "where am I now" from scratch.
[O] And does it actually work?
[G] Consistently, across all three instruction sets. The paper reports a forty-three point nine percent average relative increase in resolution rate, and a seventy-one percent average increase in subtask completion — and passing more of those AST subtasks is exactly the signature of stronger stateful reasoning, not just luckier sampling.
[S] Given the paper itself flags its baselines as stale, is there an updated number?
[G] There is. A later section reruns a newer SWE-agent one point oh with GPT-4o, which holds roughly the same pattern — twenty-one percent base, thirty-one percent descriptive — but cuts cost to about a dollar sixty-nine per successful instance, down from a ten-dollar cap. The authors also say they've seen preliminary evidence that reasoning-model agents solve many more tasks than the non-reasoning baselines here.
[O] Okay, my optimist case. This benchmark found something real and specific, not just "models are bad." Three concrete failure modes, each traceable to an interface problem, and a fix for one that actually works without retraining anything.
[S] I'll grant the diagnosis is sharp. My skepticism is about how much weight the headline numbers can bear. Start with the marquee contrast: twenty-two versus eighty-seven. The strongest model in the main results is Claude three point five Sonnet, and the paper itself admits, in its own text, that its baselines are outdated.
[G] That's accurate — flagged explicitly before the updated-baselines section, which already shows the newer SWE-agent cutting cost roughly six times over while holding accuracy. The twenty-two versus eighty-seven gap is best read as a snapshot of agent interfaces from early twenty twenty-four, not a fixed measure of the frontier.
[O] Which doesn't erase the finding, it just means the size of the gap is dated, not its existence.
[S] Fair. But the human side of that same number worries me more: it's one developer, five minutes a task, no skill distribution, no inter-annotator agreement reported anywhere. Eighty-seven percent is carrying a lot of narrative weight for a sample size of one.
[G] I'd flag that too. There's no variance reported on that number at all.
[O] What about the state-aware fix — that one felt cleaner to me.
[S] It's a genuine result, but Ffion, is there any ambiguity in how it's actually compared to baseline?
[G] There is. The forty-three point nine percent figure is a relative gain — real, but the absolute deltas underneath are modest, single-digit task counts on a hundred-task benchmark. There's also a base-model wrinkle: the results-figure caption says both agents run on GPT-4, but the text describing the method says the state-aware version uses GPT-4o. The paper never resolves which is correct.
[O] That's a real confound, not a typo, if the two compared agents might not even share the same underlying model.
[S] And there's a plainer inconsistency worth flagging before anyone quotes this paper's headline number: the abstract and the results table both say twenty-two percent for the base condition, but the running text describing that same experiment states eighteen percent instead.
[G] It's never reconciled. I'd treat both quoted figures as low-confidence until someone reruns the eval.
[O] Okay, that one actually moves me. That's not a dated-baseline problem, that's an internal-consistency problem.
[S] Two more, quickly. The failure-mode statistics — the forty-four percent, the seventy-eight point four percent — are themselves LLM-graded, checked against only about seventy-four percent human agreement on a held-out slice. The qualitative modes read as convincing, but the precise percentages inherit judge noise.
[G] Agreed. Treat those numbers as directionally right, not exact.
[S] And contamination: these are nine of the most popular Python repositories on GitHub, almost certainly in every frontier model's training data. Gold solutions are withheld, only the AST tests ship, but the surrounding code and the repositories themselves are entirely public.
[G] A related issue worth naming: the tractability filter means every task was pre-selected to be solvable by GPT-4o at construction time. Part of what looks like measured "difficulty" is really an artifact of which refactors one particular model happened to find tractable back then.
[O] What about the grading mechanism itself — does passing the AST tests actually mean you got a clean refactor?
[G] Worth being skeptical of on its own terms. The tests check the resulting code has the right broad structure per sub-edit, which is reasonable, not exact line match. But nothing in the paper describes running the repository's own pre-existing test suite to confirm the change didn't break unrelated behavior. Passing the crafted checks tells you the shape changed the way they wanted — it doesn't certify the refactor was behavior-preserving across a two-thousand-file codebase.
[S] Which is exactly the property a refactor, as opposed to a plain rewrite, is supposed to guarantee.
[O] Last one — does the state-tracking fix generalize past this one benchmark?
[G] Unclear. It's demonstrated on one agent framework, SWE-agent with GPT-4o, on RefactorBench itself. The paper doesn't test whether the same externally-maintained summary helps on SWE-bench, with a different agent scaffold, or with a different model family. It's a promising interface idea backed by a single positive data point.
[O] Stepping back — why does any of this matter beyond one benchmark?
[G] Because it's diagnosing a generic weakness in agent evaluation, not just a code problem. Most agent benchmarks reward finding the one right answer inside a short trajectory. Very few stress an agent's ability to maintain an accurate model of a long-running environment while it keeps acting inside it.
[S] Which loops back to eval methodology — a benchmark's grading function has to actually target the capability it claims to measure, and SWE-bench-style pass or fail turns out to have been measuring localization far more than composition.
[O] And the fix generalizing beyond code is the interesting bet. If an externally-maintained state summary helps a code agent, the same interface trick plausibly helps any long-horizon agent operating somewhere it can't fully observe at once.
[G] The authors gesture at exactly that in their discussion, extending state-update policies toward whole digital environments, even ones with a concurrent external actor — though that stays speculative. They only demonstrate a small, single-agent version of it.
[S] Speculative is the right word. I'd want the state-tracking idea validated on a benchmark it wasn't designed to fix before calling it general.
[G] If there's one line to take from RefactorBench, it's that these agents don't fail at refactoring because they can't write the diff. They fail because they lose track of what they've already done, and a simple external memory recovers a real chunk of that.
[O] My takeaway: the fix is more exciting than the gap. An interface change, no retraining, recovering that much performance says something genuinely optimistic about how much headroom is sitting in agent scaffolding rather than in model scale.
[S] Mine: read every headline number in this paper as provisional, given the authors' own admission that their baselines are already stale, and go read the full writeup on litsearch dot darvinyi dot com for the figures and the exact numbers we quoted today.
