---
slug: chen-2024-t-eval
title: "T-Eval: Evaluating the Tool Utilization Capability of Large Language Models Step by Step"
description: "T-Eval splits tool use into six separately-graded sub-abilities instead of one end-to-end win rate — and the String versus JSON split it adds underneath turns out to be the most revealing axis in the paper."
date: 2026-07-30
guest_name: "Imogen"
guest_voice: "bf_lily"
---
[O] Here is a number that should stop you. A model scores sixty-eight point seven on emitting a tool call. Same model, same task, same reasoning — ask for the answer in JSON instead of loose text, and it scores zero point two.
[S] Zero point two. That is not a capability measurement. That is a parser, wearing a capability measurement as a costume.
[O] Or it is the single most useful thing this benchmark does. It pulls the parser failure apart from the thinking failure and tells you which one you actually have. Those get averaged into the same mush everywhere else.
[S] That is the pitch. What I want to know is whether splitting tool use six ways earns its keep, or whether it just turns one noisy number into eleven noisy numbers and a leaderboard.
[O] Welcome to Litsearch Audio. Today it is T Eval, evaluating the tool utilization capability of large language models step by step, from Zehui Chen, Weihua Du, Wenwei Zhang and colleagues, across the University of Science and Technology of China, Shanghai A I Laboratory, Tsinghua, and Jilin. It landed at A C L twenty twenty-four.
[S] And we have Imogen with us, who has spent real time inside this paper's main table. Welcome.
[G] Thank you. It is a good paper to sit with, because the headline idea is genuinely simple and the table underneath it is not.
[O] So start with the gap, Imogen. Why did anyone need another tool benchmark at the end of twenty twenty-three?
[G] Because nearly everything before it scored the final output. ToolBench, from Yujia Qin and colleagues, puts a G P T four judge in front of a model's whole solution path and reports a win rate against G P T three point five. A P I Bank, from Minghao Li and colleagues, largely checks single-step tool calls. Gorilla, from Shishir Patil and colleagues, checks whether the right A P I got invoked at all.
[G] The authors' complaint is that a real tool episode is a chain — plan the sequence, reason about the next move, pick the tool, fill in its parameters, emit the call, then judge the response. Compress that into one win-or-lose number and every failure looks identical. A bad plan and a hallucinated parameter three steps later produce the same zero.
[S] That critique is fair and also very old. Everyone says decomposition is better. The question is whether the decomposition they chose is the right cut or just a plausible one.
[G] It is a defensible cut, and I would not call it derived from first principles. Six abilities: plan, reason, retrieve, understand, instruct, review. They map onto one round of a tool-calling loop. Plan happens once up front. Then each round, the model reasons about the next step, retrieves the right tool from the list, understands which parameters it needs, instructs — emits the actual formatted call — and then reviews whatever came back.
[O] And the trick is that each one is tested in isolation.
[G] Precisely, and that is the mechanism worth being careful about. For each ability, the model is handed a prefix of the golden solution path and asked for exactly one next micro-decision. The next thought. The next tool. The next parameter set. That prediction is scored against the gold answer for that step alone.
[S] So a model's retrieve score cannot be poisoned by its planning being bad two steps earlier.
[G] Right. Every ability is graded from the same gold prefix, so the errors do not compound. That is the real contribution — not the six labels, the isolation protocol underneath them.
[O] What does the scoring actually look like? Plan is the odd one out, I think.
[G] Plan is the most intricate. The model proposes an action sequence, and the evaluator compares it to the golden sequence by computing pairwise action similarity with Sentence BERT, then finding the maximum-similarity pairing with Hopcroft Karp bipartite matching. The score is the length of the longest ordered chain inside that pairing.
[S] So order matters but exact wording does not.
[G] Correct. Reason and understand are similarity-based too. Retrieve is a tool-name comparison. Instruct scores accuracy on tool name and parameter values in the requested format. Review is the only one graded as multiple choice — five options: success, internal error, input error, irrelevant response, and unable to accomplish.
[O] Now the piece I keep coming back to. Every ability except review is scored twice, at two difficulty levels.
[G] Yes, and this is where the paper gets interesting. The easy protocol is a loose string format that cares about semantic content. The difficult protocol requires JSON, with exact match on tool names and parameter values. The authors say they added this after watching small models' scores get destroyed by pure format failures rather than reasoning failures.
[S] Which is a real confound, I will grant that. If a seven B model cannot close a brace, you have measured brace-closing.
[G] And the overall score is built out of both. Overall is the mean of the six ability scores, and each ability score is itself the mean of its string and JSON pair. Review contributes its single choice score. I checked the arithmetic against the table and it reproduces the published numbers exactly.
[O] Let us do the data, because the construction here is unusual. This is not scraped tool logs.
[G] No, it is a synthesized, human-verified pipeline. They hand-curate fifteen tools across six everyday domains — research, travel, entertainment, web, life, financials — and write complete documentation for each one by hand. The stated reason is that tools pulled wholesale from ToolBench's RapidAPI pool have inconsistent documentation, which would conflate the model failing with the tool description being bad.
[S] That is a legitimate design choice and also a narrowing one. Fifteen tools with immaculate hand-written docs is not the world.
[G] It is not, and the paper does not claim it is. Then G P T three point five samples two to three tools at a time and drafts candidate queries, and G P T four refines them for feasibility and diversity.
[O] And the golden solution paths?
[G] This is the part I find genuinely clever. Rather than have one model role-switch through the whole chain the way chain of thought or ReAct would, they split annotation across three separate G P T three point five roles — a planner, an executor, and a reviewer. The argument is that a single agent forced to be planner, actor, and critic at once accumulates errors, and giving each agent one job reduces that.
[S] Hold on. Executor. Does something actually call a tool?
[G] Yes, and this is worth stating precisely because it is easy to get wrong in both directions. During annotation, the executor generates the tool name and parameters and does execute the tool to obtain a real response. So real tool responses exist in the dataset. But nothing is executed at grading time. Every evaluated model is scored against that frozen, pre-recorded observation.
[S] So the API-instability complaint they opened with is genuinely solved, at the cost of the benchmark never seeing a live failure.
[G] That is exactly the trade, and I think the paper is honest about the first half and quieter about the second. The scale, for the record: fifteen hundred initial instruction-solution pairs, five hundred and fifty-three surviving two rounds of human verification, sliced into twenty-three thousand three hundred and five test cases, averaging five point eight tool-calling steps per solution path.
[O] Right, let us get to who wins. Twenty models.
[G] Twenty. Three A P I based — Claude two point one, G P T three point five turbo sixteen K, and the G P T four eleven-oh-six preview — plus seventeen open-source models across roughly seven B, thirteen to fourteen B, and seventy to seventy-two B scales. LLaMA two, Code LLaMA, Qwen, Intern L M, Baichuan two, Wizard L M, Vicuna, Agent L M, Mistral, Chat G L M three.
[G] G P T four takes the highest overall at eighty-six point four. G P T three point five is second at eighty-four point oh, Claude two at seventy-eight point eight. The best open model is the largest one, Qwen seventy-two B, at seventy-one point four.
[O] Fifteen points behind G P T four, exactly.
[G] Exactly fifteen, yes. And the paper describes Qwen's climb from seven B to seventy-two B as significantly reducing the open-to-closed gap, which is true relative to smaller Qwen checkpoints, though fifteen points is still a real distance.
[S] Before the optimist takes that anywhere, I want the version question settled. Which numbers are these?
[G] Good instinct. These follow the arXiv preprint, version three, nineteen pages, seventeen open-source rows. The A C L camera-ready adds one more open row, Intern L M twenty B, with an overall of fifty-three point five, which would sit sixth among eighteen open rows. It changes none of the counts anyone quotes.
[O] Now the fact I want on the record, because I have seen it garbled. Do open models ever beat G P T four here?
[G] They do, and there are two different true statements and people constantly collapse them into one. Statement one: understand, string protocol, is the only column in the whole table whose all-model maximum is held by an open model. Qwen seventy-two B takes it at eighty-four point five, with G P T four second at eighty-three point two.
[S] Only column. You have actually checked every column?
[G] I have gone across all eleven score columns plus overall, and yes — every other maximum belongs to G P T four, G P T three point five, or Claude two.
[O] And the second statement?
[G] Open models out-score G P T four specifically in four further cells, without topping the column. On instruct JSON, Qwen seventy-two B at ninety-eight point three and Qwen fourteen B at ninety-seven point six both beat G P T four's ninety-five point nine. On retrieve string, Qwen fourteen B at ninety-five point nine and Mistral seven B at ninety-two point six both beat G P T four's ninety-one point three.
[G] But in both of those columns, G P T three point five holds the actual lead — ninety-nine point one and ninety-eight point three respectively. So beating G P T four there is not the same as topping the column, and the difference matters.
[S] Good. That is the kind of claim that gets inflated into open source has caught up, when what happened is one closed model got leapfrogged by another closed model.
[O] Fine, I will take the narrower version. One column outright, and four cells where the frontier model of the moment is not the ceiling. For December twenty twenty-three, that is not nothing.
[G] It is not nothing, and the paper does not oversell it either.
[S] So let us talk about the format collapse, because that is where I think the paper is strongest and also where it undercuts itself.
[G] Go on.
[S] LLaMA two seven B: instruct string sixty-eight point seven, instruct JSON zero point two. Code LLaMA seven B: ninety-six point oh to zero point nine. If those are your easy and difficult levels, the difficulty axis is not difficulty. It is a cliff.
[G] It is a cliff, and the authors would say that is precisely the point — that without the string protocol you would look at zero point two and conclude the model cannot follow tool instructions, when it plainly can, semantically. The string protocol recovers signal that a JSON-only benchmark destroys.
[O] And it shows up even at the top. Qwen seventy-two B understands parameters about as well as G P T four in string — eighty-four point five against eighty-three point two — and then falls to sixty-six point one in JSON while G P T four goes up to eighty-eight point three.
[G] More than twenty points below, on the same subset. The paper's read is that open models of that era understood tool parameters roughly as well as G P T four in the abstract, and lost most of it the moment the answer had to come back as valid, exact-match JSON.
[S] Here is my problem, though, and it comes straight out of their own table. Look at instruct for the entire Qwen family. Qwen seventy-two B: string twenty-seven point eight, JSON ninety-eight point three.
[O] Wait. The easy protocol is worse?
[S] Dramatically worse. Qwen seven B, twenty-eight point seven string against ninety-four point two JSON. Qwen fourteen B, forty-nine point seven against ninety-seven point six. Baichuan two thirteen B, eight point oh string against fifty-one point seven JSON. The ordering is inverted for a whole family of models.
[G] That is correct, and it is a fair hit. The difficulty framing holds on average and fails on the instruct subset for format-tuned models. If a model has been heavily tuned to emit JSON, the loose string convention is the unfamiliar one. So easy and difficult are not properties of the protocol, they are properties of the protocol crossed with the model's tuning.
[S] Which means the string protocol is not a floor. It is just a second, differently-shaped format test.
[G] I would accept that as a description of the instruct subset specifically. On retrieve, understand, and reason the string scores are broadly the higher ones, and the difficulty framing survives there. But you have found a genuine seam, and the paper does not flag it.
[O] Does it distort the overall score?
[G] It does, and visibly. Qwen seventy-two B's twenty-seven point eight on instruct string pulls its instruct average down to around sixty-three, which is the single worst of its six abilities despite it being near-perfect on the JSON half. A chunk of that fifteen-point gap to G P T four is a string-convention penalty.
[S] So the headline ranking is partly measuring formatting familiarity. That is worth saying out loud.
[O] Partly. Not wholly — retrieve is a real gap. Qwen seventy-two B at sixty-five point oh on retrieve JSON against G P T three point five's eighty-six point two is not a convention penalty.
[G] Agreed, and the paper calls tool retrieval a relatively challenging task for most models under the strict protocol. Review is the other genuine gap — most open models cluster in the fifties and sixties while G P T four leads at ninety-four point five. Judging whether a tool response actually resolved your goal was, at that moment, a frontier-only skill.
[O] There is a validity check I want to give the authors credit for. They did not just assert that decomposition tracks reality.
[G] They did not. They re-ran six representative models on ToolBench's own end-to-end win rate — a G P T four judge comparing full solution paths against G P T three point five — and plotted it against T Eval's overall score. The two track each other, which the abstract cites as consistency with outcome-oriented evaluation.
[S] Six models. That is a construct-validity check with an n of six.
[G] It is small, and I would not want anyone quoting it as established. But it is more than most benchmark papers do, and the interesting part is a case where the two metrics disagree. Qwen seven B achieves a fifty-two percent win rate over G P T three point five's responses under G P T four judging, and still trails G P T three point five across several individual ability scores.
[O] So a coin-flip-or-better win rate hides a real per-ability gap. That is a nice demonstration of why you would want the decomposition at all.
[S] It is also a demonstration that G P T four is a generous judge of models that write like G P T four. Both readings fit that data point.
[G] Both do. The paper takes the first reading and does not consider the second.
[O] There is one more analysis worth a minute — what training data predicts tool skill.
[G] They use models sharing a LLaMA two base as a natural ablation. General instruction diversity — Vicuna's ShareGPT data, Wizard L M's Evol Instruct data — helps substantially at seven B, then the benefit shrinks or reverses at seventy B. Wizard L M seventy B lands at forty-four point two overall, low for its scale cluster.
[S] Which the paper reads as data quality mattering, not just parameters.
[G] Yes. And comparing task-specific corpora on the same base, Agent L M seven B with agent-interaction data reaches forty-one point four, above Code LLaMA seven B's twenty-eight point six with code data. But neither clearly beats plain general-instruction Vicuna seven B at forty-four point eight.
[O] So narrow tool-specific fine-tuning does not substitute for good general instruction following.
[G] That is the authors' conclusion, and it is a small ablation carrying a fairly large claim. Three models, one base family.
[S] Imogen, there is a provenance detail on this paper I want you to walk through, because I would rather we state it than let someone discover it and think it was hidden.
[G] Happily, and I want to frame it correctly. In the arXiv preprint, section four point two discusses format gaps and attributes a plan string-versus-JSON pair to Baichuan two thirteen B — sixty-five point six string, and it calls the gap about twenty-five points. Those values are not Baichuan two thirteen B's row. They are Baichuan two seven B's plan numbers, sixty-five point six and thirty-nine point oh.
[O] And the thirteen B model's actual plan row?
[G] Roughly sixty-nine on string against fifty-two point one on JSON — a gap of about seventeen points, not twenty-five. And the A C L camera-ready quietly corrects the prose to the thirteen B model's own numbers and the seventeen-point gap.
[S] So it is a preprint typo, caught and fixed before publication.
[G] That is exactly what it is, and I would not present it as the paper being wrong. The table was always right. One sentence of discussion pointed at the wrong row of it, and the camera-ready fixed it. It is a good argument for reading the version you are citing.
[O] Let me make the optimist case, then. T Eval's decomposition is a durable contribution independent of its leaderboard. It gave the field a vocabulary — plan, reason, retrieve, understand, instruct, review — for saying which link in the chain is weak, instead of saying the agent failed. And the isolation protocol, grading each step from a gold prefix, is the mechanism that makes those six numbers mean anything.
[O] And the format axis was ahead of its time. Structured-output reliability being orthogonal to reasoning is now an accepted thing you design around. This paper measured it in December twenty twenty-three and built a protocol to separate it.
[S] I will concede the vocabulary and the isolation protocol. Both hold up. Here is my deflation, in three parts. First, the roster is a fossil. Testing ran the first through the tenth of December, twenty twenty-three. No G P T four o, no Claude three or four, no Llama three, no reasoning-tuned model at all. The claim of a clear gap between open source and G P T four is a snapshot of that fortnight, not a property of the world.
[O] I will grant the fossil point without a fight. What is second?
[S] The gold answers are machine-authored. G P T three point five drafts queries, G P T four refines them, and a three-role G P T three point five pipeline writes the golden plans, thoughts, calls, and reviews that every model is graded against. Humans filter fifteen hundred down to five hundred and fifty-three, but the paper reports no inter-annotator agreement and no rate at which human verification actually overrode the machine rather than approving it.
[S] So you may be rewarding stylistic resemblance to G P T three point five's tool-use conventions. And then you use a G P T four judge for the cross-check. There is a great deal of the same family in that loop.
[G] Let me adjudicate. On the roster, the skeptic is simply right, and it is a dating problem rather than a design flaw — though it does mean the paper's most-quoted sentence has aged badly while its method has not.
[G] On the gold answers, also right, and the authors partly concede it. The camera-ready's limitations section says the golden paths are machine-generated with human verification and that it would be hard to scale the construction process up. What they do not report is the divergence rate, and without it you cannot distinguish careful filtering from rubber-stamping.
[O] Does any of that damage the decomposition itself, though, or only the leaderboard it produced?
[G] Only the leaderboard, and that is where I score for the optimist. Even if the gold path reflects G P T three point five's habits, comparing every model against the same fixed prefix still localizes failure, which is the thing no prior benchmark could do.
[O] And what neither of us should claim?
[G] That a sub-ability score predicts deployment reliability. The paper never establishes that. Outside the six-model win-rate check, nothing connects a sixty-five on retrieve JSON to any downstream task-success number. It is a diagnostic instrument with almost no external calibration.
[S] That is the honest summary. And the frozen design has a cost the paper underweights — nothing is executed at grading time, so T Eval cannot tell you how a model handles a genuinely novel failure. A malformed response, an undocumented rate limit, a tool silently returning stale data. Those never happen in a pre-recorded observation.
[G] Correct, and it is a deliberate trade rather than an oversight. They bought stability and comparability with it. But review, the ability most about coping with the unexpected, is being tested entirely on expected things.
[O] What would raise your confidence, Imogen?
[G] Three things. A human-versus-machine divergence rate on the golden paths. A refreshed model roster, or a held-out split, so the gap to the frontier is not calibrated against one superseded checkpoint. And a real live-execution arm, even a modest one, tying sub-ability scores to actual downstream task success.
[O] Imogen, your one-sentence takeaway.
[G] T Eval's lasting contribution is the isolation protocol — grading each tool-use micro-decision against a fixed gold prefix so failures localize instead of compounding — and its leaderboard, resting on machine-authored gold and a December twenty twenty-three roster, has aged considerably faster than its method.
[S] Mine: a benchmark whose easy protocol is harder than its difficult one for an entire model family is measuring format familiarity alongside capability, and you should read every open-versus-closed gap here with that in mind.
[O] And mine: the six-way decomposition gave the field a way to say which link broke, and that vocabulary outlived every number in the table. Full writeup, with the figures, the main table, and the references, is on the litsearch site.
