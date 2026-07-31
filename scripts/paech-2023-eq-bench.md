---
slug: paech-2023-eq-bench
title: "EQ-Bench: An Emotional Intelligence Benchmark for Large Language Models"
description: "A sixty-question emotional-understanding benchmark that tracks MMLU at an r of point nine seven — and why that correlation is simultaneously its strongest evidence and its deepest problem."
date: 2026-07-31
guest_name: "Meredith"
guest_voice: "bf_emma"
---
[O] Here is a benchmark that claims to measure emotional intelligence in language models, and its headline validation result is a Pearson correlation with M M L U of point nine seven. That is a remarkable agreement between a test about feelings and a test about knowledge.
[S] That is the part that stops me cold. If your emotional understanding test agrees with a multi-domain knowledge quiz at point nine seven, the most economical explanation is that you built a second, shorter general capability test and put an emotional label on it.
[O] Or the far more interesting reading, which the paper actually advances, is that emotional understanding is not a separate faculty bolted onto language models. It emerges with general capability, and you can measure it with sixty questions instead of fourteen thousand and seventy nine.
[S] Both readings fit an r of point nine seven equally well. That is exactly the problem with a correlation as your primary evidence, and I want to know how many models that correlation was computed over before I believe either of us.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take a paper apart. Today it is E Q Bench, an emotional intelligence benchmark for large language models, by Samuel Paech, posted to arXiv in December twenty twenty three.
[S] Sole author, single-author preprint, no venue. Worth saying up front, not as a slight but as a fact about how much institutional review this went through.
[O] And joining us is Meredith, who has read this one closely. Meredith, welcome. This paper is on the docket because it is a rare thing, a benchmark that is honest about being subjective and still manages to discriminate sharply between models.
[G] Thank you. And I would add one more reason it is worth an hour. The paper's own central claim contains the seed of the strongest objection to it, and the author more or less says so. That is unusual and it makes for a better conversation than most benchmark papers.
[S] Set the stage for me, Meredith. What was the state of evaluation in late twenty twenty three that made this feel necessary?
[G] The paper frames the landscape as three buckets. Multi-domain multiple-choice question answering, which is M M L U and its relatives. L L M as a judge, which is the AlpacaEval style. And ranking by human preference, which is Chatbot Arena. The author spells out specific drawbacks for the first two.
[O] What are the drawbacks he names?
[G] For multi-domain question answering, that you need thousands of questions to cover broad knowledge, fourteen thousand and seventy nine for M M L U alone, and that breadth makes it gameable by targeting a model's training data at the specific domains covered. For L L M as a judge, that the scores inherit the judge's own biases, and he quotes AlpacaEval's own warning that G P T four may favour models with longer outputs, or models fine-tuned on G P T four outputs.
[S] And the third bucket, human preference ranking?
[G] He does not spell out a specific drawback for that one. The argument for the third is simply that none of the three specifically targets emotional understanding. That is the gap he is claiming, not that Arena is broken.
[O] There was one prior test in this space though, was there not?
[G] There was, and getting this right matters for the whole paper. It is S E C E U, by Wang and colleagues, from twenty twenty three. It shows a short scenario and asks the model to rate the relative strength of four candidate emotions. The format is genuinely close. E Q Bench is best understood as a targeted redesign of S E C E U, and the paper names four specific defects it is fixing.
[S] Go through them, because if the fixes do not hold, the whole contribution is thin.
[G] First, S E C E U's reference answers are the average of a human cohort's own ratings. The author argues that compresses the usable range toward the human mean. His evidence is that S E C E U scored OpenAI's Babbage and Curie models at or above the human average, and placed Curie, an early thirteen billion parameter model, within two point six percent of the far larger G P T three point five turbo.
[O] That is a good catch. If your scale says Curie is as emotionally perceptive as G P T three point five, your scale is broken.
[G] Second, the scenarios are short descriptions without dialogue, so there is less to reason about. Third, S E C E U requires the four intensity ratings to sum to exactly ten. The author argues that taxes the model's arithmetic, citing the M A T H benchmark work on how much language models struggle with basic maths, and that it forces a sequential dependence, because a model generating token by token has its later ratings constrained by how many points are left.
[S] That third one is a sharper methodological point than it first appears. You are contaminating an emotion measurement with an arithmetic measurement and a token-ordering artefact.
[G] Quite. And fourth, S E C E U picks the four most plausible emotions for a scenario, which the author argues narrows exactly the ambiguity the test is meant to probe. If all four options are plausible, you have made the discrimination harder in an uninformative way.
[O] So walk us through what E Q Bench actually does instead. Meredith, take us into the method.
[G] Sixty questions. Each presents a short dialogue generated by G P T four, depicting a scene of conflict or tension. The model is asked to rate, on a zero to ten intensity scale, how strongly one named character would be feeling each of four listed emotions.
[S] Why conflict specifically? That sounds like a hyperparameter someone chose and then rationalised.
[G] The author reports it as an empirical finding during dialogue generation. Without the conflict constraint, G P T four tended to produce dialogue that resolved too predictably to carry emotional nuance. So the constraint is there to keep the scenes from being flat.
[O] And the four emotions per question, how are those chosen?
[G] This is a detail worth stating precisely, because it is easy to over-specify. The paper says the selected emotions typically include some that are clearly wrong, some that are obvious, and some that require a nuanced understanding of the scene to rate accurately. It says some, some, and some. It does not give a fixed breakdown of how many fall in each category.
[S] Good. I appreciate you not inventing a ratio. Now the scoring, because I have seen this benchmark described as an accuracy measure and I suspect that is wrong.
[G] It is wrong, and this is the single most important thing to get right about this paper. It is not an accuracy metric. It is a rating-distance metric. There are three steps.
[S] Take them slowly.
[G] Step one. The model's four raw ratings are normalised to sum to ten. The reference answers are already stored pre-normalised the same way. Step two. You compute the sum of the absolute differences between the model's normalised ratings and the reference's normalised ratings, across the four emotions. Step three. You subtract that sum from a constant of ten. That is the question's score.
[O] So the score is ten minus the total disagreement.
[G] Exactly. Ten minus the summed absolute difference. And the constant of ten is not arbitrary. It is chosen specifically so that answering completely at random averages out to a score of zero.
[S] Wait, hold on. You normalise the model's ratings to sum to ten, but the author's whole third complaint about S E C E U was that forcing a sum to ten is bad. Is that not the same constraint?
[G] It is a genuinely sharp question and the answer is no, and the distinction is the design. S E C E U made the model do the normalising, inside its own generation, which is where the arithmetic tax and the sequential dependence come from. E Q Bench lets the model rate each emotion freely from zero to ten, independently, and then the scoring harness does the normalising afterwards in software.
[S] Right. The constraint moves out of the model and into the scorer. I withdraw the objection, that is a clean fix.
[O] And what does the normalisation actually change about what is being measured?
[G] It deliberately shifts the target from how intense is this emotion in absolute terms, to how does the model rank the relative intensity of these four emotions. The paper compares the absolute version to self-reported pain scales in medicine, where one person's seven is another person's four. Relative ranking sidesteps that.
[S] What about questions the model fails to answer in a parsable format? Because that is where a lot of benchmarks quietly cheat.
[G] The final score is the mean of per-question scores over only the parsable questions. Unparsable answers are excluded rather than scored zero, so the benchmark is not conflating emotional understanding with formatting compliance. But there is a floor. If fewer than fifty of the sixty come back parsable, the run is marked a fail rather than given a low number.
[O] That seems like the right call. You do not want a model's score dragged down by its inability to follow an output template.
[S] Now, there is a critique and revise step in the protocol. Explain how that interacts with the final number, because I have seen this misreported.
[G] And it is worth being careful. The model is prompted zero-shot to give first-pass scores, then to write a step-by-step critique of its own answer, then to give revised scores. Both the first-pass and the revised answers are kept and scored separately, so each model has two scores. The reported benchmark score is the better of those two.
[S] The better of two runs. That is score inflation by selection.
[G] No, and this is the distinction that matters. They are not two independent runs. Both scores come from a single administration of the sixty questions. The revised answer is conditioned on the first-pass answer within the same pass. So it is the better of two scores from one administration, not the best of two attempts.
[S] That is a meaningfully different thing, thank you. And why better-of-two rather than best-per-question?
[G] The author addresses that directly. Taking the best answer per question would disproportionately reward wild guessing on individual questions. Taking the better of the two whole-test scores does not have that property.
[O] Any other protocol details that could move numbers?
[G] One that matters for fairness. The open-source models were run quantised, using bitsandbytes. Eight-bit quantisation for models from seven B to thirty four B parameters, and four-bit above that. The author flags this himself as a possible source of score suppression for those models specifically, and says he hopes to quantify the effect in future work.
[S] So the open models may be handicapped relative to the A P I models, by an unmeasured amount. Noted, and credit for disclosing it.
[O] Let us get to results. Meredith, the numbers.
[G] Table one has twenty five rows. G P T four, oh six one three, is top at sixty two point five two, which the paper calls the highest score by a considerable margin. The best open-weight model is SynthIA seventy B v one point five, a Llama two seventy B fine-tune built for role-play, at fifty four point eight three.
[O] A role-play fine-tune beating everything else in the open-weight field is a lovely result. It suggests the thing you train for when you train for character consistency is the thing this test measures.
[G] The paper does note the role-play angle. Below SynthIA you have G P T four, oh three one four, at fifty three point three nine, Qwen seventy two B Chat at fifty two point four four, Claude two at fifty two point one four, and Llama two seventy B chat at fifty one point five six.
[S] And the bottom of the table?
[G] The bottom is instructive. Three legacy OpenAI completion models, Babbage, ADA, and Curie, all initially failed the fifty-answer parsability threshold. Babbage is the one model that Table one records as an outright fail.
[O] But ADA and Curie have numbers. Two point two five and nine point two eight.
[G] They do, and the provenance of those two numbers deserves stating. They were obtained only after simplifying the prompt to remove the critique and revision section. And the paper immediately notes that both scores are close to what random answering would produce, so their answers were nearly indistinguishable from random.
[S] So two of the three bottom scores come from a modified protocol and are statistically indistinguishable from noise. That is fine, it is disclosed, but nobody should cite ADA's two point two five as a measurement of anything.
[O] What about stability? A subjective benchmark that swings run to run is useless.
[G] The repeatability is good. Average coefficient of variation of two point nine three percent across multiple runs. The author attributes that to ordinary language model output non-determinism rather than any flaw in the test design.
[S] Under three percent is genuinely tight for a generative protocol. That is a real point in the paper's favour and I will grant it.
[O] And the critique and revise step, does it actually help?
[G] On average yes, nine point three percent improvement across the models compared. But the paper is candid that the benefit was inconsistent. Weaker models tended to gain more. And for some models the revised pass scored consistently lower than the first pass. Mistral seven B OpenOrca and Qwen fourteen B both revised downward in all three of the repeated runs reported in the appendix.
[S] So self-critique makes some models worse, reliably. That is a more interesting finding than the average, and it slightly undercuts using the better-of-two rule, because for those models the revision step is pure overhead.
[G] It is why the author says he includes the technique primarily to give the model a chance to deploy its reasoning, rather than as a score-maximising trick.
[O] Now the correlation analysis, which is the paper's central evidence.
[G] All Pearson correlations of E Q Bench score against the external benchmark's own score. M M L U at point nine seven. Chatbot Arena E L O at point nine four. HellaSwag at point nine one. M T Bench at point nine one. AlpacaEval at point nine one. A R C at point eight five. Then two that come back markedly weaker. TruthfulQA at point four four, and S E C E U at point two two.
[S] Stop there. S E C E U at point two two. E Q Bench is a redesign of S E C E U, same rate-four-emotions shape, and they barely agree with each other.
[G] The author leans into that rather than hiding it. The argument is that because the two share a format but disagree sharply, while E Q Bench agrees strongly with M M L U and Arena and M T Bench, the four methodological changes are what is driving the difference. He supports it with distribution statistics.
[O] Which are?
[G] On a common zero to one hundred normalised scale, over the models common to both, E Q Bench has an interquartile range of fifty three point eight one against S E C E U's fourteen point seven one, and a skewness of point one three against S E C E U's minus point six eight. So E Q Bench spreads the models out and stays near-symmetric, while S E C E U bunches them toward the top.
[S] That is a fair argument for E Q Bench being the more discriminating of the two. It is not an argument that either one measures emotional understanding.
[G] The author says exactly that, almost in those words. He notes these distribution comparisons do not take into account whether the scores are accurately measuring emotional understanding.
[O] Alright, this is the debate segment, so let me make the strongest optimist case. This is a sixty-question test, it runs in under ten minutes for an A P I model and twenty to sixty minutes on a single R T X A six thousand for an open one, it is repeatable to under three percent, it spreads models across its whole range without bunching, and it tracks every broad capability benchmark we trust. That is an extraordinarily high value-per-token evaluation.
[S] And my deflationary case is one sentence. A test that correlates with M M L U at point nine seven is, to a first approximation, M M L U. You have built a cheap proxy for general capability and named it emotional intelligence. The construct validity is unestablished.
[O] Meredith, adjudicate.
[G] I will score this in parts, because the honest answer splits. On cost and repeatability the optimist is simply right, and the paper's own runtime numbers support it. On discrimination the optimist is also right. The author highlights one specific comparison, that on an aggregate of A R C, HellaSwag, M M L U and TruthfulQA, Llama two seventy B chat scores only one point four percent higher than the seven B Mistral OpenOrca fine-tune, whereas E Q Bench scores the seventy B model thirteen point nine percent higher.
[O] So it is more sensitive to the parameter scaling than the aggregate is.
[G] On that pair, yes. On construct validity, though, the skeptic has the better of it, and I want to give him a sharper weapon than he currently has.
[S] Please do.
[G] The paper reports these correlations as bare r values. It never states, anywhere in the text, how many models each correlation is computed over. Not in the figure captions, not in the prose. You have to go to the appendix score matrices and count the rows where both values are present.
[S] And when you count?
[G] The M M L U correlation, the point nine seven, is paired over sixteen models. The S E C E U correlation, the point two two, is paired over eight. The thinnest panels are down at eight paired points.
[O] Sixteen. I had been carrying that point nine seven around as though it were a large-sample result.
[G] Most readers would. And an r of point nine seven over sixteen paired models is a substantially weaker claim than the number sounds. With eight points you can get a striking correlation coefficient from very little.
[S] It compounds with something else, which is the spread of the model pool. Those sixteen models are not peers. They run from Oasst pythia twelve B and text-davinci-oh-oh-one at the bottom to G P T four at the top.
[G] That is the right follow-through. When your sample spans that much capability range, a regression line will look strong almost regardless of what you are measuring, because how good is this model overall is itself correlated with everything. The paper does not test whether the correlation survives within a narrow band of similarly capable contemporary models, which is the harder and more useful question for a benchmark meant to separate frontier systems.
[O] That is a fair hit and I will take it. Is there anything else in the appendix that a careful reader should know?
[G] There is one wrinkle, and I want to frame it carefully, because the right description is what each table shows, not that the paper is wrong. The appendix correlation matrices list different E Q Bench scores from Table one for at least six shared checkpoints.
[S] How different?
[G] Mostly small. G P T four, oh six one three, is sixty two point five two in Table one and sixty two point nine four in the appendix, a drift of point four two. But G P T four, oh three one four, is fifty three point three nine in Table one and sixty point seven three in the appendix. That is a drift of seven point three four points.
[O] Seven points. Where would that put it?
[G] Taken at face value, second overall. Above SynthIA seventy B v one point five at fifty four point eight three, which is the paper's own best open model. There is also an apparent swap of the text-davinci-oh-oh-two and oh-oh-three values between the tables, and Curie is nine point two eight in Table one but thirteen point five five as text-curie-oh-oh-one in the appendix comparison table.
[S] What is the innocent explanation?
[G] Most likely a separate benchmark run collected for the correlation study. That would be entirely ordinary. But the paper's text never says so and never reconciles the two sets. So the practical guidance for a reader is narrow. Do not treat either table as the single canonical score for those particular checkpoints, and do not treat the exact mid-table ranking as fixed. It is not evidence that the headline claims are wrong.
[O] That is a properly scoped version of the objection.
[S] Let me raise the one I think is foundational. Every reference answer in this benchmark was set by one person's judgment.
[G] That is accurate and the paper states it plainly. All questions and reference answers were determined by the author. There is no external rater, no expert panel, no human cohort, and no inter-rater agreement check reported anywhere.
[S] So the ground truth for an emotional intelligence test is one individual's intuitions about what a fictional character ought to feel.
[G] Yes. And it is a deliberate trade, not an oversight. The alternative he is rejecting is S E C E U's crowd-averaging, which produced the compression problem he documents. So he swaps compression toward a human mean for one person's priors. The limitations section concedes the approach and says future work may employ experts in emotional intelligence to craft questions and collectively decide reference answers.
[O] Is there a human baseline at all?
[G] No. The paper says that due to resource constraints the test was not administered to a human cohort. So there is nothing outside the model comparison anchoring the scale.
[S] And contamination?
[G] Not tested. The paper flags training-set leakage as a known risk for any public benchmark, and explicitly defers investigating it to future research. It says it will monitor the space. Nothing in the paper measures whether any tested model had prior exposure.
[O] Which matters more now than it did then, because the question set has been public since release.
[G] It has. And I should be clear about scope here. The paper's numbers are a December twenty twenty three snapshot. There is a live public leaderboard that has kept running since, but everything we have quoted today is from the preprint, and none of it should be read as current standings.
[S] Good. So where does that leave us, Meredith? Is it measuring emotional understanding or is it measuring capability?
[G] My read, going a step beyond the text, is that the paper cannot distinguish those two with the evidence it has, and it knows it. The correlation table is simultaneously the strongest validation on offer and the strongest argument that the construct is not separable. That tension is raised in the paper and not resolved in it.
[O] I still think this is a genuinely useful artefact. It is cheap, it is repeatable to under three percent, it discriminates across its full range, and it improves on S E C E U in every dimension it set out to. Those are real contributions and they do not evaporate because construct validity is open.
[S] I agree with all of that, which surprises me. My position is narrower than it was at the top. This is a good, cheap, well-characterised capability probe with an emotional-understanding flavour, built by one person with unusual candour about its limits. What I object to is reading the point nine seven as validation. Over sixteen heterogeneous models, it is suggestive at best.
[G] And I would put the practical lesson for evaluation design this way. A benchmark that correlates near-perfectly with an existing benchmark has told you something, but what it has told you is ambiguous between converging on a real construct and re-measuring general capability. Distinguishing those requires holding capability roughly constant and seeing if the signal survives. That is the study this paper does not run, and the one that would settle it.
[O] Meredith, your one-sentence takeaway.
[G] E Q Bench is a well-engineered, cheap, repeatable rating-distance test whose reference answers rest on a single author's judgment, and whose headline correlation with M M L U is computed over sixteen paired models, which is far fewer than the number point nine seven suggests.
[O] Mine is that emotional understanding tracking general capability so tightly is a finding worth taking seriously rather than explaining away, and doing it in sixty questions and ten minutes is a real piece of evaluation engineering.
[S] And mine is that the most important sentence in this paper is the one it does not print, which is the sample size under each correlation. Ask that question of every benchmark validation you read.
[O] The full writeup, with the figures, the scoring worked example, and the table-by-table comparison, is on the litsearch site. Meredith, thank you.
