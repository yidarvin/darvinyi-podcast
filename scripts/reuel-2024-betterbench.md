---
slug: reuel-2024-betterbench
title: "BetterBench: Assessing AI Benchmarks, Uncovering Issues, and Establishing Best Practices"
description: "A forty-six-criterion audit turns the evaluation lens back on the evaluations themselves, and MMLU, the most-cited benchmark in the field, comes out dead last of twenty-four."
date: 2026-07-19
guest_name: "Marion"
guest_voice: "af_nicole"
---
[S] Every model card in the last two years has done the same thing: report a number on MMLU, another on GPQA, side by side, as if the two scores were equally trustworthy.
[O] They're not treated as equal because someone's being sloppy. They're treated as equal because until this paper, nobody had actually measured which benchmark deserves more trust.
[S] And when someone finally did measure it, MMLU, the most-cited benchmark in the field, came out dead last of twenty-four.
[O] Which is either a scandal or exactly the kind of self-correction a maturing field is supposed to produce. Let's find out which.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the litsearch site. Today's paper is BetterBench: Assessing AI Benchmarks, Uncovering Issues, and Establishing Best Practices, by Anka Reuel, Amelia Hardy, Chandler Smith, Max Lamparth, Malcolm Hardy, and Mykel Kochenderfer, out of Stanford and Northeastern, published at NeurIPS twenty twenty-four's Datasets and Benchmarks track.
[S] It's on the docket because it does something almost nobody does: turn the evaluation lens back on the evaluations themselves. We build benchmarks to judge models. Nobody was scoring the benchmarks.
[O] Joining us is Marion, who has studied this work closely. Marion, welcome.
[G] Glad to be here. It's rare to see a field build an instrument to grade its own instruments, rarer still to see that instrument turned on itself in the appendix.
[S] Start with the actual gap, Marion. What was actually missing?
[G] A structured way to measure quality. The authors define a benchmark, following earlier work by Raji and colleagues, as a dataset plus a metric, picked up by a research community as a shared framework for comparing methods. Under that definition, a benchmark is infrastructure, and infrastructure can be built well or badly. As of late twenty twenty-four, nobody had published a comparative quality assessment covering both foundation-model and non-foundation-model benchmarks.
[O] And that absence has teeth. Model developers cite whichever benchmark flatters the release.
[G] The paper documents that directly. GPT-4, Claude-3, and Gemini's own technical reports put MMLU and GPQA scores side by side with no acknowledgment that, on the authors' later assessment, the two differ enormously in documented quality.
[S] And it's not just marketing copy. Regulators lean on these same numbers.
[G] Right, that's what raises the stakes. The UK AI Safety Institute's Inspect framework bundles MMLU and GPQA together as evaluation tools, and Article fifty-one of the EU AI Act treats benchmark-based evaluation as a compliance pathway for systemic-risk models. If a benchmark's quality is invisible to the people deciding off its score, that's a real gap.
[O] Had nobody tried to fix this before?
[G] Pieces of it. Some papers diagnosed specific benchmarks' flaws. Others, like Narayanan and Kapoor's "Evaluating LLMs is a minefield" essay, raised structural concerns without proposing anything scorable. Adjacent fields have their own best-practice literatures, data cards, FAIR principles, benchmarking guidelines in bioinformatics and hardware, but none covered AI-specific concerns like API access, contamination protection, statistical reporting. BetterBench synthesizes that into one thing a developer, user, or regulator can actually apply.
[S] Walk us through the framework. What are they scoring?
[G] A benchmark's life as five stages: design, implementation, documentation, maintenance, retirement. Design is defining the capability, the tasks, the datasets, the metrics. Implementation is building it and protecting it against contamination and gaming. Documentation is describing all of that so others can scrutinize it. Maintenance is keeping it usable after release.
[O] That's four. You said five.
[G] Retirement is the fifth, communicating a sunset plan and archiving everything once a benchmark saturates. It's in the lifecycle diagram, but unscored, the authors say they can't assess retirement for benchmarks that haven't retired yet.
[S] Fair, you can't grade an event that hasn't happened. Where did the forty-six criteria come from?
[G] A literature review of benchmarking practice, in AI and other empirical fields, plus interviews with more than twenty people across five stakeholder groups: benchmark developers, model developers, model users, AI researchers, regulators. Each interview surfaced what that group actually needs, and those needs got translated into checkable criteria.
[O] Twenty interviews across five groups isn't huge for something meant to cover the whole field.
[G] Fair, and it matters more for the qualitative design considerations than the scored checklist. What matters more here is what happened after: the authors sorted candidate criteria into three buckets. Bucket one, fully under a developer's control, where authors and interviewees reached consensus. Bucket two, developer-controlled but context-dependent, discussed qualitatively rather than scored. Bucket three, outside a developer's control entirely, like enforcing contamination or construct validity, set aside as open challenges.
[S] So only bucket one gets scored.
[G] Only bucket one, a deliberate choice to keep the framework actionable rather than aspirational, and the single most important design decision in the paper. We'll come back to what it leaves out.
[O] How's that bucket broken down?
[G] Design contributes fourteen criteria, is the capability defined, are domain experts involved, are human and random performance levels reported. Implementation contributes eleven, is code available, is there a training-on-test-set check, is significance reported. Documentation contributes nineteen, requirements files, quick-start guides, documented limitations. Maintenance contributes three, was the code touched recently, is there a feedback channel and a contact.
[S] Those add up to forty-seven, not forty-six, by my count.
[G] They do, a real inconsistency, one criterion effectively double-counted across the figure tables versus the abstract's number. Exactly the kind of slip the framework itself would dock a benchmark points for.
[O] That's almost too on the nose.
[G] Each criterion gets a discrete score: zero for not acknowledged, five for acknowledged but not addressed, ten partial, fifteen fully addressed, or not applicable. Their reasoning for that coarse scale: a five versus a ten is easier to judge reliably than a two versus a three on something finer.
[S] Who's doing the scoring, and how do you keep two people from just disagreeing?
[G] Two authors independently scored all twenty-four benchmarks against all forty-six criteria, reconciling disagreement through discussion, with a third reviewer on standby to break ties. That tiebreaker was never actually needed.
[O] Never needed, over a thousand scoring calls. That's either remarkably tight agreement or a red flag, and I have a feeling which side you'll land on, Marion.
[G] I'll hold that for the debate, it connects to something the paper doesn't report.
[S] Tease accepted. Who were the twenty-four benchmarks?
[G] Sixteen foundation-model benchmarks, MMLU, GPQA, BIG-bench, HellaSwag, AgentBench, DecodingTrust, GSM8K, ARC Challenge, BBQ, BOLD, Codex HumanEval, MLCommons AI Safety, MMMU, TruthfulQA, WinoGrande, Machiavelli, plus eight non-foundation-model benchmarks spanning reinforcement learning, medical imaging, and PDE simulation. Chosen for being commonly used or recently reported by major developers, evaluated only from what those developers themselves published.
[O] And the whole assessment is public?
[G] A living, continuously updated repository, openly licensed, with a channel to submit new benchmarks or correct scores. The same criteria are repackaged as a pre-deployment checklist for anyone building a new benchmark.
[S] The actual numbers. What does the average benchmark look like?
[G] Averaged across all twenty-four, design scores ten point seven out of fifteen, weighted usability, implementation, documentation, and maintenance combined, scores eight point seven. Benchmarks are better at stating what they test than at being easy to run, replicate, and maintain.
[O] Break that gap open for me.
[G] Implementation is by far the weakest, six point two, versus ten point eight for design, ten point one documentation, nine point six maintenance. Not just a low mean, the spread is wide and right-skewed, near zero up to near ten, while design and documentation cluster tighter in the seven-to-fourteen range.
[S] Nine point six for maintenance sounds respectable though.
[G] The mean hides a bimodal split. Maintenance scores pile up at both zero and fifteen, benchmarks tend to either actively maintain their repository or almost entirely abandon it.
[O] Put names on this. Who scored where?
[G] MMLU, arguably the single most-cited foundation-model benchmark in the field, scored the lowest weighted average of all twenty-four, at five point five. GPQA scored eleven point oh, roughly double. HellaSwag, BOLD, and MMMU cluster down near MMLU on usability. DecodingTrust, PDEBench, GPQA, and AgentBench sit high on both.
[S] Is that noise, or a real relationship between designing something well and building it well?
[G] A Pearson correlation between design and usability: for foundation-model benchmarks alone, point seven three oh, p value point oh oh one. Combined across all twenty-four, point six nine three, p under point oh oh one. Both significant. For the eight non-foundation-model benchmarks alone, point four seven seven, p point two seven nine, not significant, but that's an underpowered sample of eight, not evidence of a real categorical split.
[O] So well-designed benchmarks also tend to be well-built.
[G] That's the shape of it. A separate bootstrap test, meanwhile, found no significant difference between foundation-model and non-foundation-model benchmarks' mean design or usability at the ninety-five percent confidence level, even though the raw table shows visibly different implementation and maintenance means.
[S] The two findings that made me sit up. Statistical rigor.
[G] Fourteen of twenty-four assessed benchmarks don't report statistical significance or re-run their evaluation, different seeds, different sampling temperatures, to separate real model differences from noise. Average score on that one criterion, five point six two out of fifteen.
[S] And reproducibility.
[G] Seventeen of twenty-four ship no easy-to-run script to replicate their own results. Four more replicate only part. That leaves three of twenty-four with full replication support, an average of three point seven five out of fifteen. A related signal, a passing GitHub build status, is met by three of the twenty-four.
[O] None of that is exotic. The authors say it themselves, code documentation and a point of contact aren't hard or time-consuming to add.
[G] Their framing exactly, small changes, significant improvements, and most of the field is skipping the easy wins.
[O] Time for the actual argument. My case: this is the first cross-cutting, scored assessment of AI benchmarks anyone's built, and it's immediately actionable, not a complaint. A developer gets a literal checklist, users get a public, updated scoreboard instead of vibes, and the missing fixes, a requirements file, a contact, a CI badge, are cheap. A field correcting one of its blindest spots with almost no excuse not to.
[S] I'll grant the shared vocabulary is real. My problem is what's underneath the numbers. The criteria are equally weighted, a genuinely hard one, like getting domain experts involved, counts the same as adding a contact email. The authors admit it themselves, and even acknowledge developers could game the assessment by chasing easy points.
[G] Accurate, their own admission. Their defense: even a benchmark gaming the easy criteria ends up higher quality than one meeting none, a reasonable floor argument, but it means the forty-six-point score isn't a clean ranking, it's closer to a compliance count.
[O] Counterpoint: perfect weighting was never available, and a coarse, transparent scale beats an opaque one.
[S] Sure, but transparency about the scale doesn't fix subjectivity in applying it. Section five lists design considerations the authors chose not to score at all, general versus specific scope, static versus dynamic design, whether small improvements are even detectable, too context-dependent to grade fairly. Honest exclusion, but it means the forty-six are, by the authors' own admission, the easy-to-judge subset of what actually matters.
[G] Which connects to the deepest gap, one the authors name themselves rather than bury: this checklist measures process, is a benchmark documented, reproducible, maintained, not construct validity, whether it measures the capability it claims to at all. Their limitations section says assessing that needs in-depth domain-expert analysis, out of scope. A benchmark can score full marks on all forty-six criteria while measuring the wrong thing, or nothing coherent at all.
[O] That's a real gap, but an honestly disclosed one. Most papers bury their weakest assumption. This one puts it in a numbered limitations section.
[S] Disclosure isn't the same as the problem going away. And here's what bothers me most: BetterBench turns its own checklist on itself, in an appendix, as a proof of concept.
[G] Appendix I point two, genuinely useful to attempt, most self-assessment papers never try it. But look what comes out: three design criteria marked not applicable, with justifications that are themselves judgment calls. Human performance level, not applicable, a human can't be an evaluation target here. Random performance level, not applicable, random generation can't constitute an AI benchmark. And the one that actually matters, "automatic evaluation is possible and validated," marked not applicable because, quote, we manually evaluate all benchmarks, since the source material doesn't follow a standard structure.
[S] Say that back plainly. The one criterion asking whether your own scoring is validated against something checkable gets waved off as not applicable to itself.
[G] Exactly. For a framework whose entire pipeline is two humans reading websites and repos and assigning a zero, five, ten, or fifteen, that's the criterion you'd most want answered honestly, and it's the one they exempt.
[O] To be fair, they do report a reconciliation process, two independent scorers, a tiebreaker in reserve.
[S] Never invoked once, across twenty-four benchmarks times forty-six criteria, over a thousand calls. No Cohen's-kappa-style agreement number, no raw disagreement rate before reconciliation. "We always agreed" is possible. It's also what you'd hear whether agreement was genuinely tight or negotiated down to consensus mid-discussion, and a reader can't tell which.
[G] One more limitation worth naming, because the authors raise it themselves, not the usual thing benchmark papers admit: their impact statement flags that criteria like domain-expert involvement may structurally favor well-resourced, well-connected labs over smaller teams, regardless of how sound the underlying benchmark idea is. They flag it. They don't correct for it in the scoring.
[O] Credit for flagging it honestly, most papers don't even do that much.
[S] Credit given. It just means a low design score and a poorly conceived benchmark stay conflated, for exactly the teams with the fewest resources to fix that.
[O] Zoom out. If this framework gets adopted, what actually changes?
[G] Optimistically, benchmark scores stop being treated as interchangeable. A regulator citing MMLU and GPQA in the same breath, the way the paper says Inspect does, would have to reckon with an eleven point oh versus five point five gap in documented quality, not just two accuracy numbers.
[S] Pessimistically, the sample skews old and established, MMLU dates to twenty twenty, GSM8K and ARC Challenge earlier still. Judging a twenty-twenty-vintage benchmark against twenty-twenty-four best practices, canary strings, encrypted eval sets, CI badges, risks penalizing benchmarks for missing norms that didn't exist when they shipped.
[G] Fair caveat, the paper doesn't discuss when a given practice became standard. It matters more for interpretation than the scores themselves, the criteria are checked against present-day best practice by design.
[O] Either way, publishing a living, public scoreboard instead of leaving quality to word of mouth feels like the right direction, regardless of where any single number lands today.
[G] If there's one line to take from the paper itself: this is a minimum quality assurance, a floor, not a ceiling on trust, and whether a high score predicts anything the field cares about is a question the authors raise and don't answer.
[O] My takeaway: a public, shared checklist for benchmark quality was long overdue, and even an imperfect one beats trusting a benchmark because everyone already cites it.
[S] Mine: documentation and reproducibility are necessary, but they're not the same as measuring whether a benchmark is actually right, and BetterBench is honest enough to say so about itself. For the figures and the rest of the critique, find the writeup on the litsearch site.
