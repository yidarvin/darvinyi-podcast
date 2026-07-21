---
slug: shi-2022-mgsm
title: "Language Models are Multilingual Chain-of-Thought Reasoners"
description: "MGSM hand-translates two hundred fifty grade-school math problems into ten languages to ask a question nobody had tested: does step-by-step reasoning survive the jump into a language the model has almost never seen?"
date: 2026-07-20
guest_name: "Sinead"
guest_voice: "bf_emma"
---
[S] Chain-of-thought reasoning was proven in English, tested in English, and celebrated in English. Nobody had checked whether it worked in Swahili.
[O] And when someone finally checked, Swahili survived scaling to five hundred forty billion parameters and barely lost ground.
[S] Barely, on two hundred fifty problems, from a single greedy decode, with no error bars anywhere in the paper.
[O] Barely is also the headline result. Let's see who's right.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the litsearch site. Today's paper is Language Models are Multilingual Chain-of-Thought Reasoners, by Freda Shi, Mirac Suzgun, and colleagues at Google Research, published at ICLR twenty twenty-three.
[S] It's on the docket because it built the benchmark that's still the field's default way to measure multilingual math reasoning, years later, from DeepSeekMath down to whatever multilingual suite ships next.
[O] Joining us is Sinead, who has studied this paper closely. Sinead, welcome.
[G] Thanks for having me. It's a short paper for how much it ended up shaping evaluation practice.
[S] Start with the gap. What didn't exist before this paper?
[G] Two research threads had matured separately but never met. Chain-of-thought prompting, writing out reasoning steps before the final answer, had been shown to unlock multi-step arithmetic and commonsense reasoning, but only in English. Separately, multilingual pretrained models were already doing respectable work across typologically distant languages.
[O] So multilingual models existed, English reasoning existed, but nobody had crossed the streams.
[G] Right, and the reason is what the existing multilingual benchmarks actually tested. Cross-lingual question answering, natural language inference, lexicon induction, these ask for one recognition step, pick an answer, classify a sentence. None of them chain several dependent operations together the way a word problem does.
[S] So the honest answer to "can a model reason step by step in Bengali" was just: nobody had built a way to ask.
[G] Correct. The paper starts there, with a benchmark that didn't exist, before it gets to any result at all.
[O] And the stakes are bigger than one dataset. If reasoning turns out to be an English-only party trick, that's a real ceiling on how useful these models are for anyone who doesn't primarily think in English.
[S] Or if it transfers, that's evidence these models built something closer to a general capability than a memorized English template. Either answer is worth having.
[O] Walk us through what they actually built, Sinead.
[G] MGSM, the Multilingual Grade School Math benchmark. They took the first two hundred fifty problems from GSM8K's official test set, English grade-school word problems that each need two to eight reasoning steps in the official solution, and had them professionally translated into ten typologically diverse languages: German, French, Spanish, Russian, Chinese, Japanese, Thai, Telugu, Bengali, and Swahili.
[S] Machine-translated, or human?
[G] Human, and they go out of their way to prove it. Every translator was a native speaker with at least two years of professional translation experience, and each one signed a declaration not to use machine translation. A separate translator then spot-checked a random subset, and the vendor ran an n-gram overlap check against popular machine translation toolkits to catch anyone who quietly used one anyway.
[O] That's an unusually paranoid amount of verification for a quarter-thousand-problem dataset.
[G] It matters for what comes later, because one of the four prompting formats in this paper deliberately does use machine translation. You want to be able to tell that condition apart from accidental contamination in the other nine language columns.
[S] Say more about those four formats.
[G] DIRECT is the floor, predict the answer with no reasoning shown at all. NATIVE-COT reasons step by step in whatever language the question was asked in. EN-COT keeps the question in its native language but writes the reasoning steps in English. TRANSLATE-EN runs the question through the Google Translate API into English first, then solves it with an English chain of thought.
[O] So NATIVE-COT tells you if the model can actually think in Bengali, and TRANSLATE-EN tells you what you get by just outsourcing the language problem entirely.
[G] Exactly, and EN-COT sits in between: understand the foreign question, but do the internal reasoning in English. Comparing all three tells you where any multilingual ability is actually coming from.
[S] And the answer stayed a plain Arabic numeral, no matter what script the question was written in?
[G] Right, deliberately, so the target output is identical across all eleven languages and scoring never has to reconcile different number systems.
[O] What models did they actually run this on?
[G] Two headline models. GPT-3 in the text-davinci-002 variant, and PaLM at eight billion, sixty-two billion, and five hundred forty billion parameters. Everything runs few-shot, six exemplars where the context budget allows, with greedy decoding, so there's no sampling variance to hide behind.
[S] One more wrinkle before we get to the numbers: exemplars. Did the few-shot examples have to match the question's language?
[G] They tested three choices: native-language exemplars, English exemplars, and a generic multilingual mix. That turns out to matter a lot, and it's worth coming back to after the headline results.
[O] Let's get to it. What happens with no reasoning shown at all?
[G] Both models are weak. GPT-3 averages eleven point seven percent under DIRECT prompting, PaLM-540B averages eighteen point six. Neither model does much multi-step arithmetic unless it's shown how.
[S] And chain of thought changes that.
[G] Substantially, but only past a certain scale. PaLM-540B with NATIVE-COT jumps to a forty-eight point one percent average, and its best setting, TRANSLATE-EN, reaches fifty-five percent. In that best setting it clears forty percent in every single language tested, bottoming out at forty-nine point six percent on Telugu.
[O] And even NATIVE-COT, the harder setting, only dips below forty percent once, at thirty-five point two on Swahili. Everything else clears it.
[S] What about the smaller models?
[G] They barely move. Neither GPT-3 nor PaLM shows a substantial solve rate until it crosses a scale threshold, text-davinci-001 for the GPT-3 family, sixty-two billion parameters for PaLM. Below that line, chain-of-thought prompting adds almost nothing. The authors call multilingual reasoning an emergent ability for exactly that reason, flat, then not.
[O] Now the signature result, the one on the paper's own figure one.
[G] The four underrepresented languages in the set, Swahili, Bengali, Telugu, and Thai, average forty-four point nine percent under NATIVE-COT with PaLM-540B. The six high-resource languages average forty-seven point nine. That's a three-point gap, and Swahili and Bengali each make up under zero point zero one percent of PaLM's pretraining tokens.
[S] Zero point zero one percent. Say that again slowly, because that's a genuinely tiny number.
[G] It is. English alone is seventy-eight percent of the training mix by the paper's own frequency table. Swahili and Bengali sit roughly five orders of magnitude below that, and the model still solves general math word problems in them within a few points of French or Chinese.
[O] That's the whole paper in one sentence: past some threshold of scale, how much of a language the model saw in training stops predicting how well it reasons in that language.
[S] Two more results worth having before we argue about what they mean.
[G] English reasoning beats native reasoning, consistently. EN-COT averages fifty-one point three percent for PaLM-540B, versus forty-eight point one for NATIVE-COT. Writing the intermediate steps in English, even when the question itself is in Telugu, does better than reasoning natively. The paper recommends English chain-of-thought as a default baseline for exactly that reason.
[O] And it generalizes past math.
[G] With just four chain-of-thought examples, PaLM-540B sets a new state of the art on XCOPA, a causal commonsense benchmark, at eighty-nine point nine percent, about fourteen points over the previous best system, which needed thousands of training examples to reach seventy-six. Codex trails PaLM by nine points on the same task.
[S] Was that even across languages, or did it ride on a couple of easy ones?
[G] Notably even, and it goes further than that. PaLM does especially well on XCOPA's own underrepresented languages, Estonian, Haitian Creole, and Swahili, outperforming every other model tested on those three specifically. The authors read that as a hint the model retained real internal knowledge of those languages, beyond what raw frequency counts alone would predict.
[S] Does it generalize to everything, or is that one result cherry-picked?
[G] It's not universal, and the paper says so directly. On XL-WiC, a word-sense judgment task, chain-of-thought gives no real lift over direct prediction for PaLM, sixty-six point seven versus sixty-three point two, direct prediction actually edges it out. The authors attribute that to the task itself, the correct rationale is short and specific to each example rather than a chain of dependent steps, so there's nothing for chain-of-thought to unlock.
[O] One more thing before we argue: you said exemplar choice mattered a lot.
[G] It's a genuinely practical finding. Swap native-language exemplars for a generic multilingual mix and NATIVE-COT collapses, forty-eight percent down to about thirty. But pair that same multilingual mix with EN-COT and you recover almost all of it, roughly forty-nine percent, close to the native-exemplar number. Plain English-only exemplars with EN-COT land far worse, around thirty-five. So if you don't have native examples for a language, a multilingual mix beats an English-only one by a wide margin.
[S] Did simply adding more examples help, separate from which language they were in?
[G] Generally, yes. Testing one, two, four, and six exemplars, PaLM-540B trends upward across nearly every language as you add more, though the improvement isn't perfectly monotonic case by case.
[O] Alright, cases. Mine first. This is evidence that reasoning, once it emerges with scale, is closer to a transferable capability than an English party trick. A model that has seen almost none of a language can still chain arithmetic operations in it. That's the finding that matters for anyone who doesn't primarily think in English, or whose language barely shows up in these training sets at all.
[S] My deflationary case: look at where the best number actually comes from. Fifty-five percent, the number people quote, is TRANSLATE-EN, machine-translate the question into English, then reason in English. That measures Google Translate plus English chain-of-thought, not multilingual reasoning. The genuinely multilingual settings, NATIVE-COT and EN-COT, both sit lower, and the fact that EN-COT beats NATIVE-COT is itself a tell. The model does better work when it gets to think in English about a foreign question. That's not "reasoning is language-independent," that's "English is still the model's native tongue for reasoning, and everything else routes through it."
[G] Both are fair readings of the same table. The paper's own framing actually supports the skeptic's exact point here, recommending EN-COT as the default is really the authors conceding that native-language reasoning isn't the strongest option they found.
[S] Second problem: the flat curve everyone quotes is a three-point gap, forty-four point nine versus forty-seven point nine, on two hundred fifty problems per language, from a single greedy decode. No confidence intervals, no significance test, anywhere in the paper.
[O] Three points on two hundred fifty examples is genuinely within noise range for that kind of split.
[G] It is. "No strong correlation with language frequency" is a defensible read of the data, but it's stated with more confidence than a quarter-thousand-example, single-decode sample actually licenses. The paper never runs the significance test that would settle it either way.
[S] Third: only two model families, both closed, and the flagship result rests entirely on PaLM-540B, which was never released. Nobody outside Google could independently rerun the emergence curve.
[O] That's fair, but it's also just the state of frontier research at the end of twenty twenty-two. Almost nothing at that scale was open then. I'd rather have a documented closed-model result than no result at all.
[G] The paper doesn't hide that limitation, but it doesn't resolve it either. It's worth flagging for anyone treating the exact emergence threshold as settled rather than a snapshot of two specific model families.
[O] What about contamination? The English half of this benchmark is just GSM8K's own public test set.
[G] That cuts in an interesting, asymmetric way. Yes, the English column reuses GSM8K's first two hundred fifty problems, and that test set is public and scrapeable, so it's the most contamination-prone column in the table. But the ten non-English splits are new human translations made specifically for this paper, so they're comparatively fresh. If there's a leakage worry, it sits under the English baseline, not under the cross-lingual transfer claim, which is the more interesting number.
[S] So the column most people would treat as the trusted anchor is actually the shakiest one, and the columns people are more skeptical of are the cleaner ones.
[G] That's a fair way to put it, and it's a wrinkle neither of your cases fully accounts for on its own.
[O] Zoom out. What did this paper actually become, years on?
[G] The default multilingual math benchmark. DeepSeekMath, DeepSeek-V3, and most multilingual reasoning suites since have reused MGSM as their non-English math check, largely because it was small, carefully constructed, and had this striking headline result attached to it.
[S] Which is exactly why the measurement caveats matter more now than they did in twenty twenty-two. A quarter-thousand-problem set with no variance reporting became load-bearing infrastructure for how the field claims multilingual reasoning progress, without anyone going back to add error bars.
[O] Or read the other way: it's a benchmark that survived years of scrutiny and reuse without anyone finding a fatal flaw in it. That's its own kind of evidence.
[G] Both readings sit on the same underlying fact, small, carefully human-translated, and still the field's default, for better and for worse.
[G] If there's one line to take from the paper itself: reasoning ability, once it emerges with scale, largely survives the jump into languages the model has barely seen in training, and English intermediate steps remain the strongest lever regardless of what language the question was asked in.
[O] My takeaway: don't bet against transfer. A capability that generalizes across a training-data cliff this steep should update your priors about what scale actually buys you.
[S] Mine: read the fifty-five percent number for what it is, Google Translate wearing a chain-of-thought costume, and treat the three-point frequency gap as suggestive, not proven. Go read the full writeup on the litsearch site for the figures and the per-language breakdown.
