---
slug: zadeh-2019-social-iq
title: "Social-IQ: A Question Answering Benchmark for Artificial Social Intelligence"
description: "Fifty annotators, fourteen months, and 1,250 unscripted YouTube clips turned social intelligence from a sentiment score into open-ended question answering — opening a thirty-point gap between humans and the best 2019 model that the benchmark's own design cannot fully explain."
date: 2026-07-25
guest_name: "Nadia"
guest_voice: "af_bella"
---
[S] A benchmark reports its best model at sixty four point eight two percent and humans at ninety five point zero eight percent, and calls the thirty point gap the headline finding.
[O] Which it is. That is an enormous gap for a task where random guessing gets you fifty.
[S] Except the paper's own results section says the human number was calculated during the validation stage. By the same trained annotator pool that wrote the questions.
[O] And I still think it is the most careful dataset construction of its year, which is exactly why that detail is worth arguing about instead of waving through.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Our guest is Nadia.
[S] The paper is Social-IQ, A Question Answering Benchmark for Artificial Social Intelligence, from Amir Zadeh, Michael Chan, Paul Pu Liang, Edmund Tong, and Louis-Philippe Morency, at Carnegie Mellon's Language Technologies Institute and Machine Learning Department. CVPR twenty nineteen.
[O] About a hundred eighty citations, and it is on the docket because a lot of newer work, SOTOPIA and MMToM-QA among them, cites it as the thing they are moving past. Nadia, welcome.
[G] Thank you. And I would start by saying the framing you just used is the right one. This paper is more interesting as a historical marker than as a leaderboard, and it is a genuinely instructive one.
[S] Set up the gap. What did social intelligence mean in machine learning before this?
[G] A number. Almost entirely a number. The dominant resources were CMU-MOSEI, MOSI, and their relatives, which reduce a social moment to a valence score or a discrete emotion tag. The paper's word for this is numeric supervision, and its argument is that numeric supervision is structurally incapable of expressing why a room is tense, or how two people are managing a disagreement.
[O] Because those answers are sentences, not scalars.
[G] Right, and the authors go further and say that unconstrained language is what opens the door to explainable social intelligence. A model that answers why is a model whose reasoning can in principle be inspected. A model that emits a valence number cannot be interrogated at all.
[S] Question answering as a probe was not new though.
[G] Not at all, and the related work is honest about the lineage. DAQUAR, then COCO-QA, VQA, FM-IQA, Visual7W for images. Then MovieQA and TVQA extending it to video. The claim is not that video QA is new. The claim is that none of those probe social reasoning specifically.
[O] MovieQA and TVQA are about plot.
[G] Events and their ordering, essentially. And the paper adds a second objection to those two that I think is the sharper one. Movies and television are scripted and rehearsed. Social behavior in scripted drama is compressed and stylized. So Social-IQ deliberately scrapes ordinary YouTube instead. Talk show panels, pranks, family arguments.
[S] There is a third objection buried in there about annotators.
[G] There is, and it is a contamination argument before the field had the vocabulary. If your benchmark is built on famous movies, your annotators may already know the plot, and so a model that has absorbed cultural knowledge about that movie can get credit without watching anything. Arbitrary YouTube clips are unlikely to have been seen by the annotator beforehand.
[O] That is a genuinely good instinct for twenty nineteen.
[S] It is. And I want to note it does nothing about the modern version of the problem, which we will come back to.
[O] Nadia, the part I want you to spend time on is the taxonomy. Because this is not a paper that just collected data and hoped.
[G] It is not, and this is the real contribution in my view. Before collecting anything, they define four criteria drawn from psychology and sociology, going back to Thorndike in the nineteen twenties and Thelma Hunt in nineteen twenty eight on measuring social intelligence. A question is admissible only if it satisfies at least one of the four.
[O] Walk them.
[G] One, judgment in social situations. They define a social situation following Sztompka and Max Weber as a social exchange involving two or more individuals with physical movement, intentions, and interactions in response to one another. Example question, are the people in this group getting along.
[S] Two?
[G] Processing human intelligent behavior. How and why people act or react. Their example is, why does the woman pretend to not hear the man. And crucially, they explicitly exclude action recognition. Is the man lifting weights is a rejected question, because it does not probe social intelligence at all.
[O] That exclusion is doing a lot of work. Most video QA datasets are full of exactly those questions.
[G] They are, and it is why Social-IQ's question type distribution looks so different, which we will get to. Third criterion is understanding mental state, trait, attitude, and attributes, where they carefully separate traits as stable personality characteristics from states as temporary situation-dependent feelings, citing Chaplin, John, and Goldberg. Example, does the man in the black robe seem like he can manage high stress.
[S] And the fourth is the one I did not expect.
[G] Memory for referencing and grounding. In real social situations you often do not know anyone's name, so humans establish common ground by description. The man with a tense voice. The woman who was sad when coming into the house. Social-IQ requires references to be resolvable from the video itself, and explicitly rejects names that cannot be inferred from what you are watching.
[O] So the benchmark bans the shortcut of identity lookup.
[G] It does. And there is a global constraint on top of all four. Every question must be about humans. Questions about objects, inanimate entities, or animals are rejected. Their contrast is nice, what is the man picking up is rejected, is the man lifting the box under pressure is accepted.
[S] Now the pipeline, because fourteen months is a real number and I want to know where it went.
[G] Six stages, fifty annotators, all hired and trained Carnegie Mellon undergraduates, over fourteen months across three annotation seasons. Stage one, video acquisition. Two thousand candidate videos from YouTube under Creative Commons, using a broad search term set following the precedent of CMU-MOSEI's two hundred fifty diverse terms, with a hard filter requiring a face detected by MTCNN in at least eighty percent of frames.
[O] Stage two prunes hard.
[G] Two trained annotators independently inspect each video to confirm a genuine social situation is present, looking for interaction, opinion sharing, communication. That cuts two thousand to twelve hundred fifty. And the multimedia statistics are worth stating, because they surprise people. Twelve hundred thirty nine minutes of annotated content, drawn from ten thousand five hundred twenty nine minutes of full video.
[S] So they are annotating roughly twelve percent of the footage they downloaded. These are short clips.
[G] Roughly a minute each on average, yes. And all of them carry manual transcriptions with detailed timestamps.
[O] Stages three through six are the question and answer machinery, and the disjointness is the point.
[G] It is the whole point. Question creation, two trained annotators each write three questions per video, plus one correct and one incorrect answer for each, and tag everything with a complexity label. Question validation, a separate pair of annotators checks each question against the four criteria. If either disputes it, the question is removed and sent back for re-annotation.
[S] So rejection is a loop, not a discard.
[G] A loop, correct. Then the answering stage, two more annotators, different from both the creators and the validators, split the six questions between them. Each writes three correct and two incorrect answers for their questions, and critically they do this blind to the answers written during question creation.
[O] So you get diversity of correct answers rather than one canonical one.
[G] That is the design goal, and it is why the arithmetic lands where it does. Each question ends with four correct answers, three from the answering stage plus one from creation, and three incorrect, two plus one. Then a final answer validation stage, again a disjoint pair, checks that correct answers are actually correct, that incorrect ones are actually incorrect, that they are diverse, and assigns complexity labels.
[S] Give me the totals.
[G] Twelve hundred fifty videos. Seven thousand five hundred questions, exactly six per video. Thirty thousand correct answers and twenty two thousand five hundred incorrect, so fifty two thousand five hundred total.
[O] And the annotator management is unusual enough to mention.
[G] Three training stages, then continuous weekly supervision by the authors, eight annotation workshops over the year, and individual retraining meetings for annotators whose work quality dropped. And the incentive design is the part I find most thoughtful. Monetary bonuses were tied to the creativity and novelty of annotations, not to throughput.
[S] That is the opposite of how crowdsourced datasets usually go wrong.
[G] It is, and it shows up in the statistics.
[O] Which are the argument, honestly. Give us the dataset's self-portrait.
[G] Questions average ten point eight seven words. Answers average ten point four six words. The paper compares that to prior multimodal QA datasets where average answer length runs between one point two four and five point three words, and describes its own answers as longer by nearly a factor of one hundred percent.
[S] So roughly double the longest prior dataset and eight times the shortest.
[G] Yes. And the question type distribution is the sharper number. Why questions are thirty four percent of the dataset and how questions twenty six percent. Together, sixty percent of all questions are causal.
[O] Compared to what?
[G] The paper's claim is that prior video and image QA benchmarks are dominated by what, meaning object questions, and who. In Social-IQ, what is only fifteen percent and who is one percent.
[S] One percent. That is the referencing criterion doing its job, isn't it. You cannot ask who when names are banned.
[G] Exactly right, and I do not think the paper connects those two facts explicitly, but they are the same design decision seen from two sides.
[O] And complexity?
[G] Forty one percent advanced, forty percent intermediate, nineteen percent easy. So eighty one percent of the dataset sits in the top two tiers by the annotators' own subjective rating.
[S] Which is a self-report from the people incentivized for creativity. I am not saying it is wrong. I am saying that number is not independent of the incentive structure you just praised.
[G] That is a fair objection and the paper does not defend against it. There is no external check on the complexity labels.
[O] Let's do the experiments, and I want to start with the bias probes because that is the part I most respect.
[G] Four probes, each an LSTM encoder over the given modalities with answers conditioned on the concatenation, following TVQA's setup. Question plus answer only, no video, no audio, no transcript, using BERT embeddings, scores fifty seven point zero two percent binary accuracy against a fifty percent floor.
[S] Seven points above chance from text alone.
[G] Seven points. Then question plus answer plus transcript, fifty seven point eight seven. Question plus answer plus acoustic features from COVAREP, fifty seven point two two. And question plus answer plus visual features from DenseNet-161, sixty three point nine one.
[O] There it is. That is the number I would put on the slide. Adding transcript buys you under a point. Adding audio buys you nothing. Adding vision buys you almost seven.
[G] And the authors' reading is that answering Social-IQ requires both commonsense and context, and that the visual channel carries the most context. I would put it more strongly. That single comparison is the best evidence in the paper that the benchmark is actually multimodal rather than a text benchmark with video attached.
[S] I will grant that, and it is genuinely rare. Most so-called multimodal benchmarks do not survive that ablation. But I want to push on the seven-point text-only signal, because the paper describes it as minimal bias and I think that is too generous.
[G] Say more.
[S] Seven points above chance with no video at all means there is a detectable stylistic signature separating correct from incorrect answers. And it is not mysterious where that comes from. Correct and incorrect answers are written by the same annotator in the same sitting, with correct ones drawn from what they believe and incorrect ones invented as foils. Invented foils read differently.
[G] The paper does show that correct and incorrect answer lengths follow the same distribution, which rules out the crudest version of that, length. But you are right that it does not rule out subtler stylistic tells, and it does not run an adversarial filtering pass in the style of SWAG or HellaSwag, which is what you would do to strip those.
[O] To be fair, HellaSwag is a twenty nineteen paper too. That technique was arriving at the same moment.
[G] Correct, and I would not fault a CVPR twenty nineteen submission for not having it. I would fault a twenty twenty six citation for not mentioning it.
[S] Fine. Now the model results, which are the weakest part of the paper.
[G] Seven architectures ported from the MovieQA, TVQA, and CMU-MOSEI leaderboards. Layered Memory Network at sixty one point one two. Focal Visual-Text Attention at sixty point eight eight. End-to-end memory networks at sixty two point five eight. Multimodal Dual Attention Memory at sixty point two three. Multi-stream Memory at fifty nine point nine six. Tensor Fusion Network at sixty three point one five. Memory Fusion Network at sixty two point seven eight.
[O] A tight cluster. Everything between roughly sixty and sixty three.
[G] Then their own contribution, Tensor-MFN, at sixty four point eight two binary and thirty four point one four on the four-way multiple choice, where chance is twenty five.
[S] Nadia, what is Tensor-MFN?
[G] The paper's own description is that it was created by performing architecture and hyperparameter search on TFN and MFN and combining them into a joint model. Concretely, it uses DenseNet-161 scene embeddings and tensor fusion inside the recurrent stages of MFN.
[S] So the best model on this benchmark is a hyperparameter search over two existing fusion architectures, neither of which was designed for social reasoning, and it beats the plain visual bias probe by less than one point.
[G] Sixty four point eight two against sixty three point nine one. Under a point.
[O] That is uncomfortable and I am not going to pretend otherwise.
[S] It is more than uncomfortable. Every one of the seven so-called state of the art models loses to the naive question-plus-answer-plus-vision LSTM baseline except the one the authors built. So the entire model comparison is telling us that sophisticated fusion architectures from MovieQA and TVQA transfer worse than a simple concatenation.
[G] That is a correct reading of Table one and I will not soften it. What I will say in the paper's defense is that this cuts against reading the thirty point gap as a measure of the task's difficulty specifically. It is at least partly a measure of pre-CLIP, pre-video-transformer multimodal fusion in general. There is no large pretrained multimodal model anywhere in this table, because in twenty nineteen there was not one to run.
[O] So the honest statement is that the gap is real but underdetermined. We know twenty eighteen-era fusion cannot do this. We do not know from this paper what would have.
[G] That is exactly the honest statement.
[S] Now the human number, which is where I started and where I want to end up.
[G] Two things the paper says about it, and they sit in slight tension. In the baseline description, the human row is defined as annotators who had not seen the question or the video beforehand, picking the correct answer in the binary format, the same setup as the models. In the results section, one sentence says human performance was calculated during the validation stage.
[S] Those cannot both be fully true in the way a reader will assume. Validation-stage annotators are trained on the four criteria, drawn from the same fifty-person pool, and immersed in the dataset's conventions for months.
[G] I think both can be literally true, and that is the problem. A validator can be seeing a specific video for the first time while still being deeply calibrated to how this dataset's questions and foils are written. The paper does not distinguish those, and it should have.
[O] What would settle it?
[G] Inter-annotator agreement, which is not reported anywhere. There is no kappa, no percent agreement, no variance around the ninety five point zero eight. It is a single point estimate with no error bar and no independent-rater control.
[S] For a paper whose entire argument rests on the size of the human-model gap, that is a significant omission.
[G] It is, and it is the single change I would most want. A batch of naive raters with no exposure to the criteria, scored on the same binary task, with agreement statistics. That number might be ninety five. It might be eighty.
[O] There is one more thing missing that I only noticed reading the paper cover to cover.
[G] Go ahead.
[O] There is no train, validation, and test split stated anywhere in the paper. It reports accuracies for thirteen models and never says what they were evaluated on.
[G] That is right, and I checked. The word split appears twice in the paper, once about splitting the statistics section into three parts and once about splitting annotator training into three stages. There is no data split described. The release includes features and presumably a split convention, but the paper as published does not state it.
[S] Which means the numbers in Table one are not reproducible from the paper alone.
[G] From the paper alone, no. That is a real reproducibility gap, and it is the kind of thing that was more tolerated in twenty nineteen than it should have been.
[O] Alright. Closing arguments. I will make the optimist case and it is not about the numbers.
[S] Please.
[O] Social-IQ is a measurement design paper wearing a dataset paper's clothes. It starts from psychometrics rather than from what is easy to annotate. It writes down four admissibility criteria before collecting anything and enforces them with a disjoint validation loop. It bans action recognition and identity lookup, the two shortcuts that would have made the task easy and meaningless. It pays for creativity instead of throughput. And it runs the ablation that would have embarrassed it, the text-only probe, and reports the result. That is a template, and the template outlived the numbers.
[S] My case. The headline is a thirty point gap whose two endpoints are both shaky. The model endpoint is a hyperparameter search over pre-transformer fusion methods that barely beats a naive baseline, so it measures the state of multimodal fusion in twenty eighteen more than it measures the task. The human endpoint has no error bar, no agreement statistic, and was computed by the dataset's own trained annotators. The evaluation is discriminative, picking from a fixed pool of four, despite an explainability pitch that would require generation. There is no stated data split. And the contamination story has inverted since publication, because these are unmodified public YouTube videos whose transcripts and comments may well sit in every modern pretraining corpus.
[G] My adjudication. The taxonomy and the pipeline are the durable contribution and I score that entirely to the optimist. The bias ablation is real evidence that the benchmark is genuinely multimodal, and the vision lift of nearly seven points against under one point for transcript is the strongest single result in the paper. The model comparison I score to the skeptic without reservation. The human ceiling I score to the skeptic on rigor, while noting the direction is almost certainly right even if the magnitude is not. And there is one limitation neither of you named that I think matters most for how this paper gets cited today. Social-IQ asks a model to judge a social situation that has already finished. It never asks a model to behave inside one. Acing Social-IQ demonstrates you can evaluate someone else's social conduct after the fact, which is a different and easier thing than producing competent social conduct of your own under live pressure. That is precisely the gap SOTOPIA was built four years later to fill, and it is why this paper reads best as the thing that made the next question askable.
[O] Nadia, thank you. The full write-up with the figures and the full results table is on the litsearch site under Zadeh twenty nineteen Social-IQ.
