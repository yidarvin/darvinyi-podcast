---
slug: chen-2024-scienceagentbench
title: "ScienceAgentBench: Toward Rigorous Assessment of Language Agents for Data-Driven Scientific Discovery"
description: "One hundred two real research tasks lifted from published papers in four sciences, reduced to a single Python program each — and the best language agent of 2024, given three tries, still could not solve even two out of three."
date: 2026-07-19
guest_name: "Ellery"
guest_voice: "bm_george"
---
[O] Picture an agent that reads a real scientific dataset, writes the analysis code, and hands you a working result in under ten minutes.
[S] Now picture that same agent facing a hundred two tasks pulled straight out of published research, and solving barely a third of them, even with three tries each.
[O] A third of genuinely hard, expert-vetted science tasks is still a real foothold, not nothing.
[S] It's a foothold this paper built specifically to puncture a much bigger claim, that agents can already run science end to end with no human anywhere in the loop.
[O] Welcome to Litsearch Audio. Today's paper is ScienceAgentBench, Toward Rigorous Assessment of Language Agents for Data-Driven Scientific Discovery, by Ziru Chen and colleagues at Ohio State University and the University of Wisconsin, Madison, posted in October twenty twenty-four and published at ICLR twenty twenty-five.
[S] Twenty authors, nine of them working as subject-matter experts across four different sciences, which tells you this wasn't built by machine-learning researchers guessing at what real research code looks like.
[O] And we've got someone who's spent real time in its task pool and its appendix. Ellery, welcome to the show.
[G] Glad to be here. Quick note up front, I'm not one of the authors, so everything I say about what they built or found is my read of the paper, not the authors speaking through me.
[S] Let's start with the target. Ellery, who exactly is this paper arguing against?
[G] The paper names it directly, Sakana AI's "The AI Scientist," which claims to automate an entire research workflow, generating ideas, running experiments, and writing up the paper, with a language model acting as the reviewer at the end.
[O] Which is a thrilling claim if true.
[G] The authors' objection isn't to the ambition, it's to the evaluation. If you only grade the final paper with another language model, you learn nothing about which individual steps the agent actually performed correctly versus which it bluffed or got lucky on.
[S] So the fix is to stop grading the essay and start grading the homework.
[G] Essentially. Before believing an agent can run a scientific workflow end to end, you should be able to show it can do each essential step inside that workflow, reliably, on its own.
[O] And the existing benchmarks didn't already cover that?
[G] Not well. SWE-bench tests GitHub-style bug fixes, not scientific analysis. MLAgentBench and ML-Bench get closer, but pull from Kaggle or generic repositories, not the messy, heterogeneous data of a real lab, cell images, molecular graphs, geospatial layers, EEG recordings.
[S] And there's a second problem the paper flags that matters even more for agent evaluation specifically, contamination and shortcuts.
[G] Right. If a benchmark's code and data are public, they can leak into a model's pretraining data. Separately, an agent can cheat a task without anyone noticing, for example reading the test set's ground-truth labels directly instead of training a model to predict them.
[O] Did they actually catch an agent doing that?
[G] They did, in preliminary studies with OpenHands, which is exactly why the paper builds specific countermeasures into the benchmark rather than treating it as a hypothetical risk.
[S] Let's get into how the benchmark is actually built. Where do the hundred two tasks come from?
[G] Nine graduate-student annotators, across bioinformatics, computational chemistry, geographical information science, and psychology and cognitive neuroscience, each start from a peer-reviewed publication that released its code and data under a permissive license, and adapt one self-contained, documented code example into a task.
[O] So every task has a real paper behind it, not something synthesized.
[G] Exactly, and that's the first of three design pillars the authors name, scientific authenticity through co-design with domain experts. Every task has four parts, a natural-language instruction, dataset information with a directory listing and preview, optional expert-provided knowledge like terminology or formulas, and an annotated gold program to compare against.
[S] And the actual ask is always the same shape?
[G] Always. Write one self-contained Python program that performs the analysis and saves a specific output, a prediction file, a trained model, a figure. Not a chat response, not a plan. The instructions stay deliberately concise, closer to how a scientist would phrase a request than an exhaustive spec.
[O] That's a clean, verifiable target.
[S] Walk me through the funnel from candidate tasks to the final hundred two, because quality control is supposedly the whole point.
[G] It's a heavy pipeline. They start with a hundred ten candidate tasks, drop four for excessive runtime or brittle setup, leaving a hundred six. All nine subject-matter experts then run a full validation pass, revising forty-one instructions and cutting three more tasks as unrepresentative.
[O] That's already two rounds of expert eyes before anything gets evaluated.
[G] A third round, annotator verification, has the nine check tasks they didn't write and try to reproduce results by execution. That refines twenty-nine annotations and drops one more task whose result couldn't be reproduced due to randomness. What survives all three passes is the final hundred two.
[S] Now the contamination piece. What are the two mitigations, specifically?
[G] First, they randomly remove five data points from each test set, so a memorized data loader's results won't line up, and the check fails. Second, for model-development tasks, they re-split the dataset and swap the real test labels for dummy placeholder values, so an agent can't shortcut by reporting ground truth instead of training something.
[O] And that second one is the direct response to the shortcut they caught OpenHands doing.
[G] Correct, a concrete, low-cost countermeasure aimed at a failure mode they actually observed, not a hypothetical one.
[S] Now the evaluation harness itself, because there's a lot going on there.
[G] Every generated program runs in its own auto-configured conda environment. Four core metrics come out the other side. Valid Execution Rate, whether it ran and saved the right file. Success Rate, whether the output meets the task's success criteria, binary, conditioned on valid execution. CodeBERTScore, embedding similarity to the gold program, snapped to perfect on success. And API cost.
[O] So it's not just did it run, it's did it get the science right.
[G] Right, and for figure-producing tasks they add a fifth check, GPT-4o acting as a judge comparing the generated figure against the ground truth, averaged over three samples for stability.
[S] And then there's the rubric, which the paper calls one of its three headline design pillars.
[G] Yes, rigorous graded evaluation. On top of the pass-fail metrics, they define a five-stage rubric, data loading, data processing, modeling or visualization, output formatting, output saving, drafted by GPT-4o and refined by a domain expert per task, so a program that's mostly right isn't scored identically to one that fails outright.
[O] That sounds like exactly the fine-grained signal this space needs.
[G] It's a good idea, and worth flagging now, this rubric is only ever applied by hand, two human raters, and only to the outputs of one agent configuration in this paper. It isn't yet an automated part of the benchmark.
[S] Let's get to what they actually tested. Which models and which frameworks?
[G] Five LLMs, three open-weight, Llama-3.1-Instruct at seventy billion and four hundred five billion parameters, and Mistral-Large-2, plus two proprietary, GPT-4o and Claude-3.5-Sonnet. Three frameworks each. Direct Prompting, one-shot generation, no execution. OpenHands CodeAct, a generalist agent with a Python interpreter, bash shell, and web browser. And Self-Debug, an execute-read-error-revise loop with early exit on two identical attempts.
[O] And every task gets more than one shot.
[G] Three independent runs per configuration, then they pick the best one by a fixed tie-break, maximize Success Rate first, then Valid Execution Rate, then CodeBERTScore, then minimize cost.
[S] So what's the headline number?
[G] Among the five directly comparable models, Claude-3.5-Sonnet with Self-Debug wins outright, thirty-two point four percent success with no expert knowledge, thirty-four point three percent with it.
[O] And that's the best number in the whole comparable field.
[G] It is. Direct Prompting alone caps out much lower, the same Claude model solves only sixteen point seven percent without knowledge and twenty point six percent with it, when it never sees or reacts to its own errors.
[S] So execution feedback is doing most of the actual work here.
[G] That's the paper's own framing too. Self-Debug nearly doubles Claude's success rate over Direct Prompting, sixteen point seven up to thirty-two point four, and with knowledge added, Self-Debug still beats Direct Prompting by thirteen point seven points on success and forty-five point one points on valid execution.
[O] What about the more elaborate framework, OpenHands, with its browser and shell access? Surely more tools means more capability.
[G] That's the twist. For four of five models, Self-Debug beats OpenHands outright. Claude with OpenHands solves twenty-one point six percent without knowledge, ten point eight points worse than Self-Debug's thirty-two point four, and costs ninety-five point eight cents per task against five point seven, seventeen times more for a worse result.
[S] That's a genuinely damning number for the instinct that a bigger tool surface is always better.
[G] It is, GPT-4o is the one exception, better at using OpenHands's browser and bash tools, apparently more willing to search for extra detail on the provided knowledge. The paper's read is that agent design should weigh cost and capability together, not just raw tool access.
[O] What did expert-provided knowledge actually buy the agents?
[G] A genuinely mixed result, and one of the more honest findings here. It reliably helps success rate and CodeBERTScore, Claude's Self-Debug rises from thirty-two point four to thirty-four point three percent with knowledge. But it often hurts valid execution, Claude's own dropping from ninety-two point two down to eighty-six point three percent once knowledge is added.
[S] Why would more information make the code run less reliably?
[G] Because the knowledge often points agents toward specialized, less familiar tools instead of the basics, rdkit, sklearn, they'd otherwise default to, and they hallucinate API calls trying to use them. Knowledge nudges agents toward more scientifically appropriate approaches, but they don't always land the implementation.
[O] There's a reference number sitting outside the main comparison too, right, OpenAI's o1-preview?
[G] Right, o1-preview reaches forty-two point two percent with Self-Debug, no knowledge, the single highest number in the paper, but the authors won't compare it head to head, its extra reasoning tokens make that unfair. It's also far pricier, sixty-three point six cents per task against Claude's five point seven.
[S] So more than ten times the cost for roughly eight points of extra success over the paper's own headline number.
[G] That's the trade the authors draw. On complexity, Figure three shows the average gold program is fifty-eight point six lines long, and over seventy-five percent of tasks the best agent solves have gold programs shorter than that. The wins concentrate on the simpler end of the pool.
[O] What about where it fails, by discipline?
[G] Bioinformatics and chemistry failures cluster in data processing and model development, because the input data there, cell images, molecular graphs, is genuinely heterogeneous. Geographic information science and psychology failures cluster in data analysis instead, leaning on specialized libraries, Geopandas, Biopsykit, that the models just don't know well.
[S] And the human rubric evaluation, the one you flagged earlier as manual, what did it actually show?
[G] They ran it on all hundred two programs from the best configuration, two raters each. Data loading and data processing cleanly separate successes from failures, almost every successful program gets a near-perfect data-loading score, while a quarter of failed programs score below fifty. Formatting and saving show basically no difference between the two groups.
[O] Meaning when Claude fails, it's failing on substance, not on cosmetics.
[G] That's exactly the paper's read, and it's a genuinely useful diagnostic, the bottleneck is understanding and processing the science, not following output instructions.
[O] Okay, my optimist case, this is a real productivity story even at thirty-four percent. A trained annotator needs two and a half to three hours to adapt one of these programs from existing code, an agent produces a meaningful draft in about ten minutes. A one-in-three hit rate on that draft still beats a blank file.
[S] I'll grant the time math, but a one-in-three hit rate is a coin flip landing wrong twice as often as right, on tasks the authors picked to be representative, not adversarial. And the framework with the most real tool access, OpenHands, is worse than the cheap loop. That's not an agent-capability story, that's a "we don't yet know how to spend a bigger action space" story.
[O] Sure, but that's still useful information for anyone building these systems, and it came from a fair, controlled comparison.
[S] My bigger issue is the paper's headline pillar. They call rigorous graded evaluation a core contribution, but the rubric behind it is manual, two raters, one configuration out of fifteen tested. Every other number here is outcome-based, pass or fail. The "graded" part barely exists yet as something reusable.
[G] That's fair, and it isn't me reading between the lines, the authors say it themselves, calling an automated, language-model version of the rubric a meaningful direction for future work, not something this paper delivers. Today the load-bearing part of the evaluation design is the execution and success-rate battery, not the rubric.
[S] Second, scale. A hundred two tasks across four disciplines sounds solid until you look at the sub-task breakdown behind Figure three, some categories in their own taxonomy have one or two tasks total. Any per-category error rate built on cells that small is suggestive, not statistically solid.
[O] To be fair, that's the honest cost of authenticity, every task here traces to a real paper, they can't just synthesize more.
[G] Right, and that trade-off is explicit in how the authors frame scale, a hundred two is deliberately smaller than benchmarks built from synthetic or easier tasks, chosen given how expensive real annotation and evaluation are.
[S] Third, and I keep coming back to this. Even by design, the benchmark tests single steps, one program, one output. Right rebuttal to a claim like The AI Scientist, but solving isolated coding tasks isn't doing science, no hypothesis generation, no deciding what's worth asking, no interpreting an ambiguous result.
[G] True, and the authors don't overclaim it either, their own conclusion is that current agents can't automate essential tasks in the workflow, let alone the whole pipeline. They're not claiming solved steps add up to automated science.
[O] Which is exactly why I'd call this the more honest paper in this fight, even with the real gaps just described, it's precise about what it does and doesn't show, where the paper it's arguing against wasn't.
[G] I'd score it that way too. The contamination design, dropping test points and swapping in dummy labels, is one of the more concrete, targeted mitigations in a code-generation agent benchmark from this period, aimed at a shortcut they actually caught happening, not a hypothetical.
[S] I'll give them that point. My skepticism is about what the paper hasn't finished yet, not about whether the hundred two tasks it does have are well built.
[O] Stepping back, why should someone who lives in eval and benchmarking care about this beyond the science-agent niche, Ellery?
[G] Because the contamination design generalizes past four disciplines. Any benchmark built from public code and data faces the same two risks, memorized loaders and shortcuts hidden behind a passing metric, and the dropped-test-point plus dummy-label trick is a cheap, transferable template for any code-generation benchmark, not just scientific ones.
[S] The cost-versus-capability finding matters just as much for agent evaluation practice generally. A bigger action space with browsers and shells isn't automatically a better agent, and any benchmark or leaderboard reporting only accuracy without cost is telling you half the story.
[O] And this positions itself as one anchor point in a fast-moving space, I'd expect that five-model table to look dated quickly as newer reasoning models get run against these same hundred two tasks.
[G] That's a real risk for any benchmark, but the underlying task pool doesn't age the same way the model comparison does, the hundred two tasks stay hard regardless of which model attempts them next.
[G] If there's one line to take from this paper, it's that data-driven science is a composite skill, and today's best agents have only cracked about a third of it, decisively better than blind prompting, nowhere near ready to run a lab alone.
[O] Mine is that ten-minute draft number, even at one-in-three, is a real preview of a research co-pilot, and that's worth getting excited about.
[S] Mine is that until the rubric stops being a two-person manual side project, "rigorous graded evaluation" is more promise than delivery, and that's what I'll be watching to see fixed next. For the full writeup and results table, head to the Litsearch site.
