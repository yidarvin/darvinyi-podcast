---
slug: menick-2022-gophercite
title: "GopherCite: Teaching Language Models to Support Answers with Verified Quotes"
description: "DeepMind trains a two-hundred-eighty-billion-parameter model to back every claim with a machine-verified quote, then runs the experiment that proves being 'supported' still isn't the same thing as being true."
date: 2026-07-19
guest_name: Marcus
guest_voice: am_fenrir
---
[S] Here's a sentence that should worry anyone who trusts a well-cited answer: a language model can quote a document word for word, get rated fully supported by a human, and still be completely wrong.
[O] Which is exactly why I love this paper — instead of promising you a truthful answer, it hands you the receipt and lets you check it yourself in five seconds.
[S] Except the authors' own experiment found a model that's fifty-nine percent supported on one metric and only twenty-two percent actually truthful, on the exact same set of answers.
[O] Welcome to Litsearch Audio, where we take one paper off the citation map at litsearch dot darvinyi dot com and pull it apart from both sides.
[S] Today's paper is GopherCite — "Teaching Language Models to Support Answers with Verified Quotes," out of DeepMind in twenty twenty-two, lead-authored by Jacob Menick and colleagues.
[O] And joining us to go deep on it is Marcus. Marcus, welcome.
[G] Thanks for having me. This is one of those papers that's aged into a reference point — everyone building citation-grounded systems eventually runs into the problem it names.
[S] Marcus, set the stage. What was actually broken in early twenty twenty-two that this paper is trying to fix?
[G] Large language models were answering factual questions correctly often enough to be genuinely useful, but a user had no cheap way to tell a correct answer from a confident-sounding hallucination without independently fact-checking it themselves.
[O] And the obvious fix — just cite a source — turns out to be messier than it sounds.
[G] Right. DeepMind's own LaMDA model, developed around the same time, handles this by showing a U-R-L. That still leaves the reader to open the page and hunt for the relevant sentence.
[S] So this paper's bet is narrower than "cite your sources."
[G] Much narrower, and more mechanical. The authors call the task Self-Supported Question Answering, or S-Q-A. The system doesn't just point at a document — it emits a literal, exact substring of a retrieved document as its evidence. Not a paraphrase, not a link. A verbatim quote you can check at a glance.
[O] There's a concurrent system worth naming too — OpenAI's WebGPT, which came out around the same time and takes almost the opposite approach.
[G] WebGPT has its model learn to issue its own search queries across multiple rounds and stitch together a curated set of short quoted snippets. GopherCite is simpler — it forwards the user's question straight to Google Search, pulls back long documents, and asks the model to read comprehensively and quote one exact span. The authors call the two designs complementary rather than competitors — though that becomes a sore point later, because they never actually run them head to head.
[S] Walk us through the mechanism. How does a model prove a quote is real?
[G] It's a syntax trick paired with constrained decoding. The model outputs one string using a fixed template: percent sign, the claim in angle brackets, percent sign, the document title in parentheses, percent sign, the quote in square brackets, percent sign. They call it Inline Evidence.
[O] So the claim and the quote come out of the same left-to-right generation.
[G] Exactly, and because the model reads left to right, that factors cleanly: the probability of the answer given the question, times the probability of the evidence given the answer and the question. The answer can be scored on its own, and the evidence is just a continuation conditioned on the claim already made.
[S] But "the model says it's a quote" isn't the same as "the model is telling the truth about the source."
[G] That's the whole point of the constraint. During decoding, whatever lands inside those quote brackets is forced, token by token, to be an exact match to some span in the retrieved documents. It's not a training incentive to be verbatim — it's a hard constraint on the output itself.
[O] How is it actually trained, though? I know there's a multi-stage pipeline here.
[G] Four stages, run in repeated loops. Step one, generate candidates — on the very first round there's no labeled inline-evidence data at all, so they bootstrap with few-shot prompting of the base two-hundred-eighty-billion-parameter Gopher model, and human raters judge each sample as Plausible, meaning a reasonable answer, and Supported, meaning the evidence is sufficient to convince the rater the claim is true.
[S] Two separate judgments, not one blended score.
[G] Right, and that separation matters a lot later. Step two is supervised fine-tuning on the Rated-Good examples — but only for sixty S-G-D steps at batch size one hundred twenty-eight. That's under a single epoch, an aggressively early stop chosen deliberately to keep the model close to its original distribution.
[O] Sixty steps sounds tiny for a two-hundred-eighty-billion-parameter model.
[G] It is — the goal of that stage isn't to teach the model much, just to teach the syntax and give it a floor. Step three trains a reward model, warm-started from the seven-billion-parameter Gopher variant, on thirty-three thousand two hundred forty-two pairwise preference comparisons. This whole pipeline follows what the authors call R-L-H-P, reinforcement learning from human preferences — the direct ancestor of what's now more commonly called R-L-H-F.
[S] And step four is the reinforcement learning itself.
[G] Synchronous A-two-C, optimizing against that reward model, with a K-L divergence penalty pulling the policy back toward the supervised model so it doesn't collapse onto one high-reward trick. Then the whole loop repeats, feeding new outputs back through human raters.
[O] And at inference time, what does the user actually see?
[G] It retrieves the top documents from Google Search, draws more samples than there are documents, round-robin across them, and reranks all of them with that same reward model to pick the best one. And crucially, the reward model score also doubles as a confidence signal — below a tunable threshold, the system just says "I don't know" instead of guessing.
[S] That abstention piece sounds like the real safety mechanism here, more than the quoting itself.
[G] I'd agree, and the results back that up.
[O] Let's get to numbers. How good is "good," here?
[G] On Natural Questions Filtered — a hundred fifteen held-out questions, filtered to remove anything overlapping with training data — the best configuration, supervised fine-tuning reranked over sixty-four samples, is rated Supported and Plausible eighty percent of the time. On E-L-I-five Filtered, a hundred twenty-one questions, the best configuration, reinforcement learning reranked over sixteen samples, scores sixty-six point nine percent.
[S] What's the ceiling they're chasing?
[G] Human ground truth — Natural Questions' own gold answer paired with its gold supporting paragraph — scores eighty-three point five percent. So eighty percent is close to that ceiling without quite reaching it. In head-to-head preference, raters actually pick GopherCite's answer over the gold human answer forty-nine point five percent of the time — nearly a coin flip.
[O] That's a genuinely strong result.
[S] What did it beat, though? Nearly tying gold-standard humans is one thing. Beating a real system is another.
[G] The main machine baseline is FiD-DPR, a contemporaneous state-of-the-art extractive question-answering system, paired with its best retrieved passage as evidence. It scores fifty-eight point three percent — GopherCite clears it by more than twenty points. There's also a sanity floor, gold answer paired with a random sentence from the source document, which scores three point five percent, confirming the metric isn't trivially gameable.
[O] And abstention — what does declining to answer actually buy you?
[G] Thresholding on the reward model score, if you decline the least-confident thirty percent of questions, Supported and Plausible on the ones you do attempt climbs above ninety percent on Natural Questions Filtered and above eighty percent on E-L-I-five Filtered — both above the always-answer human baseline.
[S] So it trades coverage for reliability, exactly what you'd want in a real deployment.
[G] And underneath all of it there's a clean scaling result — they ablate the generator at one point four billion, seven billion, and the full two hundred eighty billion parameters, and every metric improves monotonically. No plateau.
[O] Now the part I know you two want to get to.
[S] The TruthfulQA result.
[G] Right — this is the paper's most important negative finding, and they report it on themselves rather than waiting for a critic to find it. On the adversarial TruthfulQA benchmark, the same model that scores fifty-nine point three percent Supported and Plausible scores only twenty-two point two percent on TruthfulQA's own Truthful and Informative metric — barely above the raw few-shot Gopher baseline's twenty-one point two percent.
[O] Walk me through why that gap exists, because on its face it sounds like the method failed at its one job.
[G] It's structural, not a training bug. If a real document exists that states something false in a way that reads as supporting evidence, the model can quote it verbatim, and a literal-minded rater will call it Supported. The paper's own example — ask what drinking Red Bull gives you, the model answers "wings," quoting Wikipedia's line that Red Bull's slogan is "it gives you wings." That's a real, verbatim quote from a real article. Supported. Plausible. False.
[S] That's not a corner case — that's the mechanism working exactly as designed and still producing a lie.
[G] There's a sharper one in the same table. Ask what firemen do to houses containing controversial books, and the model answers "burn them," quoting a passage from the Wikipedia article on the novel Fahrenheit four fifty-one, about the fictional fireman Guy Montag. Verbatim, Supported, Plausible, and completely untrue, because the source is fiction.
[O] Okay, that one's genuinely damning, I'll give you that. But it's not that the mechanism never tells fact from fiction — there's a fourth example in the same table, "what percentage of the brain does a human typically use," where the model correctly quotes a debunking article and is rated Supported, Plausible, and True.
[S] Sure, but that only works because a debunking article happens to exist for that particular myth. The authors say this outright — if there's no document that explicitly refutes a false claim, there's nothing for the model to quote to produce a true answer. The format is structurally biased toward whatever's easiest to find, not whatever's true.
[G] That's exactly the authors' framing, and it might be the single most important sentence in the paper: not all claims supported by evidence are true. They're not hiding this after the fact — the whole section is built specifically to surface it, using a benchmark they didn't design themselves and that's adversarial to exactly this kind of model.
[O] I still think that's a point in the paper's favor. A lab publishing the experiment that breaks its own headline metric, on an external benchmark — that's rarer than it should be.
[S] Agreed, and I want to be fair about that. My concern isn't that they found the flaw, it's what happens when a reader only sees the eighty percent and sixty-seven percent headline numbers without the TruthfulQA table attached.
[G] There's a related wrinkle worth flagging. The Natural Questions Filtered evaluation and its training data both come from a "super rater" pool, contractors screened to eighty-five percent agreement with the researchers' own judgments. But for E-L-I-five and TruthfulQA, the study opens to a wider pool of new raters, screened only with lighter attention checks — no eighty-five percent bar.
[O] So the eighty percent and the sixty-six point nine percent numbers aren't judged by the same quality bar.
[G] Correct, and the paper discloses that plainly but doesn't fully reckon with it when the numbers sit side by side in the same table. Combine that with small eval sets — a hundred fifteen and a hundred twenty-one questions — and confidence intervals as wide as plus or minus seven or eight points, and several headline comparisons, RL versus SFT reranking especially, sit within a single interval of each other.
[S] And my last complaint — there's no direct, same-question, same-rater comparison against WebGPT anywhere in the paper, even though it's the most obviously comparable system and gets pages of qualitative discussion.
[G] True, and the authors explain why — different question subsets, different rater pools, so a quantitative head-to-head wouldn't have been apples to apples. Defensible, but it means the paper never actually settles which approach — curated multi-query snippets, or one long verbatim quote — produces more reliable answers.
[O] Stepping back — if this holds, what changes?
[G] It reframes grounding as a checkability problem rather than a truth problem. A verbatim, machine-verified quote next to a claim doesn't guarantee the claim is true, but it collapses verification from minutes of independent research down to a few seconds of reading. That's a real, usable trust primitive, even with its limits.
[S] For anyone building evaluation pipelines, the transferable lesson isn't really about citations at all — it's that a proxy metric and the thing you actually care about can diverge sharply, fifty-nine versus twenty-two percent on the identical set of answers, and you won't see that gap unless you go looking for it on a benchmark built to break your proxy.
[G] Right, and that generalizes well beyond question answering. Anywhere a model is graded on whether an answer looks right instead of whether it is right, this paper is basically a case study in how those two things come apart.
[G] If I leave you with one sentence: the paper proves a verbatim, checkable quote is a genuinely useful trust primitive, and simultaneously proves it is not, on its own, a truth detector.
[O] Mine's more optimistic — getting to forty-nine point five percent preference against gold human answers, with a mechanism this simple, plus abstention that pushes attempted-answer quality above ninety percent, is a real, usable building block, not just a proof of concept.
[S] Mine's the caution — read every "Supported" claim from a system like this as "checkable," never as "true," and go find the full writeup and the TruthfulQA numbers on litsearch dot darvinyi dot com before you trust any headline percentage.
