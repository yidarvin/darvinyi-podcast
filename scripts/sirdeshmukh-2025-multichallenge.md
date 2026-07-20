---
slug: sirdeshmukh-2025-multichallenge
title: "MultiChallenge: A Realistic Multi-Turn Conversation Evaluation Benchmark Challenging to Frontier LLMs"
description: "Every frontier model fails more than half the time on ordinary multi-turn conversations, and the benchmark that proves it also invented a clever trick for making an LLM judge trustworthy."
date: 2026-07-19
guest_name: "Maya"
guest_voice: "af_bella"
---
[O] Every frontier model in this paper fails more than half the time, on conversations an ordinary person could have with a chatbot in one afternoon.
[S] Which sounds damning until you notice who wrote the test. The same six models that got beaten also picked which conversations counted as hard.
[O] Fair, but Claude 3.5 Sonnet still only clears forty-one percent, and this isn't an adversarial jailbreak prompt. It's someone asking for a dessert recipe.
[S] A dessert recipe that quietly checks whether the model remembers a nut allergy mentioned six turns earlier. That's the whole game today.

[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a guest scholar take apart one paper from the map each episode.
[S] Today's paper is MultiChallenge, A Realistic Multi-Turn Conversation Evaluation Benchmark Challenging to Frontier LLMs, out of Scale AI, published at ACL twenty twenty-five.
[O] Joining us to walk through it is Maya, who has spent a lot of time inside this paper's rubrics and appendices. Welcome, Maya.
[G] Glad to be here. It's a small benchmark by dataset standards, two hundred seventy-three conversations, but it's doing something the field badly needed.

[S] Maya, set the stage. Why did we need yet another conversational benchmark?
[G] Because the ones everyone was using had stopped measuring anything. MT-Bench and MT-Eval were the standard multi-turn tests, and by twenty twenty-four, GPT-4, Claude 3, and Llama 3 were all scoring near perfect on them.
[O] Which sounds like great news. Models got good at conversation.
[G] Except a benchmark everyone passes stops discriminating between models, and worse, it stops telling you where the real failure modes are. The authors needed something with headroom left.
[S] What about Multi-IF? I thought that one already extended instruction following into multi-turn settings.
[G] It did, and it's a real contribution, but it tests explicit, auto-verifiable instructions. Keep every word in uppercase, use exactly three bullet points. Clean to grade, but not what makes ordinary conversations hard.
[O] What does make them hard, in the paper's own framing?
[G] Three things happening at once: following instructions, allocating attention across a growing context, and doing in-context reasoning over what's in that context. Existing benchmarks isolate the first of those and largely ignore the other two.
[S] So the design goal was a benchmark that forces all three simultaneously.
[G] Exactly, and that it stay realistic. Not a trick question, but the kind of slip that actually happens when someone uses a chatbot for ordinary things, planning a trip, editing a document, asking for recipes.

[O] Walk us through the actual test format. What does one example look like?
[G] Up to ten conversation turns between a user and an assistant, ending on a final user message the model under test has to answer. Average length is about five turns and twelve hundred thirty-two words, so these are short by any modern context-window standard.
[S] So it's not a long-context stress test.
[G] Correct, and that distinction matters a lot later. There are four challenge categories, each isolating a different way multi-turn conversation breaks down.
[O] Start with the one from the cold open.
[G] Instruction Retention. A user states a constraint in the first turn, films should only carry a UK age rating of fifteen or eighteen, and never repeats it. Many turns later, the model has to still be honoring that constraint when it makes its final recommendation. Sixty-nine examples test exactly that.
[S] And the nut allergy one is a different category.
[G] Inference Memory, a hundred and thirteen examples, the largest category. A detail gets mentioned early and in passing, a partner's nut allergy, and much later the user asks something that only implicitly depends on it, dessert recipes. Critically, the final turn never asks "does my girlfriend have a nut allergy." It only implies the fact matters. That's deliberate, so the model is tested on judging relevance, not on keyword lookup.
[O] That's a genuinely clever construction. It's testing whether the model reasons about what's relevant, not whether it can retrieve a fact.
[G] Right. Third category, Reliable Versioned Editing, forty-one examples. The user revises a document or schedule across several passes and then refers back anaphorically, "the plan we had before we adjusted the workshop's ending time." The model has to resolve which version that is, reproduce it accurately, and apply the new edit without hallucinating content that was never there.
[S] And the fourth?
[G] Self-Coherence, fifty examples, and this one's about sycophancy. The model tells the user, early on, that the next step for setting up their e-reader is to register the device. Later the user says, "all that's left now is to choose a book, right?" contradicting what the model itself said. Most frontier models just cave and agree.
[O] Which is a genuinely uncomfortable failure mode, the model contradicting its own earlier, correct answer because the user pushed back.
[S] How were these actually written? Two hundred seventy-three realistic, frontier-breaking conversations is a lot of careful authoring.
[G] A hybrid pipeline. A multi-agent system called MMSE generates a draft, then trained humans edit it. MMSE takes three seeds, a topic, a persona sampled from a public persona dataset, and a category-specific config, and runs three roles. A Planner Agent builds and updates a conversation blueprint, a User Agent turns that blueprint into concrete user turns designed to trip up the assistant, and a Responder Agent plays the assistant, sampled randomly from a pool of six frontier models so the data doesn't overfit to any one model's quirks.
[O] What decides whether a candidate conversation is even worth keeping?
[G] The planner keeps looping and revising until it detects an actual failure, at which point the conversation is saved for human review. If it hits the turn cap first with no failure, it's discarded.
[S] Isn't that circular, though, Maya? You're defining "hard" entirely in terms of six specific models failing, then grading exactly those six models on it.
[G] It's a fair tension, and it's one the authors flag themselves rather than hide. Hold that thought, it matters a lot when we get to the debate.
[O] And grading. You can't rule-check a thousand-word conversation with regex.
[G] Right, there's no single ground-truth answer, so the authors tried the obvious thing first, hand a judge model the whole transcript and ask if the response was good. That aligned with expert human raters only thirty-seven point three three percent of the time.
[S] That's barely better than a coin flip on a well-defined task.
[G] It's worse than it sounds, actually, because every one of those frontier judge models also scores under fifty percent on MultiChallenge itself, so you're asking a model to grade a task it can't reliably do. The fix is elegant: at authoring time, the human writer also writes one binary rubric question, a yes or no, that only needs the model's final response and is squarely within what current LLMs can judge. For the nut allergy example, it's just, "does any dessert recipe in this response contain nuts?"
[O] And that narrower question is answerable even by a model that can't solve the whole conversation.
[G] Ninety-three point nine five percent alignment with human raters, above ninety percent in every one of the four categories. A model's score is just the fraction of examples where its final response passes its own rubric question.

[S] Let's get to the actual numbers. Who wins, and by how much?
[G] Human evaluation first, since that's the ground truth here. Claude 3.5 Sonnet, the June twenty twenty-four version, leads at forty-one point four two percent average accuracy. o1-preview is second at thirty-seven point two three. Then a steep drop, Gemini 1.5 Pro at nineteen point nine six, Llama 3.1 four-oh-five B at fourteen point nine two, Mistral Large at fourteen point six three, and GPT-4o at twelve point five two.
[O] So the best model in the world, on ordinary multi-turn conversation, is right by human raters forty-one percent of the time.
[S] And the automatic evaluator, the one built on the binary rubrics, how well does it track that?
[G] Very closely. Claude at forty-two point seven five automated versus forty-one point four two human, o1-preview at thirty-five point seven three automated versus thirty-seven point two three human. Same ranking throughout, close numbers throughout.
[O] That's not a small result, it's the paper's evidence that the rubric design actually works as a cheap stand-in for expensive human grading.
[G] Right, Claude wins overall but loses to o1-preview on both Reliable Versioned Editing, twenty-four point three nine versus thirty-nine point oh two, and Inference Memory, thirty-seven point two nine versus forty-one point five three. Gemini nearly matches o1-preview on Instruction Retention, thirty-one point four three versus thirty-four point two nine, then falls way behind everywhere else.
[O] Couldn't that per-category spread just be small-sample noise, rather than real specialization, Maya?
[G] It's a fair worry given how few examples some categories have, but the pattern holds up across two independent measurements. Claude beats o1-preview on Instruction Retention and Self-Coherence in both the human and the automatic evaluation, and loses to it on the other two categories in both. That kind of agreement is more than you'd expect from pure noise.
[S] Which argues the four categories are measuring genuinely different things, not just one general conversation-skill dial.
[G] That's the intended reading, yes.
[O] Now the length question. Isn't this secretly just a long-context test wearing a multi-turn costume?
[G] The paper checks that directly, and the answer is no. Performance against number of turns shows no monotonic trend at all, it goes up and down as turns increase from two to ten. And the conversations are short anyway, five turns and about twelve hundred thirty-two words on average, nowhere near stressing any current model's context window. The difficulty is coming from the reasoning the context demands, not from how much of it there is.
[S] What about open models, since none of them were in the panel that built the benchmark?
[G] Run through the auto-evaluator, the strongest is Llama-3.3-70B at twenty-three point one nine percent, then Qwen2-72B at twenty point five eight, with the rest of the open pool between about eleven and seventeen percent. And here's the notable part, the benchmark should in theory be biased against the six closed frontier models, since they're the ones the acceptance gate was tuned against. Open models weren't part of that selection process at all.
[O] So if anything the deck should be stacked in favor of the open models doing relatively well here.
[G] And they still land below Claude and o1-preview. Bigger open models tend to do a bit better, roughly seventeen to twenty percent as parameter count climbs from three billion up to seventy or seventy-two billion, but it's not clean. Reliable Versioned Editing actually gets worse with scale in their data, though that category only has forty-one examples total, so I wouldn't hang much on that one trend line.

[O] Okay, time for the part where Michael tries to talk me out of being impressed.
[S] I don't need to try hard. Here's my problem: the six models that got scored are the same six models that generated and filtered the test set. An example only makes it into MultiChallenge if at least three of those six already fail it. That's not measuring general capability, that's measuring performance on a set adversarially mined against exactly those six.
[O] But the authors say that upfront, and their argument is that comparisons among future models in those same families, or against open models that had no part in construction, are still fair.
[S] Sure, but nobody reads a leaderboard that carefully. "Claude 3.5 Sonnet, forty-one percent" is going to get quoted as a capability number, and it isn't one. It's a number against a test built specifically to catch that model's blind spots.
[G] Both points are right, and the paper is honest about it, this is explicitly listed as a limitation. My read is the safe way to use MultiChallenge is the category-level ranking and the qualitative pattern, not the absolute score as a general capability estimate.
[O] Fine, point to Michael there. But here's my counter for the debate: the real contribution isn't the leaderboard, it's the instance-level rubric trick. Collapsing an unjudgeable, open-ended grading problem into one narrow yes-or-no question that a weaker judge can still answer reliably, that's a pattern other people can reuse regardless of what the six-model panel problem does to this specific number.
[S] I'll actually give you that one. Going from thirty-seven percent judge alignment to ninety-four percent by narrowing the question is a real methodological result.
[G] It's held up, too. That instance-level binary rubric idea is very much in the DNA of later rubric-based evals in the field. Beyond that, I'd flag two more limits, straight from the paper's own limitations section, not just my read. First, the difficulty ceiling is capped on purpose, any example whose rubric question was itself too hard for current judge models to answer got excluded and kept private. So the public two hundred seventy-three systematically leaves out its hardest cases.
[O] Meaning the public score is a floor, not the real difficulty.
[G] Exactly the authors' own framing. Second, one binary rubric per example only grades a single failure mode, on the final turn, with no partial credit and no read on whether the rest of the response was actually good. It tells you the model avoided one specific trap, not that it held a good conversation overall.
[S] And the category sizes are lopsided too, a hundred and thirteen Inference Memory examples against just forty-one for Versioned Editing, with no confidence intervals reported anywhere.
[G] Right, so a headline like "editing accuracy falls as models get bigger" is suggestive, not something I'd bet on holding up with more data.
[O] Net verdict from me: this is a genuinely hard, genuinely realistic benchmark with a reusable grading idea inside it, and it earned its citations.
[S] Net verdict from me: read the category rankings, ignore the second decimal place, and never forget the panel that built this test is the panel it grades.

[O] Zooming out, Maya, what should someone building real products take from this?
[G] That conversational reliability, holding an instruction, staying self-consistent, silently tracking relevant facts, is not something single-turn evals will ever catch, and it degrades faster than people assume once you go past two or three turns.
[S] And for evaluation practice specifically?
[G] The rubric design is the transferable lesson. If you're building any LLM-as-judge system, the result here says don't hand the judge the entire messy context and ask a vague question, narrow the judging task down to something the judge model can actually answer reliably, even when the underlying task is beyond it. That idea generalizes well past multi-turn chat, into contamination-resistant grading and reward modeling more broadly.
[O] It's also just a good reminder to check benchmark self-selection on any eval, not just this one, whenever the models that built the test are also the models being ranked on it.

[G] If there's one line to take from the paper itself, it's this: near-perfect scores on the old multi-turn benchmarks were never evidence that models could hold a real conversation, they were evidence the tests had stopped measuring anything.
[O] My takeaway: the instance-level rubric is the idea with legs here, and I expect to keep seeing its descendants in eval design for years.
[S] Mine: trust the category rankings, distrust the leaderboard, and remember who graded whom. For the figures, the full results tables, and the rest of the numbers we didn't have time for, go read the writeup on the litsearch site.
