---
slug: liao-2024-saps
title: "Automatic Interactive Evaluation with a State-Aware Patient Simulator"
description: "A medical eval that replaces the multiple-choice exam with a ten-round consultation against a scripted patient simulator, and finds that the strongest model tested recalls thirty-eight point seven percent of what the patient knows."
date: 2026-07-28
guest_name: "Clara"
guest_voice: "bf_emma"
---
[S] Here is the number that should end the medical-exam era. GPT-4, on fifty real hospital cases, given ten rounds to interview a patient, recovers thirty-eight point seven percent of the information in that patient's chart. The same model class posts exam scores in the eighties and nineties.
[O] And that is exactly the point of the paper, so I will take it as a win rather than an indictment. A model that aces the exam has never once been tested on whether it can ask the right question. This is the first number I have seen that separates knowing medicine from doing a consultation.
[S] Or it is a number produced by a simulator that decides, turn by turn, what counts as a good question. If the referee is a language model, thirty-eight point seven percent tells me about the referee as much as the doctor.
[G] That tension is real, and the paper does more to address it than you would expect. It validates the referee first, against human annotators, on four thousand questions, before it lets the referee grade anyone. Whether that validation is sufficient is the interesting argument.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Today it is Automatic Interactive Evaluation for Large Language Models with State-Aware Patient Simulator.
[S] Yusheng Liao, Yutong Meng, Yuhao Wang, Hongcheng Liu, Yu Wang, and Yanfeng Wang, from Shanghai Jiao Tong University and the Shanghai Artificial Intelligence Laboratory. On arXiv in March twenty twenty-four, with the current version from that July.
[O] Our guest is Clara, who has read this one and the interactive medical evaluation work around it closely. Clara, why is this the paper on the docket?
[G] Because it identifies a gap that everyone acknowledged and almost nobody had built infrastructure for. And because the engineering answer is unfashionable. It is not a bigger model or a cleverer prompt. It is a task-oriented dialogue system, of the kind people built before the current era, wrapped around a language model to keep it honest.
[S] Set up the gap properly. What was medical evaluation in early twenty twenty-four?
[G] Overwhelmingly, standardized exams. MedQA, MedMCQA, MMLU-style multiple choice. The authors' complaint is structural rather than aesthetic. A multiple-choice item hands the model the entire case file and asks it to pick from five options. A real consultation gives the model nothing and requires it to elicit the case file, in an order, under a turn budget.
[O] And there were dialogue datasets before this. Those do not count?
[G] The paper groups them as a second incomplete bucket. Things like MedDG and the automatic medical consultation benchmark reduce the doctor to closed slot-filling. The action space is constrained to a fixed set of moves rather than open freeform inquiry. So you test dialogue management, not clinical questioning.
[S] What about the human-in-the-loop work? Google's AMIE had actual people role-playing patients.
[G] That is the third strand, and the authors treat it as the right target with the wrong economics. It captures the real back-and-forth, but it needs a human patient-actor for every turn of every dialogue for every model you want to test. You cannot run that against seven models on two datasets. The stated goal here is to keep AMIE's realism and replace the human with something automatic and controllable.
[O] So the whole paper is really about building a good enough fake patient.
[G] The whole paper is about building a fake patient you can trust to be difficult in the right way. That last part is the design insight. A naive simulator is too helpful.
[S] Unpack that.
[G] If you prompt a strong model to play a patient, it wants to be cooperative. Ask it something vague, and it dumps everything it knows. The authors observed this directly. They write that the doctor model could elicit more information by repeatedly asking vague questions. That is a shortcut, and it inverts the thing you are measuring, because the worse your questions, the more you learn.
[O] So a bad doctor gets rewarded.
[G] Precisely. So they built a patient that classifies your question before answering it, and answers according to what kind of question it was.
[S] That is the state tracker. Walk me through the categorization.
[G] Ten action types, in Table 1. Initialization and Conclusion bookend the dialogue. Then Inquiry and Advice each split three ways, into effective, ineffective, and ambiguous. Effective means the answer is in the patient's chart. Ineffective means it is a specific question but the chart has nothing. Ambiguous means the question was too broad. Then two more types to catch hallucination. Demand, where the doctor asks the patient to physically do something, and Other Topic, where the doctor wanders off medicine entirely.
[O] And each type has a scripted patient behavior.
[G] A required behavior, yes. Effective inquiry gets the corresponding information, unrephrased. Ineffective inquiry gets a negation. Ambiguous inquiry gets a request to be more specific — which is the anti-shortcut mechanism. Demand and Other Topic get a reminder that this is an online consultation about a medical problem.
[S] How does the classification actually work? Because if that step is unreliable, everything downstream is decoration.
[G] Three sequential constrained prompts. Step one sorts into five top-level categories, Inquiry, Advice, Demand, Other Topics, Conclusion. Step two runs only for Inquiry and Advice, and decides specific versus ambiguous. Step three, again only for the specific ones, asks whether the patient's chart actually contains relevant information, which is what separates effective from ineffective. Each step uses logit bias to force a single-token category output.
[O] Clara, that is three model calls per doctor turn on top of the response. Is that not enormously expensive for something billed as the cheap alternative?
[G] It is more expensive per turn than one prompt, certainly. The comparison the paper is making is against paying a human to sit in every dialogue, and against that baseline the arithmetic is not close. But you are right that this is not free, and the paper does not report a cost figure at all.
[S] And the memory bank?
[G] Three stores, and the gating is the clever part. Long-term memory is the fixed patient chart, and here is the key detail — it is only surfaced to the response generator when the tracker labels the turn effective inquiry or effective advice. Working memory holds the canned per-category instruction, so an ambiguous inquiry loads "ask the doctor to be more specific." Short-term is the running dialogue.
[O] So on a bad question, the generator literally cannot see the chart.
[G] That is the architecture. It is not asking a model to resist being helpful. It is withholding the material.
[S] Good. That is a real mechanism rather than a prompt hoping for the best. So how do they show it works?
[G] Two phases, and the first is the patient simulator test set. Fifty real hospital cases. GPT-4 generates ten rounds of doctor-patient dialogue per case, spanning the preset action types. Then human reviewers refine both the answer and the action label for every question. That yields four thousand test questions.
[O] Human-refined labels. That is the gold standard here.
[G] It is, and it matters for a subtle reason we should get to. They then score six patient-side dimensions. Accuracy, whether the reply covers the right information. Passive, whether it over-answers. Cautious, whether it leaks the chart on an ineffective question. Honest, whether it denies things not in the chart. And Guidance and Focus, whether it redirects a vague or off-topic doctor.
[S] Compared against what?
[G] Four off-the-shelf models prompted directly as patients — QianWen, XingHuo, ChatGPT, and GPT-4 — plus human actors as the ceiling. Figure 3a tracks the metrics turn by turn, and SAPS follows the human curve more closely and stays more stable across turns than the prompted models. The authors note it is actually more stable than the humans.
[O] Give me the instance-level numbers, because a curve is easy to eyeball generously.
[G] Figure 3b, Spearman correlation with human judgments. SAPS reaches point two eight on Accuracy, point four zero on Passive, and point six three on Cautious. Vanilla GPT-4 prompted as a patient gets point two three, point two two, and point two four.
[S] So the scaffold roughly triples the correlation on Passive and Cautious, and does almost nothing on Accuracy.
[G] That is a fair reading, and it is a coherent one. Accuracy is about faithfully reporting information you have been handed, which a strong model does adequately either way. Passive and Cautious are about withholding, which is exactly what the gating mechanism controls. The architecture improves precisely the dimensions it was built to improve.
[O] I want to sit on that, because it is the paper's best moment. The gains are not diffuse. They land where the theory says they should.
[S] Granted, and I will say I find that more convincing than a uniform lift would have been. But point two eight is a weak correlation in absolute terms, and the paper's own sentence is that SAPS shows improvements across all metrics compared to standard GPT-4. That framing is doing more work than point two three to point two eight supports.
[G] I would accept that criticism. The claim is directionally true on every metric and substantively true on two.
[O] Now the confusion matrix, Figure 3c, because I have heard this one described sloppily.
[G] It deserves care. The paper's own sentence is that the tracker's accuracy is slightly worse than the humans', still comparable and acceptable. On the means, that holds. Across the eight action categories, the tracker's diagonal averages ninety-three point four percent against ninety-five point nine for the human annotators.
[S] Two and a half points. Fine.
[G] But the per-category picture is not a uniform deficit, and this is where most summaries go wrong. The tracker actually beats the humans on two categories. Ineffective Inquiry, eighty-eight against eighty-three. And Ambiguous Inquiry, one hundred against ninety-eight. It ties them on Ambiguous Advice and on Demand, both at one hundred for each.
[O] So it trails on four of eight.
[G] Effective Inquiry, eighty-three against ninety-three. Effective Advice, ninety-eight against one hundred. Ineffective Advice, eighty against ninety-three. And Other, ninety-eight against one hundred. The tracker's single worst class is Ineffective Advice at eighty. The humans' worst class is Ineffective Inquiry at eighty-three — a different category entirely.
[S] That is a genuinely more interesting result than the mean. The machine is better at recognizing a vague question than the humans are, and worse at recognizing when advice went nowhere.
[G] And there is a structural reason to expect that. Ambiguity is a property of the question text alone. Judging whether advice was ineffective requires reading the whole chart and confirming an absence. Absence judgments are harder for a model and, apparently, easier for a person.
[O] One more methodological point before results, because you flagged it earlier.
[G] Equation seven, the Accuracy definition. It sums over the turns where the gold, human-annotated state is effective inquiry or effective advice. Not over the tracker's own predicted state. That matters enormously — if it used the prediction, the tracker would be selecting the turns on which it is graded, and the comparison in Figure 3c would be self-scored. They avoided that.
[S] Good. I will give them full credit for that one. Now the doctors.
[G] Seven models, at fixed late twenty twenty-three snapshots. GPT-4 and ChatGPT at the November preview versions, plus XingHuo and QianWen as the other closed-source entries, and ChatGLM3 at six billion, Baichuan at thirteen billion, and InternLM at twenty billion open-source. The doctor gets a system prompt saying it has up to ten rounds to gather information before an early diagnosis. Then it answers a multiple-choice diagnosis question over the dialogue it collected.
[O] And the options?
[G] Five total. Four distractor diseases generated by GPT-4, plus the true diagnosis. Figure 1 shows a worked example — diverticulitis as the answer, against hypothyroidism, colon adenocarcinoma, inflammatory bowel disease, and irritable bowel syndrome.
[S] Who did the human evaluation, exactly? I have seen this misreported.
[G] Three medical students played the doctor role. The patient-perspective ratings came from lay raters — the paper says normal people. Pairwise comparative evaluation, five metrics from each perspective, with a parallel GPT-4-as-judge run alongside.
[O] And the winner?
[G] QianWen, with the highest win rate in nearly all metrics. GPT-4 follows but, in the paper's words, not as dominant. InternLM is the weakest. Open-source models generally trail the closed-source ones.
[S] Hold on. GPT-4 is one of the two judges and also one of the seven contestants. That is the loudest problem in the paper and we have walked past it.
[G] It is the sharpest fair criticism available, and I will not defend it away. GPT-4 is a tested doctor model and simultaneously the automatic judge in Figure 4 and Figure 6a. On top of that, the state tracker runs on the same constrained-prompting recipe, and it feeds six of the eight automatic metrics.
[O] Six of eight. Which two are clean?
[G] Diagnosis and Distinct-2. Diagnosis is a multiple-choice answer checked against ground truth, and Distinct-2 is a surface repetition statistic over the dialogue text. Neither touches the tracker. Coverage, Inquiry Accuracy, Inquiry Specific, Advice Accuracy, Advice Specific, and Inquiry Logic all depend on the tracker's labels.
[S] So the judge and one contestant share a family, and three quarters of the automatic scoreboard is computed by that family.
[G] Yes. The one piece of evidence pointing the other way is that QianWen wins, not GPT-4. If there were blatant self-preference, GPT-4 should be topping its own leaderboard, and it does not. But the paper never tests the overlap directly and never discusses it.
[O] I will take the QianWen result as meaningful counter-evidence, but I concede it is circumstantial. Give me the automatic numbers on real hospital cases.
[G] Table 2. Best diagnosis accuracy is GPT-4 at sixty-four percent, ChatGPT at sixty, QianWen fifty-six, ChatGLM3 forty-eight, Baichuan forty-four, InternLM thirty-eight, XingHuo thirty-four. Coverage, the share of chart information actually recalled in dialogue, tops out at thirty-eight point seven percent for GPT-4.
[S] Against a five-option multiple choice, sixty-four percent is not far above what a decent guesser plus partial information yields. That is a sobering headline.
[O] It is sobering in exactly the productive direction. These are models that look near-ceiling on exams. Put them in a consultation and the ceiling is nowhere in sight. That gap is the entire contribution.
[G] There is one more pattern in that table worth naming. Every one of the seven models scores far higher on Inquiry Specific than Advice Specific. GPT-4, ninety point six against forty-eight point five. QianWen, ninety-four point three against fifty-six. The authors attribute this to safety tuning making models reluctant to commit to concrete treatment advice.
[O] That is a lovely finding. An alignment intervention showing up as a measurable clinical behavior deficit.
[S] It is a plausible story, not a demonstration. They did not ablate it. But I agree it is the most interesting hypothesis in the paper.
[O] What does the correlation analysis say about whether any of these metrics are worth trusting?
[G] Figure 5, twenty-eight dimensions across human, GPT-4, and automated evaluation. Three findings. GPT-4 judgments correlate with humans better than any automated metric does. Among the automated metrics, Distinct-2 correlates best. And diagnosis accuracy has the lowest human correlation of anything measured.
[S] Say that last one again.
[G] The metric that looks most like a real clinical outcome correlates least with what humans think of the consultation. And a surface repetition statistic correlates most.
[S] That should trouble everyone. Either humans are rating fluency and calling it clinical quality, or the diagnosis metric is too coarse at fifty cases to carry signal. Both readings are bad for somebody.
[G] The paper reads it as dialogue fluency remaining a key factor in evaluating diagnostic dialogues. I think your first reading deserves more weight than they give it.
[O] Is there a limit on the GPT-4-as-judge substitution?
[G] There is, and to their credit they report it. In the subset where both compared models are closed-source — the strongest pairings — GPT-4-to-human correlation actually drops. They conclude GPT-4 cannot yet fully replace human evaluation when comparing top-tier models. Their discussion section generalizes it further: the metrics differentiate well between models of clearly different ability and poorly between models of similar ability.
[S] Which is the property you least want in an eval, since the interesting comparisons are always between close models.
[O] Move to the second dataset. Does the framework scale?
[G] MedicalExam, one hundred fifty cases drawn from five public sources — MedQA, MedMCQA, MMLU, SelfExam, and QMAX. The paper's summary is that scores are lower, therefore MedicalExam is more complex and challenging, with the explanation that unlike the hospital cases, the diagnosis is not directly contained in the patient information and requires further reasoning.
[S] Is that true?
[G] For the outcome metrics, yes, and clearly. Diagnosis falls for all seven models. GPT-4 from sixty-four to fifty-three point three. InternLM thirty-eight to thirty. XingHuo thirty-four to fifteen point three. Advice Accuracy also falls for every model.
[O] And the rest of the table?
[G] Three columns move the opposite way, for every one of the seven models. Distinct-2 rises — InternLM from sixty-two point two to ninety-five point five, GPT-4 from seventy-eight point two to seventy-nine point one. Inquiry Logic rises, GPT-4 forty-one point seven to forty-two point seven. And Advice Specific rises, QianWen from fifty-six to seventy-two point two. Coverage even rises for ChatGLM3.
[S] So the sentence "score values are lower" is false for three of the eight columns in their own table. And one of those three is Distinct-2, which they elsewhere call their single most human-correlated automatic metric.
[G] That is the cleanest internal inconsistency in the paper. The harder-benchmark claim holds for outcomes and fails for behavior.
[O] What about the reversals — cases where the interactive format beat the multiple-choice format?
[G] Figure 6b compares direct multiple-choice against the interactive pipeline per source dataset. Generally the interactive scores are lower, which is expected since the model has to collect its own information. The paper names three exceptions. ChatGLM3 on MedQA, point three seven interactive against point two seven multiple-choice. XingHuo on MedMCQA, point four seven against point four three. Baichuan on QMAX, point four against point three.
[S] You said the paper names three. That is a strange way to phrase it.
[G] Because the figure shows five. InternLM also reverses, on both MedQA and MedMCQA, and the text does not mention it. Three by the paper's count, five by the figure's. None on MMLU or SelfExam either way.
[O] Does the extra two change the story?
[G] It strengthens their hypothesis slightly — that weaker models cannot fully exploit a complete chart, so interactive collection helps them. But I would not lean on it. One hundred fifty cases split across five sources is roughly thirty cases each. A reversal of ten points on thirty cases is well inside sampling noise.
[S] Let me raise a smaller thing that I think is diagnostic. What is the advertised turn limit?
[G] Ten rounds, stated in the doctor system prompt.
[S] And the average turn count on MedicalExam?
[G] Between ten point three five and twelve point one three, for every model. So the cap is not enforced — it is a suggestion in a prompt that models routinely exceed. On the hospital cases the averages sit under ten, so this is specific to the harder set.
[S] That is my point precisely. A benchmark whose stated budget is not a real constraint has a comparability problem, because a model that takes twelve turns is not running the same eval as one that takes ten point three.
[O] I will concede that fully. It is a small fix and it should have been made.
[G] There is one more gap worth stating carefully, because it affects reproducibility. Three of the six patient-side validation metrics — Honest, Focus, and Guidance — are keyword-membership tests. The response is scored as honest if it contains any word from a set the paper calls H, and similarly for the focus and guidance sets.
[S] And where are those sets printed?
[G] They are not, anywhere in the paper. There is no appendix. The Data Availability section says all preprocessed data are available in the code repository, and the Code Availability section gives a repository containing the annotation guidelines and synthetic datasets. So there is a pointer, and it may well contain them.
[S] But half the validation suite for the simulator is not recomputable from the paper alone.
[G] That is the accurate statement. A pointer to a repository is not the same as a definition in the text, and for a keyword set — where adding one word changes every score — the exact contents are the metric.
[O] Let me make the optimist case cleanly, and then take the hits. This paper does the thing the field keeps saying it wants. It replaces a static exam with an interactive protocol, it defines a real action space rather than hand-waving at dialogue quality, and it validates the referee before using it. Thirty-eight point seven percent coverage from the best model is a finding that no exam could have surfaced.
[S] The deflationary case. Six of eight automatic metrics are computed by a component from the same model family as one contestant and both judges. The headline harder-benchmark claim is contradicted by three columns of the authors' own table. The turn cap is not enforced. Half the simulator validation rests on unpublished keyword lists. And not one domain-tuned medical model is actually run.
[O] On that last one, they give a reason.
[G] They do, in the methods. Preliminary experiments showed the instruction-following ability of many medical models is compromised, causing them to fail multi-turn tasks requiring complex instructions. It is an honest reason. But it is also a selection effect built into the eval — AIE can only be run on models that already clear an instruction-following bar. So the paper's weak-versus-strong finding is a general-model story, not a medical-specialization one, and Huatuo, DISC-MedLLM, ChatDoctor and the rest are discussed as related work without ever being measured.
[O] Score it, Clara.
[G] To the optimist, the framework and the anti-shortcut mechanism — those are sound, and the withholding architecture is genuinely well-motivated. Equation seven's use of the gold label is a real piece of methodological care. And the per-category confusion result is stronger than the paper's own framing of it. To the skeptic, the judge overlap and the keyword sets, unambiguously. On the harder-benchmark claim, the skeptic is simply right — read column by column, it does not hold.
[S] And the reversals?
[G] Underpowered. Interesting, not established.
[O] What would raise your confidence most?
[G] Print the three keyword sets in the paper. Run one domain-tuned medical model, even if it fails, and report how it fails. Reconcile Inquiry Logic's definition with its values — it is defined as a Levenshtein edit distance, where lower should mean a more logical ordering, yet the strongest models post the highest scores in both tables, with no stated inversion or normalization. And enforce the turn cap.
[S] My takeaway. This is the right idea with a scoreboard I would not cite a single column from without checking its definition against its equation first. Two of those equations print the wrong left-hand side.
[O] Mine is the opposite emphasis on the same facts. The gap between exam performance and consultation performance is enormous, real, and previously invisible. Fix the four things Clara listed and this becomes the template for interactive evaluation well beyond medicine.
[G] The paper's own takeaway, stated fairly, is that a state-aware simulator role-plays a patient more faithfully than prompting a model to do it, and that once you have such a simulator you can run interactive evaluation at a scale human actors never allowed. Both claims survive. The individual metric columns need a second look before any of them travels.
[O] The full writeup is on the litsearch site, with the figures, the confusion matrix, and the column-by-column reading of both tables. Clara, thank you.
