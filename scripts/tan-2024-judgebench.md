---
slug: tan-2024-judgebench
title: "JudgeBench: A Benchmark for Evaluating LLM-based Judges"
description: "Most LLM judges land barely above a coin flip on response pairs where one answer is objectively right and the other is objectively wrong — until you hand the job to a reasoning model."
date: 2026-07-19
guest_name: "Rhydian"
guest_voice: "bm_lewis"
---
[S] Flip a coin. On this benchmark, that is roughly how well a vanilla GPT-4o judge does at telling a correct answer from a wrong one.
[O] Except the same benchmark also has a reasoning model landing above eighty percent on that exact same task, so the real story isn't "judges are broken," it's "judges vary enormously."
[S] Sure, but the judges most people are actually deploying today, the cheap prompted ones, are the ones clustering right at that coin flip.
[O] Which is exactly why this paper earns forty minutes of your commute.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the frontier of AI evaluation. Today's paper is JudgeBench, A Benchmark for Evaluating LLM-based Judges, by Sijun Tan and colleagues at UC Berkeley and Washington University in St. Louis, published at ICLR twenty twenty-five.
[S] Joining us is Rhydian, a researcher who has spent real time inside this paper's pipeline and its results table. Welcome, Rhydian.
[G] Glad to be here. This is one of those benchmarks that quietly changes how you read every other judge benchmark once you've seen it.
[O] Rhydian, set up the gap. Why do we need yet another judge benchmark?
[G] Because almost every existing one asks the same question: does the judge's verdict match what a crowdsourced human would have picked. Chatbot Arena, MT-Bench, that whole lineage.
[G] The authors argue that's a fine proxy when two responses differ in tone or helpfulness, because ordinary annotators are good at spotting that. It falls apart once judging requires actually checking a multi-step math derivation or a subtly buggy function.
[S] Because at that point the humans supplying the "ground truth" are themselves just guessing.
[G] Exactly, and that's the paper's central move. They lay out a three-part hierarchy a good judge should respect: does the response follow instructions, is it factually and logically correct, and only then, does its style match human taste.
[G] Humans judge principles one and three fine. Principle two, correctness, is where crowdsourced preference stops being trustworthy, and no prior benchmark had isolated it. LLMBar came closest, but only for instruction-following.
[O] And this matters for more than leaderboard bragging rights.
[G] Right. Judges aren't just ranking chatbots, they're used as verifiers in best-of-N sampling and as reward signal during RLHF. A systematically wrong judge doesn't just misjudge one output, it actively steers training toward whatever it mistakes for correct.
[S] So the stakes are the training loop itself, not just who's on top of a leaderboard.
[O] Walk us through how you actually build a benchmark around "objectively correct," Rhydian.
[G] The key insight is almost embarrassingly simple: if a model struggles to consistently answer a hard question correctly, it will also struggle to tell its own correct answer from its own incorrect one. That single observation drives the whole pipeline.
[G] So instead of pulling two responses from two different models, which invites stylistic confounds and lets a judge win just by recognizing which model wrote which answer, the authors sample several responses from one strong model, GPT-4o, to the same question. Each sample gets graded against the source dataset's own verifier, and they keep only questions where the samples split into at least one right answer and one wrong one, then pair a correct response with an incorrect one.
[S] So same model, same prompt, roughly the same style and length, the only real difference between the two responses is whether the content is actually right.
[G] Precisely, and that's what lets them call the label objective rather than a matter of taste.
[O] Where do the questions themselves come from?
[G] Four existing datasets, one per category, each already shipping a verifier. Knowledge comes from MMLU-Pro, twelve thousand college-level multiple-choice questions across fourteen disciplines. Reasoning and math both come from LiveBench, which refreshes its question pool monthly specifically to resist contamination. Coding comes from LiveCodeBench, contest problems pulled from LeetCode, AtCoder, and Codeforces.
[G] Correctness checking combines a regex match against the ground truth with a second pass from GPT-4o-mini, which independently reads the response and judges correctness. Any case where the two disagree gets discarded rather than trusted either way.
[S] That's a nice belt-and-suspenders move, it catches cases where a genuinely correct answer just got marked wrong on a formatting technicality.
[G] Right. The end result is three hundred fifty response pairs: a hundred fifty four knowledge, ninety eight reasoning, fifty six math, forty two coding, all built from GPT-4o's own responses.
[O] And because every judge is known to favor whichever answer it happens to see first...
[G] They score every pair twice, once in each order, and only count a verdict as correct if the judge picks the right answer both times, consistently. A tie, or a flip between the two trials, counts as incorrect. No partial credit.
[S] Which sets a real random baseline. With exactly one objectively correct response per pair, a judge with zero signal should land at fifty percent by construction.
[G] That's the anchor every result gets read against.
[S] One more thing before results: did they check for length bias? Judges are notorious for just preferring the longer answer.
[G] They did, and because both responses in a pair come from the same model, it's mostly neutralized by construction. Across all three hundred fifty pairs, correct and incorrect responses average around five hundred sixty two versus five hundred sixty one tokens. Essentially no gap.
[O] Okay, give us the headline number.
[G] Vanilla GPT-4o, just prompted to pick A or B with no explanation, scores fifty point eight six percent overall. Statistically indistinguishable from a coin flip.
[S] And that's not even the worst case.
[G] It isn't. Google's VertexAI evaluation service, running Gemini-1.5-Pro, scores forty four point five seven percent, which is actually below random guessing. A better prompt helps GPT-4o some: the Arena-Hard style prompt, which has it draft its own reference answer first, lifts it to fifty six point five seven percent. Still not exactly reassuring.
[O] What about the fine-tuned judges, the ones trained specifically to do this job?
[G] Mostly worse, and for a very concrete reason: many of them simply fail to produce a usable decision. PandaLM calls a tie on four hundred seventy nine of seven hundred judgments. One model, Prometheus two, outputs an unparseable verdict on two hundred fifteen of seven hundred. Several fine-tuned judges flip their answer between the two swapped trials on more than half the pairs.
[S] So it's not that they're confidently wrong, a lot of the time they just can't commit to an answer at all.
[G] Right, and PandaLM lands at thirteen point one four percent overall, well below random, largely because ties get scored as failures. The exception is Skywork's judges, fine-tuned on current Llama-3.1 models, which hit fifty seven point four three percent at seventy billion parameters and actually beat the prompted Arena-Hard judge on the same base model.
[O] Now here's where I get to be smug for a second. What happens once you swap in an actual reasoning model?
[G] The story flips completely. Freeze the same Arena-Hard prompt and swap the underlying model: o3-mini on high reasoning effort reaches eighty point eight six percent overall, including a perfect score on the coding split. o1-preview reaches seventy five point four three percent. DeepSeek-R1 reaches seventy three point one four percent.
[S] That's a thirty-point swing from the identical prompt, just by changing which model is doing the thinking.
[G] And even among non-reasoning general models there's a large spread. Claude-3.5-Sonnet leads at sixty four point two nine percent, well clear of GPT-4o, while Claude-3-Haiku trails at thirty three point one four percent. A thirty-one point gap between the best and worst general-purpose model on the identical setup.
[O] What about reward models, the ones that just output a scalar score instead of a verdict?
[G] They hold up surprisingly well, and more consistently. Several purpose-built reward models cluster in the fifty-nine to sixty-four percent range regardless of size, anywhere from two billion parameters up to twenty-seven billion. Skywork's own eight billion parameter reward model scores sixty two point two nine percent, crushing the plain Llama-3.1 eight billion instruct model used as an Arena-Hard judge, which only manages forty point eight six percent.
[S] So training a small model specifically to verify buys you more than just making it bigger.
[G] That's exactly the authors' read: training data quality for this specific skill, verification rather than conversation, seems to matter more than raw scale.
[O] And the multi-agent judge, the one where models debate before scoring?
[G] ChatEval scores thirty four percent, worse than just asking vanilla GPT-4o once. Two personas debate for up to four rounds before each scores the candidates, and on these hard, single-correct-answer pairs, that extra deliberation doesn't surface a decisive error, it just seems to dilute the model's own read.
[O] That's a genuinely useful negative result. More talk doesn't manufacture reasoning that wasn't there to begin with.
[G] One last ablation worth flagging: they compare each model's accuracy as a solver, answering the question cold, against its accuracy as a judge on the same questions. For most models those two numbers track closely. Coding is the one clear exception, solvers consistently beat judges there, while in math the judge often beats the solver.
[O] Alright, let me make the optimist's case. This is exactly the stress test the field needed. It shows plainly that reasoning effort, not clever prompting, is what actually buys judging accuracy, and it hands everyone a cheap, reusable recipe for building more benchmarks like it out of anything that already has a verifier.
[S] I'll grant the recipe is clever. But I think the "judges are near random" framing oversells the finding. The paper's own results show the ceiling moving thirty to forty points once you swap in a reasoning model, on the exact same prompt. That's not really a story about judgment being broken, it's a story about which underlying model you picked.
[G] That's a fair read, and it lines up with the paper's own solver-versus-judge ablation: judge accuracy tracks solver accuracy closely for nearly every model tested. Which suggests JudgeBench is measuring something close to general problem-solving ability, re-expressed as a comparison task, more than some distinct evaluative skill.
[O] Even so, that's useful information. If a judge is only as good as its solving ability, that tells you exactly what to go upgrade.
[S] Sure, but then don't call the headline finding "judges are unreliable," call it "cheap judges inherit whatever reasoning gap the underlying model already has." Those are different claims with different implications for anyone deploying one.
[G] I'd score that point to Skeptic. There's a baseline the paper never runs that would settle it directly: just have the model solve the question itself, then match its own answer against whichever candidate agrees. They note the correlation but never isolate it that cleanly.
[S] Second issue, the fine-tuned baselines. PandaLM, JudgeLM, and Auto-J are all built on small twenty twenty-three era models with tiny context windows the authors had to truncate just to fit the responses in. That's not a fair fight against twenty twenty-four frontier prompted judges.
[G] Also fair, and the paper's own data cuts against the "fine-tuning doesn't work" reading it otherwise invites, because Skywork's judges, fine-tuned on a current base model with better data, are the strongest fine-tuned models in the whole table, and they beat their own prompted counterpart.
[O] Point to Skeptic again, but doesn't that actually strengthen the optimist case? It's not fine-tuning that fails, it's stale fine-tuning.
[S] Granted. My last concern is contamination. The source questions are contamination-resistant by design, LiveBench refreshes monthly. But the response pairs and gold labels JudgeBench itself releases are static, public, and sitting on GitHub with a leaderboard attached. That's exactly the kind of artifact that tends to leak into pretraining data later.
[G] The paper doesn't state a refresh plan for the pairs themselves, so that's a real gap, one level removed from the exact problem the source datasets were chosen to avoid.
[O] I'll concede that one outright. A public answer key with no refresh cadence is asking for trouble down the line.
[G] There's a bias check worth real credit, though it's more interesting than a clean story. The authors rebuilt the whole dataset using Claude-3.5-Sonnet instead of GPT-4o to generate the pairs, and the result isn't simple self-favoritism: every model tested, not just GPT-4o, scores lower on the Claude-generated pairs than on the GPT-4o-generated ones.
[S] So it's less "each model prefers its own mistakes" and more "one generator happens to produce harder pairs than the other."
[G] Mostly, yes, the paper reads it as Claude-3.5-Sonnet being the stronger reasoning model, producing subtler errors in general. But there's a self-bias signal hiding inside that too: Claude itself drops from sixty four point three percent on GPT-4o's pairs to forty four point eight percent on its own pairs, nearly twenty points, while every other model only drops a handful of points across the same two splits.
[O] So Claude judging Claude is uniquely bad, worse than the general difficulty gap alone would predict.
[S] Which still leaves the core worry alive, a benchmark's difficulty depends on which model wrote the wrong answers, and this is one swap between two frontier labs. It says nothing about a model that's distilled from the generator, GPT-4o-mini being trained on GPT-4o's own outputs is a much more insidious version of the same confound.
[G] Agreed, that version of the test doesn't exist in this paper.
[O] Stepping back, what should someone actually building an eval pipeline take from this?
[G] If an LLM judge is verifying anything that requires real reasoning to check, its score on a human-preference benchmark tells you very little about its accuracy on hard, checkable problems. This paper shows those two things can diverge by thirty points or more.
[S] And if a deployment leans on a small, cheaply-prompted judge specifically because it's fast, this is the paper that should send someone to go measure it directly rather than trust an Arena-style leaderboard score.
[O] Whereas if the budget allows for a reasoning model as the judge, or a purpose-built reward model, this is decent evidence the extra cost buys real accuracy, not just longer explanations.
[G] The honest caveat is scope. Everything here is closed-form, checkable correctness. Grading open-ended writing or a multi-turn conversation is a genuinely different problem, and JudgeBench doesn't speak to it directly.
[G] My one-line takeaway from the paper itself: human-preference agreement is the wrong yardstick for a judge once the task requires expertise to verify, and this pipeline is a cheap way to build a benchmark that actually checks that.
[O] Mine: reasoning effort, not judge architecture, closes most of this gap, and that's a genuinely encouraging trend line.
[S] Mine: don't trust a judge's preference-benchmark score to predict its correctness-checking accuracy. Go measure the thing that's actually needed.
[O] That's JudgeBench. The full write-up, figures, and results table are on the litsearch site. Thanks for listening to Litsearch Audio.
