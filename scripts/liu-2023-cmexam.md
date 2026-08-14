---
slug: liu-2023-cmexam
title: "Benchmarking Large Language Models on CMExam - A Comprehensive Chinese Medical Exam Dataset"
description: "CMExam turns 68,000 real Chinese medical licensing exam questions into a benchmark that grades answers and explanations at once — and its two leaderboards disagree about which model is best."
date: 2026-08-02
guest_name: "Alban"
guest_voice: "bm_daniel"
---
[O] Here is a result I did not expect from a 2023 benchmark paper. GPT-4 wins the multiple-choice task outright, 61.6 percent accuracy, nothing else close. And then on the reasoning task it loses to a hundred-million-parameter BART model.
[S] It loses to every fine-tuned model in the table. Not most of them. All nine that report a reasoning score, on all five reasoning metrics, without a single exception.
[O] Right, and my read is that this is the benchmark working. It found something.
[S] My read is that the benchmark broke, and the authors say so themselves in the limitations section. Those are very different papers.
[G] They are, and the honest answer is that the paper contains evidence for both readings, in an appendix that most people who cite this dataset have never opened.
[O] Welcome to Litsearch Audio. Today we are on CMExam — "Benchmarking Large Language Models on CMExam, A Comprehensive Chinese Medical Exam Dataset." Liu, Zhou, Hua and colleagues, a large collaboration across Alibaba, Hong Kong University of Science and Technology Guangzhou, Harvard, Peking University, Zhejiang, Johns Hopkins, and Yale. NeurIPS 2023, Datasets and Benchmarks track.
[S] And joining us is Alban, who knows this dataset well. Alban, this one is on the docket because it is a rare case of a benchmark whose two grading heads point at different winners, and the paper prints both without resolving it.
[G] Thank you both. And that framing is fair. I would add one thing up front — the reason this paper stayed relevant is not the leaderboard at all. It is the annotation layer sitting underneath the leaderboard, which is a genuinely reusable artifact in a way the model rankings are not.
[O] Then set the stage. What did Chinese medical question answering look like before this?
[G] The paper's own Table 1 splits the field along two axes, language and source type. In Chinese, the consumer-question camp is the crowded one — webMedQA, cMedQA version one and two, ChiMed, Huatuo-26M. These are forum questions answered by doctors. Open-ended, no single objectively correct answer, and as they scale up, quality control gets harder, which the authors flag directly.
[S] So you cannot grade a model on them without a human in the loop.
[G] Not reliably. The other camp is research literature, textbooks, and exams, which the authors treat as inherently more trustworthy because the source has already been through review. And in Chinese, that camp had exactly one prior entry — MLEC-QA, drawn from the same Chinese National Medical Licensing Examination that CMExam draws from.
[O] The same exam. So what is CMExam adding?
[G] Not size, which is where I would push back on the paper slightly. The authors list "Scale" as one of three headline advantages — over sixty thousand high-quality questions. But their own Table 1 marks both MLEC-QA and CMExam with the dagger for datasets above fifty thousand questions. So scale is not the differentiator on their own accounting.
[S] I appreciate you saying that, because that is the kind of claim that gets copied forward uncritically.
[G] The real differentiator is stated more precisely elsewhere in section two. CMExam adds question explanations for reasoning inspection, annotation facets tied to authoritative external references, and question-level competency and difficulty ratings computed from human performance. MLEC-QA offers none of those. It is the bare multiple-choice pool.
[O] So walk me through construction. How do you get from a national exam to a dataset?
[G] They collected 96,161 questions from the internet, then filtered. Anything leaning on non-textual information goes — questions referencing an image or a table, or containing the keywords "graph" and "table." Then deduplication. What survives is 68,119 questions. Of those, 65,950 are single-choice and 2,169 allow multiple correct answers, with a maximum of five options.
[S] And the explanations? A licensing exam does not publish worked solutions.
[G] It does not, and the authors are explicit about that. The CNMLE publishes no official explanations, so they cross-referenced questions against three online exam-preparation platforms to recover them. That gets them coverage on 85.24 percent of questions. The split is a random eight to one to one — 54,497 train, 6,811 dev, 6,811 test.
[O] Random split. Hold that thought, I suspect our skeptic wants it later.
[S] I want it later.
[G] You should. Now the annotation layer, which is the contribution. Five dimensions, and the design choice I find genuinely good is that four of the five are anchored to external citable taxonomies rather than invented for the dataset. Disease group from the World Health Organization's ICD-11. Clinical department from China's Directory of Medical Institution Diagnostic and Therapeutic Categories, published by the National Health Commission — 36 categories. Medical discipline from the Ministry of Education's List of Graduate Education Disciplinary Majors — seven categories.
[O] And the two that are not external?
[G] Competency, which is four categories devised in-house by two of the paper's own medical professionals to describe what skill a question tests. And difficulty, which is five tiers — but notice that difficulty is computed, not judged. It comes from the correctness rate of real human exam-takers whose response data was collected alongside the questions.
[S] That is the part I like most in the whole paper, and I want to say so early since I will be unpleasant later. The difficulty tiers and the human baseline come from the same real response data. That is much stronger than three graduate students rating questions easy or hard.
[O] Say more about the human baseline, because 71.6 percent is doing a lot of work in this paper.
[G] It is a weighted average of human response accuracy, with weights set by the number of respondents per question. So questions answered by more people count for more. That is a defensible construction — it means the number is not swung by a question three people happened to attempt.
[O] Now, the ICD-11 count. I want to ask because the writeup flags it.
[G] Yes, and this one is the paper's inconsistency, not the writeup's. Section two says ICD-11 consists of 27 major disease groups. Table 2, the annotation summary, also says 27 unique values. And critically, the actual GPT-4 annotation prompt reproduced in the appendix says "there are twenty-seven categories" and then lists them. So 27 is the number the pipeline actually ran on.
[S] But?
[G] But the results section says, and I am quoting, "ICD-11 annotations, 26 categories." And the appendix table that enumerates the groups has 28 substantive rows — codes zero-one through twenty-six, plus a functioning-assessment section and an extension-codes row, plus a separate not-applicable row on top of that. Three different numbers in one paper.
[S] Does it change any result?
[G] No. It is a bookkeeping failure, not a measurement failure. But if you are quoting the taxonomy size, quote 27, because that is what section two, Table 2, and the annotation prompt all agree on.
[O] Fine. So how did they actually annotate 6,811 test questions across five dimensions? That is a lot of physician time.
[G] They did not spend that physician time, and this is the "GPT-Assisted Annotation" strategy they promote. GPT-4 does an initial pre-annotation pass, then humans review and correct. And the appendix has a small ablation on prompt design that I think is more useful than it looks.
[S] Go on.
[G] Three findings. One, when they did not supply the ICD-11 category list in the prompt and just asked GPT to respond, a significant portion of the returned categories did not strictly belong to ICD-11 at all. Two, when they batched multiple questions into one call to save cost, expert validation showed the annotation accuracy dropped. Three, without explicit format guidance the output format was inconsistent and parsing costs went up. So the final pipeline is one question per call, full category list in the prompt, strict format instructions.
[O] That second one is a real finding for anyone doing LLM-assisted labeling today. Batching to save money quietly costs you accuracy.
[S] Agreed, and it is under-reported generally. But now the part that worries me. Who are the humans?
[G] Two people. One expert physician from the Second Affiliated Hospital of Zhejiang University School of Medicine, with over two years of clinical experience. And one senior doctoral student from the same institution. Where they disagree, the guideline says a collaborative discussion shall be initiated to reach consensus.
[S] Two annotators, consensus by discussion, and no agreement statistic. I searched for it — there is no kappa anywhere in that paper, not for the GPT-4 pre-annotation pass and not for the human review.
[G] That is correct. No inter-annotator agreement figure is reported for either stage.
[O] And "over two years of clinical experience" is a modest credential to hang a medical taxonomy on.
[G] It is what the paper says, twice, in two different appendix sections. I will not soften it.
[S] Let us get to the numbers, because the headline is genuinely interesting before we start pulling at it.
[G] Answer prediction first. Zero-shot GPT-4 leads at 61.6 percent accuracy and 61.7 weighted F1. Human performance is 71.6 percent. So a ten-point gap. GPT-3.5-turbo trails badly at 46.4 percent — that is a 25-point gap. So between the two model generations, the gap to human closed by about fifteen points.
[O] And that is the trajectory story. In 2023 that looked like a benchmark with maybe two years of headroom.
[G] Then the fine-tuning results, which are the more durable part. ChatGLM-CMExam — six billion parameters, fine-tuned on the CMExam training set with P-tuning version two — reaches 45.3 percent. The paper calls that comparable to GPT-3.5, at roughly three percent of the parameters.
[S] Six billion against a hundred and seventy-five billion. That is the finding that aged best.
[G] And there is a sharper version of it that gets less attention. The encoder-only models. RoBERTa-CMExam, three hundred million parameters, gets 37.1 percent. BERT-CMExam, a hundred million parameters, gets 31.8 percent. Both of them beat LLaMA-CMExam at 18.3 percent and Alpaca-CMExam at 21.1 percent — seven-billion-parameter decoder-only models, fine-tuned on the same data.
[O] A BERT beating a fine-tuned LLaMA by nineteen points on a medical licensing exam.
[S] On a five-way classification task, which is what this is once you strip the framing. That is BERT's home turf. I do not think that is a mystery, but I do think it is a useful embarrassment for 2023's assumption that scale and decoders solve everything.
[G] Worth adding the floor for calibration. Random guessing scores 3.1 percent. And zero-shot LLaMA scores 0.4 percent.
[O] Below random. Substantially below random.
[G] Well below. Vicuna is 5.0 percent, Alpaca 8.5 percent. Those numbers are not measuring medical knowledge. They are measuring whether the model can emit an answer option in the requested format in Chinese. And DoctorGLM could not do it at all — the paper reports no prediction score for it, noting it is unable to return answer options according to the prompt.
[S] Which is a real limitation of the benchmark, not of those models. If your harness cannot extract an answer, you have measured your parser.
[O] Conceded. Now the inversion. Give me the reasoning table.
[G] Explanations are scored with BLEU-one, BLEU-four, and ROUGE-one, two, and L, against the single reference explanation. GPT-4's BLEU-one is zero point one seven. Its BLEU-four is zero point zero six.
[O] Zero point one seven. Not seventeen.
[G] Not seventeen. For comparison, ChatGLM-CMExam tops that column at 31.10. So the gap is not marginal, it is two orders of magnitude.
[S] And I want the precise version of the claim, because this is the sentence that gets repeated. Is it really every fine-tuned model?
[G] Let me be exact. There are eleven models the authors fine-tuned on CMExam. Two of them, BERT-CMExam and RoBERTa-CMExam, are answer-prediction only — they print a dash in all five reasoning columns, because an encoder-only classifier does not generate text. So nine report reasoning scores. And against those nine, both GPT-4 and GPT-3.5 score lower on all five metrics.
[S] Give me the tightest margin, because "all five" is only impressive if some of them are close.
[G] The tightest is ROUGE-one. The weakest of the nine on that metric is PromptCLUE-CMExam at 40.88. GPT-3.5 gets 33.80. So seven points, not a hair. On BLEU-one the weakest of the nine is MedAlpaca-CMExam at 16.35, against GPT-3.5's 3.56. It holds comfortably in every column.
[O] And the top of that reasoning table?
[G] ChatGLM-CMExam sweeps four of five — BLEU-one 31.10, BLEU-four 18.94, ROUGE-two 31.48, ROUGE-L 29.39. LLaMA-CMExam takes ROUGE-one at 45.88 against ChatGLM-CMExam's 43.94.
[S] So here is my problem, stated plainly. The paper's introduction lists as a headline finding that lightweight fine-tuned models "significantly outperform GPT-3.5 and GPT-4 on the reasoning task." That sentence, as written, is not supported by the evidence in that table.
[O] That is a strong charge. Alban, does it land?
[G] Partially, and I want to split it carefully, because the authors are less guilty than that framing suggests. The same introduction, one bullet earlier, says GPT-3.5 and GPT-4 generated reasonable answers on the reasoning task despite low BLEU and ROUGE scores, because they tended to generate short answers with reasonable quality. So they diagnose the artifact themselves, in the introduction, before making the outperformance claim.
[S] They diagnose it and then make the claim anyway.
[G] They do. And the limitations section goes further — quoting directly, BLEU and ROUGE "are insufficient for assessing the reasonableness of the answer." So the paper knows its reasoning metric does not measure reasoning, states it twice, and still ranks models on it.
[O] Then let us test the diagnosis, because if the short-answer explanation is right, it is testable.
[G] It is, and this is the appendix result I think is the most valuable thing in the paper. Appendix A-five. They rerun the GPT models with few-shot and chain-of-thought prompts. GPT-4's BLEU-one goes from zero point one seven to 5.95 with few-shot. BLEU-four from zero point zero six to 2.25. Chain-of-thought pushes BLEU-one further, to 7.29. ROUGE-one, two, and L go to 37.24, 19.23, and 17.24.
[S] And accuracy?
[G] Barely moves. 61.6 percent to 62.0 percent.
[O] That is the control. Same model, same knowledge, thirty-five times the BLEU score, and prediction accuracy flat. The metric was measuring output format the entire time.
[S] That is a good control. I will give you that one — that is the cleanest internal evidence in the paper, and it is buried in an appendix while the main table stands unqualified.
[G] Same pattern on GPT-3.5, incidentally. Few-shot takes BLEU-one from 3.56 to 14.62, BLEU-four from 1.49 to 4.80. So it replicates.
[O] So the inversion is an artifact. Case closed.
[G] Not quite, and this is where I have to correct you rather than the skeptic. It does not fully close. Even GPT-4 with few-shot prompting reaches ROUGE-one of 37.24. The weakest of the nine fine-tuned models, PromptCLUE-CMExam, is at 40.88 zero-shot. So after you hand GPT-4 the format it was missing, it still does not clear the floor of the fine-tuned group.
[S] Which is what you would expect if part of the gap is real. The fine-tuned models learned the house style of these particular exam-prep explanations. That is a genuine advantage on this reference set, and it is also exactly the kind of advantage that does not transfer anywhere.
[O] Is there a human check? Because that would settle it better than any n-gram.
[G] There is, and it is thin. Appendix A-four. They took fifty randomly selected cases per model, invited medical experts to hand-verify the explanations, and sorted the errors into irrelevant, repeated, or inaccurate. The GPT models exceeded 45 out of 50 rated reasonable — over ninety percent. ChatGLM and ChatGLM-CMExam come out lower, in the low forties by the figure.
[O] So the human ordering is the exact inverse of the BLEU ordering.
[G] It is. And I want to be the one to list what is wrong with it, rather than let the skeptic have all the fun. Three problems. It is fifty items. The number of experts is never specified — just "medical experts." And there is no agreement statistic, same as the annotation layer.
[S] There is a fourth and it is the worst one. Read the sampling criterion.
[G] You are right. The fifty cases are drawn from cases in which the models correctly predicted the answer. So it is a spot check on explanation quality conditioned on the model already getting the question right.
[S] Which tells you nothing about the roughly thirty-eight percent of questions GPT-4 gets wrong. Or, for zero-shot ChatGLM at 26.3 percent accuracy, the roughly seventy-four percent it gets wrong. The interesting failure mode in medical AI is the confident wrong explanation, and this design cannot see it by construction.
[O] That is fair and I am not going to fight it. Let me take the optimist case somewhere else, then — the stratified results, which I think are the actual product here.
[G] Go ahead, because I agree that is where the annotation layer earns its keep.
[O] By disease group, GPT-4 ranges from 74.4 percent on Neoplasms down to 44.3 percent on Traditional Medicine Disease Patterns. Thirty points of spread inside one model. GPT-3.5 shows the same shape, 63.9 down to 31.0 on the same two categories. And by discipline, the three weakest are Traditional Chinese Pharmacy at 37.1, Traditional Chinese Medicine at 40.6, and Pharmacy at 41.9 — all below forty-two percent.
[S] So a coherent knowledge region where frontier models are weak.
[O] A coherent, clinically real, culturally specific knowledge region — one that a single aggregate accuracy number completely hides. You only see it because someone attached ICD-11 codes and Ministry of Education discipline labels to the test set. That is the reusable artifact.
[G] And the difficulty stratification is the cleanest result in the paper, methodologically. All four tracked models decline monotonically across the five tiers — average accuracy 56.5 percent on Easy, then 45.8, 36.4, 26.5, and 19.1 on Extremely Difficult. Every model, every tier, no inversions.
[S] Though I would note that is partly by construction. The tiers were defined by human correctness rates, so you have shown models find hard-for-humans questions hard. That is a validity check, and it passes, but it is not a discovery.
[G] That is the right reading. It is evidence the difficulty axis is measuring something real, which is worth having.
[S] Two caveats on the stratified tables before we move on, since precision matters here. Both Table 4 and Table 5 include a not-applicable row among their categories — questions where neither taxonomy fit. So when you see sixteen rows in the disease table, that is fifteen actual ICD-11 groups plus a residual bucket. Fifteen department rows is fourteen departments plus the bucket.
[G] Correct, and worth saying because the not-applicable bucket is not small. Only about sixty-six percent of test questions got a disease-group label at all — 4,493 out of 6,811. And about seventy-three percent got a department label, 4,965 out of 6,811.
[O] So a third of the test set is unclassifiable under ICD-11.
[G] Under ICD-11 as applied by this pipeline, yes. Which is not shocking for an exam with a large traditional-medicine component, but it does mean the disease-group analysis covers two-thirds of the test set, not all of it.
[S] One more oddity, lightly held. The bottom department row, Intensive Care Medicine, averages 13.9 percent with a standard deviation of plus or minus 15.7 on one model. Whatever its question count, that row should not be read as a finding about intensive care medicine.
[O] Alright. Contamination. Skeptic, this is your moment, you have been waiting since the eight to one to one.
[S] Then let me be concrete rather than just gesturing at it. These are real, publicly available, past national exam questions, collected from the internet. The paper footnotes three Chinese exam-prep websites as the sources of the explanations. That is static, indexed, license-free web content of exactly the kind that ends up in a Chinese-capable model's pretraining corpus.
[G] All accurate.
[S] And the split is a random eight to one to one over that same scraped pool. Not a temporal holdout by exam year. So if a model memorized a question during pretraining, that question is as likely to land in test as in train, and nothing about the split procedure would reveal it. The paper runs no overlap check, no n-gram decontamination, no membership test. It is simply not measured.
[O] Do you think it is inflating the numbers?
[S] I have no idea, and that is precisely my complaint. Neither does anyone else, because it was not checked. And notice the direction of the risk — the models most likely to have ingested Chinese exam-prep sites are the large pretrained ones, which are the ones topping the prediction leaderboard.
[G] I will score that one to the skeptic without qualification. There is no decontamination analysis in the paper. And I would add the temporal point is the fixable one — the questions come from past exam years, so a holdout by year was available and would have cost nothing.
[O] Let me make my strongest case, then, and I will concede the leaderboard entirely to make it. Forget the rankings. What CMExam contributed is a template — pair every item with both a scoreable answer and a free-text rationale, then anchor your metadata to taxonomies someone else maintains. ICD-11 and the Ministry of Education discipline list are not going to drift because a benchmark author changed their mind. That makes the stratification portable and auditable.
[G] That is the right case to make, and it is the one the paper's own bottom line supports better than its abstract does.
[S] And my deflationary case is narrower than it might sound. I am not saying the dataset is bad. I am saying that the leaderboard on top of it has a two-year shelf life and reached it — these are GPT-4-0314 and GPT-3.5-turbo, frozen mid-2023 API snapshots, both long since superseded. As a capability ranking it is a historical document. As a fine-tuning ablation, which is what the eleven fine-tuned rows actually are, it holds up fine.
[O] I will take that deal.
[G] Then let me adjudicate, since I have been asked to score it. On the inversion — the skeptic is right that the metric is invalid for the claim, and the optimist is right that the paper's own appendix demonstrates why, and neither of those is in the abstract. On the annotation layer — the optimist is right that it is the durable contribution, and the skeptic is right that two annotators with no reported agreement statistic is thin support for it. On contamination — the skeptic wins outright, unopposed.
[S] What would raise your confidence, concretely?
[G] Four cheap things. An overlap audit against the test split. A kappa for the annotation review, and a second for the explanation-quality check. An explanation-quality sample not conditioned on the model answering correctly — that is the biggest one. And a refresh against current model snapshots.
[O] And the transferable lesson for people building evals now? Because I think it is sharper than "BLEU is bad."
[G] It is sharper. The paper had the disconfirming evidence in hand — appendix A-five, a thirty-five-fold BLEU swing at flat accuracy — and still let the reference-overlap metric arbitrate a claim in the introduction. Having the control is not enough. It has to outrank the table.
[S] Which is the recurring failure in this whole literature. The caveat goes in the limitations section, and the number goes in the abstract, and only one of those gets cited.
[O] Let us land it. Alban, the paper's takeaway.
[G] CMExam's durable contribution is a format and a metadata scheme — sixty-eight thousand real licensing-exam questions, each with both a gradeable answer and a free-text explanation, plus five stratification axes anchored to external authorities. The model rankings on top of it are dated, and its reasoning metric contradicts its own human spot check.
[O] Mine is that stratified evaluation is worth the annotation cost. A single 61.6 percent hides a thirty-point spread across disease groups and an entire weak region in traditional medicine. Aggregate accuracy would never have shown you that.
[S] Mine is that a benchmark inherits the validity of its weakest metric, not its strongest. CMExam graded two things, was honest that one of the two does not measure what it claims, and published the ranking anyway. Read the appendix before you cite the table.
[O] The full writeup is on the litsearch site, with the figures, the complete twenty-model table, and the stratification breakdowns. Thanks Alban.
