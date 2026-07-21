---
slug: nathani-2025-mlgym
title: "MLGym: A New Framework and Benchmark for Advancing AI Research Agents"
description: "Meta builds the first Gym environment for AI research agents, then catches its own frontier models tuning hyperparameters instead of inventing anything new."
date: 2026-07-19
guest_name: "Griffith"
guest_voice: "bm_lewis"
---
[S] Here is the sentence that should worry anyone hyping autonomous AI scientists.
[S] Across five frontier models and thirteen research tasks, the search tool got used eleven times.
[O] Out of thousands of actions, eleven searches, and yet these same agents still managed to nearly double their accuracy on some tasks.
[S] Nearly doubled by tuning, not by having a single new idea. That is the whole tension of this paper in one number.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a guest scholar take one paper apart in public. Today's paper is "MLGym: A New Framework and Benchmark for Advancing AI Research Agents," from Deepak Nathani and colleagues at UC Santa Barbara, University College London, and GenAI and FAIR at Meta, posted in February twenty twenty-five.
[S] Joining us is Griffith, a researcher who has spent real time with this paper and the codebase it shipped. Griffith, welcome.
[G] Glad to be here. This is a paper that's as interesting for what it admits it can't measure as for what it does.
[S] Let's start with the gap. Why did we need yet another agent benchmark in twenty twenty-five?
[G] Because none of the existing ones were built to train agents, only to score them. SWE-bench and SWE-agent test whether a model can resolve a GitHub issue. MLAgentBench covers a handful of single-domain machine learning tasks. MLE-bench frames Kaggle competitions. Each is narrow, each bolts on its own harness, and none exposes a real Gym interface.
[O] And a Gym interface matters because that's the standard reset and step contract reinforcement learning needs.
[G] Exactly — if you want to train research agents with reinforcement learning, curriculum learning, or open-ended learning, you need reproducible state, rewards, and resets, not just a static leaderboard.
[S] There's a second problem buried in there too: how do you even score an agent across wildly different tasks? Accuracy on one, BLEU on another, validation loss on a third, average reward in a game.
[G] Naive averaging is meaningless, and naive ranking is worse, because it disproportionately punishes a model that solves a task well but ties with a competitor. That's the paper's second contribution, a scoring method built to be fair across incommensurable metrics.
[O] So Meta built both halves at once. The framework, called MLGym, and the benchmark suite, called MLGym-Bench.
[G] Correct. And the authors are unusually upfront about placing their own benchmark at Level 1 on a six-level capability ladder they define themselves — Level 0 is reproducing a known result, Level 1 is improving a non-state-of-the-art baseline, Level 2 is reaching state of the art, and Levels 3 through 5 climb from a genuinely novel scientific contribution to a long-term research agenda. MLGym-Bench targets Level 1 only.
[S] So the title says "Advancing AI Research Agents," but the instrument only measures whether a model can nudge a baseline upward.
[G] That's the honest reading, yes. Everything above Level 2 is explicitly left unmeasured.
[O] Walk us through the three pieces of the framework.
[G] There's the Agent, any large language model behind a scaffold, holding the task description, tool documentation, and prompts. There's the Gymnasium Environment, which mediates every interaction. And there's the Computer, a real shell with tools and a file system holding the task's data, code, and requirements. The agent emits an action, the environment forwards it to the computer, and feedback flows back.
[S] So it's a genuine reinforcement learning loop wrapped around what's otherwise a coding agent.
[G] Yes, and that's the headline framework claim: the first Gym interface built specifically for machine learning research tasks, as opposed to software engineering tasks.
[O] What's actually in the action space?
[G] It's built on SWE-Agent's Agent-Computer Interface — search, file navigation, a line-numbered viewer, a linting editor. MLGym adds a permission system, so editing a read-only evaluation script returns a feedback string instead of silently corrupting the eval, plus a literature-search and PDF-parsing tool, and a Memory Module that lets the agent write and re-read "research logs" so findings carry across a long run.
[S] How long is a run, concretely?
[G] Capped at fifty steps, each individual action has to finish within eighteen hundred seconds, and whatever codebase state exists at the end gets auto-submitted.
[O] And the benchmark itself, MLGym-Bench, is thirteen tasks?
[G] Thirteen open-ended tasks spanning computer vision, natural language processing, reinforcement learning, and game theory. Concretely: CIFAR-ten, Fashion-MNIST, MS-COCO captioning, MNLI, language modeling on FineWeb, Atari Breakout, MountainCar, Meta Maze, three-SAT, house-price regression, and three game-theory tasks — Battle of the Sexes, Prisoner's Dilemma, and Blotto.
[S] That's a fairly small and fairly familiar list. We'll come back to that.
[O] What exactly is the AUP score?
[G] Area under the performance profile — adapted from Dolan and Moré's two thousand two optimization work, and from the AutoML Decathlon competition. For a given task and model, you compute a performance ratio against the best model on that task. Across all tasks, you ask: for what fraction does this model land within a factor of ten to the tau of the best, tau being a log-scaled tolerance, inverted for metrics where higher is better. Integrate that fraction over tau, and you get one number per model. Higher AUP means better.
[S] So it's explicitly relative to the pool of models you happened to run, not an absolute capability score.
[G] Correct, and that matters a lot for how you read the final numbers, which we'll get to.
[O] The paper also reports two flavors of this score.
[G] Best Submission at four uses whatever the agent actually submitted as final, averaged across four seeds. Best Attempt at four uses the best validated solution it produced at any point, whether or not it had the sense to submit it. Submission rewards remembering your own best result; Attempt is closer to a capability ceiling.
[S] That gap between attempt and submission is itself a finding, isn't it — whether a model can track and recover its own best answer.
[G] It is, and it's one of the more human failure modes in the paper. Some models find a good solution and then submit something worse.
[O] Let's get to results. Five frontier models were evaluated: Claude-three-point-five-Sonnet, Llama-three-point-one four-oh-five-B-Instruct, GPT-4o, OpenAI o1-preview, and Gemini-one-point-five-Pro.
[G] On aggregate, o1-preview comes out on top, with a Best Attempt AUP at four of one point one five zero, and a Best Submission AUP at four of one point one seven six. Claude-three-point-five-Sonnet is close behind at one point one four two and one point one three five, and Gemini-one-point-five-Pro at one point one four zero and one point one two five.
[S] So the best and worst aggregate scores in the entire field differ by less than point one eight. That's an extremely compressed spread.
[G] It is — and that compression is partly a property of the metric itself, not just the models, which I'll come back to.
[O] Walk us through a few of the per-task numbers.
[G] On CIFAR-ten, accuracy climbs from a baseline of point four nine seven to point eight nine five with Claude. On Fashion-MNIST, from point seven eight three to point nine four five, also Claude. On MNLI, Gemini takes it from point five two five to point eight three eight. On the language modeling task, o1 drops validation loss from four point six seven three to three point nine six six.
[S] Those are real, substantial jumps over the provided baselines.
[G] They are. But go back to the paper's own abstract, and it's very precise about the mechanism: these gains "usually" come from finding better hyperparameters, not from new hypotheses, algorithms, or architectures.
[O] Competent optimizers, not researchers.
[G] That's the paper's own framing, more or less.
[S] And they're brittle on top of that.
[G] Very. Llama-three-point-one four-oh-five-B fails to produce any valid solution at all on the Language Modeling task. GPT-4o does the same on Breakout. Both marked with infinity in the results tables — no usable submission.
[O] What about cost?
[G] o1-preview tops the AUP axis but costs roughly nine dollars in API spend per run on average. Gemini-one-point-five-Pro is the standout on value: roughly nine times cheaper than o1 while reaching about ninety-nine percent of its AUP score. GPT-4o is cheap but clearly behind the top tier.
[S] So if you're optimizing dollars per unit of research-agent competence, Gemini wins this benchmark, not o1.
[G] Now here's where the behavior gets concrete about what "tuning, not researching" looks like. Across all runs, Edit is roughly fifty percent of all actions, thirty-seven hundred and eight calls. The cycle is edit, view, run Python, validate, repeat. Search — the tool built to let the agent look things up in the literature or codebase — is used eleven times total, about one percent of actions.
[S] Eleven times. Across five models, thirteen tasks, four seeds each.
[G] Eleven times, total, across the whole evaluation. The tools for exploring ideas exist. The models almost never reach for them — they tweak the code in front of them and rerun it.
[O] I want to push back on the doom read for a second — there's a moment in the paper I found genuinely impressive as an engineering capability, even if it's not "research" in the romantic sense.
[G] The Memory Module trajectory on Fashion-MNIST. The agent queries memory for "accuracy on Fashion-MNIST," retrieves a stored ResNet-style config it had written earlier that hit ninety-three point five one percent, and writes an improved model script reproducing those exact ingredients — skip connections, batch norm, dropout, a learning-rate schedule, augmentation.
[O] That is real recall-and-reuse across a long run. That's not nothing.
[S] It's also, and I think this is the crux, a vivid illustration of recall over invention. The agent isn't discovering that recipe. It's remembering it, possibly from pretraining, possibly from its own earlier steps in the same run.
[G] Both readings are supported by the trajectory. The paper itself calls this a useful capability and, in the same breath, evidence for the recall story.
[S] Let's get into the debate properly. Start with contamination: every one of the thirteen tasks is a famous, public, thoroughly-documented dataset — CIFAR-ten, Fashion-MNIST, MNLI, Breakout. These models have almost certainly seen good architectures and hyperparameter recipes for exactly these datasets during pretraining.
[G] The paper doesn't run a controlled contamination test, so it can't rule that out, and the Memory Module trajectory we just discussed is suggestive in exactly that direction — a stored, specific, high-performing config being pulled back out and reused.
[O] I'll grant that's a real risk. But even a contaminated recipe still has to be correctly retrieved, correctly implemented, and correctly validated against the task's actual harness. That's not zero skill.
[S] It's real skill, but a different skill than the title advertises. My second objection: the single-scalar reduction. MS-COCO captioning is scored by BLEU, a metric long criticized for correlating poorly with caption quality. The game-theory tasks reduce to average reward. "Open-ended AI research" gets compressed into optimizing one number per task.
[G] Fair, and I'd extend it: a leaderboard metric produces leaderboard behavior. The edit-and-rerun loop the action data shows is arguably the rational response to a benchmark that only rewards moving one scalar, regardless of how you got there.
[O] So the harness might be manufacturing the very narrowness the paper diagnoses in the models.
[G] That's the sharpest version of the critique — the paper observes narrow behavior, but its own scoring design may be partly producing it, not just measuring it.
[S] Third, the relative normalization. AUP is computed against the best model in this specific pool. A score of one point zero means "roughly matches GPT-4o," not "good" in any absolute sense. Add a stronger model to the pool, or drop a weak one, and every score shifts.
[G] Correct — the compressed one-point-zero-zero to one-point-one-eight spread we discussed earlier is partly an artifact of that normalization, making real capability gaps look smaller than they may actually be.
[O] What about the failure data?
[G] Across two hundred twenty trajectories — eleven tasks times five models times four seeds — Evaluation Error is the dominant termination reason, at roughly seventy-five percent of all termination errors. Cost-limit errors show up too, and Gemini, despite being the most cost-effective model overall, still hits them most often, because it uses fewer but more expensive-per-step actions.
[S] So the brittleness isn't evenly distributed. It's a real signal about which models can reliably finish a long agentic task versus which ones just produce something plausible-looking that fails validation.
[O] The strongest optimist case: this is the first real Gym-style environment for ML research agents, full stop. That's genuine infrastructure the field can build on, including for actual reinforcement learning training, not just evaluation. The AUP metric is a principled answer to a real measurement problem — comparing models across incommensurable task metrics is genuinely hard, and performance profiles, borrowed from serious optimization literature, are defensible. And even granting everything Griffith said about contamination and metric narrowness, five different frontier models independently, reliably improved on non-trivial baselines under a fifty-step budget and a real permission-protected shell. That's not a party trick.
[S] The strongest deflationary case: thirteen tasks, all on famous public datasets, is a small, contamination-prone suite to hang a title like "Advancing AI Research Agents" on. The benchmark's own creators cap their ambition at Level 1 of a six-level ladder they invented, meaning it cannot see ideation, experimental design, or genuine novelty by construction — the L2-through-L5 capabilities the title evokes. Search at roughly one percent of actions is close to a null result for literature-grounded research. And the model pool — o1-preview, Claude three point five, Gemini one point five, GPT-4o, Llama three point one — is already a February twenty twenty-five snapshot, behind the reasoning models that came after.
[G] Scoring it claim by claim: on infrastructure, I side with the optimist without much hedging — a genuine, open-sourced Gym interface is durable value regardless of how today's models score on it. On "these are researchers," I side with the skeptic — the paper's own abstract says the gains are usually from hyperparameter tuning, and the action data backs that up directly. On contamination, it's a serious open risk the paper doesn't rule out, not a settled verdict — no controlled experiment resolves it. On relative AUP, that's simply correct as a description of the metric; the one-point-zero-zero to one-point-one-eight spread shouldn't be over-read as absolute capability distance.
[O] So the framework earns its optimism, the headline capability claim earns its skepticism.
[G] That's roughly where I land. The paper is honest about that split too — it says outright it's an initial step, and explicitly calls for held-out tasks, richer evaluation, and re-running with newer models.
[S] Worth naming: the paper's own ethical-considerations section takes the acceleration risk seriously — it explicitly connects MLGym-Bench to autonomy metrics in frontier labs' safety frameworks.
[O] That's a responsible move, and a good segue to implications. If a later, harder, less-contaminated version of this benchmark with a bigger step budget showed the same edit-heavy, search-light pattern, that would be much stronger evidence today's agents genuinely can't do open-ended research, rather than just being boxed in by fifty steps and familiar datasets.
[S] And if the pattern flipped — Search usage rising, genuinely novel approaches appearing once budgets grew — that would be the update the other way. Right now we don't have that data point.
[G] Which is exactly what the authors call for in their own discussion: scaling to more domains and larger tasks, testing generalization across disciplines, and admitting nobody has yet formalized what automated scientific novelty even means in a form an agent could be scored against.
[O] Griffith, before we close, what's the one-sentence version of this paper for someone who only has time for the title?
[G] MLGym gives the field its first real Gym for ML-research agents and a principled way to compare them, and its most important finding is that, as of early twenty twenty-five, frontier models tune what's in front of them rather than inventing anything new.
[O] My takeaway: the infrastructure outlives the specific numbers. A real Gym interface plus a defensible cross-task metric is unglamorous groundwork that lets the next few years of agent research actually get measured, not just vibes-checked.
[S] Mine: don't let "advancing AI research agents" in the title do more work than the Level 1 instrument underneath it can support. Remember the eleven Search calls and the contamination risk before you extrapolate this to "AI can do science now."
[O] That's the show. Thanks to Griffith for walking us through it.
[G] Thanks for having me.
[O] For the figures, the full results tables, and the paper's own critique of itself, head to the writeup on litsearch dot darvinyi dot com. We'll see you next time.
