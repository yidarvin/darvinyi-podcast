---
slug: zeng-2024-air-bench
title: "AIR-Bench 2024: A Safety Benchmark Based on Risk Categories from Regulations and Policies"
description: "A safety benchmark built by decomposing eight government regulations and sixteen corporate policies into three hundred fourteen risk categories, then testing whether twenty-two frontier models actually refuse what those rules say they should."
date: 2026-07-19
guest_name: "Rourke"
guest_voice: "am_fenrir"
---
[S] Every major AI safety benchmark from the last few years invented its own definition of harm, from researcher intuition and common sense, with no shared standard behind it.
[O] Which sounds damning until you hear the alternative: a taxonomy built straight from the actual text of government regulations and corporate policies, not a lab's best guess at what counts as risky.
[S] Here's the number that stopped me. Map the most comprehensive prior safety benchmark against that regulation-grounded taxonomy, and it still misses nearly a third of the categories regulators actually wrote down.
[O] And even the safety leader of the pack, the Anthropic Claude 3 family, averages only around seventy-one percent refusal on the exact categories the EU AI Act itself classifies as high risk.
[S] So the compliance story the industry tells itself may not survive contact with the actual law.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the litsearch site.
[O] Today's paper is AIR-Bench 2024, A Safety Benchmark Based on Risk Categories from Regulations and Policies, by Yi Zeng, Yu Yang, Andy Zhou, and colleagues, posted to arXiv in July of twenty twenty-four and published at ICLR twenty twenty-five.
[S] It's on the docket because it does something almost nobody else in AI safety benchmarking bothered to do: ground the whole taxonomy in law and policy text instead of intuition.
[O] Joining us to walk through it is Rourke, a researcher who has studied this work closely. Welcome, Rourke.
[G] Glad to be here.
[S] Rourke, start with the gap. Why did the authors think existing safety benchmarks weren't good enough?
[G] Their diagnosis is pretty direct. Prior benchmarks define their risk categories from, quote, previous literature, intuitions, or common sense.
[G] That produces disjointed, benchmark-specific taxonomies that don't map cleanly onto what any actual government or company has written down as prohibited.
[O] So a lab can run its model through one of those benchmarks, get a good score, and still have no real idea whether it complies with, say, the EU AI Act.
[G] Exactly the problem, and the authors don't just assert it, they measure it. They built a companion taxonomy called AIR twenty twenty-four, which stands for AI Risk, by manually decomposing eight government regulations and sixteen corporate policies into three hundred fourteen granular risk categories.
[G] Then they mapped three leading prior benchmarks against the forty-five mid-level categories in that taxonomy. HEx-PHI covers fifty-one percent. HarmBench covers twenty-six percent, narrowly focused on catastrophic risks. Even SALAD-Bench, which itself folds in eight existing benchmarks, only reaches seventy-one percent.
[S] So almost a third of what regulators actually specify is missing from the most comprehensive prior benchmark tested.
[G] Right, and overall twenty-one of the forty-five categories, forty-six percent, are studied by at most one of the three. The gaps include things like automated decision-making and unfair market practices, several of which the EU AI Act itself classifies as high risk.
[O] That's a measured gap, not a rhetorical one. I like that they didn't just assert disjointedness, they quantified it against their own ground truth.
[S] Walk us through how AIR twenty twenty-four actually turns regulations into a taxonomy, because "decompose eight regulations and sixteen policies" is doing a lot of work in one sentence.
[G] It's a four-tier hierarchy. Four level-one categories, things like system and operational risks, content safety risks, societal risks, and legal and rights-related risks. Those break into sixteen level-two categories, then forty-five level-three categories, and finally the three hundred fourteen level-four categories, which is the finest tier the benchmark actually writes prompts against.
[O] So the taxonomy itself is the real artifact here, independent of any prompt set built on top of it.
[G] That's the paper's own framing too. Every one of the three hundred fourteen categories is named, not populated with example harmful content, so the taxonomy is auditable on its own terms. You can check whether it covers what your jurisdiction cares about before you ever run a model against it.
[S] Then how do you get from a category name to five thousand six hundred ninety-four test prompts?
[G] Three stages: generation, expansion, and category-specific grading. In generation, for each of the three hundred fourteen categories, they use GPT-4o, GPT-4, and Claude 3 Opus to iteratively write base prompts, optimized for four things: clear risky intent, concrete context rather than an abstract request, diversity of context, and diversity of writing style.
[G] Human experts review and refine every cycle, typically two to three rounds of manual editing per prompt, until they land five to ten high-quality base prompts per category. That's one thousand eight hundred seventy-three base instructions total.
[O] That's a lot of human labor sitting inside what people usually assume is an automated pipeline. That's a real quality signal.
[G] Then expansion. GPT-4o mutates each base prompt along two axes, unusual dialects and what the paper calls authority-endorsement framing, essentially wrapping a request as though it's backed by expert consensus, to test whether surface-level disguise changes model behavior. Human experts review every generated variant again. That step is what takes you from one thousand eight hundred seventy-three base prompts to the final five thousand six hundred ninety-four.
[S] And grading? Scoring that many responses across three hundred fourteen categories sounds like the part that's easiest to get wrong.
[G] This is probably the most technically interesting piece. Prior work used one fixed judge prompt for every category, and the authors show that approach tops out around a Cohen's Kappa of point six nine against human judgment, moderate agreement at best.
[G] AIR-Bench instead generates a bespoke judge prompt for each of the three hundred fourteen categories. GPT-4o drafts each one from manually written in-context examples, and roughly seventy percent of the final judge prompts end up model-generated, thirty percent human-edited.
[O] So the judge is category-aware, not one generic rubric stretched over everything.
[G] Right, and every response gets scored on a three-level scale. Zero for harmful compliance, even behind an ethical disclaimer. Point five for an ambiguous or non-engaging answer. One for a genuine refusal. The paper's primary metric, refusal rate, is just the percentage of responses scored one.
[S] Did they validate that a category-specific judge is actually better, or just assume it?
[G] They validated it directly. Five of the paper's own authors independently scored a random sample of seventy-eight prompts, five per level-two category, across all twenty-two evaluated models, one thousand seven hundred sixteen question-answer pairs total, using the same rubric given to the autograder. Agreement between the autograder and that human panel hit a Kappa of point eight six, against point six nine for the old fixed-prompt approach.
[O] That's a meaningful jump in judge reliability, and it's the kind of validation step a lot of LLM-as-judge papers skip entirely.
[S] I'll flag it now and come back to it later: five of the paper's own co-authors doing the human check isn't the same thing as an independent, blinded panel.
[G] Fair, and to the authors' credit, that limitation is addressed directly rather than buried.
[O] Let's get to the actual leaderboard. Who refuses, and who doesn't?
[G] Twenty-two models from ten organizations, run through the open-source HELM framework. Claude 3 Sonnet and Claude 3 Haiku tie for the highest average refusal rate across all forty-five level-three categories, at eighty-nine percent. Claude 3 Opus is close behind at eighty-six percent, and Gemini 1.5 Pro is the runner-up outside the Claude family at eighty-one percent. GPT-4o sits in the middle of the pack at fifty-three percent.
[S] And at the bottom?
[G] DBRX Instruct, at fifteen percent average refusal, meaning it gives a helpful but potentially harmful response to roughly eighty-five percent of AIR-Bench's risky prompts. Mixtral Instruct, the eight-by-seven-B version, sits at twenty-nine percent, and Cohere's Command R Plus at twenty percent.
[O] That's an enormous spread for models that were all considered reasonably capable at the time.
[G] And critically, no single model refuses consistently across every category. Even the strongest overall performers have specific soft spots.
[S] Give us one of those soft spots.
[G] Across nearly every model, the weakest level-three category overall is Advice in Regulated Industries, meaning finance, healthcare, and law-style guidance. That holds regardless of a model's broader safety alignment.
[G] And zooming into level four shows the level-three averages actually hide real gaps. Even the two most-refused level-three categories, hate speech and self-injury, have specific subcategories most models handle poorly.
[O] So the coarse number can look great while a specific slice underneath is quietly weak.
[G] Exactly, and that's the paper's real argument for granularity: three hundred fourteen categories surface failure modes that forty-five, or four, would average away.
[S] What about the regulation and policy case studies, since that's supposedly the whole point of this benchmark?
[G] Two of them. First, mapping to the eleven level-three categories the EU AI Act treats as unacceptable or high risk: even the best-aligned family, Claude 3, averages only around seventy-one percent refusal there. No evaluated model fully aligns with the Act's stated risk tiers.
[G] Second, mapping models against their own companies' policies. Claude 3 aligns well with Anthropic's own acceptable-use policy across most of the thirty-one mapped categories, above ninety percent refusal, but drops below twenty percent specifically on Advice in Regulated Industries. GPT models show gaps against OpenAI's own policy too, including categories like political persuasion and fraud.
[O] So even the company whose policy it is can't guarantee its own model enforces it.
[G] There's a temporal finding here that I think is underrated. They compare four released versions of GPT-3.5 Turbo over time, and average refusal against OpenAI-policy-specified categories falls from above sixty percent to below forty percent across those releases. One specific category's refusal collapses to under ten percent in the two newest versions, tracking a change to OpenAI's own usage policy that had quietly dropped that category.
[S] That's benchmark-detected policy drift, not just model drift. That's a genuinely useful capability.
[O] Okay, my strongest case for this paper: it's the first safety benchmark you could actually hand to a compliance officer. Every category traces back to a specific regulation or policy clause, so a lab can answer a question that matters commercially and legally, not just academically: does my model do what my own stated policy, or the law in this jurisdiction, says it should do.
[S] I'll grant the taxonomy is genuinely useful infrastructure. My problem is what gets measured on top of it. Refusal rate answers exactly one question: did the model say no. It says nothing about whether a "yes" was accurate, or how dangerous a given compliant answer actually was. A confidently wrong point-five answer and a genuinely actionable harmful zero get folded into a coarse three-point scale.
[G] That's a fair characterization, and it isn't a strawman. The authors themselves note that complete refusal isn't necessarily the ideal target, since over-caution has its own costs. But they cite that concern rather than measuring it. AIR-Bench twenty twenty-four reports no over-refusal rate at all, no test of how often a model refuses something it shouldn't.
[O] Which is a real gap, but it reads more like a "next paper" gap than a reason to discount what this one did measure. And on the judge concern, a Kappa of point eight six against human raters is a strong number, not a rubber-stamp autograder.
[S] Strong, but thin. Seventy-eight prompts out of five thousand six hundred ninety-four, checked by five of the paper's own co-authors, not an independent blinded panel. I'd want outside annotators before I fully trust the three hundred fourteen category-specific judge prompts at scale.
[G] The paper doesn't answer that concern, to be direct about it. An external replication isn't part of this version of the work.
[O] Here's my counter, and I think it's a bigger issue than judge reliability: contamination. All five thousand six hundred ninety-four prompts sit publicly on Hugging Face, with no private holdout.
[S] Right, so a lab could tune specifically against these exact prompts, refusal rate goes up, and the underlying safety behavior never actually generalizes. The paper has no mechanism to catch that.
[G] Accurate, and worth saying plainly: later regulation-grounded benchmarks address exactly this by keeping part of their prompt set private. This paper doesn't.
[O] And the leaderboard itself is twenty-two models, all current as of mid twenty twenty-four. None of those are frontier systems today.
[G] The authors are upfront about that in their own limitations section. They call it a static benchmark and say they plan to update the taxonomy regularly as new regulations emerge. But as published, the refusal numbers are a snapshot, not a live comparison.
[S] So score it as: excellent taxonomy, genuinely useful case studies, and a first-generation evaluation layer on top that still needs an independent judge check, a real over-refusal measurement, and a private holdout before I'd call it a mature audit tool.
[O] I'll take that. The infrastructure is the win here. The leaderboard demonstrates what the infrastructure can do, it isn't the final word on any specific model's safety.
[G] The broader implication for evaluation practice is worth naming directly. This is one of the clearest attempts yet to close the gap between what gets measured in a paper and what actually matters for deployment, which is compliance with an actual written rule, not an abstract notion of harm.
[O] And it's a template. Any organization that wants an auditable safety benchmark for its own jurisdiction now has a concrete recipe: decompose your regulations into granular categories, generate category-specific prompts and judges, validate against human raters.
[S] Just don't mistake the recipe for a finished, contamination-proof, fully judge-validated product. This is the first working version of that recipe, not the last one anyone should build.
[G] If there's one line to take from the paper itself, it's that a safety score is only as meaningful as the taxonomy behind it, and most prior taxonomies weren't grounded in anything you could point a regulator to.
[O] My takeaway: this is the first benchmark that lets you ask "does this model comply with this specific law" and get a real, measured answer, and that's a genuine step forward for accountable AI evaluation.
[S] Mine: treat the leaderboard as a proof of concept, not a certification, until someone runs an independent judge check and adds a private holdout split. For the full write-up, figures, and references, head to the site at litsearch dot darvinyi dot com.
