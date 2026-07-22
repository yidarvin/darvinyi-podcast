---
slug: yao-2022-react
title: "ReAct: Synergizing Reasoning and Acting in Language Models"
description: "The paper that taught language models to think out loud between actions, seeding the default agent scaffold — even though its own flagship benchmark number quietly loses to plain chain-of-thought."
date: 2026-07-19
guest_name: "Elena"
guest_voice: af_nicole
---
[O] Here's the number that made this paper famous: on a household-tasks game called ALFWorld, a model prompted with just a couple of examples beat an agent trained on tens of thousands of trajectories by thirty-four percentage points, absolute.
[S] And here's the number that paper buries: on its own flagship task, question answering, the method it's named for actually loses to plain chain-of-thought. Not a tie. A loss.
[O] It also wins once you let it fall back to chain-of-thought when it's stuck, which is kind of the whole point of the paper.
[S] Which is exactly the kind of asterisk I want to spend the next half hour pulling apart.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a guest scholar take apart one paper from the litsearch site. Today it's "ReAct: Synergizing Reasoning and Acting in Language Models," Yao and colleagues, published at ICLR twenty twenty-three. Joining us is Elena, who's spent a lot of time with this one.
[G] Glad to be here. One thing up front: I'm not one of the authors, so when I say "they show" or "the paper argues," that's me describing their work, not claiming it.
[S] Fair enough, Elena. So why does a twenty-twenty-two prompting paper still get a full episode?
[G] Because almost every agent scaffold you've used since — a model that thinks, calls a tool, thinks again — is a direct descendant of this paper's core trick.
[O] Set the stage for us. What was broken before ReAct?
[G] Two separate literatures, basically. Chain-of-thought prompting had shown language models could reason step by step through arithmetic and commonsense problems. Separately, a line of work — SayCan, WebGPT, Inner Monologue — used language models to generate actions for embodied or web agents. Almost nobody combined them.
[S] Why does that split actually matter? Reasoning alone sounds fine on its own.
[G] Because the authors call chain-of-thought a "static black box." The model reasons entirely from its own frozen internal representations, with nothing external to check itself against. So it hallucinates a fact early in a chain, and that error just propagates downstream with no way to catch it.
[O] And the action-only side has the opposite failure.
[G] Right. Agents that only act tend to lose the plot on long-horizon tasks. They don't decompose a high-level goal into subgoals, and they don't track what they've already tried, so they wander.
[S] So the pitch is: put reasoning and acting in the same loop.
[G] Exactly, and the authors frame it through human cognition, the inner speech you use while cooking. "Now that everything's cut, I should heat the pot." "I'm out of salt, use soy sauce instead." That tight loop between thinking and doing is what they're trying to give the model.
[O] Okay, get concrete. What did they actually build?
[G] It's a small idea with a big name. Normally an agent picks an action from a fixed action space, given its context. ReAct just adds a second kind of action, a thought. Formally, the augmented action space is A-hat equals A union L, where L is the space of language.
[S] What does a thought actually do inside the environment?
[G] Nothing, and that's the point. A thought doesn't touch the environment and produces no observation back. It only rewrites the model's own context for the next step. So the trajectory becomes a stream of thought, action, observation, thought, action, observation.
[O] So the model is literally narrating its own plan in between doing things.
[G] Right, and those thoughts do real work: decomposing a goal, injecting commonsense like "desk lamps are usually on desks or dressers," pulling the relevant fact out of a noisy observation, or noticing a search failed and reformulating it.
[S] And none of this needs any training.
[G] Correct, that's a genuine strength. Everything in the main paper runs on a frozen PaLM model at five hundred forty billion parameters, prompted with somewhere between one and six human-written examples depending on the task. Annotating a ReAct prompt is just typing your thoughts on top of the actions you'd take anyway.
[O] Walk us through how it actually touches the world, say on the question-answering side.
[G] For HotpotQA and Fever, they give the model a deliberately simple Wikipedia interface: search of an entity, which returns the first five sentences of that page, or similar titles if it doesn't exist; lookup of a string, which behaves like control-F on the page; and finish, which submits the answer. Thoughts are dense here, nearly one before every action.
[S] "Deliberately simple" is doing a lot of work in that sentence.
[G] It is, and we should come back to that. For the decision-making tasks, ALFWorld and WebShop, the thought schedule flips. Thoughts are sparse; the model decides for itself when a thought is worth generating, because the action sequences run much longer.
[O] You mentioned falling back to chain-of-thought earlier. How does that actually work?
[G] Two heuristics. ReAct falling back to self-consistency chain-of-thought: if ReAct can't produce an answer within seven steps on HotpotQA, or five on Fever, the model backs off to a self-consistency vote over pure chain-of-thought samples. And the reverse, self-consistency chain-of-thought falling back to ReAct, triggers when the majority vote among the sampled chains wins fewer than half the votes, meaning the model's internal knowledge looks shaky, so it goes and checks Wikipedia instead.
[S] Those thresholds, seven steps, half the votes, who chose those, and on what basis?
[G] The authors, by inspection on the training data. It's a hand-tuned heuristic, not something learned end to end. Worth flagging.
[O] Last piece on the method, you mentioned fine-tuning.
[G] Right, a small coda. They bootstrap three thousand ReAct trajectories that reached correct answers, and fine-tune much smaller PaLM models, eight billion and sixty-two billion parameters, to imitate them. That's a completely different regime from the few-shot prompting story, and it changes the results substantially, which we'll get to.
[O] Give us the numbers. Start with the knowledge tasks.
[G] Table one, the five-forty-B PaLM model. On HotpotQA exact match: standard prompting gets twenty-eight point seven, chain-of-thought twenty-nine point four, act-only twenty-five point seven, and plain ReAct twenty-seven point four. On Fever accuracy: standard fifty-seven point one, chain-of-thought fifty-six point three, act-only fifty-eight point nine, ReAct sixty point nine.
[S] Hang on, say that HotpotQA line again. ReAct is below chain-of-thought, and below plain standard prompting?
[G] Yes. Twenty-seven point four, versus twenty-nine point four for chain-of-thought and twenty-eight point seven for standard. On its own headline benchmark, plain ReAct is not the best method in that table.
[O] But it wins on Fever.
[G] It does, sixty point nine versus fifty-six point three for chain-of-thought, and the authors' explanation is that verifying a claim needs an up-to-date fact, which retrieval gives you and pure reasoning doesn't.
[S] So where does the marquee "ReAct wins" result actually come from?
[G] From combining methods. ReAct falling back to self-consistency chain-of-thought reaches thirty-five point one on HotpotQA; the reverse combination reaches sixty-four point six on Fever. Those are the best prompting numbers in the paper, but they're still far under the supervised state of the art, which sits at sixty-seven point five and eighty-nine point five.
[O] What about the error analysis? Why does grounding actually help?
[G] They hand-labeled two hundred trajectories, a hundred from each method, split between correct and incorrect. ReAct's true-positive rate, correct trace and correct facts, is ninety-four percent versus eighty-six for chain-of-thought. And hallucination accounts for fifty-six percent of chain-of-thought's failures, versus zero percent for ReAct.
[S] Zero percent sounds almost too clean.
[G] It's real, but it's not free. ReAct's reasoning-error rate is higher, forty-seven percent versus sixteen for chain-of-thought, including a specific failure where the model gets stuck repeating the same thought and action in a loop. And twenty-three percent of ReAct's failures are just uninformative Wikipedia searches it can't recover from.
[S] Does the paper explain why it loops like that?
[G] They have a guess, not a confirmed answer. A footnote suggests it might be the greedy decoding they used, and that something like beam search could help. They don't actually test that, so whether better decoding fixes the looping is something the paper doesn't answer.
[O] Now the part everyone actually remembers, ALFWorld and WebShop.
[G] On ALFWorld, the best of six ReAct prompt permutations gets a seventy-one percent overall success rate, against forty-five for the best act-only prompt and thirty-seven for BUTLER, the imitation-learning baseline. ReAct's average across those six trials is fifty-seven percent, and even its worst trial, forty-eight percent, beats everyone else's best.
[S] And WebShop?
[G] ReAct scores sixty-six point six with a forty percent success rate, against imitation learning's twenty-nine point one percent and imitation-plus-reinforcement-learning's twenty-eight point seven percent. Roughly a ten-point absolute gain in success rate, with one or two prompt examples instead of thousands of training trajectories. Though everyone, ReAct included, is still well behind expert humans at fifty-nine point six percent.
[O] Any robustness checks across different base models?
[G] One appendix result: swapping PaLM for OpenAI's text-davinci-002, with the identical ReAct prompts. GPT-3 scores higher on both tasks, thirty point eight versus twenty-nine point four on HotpotQA, seventy-eight point four versus seventy point nine on ALFWorld, which at least suggests the paradigm isn't an artifact of one specific model.
[S] And the fine-tuning result you mentioned?
[G] That one flips the story. Under few-shot prompting, ReAct is actually the worst of the four methods at eight and sixty-two billion parameters, it's hard to learn both reasoning and acting from a handful of examples. But fine-tuned on those three thousand bootstrapped trajectories, ReAct becomes the best: the eight-billion fine-tuned model beats every sixty-two-billion prompted method, and the sixty-two-billion fine-tuned model beats every five-forty-billion prompted method.
[O] Okay, let me make the strongest case for this paper, because I think it's genuinely underrated even now. You don't need reinforcement learning, you don't need tens of thousands of trajectories, and you don't need fine-tuning to beat agents that had all three. One or two examples, and ReAct beats BUTLER, beats imitation learning, beats imitation-plus-reinforcement-learning. And it fixes chain-of-thought's actual worst failure mode: hallucination drops from fifty-six percent of failures to zero. That's the paradigm every tool-using agent since has copied — think, act, look at what happened, think again.
[S] I'll grant the paradigm point, I'm not arguing the idea was wrong, I'm arguing the twenty-twenty-two evidence for it is thinner than people remember. Start with ALFWorld: the headline seventy-one percent is best of six prompt permutations. The average is fifty-seven. That's a real gap, and reporting the max while the mean sits in the body is a choice that flatters the number.
[O] Fair, but the average still clears every baseline.
[S] It does, I'll give you that one. Harder to wave away: on HotpotQA, the task this whole paper opens with, plain ReAct loses to plain chain-of-thought and loses to standard prompting with no reasoning at all. The synergy story only survives because they bolt on a hand-tuned fallback heuristic, seven steps, then bail to chain-of-thought. That's a real result, but it's not the clean story the abstract sells.
[G] Both of those are accurate reads of the paper. I'd add a third: the Wikipedia interface is a toy by design, first five sentences, exact title match, and the authors say so themselves, calling it "significantly weaker than state-of-the-art lexical or neural retrievers." A quarter of ReAct's failures are just bad search. So some of the ceiling on the QA numbers is a retrieval-interface problem, not a reasoning problem, and it's hard to fully separate the two from what's reported.
[S] There's a contamination angle too, isn't there? HotpotQA and Fever are from twenty eighteen.
[G] Yes, both predate PaLM's training cutoff, so chain-of-thought's closed-book strength partly reflects memorized facts rather than pure reasoning skill. The paper even flags outdated gold labels on some HotpotQA questions, where its own retrieval turns up a more current answer than the dataset's frozen label allows. And exact match is a blunt instrument here too: twenty-eight to twenty-nine percent of the disagreements they hand-checked were just phrasing mismatches, not wrong answers.
[O] Okay, that's a real ding. But does any of that touch the decision-making results, ALFWorld and WebShop? Those don't have a contamination story the same way.
[G] Not in the same way, no. My honest read, going a little beyond what the paper states directly, is that the decision-making results are the more durable evidence. A twenty-to-thirty-four-point gain on ALFWorld and a roughly ten-point gain on WebShop, even comparing ReAct's plain average against the baselines' best runs, are hard to explain away with retrieval quality or label noise.
[S] So: paradigm, yes. The specific twenty-twenty-two scoreboard, read carefully.
[O] Big picture, what actually changed because of this paper?
[G] Essentially every agent you interact with today, a model that calls a search tool, reads the result, and decides what to do next, inherited this loop. The specific benchmarks aged out; the interleaving pattern didn't. There's a smaller inheritance too: because the reasoning is now visible text instead of a hidden internal state, a human can read a trajectory, catch a bad thought mid-run, and edit it. That's basically the seed of today's human-in-the-loop agent tooling.
[S] There's also an evals lesson buried in here that feels relevant to this audience specifically. Best-of-k reported as the headline while the mean sits in the appendix, a single base model carrying the main claims, exact match undercounting correct answers. Those are exactly the failure modes that keep showing up in agent benchmark papers being published this year.
[O] Which is maybe the most ReAct-coded thing about ReAct. Even its own evaluation reads like an early draft of problems the field is still arguing about.
[G] If I had to leave you with one sentence: the paper's real claim isn't that ReAct wins every number in the table, it's that letting a language model narrate its own plan in between actions makes it both more capable and more inspectable, and that trade held up better than most of its original scores did.
[O] Mine: this is the paper that taught the field to let a model think out loud on purpose, and years later we still haven't found a better default.
[S] Mine: read the average, not just the best of six, and remember the flagship task where the celebrated method actually lost. Full trajectories, all four tasks, and the complete error breakdown are in the writeup on the litsearch site.
