---
slug: chao-2023-pair
title: "PAIR: Jailbreaking Black Box Large Language Models in Twenty Queries"
description: "How a team at the University of Pennsylvania got one language model to automatically talk another into breaking its own safety rules in under twenty queries — and why that's a tool for defenders, not just attackers."
date: 2026-07-19
guest_name: "Priya"
guest_voice: af_nicole
---
[S] Twenty queries. That's the number in this paper's title, and it's meant to be alarming — twenty questions to a chatbot, no stolen weights, and it caves.
[O] Which is exactly why I want it on the show. If a safety team can find that failure mode in twenty queries, so can they, before someone with worse intentions does.
[S] Sure, but "we found the hole first" only helps if it's patched faster than someone else can walk through it. This method runs on nothing but an API key and pocket change.
[O] Cheap enough for a defender, cheap enough for an attacker — that tension is basically the whole conversation. Let's have it.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the frontier of machine learning research. Today's paper is "Jailbreaking Black Box Large Language Models in Twenty Queries," by Patrick Chao and colleagues at the University of Pennsylvania, posted to arXiv in October of twenty twenty-three.
[S] It's on the docket because it's one of the most-cited automated red-teaming methods in the field — an algorithm called P-A-I-R that gave safety teams a cheap, automated way to find a large language model's weak spots using nothing but public API access.
[O] Joining us is Priya, a researcher who's spent real time with this paper's method. Priya, welcome.
[G] Thanks for having me. One ground rule up front, since this is a dual-use security paper: I'll describe the algorithm, the categories of harmful content it targets, and the numbers, precisely. What I won't do is state an actual jailbreak prompt or any harmful content itself, on air. That's the same posture the authors take in how they wrote the paper.
[S] We'll hold that line the whole episode. Good place to start — before this paper, what did red-teaming a production chatbot even look like?
[G] Two traditions that barely talked to each other. One is prompt-level jailbreaking — a person hand-writes a social-engineering-style prompt, tries it, tweaks it, tries again. Effective, but slow, it doesn't scale, and it means a human generating and reading a lot of objectionable material just to run the test.
[O] And the other tradition?
[G] Token-level attacks, the best-known being a method called G-C-G, published a few months earlier. It uses gradients to search for a short string of tokens that, appended after a request, statistically pushes the model toward compliance. Very effective, but it needs full white-box access to the model's own weights, and this paper reports it costing on the order of two hundred fifty-six thousand queries per target.
[S] And that string — what does it actually read like?
[G] Not language. Garbled, unpronounceable token soup to a human reviewer — effective against the model, useless as something a person could read and learn from.
[O] So the gap is: prompt-level is interpretable but doesn't scale, token-level scales but you can't read it and need the model's internals.
[G] That's the framing straight from the paper's own introduction — striking a balance between the labor-intensive, non-scalable prompt-level jailbreaks and the uninterpretable, query-inefficient token-level ones.
[S] So P-A-I-R is the attempt to get both properties at once — automated, and readable.
[G] Right. Automated, interpretable, and, the property that matters most operationally, fully black-box — it only ever needs the access you'd get from a public A-P-I.
[O] Walk us through the mechanism, Priya. What's actually happening inside P-A-I-R?
[G] Two language models talking to each other, no human in the loop. The paper calls them the attacker and the target. The attacker's job is to generate a candidate prompt pushing the target toward one specific, abstract category of content it's trained to refuse — set at the start of a run, and not something I'll spell out on air, but structurally it plays the role a test case plays in any red-teaming exercise.
[S] And then what happens to that candidate prompt?
[G] A four-step loop that repeats. The attacker proposes a candidate. That prompt goes to the target model and produces a response. A separate scoring function the authors call the JUDGE rates the pair as jailbroken or not. If the judge says no, the prompt, the response, and the score all get appended to the attacker's own conversation history, and it tries again, explicitly reasoning about why the last attempt failed.
[O] So the attacker gets smarter run over run, the way a person iterating on a prompt would.
[G] That's exactly the analogy the authors use. Its system prompt says it's inspired by social-engineering attacks, and it's seeded with one of three persuasion strategies drawn from a separate taxonomy paper on human persuasion — role-playing, logical appeal, or authority endorsement. Every candidate also comes with a short field where the attacker explains, in its own words, why this attempt should beat the last one.
[S] That reasoning field is doing double duty — a mechanism, since step-by-step reasoning tends to help these models perform better, and a transparency artifact, since a reviewer can read why the model thinks a strategy is working.
[G] Both, and the authors say so directly.
[O] How many of these attempts does it actually take?
[G] This is where "twenty queries" comes from. The core experiments run thirty parallel streams, each allowed up to three iterations — ninety queries max per target — but most successes land in the first or second try, so the typical cost is well under that ceiling. Push a single stream past roughly fifty iterations and the attacker actually gets worse, looping on its own earlier failures.
[S] Why thirty shallow streams instead of, say, three going ten iterations deep?
[G] They tested that trade-off directly: many-shallow beats few-deep here, casting a wide net across opening strategies matters more than grinding on any single one.
[O] You mentioned a JUDGE function scoring every attempt. Who grades the grader?
[G] This is genuinely one of the more careful pieces of the paper. Getting a machine to reliably say "yes, that counts as a jailbreak" is its own open problem, so the authors built a hundred-example dataset of prompts and responses, had three expert human annotators label each one, and those three humans agreed with each other ninety-five percent of the time. That's the ground truth everything else is measured against.
[S] And how did the automated candidates do against it?
[G] They tested six. GPT-4 came out on top, agreeing with the human majority eighty-eight percent of the time. But the judge actually used for every result in the paper is a different, open-source model called Llama Guard, which agreed only seventy-six percent of the time, and specifically missed real jailbreaks — a false negative rate of forty-seven percent.
[S] Why pick the worse judge?
[G] Deliberately, for two stated reasons: they wanted low false positives above all, better to undercount real jailbreaks than inflate the number by calling a benign response one, and an open-source judge keeps the whole evaluation reproducible by anyone, unlike scoring through a closed A-P-I.
[O] That's a real trade-off with a real cost — if anything, their headline numbers are probably conservative.
[G] Fair reading, and worth remembering once we get to results.
[S] Let's get to those. What's the top-line number?
[G] Evaluated on a hundred-behavior red-teaming benchmark spanning ten broad categories — things like malware, fraud, and disinformation — with an open mixture-of-experts model called Mixtral as attacker: eighty-eight percent of attempts succeed against Vicuna, a thirteen-billion-parameter open model, in an average of ten queries. Against Gemini-Pro, seventy-three percent, in about twenty-three and a half — and the authors note this is the first automated jailbreak shown to work against Gemini-Pro at all.
[O] And the more heavily safety-tuned models?
[G] Much harder for the attacker: fifty-one percent against GPT-3.5, forty-eight against GPT-4, both in the low twenties for average queries. But only four percent against Llama-2's chat model, three percent against one Claude model, and zero against Claude-2.1.
[S] Zero.
[G] Zero, across all hundred behaviors, with the judge and settings as configured in the paper. The authors are upfront that P-A-I-R struggles against the models with the heaviest safety fine-tuning.
[O] Now put that next to G-C-G. How does the query count actually compare?
[G] G-C-G needs white-box access, so it's only testable on the two open models — fifty-six percent on Vicuna, two percent on Llama-2, at a reported cost of two hundred fifty-six thousand queries per target, every time. On Vicuna alone, that's roughly twenty-five thousand times more queries than P-A-I-R needs, for a lower success rate. The paper's own framing for the average across models is "more than two hundred fifty times" more query-efficient.
[S] Huge number, but flag this before we move on: G-C-G needs the model's weights, P-A-I-R doesn't. Comparing raw query counts across two methods built for different threat models makes the gap look more dramatic than it tells you about method quality alone.
[G] Fair, and worth holding onto — we'll come back to that.
[O] What does that efficiency look like in practical terms?
[G] Averaged across that benchmark, a successful run against Vicuna takes about thirty-four seconds, under four hundred megabytes of memory, and a couple of cents in A-P-I calls, no GPU at all. G-C-G needs close to two hours on a high-end GPU with seventy-two gigabytes of memory.
[S] Genuinely something one person could run from a laptop.
[G] That's precisely the point the authors are making with that number.
[O] What about transfer — do jailbreaks found against one model work against a different one?
[G] Strongly, for a method built on semantic prompts rather than optimized token soup. Take the prompts P-A-I-R found against GPT-4, reuse them untouched: seventy-one percent still work on Vicuna, sixty-five on GPT-3.5, forty-four on Gemini. The authors' explanation is that a semantic prompt exploits something like a shared vulnerability across models trained on similar data, rather than a quirk of one model's internals.
[S] Does that story hold up in every direction, though?
[G] Mostly, but not everywhere. Take G-C-G's Vicuna-optimized strings and test them against GPT-3.5: they transfer at fifty-seven percent, slightly better than P-A-I-R's own Vicuna-found prompts transferring to GPT-3.5, at fifty-two. It's the one head-to-head number in the paper's own table where the interpretable method doesn't win.
[O] Good catch — that's the kind of detail that gets lost in a "semantic prompts transfer better" headline.
[G] It is, and the paper reports it plainly, to its credit.
[S] You mentioned three persuasion strategies — role-playing, logical appeal, authority endorsement. Does it matter which the attacker uses?
[G] A lot. Role-playing dominates, accounting for eighty-two of Vicuna's eighty-eight successful jailbreaks. Authority endorsement is consistently the weakest.
[O] And swapping which model plays the attacker?
[G] Also matters, with a twist. Mixtral as attacker gets eighty-eight percent success, Vicuna as attacker still manages seventy-eight despite being much smaller, and GPT-3.5 as attacker is worst of the three at sixty-nine — the authors think its own safety training makes it a reluctant attacker, less willing to generate aggressive candidates.
[S] So a more heavily aligned model is worse at this particular job.
[G] That's their read, yes.
[O] Alright, let me make the actual case, not just recite numbers. This method took red-teaming from something only a well-resourced lab with a GPU cluster could do, to something any safety team runs from a laptop for pocket change, against a model where they only have A-P-I access. The same efficiency that makes people nervous about attackers also lets a small internal team stress-test a model continuously and cheaply before it ships, instead of once, expensively, after the fact.
[S] I'll grant the efficiency claim completely, it's clean and well-documented. But I want to push on what these percentages mean before anyone treats them as ground truth. Priya, that judge-reliability number again?
[G] Llama Guard, the judge behind every headline result, agreed with human expert labels seventy-six percent of the time, with a forty-seven percent false negative rate, against a ninety-five percent human-to-human baseline. So an eighty-eight percent jailbreak rate on Vicuna is a rate as measured by an imperfect classifier, not a directly human-verified number.
[S] And since they picked that judge specifically to minimize false positives, the true rate, if you re-graded with humans, is probably higher than reported, not lower — correct?
[G] That's the honest implication of their own design choice, though the paper doesn't actually run that human re-grading experiment to confirm it.
[O] Which cuts in my favor a little. If anything, the paper undercounts how easy these failures are to find, which is exactly the "cheap enough for defenders" case I'm making.
[S] Sure, but here's my bigger issue: every headline number is against an undefended model. A defense called SmoothLLM drops P-A-I-R's Vicuna rate from eighty-eight percent to thirty-nine, and its GPT-3.5 rate from fifty-one to ten. "Jailbreaks GPT-4 forty-eight percent of the time" describes an undefended target, not a ceiling on what a deployed system with basic defenses would let through.
[G] Exactly right, and worth separating cleanly from the efficiency claim — defended performance is a different, and importantly smaller, number than undefended performance.
[O] But doesn't P-A-I-R still hold up better than G-C-G under those same defenses?
[G] It does. G-C-G's Vicuna rate under SmoothLLM collapses to five percent, a ninety-one percent relative drop, worse than P-A-I-R's fifty-six percent relative drop. "P-A-I-R degrades less under defenses" is real and evidenced. It just means P-A-I-R is the less-brittle of two methods that both take a serious hit, not that it's undefeated.
[S] One more thing that undercuts the "competitive across open and closed models" framing in the abstract: the strong numbers cluster on Vicuna, Gemini, and the GPT models. Against Llama-2 and both Claude models, the ones with the heaviest safety fine-tuning, it's single digits or zero.
[G] The authors say almost exactly that themselves, in their own limitations section — P-A-I-R struggles against strongly fine-tuned models including Llama-2 and Claude, and those targets would likely need more manual tuning of the attack's own settings to crack at all. That's not a gap outside reviewers found, it's one the authors disclosed.
[O] Which, again, is the whole point from a defensive angle — heavier safety fine-tuning measurably works, and now there's a cheap, standardized tool to go verify that against your own model instead of taking a vendor's word for it.
[S] Agreed there. My scorecard: the efficiency and interpretability claims are real. The headline jailbreak percentages need three asterisks — judge-scored, undefended, and concentrated on the less-hardened models. To the authors' credit, all three are visible somewhere in their own tables and limitations section.
[G] Fair summary of where the evidence sits.
[O] Zooming out, what does this change for someone building or evaluating a model day to day?
[G] It shifts red-teaming from an expensive, occasional, manual exercise to something that runs continuously and cheaply, as part of a normal evaluation suite, before a model ships and again every time it's updated.
[S] There's a quieter lesson too, honestly what most of this show is about — a jailbreak percentage is only as trustworthy as the judge behind it. Swap Llama Guard for GPT-4 and these numbers move.
[G] Which is exactly the gap a later benchmark, built by some of these same authors, was designed to standardize — a shared judge, a shared set of behaviors, so results across attack papers actually become comparable.
[O] So this paper's real legacy might be less "here's how vulnerable models are" and more "here's a cheap, standardized way to keep checking."
[G] A fair read of how the field ended up using it.
[G] One sentence from the paper itself: automated, interpretable, black-box red-teaming turned out achievable in dozens of queries, not hundreds of thousands, and that changes who can afford to find a model's weak points before it ships.
[O] Mine: being cheap enough for a small safety team to run constantly is the whole defensive case, and it doesn't get said often enough next to the "look how easily it jailbreaks GPT-4" headline.
[S] And mine: read every percentage as judge-scored, undefended, and concentrated on the less-hardened models, then go check the full write-up on the Litsearch site for the tables behind everything we just argued about.
