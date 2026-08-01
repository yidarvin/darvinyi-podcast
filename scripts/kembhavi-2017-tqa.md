---
slug: kembhavi-2017-tqa
title: "Are You Smarter Than A Sixth Grader? Textbook Question Answering for Multimodal Machine Comprehension"
description: "TQA puts a whole middle-school science curriculum behind twenty-six thousand questions, and the era's best attention models barely clear the floor."
date: 2026-08-01
guest_name: "Maeve"
guest_voice: "bf_lily"
---
[O] Here is the number that made me sit up. On the true-false questions in this dataset, the two models that were actually scored on them land at fifty point two percent and fifty point four percent. The random floor is fifty point zero.
[S] Above the floor. By two tenths of a point, and four tenths of a point. That is not a system answering questions. That is a coin with a very faint opinion.
[O] And I think that is the achievement. Somebody built a benchmark where the standard machinery of the era bought you essentially nothing, and then published it that way instead of tuning until it looked respectable.
[S] Or somebody built a benchmark and evaluated it exclusively with models they wrote themselves. I would like to know which of those two stories this is before I get excited.
[O] Welcome to Litsearch Audio. I am the optimist, that is our resident skeptic, and today's paper is Are You Smarter Than A Sixth Grader? Textbook Question Answering for Multimodal Machine Comprehension.
[S] Kembhavi, Seo, Schwenk, Choi, Farhadi and Hajishirzi, from the Allen Institute for Artificial Intelligence and the University of Washington, at CVPR twenty seventeen. The dataset is called TQA, for Textbook Question Answering.
[O] And joining us is Maeve, who has read this one closely. Maeve, welcome.
[G] Thank you. Before either of you quotes another number at me, I want one ground rule on the table, because this paper is unusually easy to misreport and the mistake is always the same shape.
[S] Go on.
[G] Every result here belongs to a specific population of questions, and there are two independent splits. Text questions versus diagram questions, and within those, true-false versus multiple choice. Separate cells, separate chance rates. They do not average into each other in any meaningful way.
[O] Because true-false has a fifty percent floor and multiple choice does not.
[G] Exactly. And there is a second population trap, about the models rather than the questions. The results table has four model rows plus a random baseline row, and only two of the four model rows have a text score at all. So any sentence beginning with all four baselines, or every model, is almost certainly false about the text columns. I will name the population on every number I give you.
[S] Noted, and I will hold you to it. So set the scene. Twenty seventeen. What was broken?
[G] Two communities sprinting in parallel, neither able to see the other's problem. Textual machine comprehension had SQuAD and the cloze datasets, where the knowledge you need is a short block of prose. Visual question answering had a family of datasets built on Microsoft COCO images, where the knowledge you need is one photograph.
[O] And the complaint about that split is architectural, not aesthetic.
[G] It is. The authors write that in the conventional setup the context is usually about a single modality, either language or vision. Their claim is that world knowledge is not sorted that way. It is spread across text documents, images and videos, and a system that can only read, or only see, is answering a narrower question than the one it advertises.
[S] Here is where I push. Extending the context to pictures sounds like a rebranding of V Q A with more pixels. What is the actual technical difference?
[G] Bounded knowledge, and they make the argument using V Q A's own example. They quote a question from that dataset, does this person have twenty twenty vision, and point out that answering it requires detecting eyeglasses and then applying an outside common-sense fact, that people with perfect vision do not usually wear them. That fact is not in the image and not in the supplied context. In practice the model has absorbed it from the training split.
[O] So the knowledge requirement is unbounded, and you cannot tell comprehension from memorisation.
[G] That is their argument. Their alternative task, which they call Multi-modal Machine Comprehension, or M three C, requires that the knowledge be, in their phrase, bounded to the multi-modal context supplied with the question.
[S] That I grant is a real methodological distinction. If the answer is provably in the context you handed the model, a wrong answer is a comprehension failure and not a missing-fact failure. You have removed a confound.
[O] So why textbooks?
[G] Because they wanted contexts that were hard rather than merely long. They argue that the textual and diagrammatic content in middle school science reference fairly complex phenomena that occur in the world, which they say makes it a good test bed for the M three C paradigm. Science diagrams encode processes and systems. A photograph of a kitchen does not.
[S] Tell me how it was built. Provenance is where I usually find the problems.
[G] The lesson content comes from C K twelve, a public middle-school curriculum site, downloaded wholesale in August of twenty sixteen. Life Science, Earth Science and Physical Science. One thousand seventy six lessons.
[O] And a lesson is not just a paragraph.
[G] No, it is a bundle. Body text, diagrams and natural images, a vocabulary section defining the lesson's scientific terms, and a lesson summary typically held to five sentences. Across all one thousand seventy six lessons that is seventy eight thousand three hundred thirty eight sentences and three thousand four hundred fifty five images.
[S] And the questions?
[G] Twenty six thousand two hundred sixty, all multiple choice, with the number of choices varying from two to seven. Of those, twelve thousand five hundred sixty seven come with an accompanying diagram, and those are what the paper calls diagram questions. The rest are text questions.
[O] Twelve and a half thousand diagram questions is a serious visual set for the time.
[G] It is, but how they got there is worth dwelling on, because it is not one uniform pipeline. Most questions are lifted directly from C K twelve's own workbooks and quizzes. Diagram questions were scarce in that source, so the authors supplemented them separately.
[S] How.
[G] They pulled a list of scientific topics from each lesson, used those as queries to Google Image Search, downloaded the top results, and manually filtered them down to images matching the lesson content. That yielded, in the paper's words, two thousand seven hundred forty nine diagrams spread across eighty five lessons. Crowd workers were then shown the full lesson plus one of those diagrams and asked to write a middle-school science question that required the diagram to answer correctly and was answerable from the provided lesson.
[S] Stop there. That is a scraped-off-the-open-web path sitting inside a dataset whose selling point is that the knowledge is bounded and controlled. Those two thousand seven hundred forty nine diagrams were never part of the curriculum they claim to be testing.
[G] Fair reading, and the paper does not defend against it. It describes the sourcing plainly and then says nothing anywhere about licensing, attribution or copyright status, for either the curriculum content or the search-engine images.
[O] To be fair, that scrutiny largely postdates the paper.
[S] It does, and I am not calling it misconduct. I am saying that if you reuse this dataset today, those eighty five lessons are a different provenance class from the rest, and the paper gives you no handle to separate them.
[G] I would accept that. I would add one thing that cuts the other way. They also added a small set of what they call instructional diagrams, typically three to five per lesson, to the lessons that already had diagram questions, with crowd-written rich captions describing the concepts illustrated.
[O] Why?
[G] Because they found a genuine gap during construction. The lesson prose and image captions did not comprehensively describe what the diagrams showed. Their conjecture is that a teacher normally fills that gap out loud in class. So they wrote the teacher's explanation into the dataset rather than leave diagram questions unanswerable from context.
[S] Honest curation. It also quietly concedes the raw textbook alone was not self-contained.
[O] What about the splits? That is where multi-lesson corpora usually leak.
[G] They split at the lesson level, not the question level, so no lesson straddles the boundary. Six hundred sixty six lessons for training, two hundred for validation, two hundred ten for test. And they go further, because some lessons cover overlapping concepts, so they grouped concept-overlapping lessons together before splitting, in order, they write, to minimize the concept overlap between data splits.
[S] For twenty seventeen that is genuinely careful. More than most contemporaries did.
[O] Now the models. Four, and none of them new.
[G] Correct, and deliberately so. The paper adapts four existing architectures rather than proposing a fifth. The point is to show the gap, not close it. The first is Text Only, an extension of Memory Networks, which ignores all visual content. The interesting engineering detail is that it cannot fit a lesson in memory. A lesson often runs past a thousand words, and their own figure is that a single paragraph of five hundred twelve words at a batch size of thirty two can consume up to twelve gigabytes of GPU RAM.
[O] So what do they do?
[G] They retrieve. A T F I D F keyword-overlap score picks the single most relevant paragraph, and only that paragraph goes forward. Then an LSTM encodes the paragraph, the question and each answer choice, and attention scores every paragraph word against the question.
[S] So before the model reasons about anything, a bag-of-words retriever has thrown away most of the lesson.
[G] Yes, and they flag it themselves, pointing at hierarchical memory networks as the fix they did not implement. Hold that thought, because their own analysis section says how often the answer needs more than one paragraph.
[O] And the diagram models?
[G] Two of them extend Text Only. Text plus Image pushes the diagram through a V G G network pretrained on ImageNet and folds the last convolutional layer into the same memory. That output is a seven by seven grid of five hundred twelve dimensional patch vectors, forty nine in all, mapped down through two perceptron layers and concatenated onto the text so the question can attend over patches and sentences alike. The paper says this is similar to popular models employed in the V Q A paradigm.
[S] And the other one?
[G] Text plus D P G does something quite different. D P G is a diagram parse graph, a structured representation of objects and relationships from the authors' own earlier diagram parser, the A I two D work. Those graphs are mechanically translated into factual sentences. Their example is that if a mouse object and a cat object are connected in the graph, the translator emits the sentence, mouse is connected to cat.
[O] So they turn the picture into prose and feed it to the text pipeline.
[G] Precisely. The diagram enters as extra paragraph sentences and everything downstream is unchanged. The fourth model is BiDAF, which the paper describes as ranking second best on the SQuAD leaderboard at the time. It was built to predict an answer span, so they modify the output layer for multiple choice by comparing the predicted span against each option and taking the closest match.
[S] Structural complaint before the numbers. All four are the authors' own builds. Is there a single externally-published system in that table?
[G] There is not. No external-model baseline and no human baseline anywhere in the paper. I checked the full text for a human performance figure, and the only mentions of human subjects are crowd-sourcing and annotation, not an accuracy row.
[S] And BiDAF?
[G] Reference twenty one in this paper's own bibliography is Seo, Kembhavi, Farhadi and Hajishirzi. Four of the six authors of the paper we are discussing.
[S] So even the baseline that looks like an outside system is in-house.
[O] I will take that hit. Give us the table, Maeve, with the populations attached.
[G] Four measured columns. Text true-false, text multiple choice, diagram multiple choice, and a combined column labelled All. The first thing to say is that only two of the four model rows carry a text score. Text plus Image and Text plus D P G are printed as not-applicable in both text columns. They were only ever run on diagram multiple choice.
[S] So the two text columns describe Text Only and BiDAF, and nobody else.
[G] Correct. Text true-false first. The random baseline row sits at fifty point zero percent. Text Only reaches fifty point two. BiDAF reaches fifty point four. Both are above random, and both by less than half a point.
[O] I want care here, because I have seen this described sloppily. Nothing is below chance.
[G] Nothing is below chance. Both scored models are marginally above the floor, and the honest description is that the signal is indistinguishable from none. The authors' own sentence is that both the text models perform very poorly on true-false questions.
[S] Do they explain it, or just report it?
[G] They explain it. They write that most true-false questions in this dataset are not simple lookups but require paraphrasing, multiple sentences, reasoning to be answered correctly, which standard attention models are not good at. Their qualitative figure backs it with worked examples. One requires relating too high against below across several sentences. One requires parsing a flowchart and counting its steps, and they note counting is a notoriously hard task for the systems of the day. One requires reading the numerical phrase two slash three as two thirds rather than two and three, and then reasoning that two thirds exceeds one third.
[O] That last one is almost cruel.
[S] It is a middle-school question. That is the joke in the title.
[O] Now the multiple choice columns, and I want them kept apart.
[G] They must be kept apart, because the floors differ and so do the margins. On text multiple choice the random baseline is twenty two point seven percent. Text Only reaches thirty two point nine, BiDAF thirty two point two. So the better of those two clears its floor by about ten point two points, and BiDAF by about nine point five.
[S] And the paper characterises that how?
[G] As roughly ten percent improvement over the random baseline, which matches. And they are not celebrating. They immediately say many multiple choice questions are complex, which explains the poor performance of the baselines.
[O] Now diagram multiple choice, which is the column everybody has a number in.
[G] It is the only column all four model rows have a real entry in, and the random baseline there is twenty five point zero percent. Text Only gets twenty nine point nine. Text plus Image gets twenty nine point nine. Text plus D P G gets thirty one point three. BiDAF gets thirty point one.
[S] So the best of the four is thirty one point three, six point three points over its floor.
[G] Six point three over its floor, and that is a different margin from the text multiple choice one. Ten point two on text multiple choice, six point three on diagram multiple choice, against two different chance rates. Anyone who merges those into a single overall margin has destroyed the finding.
[O] But look at the pair in the middle. Text Only gets twenty nine point nine ignoring the diagram entirely. Text plus Image gets twenty nine point nine while looking at the diagram through a pretrained convolutional network.
[S] Identical. To the decimal.
[G] Identical, and the authors say so directly. Their sentence is that the Text plus Image model gives no value beyond the Text only model. Whereas Text plus D P G, the structured parse, comes in one point four points above Text Only, which they note is consistent with the findings in Kembhavi and colleagues on the A I two D dataset.
[O] So structure beats pixels on this kind of image, in two separate papers.
[S] On this kind of image being the crucial qualifier. These are schematic diagrams with labelled text boxes and arrows. A grid of forty nine ImageNet patch vectors was never going to represent an arrow meaning causes.
[G] That is the right read, and it is a narrow claim, not a general one about vision.
[S] What about that All column? Because that is the one that gets quoted.
[G] It runs from twenty eight point four for the random row up to thirty four point six for Text plus D P G, with the other three models between thirty three point seven and thirty three point eight. And it is the most misleading thing in the paper, though the prose is careful even where the table is not.
[O] Misleading how?
[G] It mixes populations. A reader skimming only that column sees a gap over random of roughly five to six points and concludes the models are uniformly slightly-better-than-chance everywhere. Underneath is a near-zero margin on true-false and about ten points on text multiple choice. The aggregate hides both.
[S] There is a stranger problem. You said Text plus Image and Text plus D P G have no text scores at all.
[G] They do not.
[S] Then what is their All number aggregating over? They were never run on text questions.
[G] The paper does not say. It reports thirty three point eight and thirty four point six for those two rows and never states what the aggregation covers. It also never states the formula, and it is not the unweighted mean of the other three columns, which you can check on the random row. And the table does not state which split these accuracies were computed on either, and neither does the surrounding text.
[O] Three separate things left unstated in one table.
[S] Which is my cue. Let me make the deflationary case properly. This paper reports that four systems the same lab wrote, on a dataset the same lab built, on an unstated split, using an aggregate column with an unstated formula, do badly. Every degree of freedom points the same direction.
[O] Then let me make the optimist case, narrower than usual. The result I actually believe is the paired one. Text Only and Text plus Image. Same architecture, same retrieval, same everything, differing only in whether the diagram is fed in as convolutional features. Twenty nine point nine and twenty nine point nine.
[S] That is a controlled comparison. I grant it.
[O] And it is immune to your entire list, because both sides inherit every flaw equally. It is an internal ablation, and it says the standard visual pipeline of the era extracted nothing from these diagrams. Same for the D P G contrast in the other direction.
[G] I score that to the optimist. Within-table paired contrasts survive the shared-author objection in a way absolute levels do not. The absolute numbers tell you what these implementations achieved. The paired contrasts tell you something about the diagrams.
[S] Then here is the question that decides it for me. How do we know the diagram questions actually need the diagram? If they do not, the visual premise is decoration.
[G] They ran that check, and this is the part I most want stated precisely, because the conditioning is load-bearing and it gets dropped constantly.
[O] Say it exactly, then.
[G] Section four point three describes a human-coded study. In the paper's words, this analysis was performed by human subjects on two hundred fifty randomly sampled questions in each type. Two hundred fifty text questions, two hundred fifty diagram questions. Not the full twenty six thousand.
[S] And the finding?
[G] The findings I want to quote carry an explicit condition in the paper's own figure caption. The caption reads, of the questions that require a diagram, the degree of parsing required. And for the next one, of the questions that require a diagram, the percentage of questions that can be answered with the OCR of the diagram alone. The body text repeats it, saying given that the diagram is needed.
[O] So both statistics are about a sub-population.
[G] Both are about the subset of sampled diagram questions that genuinely require the diagram. Within that subset, the authors write that very few questions can be answered with just a classification of the diagram, and more than fifty percent need a rich structure to be parsed out of the diagram. And separately, that fewer than five percent of diagrams can be trivially answered by just the raw OCR text.
[S] And if you strip the condition off you get a much stronger claim that was never measured.
[G] You get the claim that fewer than five percent of all diagram questions are solvable from raw OCR text, which is not what was measured. The measured statement is conditional on the diagram being needed in the first place.
[O] Does the paper report how large that conditioning subset is?
[G] It reports a scope distribution for diagram questions in a companion chart, but those charts print no per-bar values, only axis gridlines. So I will not give you a percentage for it. That is a case of the paper not answering the question in a form I can quote.
[S] Alright. That is a well-designed check on their own premise and I will say so. Human-coded, stated sample size, conditioning declared in the caption rather than buried. Better hygiene than the results table.
[O] I hear a but coming.
[S] The but is that it is a human check, not a model check. The control I want is a context-blind baseline on the diagram questions. Question and answer choices only, no lesson, no diagram, and see how far pure option-pattern exploitation gets you.
[G] That control is not in the paper. The closest row is Text Only, which still receives the lesson's textual context, so it is not context-blind. Given how many multiple choice benchmarks in the following decade turned out to be partly solvable from the choices alone, its absence is worth naming even though it was not standard practice at the time.
[O] Anything comparable on the text side?
[G] One comparison the paper makes explicitly. For text questions the sampled distribution splits fairly evenly between needing a single sentence and needing multiple sentences within a paragraph, with a tail needing information spread across the whole lesson. They contrast this with SQuAD, where they write a majority of questions can be answered by one sentence.
[S] So the single-sentence share here is smaller than SQuAD's majority. That is the honest version of the harder-than-SQuAD claim.
[G] It is, and note it also indicts their own retrieval step. If a substantial share of questions need multiple paragraphs, a pipeline that selects exactly one paragraph by keyword overlap has thrown the answer away before the network sees anything.
[O] So some fraction of that near-floor performance is the retriever, not the reasoner.
[G] Plausibly, and the paper does not decompose it. They offer three candidate explanations overall. Contexts in TQA are long compared to other comprehension datasets. Fitting multiple modalities into a single memory introduces new challenges. And questions require reasoning or show large lexical variation from the context, which pushes multi-hop reasoning beyond the synthetic settings where it had been validated.
[O] There is one texture detail I liked. The question length distribution.
[G] The mode of the question length distribution here is eight words, compared to five for V Q A, and the paper states that comparison directly. There is also an unusually large Other bucket in their question-category breakdown, which they trace to workbook questions being phrased as assertive statements rather than interrogative ones, and they suggest that may itself be part of why the baselines struggle.
[S] A model tuned on question words meets a corpus of assertions to be judged. That is a nice observation.
[O] And the lesson-scale statistics?
[G] About fifty percent of lessons have five to ten images, and more than seventy five percent have more than fifty sentences, both stated in the prose. There are also two thousand one hundred fifty six instructional videos linked across the lessons, and I want to be exact, because that is easy to misreport as a modality of the dataset. It is not. A footnote says explicitly the videos are not part of TQA, and the links are offered to encourage future work on extracting content from instructional video.
[S] Good. That would have been an easy one to inflate.
[O] Let me try implications, because this one aged in an interesting direction. What TQA was really testing is whether a system can hold a long, mixed-modality context and reason across it. That is now the default posture of every frontier model.
[S] And my deflationary version of that point is that TQA's central design virtue, the bounded knowledge claim, is exactly what a web-scale pretraining corpus dissolves. The whole argument was that the answer is provably in the supplied context. If a public curriculum site has been absorbed into pretraining, you no longer know a correct answer came from the context.
[G] The paper cannot help you there, and I want to be precise about why. Its notion of leakage is lesson-level concept overlap between its own splits, which it does control for deliberately. The pretraining-corpus sense of contamination is simply not in the paper's vocabulary. It did not exist as a concern in twenty seventeen.
[O] Which is a warning label on reuse, not a criticism of the paper.
[G] That is how I would put it.
[S] I will concede something I did not expect to. The candour is real. The abstract itself says these models do not perform well on TQA. There is no attempt to dress up thirty four point six percent as progress.
[O] And the framing is right. The headline is not that nobody can solve this. It is that these extensions of contemporary architectures could not, which is a weaker claim and the one the evidence supports.
[G] Which is exactly the distinction the paper's framing invites you to blur, and mostly does not.
[O] Takeaway each. Mine is the paired contrast. Same model, same retrieval, diagram in or diagram out, twenty nine point nine either way, while the structured parse moved it one point four points. That single comparison told the field more about science diagrams than the absolute numbers did.
[S] Mine is that a results table with no external baseline, no human ceiling, no stated split and an aggregate column with no stated formula gives you a strong signal about the authors' implementations and a much weaker one about the dataset's difficulty. The human-coded analysis is the stronger half of this paper, and it is the half that gets quoted least.
[G] And the paper's own takeaway, which is the one I would keep. Bounding the required knowledge to a supplied multi-modal context makes an evaluation you can actually reason about. When they did that at textbook scale, the era's attention and memory architectures had close to nothing on true-false, and clearly less than they needed on either kind of multiple choice.
[O] The full writeup, with the figures, the complete results table and the references, is on the litsearch site. Thanks Maeve.
[G] A pleasure.
