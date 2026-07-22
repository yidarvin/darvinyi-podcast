---
slug: huang-2025-gather-info
title: "Teaching Language Models To Gather Information Proactively"
description: "A seven billion parameter model learns to ask the one clarifying question that actually matters, by being rewarded only when the answer pulls out something it couldn't have guessed."
date: 2026-07-19
guest_name: "Maya"
guest_voice: af_nicole
---
[O] Picture the laziest possible prompt: "help me write a lesson plan." Nothing about grade level, subject depth, or what the student already knows.
[S] And a model that just answers anyway, filling in every blank with its best guess and hoping it lands.
[O] Today's paper trains a model to stop guessing and ask a genuinely useful question first. That's the promise.
[S] My worry going in: what stops "asks good questions" from turning into "asks endless questions," and how do you even train a reward for a good question in the first place?
[O] Welcome to Litsearch Audio, where two hosts and a guest scholar go deep on one paper at a time from the Litsearch site.
[S] Today's paper is "Teaching Language Models To Gather Information Proactively," by Tenghao Huang and colleagues at Microsoft, U-S-C, and U-C Davis, in Findings of E-M-N-L-P twenty twenty five.
[O] It's brand new, only a handful of citations so far, but it's going after something every one of us has felt using an assistant: it just answers, when what you actually needed was a good follow-up question.
[S] And joining us is Maya, who's spent real time in this paper's weeds. Maya, welcome.
[G] Glad to be here. This is a fun one. It's less about a flashier model and more about a completely different question: when should a model open its mouth and ask, instead of just answering.
[S] So set up the problem for us. Why is "just answer the prompt" actually broken?
[G] The authors point to something concrete. An Anthropic education report found that more than half of real assistant conversations are collaborative back-and-forth rather than one-shot. Users don't front-load everything the model needs.
[O] Which sounds obvious once you say it out loud. Nobody writes a perfect spec on the first try.
[G] Right, and the paper calls this information asymmetry. The user is sitting on domain knowledge, formatting preferences, constraints they never bothered to type, and the model only ever sees a slice of it.
[S] Okay, but models already ask clarifying questions sometimes. Why isn't that solved?
[G] Because the questions they ask are the wrong kind. The paper shows baseline models mostly do slot-filling. They ask about something already visible in the prompt, or they lob a generic question that doesn't move anything forward, like "what outcomes do you want" when the user already told you the topic.
[O] So it's clarifying without actually gathering anything new.
[G] Exactly the distinction the paper wants you to sit with. Proactive information gathering isn't resolving an ambiguity that's already on the table, it's reaching for something the user never mentioned at all: unstated domain expertise, a formatting rule, a fine-grained requirement.
[S] Why hasn't anyone just trained this directly, then? It doesn't sound like a brand new idea.
[G] Two blockers, and the authors are upfront about both. First, data. Real collaborative dialogue is scarce and often proprietary. Second, and harder, reward. What makes a question good, helpfulness, novelty, whether it complements what's already known, is subjective and resists a clean automatic signal, unlike math or code, where you can just check if the final answer is right.
[O] Which is exactly the terrain reinforcement learning has struggled with outside verifiable domains.
[G] Right, and closing that gap is what this paper sets out to do.
[S] Let's get into the mechanics, then. How do you even build training data for "ask about the thing nobody mentioned"?
[G] The clever part is they don't collect it, they manufacture it, by masking. They start from an existing dataset called Dolomites, named after the mountain range, five hundred nineteen long-form writing task templates elicited from two hundred sixty six working professionals across twenty five domains: medicine, law, civil engineering, and more.
[O] So real expert-level writing tasks, not toy prompts.
[G] Right. Each task template has four parts: an objective, a procedure, an input section, and an output specification. The trick is which half they show the model. The objective and the input section, the part a lazy user would actually type, that's shown. The procedure and the output specification, the part that captures real domain expertise and formatting requirements, that's hidden.
[S] So the model is structurally forced to ask, because half the task is invisible to it by construction.
[G] Exactly, and that's what makes it scalable. You're not paying humans to role-play ambiguous conversations, you're mechanically splitting existing expert-authored tasks into a visible half and a hidden half.
[O] Walk us through what actually happens once the model is missing that hidden half.
[G] They frame it as a partially observable Markov decision process. The assistant only sees the visible half. A second language model, a user oracle, has access to both halves and answers honestly from the hidden part. Over up to five turns the assistant asks a question, the oracle answers, and that running dialogue becomes its working estimate of what it's missing. Then it uses up its budget or calls stop, and drafts a final answer.
[S] Important detail: who's actually writing that final answer?
[G] A fixed, un-fine-tuned GPT-four-oh, held constant across every condition in the paper. The model being trained is purely the question-asker. It never touches the final prose.
[O] That's a really clean isolation, actually. Whatever wins, wins on question quality alone, not writing quality.
[S] Or it's a really convenient one, depending how you squint at it. We'll come back to that.
[G] Fair, hold that thought, it matters a lot for how you read the headline result.
[O] Okay, so how do you reward a question when there's no single right answer to check against?
[G] This is the actual contribution, in my read. Instead of grading the final essay against a thin reference, sparse and noisy, especially early on when good questions are rare, they reward each question directly. They split the hidden information into sentences, each tagged as a hidden field, then prompt the oracle to say which sentences it would cite to answer the assistant's question. If any cited sentence falls inside a hidden field, the question earns a reward of one. Otherwise, zero.
[S] So it's binary. Did this question pull in anything genuinely new, yes or no.
[G] Right, no span annotation, no human labeling. The oracle's own citation behavior becomes the label, for free, at every single turn.
[O] And that's dense enough to actually train on, unlike scoring one long essay at the very end.
[G] Exactly, and they use that per-turn signal to train a Qwen two point five, seven billion parameter model with P-P-O, proximal policy optimization, in an actor-critic setup, using the verl framework. Three epochs, eight A-one-hundred GPUs, batches of two hundred fifty six episodes, a clip parameter of point two, and separate learning rates, roughly two times ten to the negative fifth for the actor, ten times higher for the critic.
[S] That's a fairly standard P-P-O recipe. The novelty is entirely in what the reward is measuring, not in the R-L machinery.
[G] Agreed, and I think that's the right way to read this paper. It's a reward-design paper wearing an R-L paper's clothes.
[O] Let's get to numbers, then. Does it actually work?
[G] The trained model, they call it Qwen-R-F-T, scores point six five on their writing checklist metric, the top of every comparison in the paper. That's an eighteen percent relative gain over o3-mini, and the authors report it's statistically significant.
[S] Point six five out of what, exactly?
[G] It's a checklist coverage score. They take the hidden output specification and turn it into a set of checklist items, then a separate frozen judge model checks whether the final essay satisfies each one, no partial credit for something omitted or misformatted. So point six five means it recovered roughly two thirds of the hidden requirements in its final draft.
[O] And remember, every method here is paired with the same fixed GPT-four-oh writer. So the entire gap between point six five and everyone else comes down to which questions got asked.
[S] What's everyone else scoring?
[G] O-three-mini as a questioner lands around point five five. GPT-four-oh asking its own questions gets point five one, roughly the same as GPT-four-oh answering directly with no clarification at all. Two supervised fine-tuned variants, trained by imitating synthetic conversation transcripts, actually land lower than their own un-tuned base models, point four seven and point four six.
[O] Wait, fine-tuning on conversations made it worse?
[G] Worse than doing nothing. Imitating question traces taught something, but not proactive questioning. Only the outcome-based reward actually moved the needle. One more baseline worth naming: GPT-four-oh trained with D-P-O on real human brainstorming turns mined from meeting transcripts reached point five seven, genuinely helped by human data, but still behind the reward-trained model.
[S] So imitation learning failed and reinforcement learning worked. That's a real result, not just a marginal bump.
[G] And it's consistent across their other analyses. Broken out by domain, R-F-T scores point eight three in social science and point seven one in humanities, against direct baselines of point four six and point four in those same domains, so gains of roughly plus point three seven and plus point three one. In technology, a more procedural domain, the gain is much smaller.
[O] Which fits the whole thesis. Proactive questioning pays off exactly where the task is underspecified and open-ended, and pays off less where the task is already fairly mechanical.
[S] What about the worry that it just asks more questions, not better ones?
[G] They check that too. Across turn budgets, R-F-T keeps climbing to its five-turn cap and holds the gain, while GPT-four-oh and its fine-tuned cousin plateau after three turns. They also trace where each model's questions pull evidence from in the source document: R-F-T's questions concentrate on the procedural and output-requirement text, exactly where the hidden information lives, while the baselines stay biased toward things already visible.
[O] That's a nice mechanistic confirmation, not just an aggregate score going up.
[G] There's also a human evaluation, three graduate annotators, thirty side-by-side comparisons against o3-mini. Annotators preferred R-F-T's questions sixty two percent of the time, with an eighteen percent tie rate and twenty percent losses. For the resulting outlines, it's fifty percent wins, twenty eight percent ties, twenty two percent losses.
[S] Hang on, the abstract headlines forty two percent and twenty eight percent. Those numbers don't match what you just said.
[G] Good catch, and worth being precise about. The abstract is reporting net margin, wins minus losses. Sixty two minus twenty is forty two, fifty minus twenty two is twenty eight. The raw head-to-head win rate against o3-mini is sixty two percent on questions, not forty two. Both framings are honest, but they mean different things, and it's easy to read the abstract and think you're looking at a win rate.
[O] Alright, let's make the case for why this matters. My honest read: this is one of the more concrete demonstrations I've seen that you can reward-shape your way around "we can't define a good question," instead of throwing up your hands and defaulting to imitation.
[S] I'll grant the mechanism is clever, but I want to push on how closed this loop is.
[O] Go ahead, land the punch.
[S] Every component here is a language model. The user oracle is an LLM. The reward labeler deciding whether a question hit a hidden field is the exact same oracle. The final judge scoring the checklist is another LLM. Three roles played by models never trained to be adversarial, noisy, or wrong, the way real users actually are.
[G] That's a fair characterization, and the paper doesn't really contest it, it's simply the setup they chose. The oracle answers faithfully and completely from the hidden ground truth every time. A real user forgets things, contradicts themselves, or just doesn't know the answer.
[O] Sure, but isn't that true of basically every simulated-user R-L setup? You have to start somewhere before you throw it at real humans, and they did also run an actual human evaluation as a check.
[S] The human eval is real, and I'll credit it. But it's still evaluating against the same closed benchmark, judged on the same masked specification the reward was trained on. My second issue is sharper: the reward target and the eval metric measure almost the same thing. You're rewarded for questions that surface the hidden fields, then graded on whether your final answer recovers those same hidden fields.
[G] I'd put it this way. That's not circular in a fatal sense, because recovering the hidden requirements genuinely is the task here. But it does mean point six five should be read narrowly, as how well this model reconstructs this specific masked specification, not as a general "writes better" claim. That's a real scope limit, not a flaw exactly.
[O] Okay, I'll take that point. What about the "seven billion parameter model beats o3-mini" framing, is that fair?
[S] That's my other flag. Every method in this comparison, including o3-mini, has its questions fed to the same fixed GPT-four-oh, which does all the actual writing. So the win is entirely about which model asks better questions, not about which model produces a better essay end to end.
[G] Agreed, and to the authors' credit, that's actually a deliberate and useful isolation, it cleanly separates question quality from writing quality, which is scientifically the right move. The framing problem is just that "small model beats o3-mini" reads, casually, like an end-to-end claim, when it's really a questioner-only claim.
[O] So it's a real result, just narrower than the headline makes it sound.
[S] One more, and it's my favorite, because it's almost philosophical. The reward is fully binary. Touch any hidden sentence, get a point. It doesn't care if you asked about the single most important missing requirement or the least important one, doesn't penalize redundant questions, doesn't reward good ordering. A model could, in principle, learn to ask several cheap, safely-hits-something questions rather than one precise one.
[G] That's a legitimate gap, and it's not something the paper's evidence-sentence analysis rules out. It shows the reward-trained model's questions do concentrate where the hidden content lives, which is reassuring, but concentration isn't the same as efficiency or prioritization.
[O] So where does that leave us, promising or oversold?
[G] My honest read, going a little beyond just restating the paper: this is a genuinely good reward-design idea, cleanly executed on one benchmark, with real evidence that reinforcement learning beats imitation for this specific skill. What it hasn't shown yet is that it survives a noisier user, a second benchmark, or a reward that actually ranks questions instead of just thresholding them.
[S] I can live with that verdict. Clever recipe, proof of concept, generalization still owed.
[O] I'll take clever recipe with real evidence behind it. That's a good place to be for a first paper on a new task.
[S] Before we wrap, is there anything here that matters beyond this one task?
[G] I think, going a step beyond what the paper itself argues, the honest connection is to evaluation practice generally. The evidence-sentence trick, grading an action by whether it provably touches held-out ground truth rather than scoring a long output against a thin reference, is a pattern that shows up anywhere you're stuck with sparse rewards over open-ended text. Agentic evaluation has the exact same problem.
[O] And it's a reminder that a benchmark built entirely from LLM judges, LLM users, and LLM rewards can still produce a real, reproducible, statistically significant effect. The closed loop doesn't automatically mean the finding is fake.
[S] It just means you should read the number for exactly what it measures, and not one inch further. Which, frankly, is good advice for reading almost any benchmark on this show.
[G] If I had to leave you with the paper's own claim, it's this: rewarding a question by whether its answer provably surfaces held-out information turns "ask a good clarifying question" from an unscorable, subjective task into something you can actually train with reinforcement learning.
[O] My one-liner: a small model beating a much bigger baseline, on a task nobody had really cracked, is exactly the kind of result that makes me want to see this tried on a second benchmark fast.
[S] And mine: judge it as "recovers a masked specification," not "writes better," until someone runs this outside a fully LLM-simulated loop. For the figures, the full baseline table, and the eval-rigor critique in detail, head to the write-up on the Litsearch site.
