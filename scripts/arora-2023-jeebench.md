---
slug: arora-2023-jeebench
title: "Have LLMs Advanced Enough? A Challenging Problem Solving Benchmark For Large Language Models"
description: "JEEBench pulls 515 problems from India's IIT JEE-Advanced exam, scores them with the exam's own partial-credit and negative-marking rules, and finds GPT-4's best configuration stuck under 40 percent."
date: 2026-07-27
guest_name: "Philippa"
guest_voice: "bf_isabella"
---
[O] Here is a number I did not expect from a 2023 paper. GPT-4, with chain-of-thought and self-consistency, projected onto a real Indian engineering entrance exam, lands somewhere in the eightieth to ninetieth percentile of the humans who actually sat it.
[S] And here is the same paper's other number. That same configuration scores 38.9 percent overall on the benchmark. Both are true, and I think exactly one of them is the story.
[O] I think they are the same story. The exam is brutal. Under forty percent is a top-twenty-percent human result. That is the entire point of building it.
[S] Or the percentile is doing work the raw score will not do. Let's find out which.
[O] This is Litsearch Audio. Today's paper is "Have LLMs Advanced Enough? A Challenging Problem Solving Benchmark For Large Language Models" — the JEEBench dataset, from Daman Arora, Himanshu Gaurav Singh, and Mausam, at EMNLP 2023.
[S] It is on the docket because it is one of the few benchmark papers of its era that took contamination seriously enough to actually go looking, rather than waving at it in a limitations paragraph.
[O] And because it borrows its whole grading scheme from a real exam instead of inventing one. Philippa, welcome — you have read this one closely.
[G] Glad to be here. And I would flag one thing at the top: this is really four benchmarks crossed with three subjects, and almost every argument about the paper turns on whether you quote the aggregate or the cells.
[S] Start with the gap, then. Why did anyone need a harder science benchmark in the middle of 2023?
[G] Because the authors did not take the saturation claim on faith, they ran their own diagnostic. They sampled fifty questions each from the MATH test set, from the high-school physics, chemistry and mathematics sections of MMLU, and from their own dataset, and evaluated GPT-4 zero-shot on all of them. GPT-4 clears more than 80 percent on the MMLU subsets, roughly 60 percent on MATH, and on their own maths questions it solves close to a mere 20 percent.
[O] Four-to-one on the same model, same prompting. That is a clean argument for headroom.
[G] It is. Though note exactly what it is: fifty questions per bucket, one model, zero-shot. It establishes that a gap exists, not the size of the gap to two decimal places.
[S] What is the source, precisely? I want to know how much of this is harder problems versus a different format.
[G] The problems come from eight editions of the IIT JEE-Advanced, 2016 through 2023 — India's entrance exam for the IITs, with a selection rate the paper puts at approximately five percent. Two papers a year, fifty to sixty questions each, split roughly evenly across physics, chemistry and mathematics.
[O] How do you get from an exam PDF to a text benchmark?
[G] Off-the-shelf tooling to extract the papers into LaTeX, then they discard every problem whose statement depends on a diagram — approximately 40 percent of the raw pool — and manually quality-check what survives. That leaves 515 problems: 236 mathematics, 156 chemistry, 123 physics. Physics and chemistry are smaller precisely because more of their problems were image-based.
[S] So the surviving physics set is already selected for being expressible in text. That is a real distributional edit, not a neutral filter.
[G] It is, and the paper is fairly quiet about it in the dataset section. It does acknowledge in the discussion that physics problems often require spatial reasoning, and that a multimodal GPT-4 would make that easier to evaluate properly.
[O] Tell me about the answer formats, Philippa, because I gather that is where this really departs from GSM8K.
[G] Four formats, all inherited from the exam. Single-correct multiple choice, one of four options — 110 problems. Multi-correct multiple choice, any subset of four options — 186. Integer type, an unbounded non-negative integer — 82. And numeric type, a decimal to two places — 137.
[S] And the scoring?
[G] This is the part I would underline. They do not use plain accuracy. Single-correct and integer questions score one for an exact match and zero otherwise. Numeric scores one if the model's answer is within point zero one of the gold value. Multi-correct is the interesting one: zero if the model selects any incorrect option, and otherwise point two five for each correct option it did select. So a gold answer of A-B-D against a model answer of B-D scores point five.
[O] That is the exam's own rule, not a metric they invented.
[G] Exactly. It is JEE's built-in incentive against blind guessing, imported wholesale. And it is what later makes the human comparison possible at all — you cannot place a model in a percentile band unless you are scoring it the way the humans were scored.
[S] It also means the aggregate blends a partial-credit regime with an exact-match regime in one unweighted average. Hold that thought, I am coming back to it.
[O] Give me the main table.
[G] Random guessing scores 10.5 percent overall — nonzero only because the multiple-choice formats hand out partial credit even to blind guesses. On integer and numeric types random scores zero. The two open-source models tested, Falcon-7B-Instruct and Alpaca-LoRA, land at 9.8 and 8.9 percent overall, which is at or below random.
[S] Seven-billion-parameter models. There were much stronger open weights available in mid-2023 and they did not test them. To their credit the paper says so outright — evaluation on larger open-source models is left for future work. So "open-source performs as good as random" is a claim about the checkpoints they picked.
[G] Fair, and I would not defend that row either. The proprietary line is more informative. GPT-3, meaning text-davinci-003, scores 12.2 percent. PaLM-2, the text-bison snapshot, 15.3. GPT-3.5-turbo, 17.7. And vanilla zero-shot GPT-4, the March 2023 snapshot, 30.9 percent overall.
[O] Monotone up the GPT family, and GPT-4 roughly doubles GPT-3.5.
[G] It does. One small note for anyone reading closely: the prose says GPT-4 beats GPT-3.5 by a large margin of 12.9 points, while the table gives 17.7 against 30.9, which is about 13.2. Same story for chain-of-thought, where the text says 4.2 points and the table gives 4.1. That is rounding in the write-up, not a result that changes. Quote the table.
[S] Noted, and I appreciate you not inflating that into an error. What about the subject split?
[G] That is where the aggregate hides the most. Going from GPT-3.5 to vanilla GPT-4, chemistry moves 22.8 to 42.3, physics 17.3 to 35.2, and mathematics only 14.6 to 21.2. That is the paper's own ordering — biggest gain in chemistry, then physics, then maths — and their explanation is that the reasoning chains are longest in mathematics and shortest in chemistry.
[O] So the "GPT-4 doubles GPT-3.5" headline is disproportionately chemistry.
[G] Largely, yes.
[S] Now the prompting ladder. Does chain-of-thought help?
[G] Zero-shot chain-of-thought, just appending "let's think step by step", takes GPT-4's total from 30.9 to 35.0 percent. Self-consistency with eight samples at non-zero temperature, layered on top of chain-of-thought, takes it to 38.9 — the best number anywhere in the paper. And that last gain is concentrated: single-correct multiple choice jumps from 47.3 to 61.8 percent.
[O] Fourteen points on single-correct from majority voting alone. That is a lot.
[G] It is, and it is also the format where majority voting is most natural — one answer, four options, take the vote. On multi-correct it goes the other way: 44.8 with chain-of-thought down to 41.0 with self-consistency, because there they treat the four options as independent and include an option only if it appears in at least half the samples.
[S] So the best row in the table is best partly because of how the aggregate weights formats.
[G] That is a legitimate reading. Numeric type also improves under self-consistency, 17.5 to 23.4, so it is not purely a multiple-choice artifact. But yes, the single-correct column is the engine.
[O] What about few-shot prompting?
[G] One-shot chain-of-thought, with one worked example per question-type and subject pair drawn from the 2014 exam, scores 29.2 percent overall. That is well below zero-shot chain-of-thought at 35.0, and it is also below vanilla GPT-4 at 30.9. It regresses.
[S] Few-shot making things actively worse deserves a beat.
[G] The authors' hypothesis is that conceptual errors are hard to repair with worked examples, and that a fixed set of examples narrows the range of reasoning paths the model is willing to try. They point out the same pattern was reported concurrently on SciBench.
[O] And self-critique?
[G] Also down. GPT-4 with chain-of-thought plus self-critique — a second GPT-4 instance shown the problem and the first model's solution, told to find and fix errors — scores 33.9 percent, against 35.0 for chain-of-thought alone. So two of the variants in that table regress, not one: one-shot chain-of-thought and self-critique.
[S] And self-critique regresses even though it improves some columns, doesn't it.
[G] That is the interesting part. On the subject side, chemistry goes up, 46.8 to 48.7, while mathematics drops, 28.0 to 23.4. On the format side, integer goes up, 25.6 to 28.0, numeric goes up, 17.5 to 21.9, multi-correct is essentially flat, and single-correct collapses from 47.3 to 35.5. That one column is almost the entire aggregate drop.
[O] So the verifier is talking itself out of right answers on the format where it was strongest. Do they look at why?
[G] They do, manually, on a random subset of one hundred problems, where GPT-4 with chain-of-thought scored 27.25. Eighty of those solutions contained an error. On those eighty, the verifier found no error at all in 46 — that is the 57.5 percent the paper quotes. It found an error but failed to fix it in 25. It converted a correct part of the solution into an error in 7. And it successfully found and fixed an error in exactly 2.
[S] Two out of eighty. That is not a weak verifier, that is not a verifier.
[G] And on the twenty solutions that had no error to begin with, it introduced a spurious error in one and left nineteen alone. So the ledger is two genuine repairs against eight new breakages.
[O] I will concede that one immediately. Self-refinement was extremely fashionable in 2023 and this is a hard counterexample.
[S] It is the result I would carry out of the paper, honestly.
[G] The paper is careful to frame it as domain-dependent rather than universal — it explicitly asks which class of problems self-critique is and is not helpful for, and points toward learned verifiers as the alternative.
[O] What is the failure mode underneath it? The same hundred-problem pass has an error taxonomy, doesn't it?
[G] It does. Thirty-four conceptual errors, where the model cannot retrieve the right domain concept. Thirty computation errors, algebra and arithmetic. Fifteen grounding errors, where the concept is right but it is turned into the wrong equation. One case of simply misreading the problem. And twenty solutions they call perfect. Plus a caveat they state plainly: a question can contain several kinds of error, and they only record the first one noticed.
[S] Which undercounts multi-error solutions. There is no inter-annotator agreement reported, it is a hundred problems, and I believe it is the same hundred used for the verifier analysis.
[G] It is the same subset, and they say so.
[O] There is a lovely diagnostic buried in there, though — the correct-answer-wrong-reasoning count.
[G] Of the hundred problems, 27 had a correct final answer, but only 20 of those also had correct reasoning. Seven out of twenty-seven. The paper rounds that to 28 percent of correct answers being correct for the wrong reasons.
[S] Any tool use in the paper?
[G] One ablation, and it is a cautionary tale. Function calling was only available on the June 2023 GPT-4 snapshot, whereas everything else in the paper uses the March one. On the June snapshot, zero-shot chain-of-thought scores 30.3 percent — already weaker than 35.0 on March, before any tool is involved. Then they give it a four-function arithmetic calculator, deliberately matching what the exam itself permits candidates to use, and it drops further to 27.4.
[O] A calculator makes it worse. That is genuinely surprising.
[G] Their read is twofold. The model sometimes hallucinates invalid function names or invalid arguments. And GPT-4 is already fairly accurate at small-digit arithmetic — the computation errors are mostly symbolic manipulation, which a black-box calculator does not touch at all.
[S] The snapshot confound makes that nearly uninterpretable as a tool-use result, though. Two things changed at once.
[G] Agreed. The within-snapshot comparison, 30.3 down to 27.4 on the June model, is the clean one, and it is still a drop.
[O] Let's do contamination, because this is one benchmark where I actually worry about it rather than reciting the concern. JEE-Advanced is a public exam with an enormous coaching industry publishing solutions online.
[S] Right. This is not the hypothetical version of the argument. The answer keys are published, full solutions are monetized content on a dozen sites, and the model was trained on the web.
[G] The paper agrees with you and goes looking, in an appendix, along three axes. First, they search the C4 corpus using fifty randomly sampled physics and chemistry questions, and find no documents containing sufficiently long substrings from those questions. They exclude mathematics from that particular search on the grounds that the questions are more LaTeX-heavy, so exact matches would be harder to find.
[S] Which is a reasonable methodological excuse and also removes the largest subject from the search.
[G] It does. Second axis: they search the 2023 Common Crawl URL index for several popular sites that publish consolidated full-length JEE solutions. They find pages containing the solution to 30 of the 515 questions — 19 chemistry, 11 mathematics, no physics matches reported. That is under six percent of the dataset.
[O] And what happens if you drop those thirty?
[G] GPT-4 with chain-of-thought goes from 35.0 to 34.7 percent. Also worth knowing: the average score on those thirty flagged questions is 39.2 percent, which is above the overall average — though the paper itself notes that could simply be the chemistry skew, since chemistry is the subject GPT-4 is best at.
[S] That is an honest caveat and I will give them credit for volunteering it.
[G] Third axis: they prompt GPT-4 with a prefix of a question and ask it to complete the rest, giving the exam year as context, and check whether it can generate what they call precarious data — numbers or option text that could not be predicted from context. Same fifty questions. They found no such completions.
[O] But the strongest evidence is none of those three, is it.
[G] No. It is structural, and it sits in the main body rather than the appendix. The 2023 exam was released on the fourth of June 2023, which postdates every tested model's training cutoff. GPT-4 with chain-of-thought and self-consistency scores 33.8 percent on the 2023 questions, against 39.6 percent on the rest of the dataset.
[S] Lower on the guaranteed-clean slice. That is the right direction for their argument, and it is the kind of evidence a substring search cannot give you.
[G] It is. And to their credit the paper offers a competing explanation that cuts the other way — it says some sittings, 2017 for instance, are simply easier, and GPT-4 does much better on those, which inflates the aggregate.
[O] So the clean slice being harder might be about year-to-year difficulty rather than leakage everywhere else.
[G] Correct. And the honest summary is that the 2023 slice is 65 textual questions. That is a small sample to hang a contamination verdict on.
[S] Let me be precise about what I am conceding. The search evidence is partial — fifty questions, mathematics excluded, a hand-picked list of solution sites, one Common Crawl index. But the temporal argument is the good one and it points the right way. And the paper makes the correct technical point that a URL appearing in Common Crawl does not imply it was trained on, since pretraining does not usually complete even one epoch over the corpus.
[G] They also propose the right remedy, which almost nobody follows through on: add forty to fifty fresh, uncontaminated problems every year from the new sitting. A rolling benchmark rather than a fixed 515-problem snapshot.
[O] Which is precisely what GSM8K and MATH did not do, and we all watched how those aged.
[S] Now the scoring angle, which I think is the second genuinely novel thing here.
[G] JEE-Advanced has negative marking. Single-correct multiple choice is plus three for a correct answer, minus one for a wrong one, zero if you skip. Multi-correct is plus four for a fully correct answer, minus two if you include any wrong option, and plus one per correct option on a partial answer. So the exam tests risk assessment as much as it tests physics.
[O] And they ask whether GPT-4 can play that game if you simply tell it the rules.
[G] They do. They prompt GPT-4 with chain-of-thought, hand it the exact marking scheme for each multiple-choice type, and instruct it to answer or skip. Its total across all multiple-choice questions falls from 308 marks to 198, out of a possible 1074.
[S] That is a large drop. Do we know whether it skipped too much, or answered worse?
[G] Both, and this is the detail I like most. Its positive score went down, 489 to 404, and its negative score went up, 181 to 206. So being told about the penalty made it answer fewer questions correctly and incur more penalties. It is not trading accuracy for caution. It is just worse.
[O] Prompting alone does not buy you calibration. I will take that on the chin.
[G] The paper connects it to the planning literature — it cites the finding that these models plan poorly. Their fix is post-hoc rather than prompted. They take the self-consistency samples, convert each option's relative frequency across those samples into a confidence score, and include an option in the final answer only if its confidence clears a tuned threshold.
[S] Is the model calibrated well enough for that to mean anything?
[G] Reasonably. Maximum calibration error is point one three six, average calibration error point zero nine eight. Slightly overconfident at high confidence, slightly underconfident at low and medium confidence.
[O] And how do they set the thresholds?
[G] Tuned on 2016 through 2021 as a validation set, then evaluated on 2022 and 2023 as the held-out test set. The optimal threshold for single-correct is point one two five, and for multi-correct point seven five. The single-correct value being below point two five just means plain majority voting is already the right policy there. The multi-correct value is the interesting one — self-consistency's default of point five is clearly too permissive when including a wrong option costs you two marks.
[S] And the payoff?
[G] On the test set, chain-of-thought alone scores 66 marks, chain-of-thought plus self-consistency 69, and adding thresholding 72. You can see the mechanism in the split — thresholding takes the positive score down a little, 118 to 111, but the negative score down more, 49 to 39. Sixty-nine to seventy-two is what the paper reports as roughly a four point three percent increase.
[O] So a modest gain in absolute terms.
[G] Three marks. It is real, it is in the right direction, and I would not oversell it.
[S] Then the percentile claim. Walk me through the arithmetic, because that is the number people will quote.
[G] They use the 2023 paper, the uncontaminated one. It had 102 questions, of which 65 were textual — the other 37 contained images. The full exam is worth 360 marks; the textual subset is worth 229. GPT-4 with chain-of-thought, self-consistency and confidence thresholding on the multiple-choice questions, plus plain self-consistency on integer and numeric, scores 49 out of those 229.
[O] And then you scale it up.
[G] You scale up, under an assumption they state clearly and cannot verify: that the 37 image-based questions are on average no easier and no harder than the 65 textual ones. Under that assumption, 49 out of 229 projects to 77 out of 360.
[S] And the human bands come from the real results?
[G] They do. For the 2023 sitting, the top-ten-percent cutoff is approximately 97 out of 360, and the top-twenty-percent cutoff approximately 70. So 77 sits above the top-twenty line and below the top-ten line, which is the paper's eightieth-to-ninetieth-percentile claim.
[O] And I want to be exact about their chart, because it is easy to misread. Both self-consistency configurations — with thresholding and without — clear the top-twenty-percent line. Thresholding is the higher of the two, but plain self-consistency is already above the line.
[G] That is right. Everything below those two in that plot — chain-of-thought alone, vanilla GPT-4, GPT-3.5, and down through PaLM-2 and the open models — sits under the top-twenty line.
[S] My objection to the percentile is not the arithmetic, it is the exam conditions. The paper concedes it in the limitations: humans sit this under severe time pressure. GPT-4 had no clock, temperature zero, eight samples per question, and a threshold tuned on six years of past papers.
[G] They do concede it. And I would add that the projection rests on one exam, 65 questions, and one unverifiable assumption about the image-based third of the paper.
[O] Let me make my case properly. The 2023 slice is guaranteed clean, and GPT-4 with chain-of-thought and self-consistency still scores 33.8 percent on it. On an exam with a five percent selection rate, scored by that exam's own rules, that projects to beating roughly four out of five human candidates. In 2023 that was a striking result, and every reasoning-model wave since has pushed further into exactly this regime.
[S] My case is that the aggregate is close to uninterpretable. The total column is a straight unweighted average across four formats with wildly different scoring regimes — a multi-correct question hands out partial credit to a lucky guess, a numeric question gives you nothing. Within a single model-and-method cell you have 61.8 percent on single-correct and 23.4 on numeric. A forty-point spread. Calling that "38.9 percent" tells you almost nothing about what the model can do.
[G] I score that one largely to the skeptic. The paper's own subject and format columns are far more informative than its total, and the self-critique row is the proof — the aggregate moves for a reason that lives almost entirely in one column.
[O] Then let me pick a narrower hill. Not the aggregate, the direction. From GPT-3.5 to vanilla GPT-4: chemistry 22.8 to 42.3, physics 17.3 to 35.2, and even mathematics, the worst case, 14.6 to 21.2. Every subject, every format, one model generation.
[G] That I score to the optimist. Monotone improvement across the entire GPT family, on a benchmark constructed specifically to be out of reach, is a real signal, and it does not depend on the aggregate at all.
[S] Then give me the third. Open-source performing at random. That is a headline claim in this paper and I do not think it survives.
[G] Nor do I. Two seven-billion-parameter models against four proprietary frontier systems is not a comparison, and the paper itself defers larger open models to future work. Score that to the skeptic.
[O] Conceded. What about self-critique — does that negative result generalize?
[G] The paper is careful there and so will I be. What it shows is that on this benchmark, with this prompt, a GPT-4 verifier misses the error 57.5 percent of the time an error exists. It asks, rather than answers, which classes of problem self-critique helps on. Going beyond the paper, my read is that the failure is downstream of the error taxonomy — thirty-four of those errors are conceptual, and a verifier that could not retrieve the right concept the first time is unlikely to retrieve it on the second pass.
[S] What does all this change for evaluation practice?
[G] Three things. First, the borrowed rubric. Because they used the exam's actual marking scheme rather than plain accuracy, they could place the model in a human percentile band at all. Most benchmarks claiming a human comparison have to invent the comparison.
[O] Second, I would say the contamination playbook. Corpus substring search, URL-index search, a prefix-completion memorization probe, and a temporally clean holdout slice. Four angles, each reported with its limits.
[G] And third, the rolling-benchmark proposal — add one fresh sitting's worth of problems every year. It is the only structural answer to both saturation and leakage, and it is the piece that almost never gets executed.
[S] Which is a fair note to end on, given that JEEBench itself is still a fixed 515-problem snapshot spanning 2016 to 2023.
[G] My one-sentence takeaway is the paper's own: a benchmark built from a real high-stakes exam, scored by that exam's partial-credit and negative-marking rules, put GPT-4's best configuration at 38.9 percent overall in 2023, with concept retrieval and algebraic manipulation as the dominant failure modes and self-critique actively unhelpful.
[O] Mine is that the human-percentile framing is the durable contribution. Grounded scoring is what turns a benchmark number into something you can actually reason about outside the field.
[S] And mine is: read the subject-by-format table, never the total column. The aggregate here blends four scoring regimes across three subjects, and every interesting thing in this paper lives in the cells.
[O] The full writeup, with the figures, the tables and the references, is on the litsearch site. Thanks, Philippa.
