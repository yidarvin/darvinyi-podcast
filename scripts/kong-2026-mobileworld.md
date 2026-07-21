---
slug: kong-2026-mobileworld
title: "MobileWorld: Benchmarking Autonomous Mobile Agents in Agent-User Interactive and MCP-Augmented Environments"
description: "AndroidWorld's leaderboard broke ninety percent and stopped telling anyone anything useful. MobileWorld triples down on realism — two hundred one long-horizon, cross-app tasks that also require asking clarifying questions and calling outside tools — and even the best system only reaches fifty-one point seven percent."
date: 2026-07-19
guest_name: "Rhun"
guest_voice: "bm_lewis"
---
[S] Every mobile agent leaderboard has the same problem right now: everybody's winning.
[O] AndroidWorld, the benchmark basically everyone in mobile agents uses, has the top agentic frameworks clearing ninety percent success. That sounds like a triumph.
[S] It sounds like a ruler that ran out of room. Once your best systems all cluster above ninety percent, you can't tell a genuine capability jump from noise anymore.
[O] So today's paper doubles the task length, adds two skills nobody tested before — asking the user a clarifying question, reaching for an outside tool mid-task — and the best system on the new test drops to fifty-one point seven percent.
[S] Fifty-one point seven, on the winning system. That's not a benchmark refresh. That's a benchmark resetting the entire conversation about what "good" means.
[O] Welcome to Litsearch Audio. I'm your optimist host, and across the table, as always, is our resident skeptic.
[S] Glad to be here. Today we're covering "MobileWorld: Benchmarking Autonomous Mobile Agents in Agent-User Interactive and MCP-Augmented Environments," out of Tongyi Lab at Alibaba Group. Lead authors are Quyu Kong and Xu Zhang, with a long author list including Chen Liu, Steven Hoi, and Yue Wang, plus collaborators from Hong Kong University of Science and Technology's Guangzhou campus and the University of Florida.
[O] And joining us to walk through it is Rhun, a researcher who's spent real time with this paper. Rhun, welcome.
[G] Thanks for having me. This is a paper where the diagnosis matters as much as the leaderboard, and that's the right way to listen to it.
[S] Let's set up the problem. Why does mobile GUI benchmarking need resetting at all?
[G] AndroidWorld earned its position honestly — a hundred sixteen tasks across twenty real apps, dynamically parameterized so the same task can be resampled with different arguments, fully reproducible and deterministically scored. But three years in, state-of-the-art agentic frameworks clear ninety percent plus on its leaderboard, and the authors argue that ceiling now hides more than it reveals.
[O] Saturation alone would justify a new benchmark. What else did they find broken?
[G] Three gaps. Prior benchmarks are short-horizon and single-app, and skip categories central to real phone use — e-commerce, enterprise communication — where authentication or opaque state would force a noisy model-as-judge grader. They assume the instruction is fully specified, when real requests routinely aren't — "send this to Kevin" with no email on file is ordinary, and a competent agent needs to ask rather than guess. And none touch the Model Context Protocol, even as MCP becomes the standard way agents reach outside tools.
[S] So the pitch is: fix saturation, fix vague instructions, and add tool use, without falling back on a judge model to grade it.
[G] Exactly that. MobileWorld's whole design constraint is deterministic scoring even while adding those two genuinely new task types.
[O] Let's get into how it actually works. Walk us through the environment.
[G] The task is formalized as a POMDP — a partially observable Markov decision process. The agent observes an instruction plus the screenshot, acts through standard mobile operations — tap, drag, scroll, type, navigate — and gets a binary reward for completion. On top of ordinary GUI-only tasks, completion and information retrieval, the paper adds two new families needing entirely new actions.
[S] Start with the user-interaction one, since that's the more novel of the two.
[G] Annotators write a fully specified task — send an email to a named address with a message — then strip out a required detail, replacing the full email with just a first name, and verify it isn't recoverable elsewhere on the device. A simulated user, built on GPT-4.1 and seeded with exactly the withheld fact, answers the agent's clarifying questions and refuses anything off-task. Forty-five tasks, twenty-two point four percent of the set.
[O] So it's testing whether the agent knows it doesn't know something, instead of confidently guessing.
[G] Right — turning silent hallucination into something you can actually measure.
[S] And the MCP tasks?
[G] Forty tasks, nineteen point nine percent, built around sixty-four MCP tools across five servers — GitHub, Amap Maps, Jina AI, StockStar, and arXiv. A task might require pulling a GitHub README through the tool, then switching back to the GUI to open mail and send a summary — forcing the agent to choose, mid-task, between a screen tap and a direct tool call, and often chain both.
[O] How do you get deterministic scoring on something like a messaging app without a judge model reading the screen?
[G] For commercial apps they can't authenticate into, MobileWorld self-hosts open-source substitutes — Mattermost for Slack, Mastodon for X, Mall4Uni for e-commerce — modifying the source for direct backend access. Four verification modes: text-answer matching, backend-database queries, local storage inspection via a rooted emulator, and custom app callbacks, all inside Docker-in-Docker containers with device snapshots so every run starts identical.
[S] That's a real engineering investment just to avoid a judge model.
[G] It is, and it's the paper's strongest methodological claim — determinism without sacrificing app realism.
[O] Now the baseline agent they built to run all this — the planner-executor setup.
[G] A planner, any general-purpose vision-language model, describes the next action in natural language — "the Send button at the bottom right" — instead of raw coordinates. That description goes to a separate grounding model, UI-Ins-7B, which converts it to pixel coordinates. The action space adds two moves: ask user, routing a query to the simulated user, and MCP call, invoking a named tool with structured parameters — both inside one closed decision loop.
[S] And they don't just report one pass-fail number, right?
[G] Five metrics. Overall success rate plus per-category rates for GUI-only, interaction, and MCP. Average completion steps. Average user queries per interaction task. And user interaction quality, or UIQ — success divided by queries invoked, penalizing both a failed clarification and an unnecessary one, since the denominator also counts non-interaction tasks with a triggered query. Plus average MCP tool calls.
[O] That UIQ metric already tells me this paper cares about more than raw accuracy.
[G] It does — built to catch a model that's chatty without being useful.
[S] Before results, give me the shape of the two hundred one tasks overall.
[G] A hundred sixteen GUI-only, fifty-seven point seven percent. Forty-five interaction, forty MCP. Only seventy-six tasks, thirty-seven point eight percent, are confined to a single app — a hundred span exactly two apps, twenty-five span three or more. Communication and messaging is the largest scenario category, tagged on a hundred eight of the tasks.
[O] Let's get to what they actually found, because that fifty-one point seven percent number opened the show for a reason.
[G] Against AndroidWorld's ninety percent plus, MobileWorld's best system reaches fifty-one point seven. Average completion steps nearly double, fourteen point three to twenty-seven point eight, right-skewed with a large share past twenty steps. Cross-app tasks jump from nine point five percent to sixty-two point two.
[S] Break down the leaderboard by architecture, because I'd guess it's not a smooth curve.
[G] It's a cliff. Among agentic frameworks, GPT-5 with UI-Ins-7B tops the table at fifty-one point seven overall — fifty-four on GUI-only, sixty-two point two on interaction, fifty-one point six on MCP. Gemini-3-Pro with the same grounding model reaches forty-six point three, Claude-4.5-Sonnet forty-three point eight. End-to-end models trail badly — Doubao-1.5-UI-TARS leads at twenty point nine overall, not evaluated on MCP. Everything else — GUI-Owl, UI-Venus, Qwen3-VL, GELab-Zero — clusters between four point five and ten point nine percent.
[O] And the MCP-specific numbers for models that do attempt tool calls?
[G] Only the three agentic frameworks and Qwen3-VL even attempt MCP calls. Qwen3-VL's MCP success rate runs zero to five point four percent despite averaging two point three to three point eight tool calls per task — it's trying, but generating tool names and arguments that are often wrong.
[S] What does the efficiency data add on top of raw success rate?
[G] Gemini-3-Pro is most efficient, twenty-four point two average steps. GPT-5 is the most judicious clarifier — one point one one queries per interaction task, a UIQ of point four zero, best of the three, and the highest interaction success rate at sixty-two point two. Doubao is the starkest counter-case — thirty-two point four percent success but a UIQ of only point one three, meaning most of its clarifications are redundant or off-target.
[O] And on the tool-calling side, does more calling mean more success?
[G] Broadly yes — Gemini-3-Pro averages two point six three MCP calls at forty-eight point six percent success, GPT-5 two point two three calls at fifty-one point six, Claude-4.5-Sonnet one point nine one calls at fifty percent.
[S] Walk me through the failure analysis, because that's usually where a benchmark paper earns its keep.
[G] Five recurring gaps from a manual sweep of failures. Agents hallucinate missing facts instead of asking — one invents "Shanghai" as a departure city for a driving-distance query rather than asking where the user lives. MCP responses overflow the context window — one case returns a twenty-thousand-token PDF dump that buries the fact needed. There's no working long-term memory, so a file-renaming task loses track of what it already renamed and re-touches it. Multi-step arithmetic is weak — summing the top three cart prices one at a time, and getting it wrong. And there's no grounding in real-world time or location unless it's spelled out in the prompt.
[O] Alright, I want to make the strongest optimist case for this paper, and Rhun, hold me to the evidence.
[S] I'll do the opposite. Go.
[O] This is a genuine, badly needed reset. AndroidWorld was telling us nothing new at ninety-plus percent, and MobileWorld puts real headroom back under the field's feet — long-horizon planning, cross-app memory, knowing when to ask instead of guess. The self-hosted backend design is the right instinct — deterministic ground truth without a judge model guessing what "success" looks like. That's a real answer to a problem the field's complained about for years.
[S] I don't disagree with any of that as design philosophy. My problem is how much weight fifty-one point seven can actually bear, and three things in this paper made me sit up.
[O] Go ahead.
[S] First: the winning system isn't neutral. Every agentic-framework row, including the fifty-one point seven winner, is paired with the same grounding model, UI-Ins-7B. Rhun, who built that model?
[G] The same lab, largely the same people. UI-Ins-7B's own paper lists Liangyu Chen, Hanzhang Zhou, Chenglin Cai, Jianan Zhang, Panrong Tong, Quyu Kong, Xu Zhang, and Chen Liu as authors — essentially the MobileWorld roster, released two months earlier out of the same group. Every end-to-end competitor is fully external, evaluated as-is.
[O] That doesn't make the number wrong, though. UI-Ins-7B still has to ground clicks correctly, or the framework fails regardless of who built it.
[S] Sure, but the flagship result pairs the benchmark's own grounding component with the winning framework, built by the same people who designed the test. Does the paper report an outside grounding model instead?
[G] It doesn't. No ablation swaps in a third-party grounding model, so you can't isolate how much of that fifty-one point seven comes from the planner versus the grounding choice.
[O] Fine, that's a fair gap. What's your second concern?
[S] The Overall success-rate formula. Section four point three says plainly that MCP tasks are dropped for models with no tool support, and interaction tasks for models with no clarifying-query action. But the Overall formula is just one over N, summed across all two hundred one tasks. Rhun, does the arithmetic actually check out?
[G] It does, and it's a clean catch. GUI-Owl-7B's GUI-only rate is seven point seven percent over a hundred sixteen tasks — about eight point nine successes. Divide by two hundred one instead of a hundred sixteen, and you get roughly four point four percent, matching the reported Overall of four point five almost exactly. That only works if the eighty-five untested interaction and MCP tasks are counted as failures rather than excluded.
[O] So the eighty-five tasks a model was structurally incapable of attempting are being scored as zero.
[G] That's what the numbers imply, yes.
[S] Which means part of that headline gap, fifty-one point seven versus twenty point nine, is mechanical. End-to-end models are guaranteed to lose roughly forty-two percent of the possible score just for lacking an action space — a different claim than "twice as capable."
[G] I'd frame it carefully. The category-level numbers are each computed only over the tasks a model actually ran, and those are trustworthy on their own terms. It's specifically the single "Overall" column that conflates capability with coverage.
[O] Okay, I'll concede that one fully. That's a real design flaw, and it inflates the exact gap I was leaning on a minute ago.
[S] Third, and smaller: the two new categories are each measured on just forty to forty-five tasks. A single task swings a percentage by more than two points, and everything runs once, at temperature zero, with no confidence intervals.
[G] Accurate. No variance reporting anywhere, so rankings among close competitors — Gemini-3-Pro's forty-eight point six versus GPT-5's fifty-one point six on MCP — should be read as directional, not precise.
[O] I'll take that as a responsible caveat, not a reason to discount the benchmark. This is a first release, and the categories that need the most tasks are exactly the ones they just invented.
[S] One more thing, not in the paper's own critique but worth flagging — these self-hosted stand-ins aren't the real apps. Mattermost isn't Slack, Mastodon isn't X. How much does success on the substitute transfer to the commercial app on someone's actual phone?
[G] The authors are upfront it's a deliberate tradeoff — production-grade utility against reproducible evaluation, not behavioral identity with the commercial app. It buys backend access and determinism at the cost of interface drift from the real thing, and the paper doesn't quantify that gap.
[S] And the binary reward itself misses something. The Shanghai hallucination fails the task, which is good, but a confident, plausible-looking wrong answer is worse in the real world than an obvious failure. A single completion score doesn't distinguish "failed loudly" from "failed convincingly."
[G] Fair, and the paper doesn't attempt that distinction — binary reward throughout, consistent with the AndroidWorld tradition it's building on.
[O] Let's talk about where this actually lands for the field, beyond the leaderboard.
[G] The clearest lesson generalizes past mobile agents — an Overall metric that folds untested categories in as zero looks fine in a spreadsheet and only shows up when someone works the arithmetic backward.
[S] It also connects to contamination, which the paper doesn't address. Several end-to-end baselines — UI-TARS, UI-Venus, GUI-Owl, GELab-Zero — are fine-tuned systems, with no reported check for training leakage from MobileWorld's own construction methodology.
[O] And on the positive side, the simulated-user design is genuinely useful for the field — a live, seeded LLM you can interrogate instead of a static ground-truth string, closer to real ambiguity resolution.
[S] Though that's also a second LLM judgment layer sitting inside a benchmark proud of avoiding LLM-as-judge grading. The simulated user decides what counts as "on task" when it refuses to answer — a subjective call.
[G] That's outside what the paper directly analyzes. My own read, going a bit beyond the text, is it's a smaller risk than judge-based scoring, since it only gates information flow rather than deciding pass or fail — but not zero risk.
[O] Let's close it out. Rhun, one sentence — what's the paper's own takeaway?
[G] Their own framing: mobile agents have gotten good at tapping screens and bad at knowing what they don't know, and the next real gains come from user interaction and tool orchestration, not more GUI polish.
[S] Mine's the caveat wearing a takeaway's clothes. Trust the fifty-one versus twenty split directionally, trust the failure taxonomy completely, and treat the exact Overall percentages with real suspicion until someone reruns this with an external grounding model and a denominator matching what each model was actually tested on.
[O] And mine's the optimist's close. AndroidWorld's ceiling just got blown open, and for the first time we have a deterministic way to measure whether an agent knows when to ask instead of guess — the skill that decides whether you'd trust one of these on your own phone. For the full writeup and citations, head to the litsearch site. Thanks for joining us, Rhun.
[G] Thanks for having me.
