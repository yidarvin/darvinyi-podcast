---
slug: liu-2023-lost-in-the-middle
title: "Lost in the Middle: How Language Models Use Long Contexts"
description: "A controlled experiment shows language models reading a long prompt like a U, strong at the edges, weak in the middle, sometimes worse than reading nothing at all."
date: 2026-07-19
guest_name: "Julian"
guest_voice: "bm_lewis"
---
[O] Picture this. you drop the exact fact your model needs into position ten of a twenty document prompt, and the model does worse than if you had shown it nothing at all.
[S] That is the headline, and it is the part that should scare anyone building a retrieval pipeline right now, not two years from now.
[O] I know, I know, you are going to spend the whole episode telling me the models involved are ancient history.
[S] They are. But the U-shaped curve they found is not ancient history, it just got quieter.
[O] Welcome to Litsearch Audio, where we take one paper off the map at litsearch dot darvinyi dot com and actually argue about it.
[S] Today's paper is Lost in the Middle, How Language Models Use Long Contexts, by Nelson Liu and colleagues at Stanford, Berkeley, and Samaya AI, published in TACL in 2023.
[O] And joining us to walk through it is Julian, a researcher who has spent a lot of time with this paper's experimental design. Julian, welcome.
[G] Thanks for having me. This is one of those papers that is short, almost embarrassingly simple in its method, and yet it reset how an entire field thinks about what a long context window actually buys you.
[S] Let us set the scene. by mid twenty twenty three, context windows were the marketing number of the moment, four thousand tokens, sixteen thousand, Anthropic had just pushed Claude to one hundred thousand.
[O] And the implicit promise was, feed the model your whole legal brief, your whole codebase, fifty retrieved passages, and it will use all of it.
[G] Right, and almost nobody had actually tested that promise directly. The standard way people evaluated long context models was perplexity on a big web corpus, essentially asking, does the model predict the next token well when given a lot of prior text.
[S] Which rewards smooth prediction over mostly redundant nearby text. It tells you almost nothing about whether the model can reach into position fifty of a hundred and pull out one specific fact.
[G] Exactly, and that gap matters because the dominant way models actually touch long text in production is retrieval augmented generation. a search system dumps the top k documents into the prompt and the model is supposed to find the answer somewhere in there.
[O] So if retrieval recall, getting the right document in there somewhere, does not predict task success, then the whole just-retrieve-more-documents instinct could be quietly making things worse.
[G] That is precisely the authors' framing, and it gives them a clean falsifiable test. if a model genuinely uses its whole context, moving the relevant information around inside the prompt should not change the answer. performance should be roughly invariant to position.
[S] So instead of inventing a new leaderboard, they hold the task fixed and vary exactly two things, where the answer sits, and how long the context is.
[G] Any sensitivity to position becomes direct evidence the model is not reading robustly, and that framing is what makes the paper reproducible and durable, even after the specific models age out.
[O] Walk us through the two tasks, Julian, because I think people who have only seen the U-shaped chart do not always know how clean the design underneath it is.
[G] The first is multi-document question answering. the model gets a question plus k Wikipedia passages, and exactly one of those passages contains the answer, the rest are distractors.
[G] The questions come from NaturalQuestions-Open, real historical Google queries with human annotated answers, and they use roughly twenty six hundred of them where the annotated answer is a full paragraph.
[S] And the distractors are not random noise, which is the important part.
[G] Correct, they are the most relevant non-answer passages returned by Contriever, a retrieval model fine tuned on MS-MARCO. so every distractor looks on topic, which mimics a real retrieval augmented generation prompt where everything in front of the model looks plausible.
[G] To probe position, they slide the answer-bearing document to the first slot, the middle, or the last slot. to probe length, they run ten, twenty, or thirty total documents, so somewhere between two and six thousand tokens.
[O] And accuracy is just, does any correct answer string show up in the output.
[G] Right, a lenient string match, following prior work on this dataset.
[S] What is the second task doing that the first one does not already cover?
[G] Stripping away every excuse. the second task is synthetic key value retrieval. the model gets a JSON object of key value pairs, every key and value a random unique string, and has to return the value for one specified key.
[G] No reasoning, no paraphrase, no semantics at all, just exact match lookup. they run seventy five, one hundred forty, and three hundred pairs, so up to about sixteen thousand tokens, with the target key sliding across every position.
[O] That is about as generous a test as you could design. if a model cannot do that, it definitely cannot do anything harder.
[G] Which is the point, it is a floor, not a ceiling. and the model roster spans the frontier of the moment, MPT-30B-Instruct with an eight thousand token window using ALiBi position encoding, LongChat-13B stretched to sixteen thousand tokens from a LLaMA-13B base, GPT-3.5-Turbo and its sixteen thousand token sibling, and Claude-1.3 at both eight thousand and one hundred thousand tokens.
[S] All decoded greedily, all with a standard prompt.
[G] Yes, and they anchor everything against two reference points, a closed-book setting with no documents at all, pure parametric memory, and an oracle setting with only the single answer document. a model reading well should track near oracle no matter where the answer sits.
[S] So let us get to the number that actually made this paper famous.
[G] For GPT-3.5-Turbo on the twenty document setting, accuracy at the very first position is seventy five point eight percent. move the answer into the middle positions and it falls into the low-to-mid fifties. move it to the very last position and it climbs back up to about sixty three percent.
[O] That is a U, not a slope, primacy and recency both win, the middle loses.
[G] And the gap between best and worst position is more than twenty points, which the authors are explicit about. the closed-book score for that model, meaning zero documents at all, is fifty six point one percent.
[S] Say that part again, because it is the sentence that should stop anyone mid-sip of coffee.
[G] In the twenty and thirty document settings, mid-context accuracy drops below fifty six point one percent. the model does worse with the correct document sitting somewhere in the prompt than with no documents whatsoever.
[O] Meanwhile the oracle score, just the one right document and nothing else, is eighty eight point three percent. so there is enormous headroom being left on the table purely because of where the answer happens to sit.
[S] And the obvious next question, does a bigger context window fix this.
[G] No. When a prompt fits inside both a base model and its extended-context sibling, their curves are nearly superimposed. GPT-3.5-Turbo and its sixteen thousand token version trace almost the same U. Claude-1.3 and its hundred thousand token version do too.
[O] So buying a longer maximum length did not buy better use of the length you already had.
[G] The window grew, the reading habit did not change at all.
[S] What about the key value task, the one with zero semantics.
[G] Claude-1.3 and its hundred thousand token variant solve it almost perfectly at every length, which proves the task itself is doable. But GPT-3.5-Turbo, its sixteen thousand token sibling, and MPT-30B-Instruct all sag once you reach one hundred forty or three hundred pairs. without query-aware contextualization, the sixteen thousand token GPT-3.5 variant's worst-case accuracy drops to forty five point six percent on pure exact-match lookup.
[O] That is the line that got me. a model failing to copy a token it can see, purely because of where that token sits.
[G] There is one fix worth naming, query-aware contextualization, meaning you place the question both before and after the data instead of only after it. that alone pushes the key value task to near perfect, GPT-3.5-Turbo's sixteen thousand token version hits one hundred percent even at three hundred pairs.
[S] But it barely touches the multi-document QA curve.
[G] Barely. slightly better at the very start, slightly worse elsewhere. so the fix that rescues pure retrieval does almost nothing for retrieval plus reasoning.
[O] Okay, here is my optimist case, and I want Julian to hold me to the actual text. this paper did not just find a bug, it handed the field a protocol. position invariance became something people actually test for, and the practical fixes it names, rerank so the best document lands near the edges, truncate the ranked list instead of stuffing the window, became close to standard retrieval augmented generation hygiene almost immediately.
[S] Hold on, that is a fairly low bar to call a win. telling people to rerank documents is not a solved problem, it is a workaround for a model limitation nobody has actually fixed.
[O] Sure, but naming the failure mode precisely is most of the battle. before this paper, people were adding more retrieved documents to fix things, which the paper shows can make results worse. that is a real behavior change in how systems get built.
[S] Fine, I will give you that much. Now here is my deflationary case. the model roster is GPT-3.5-Turbo, Claude-1.3, MPT-30B, LongChat-13B, that is a museum piece lineup by today's standards, and GPT-4 only gets tested on a five hundred example subset because a full sweep would have cost upward of six thousand dollars.
[G] That is accurate, and it matters. GPT-4 does show higher absolute accuracy, but it still traces the same U on that subset, so the qualitative finding survives even where the paper's coverage is thinnest.
[S] One more dent. NaturalQuestions-Open is squarely inside these models' pretraining data, which is presumably why the closed-book score is fifty six percent instead of near zero. Doesn't the whole worse-than-no-documents framing lean on a contaminated anchor?
[G] It does complicate that specific comparison, closed-book is inflated by memorization, not by the model conjuring the paragraph fresh. But it does not touch the core position result, because the manipulation there is purely where the same passage sits, memorization is held constant across every position on the curve. the contamination muddies the secondary claim, not the primary one.
[S] And the cleanest, most dramatic collapses, that forty five point six percent number, come from the synthetic key value task, random strings with no semantics. That is the least representative thing here of a real retrieval augmented generation system.
[G] Fair, though I would push back gently. the key value task exists specifically to remove the maybe-the-model-just-cannot-spot-which-document-is-relevant excuse. and there is a companion appendix ablation using random, rather than retrieved, distractors in multi-document QA, and the U-shape survives that too. so it is not purely a synthetic artifact.
[O] Which is exactly why I do not think the skeptic case fully lands. this is not just one weird synthetic result, it replicates across a semantic task and a stripped down one, across six different models, across base and instruction tuned checkpoints.
[S] I will grant the replication. What I will not grant is that the mechanism story is settled. the encoder-decoder comparison, Flan-T5 and Flan-UL2, looks far more robust, only about a one point nine point gap within their training length, but that comparison pits an entirely different model family, scale, and training length against the decoder-only models all at once.
[G] Correct, and the authors call that comparison preliminary themselves, which is the right call. What is cleaner is the instruction tuning result, base MPT-30B is already U-shaped before any fine tuning, tuning only narrows the gap from around ten points to around four, and the Llama-2 scale sweep, where the seven billion parameter model shows only recency bias but the thirteen and seventy billion versions both develop the full U regardless of additional fine tuning.
[O] So the shape is not a training artifact, it shows up in a base model nobody hand-tuned for chat behavior, and it gets stronger with scale.
[S] Which I will concede is the strongest piece of the causal story in the whole paper.
[G] The angle I would flag for anyone doing evaluation work is that position becomes a variable you have to control for, the same way you would control for prompt template or few shot ordering. a benchmark that never varies where the gold evidence sits could be silently rewarding primacy and recency instead of actual comprehension.
[O] And it directly informs how you build a retrieval pipeline, rerank the most relevant hit toward the edges of the prompt, and do not assume adding a fiftieth document is free just because your retriever can find it.
[S] The case study in the paper backs that up concretely, going from twenty to fifty retrieved documents only buys about one and a half percent for GPT-3.5-Turbo and about one percent for Claude-1.3, while retriever recall keeps climbing and so does your latency bill.
[G] There is also a nice connection the authors draw explicitly, this pattern echoes the serial position effect from human memory research, Ebbinghaus in nineteen thirteen, Murdock in nineteen sixty two, people best recall the first and last items of a list too. it is a striking parallel for a mechanism that is, in principle, equally able to attend to any token.
[G] If there is one sentence to take from this paper, it is that a longer context window is not the same claim as reading the context well, and proving the second one requires showing performance stays flat no matter where the relevant information sits.
[O] My takeaway is that this paper is a genuine public service, it turned a vague worry into a testable protocol, and that protocol outlived every model in the study.
[S] Mine is a caution label, the specific numbers are a twenty twenty three snapshot and frontier models have closed a lot of this gap since, so treat the shape of the finding as durable and the magnitude as dated. for the figures, the full model roster, and the writeup's own critique, head over to the piece on the litsearch site.
