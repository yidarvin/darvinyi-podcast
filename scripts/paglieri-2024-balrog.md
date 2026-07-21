---
slug: paglieri-2024-balrog
title: "BALROG: Benchmarking Agentic LLM and VLM Reasoning On Games"
description: "A benchmark that drops today's best language and vision models into six reinforcement-learning games, from a seconds-to-master grid world up to a NetHack run that takes humans years — and catches them stating a survival rule correctly, then breaking it two moves later."
date: 2026-07-21
guest_name: "Dmitri"
guest_voice: "am_fenrir"
---
[S] A model can tell you, in plain English, that eating rotten food in NetHack might kill it, and then two minutes later it eats the rotten food anyway.
[O] That's not a bug, Michael, that's the most honest failure mode I've seen all year — the knowledge is right there, it's the execution that isn't.
[S] Or it means the "knowledge" was never doing any work in the first place, just a party trick for a quiz question.
[O] Well, today's paper built an entire benchmark just to catch models in that exact contradiction.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a guest scholar take apart one paper from the litsearch dot darvinyi dot com map.
[O] Today it's BALROG, Benchmarking Agentic LLM and VLM Reasoning On Games, from Davide Paglieri and colleagues at University College London, IDEAS NCBR, Oxford, and NYU, published at ICLR twenty twenty-five.
[S] And joining us is Dmitri, a researcher who's spent a lot of time in the weeds of this paper's six game environments.
[G] Glad to be here. This is one of the more entertaining benchmarks to dig into, mostly because the failure modes are so viscerally clear once you watch a trajectory play out.
[O] Dmitri, give us the one-line version before we go deep — why does this paper exist?
[G] The authors argue that most agentic LLM benchmarks in twenty twenty-four cap an episode at a few dozen rounds of interaction — web navigation, GitHub issues, office tasks — and that ceiling hides whether models can actually act correctly over hundreds, or hundreds of thousands, of steps.
[S] So the claim is that short-horizon benchmarks are lying to us about long-horizon competence.
[G] That's the wager. Long-horizon decision-making is framed as the next frontier for these models, and the field is said to lack a comprehensive, difficulty-graded way to measure it.
[O] And their answer is games, which I love, because reinforcement learning has used games as a yardstick for decades — Atari, Go, StarCraft.
[G] That's exactly the lineage they invoke. Games come with lightweight simulators, clear objectives, and a known difficulty ladder, so BALROG stitches six existing RL environments into one testbed.
[S] Which six, and why these six specifically?
[G] BabyAI, Crafter, TextWorld, Baba Is AI, MiniHack, and the NetHack Learning Environment — spanning a task a human clears in seconds, that's BabyAI, up to NetHack, which takes human players years to master without a guide.
[O] That's the part that hooked me. It's not one difficulty, it's a ladder, so you can actually see where competence falls off a cliff instead of just failing one hard test.
[S] Fine, but ladders only work if you can't just memorize the rungs.
[G] That's the other design pillar. Every environment is procedurally generated, so no fixed level layout repeats. The authors are explicit that this closes off a leakage problem they call endemic to other benchmarks.
[O] Walk us through how the harness actually works, Dmitri — I know it's deliberately simple on paper.
[G] It's four files. env underscore wrapper dot p y standardizes the step and reset interface across all six environments regardless of their native APIs. client dot p y abstracts the model provider — OpenAI, Gemini, Claude, or a locally served model through the vLLM library. agent dot p y couples a model with a pluggable "agentic strategy." evaluator dot p y runs the episode loop and scores it.
[S] Why does that decoupling matter beyond being tidy software design?
[G] Because the whole point is that testing a new inference-time method means editing agent dot p y only, and benchmarking a new model zero-shot means editing a config in client dot p y only. And every baseline in this paper uses the simplest possible strategy: zero-shot prompting, no chain-of-thought, no few-shot examples.
[O] Which is important context for everything that follows.
[G] At each timestep, the agent gets the interaction history — observation plus prior action — in a chat-formatted prompt, and it has to emit the next action as a natural-language string. History is fixed at sixteen observations for every experiment in the paper.
[S] And if the model just hallucinates an invalid action?
[G] It's logged, and a fallback fires — a do-nothing action, or a default move like north — so the episode doesn't crash, but the failure is recorded in the trajectory statistics.
[O] Tell us about the two observation modes, because I think that's where the most interesting result lives.
[G] Every environment except TextWorld, which has no visual component, is tested both language-only — a templated text description of the state — and vision-language, that same text plus a rendered image of the current frame. MiniHack and NetHack additionally get an ASCII-rendered two-dimensional map in both modes.
[S] Only one image per prompt, though — is that a meaningful constraint?
[G] It is, and the authors say so themselves. Because of the cost of image tokens, only the single current frame is included per prompt, with the rest of the sixteen-step history staying text-only. They flag that as a real limitation, not a footnote.
[O] And the scoring is the part I think is genuinely well designed. It's not win or lose.
[G] Right, it's a zero-to-one-hundred progress score. For BabyAI, MiniHack, and Baba Is AI, it's binary per episode — solved or not. For TextWorld and Crafter, it's the proportion of achievements unlocked out of the maximum. For NetHack, the game's own in-built score is a bad proxy for actual progress, so the authors built a novel, data-informed progression metric specifically to capture how far an agent actually got.
[S] Who's actually being tested here?
[G] Seven main models — Gemini one point five Flash and Pro, GPT-4o-mini and GPT-4o, Claude three point five Sonnet and Haiku, and four sizes of Llama, the eight B and seventy B from three point one, and the one B, three B, eleven B, and ninety B from three point two. Plus OpenAI's o1-preview, but only on NetHack, because of budget constraints.
[O] That caveat is going to matter a lot in a few minutes.
[O] Let's get to numbers. Who wins language-only?
[G] Claude three point five Sonnet, at an average progression of thirty-two point six four percent across all six games, with a standard error of about one point nine. GPT-4o is a hair behind at thirty-two point three four percent. Then Llama three point one seventy B at twenty-seven point eight eight, and Llama three point two ninety B close behind at twenty-seven point two nine.
[S] Those top two are basically tied within error bars.
[G] They are, and the paper doesn't claim otherwise — it calls GPT-4o "closely following."
[O] But the shape of the curve matters more than who's on top. Everyone does fine on the easy end.
[G] Correct. BabyAI, Crafter, and Baba Is AI all show reasonable progress across the board. Then it falls off a cliff. MiniHack's Quest and Boxoban tasks were never solved by a single model, at any seed. And every model flatlines on NetHack.
[S] Give me the NetHack number, because I've heard it's brutal.
[G] The best NetHack performance in the entire paper belongs to o1-preview, at one point five percent average game progression — the authors' own words are "far from satisfactory." That's still roughly three times its closest text-only competitor, Claude three point five Sonnet, which is essentially at zero.
[O] Three times better than basically zero is still basically zero.
[G] That's a fair characterization, yes.
[S] Now the vision result — this is the one I find most interesting, because it inverts the intuition.
[G] Adding an image mostly hurts. GPT-4o drops from thirty-two point three four percent text-only to twenty-two point five six with vision. Llama three point two ninety B drops from twenty-seven point two nine to just under twenty-one percent. Claude three point five Sonnet and Gemini one point five Pro are the exceptions — Sonnet actually improves, to thirty-five point four eight percent, making it the best vision-language model in the whole paper, better than its own text score.
[O] So vision isn't uniformly bad, it's that most models can't use it, and one or two clearly can.
[G] That's the paper's read too. They attribute Sonnet's edge partly to its computer-use training, which inherently requires integrating visual and textual input for action-based reasoning.
[S] And there's a weird artifact in TextWorld I want on the record.
[G] Gemini's API flagged the TextWorld prompts as unsafe and refused them, despite the authors describing the prompts as containing no actual safety concerns — so Gemini scores zero on that game for reasons that have nothing to do with capability.
[O] That's a great example of why you read the fine print before you rank a leaderboard.
[S] Now give us the knowing-doing gap, because that's the headline qualitative finding.
[G] The authors ran a five-question questionnaire on basic NetHack knowledge in a separate thread, outside gameplay. Models correctly answer that eating rotten food can cause blindness, hallucination, or death, and that ascending the stairs on level one causes instant game over. Then, in actual play, GPT-4o repeatedly dies from eating rotten food it can correctly identify as dangerous, and models exit the dungeon early despite knowing that ends the game instantly.
[O] The knowledge and the action are just not talking to each other.
[G] That's the paper's framing exactly — a disconnect between declarative knowledge and in-context decision-making, under the pressure of a live trajectory.
[O] Let me make the optimist case, because I think this paper is more encouraging than it sounds. You've got a difficulty ladder with real signal at every rung, and this is entirely zero-shot, with no scaffolding at all. Add chain-of-thought or a ReAct-style loop and I'd bet real money the easy-to-medium scores climb fast.
[O] And the procedural generation genuinely defeats the laziest form of contamination — you can't memorize a walkthrough for a level that never repeats twice.
[S] I'll grant the leakage point, that's real and checkable. But every number in this paper is a floor, not a ceiling, and the paper says so itself.
[S] Chain-of-thought, few-shot, and in-context reinforcement learning are all explicitly left as future work, not baselines. So when Dmitri quotes thirty-two point six four percent for Sonnet, that's "Sonnet prompted with nothing extra." We don't know what Sonnet with a scaffold does, and neither does this paper.
[G] That's accurate. The authors themselves note that a single NetHack demonstration can run past seven hundred thousand input tokens, which they found infeasible to prompt with naively at the time of writing — so the future-work list isn't padding, it's a real, acknowledged gap.
[O] Fine, but that cuts in my favor too — it means the ceiling on this benchmark hasn't been probed yet, which is exciting, not damning.
[S] It's exciting, and it also means the "far from solving this" framing is doing more work than the evidence supports.
[S] My second problem is contamination of a subtler kind. Procedural generation stops you from memorizing a specific dungeon, but NetHack has decades of public wikis and strategy guides, and the questionnaire result — models reciting the danger of rotten food — is exactly what you'd expect if that declarative knowledge is baked into pretraining.
[G] The paper actually cites the NetHack Wiki directly, as the kind of resource new human players rely on, so that pretraining exposure is plausible — though the authors frame the gap as knowing-doing, not contamination. They don't test which one it actually is.
[O] Knowing the rule from a wiki and still failing to apply it in a live trajectory is arguably worse for the "models are secretly capable" story than good news, though.
[S] Agreed, that particular result cuts against hype either way.
[S] Third point — o1-preview, the one model that actually moves the needle on NetHack, was tested on NetHack only, for budget reasons. We have zero data on how a reasoning model does on the five easier games, and zero data on it in vision mode.
[G] Correct, that's a real hole. The headline "reasoning helps" story rests on one model, one environment, one modality.
[O] I'll take that one clean, no defense.
[S] Last point — no cost or token comparison is reported across models, even though a NetHack demonstration running to seven hundred thousand tokens is exactly the kind of practical constraint that shaped half the paper's own methodology.
[S] And some of the "surprising" wins, like the Llama models narrowly leading on Baba Is AI, sit inside standard-error bars wide enough to make "leading" close to a coin flip.
[G] Both fair. The paper reports standard errors from five seeds across Baba Is AI's forty tasks, and several of the top rows do overlap — I'd call that ranking suggestive, not settled.
[O] Where does that leave us? I still think the core contribution stands — a leakage-resistant, difficulty-graded testbed that surfaces a real capability gap nobody else was measuring.
[S] Agreed on the diagnosis. I just don't think the paper has earned the word "ceiling" yet — it measured a floor, cleanly, and described it as further than the evidence lets it.
[G] That's roughly how I'd summarize the paper's own honesty, too. It reads more like a diagnosis than a verdict, and the authors mostly say so themselves in the limitations and future-work sections.
[O] Zoom out for a second — why should someone who cares about evaluation broadly care about this paper, beyond agentic gaming?
[G] Because it's a clean case study in metric design for long-horizon tasks. Fine-grained partial credit instead of binary win-loss is exactly what you want if you're trying to detect incremental capability gains, rather than wait for a single pass-fail cliff.
[S] And it's a useful contamination case study too — procedural generation defeats instance-level leakage, but not knowledge-level leakage from public wikis, which is a distinction a lot of benchmark designers still blur.
[O] Agreed, and I'd add: the knowing-doing gap should worry anyone building agents for real deployment, not just game-players. If a model can state a safety rule and then violate it under task pressure, that generalizes badly.
[G] My one-line takeaway, sticking close to what the paper shows: BALROG is a real, leakage-resistant instrument that finds a genuine knowing-doing gap and a counterintuitive vision-hurts-more-than-helps result, but its headline "how far are we from solving this" numbers describe naive zero-shot prompting, not a ceiling on these models.
[O] Mine: the fact that this benchmark isn't saturated at the easy end, and that the ladder itself works, is the more interesting long-term story than any single number in the tables.
[S] Mine: read every number here as the floor with no scaffolding, and don't let a benchmark's own framing tell you it's found a hard ceiling when it's tested exactly one prompting strategy.
[O] That's it for this episode of Litsearch Audio. Thank you, Dmitri, for walking us through it.
[G] My pleasure.
[O] For the figures, the full leaderboard tables, and our own critique, head to the writeup on litsearch dot darvinyi dot com. See you next time.
