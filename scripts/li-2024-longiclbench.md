---
slug: li-2024-longiclbench
title: "LongICLBench: Long-context LLMs Struggle with Long In-context Learning"
description: "LongICLBench swaps passkey retrieval for in-context classification over label spaces of 28 to 174 classes, and finds that fifteen long-context LLMs get worse as you give them more demonstrations. On the hardest task the best model in the world scores fourteen percent against a fine-tuned classifier's eighty seven point four."
date: 2026-08-03
guest_name: "Beatrix"
guest_voice: "bf_lily"
---
[O] A model with a ten million token context window scores fourteen percent on a task where a fine-tuned classifier from the BERT era gets eighty seven point four.
[S] And that is the good news in this paper. That is the winner.
[O] Right, that is Gemini one point five Pro, and it is the only model out of fifteen that reaches double digits at all. Everything else is at or near zero.
[S] What I want to sit with is the shape of the curve, not the level. Fourteen percent is Gemini's score at ten thousand tokens. Give it fifty thousand tokens, five times as many demonstrations, and it falls to two point eight. More context makes it worse.
[O] Which is the opposite of what in-context learning is supposed to do, and that is why this paper matters more than the headline number.
[O] Welcome to Litsearch Audio. Today's paper is LongICLBench, subtitled Long-context LLMs Struggle with Long In-context Learning, by Tianle Li, Ge Zhang, Quy Duc Do, Xiang Yue and Wenhu Chen, out of the University of Waterloo, Carnegie Mellon, and the Vector Institute. Published in TMLR in twenty twenty four.
[S] About three hundred and eighty citations as of now, and it is one of the papers that made the phrase "effective context length" a thing people say with a straight face.
[O] And joining us is Beatrix, who knows this benchmark inside out. Beatrix, welcome.
[G] Thank you. And I would start by insisting on the framing, because the paper's contribution is a task design, not a leaderboard. The leaderboard is the evidence. The contribution is an argument about what long-context evaluation had been failing to measure.
[S] Then make the negative case first. What was wrong with how we were testing long context in early twenty twenty four?
[G] The authors identify three families, and argue all three are gameable. One is perplexity over long documents, which most long-context papers reported. Perplexity is a language modelling statistic and a poor proxy for downstream task ability, and nobody really defends it as more than a sanity check. Two is passkey retrieval, or needle in a haystack, where you bury a string in filler and ask the model to recite it. Several models were already scoring above ninety nine percent on that.
[O] Which everyone treated as evidence the window worked.
[G] It is evidence the window is addressable. It is not evidence the window is comprehensible. Locating one inserted string requires the model to find one position. It says nothing about integrating the rest. The third family is long-document question answering and summarization, over corpora like Qasper, and that is the one the authors spend the most energy on, because it looks the most legitimate.
[S] And it is the one I would have defended. What is the objection?
[G] That a model can shortcut it. In long-document QA the answer usually lives in one short passage, so a system that finds that passage and ignores the other forty thousand tokens gets full marks. Summarization has a parallel problem, the strong lead-sentence position bias documented by Nallapati and colleagues back in twenty seventeen, where you score well by leaning on the first few sentences. In both cases high performance is consistent with never having read the document.
[O] So the design goal becomes: construct a task where a correct answer is itself proof that the model read everything.
[G] That is exactly the requirement, and it is a sharp one. Not a task that is hard. A task where success cannot be achieved by local retrieval.
[S] And the answer they land on is extreme-label classification. Walk me through why that satisfies the requirement.
[G] Take a classification dataset with a very large, fine-grained label space, and do in-context learning on it. You put at least one demonstration of every label into the prompt, then ask the model to classify a held-out instance. The key property is that the label space itself is only defined by the prompt. The model cannot know that "per colon date of birth" is one of the available answers unless it has seen that label somewhere in the demonstrations.
[O] So it has to traverse the whole demonstration set just to know what the answer options are.
[G] Just to know the option set exists, yes. And with fine-grained labels it also needs to have seen the contrasting examples to tell neighbouring labels apart. There is no short passage that contains the answer. The answer is a property of the entire prompt.
[S] I will grant that is a genuinely different shape of task from a needle. Give me the datasets.
[G] Six existing classification datasets, chosen to ladder in difficulty. GoEmotions, twenty eight emotion labels from Reddit comments. BANKING77, seventy seven banking intents. DialogRE, thirty six dialogue relation types, drawn from the sitcom Friends. TacRED, forty one relation types. Few-NERD, sixty six fine-grained entity types. And Discovery, one hundred and seventy four discourse-marker classes, which is the monster.
[O] And the length knob?
[G] Rounds. One round is a complete pass through every distinct label with exactly one example each. Two rounds is two examples per label, and so on up to five rounds. So on BANKING77 you go from roughly two thousand tokens at one round to fourteen thousand at five rounds. On Discovery, one round is already ten thousand tokens, because there are a hundred and seventy four classes to get through, and five rounds is fifty thousand.
[S] That is a clean construction. The label cardinality sets the floor on context length, so the difficulty axis and the length axis are the same axis.
[G] They are the same axis, and hold that thought, because it is also the paper's sharpest methodological weakness. We should come back to it.
[O] Noted. What is the model set?
[G] Fifteen. Eleven open-source models around seven billion parameters, chosen to span basically every context-extension trick in circulation at the time. Position interpolation in LLaMA-2-7B-32K. NTK-aware interpolation in Qwen one point five. Shifted short attention in LLaMA-2-7B-LongLora. Dynamic NTK in InternLM2. The Focused Transformer approach in Long-LLaMA-code. Plus two non-Transformer architectures, RWKV-5-World and Mamba, at two point eight billion.
[S] So the open-source set is a survey of the methods, not a survey of the best models.
[G] That is the right reading, and I think it is deliberate. Then four frontier API models: GPT-4-turbo and GPT-4o at a hundred and twenty eight thousand tokens of support, Claude 3 Opus at two hundred thousand, and Gemini one point five Pro at ten million.
[O] And the evaluation protocol?
[G] Five hundred test examples per dataset, sampled to keep the label distribution even, and every model sees the identical demonstration set and the identical test set. Accuracy for GoEmotions, BANKING77 and Discovery. F one for the two relation-extraction sets, TacRED and DialogRE, and for the entity-recognition set, Few-NERD.
[S] Good. Same prompts, same items, no per-model tuning. That part is clean. Now give me the results, and start with the easy end, because I suspect the easy end is where the optimist case lives.
[G] It does. BANKING77, two thousand to fourteen thousand tokens, seventy seven classes. Here in-context learning behaves roughly the way the textbook says it should for a good chunk of the field. LLaMA-2-7B-32K goes from thirty point two percent at one round to seventy seven point two at five rounds.
[O] That is a huge gain. That is the model more than doubling by being shown more examples.
[G] It is. And Gemini one point five Pro goes from twenty eight point eight at one round up to a peak of eighty two point two at three rounds. Six of the fifteen models gain end to end from one round to five, and roughly eight of fifteen peak somewhere above their one-round score by a real margin.
[S] Eight of fifteen. So even on the easiest task, roughly half the field does not benefit from more demonstrations.
[G] And two models fail outright. LLaMA-2-7B-LongLora and Mamba score exactly zero at every round on every one of the four datasets that get main-body tables. Not low. Zero.
[O] What does zero mean here mechanically? They are not producing a valid label at all?
[G] The paper does not do that error analysis, which is one of the things I would want. The number is zero and we are left to infer whether it is format failure, refusal, or genuine confusion. There is a third model, Gemma-7B-base, that is more interesting because it is not uniformly zero. It gets zero on BANKING77 and Discovery, but it manages fourteen point seven F one on DialogRE's shortest round, and nought point four on TacRED's first two rounds before falling to zero.
[S] So Gemma at least demonstrates it can do the task shape, and then loses it as length grows. That is a more informative failure than a flat zero.
[O] Move up the ladder. TacRED and DialogRE.
[G] TacRED runs four thousand to eighteen thousand tokens, DialogRE eight thousand to thirty two thousand. Both are relation extraction, so the model has to track argument pairs across a whole relation label set. Here the API models mostly pull ahead of open source at nearly every round, though the size of the gap varies a lot. At DialogRE one round, Mistral 7B v zero point two base gets twenty four point zero F one against Gemini's twenty nine point six. That is a five point six point gap between a seven billion parameter open model and a frontier system.
[O] That is closer than the marketing would suggest.
[S] And Claude?
[G] Claude 3 Opus is the outlier, and not in a good way. Its decline is steep enough that Mistral outscores it at two of five rounds on TacRED, fifty one point six against thirty five point four at three rounds, and forty eight against forty three point four at four rounds. And at four of five rounds on DialogRE. At five rounds on DialogRE, Mistral has twenty one point one F one and Claude 3 Opus has zero.
[S] A seven billion parameter open base model beating Claude 3 Opus at thirty two thousand tokens, when Opus supports two hundred thousand. That is the number I would put on the slide.
[O] Although I want to be careful. That is one dataset, one length, and a collapse to zero smells like something breaking rather than the model gradually degrading.
[G] That is a fair caution and the paper does not diagnose it. What it does claim, in prose, is that "only GPT-4-turbo and GPT-4o can consistently benefit from more demonstrations", while everything else peaks in the middle, somewhere around thirteen to twenty five thousand tokens, and then declines.
[S] Is that claim true?
[G] Half of it. GPT-4-turbo really is monotonic in both tables. On TacRED it goes seventy four point four, seventy six point five, seventy nine point five, eighty point four, eighty four point two. On DialogRE, forty two point nine, forty seven point eight, fifty two, fifty five point nine, fifty seven point seven. Straight up, every round, both tasks.
[O] So for one model out of fifteen, long in-context learning works exactly as advertised.
[G] For one model, yes. But GPT-4o, the other model named in that sentence, is not monotonic in either table. On TacRED it goes seventy one point one, seventy five point five, seventy three point six, seventy three point two, seventy two point three. It peaks at two rounds and then declines for three straight rounds. On DialogRE it dips at three rounds, rises, then falls again.
[S] So the paper's own sentence is contradicted by the paper's own table, two rows down.
[G] It is, and I do not think it is load-bearing for the conclusion, but it is the kind of thing that should have been caught. Gemini and Claude are also non-monotonic, for what it is worth. Gemini's TacRED F one rises to eighty one point four at two rounds, dips to seventy nine point six at three, then climbs back to eighty two point three by five.
[O] Fine. Discovery. The one everyone quotes.
[G] One hundred and seventy four discourse-marker classes, ten thousand to fifty thousand tokens, scored on accuracy. Every one of the eleven open-source models scores zero, or effectively zero, at every round it could attempt. There are exactly two non-zero cells in that entire open-source block: ChatGLM3 gets one point zero at two rounds, and RWKV gets nought point two at two rounds.
[S] Two non-zero cells out of a fifty-cell grid.
[G] And two of those models, LLaMA-2-7B-32K and ChatGLM3, could not even attempt the longest rounds, because forty and fifty thousand tokens exceed their supported window. Those cells are marked as not attempted rather than scored.
[O] And the API models.
[G] GPT-4-turbo peaks at one point five percent. GPT-4o at two point eight. Claude 3 Opus at one point two. None of the three ever exceeds two point eight at any round. Gemini one point five Pro is the only model in double digits, at fourteen percent, and that is at one round, ten thousand tokens.
[S] Its best score is its first data point.
[G] Its best score is its first data point. Then six point zero, three point two, one point eight, and two point eight as the context grows to fifty thousand. Monotonically worse apart from the last step.
[O] And the reference point is eighty seven point four.
[G] Here I have to flag a discrepancy, because the paper is not consistent with itself about what that number is. Table six lists the row as SoTA, labelled MTL, at eighty seven point four. The introduction separately says a fine-tuned BERT model can achieve eighty seven percent. Those are different systems being described as the same reference point.
[S] Does it change the conclusion?
[G] Not remotely. Whether the comparison is a multi-task-learned system or a fine-tuned BERT, it is roughly six times Gemini's best few-shot number, and it is a small model from years earlier. But a reader trying to reproduce the comparison would be confused about which baseline to reproduce.
[O] Let us do the second experiment, because I think it is the part people forget.
[G] The position analysis. They take TacRED at three rounds, which is a hundred and twenty three demonstrations, forty one labels times three, about ten thousand tokens. In the default setup, demonstrations of the same label are scattered randomly through the prompt. Then they re-order the exact same demonstrations so that same-label instances sit adjacent to each other. Same content, same token count, different arrangement.
[S] And grouping helps, presumably. It is the more organized prompt.
[G] Grouping hurts. Badly, for most models. Mistral goes from fifty one point six F one scattered down to five point one grouped. That is a forty six point five point fall, from a respectable score to nothing, purely from reordering.
[O] That is astonishing and I want to make sure I understand it. Identical demonstrations, identical length, and the model loses ninety percent of its performance because you sorted them.
[G] Identical. And the frontier models are not immune. GPT-4-turbo loses twenty point three points, seventy nine point five down to fifty nine point two. Gemini loses twenty two point three, seventy nine point six down to fifty seven point three. A minority of models actually gain, LLaMA-2-7B-32K and RWKV both pick up two point six points, but they are gaining from near-zero baselines.
[S] What is the mechanism the paper proposes?
[G] It observes a bias toward labels presented later in the sequence. When a label's examples are all clustered in one region, models like InternLM2 and Mistral only reliably handle the labels sitting near the end of the prompt. When the same labels are scattered, every label has at least one instance somewhere recent.
[O] So scattering is accidentally a recency-mitigation strategy. Every label gets a lottery ticket near the end.
[G] That is my read of it, and I want to be clear that is my read going slightly beyond what the paper states. What the paper states is the bias and the drop.
[S] There is a small numerical wrinkle in that table too, isn't there.
[G] There is. For InternLM2 the table prints a delta of minus nine point seven, but its own cells are fifteen point five scattered and four point eight grouped, which is minus ten point seven. Off by exactly one. The litsearch writeup reproduces the printed value with a footnote rather than silently correcting it, which I think is the right call.
[S] Good. Now let me make the deflationary case, and I want to start with the confound, because Beatrix flagged it forty minutes ago and we owe it a proper hearing.
[G] Please.
[S] Adding a round does two things at once. It adds one more demonstration per label, which is more contrastive signal for in-context learning. And it adds tokens, which is more context to process. The paper never separates them. So when Gemini falls from fourteen percent to two point eight on Discovery, I cannot tell whether that is long-context degradation or in-context learning saturating and diluting as the demonstration set grows, independent of length.
[O] Or both, which is my guess.
[S] Or both, and "or both" is not a finding, it is an absence of one. The title of the paper is Long-context LLMs Struggle with Long In-context Learning. The attribution to length specifically is doing real work in that title, and the design cannot support it. You would want a variant that holds token count fixed while varying label coverage, or the reverse.
[G] I think that criticism is correct and I would not try to defend the design against it. What I would say is that the cross-dataset comparison partly rescues it. Discovery at one round is ten thousand tokens and scores near zero. DialogRE at five rounds is thirty two thousand tokens and GPT-4-turbo scores fifty seven point seven. So longer is not uniformly worse across datasets, which means label cardinality is clearly carrying weight independently.
[S] That is a fair point and it cuts against the length story, not for it. If thirty two thousand tokens is fine on DialogRE and ten thousand is fatal on Discovery, then the paper's own evidence says the binding constraint is the label space, not the context length.
[O] I want to take that seriously rather than deflect it. Suppose you are right and this is really a paper about extreme-label classification rather than long context. Does the result get less interesting?
[S] Honestly, no. It gets differently interesting. It becomes evidence that in-context learning does not scale to large output spaces, which is arguably a more actionable finding for anyone building a classifier.
[O] Then let me put the optimist case at its strongest, and it is not the one you might expect. It is not that the models will get better, though I do think they have. It is that this benchmark is unusually hard to cheat. The reason Discovery at fourteen percent is such a legible number is precisely that you cannot explain it away as a retrieval failure. There is no snippet to find. The model either recognized a hundred and seventy four labels or it did not.
[G] I would score that to the optimist, and it is the paper's real contribution. The construct validity here is better than most long-context evaluations because success requires the capability being claimed. That is rarer than it should be.
[S] Then let me press on the thing the paper does not address at all, which is contamination.
[G] It is not discussed anywhere in the paper. And every one of the six datasets is a public release dating from roughly twenty seventeen, for TacRED, to twenty twenty one, for Few-NERD. All of them are near certain to appear somewhere in every evaluated model's pretraining corpus, whether as raw text, as a dataset card, or through papers-with-code-style summaries.
[O] Although here contamination would work against the paper's conclusion, not for it. If the models had memorized Discovery's label space, they would do better, not worse.
[G] That is the right observation and it is why I think the finding survives. The near-uniform collapse is not an obvious case of memorized-label cheating. But the paper never shows that. It offers no canary, no perturbation check, no leakage analysis. The reader has to infer the argument you just made rather than being handed the evidence.
[S] Which is my complaint in one sentence. The conclusion is probably right and the paper does not earn it.
[O] What about the baselines? Those SoTA rows.
[G] Each dataset gets one. BERT at fifty eight point nine on GoEmotions. RoBERTa plus ICDA at ninety four point four on BANKING77. DeepStruct at seventy six point eight on TacRED. HiDialog at seventy seven point one on DialogRE. MTL at eighty seven point four on Discovery. PL-Marker at seventy point nine on Few-NERD.
[S] And no training-set sizes stated.
[G] None. Which matters, because the implicit story is "fine-tuning beats few-shot", and you cannot calibrate that without knowing whether fine-tuning needed a thousand labelled examples or a hundred thousand. On BANKING77 the fine-tuned system had thirteen thousand examples available in the source dataset. The few-shot models get at most five per label.
[O] And it is not even a clean sweep for fine-tuning, is it.
[G] It is not. On five of six datasets the fine-tuned baseline beats every few-shot model. On TacRED it does not. GPT-4-turbo's best few-shot F one is eighty four point two at five rounds, against DeepStruct's seventy six point eight.
[S] Which I find genuinely striking and underplayed. On one of the six tasks, five demonstrations per label beat the fully supervised state of the art.
[O] That is my headline that survives scrutiny, actually. Not "models are bad at long context". Rather: there is a complexity frontier, and it sits somewhere between DialogRE and Discovery. Below it, few-shot is competitive with fine-tuning. Above it, few-shot is at zero. The paper's own hypothesis says exactly that.
[G] It does say that, in those words, and I think it is the most defensible statement in the paper. The frontier is real and it is sharp. What the paper cannot tell you is what the frontier is made of.
[S] What else is missing that you would want?
[G] Three things. There is no prompt-robustness check across the six bespoke templates, so we do not know how much of a model's zero is a formatting artifact. There is no demonstration resampling, so on a five hundred example test set with one demonstration draw per round we have no variance bound at all, and some of the round-to-round wobble may just be noise. And there is no error analysis on Discovery. Label confusion, refusal, and quietly hitting an undocumented practical context limit below the advertised window would look identical in that table, and they have completely different implications.
[O] That last one is the one that would change my behaviour. If Gemini's fall from fourteen to two point eight is a practical limit well below ten million tokens, that is a product claim problem, not a science problem.
[S] And the paper cannot distinguish them, which is exactly why "effective context length" became the phrase people use.
[O] So where does this leave evaluation practice?
[G] I would draw one lesson and one caution. The lesson is that a task whose correct answer requires whole-input integration is a much better long-context probe than one where the answer is locatable, and extreme-label in-context learning is a cheap way to build one out of datasets that already exist. You do not need a new corpus. You need a large label space and a round structure.
[O] And the caution?
[G] That building the difficulty knob out of two variables at once is easy to do and expensive to undo. If you are designing something in this shape, separate label count from token count from the start, because you cannot retrofit that separation onto results you have already collected.
[S] Which is a lesson about benchmark design generally, not about long context.
[O] Takeaways. Beatrix, the paper's.
[G] The paper's is that fine-grained, extreme-label in-context learning is a long-context task that cannot be shortcut, and on its hardest instance every model tested falls off a cliff that a small fine-tuned classifier walks straight past.
[O] Mine is that the frontier is the finding. On TacRED, five demonstrations per label beat the fully supervised state of the art. On Discovery, the same recipe scores essentially nothing. Something sharp happens in between and nobody has named it yet.
[S] And mine is that the paper is right for reasons it did not establish. The collapse is real, the contamination story probably favours it, and the length attribution in its own title is not supported by its own design. Believe the number, not the causal claim attached to it.
[O] The full writeup, with all four results tables, the scattered-versus-grouped figures, and the full critique, is on the litsearch site. Thanks for listening.
