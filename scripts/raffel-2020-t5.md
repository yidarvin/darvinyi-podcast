---
slug: raffel-2020-t5
title: "Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer"
description: "Google's T5 paper turns NLP into one text-in, text-out problem, runs a rigorous, apples-to-apples sweep of pretraining objectives and architectures, then scales the winning recipe to eleven billion parameters and a trillion tokens to top eighteen of twenty-four benchmarks."
date: 2026-07-19
guest_name: "Thibault"
guest_voice: "am_fenrir"
---
[S] Here's a sentence that should stop you. This paper's biggest finding is that its own headline eleven billion parameter model was not really the finding.
[O] It is the part people remember, though. State of the art on eighteen of twenty-four benchmarks, a model nearly matching human performance on SuperGLUE.
[S] Sure, but the authors themselves say the real contribution is the systematic study underneath it, and I want to know whether that study's conclusions actually survive being scaled up eleven billion parameters later.
[G] They partly checked that themselves, which is rarer than you would think, and the honest answer is mostly, but not entirely.
[O] Welcome to Litsearch Audio. Today's paper is "Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer," from Colin Raffel and colleagues at Google, published in the Journal of Machine Learning Research in twenty twenty. Most people just call the model T5.
[S] It is on the docket because it is one of those rare papers that gets cited both as a landmark model and as a methods paper about how to run a fair comparison in the first place.
[O] Joining us is Thibault, a researcher who has studied this paper closely. Thibault, welcome.
[G] Glad to be here. This is one of the papers I keep coming back to, mostly because of how disciplined the comparisons are.
[O] Set the scene for us. What did NLP transfer learning look like right before this came out?
[G] Crowded, honestly. By late twenty nineteen you had BERT, GPT-2, XLNet, RoBERTa, ALBERT, SpanBERT, all landing within about a year of each other.
[S] And each one changing several things at once, if I remember the landscape right.
[G] That is exactly the problem. A new paper would ship a new pretraining objective, a new architecture tweak, a new corpus, and a new fine-tuning trick, all bundled into one release, then report a single leaderboard number. There was no clean way to know which ingredient actually did the work.
[O] So the T5 authors frame their own goal almost humbly by comparison. They say outright the point is not to propose a new method.
[G] Right, their stated goal is to build a testbed rigorous enough to compare the existing ones. It is a survey paper's ambition wearing an engineering paper's clothes.
[S] Which requires one very specific piece of infrastructure. Some way to swap one variable at a time and read off the effect, across tasks that do not naturally share a format.
[G] That is exactly the gap. Translation is sequence to sequence, classification produces a label, similarity scoring produces a number. You cannot put those on one leaderboard without a shared interface first.
[O] So walk us through the interface. This is the text-to-text idea the model is named for.
[G] The core move is almost stubbornly simple. Every task becomes: feed the model a string, train it to generate a string back. You prepend a short task prefix so the model knows what is being asked.
[S] Give me a concrete example.
[G] "Translate English to German: that is good" goes in, "Das ist gut" comes out. "Cola sentence: the course is jumping well" goes in, and the model generates the words "not acceptable." Summarization gets a "summarize:" prefix and produces the summary as plain text.
[O] The one that surprised me is the regression task, the sentence similarity benchmark, STS-B.
[G] That is the elegant part. Instead of a real-valued output head, the model generates a quantized score as a string, something like "three point eight." It is still cross-entropy over tokens, exactly like everything else.
[S] So there is exactly one loss function in this entire paper.
[G] One loss, teacher-forced cross-entropy on the next token, one decoding procedure, greedy decoding at test time, applied unchanged whether the target is a translated sentence, a class label, or a number. That uniformity is what makes the rest of the paper possible.
[O] Because now every design choice you want to test, objective, architecture, data, can be varied one at a time against a fixed interface.
[G] Exactly, it is a coordinate-descent style sweep. Fix a baseline, change one axis, measure, move to the next axis.
[S] What is the baseline, concretely?
[G] An encoder-decoder Transformer sized so each stack matches a BERT-base configuration, about two hundred twenty million parameters total, pretrained for roughly thirty-four billion tokens. For comparison, BERT used about a hundred thirty-seven billion tokens, RoBERTa used about two point two trillion. This is a deliberately modest budget so the sweep itself stays affordable.
[O] And the unlabeled data all of this trains on is the paper's other headline contribution.
[G] The Colossal Clean Crawled Corpus, C4. They took one month of Common Crawl, April twenty nineteen, and ran it through a heuristic cleaning pipeline. Drop lines that do not end in real punctuation, drop pages under three sentences, strip anything matching a bad-words list, drop pages with stray code syntax like curly braces, deduplicate repeated three-sentence spans, and keep only pages classified as English with high confidence.
[S] That is a lot of hand-written heuristics for something called clean.
[G] It is heuristic, and the authors say so themselves. What it buys them is about seven hundred fifty gigabytes of reasonably natural English text, big enough to pretrain on a trillion tokens later without ever repeating a single example.
[O] And the pretraining objective itself, span corruption, is worth walking through, because it is not quite BERT's masking.
[G] BERT masks individual tokens. T5 drops fifteen percent of tokens, but in contiguous spans, and replaces each whole span with a single sentinel token. The target is only the missing spans, tagged by their sentinels, not the entire reconstructed sentence.
[S] Why does that matter?
[G] Shorter targets, cheaper pretraining. You are not paying to regenerate tokens you already had; you are only generating the parts that were removed.
[O] Then there is the architecture bake-off, encoder-decoder against decoder-only.
[G] They compare the classic encoder-decoder to a decoder-only language model and to a prefix-LM variant, and they are careful about the accounting. An encoder-decoder with matching layers on each side has twice the parameters of a same-depth decoder-only model, but roughly the same compute, because each stack only attends over its own half of the sequence.
[S] So parameters and FLOPs decouple in exactly the direction that matters for this comparison.
[G] Exactly, and that is why the result is interesting rather than trivial.
[O] So what actually won?
[G] Decisively, the encoder-decoder with the denoising objective. Eighty-three point two eight average GLUE, eighty point eight eight on SQuAD, seventy-one point three six on SuperGLUE. The decoder-only language model, at matched parameters, scored seventy-four point seven oh on GLUE and just sixty-one point one four on SQuAD.
[S] That is not a marginal gap, that is a different tier of model.
[G] It is. And a nice side finding: sharing parameters between the encoder and decoder stacks recovered almost all of that performance, eighty-two point eight one GLUE, while cutting the parameter count in half.
[O] What about the objective sweep itself, denoising versus everything else?
[G] Denoising always beat plain language-modeling pretraining, no exceptions across architectures. But among the denoising variants themselves, span corruption, individual-token masking, and a few others, the differences were mostly within noise of each other.
[S] So the objective choice barely matters, as long as it is some flavor of denoising.
[G] That is their conclusion, and the practical recommendation follows from it. Since the variants are interchangeable, pick whichever produces the shortest targets, which is span corruption, purely for efficiency.
[O] And the data question, C4 against more curated corpora?
[G] In-domain data can win on a matched task. Training on Wikipedia text helps a Wikipedia-flavored task. But narrow corpora are small, so pretraining on them means repeating the data many times over, and repetition actively hurts downstream performance, even as training loss looks better.
[S] That is the finding I would want double-checked, because bigger and messier beating smaller and curated is a very convenient conclusion for the team that already built the big messy corpus.
[G] Fair, though it is not just asserted. They run it directly: shrink C4 itself down to a small fixed size, and training loss drops, because the model is memorizing, while downstream scores get worse. That is a controlled version of the same claim, not just an appeal to their own dataset.
[O] One thing I want to give them real credit for is the statistics. They trained the baseline ten times from scratch just to get a variance estimate.
[G] And then assumed that same spread applies to every other single-run experiment in the sweep, which is a real assumption, not a re-measurement for each configuration. Overall GLUE standard deviation came out around point two three five, and they boldface any score within two standard deviations of the best rather than crowning a lone winner. CB, a SuperGLUE task with only fifty-six validation examples, swung by a standard deviation of about three point two on its own score.
[S] So low-resource tasks can make two configurations look meaningfully different when the seed alone explains most of the gap.
[O] Then they take everything they learned and scale it.
[G] Span corruption, the encoder-decoder, C4, pretraining on a multi-task mixture, fine-tuning per task, pushing the model up to eleven billion parameters and about one trillion pretraining tokens, roughly thirty-two times the baseline's token budget.
[S] And the headline result?
[G] State of the art on eighteen of the twenty-four tasks studied, as of October twenty nineteen. GLUE average of ninety point three, up from a previous best of eighty-nine point four. SuperGLUE jumped from a previous best of eighty-four point six to eighty-eight point nine, against a human baseline of eighty-nine point eight.
[O] Practically closing the gap to human performance, on a benchmark that was deliberately built to be hard for exactly this kind of model.
[G] SQuAD tells an even sharper story. Ninety-one point two six exact match, ninety-six point two two F1, beating the prior best by over a point on exact match. On CNN slash Daily Mail summarization, twenty-one point five five ROUGE-two, also a new best, up from twenty point three oh.
[S] What did not work?
[G] Translation. None of the three WMT pairs hit state of the art. English to German landed at thirty-two point one BLEU against a previous best of thirty-three point eight. English to French, forty-three point four against forty-three point eight. English to Romanian was the biggest miss, twenty-eight point one against a previous best of thirty-eight point five.
[O] Okay, let me make the optimist case. This paper proved that one interface, one loss, one decoding procedure can cover translation, classification, and regression without hand-built task heads, and then scaling that same recipe produced near-human scores on a benchmark designed to resist exactly that. Unification plus scale is the real blueprint the field kept building on.
[S] I will take the other side. Scale is doing most of the work here, and the paper's own honest framing admits it. Every one of those systematic-study conclusions, encoder-decoder wins, objectives are interchangeable, was established at BERT-base scale on thirty-four billion tokens, then assumed to hold at eleven billion parameters and a trillion tokens. That is a large extrapolation nobody tested directly.
[G] That is fair, and to the paper's credit, it is partly investigated rather than left as an open question. Late in the paper they compare their baseline trained for the full trillion tokens with none of T5's other changes, which hits eighty-four point eight GLUE, against T5-Base, the same trillion tokens plus every recipe change, which hits eighty-five point nine seven. So the non-scaling insights add something real on top of raw tokens, it is not scale doing all of the work.
[S] Small gap, though. Under a point and a half between just adding tokens and adding tokens plus every insight from the whole systematic study.
[G] It is not nothing, but I will grant your broader point. They did not rerun the architecture or objective ablations themselves at eleven billion parameters, so the recipe surviving to trillion-token pretraining does not prove every individual ablation would replicate at that scale too.
[O] What about contamination? Is C4 actually clean of the things it gets tested on?
[G] The paper does not run a formal overlap analysis between C4 and its test sets. They do mention, almost in passing, that SQuAD was built from Wikipedia text, which is exactly the kind of content sitting inside C4. So some leakage between pretraining and evaluation is plausible, they just never quantify it.
[S] And that matters more than it sounds like, because on SQuAD, T5-eleven-B actually beats the human baseline outright, ninety-one point two six against a human exact match of eighty-two point three oh.
[O] Beating human performance on a reading comprehension benchmark should be a triumphant number.
[S] It should make you suspicious instead. Same story on two of the SuperGLUE reading tasks, MultiRC and ReCoRD, where the paper itself notes the model exceeds human performance by a wide margin and suggests the metrics may be biased toward machine-shaped answers.
[G] The authors say that plainly, it is their own caveat, not something we are reading into the numbers. The flip side supports the same story. On COPA and the Winograd Schema task, where humans hit a clean one hundred percent, T5 falls well short. So it is not that the model became superhuman at language, it is that some of these metrics reward machine answers in ways human baselines do not capture.
[O] Which is exactly the kind of nuance that should make you trust the paper more, not less. They are not hiding the exceptions.
[S] Agreed, credit where due. Last thing, none of this was cheap. This is Cloud TPU pods, over a thousand TPU chips a piece, running dozens of ablations and then an eleven billion parameter model on a trillion tokens. Nobody outside a handful of labs could replicate the full sweep, only the conclusions.
[G] True, and worth saying plainly. This kind of systematic study is only possible with industrial-scale compute. What is generalizable is the recipe and the released model weights, not the reproducibility of the sweep itself.
[O] Zoom out for us. What actually changed in the field because of this paper?
[G] Two things stuck. The text-to-text framing became the default lens for the instruction-following and prompted models that followed, casting everything as one string in, one string out. And C4, or descendants of it, became a standard pretraining corpus well beyond this one paper.
[S] From an evaluation standpoint, the part I would flag for this audience specifically is the statistical discipline. Rerunning the baseline with different seeds, reporting standard deviations, boldfacing within noise instead of crowning a single winner. That is a template a lot of benchmark papers still do not follow.
[G] And the SQuAD-beats-human and MultiRC-beats-human results are a quiet warning that stuck too. Once a model clears a human reference point, the next question has to be whether the metric moved, not the model.
[G] If there is one line I would leave you with, it is the paper's own: text-to-text, denoising, and scale each contributed, and none of them alone explains T5's results.
[O] Mine is that this recipe, cast every task as text, sweep the design space honestly, then scale the winner, is still basically how serious empirical NLP papers get run today.
[S] Mine is to remember the asterisk. The systematic study runs at one scale, the trophies get won at another, and the paper is candid enough to say so itself. For the full write-up and the figures, head to the Litsearch site. Thibault, thank you.
