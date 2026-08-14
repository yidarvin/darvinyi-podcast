---
slug: schmidgall-2024-agentclinic
title: "AgentClinic: a multimodal agent benchmark to evaluate AI in simulated clinical environments"
description: "Models went from thirty-eight to ninety percent on the medical licensing exam. Turn the same cases into a conversation the model has to drive, and the best one gets sixty-two percent. A simulation result, not a clinical one."
date: 2026-07-26
guest_name: "Clara"
guest_voice: "bf_isabella"
---
[S] Language models went from thirty-eight percent to ninety percent on the US medical licensing exam in about two years. Put the same exam cases into a conversation where the model has to ask for the information itself, and the best model in this paper gets sixty-two percent.
[O] And that gap is the whole point. It is not a failure result, it is a measurement result. It says the licensing exam was never measuring the thing its score implied.
[S] Agreed. Here is my problem. The patient is GPT-4. The lab is GPT-4. The grader is GPT-4. We are measuring how well a model talks to itself.
[O] Which the authors say out loud in their own limitations. I still want to argue this is the most honest instrument in medical AI evaluation right now.
[G] You will both have to reckon with an appendix, because there is a number buried at the back of this paper that neither of your positions has priced in yet.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Today it is AgentClinic, a multimodal agent benchmark to evaluate AI in simulated clinical environments.
[S] Samuel Schmidgall, Rojin Ziaei, Carl Harris, Ji Woong Kim, Eduardo Reis, Jeffrey Jopling, and Michael Moor. Johns Hopkins, Stanford, Hospital Israelita Albert Einstein, and ETH Zurich. First posted to arXiv in May twenty twenty four, revised through twenty twenty five.
[O] Our guest is Clara, who has spent a lot of time with this benchmark and the medical evaluation literature around it. Clara, welcome. Set the frame before we touch a single number.
[G] Gladly, and I want one caution up front because it governs everything that follows. This is a simulation. The patient is a language model, the physical exam and the lab values come out of a language model, and the thing that decides whether a diagnosis is correct is also a language model. No human patient is involved anywhere in this work. So every accuracy figure in this paper is a statement about behaviour inside a simulated encounter, not a statement about any model's fitness to care for a person.
[S] Noted, and I intend to hold you to it.
[O] So start with the gap. Why was static medical question answering not enough?
[G] Because of the trajectory the introduction opens with. Accuracy on MedQA, the licensing-exam-derived multiple choice set, went from thirty-eight point one percent in September twenty twenty one to ninety point two percent in November twenty twenty three. The human passing score is sixty percent and the reported human expert score is eighty-seven. Read naively, that says the problem is finished.
[O] And read carefully?
[G] It says models are good at picking an answer once the vignette has been assembled for them. A MedQA item hands over the history, the symptoms, the vitals, the labs, and then four or five options. All the information-gathering was done by the question writer.
[S] Whereas the actual job starts with a chief complaint and nothing else.
[G] Exactly, and the paper cites a lovely piece of evidence for how tight the real constraint is. One study of family physicians found an average of three point two questions asked, and under two minutes spent, before arriving at a conclusion.
[O] What existed before this? Conversational medical evaluation is not a brand new idea.
[G] Three efforts mainly. AMIE, from Tu and colleagues, which does simulate diagnostic dialogue and reports strong results, but is closed source, is history-taking only, and cannot order tests or handle images. CRAFT-MD, from Johri and colleagues, dialogue-based but dermatology-focused and without images. And a state-aware patient simulator from Liao and colleagues. Then separately MedAgents, from Tang and colleagues, which improves static question answering by having specialist agents confer, but never simulates a patient at all.
[S] So the contribution is coverage rather than a new idea.
[G] The contribution is putting information-gathering, test ordering, images, bias, tools, languages, and specialties into one open-source environment, and then measuring whether the static score predicts the interactive one. The second half is the part I would defend as genuinely new.
[O] Walk us through the machinery.
[G] Four agents per case. The doctor agent is the model under evaluation, and it starts with only a brief objective, something like evaluate the patient presenting with chest pain and shortness of breath. The patient agent holds the history and symptoms but is explicitly told it does not know the diagnosis and must not state it. The measurement agent is conditioned on that case's exam findings and answers requests for tests. The moderator holds the ground truth and decides whether the doctor's final free text matches it.
[S] Why does the grader need to be a model at all?
[G] Because the doctor's output is unstructured. The paper's own example is a doctor saying, given your CT and blood results, I believe a diagnosis of PE is the most reasonable conclusion, where the ground truth string is pulmonary embolism. Something has to decide that those are the same answer.
[O] And the budget.
[G] Twenty interactions. Both doctor and patient get twenty turns, which produces about forty lines of dialogue, and crucially a test request spends one of the doctor's twenty. Ordering a CT costs you a question you could have asked.
[S] That coupling is the most clinically real thing in the whole design.
[O] What are the case sets?
[G] Five. AgentClinic-MedQA, two hundred and fifteen cases from licensing exam material. AgentClinic-MIMIC-IV, two hundred cases from de-identified electronic health records. AgentClinic-NEJM, one hundred and twenty multimodal cases sampled from nine hundred and thirty-two New England Journal of Medicine case challenges, each with a real diagnostic image. AgentClinic-Spec, two hundred and sixty specialist cases across nine specialties. And AgentClinic-Lang, seven hundred and forty-nine cases in seven languages.
[S] How were the cases built? That is usually where a benchmark rots.
[G] GPT-4 populates a structured template modelled on an OSCE station, the objective structured clinical examination format, and the authors then manually validate each scenario. The multilingual cases are GPT-4 translations corrected by native speakers.
[S] So a GPT-4-authored artifact, human-validated, played by GPT-4 agents, graded by GPT-4.
[G] That is a fair description of the pipeline, and the paper does not pretend otherwise.
[O] Tell me about the electronic health record set specifically, because real clinical data is the interesting part.
[G] It is also the most filtered. MIMIC-IV holds about forty thousand patients, and roughly thirty-four thousand of them carry multiple simultaneous diagnoses, some of them hundreds. AgentClinic needs one ground-truth answer, so the authors take the first two hundred patients out of roughly six thousand who present with exactly one diagnosis.
[S] So comorbidity, which is arguably the hardest thing about real medicine, is filtered out by construction.
[G] Yes. I think that is the single most consequential sentence in the appendix.
[O] Then there is the bias layer.
[G] Twenty-three bias prompts, eleven for the patient and twelve for the doctor, split into cognitive and implicit. Cognitive covers recency, frequency, false consensus, self-diagnosis on the patient side, plus status quo and confirmation on the doctor side. Implicit covers gender, race, sexual orientation, culture, education, religion, and socioeconomic background.
[S] The introduction says twenty-four.
[G] The introduction says twenty-four, the discussion says twenty-three, and the appendix lists twenty-three. A small thing, but it is the kind of bookkeeping that tells you how carefully a benchmark's own counts were checked.
[O] And the biases go into the system prompt rather than as a prefix on the question.
[G] Which is the real methodological improvement over the authors' own earlier work. Previously a cognitive bias was a snippet pasted in front of the question. Here it lives in the role, so it can express itself gradually through the interaction, which is much closer to how bias actually operates in a consultation.
[S] And the toolbox.
[G] Six tools. Zero-shot chain of thought, one-shot chain of thought, reflection cycles, adaptive retrieval over eighteen medical textbooks, adaptive retrieval over the web, and a notebook.
[O] Explain the notebook, because that is the one that produced the biggest effect.
[G] The notebook is persistent memory across cases. After each encounter the model is shown the dialogue, its own diagnosis, and the correct one, and asked to update a set of notes, capped at one thousand characters, that carry forward to the next patient. The prompt is unusually specific about what not to write. It explicitly forbids disease-specific notes, and even gives a worked example of a forbidden note about myasthenia gravis, on the grounds that the model will never see that patient again. What it wants is procedural, along the lines of, the previous patients gave vague answers, so I should ask more descriptive questions.
[S] So it is learning interviewing strategy, not medicine.
[G] That is exactly the distinction, and it is why the result is worth taking seriously.
[O] Give me the leaderboard.
[G] On AgentClinic-MedQA, with GPT-4 playing patient and measurement throughout, Claude three point five Sonnet leads at sixty-two point one percent. OpenBioLLM seventy B at fifty-eight point three. Three human physicians at fifty-four. GPT-4 at fifty-one point six. Then Mixtral at thirty-seven point one, GPT-3.5 at thirty-six point six, GPT-4o at thirty-four point two, MedLlama3 eight B at thirty-one point four, Meditron seventy B at twenty-nine point one, PMC-Llama seven B at twenty-three point six, Llama 3 seventy B at nineteen, and Llama 2 seventy B chat at four point five.
[S] Stop at the human row. Three physicians, and the reported interval is plus or minus twenty-eight point five.
[G] Correct, and I want to be emphatic. With three participants and an interval that wide, that row cannot support a comparison between models and clinicians in either direction. It is a sanity check that the task is doable at all, and nothing more.
[O] Noted, and I will not use it. What happens on the health record set?
[G] The ranking reshuffles, which is the more interesting result. Claude drops to forty-two point nine. GPT-4 to thirty-four. But PMC-Llama seven B goes up, from twenty-three point six on MedQA to thirty-four point three here, essentially level with GPT-4. And Llama 3 seventy B collapses to eight point five.
[S] So the two case sets rank models differently.
[G] They do, and that is the paper's methodological claim in miniature. It also reports the headline version directly: MedQA accuracy is only weakly predictive of AgentClinic-MedQA accuracy, and for the worst-affected models the interactive accuracy falls to below a tenth of the static one.
[O] Do they explain the mechanism, or only observe the gap?
[G] They do better than observe, and this is the result I think is most underrated in the paper. They took GPT-4 dialogues and manually scored coverage, meaning what fraction of the relevant information in the original vignette the doctor actually extracted through conversation. Average coverage was sixty-seven percent. In cases it got right, seventy-two. In cases it got wrong, sixty-three.
[S] That is a real mechanism. The model is not failing at reasoning, it is failing at acquisition.
[G] That is my read, and the interaction-budget sweep supports it. At twenty interactions GPT-4 sits at fifty-two percent. Cut to fifteen and it falls to thirty-eight. Cut to ten and it falls to twenty-five.
[O] And going the other way?
[G] It gets worse, not better. Twenty-five interactions gives forty-eight percent, thirty gives forty-three. The authors attribute that to growing context length.
[S] Now the part I care about most. How much of a score belongs to the doctor model and how much to the patient model?
[G] Measurably some belongs to the patient. Holding GPT-4 as the doctor, a GPT-4 patient yields fifty-two percent, a GPT-3.5 patient forty-eight, a Mixtral patient forty-six. Inspecting dialogues, they found the weaker patient agents tend to parrot the question back rather than volunteer information.
[S] So a more informative patient makes the doctor look better. There is a confound baked into the environment itself.
[G] There is, and there is a sharper version of it. A GPT-3.5 doctor with a GPT-4 patient scores thirty-eight percent, and a GPT-3.5 doctor with a GPT-3.5 patient scores thirty-seven. Nearly identical, when the better patient should have helped substantially. The authors connect this to Panickssery and colleagues, on models recognising and preferring their own output.
[O] Which cuts against every model that is not GPT-4, since GPT-4 plays the patient throughout the main table.
[G] It is a plausible reading, and the paper raises it as a limitation. It does not run the control that would settle it.
[O] Languages.
[G] Seven, and the spread is enormous. Claude averages forty-eight point four percent across them. The next best average is GPT-4 at twenty point nine, then GPT-4o at twenty point five, GPT-3.5 at nineteen point five, Llama 3 seventy B at six point two, and GPT-4o-mini at four point one.
[S] Within-model spread?
[G] Larger still. GPT-4 goes from forty point two in English to eleven point two in Chinese. GPT-4o from thirty-five point five in English to three point seven in Korean. GPT-3.5 hits one point nine in Persian. Llama 3 scores zero in Spanish. And Claude's worst language, Chinese at forty-two point nine, is still higher than any other model's best language.
[O] That is a genuinely large capability gap and I do not think it is widely appreciated.
[S] It is also exactly the gap that should stop anyone generalising an English benchmark result to a multilingual deployment.
[G] Those two statements are compatible and I would sign both.
[O] Specialties.
[G] Nine of them. Claude averages sixty-six point seven, peaking at seventy-eight point three in internal medicine. GPT-4 averages fifty-five point seven, strong in gynecology at sixty-eight point five and ophthalmology at sixty-five point two, weak in emergency medicine at thirty-two point three and geriatrics at forty. And there is an inversion worth flagging. The specialties that are hardest in the multiple-choice literature are not the ones that are hardest here.
[S] Which is either a real finding about dialogue, or an artifact of which cases they sampled.
[G] The paper argues the former and does not rule out the latter.
[O] Tools. This is where I expect the most useful result for anyone actually building.
[G] It is, and the shape is that tools are model-specific rather than universally good. Llama 3 seventy B gains the most from anything in the study: the notebook takes it from a twenty-one point four baseline to forty-one point one. That is nineteen point seven points absolute, or ninety-two percent relative, which is the figure quoted in the abstract.
[O] A model nearly doubling its accuracy from persistent procedural notes is a striking result.
[G] It is, and it is consistent with how that prompt was designed, since the notes are about how to interview rather than about diseases.
[S] And the other direction?
[G] GPT-3.5 loses accuracy on every single tool. Its worst is retrieval over textbooks, which takes it from thirty-six point three down to twenty-seven point one, a drop of nine point two points. Claude loses thirteen points from reflection, down to forty point two, and that is the one cell where GPT-4 beats it, at forty-two point two.
[S] Clara, I want to flag something in that table. The implied no-tool baselines are Claude at fifty-three point two and GPT-4 at forty point two. But the headline leaderboard has them at sixty-two point one and fifty-one point six.
[G] You are reading the table correctly, and the paper does not reconcile those two sets of baselines anywhere I can find. The tool deltas are internally consistent, but they are not measured against the configuration that produced the headline numbers.
[O] That is a real gap in the write-up and I will not defend it.
[S] There is a second one. The results text says retrieval over textbooks led to a twenty-seven point one percent drop for GPT-3.5. Twenty-seven point one is the resulting accuracy. The drop is nine point two.
[G] Also correct. The table is right and the sentence describing it is wrong.
[O] The bias study.
[G] Run on two models only, GPT-4 and Mixtral, with unbiased baselines of fifty-two and thirty-seven percent. For GPT-4 the effect on accuracy is small: the largest single absolute drop is four points and the average is one point five. Mixtral degrades much more, with doctor-side cognitive bias taking it from thirty-seven down to twenty-nine.
[S] Two of eleven models, and neither of them is the model that tops every other table in the paper.
[G] That is right. There is no bias data on Claude three point five, which is the model a reader would most want it for.
[O] Is GPT-4's robustness real?
[G] The authors themselves doubt it, and I find their doubt persuasive. In the gender bias condition they logged twenty-five occurrences out of two hundred and fifteen dialogues where GPT-4 verbosely refused to follow the bias instruction. So part of what that flat accuracy line measures is refusal to role-play, not resistance to bias. Their own sentence is that this does not mean GPT-4 is free of said biases.
[S] So the honest read is that GPT-4 is a poor instrument for studying bias, not that it is unbiased.
[G] That is what they conclude, and they suggest Mixtral as the better instrument for the purpose.
[O] But accuracy was not the only thing measured, and this is the part I find most interesting in the entire paper.
[G] Right. After every encounter the patient agent is asked three questions on a one to ten scale: confidence in the doctor's assessment, likelihood of following through with therapy, and likelihood of consulting this doctor again. There the picture changes completely. Implicit biases barely move diagnostic accuracy but substantially lower all three ratings, with education bias the most damaging across the board.
[S] And the ordering?
[G] Sexual orientation bias had the smallest effect, then race, then gender, then religion, socioeconomic, cultural, and education. Among the cognitive biases only self-diagnosis moved the ratings much, dropping confidence by four point seven points and consultation by two.
[O] So a purely accuracy-based evaluation scores that encounter as a success and misses the harm entirely.
[G] That is the argument, and I think it is the most valuable idea in the paper. But hold the caveat firmly: those ratings come from a language model asked to report how a biased patient would feel. It is a model's prediction of a human reaction, not a human reaction.
[S] Which is precisely the sort of proxy that gets quietly promoted into a metric two papers later.
[G] The authors say as much themselves, that these agents may not fully capture real patients, and they offer it as a way to study bias in simulation rather than as a measurement of patient experience.
[O] Multimodal.
[G] One hundred and twenty case challenges, four models, and the multiple choice options a human reader would get are withheld, so it is fully open-ended. With the image supplied up front: Claude at thirty-seven point two, GPT-4 at twenty-seven point seven, GPT-4o at twenty-one point four, GPT-4o-mini at eight.
[S] And when the model has to ask for the image?
[G] Everything drops a couple of points. Claude to thirty-five point four, GPT-4 to twenty-five point four, GPT-4o to nineteen point one, mini to six point one.
[O] A smaller effect than I expected, honestly.
[G] Smaller than I expected too. The breakdown by image type is where it gets stark. On the twelve radiography cases GPT-4 scored zero. On the six MRI cases GPT-4 scored zero. On biopsy images it scored fifty percent, and on physical photographs thirty-one point four.
[S] Those are tiny cells. Six MRI cases is not a finding.
[G] Agreed on the sample sizes. I would treat that whole breakdown as descriptive, not inferential.
[O] And there was one detail I liked, about what happened when GPT-4 was wrong.
[G] Sixty percent of the time its incorrect answer was still among the multiple choice options it was never shown. So it lands in the right differential and picks the wrong item out of it.
[S] What did actual clinicians make of these dialogues?
[G] Three physicians rated twenty dialogues on a one to ten scale. Doctor realism six point two, patient realism six point seven, measurement realism six point three, and empathy five point eight. The comments are specific. The doctor agent opens badly, cuts straight to symptoms without an inviting question, and sometimes fixates. The patient agent is overly verbose and repeats questions back. The measurement agent occasionally omits values, and one reviewer noted it returned only a hematocrit and a leukocyte count for a complete blood count while omitting the clotting factor assays that had been requested.
[S] Three raters again, and no inter-rater agreement reported.
[G] No agreement statistic, correct. Roughly six out of ten from three readers is a moderate and uncertain verdict on realism.
[O] Clara, you promised us an appendix number at the top of the show.
[G] Appendix G. They ran o1-preview on AgentClinic-MedQA and it scored eighty point six percent, against Claude's sixty-two point one. They could not run it across the rest of the benchmark because inference cost roughly twenty times GPT-4o and Claude.
[S] Eighty point six.
[O] That is the number that reframes the paper for me, and it cuts in my direction. Whatever the interactive gap was measuring, a reasoning model closes most of it.
[S] Or a reasoning model is better at the specific thing this benchmark rewards, which we have just spent twenty minutes establishing is partly a function of who plays the patient and who does the grading.
[G] Both readings are live. What I would say is that the headline framing, that dialogue-based diagnosis is dramatically harder, is a claim about a model generation, and the paper's own appendix shows the gap is not fixed. And note it is one number, on one case set, with an interval of plus or minus five point six.
[O] Let me make the optimist case cleanly. This paper does something almost nobody does. It takes a saturated benchmark, changes only the interaction format, and shows the ranking does not survive the change. That is a reusable open-source instrument, and the coverage analysis tells you exactly where the loss happens.
[S] And the deflationary case. Every number is produced inside a GPT-4-authored, GPT-4-populated, GPT-4-graded environment, on cases filtered to have exactly one diagnosis, with a three-person human baseline that means nothing, a bias study covering two of eleven models, a tool study whose baselines do not match the main table, and self-reported feelings from a language model standing in for patient trust.
[G] Let me score it. On the central claim, that static multiple-choice accuracy does not predict interactive diagnostic accuracy, the optimist wins, and the coverage numbers give it a mechanism rather than only a correlation. On the leaderboard as a ranking of clinical capability, the skeptic wins outright, and I would go further: no ranking in this paper should be read that way.
[O] Take the middle ones.
[G] The tool result is the most transportable finding here, because the direction of the effect flips by model, and that is a fact a practitioner can use immediately. Point to the optimist, with the baseline discrepancy docked against it. The bias result splits: the accuracy half is undermined by refusal behaviour and a two-model sample, while the patient-perception half is a genuinely novel measurement that a static benchmark cannot express at all, even though its instrument is synthetic. The multilingual result is the most robust of the sub-studies, simply because the effect sizes are enormous.
[S] And the thing neither of us can test from outside.
[G] Contamination. The authors flag that GPT-4, GPT-4o, GPT-3.5, and Claude three point five may have trained on MedQA, and note that only Mixtral and Llama 2 seventy B chat are confirmed not to have. Their counter-evidence is that MedQA accuracy does not predict AgentClinic accuracy, which shows the two evaluations diverge. It does not show that neither score is inflated.
[O] What would settle it?
[G] A direct probe. Membership inference, canary strings, or working with the model developers. That indirect argument is the weakest link in an otherwise carefully hedged paper.
[S] So what does this change for how we run evaluations?
[G] Three things in my view. First, the format of an evaluation is a variable, not a wrapper. Convert a static item into an interactive one and you can lose most of the score without changing the underlying knowledge at all. Second, in any multi-agent evaluation the environment models are part of the measuring instrument, and the patient-model sweep in this paper demonstrates that cleanly. Third, and this is the one I would carry furthest, accuracy is not the only observable an interactive evaluation produces. The encounter also produces trust, compliance, and willingness to return, and those moved when accuracy did not.
[O] The generalisation being that interactive benchmarks give you outcome metrics a multiple-choice benchmark structurally cannot have.
[G] Yes, and the discipline that has to come with it is validating those metrics against humans before treating them as ground truth.
[S] And to be very clear about the domain, because this one is not like benchmarking code generation.
[G] Let me say it plainly. Nothing in this paper is clinical evidence. The best score on the main table is sixty-two percent inside a simulation with a synthetic patient, synthetic lab results, and a model-based grader, on cases pre-filtered down to a single diagnosis. The paper's own introduction says these models are not designed to replace medical practitioners. Anyone reading a number off this benchmark as a statement about whether a model is fit to diagnose a person has misread it, and I think the authors would say so first.
[O] Agreed without reservation.
[S] Same.
[O] Takeaways. Mine is that changing the interaction format is the cheapest way to find out whether a saturated benchmark was ever measuring the capability its name claims, and this paper is the template for doing it.
[S] Mine is that when the patient, the instrument, and the grader all come from the same model family, the leaderboard measures an interaction as much as a capability, and the paper's own patient-model sweep proves it.
[G] And the paper's own takeaway is in its abstract. Solving these problems in a sequential decision-making format is considerably more challenging, with accuracies that can fall to below a tenth of the original. Everything else in it, the biases, the tools, the languages, the images, is exploratory evidence built on top of that one finding.
[O] The full write-up, with the figures, the tables, and the citation graph, is on the litsearch site. We will see you next time.
