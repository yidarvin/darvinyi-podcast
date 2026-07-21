---
slug: kazemi-2025-big-bench-extra-hard
title: "BIG-Bench Extra Hard"
description: "BIG-Bench Hard used to be the go-to test of general LLM reasoning, until frontier models started clearing ninety percent and it stopped telling us anything. Google DeepMind's harder, stealthier successor drops the best general-purpose model to single digits and the best reasoning model to under half, then admits its own construction bias in plain English."
date: 2026-07-19
guest_name: "Larisa"
guest_voice: "af_bella"
---
[S] Here is a number that should stop you: on the reasoning benchmark Google DeepMind just built, the strongest general-purpose model on the market clears well under ten percent accuracy.
[O] Nine point eight percent, for Gemini 2.0 Flash. That is close to the frontier, and I still want to sit with that number for a second.
[S] And it is not a fluke or a badly built test. The entire point of constructing this benchmark was to push that score down, on purpose, and it worked.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the litsearch site. Today's paper is BIG-Bench Extra Hard, BBEH, by Mehran Kazemi, Bahare Fatemi, and colleagues at Google DeepMind, Google Research, and UCLA, published at ACL 2025.
[S] Larisa, thanks for joining us. You have spent real time inside this paper, and I think the headline number undersells how carefully it was built.
[G] Thanks for having me. This is one of the more self-aware benchmark papers I have read this year, the authors spend real space admitting where their own construction process could bias the results, which is rarer than you would think.
[O] Let us set the stage. Before BBEH there was BIG-Bench Hard, BBH, twenty-three tasks that became the default check on whether a model could reason broadly, not just do math, but handle temporal reasoning, spatial understanding, causal judgment, even humor.
[G] Right. BBH was carved out of the original BIG-Bench dataset in 2022, and for a few years it earned its status honestly, hard for the models of that era, easy to score automatically, and covering a genuinely wide skill set.
[S] Past tense is doing a lot of work in that sentence.
[G] It is. Frontier models were clearing over ninety percent accuracy on many of the twenty-three tasks, and BBH had quietly dropped out of frontier model evaluation reports.
[O] What actually broke it? Because saturation on its own does not tell you whether the models got smarter or the test got easier to game.
[G] Both. The authors point to five cracks. Eight of the twenty-three tasks are binary, and another five offer five options or fewer, so guessing alone already scores well before any reasoning happens.
[S] That is the one that bothers me most. A benchmark where guessing gets you partway there is measuring a floor problem, not reasoning.
[G] There is worse, some tasks had outright shortcuts. In Geometric Shapes, whenever the input contained three of the letter L as drawing commands, the answer was reliably triangle, no actual shape reasoning required.
[O] So a model could pattern-match its way to a good score without ever parsing the geometry.
[G] Exactly. And the rest compound it: inputs were short, a macro average of about seven hundred characters per problem, the tasks only demanded a few hops of reasoning since they targeted older models, and the skill coverage could still be broadened.
[S] So the fix is not "build something completely new from scratch."
[O] No, and I like that restraint. They kept BBH's twenty-three-task skeleton, the same broad map of skills, and rebuilt every task to be dramatically harder, a deliberate choice not to throw out what was working.
[G] That is the core move. Every one of BBH's twenty-three tasks gets a like-for-like replacement, same skill family, much higher difficulty. Logical Deduction, which only needed a few simple steps in BBH, becomes BoardgameQA, built on earlier work by Kazemi and colleagues, where the model chains six to eight hops of deduction and learns a conflict-resolution rule on the fly.
[O] Learn a rule on the fly, meaning it is not something the model could have memorized during pretraining, it has to be extracted fresh from that one problem.
[G] Right, one of several new skills the authors explicitly designed for, alongside things like very long-range dependency and finding errors in a reasoning trace someone else wrote.
[S] Give me a concrete example, because "learn on the fly" can mean almost anything.
[G] Take Buggy Tables. It replaces Penguins in a Table, which used small, clean tables. Here the model gets a large table corrupted during conversion to markdown, a description of exactly how it was corrupted, and has to reconstruct the correct values and answer conditional queries over the fixed table.
[O] That is a real analyst's task, not a toy one.
[G] Word Sorting does something sneakier, it scrambles the alphabet, swapping the letters R and P, so a model that recalls memorized order instead of applying the stated rule gets it wrong. Object Counting and Shuffled Objects just get longer contexts and more distractors.
[S] And some of these tasks are not new inventions at all, are they? A few look borrowed wholesale.
[G] About half, by my count, Linguini for linguistic reasoning, SportQA for sports knowledge, a spatial task adapted from prior work, and causal-judgment items from two existing datasets. The authors are upfront about it, it is assembly and adaptation as much as invention.
[O] I do not think that is a knock. Reusing validated task designs is often smarter than inventing new ones just to say you did.
[S] Hold that thought, because reused public datasets are also datasets with a longer trail sitting online somewhere.
[G] The construction process is the most interesting part methodologically. They picked two reference models, a Gemini 1.5 Flash for the general-purpose ceiling, a Gemini 2.0 Thinking model for the reasoning ceiling, and iterated on each task until both scored below seventy percent.
[S] Below seventy, not near-zero, so there is deliberately headroom left even at construction time.
[G] Right, and there is a great worked example of how hard that was. Boolean Expressions, in BBH, just asks a model to evaluate a true-or-false statement. Their first attempt to add difficulty was simply adding more clauses.
[O] Let me guess, that did not work.
[G] It did not move the needle at all. Investigating why, they found the reference model had quietly started writing a single line of Python to evaluate the expression and print the result, once it could execute the logic, clause count stopped mattering.
[S] That is a genuinely good catch, most benchmark papers would not have looked hard enough to notice the model cheated its way past the intended difficulty.
[G] Their fix was elegant, they replaced some true and false literals with sentences that evaluate to the same truth value, like swapping "True" for "the capital of Canada is Ottawa." That blocks the code-execution shortcut, since there is no clean boolean literal left for a script to grab.
[S] How big is the actual dataset, and how do they score it?
[G] Two hundred questions per task, except Disambiguation QA at one hundred twenty. They also release a smaller four hundred sixty example set called BBEH Mini, twenty per task, for cheaper iteration.
[O] And the headline metric is not a simple average.
[G] No, and this matters. They use the harmonic mean across the twenty-three task accuracies, with a small offset so a zero score does not break the calculation. A harmonic mean punishes unevenness, ace twenty tasks and collapse on one, and that weak task drags the aggregate down far harder than a plain average would.
[S] Which is a deliberate choice to stop a model from gaming the leaderboard by being great at a narrow slice and mediocre everywhere else.
[G] That is exactly their stated reasoning, a metric that rewards being genuinely well-rounded, not a specialist wearing a general-reasoner costume.
[O] Okay, let us get to the numbers, because I have been sitting on that nine point eight percent since the cold open.
[G] They evaluated twelve models plus a random baseline: Llama 3.1, Qwen 2.5, Gemma2 and Gemma3, Gemini 2.0 Flash and Flash-Lite, GPT-4o, DeepSeek R1 and its Qwen 32B distillation, and o3-mini on high effort. The best general-purpose model, Gemini 2.0 Flash, scores nine point eight percent harmonic mean; the best reasoning model, o3-mini high, scores forty-four point eight percent.
[S] And the random baseline?
[G] Two point four percent harmonic mean, eight point four percent under the more forgiving micro-average metric. That confirms the small-answer-space problem from BBH is genuinely fixed, guessing barely helps anymore.
[O] Under micro average the ceilings rise, twenty-three point nine percent for general-purpose models, fifty-four point two for reasoning models, but even the generous scoreboard leaves enormous headroom.
[S] Here is my first real question, though. One of the two reference models they tuned difficulty against was a Gemini thinking model. How did that specific model do on the finished benchmark?
[G] Twenty point two percent harmonic mean, well below o3-mini's forty-four point eight, and this is one of the two models the whole benchmark was calibrated on. If they had secretly overfit the difficulty to flatter their own reference model, you would expect it to top the leaderboard. It does not.
[S] Okay, that is a real point in the paper's favor. I will take it.
[O] And the difficulty generalizes past the two reference models too. o3-mini high clears seventy percent accuracy on only four of the twenty-three tasks, DeepSeek R1 on three, and every other model never clears it on a single task.
[G] The per-task breakdown is where it gets genuinely interesting, because the gap between reasoning models and general-purpose models is not remotely uniform. On Object Counting, GPT-4o scores six point five percent and o3-mini high scores ninety percent. On Temporal Sequences, GPT-4o scores zero and o3-mini jumps to sixty-eight point five percent.
[O] That is an enormous jump from thinking harder, counting and time arithmetic are exactly the kind of formal, step-by-step tasks you would expect extended reasoning to help with.
[S] So where does it not help?
[G] Commonsense, humor, sarcasm, and causal-judgment tasks. On a New Yorker cartoon-caption task and a sarcasm task called SARC Triples, GPT-4o is competitive with, or ahead of, o3-mini. Test-time reasoning helps a lot on formal problems and barely moves the needle on softer, more human ones.
[O] That is a genuinely important nuance. "Reasoning model" is not one dial that turns up every kind of intelligence equally.
[S] There is one task that should worry anyone reading the leaderboard number at face value, Buggy Tables. What is going on there?
[G] Every general-purpose model scores between zero and three point five percent on Buggy Tables. Even DeepSeek R1, a reasoning model, only reaches four point five percent, the one task nobody has cracked.
[S] And because they are using a harmonic mean, one task everybody bombs pulls the whole aggregate score down hard, even for a model that is genuinely strong everywhere else.
[O] Let me make the optimist case plainly. This is exactly the kind of benchmark progress that keeps a field honest. BBH saturated, so instead of quietly retiring it, the authors built a harder, broader successor, self-reported their own construction bias in the text, and the strongest available model still only clears forty-four point eight percent.
[S] I will take the other side. My biggest problem is the calibration loop itself. They tuned difficulty against two Gemini models from the same lab that built the benchmark. The paper says this outright, and I want to quote it: "the choice of the reference model will unavoidably bias the benchmark towards certain types of failure modes." That is not a minor caveat, that is baked into how every task exists.
[G] That is a fair read, and worth crediting that they said it plainly instead of burying it. But the Boolean Expressions story actually cuts against the fear of self-serving bias, the fix they applied made that task harder for anyone who might reach for a code shortcut, not just their own reference model.
[S] Sure, but the paper also says, again in their own words, that "a fair comparison of the reference and non-reference models may not be possible." That is the authors themselves flagging an asymmetry baked into the leaderboard.
[O] Except the strongest evidence against that worry is right there in the results. Their own reference thinking model scores twenty point two percent, well below o3-mini's forty-four point eight. If this were quietly rigged in Gemini's favor, that gap should run the other way.
[S] That helps, I will grant it. But here is a second problem that is more about longevity than bias, where is the coverage? Twelve models, and not one of them is a Claude model. No o1, no full o3, no Gemini 2.5. All of those existed within a few months of this paper.
[G] That is a legitimate gap, and probably not a deliberate exclusion, running twenty-three tasks across a dozen models was already an enormous evaluation budget, and this class of frontier model was moving fast in early 2025. But for a benchmark whose entire premise is comparing reasoning-specialized against general-purpose models, leaving out one of the three leading closed-model families entirely is a real hole in the story, whatever the reason.
[O] Fine, but that is a "run it again with a fuller roster" problem, not a "the method is broken" problem. The scaffolding here, semi-adversarial calibration, harmonic-mean scoring, twenty-three preserved skill families, is reusable infrastructure. Someone can rerun this exact recipe against Claude and o3 tomorrow.
[S] One more, and then I will let it go, construct validity. Is a "harder version of the same reasoning skill" actually testing the same underlying thing, or is it quietly testing something new, like surviving a six times longer context window layered on top of the original skill?
[G] The paper does not really settle that, to be honest, it is an assumption baked into the design rather than something validated empirically. My own read, going a bit beyond what is written, is that it is probably some of both. Longer context and more distractors are themselves reasoning-adjacent skills worth testing, but they are not identical to the six-to-eight-hop deductive skill BoardgameQA is nominally measuring against Logical Deduction.
[S] Which is my whole worry in one sentence, you cannot fully separate "got harder at the thing" from "got harder at something else entirely."
[O] I will concede that one is a real open question. But even holding all of that, forty-four point eight percent on the best model, with a random baseline near the floor, still tells you something true: general reasoning is nowhere near solved, whatever exact mixture of skills BBEH ends up measuring.
[G] One more thing worth flagging on the evaluation-practice side. Roughly half of BBEH's twenty-three tasks repackage datasets that are already public, BoardgameQA's predecessor, the causal-judgment sources, Linguini, SportQA. Those can leak into training data over time the same way BBH itself eventually did.
[S] So the fully procedural tasks age better.
[G] Right, Buggy Tables, Word Sorting, Dyck Language, and Multistep Arithmetic can all be regenerated fresh on demand, so they resist contamination in a way the borrowed half structurally cannot.
[O] Which matters for anyone using this as a running scoreboard rather than a one-time snapshot, you would want to watch whether scores on the borrowed half start creeping up faster than the procedural half over the next couple of years.
[S] And even setting contamination aside, the paper's own conclusion basically admits the shelf life is limited. This exact saturation cycle killed BBH, and nothing about a harder, statically fixed successor makes it immune to the same fate eventually.
[G] The authors frame that as a feature more than a bug, honestly, BBEH buys headroom for now, and when it eventually saturates too, that itself will be a signal that general reasoning has genuinely advanced. If there is one line to take from the paper itself, it is this: once you remove the shortcuts and lengthen the reasoning chain, general reasoning in large language models is still far from solved, even for the strongest reasoning-specialized models available today.
[O] My takeaway is that the forty-four point eight percent is not a disappointment, it is a runway. That is a lot of real, measurable progress still on the table for the field to chase.
[S] Mine is a caution. Watch who calibrates the yardstick, watch which models get tested against it, and remember this exact benchmark will need its own harder successor sooner than anyone expects. Larisa, thanks for walking us through it.
[G] Thanks for having me.
[O] That is it for this episode of Litsearch Audio. For the full write-up and the figures, head to this paper's page on the site. We will see you next time.
