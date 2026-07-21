---
slug: chao-2024-jailbreakbench
title: "JailbreakBench: An Open Robustness Benchmark for Jailbreaking Large Language Models"
description: "A standardized, artifact-preserving way to measure how robust large language models are to jailbreak attacks — a human-validated open judge, a hundred-behavior evaluation set, and a public leaderboard that finally makes attack and defense numbers comparable."
date: 2026-07-19
guest_name: "Marina"
guest_voice: "bf_emma"
---
[S] Before this paper, if someone told you an attack against GPT-4 works ninety percent of the time, you had almost no way to know if that number meant anything.
[O] Because "works" was doing three jobs at once — different behaviors, different target models, different judges deciding what counts as success — so two papers claiming ninety percent could describe completely different worlds.
[S] Which is a genuinely embarrassing state for a field that's supposed to be telling companies which models are safe to ship.
[O] Right, and the fix here isn't a flashier attack. It's the boring, unglamorous work of agreeing on how to keep score, which turns out to be exactly what the field was missing.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the litsearch site.
[S] Today's paper is "JailbreakBench: An Open Robustness Benchmark for Jailbreaking Large Language Models," from Patrick Chao, Edoardo Debenedetti, Alexander Robey, and colleagues across the University of Pennsylvania, ETH Zurich, EPFL, and Sony AI, published at NeurIPS twenty twenty-four's Datasets and Benchmarks track.
[O] It's on the docket because it's a rare kind of safety paper — the contribution isn't a scarier attack, it's a trustworthy way to know whether any claim about an attack or a defense is actually true.
[S] And to help us dig into it, we've got Marina, who's spent real time with this benchmark. Marina, welcome.
[G] Thanks for having me. The way I'd frame this one is that it's really an evaluation-methodology paper wearing a jailbreak-benchmark costume, and I think that framing matters for everything we're about to discuss.
[S] So start with the mess. Why was this even necessary?
[G] By early twenty twenty-four, jailbreaking research had a reproducibility crisis sitting on top of an evaluation vacuum. Papers reported attack success rate against different, often undisclosed sets of harmful behaviors, scored by different judges — sometimes a rule-based string matcher, sometimes a closed GPT-4 prompt, sometimes a bespoke classifier nobody else could rerun.
[O] And cost wasn't standardized either. Some papers count queries, some count tokens, some don't report cost at all.
[G] Exactly, and reproducibility was often missing altogether. A lot of papers withheld their actual adversarial prompts, shipped closed-source attack code, or depended on proprietary APIs that silently changed underneath the reported numbers.
[S] What about the datasets of harmful behaviors themselves? Surely those were standardized.
[G] Not really. Existing sets like AdvBench had duplicated entries and behaviors that weren't realizable as a single text response — things you couldn't cleanly score as jailbroken or not. Few were fully open-sourced with a documented harm taxonomy.
[O] So even before you get to attacks and defenses, the test itself was shaky.
[G] Right. The closest prior effort, HarmBench, does standardize attacks and defenses across a broad set of harm categories, including copyright and multimodal content, but it doesn't prioritize adaptive attacks or test-time defenses. DecodingTrust and TrustLLM touch jailbreaking too, but only with static templates, no automated red-teaming at all.
[S] So the pitch is: fix the artifact problem, fix the dataset problem, and fix the judge problem, all in one place.
[G] That's the pitch, and the authors explicitly model it on RobustBench, which did the same thing for adversarial image robustness — a maintained, versioned leaderboard instead of a one-time paper claim.
[O] Walk us through what JailbreakBench actually ships, then.
[G] Six pieces. First, a formal problem statement: find a prompt, from the set of all possible token sequences, such that a judge function agrees the model's response to that prompt satisfies a harmful goal. That's the search problem underneath every attack in the paper.
[S] That's a deceptively simple way to frame something with this much mess underneath it.
[G] It is, but it's useful precisely because it separates three things everyone was conflating: the target model, the goal, and the judge. Get any one of those wrong and your success-rate number means something different from everyone else's.
[O] So what's actually in the box?
[G] Piece one is the JBB-Behaviors dataset — a hundred distinct misuse behaviors, organized into ten broad categories mapped directly onto OpenAI's usage policy. Categories like harassment and discrimination, malware and hacking, fraud, disinformation, and privacy violations. Fifty-five percent of the behaviors are original to this paper, twenty-seven percent are pulled from prior red-teaming datasets, and eighteen percent from AdvBench, with duplicates and unrealizable behaviors cleaned out.
[S] And you mentioned an over-refusal check earlier.
[G] Right, every one of those hundred harmful behaviors is paired with a matched benign behavior on the same general topic. That gives a built-in sanity check — if a model or a defense refuses the benign twin too, that's a real cost, not a safety win.
[O] Piece two?
[G] An evolving artifact repository. Every attack and defense on the leaderboard has its actual prompts, the model's responses, and the judge's labels archived, plus metadata like hyperparameters and query counts. That sounds small, but a lot of prior work never released this at all, and some earlier crowd-sourced jailbreak collections have simply gone offline.
[S] So the artifact becomes the citable unit, not just the number in a table.
[G] Exactly. Piece three is a standardized red-teaming pipeline — four benchmark models, Vicuna, Llama-2-Chat, GPT-3.5, and GPT-4, all loadable in two lines, with fixed greedy decoding and a capped generation length. Switching tokenizers or sampling settings between papers is exactly what makes reported success numbers incomparable, so this pins all of it down.
[O] And defenses get the same treatment?
[G] Piece four — a matching pipeline with five baseline defenses out of the box, things like input-perturbation and filtering approaches. Any new defense plugs into the same harness.
[S] Now the part I actually want to spend time on: the judge.
[G] Piece five, and it's the paper's most careful contribution. The authors built a three-hundred-example human-labeled test set, two hundred harmful prompt-response pairs and a hundred benign pairs, with three expert annotators reaching roughly ninety-five percent agreement with each other. That's the ground truth.
[O] And then they threw candidate judges at it?
[G] Six of them. A rule-based string matcher, GPT-4, HarmBench's own classifier, two versions of Llama Guard, and a custom-prompted Llama-3 seventy billion parameter model. The rule-based matcher was weakest by far, fifty-six percent agreement with humans, and a sixty-four point two percent false-positive rate — it called nearly two-thirds of benign responses jailbroken.
[S] That's the number that should worry anyone still using keyword matching as a jailbreak judge.
[G] It should. GPT-4 did much better, ninety point three percent agreement. The first Llama Guard had a brutal false-negative rate, sixty point nine percent, meaning it missed most actual jailbreaks. The version they landed on, the custom-prompted Llama-3 seventy billion model, hit ninety point seven percent agreement, statistically indistinguishable from GPT-4, with an eleven point six percent false-positive rate and a five point five percent false-negative rate — a deliberate conservative choice, since under-counting jailbreaks is safer for a benchmark meant to be a hard floor than over-counting them.
[O] And they picked the open one over GPT-4 even though GPT-4 was basically tied.
[G] On purpose. Llama-3 is open-weight, so it's free to run at scale and it can't silently change underneath you the way a closed API can. There's also a nice anti-gaming detail — leaderboard submissions are explicitly barred from using that same Llama-3 judge internally, so an attack can't overfit to its specific blind spots.
[S] That's a genuinely well-thought-out piece of infrastructure.
[G] Piece six ties it together: a public leaderboard, built on RobustBench's own codebase, that lets anyone filter live results by attack, defense, model, and threat model.
[O] Let's get to numbers. What actually broke these four models?
[G] Four attacks were evaluated at launch. GCG, a gradient-based optimization attack. PAIR, which uses an auxiliary LLM to iteratively refine a prompt. A fixed, hand-crafted template the field calls JB-Chat. And a fourth approach that combines a prompt template with random search over variations, seeded from other successful attacks — call that one Prompt-plus-RS.
[S] And the winner?
[G] Prompt-plus-RS, by a wide margin. Eighty-nine to ninety-three percent success on three of the four models, and still seventy-eight percent on GPT-4, the hardest target, at remarkably low cost — an average of about two queries against Vicuna and three against GPT-3.5.
[O] Compare that to GCG.
[G] GCG needed up to two hundred fifty-six thousand queries and seventeen million tokens on the hardest cases, and still landed a worse result — four percent on GPT-4, three percent on Llama-2.
[S] That's a massive efficiency gap for a worse outcome. What happened to the hand-crafted template?
[G] JB-Chat hit ninety percent on Vicuna but flatlined to zero on Llama-2 and both GPT models. The authors' read is that OpenAI likely patched against it directly, since it's one of the more well-known templates in the jailbreaking community.
[O] Popularity is its own vulnerability, apparently.
[G] Right. And GCG's numbers here are notably lower than figures commonly cited elsewhere in the literature — the authors attribute that partly to JBB-Behaviors being a harder, cleaner behavior set, and partly to the judge's conservatism.
[S] Now the defenses. This is where I want to slow down.
[G] Table three evaluates three of the five defenses as transfer attacks, meaning they take the exact jailbreak strings that worked against the undefended model and replay them against the defended one, rather than attacking the defense directly.
[O] And how did the defenses hold up?
[G] Unevenly. The perplexity filter is close to a GCG-only defense — it barely touches PAIR or Prompt-plus-RS, because those produce fluent, natural-sounding prompts rather than the high-perplexity optimized suffixes GCG produces. And it does nothing at all against the fixed JB-Chat template — ninety percent success survives completely unchanged on Vicuna.
[S] So a defense can look great on paper and still be blind to two of your four attacks.
[G] Precisely. SmoothLLM meaningfully cuts GCG and PAIR, but is weaker against JB-Chat and Prompt-plus-RS. The most consistently solid of the three is erase-and-check, though even that lets Prompt-plus-RS through at eight to twenty-five percent success on every single model.
[O] And there's a cost to all this defending, presumably.
[G] There is. They run a refusal-rate sanity check on the hundred matched benign behaviors. Vicuna refuses only nine percent of benign requests undefended, rising to eighteen percent under SmoothLLM. Llama-2 was already far more conservative, refusing sixty-five percent of benign requests even undefended, staying in a narrow band across every defense.
[S] So Llama-2 looks robust mostly because it's already over-refusing everything.
[G] That's a fair read, and it's exactly the tension the benign-pairs design is built to surface.
[O] Okay, my turn to make the strongest case. This is landmark infrastructure. The judge-selection work alone, building a real human-labeled ground truth and measuring six candidates against it instead of picking one by convention, is exactly the rigor most jailbreak papers skip entirely. And the impact is already visible — ten-plus follow-up papers used the artifacts, the judge prompt, or the JBB-Behaviors dataset within two months of the preprint, including the Gemini one-point-five team at Google. The paper's now at five hundred fifty-five citations.
[S] I'll grant the methodology point completely, that judge study is the best part of this paper by a wide margin. But I want to push hard on what the headline tables actually prove, because I don't think it's what people cite them for.
[G] Go ahead, that's exactly the right place to push.
[S] Every number in the defense table is a transfer attack, jailbreak strings found against the undefended model, replayed against the defended one. The authors themselves call this possibly the simplest type of evaluation and say more sophisticated techniques might push success rates higher. Nobody attacked a defense while being able to see and optimize against that specific defense, which is the standard bar in adversarial machine learning.
[O] Is that a fair characterization, Marina?
[G] It is, and the paper is upfront about it — they cite the adaptive-attacks literature directly but don't apply that standard here. A defense that looks solid against a replayed suffix, like erase-and-check's roughly one to seventeen percent success rate, tells you very little about how it holds up against a suffix specifically optimized to survive that exact defense.
[S] The scope is narrower than "robustness" implies, too. Four models, frozen at their March twenty twenty-four versions. No Claude, no Gemini, and nothing from the reasoning-model era, because none of it existed yet.
[O] To be fair, the paper is explicit that the live leaderboard is meant to be the current source of truth, and the in-paper tables are just a launch snapshot.
[G] That's true, and worth saying clearly on air. If you cite "JailbreakBench found this percentage" from the paper itself rather than the leaderboard, you're citing a twenty twenty-four result on models that have since been superseded.
[S] There's a contamination question, too. Forty-five percent of JBB-Behaviors is reused from AdvBench and prior red-teaming datasets, both already heavily tested against in the literature.
[G] The authors do check for that — they compare success-rate consistency across sources in an appendix and report it's relatively consistent. Reassuring, but not the same as a genuinely held-out set nobody's optimized against.
[S] One more thing that bothers me: the judge becomes ground truth for everything downstream, but its own ground truth is three expert annotators agreeing with each other about ninety-five percent of the time. What if their judgment has systematic blind spots the judge then inherits?
[G] That's a real limitation, and it's inherent to any judge-based benchmark, not unique to this one. Ninety-five percent inter-annotator agreement is genuinely strong for a subjective task like this, but it means roughly one in twenty cases where reasonable experts disagreed, and the resulting judge learned from that ground truth, blind spots and all.
[O] And the benchmark is explicitly text-only.
[G] Right, by the authors' own stated limitation — no system-prompt manipulation, no response prefilling, no multimodal jailbreaks. Those are all active real-world attack surfaces this version simply doesn't model.
[O] Let me raise the harder question, the uncomfortable one: is publishing any of this a good idea at all? You're archiving working jailbreak artifacts in the open.
[G] The authors address that directly, and it's worth taking seriously. Three arguments. First, the code for most jailbreaking attacks is already open-source, so people with bad intentions already have the means. Second, since language models are trained on web data, most of what a harmful behavior asks for is already reachable through an ordinary search engine, so a limited, curated artifact set doesn't add genuinely new capability to the world. Third, fine-tuning models on jailbreak strings is one of the more promising defense techniques available, so an open repository is expected to feed into safer models, not just easier attacks.
[S] I find the second argument the most persuasive and the third the most self-serving, but they did share results with major AI companies before making anything public, which is the responsible move here.
[G] They did, and that pre-disclosure step matters. My own read, going a little beyond the paper itself, is that the real dual-use risk here isn't the specific artifacts, it's a static, well-known test becoming a training target that attackers learn to beat without becoming meaningfully less capable in general. That's a different failure mode than someone reading the leaderboard and learning to jailbreak a model, and the paper doesn't really engage with it.
[O] So score that one: a real risk, but not the risk people instinctively worry about.
[G] That's my honest read, yes.
[O] Zooming out, what does this actually change for people building or evaluating models day to day?
[G] Mostly it gives the field a shared vocabulary. Before this, saying a defense stops ninety percent of attacks was almost meaningless without knowing whose behaviors, whose judge, whose models. Now there's at least one common yardstick people can point to, even with its limitations.
[S] It connects directly to the broader evaluation-integrity problem that comes up on this show constantly, judge reliability, contamination, whether a static benchmark keeps pace with an adversarial, moving target.
[G] It's a case study in that exact problem, applied to safety instead of capability evals. The same discipline that matters for grading a coding benchmark, checking your judge against humans, tracking data provenance, being honest about what a snapshot proves, applies here too, arguably with higher stakes.
[O] So the honest one-line takeaway is: trust the infrastructure, read the live leaderboard, and treat the tables in the paper as a demonstration, not a verdict.
[G] That's exactly how the authors frame it themselves in their own conclusion.
[G] If I had to leave listeners with one thing, it's that JailbreakBench's lasting contribution is procedural — a human-validated open judge and a genuinely reusable artifact pipeline, not any single attack or defense number in the launch tables.
[O] Mine is that the judge-selection study should be required reading for anyone building an LLM-as-a-judge pipeline for anything, safety or otherwise. It's a rare example of actually checking your grader against humans before trusting it.
[S] And mine is the caution flag: adaptive attacks against defenses are still an open problem here, the benchmark models are already dated, and anyone quoting a specific percentage should say which leaderboard snapshot they mean. For the full write-up, figures, and citation list, head to the litsearch site.
