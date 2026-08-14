---
slug: sinha-2019-clutrr
title: "CLUTRR: A Diagnostic Benchmark for Inductive Reasoning from Text"
description: "CLUTRR generated its kinship-reasoning problems instead of fixing them, making reasoning-chain length a dial and contamination structurally impossible — five years before the field named the problem. The graph model hits a perfect score where text models cannot, but the paper's own appendix shows most of that gap is parsing, not reasoning, and two of its three noise tables have a column whose printed average does not reconcile with its own cells."
date: 2026-08-03
guest_name: "Imogen"
guest_voice: "bf_emma"
---
[O] Here is a benchmark from 2019 where one model scores a perfect one point zero and everything built on language is nowhere close. And the part I like most is that the paper's own appendix quietly undercuts its own headline.
[S] Before we get to the appendix that undercuts the headline, I want to flag something else. One of the numbers in the main results table does not add up. Not approximately. You can do the arithmetic on air in about fifteen seconds.
[O] We are going to do the arithmetic on air.
[S] We are. And I still think this is one of the better-designed evaluation artifacts of its era. Both things are true and I am not going to pretend otherwise.
[O] Welcome to Litsearch Audio. Today's paper is CLUTRR: A Diagnostic Benchmark for Inductive Reasoning from Text, by Koustuv Sinha, Shagun Sodhani, Jin Dong, Joelle Pineau and William Hamilton, out of McGill, Université de Montréal, Mila and Facebook AI Research. It appeared at EMNLP in 2019.
[S] Two hundred and seventy seven citations as of today.
[O] And joining us is Imogen, who knows this work and the systematic generalization literature around it closely. Welcome.
[G] Thank you. And let me say at the outset why this paper is worth your time in 2026 rather than as a historical curiosity. CLUTRR generates its examples rather than fixing them. Which means the contamination problem the field spent the last several years discovering had already been designed around here, five years early, for reasons that had nothing whatsoever to do with contamination.
[S] Set the scene. What did 2019 look like?
[G] Crowded, and increasingly suspicious of itself. SQuAD, NewsQA, MCTest, SNLI, MultiNLI. And alongside them a growing pile of results saying those datasets rewarded the wrong thing. Gururangan and colleagues found natural language inference models exploiting annotation artifacts rather than reasoning about entailment. Jia and Liang showed adversarial insertions collapsed SQuAD performance. Kaushik and Lipton argued several so-called reading comprehension datasets could be solved without reading much of the passage at all.
[O] And BERT was topping every one of those leaderboards.
[G] Which these authors read as a diagnosis rather than a triumph. Their inference is that the primary difficulty in those datasets is incorporating the statistics of natural language, not reasoning.
[S] So what specifically could no existing benchmark do?
[G] Three things at once. Dial the exact number of reasoning steps a test example requires. Hold out specific combinations of logical rules from training. And add controlled, taxonomized noise. All while keeping the surface form genuine natural language rather than a synthetic template language like the bAbI tasks. Knowledge graph question answering benchmarks were closer in spirit, but almost all of them were transductive, reasoning over a fixed and already known set of entities. CLUTRR wants inference over a completely fresh set of entities every single time.
[O] Walk me through the generator, Imogen.
[G] Four steps. Sample a random kinship graph using a stochastic backbone process, then close it under a small deterministic knowledge base of resolution rules, sixteen in total, covering grandparent, child, sibling, in-law and the aunt-uncle-niece-nephew family. Then sample the target fact you want the model to predict. Then run backward chaining from that target for exactly k steps. Then convert the sampled facts into a short natural language story through Mechanical Turk paraphrasing.
[S] Exactly k steps is doing enormous work in that sentence.
[G] It is the whole trick, and it is a one-line modification to a textbook algorithm. Traditional backward chaining stops the moment it obtains a proof. This variant does not. It runs for a fixed number of iterations, uniformly sampling a subgoal to resolve and a knowledge base rule to resolve it with at each step.
[O] So chain length stops being an accident of the data and becomes a knob.
[G] It becomes a first-class experimental variable. You can say this example requires exactly six steps of reasoning and actually mean it. Nothing else in 2019 let you do that over natural language.
[S] The paraphrasing has to be the bottleneck. You cannot crowdsource a story for every possible combination.
[G] You cannot, because the space grows combinatorially in k. So they collected paraphrases only for base clauses of length one, two and three. Six thousand and sixteen unique paraphrases, peer-reviewed by other Turkers with a seventy nine percent pass rate. Then they replaced the entities with placeholders and stitched those templates together to synthesize longer stories, out to chain length ten.
[S] That stitching is a seam. I want to come back to it.
[G] Fairly. Note it.
[O] What about the question itself?
[G] Deliberately not a question. It is posed as K-way classification over relation labels. You are handed the two entities and asked which relation holds between them. That is a direct response to Kaushik and Lipton, whose critique was that a generated natural language question can leak information about its own answer. Entity names come from a fixed pool of three hundred gendered English names and are then Cloze-style anonymized into at-entity placeholders, so no model can ride a name-to-answer correlation.
[O] And the generalization tests themselves?
[G] Three of them, escalating. Hold out a subset of the collected paraphrases so test stories use linguistic templates the model has never seen. Hold out a subset of the logical clause combinations for chains longer than two, so the model has seen every individual rule but not every composition of them. And most aggressively, train only on chains up to some length and test on strictly longer chains the model has never encountered in any form.
[S] And the noise axis?
[G] Taxonomized geometrically, relative to the target reasoning path. Supporting facts share both endpoints with the target path, so they close a cycle and create an alternative, longer proof. Irrelevant facts share exactly one endpoint, so they are a pure distractor hanging off one of the two target entities and dead-ending. Disconnected facts share no endpoint at all.
[O] Those are three genuinely different kinds of hard.
[G] And the results turn entirely on the difference between them. Hold that thought.
[S] Seven baselines. Give me the roster.
[G] A bidirectional LSTM with and without attention pooling, Relation Networks, MAC, which was the state of the art on CLEVR at the time, vanilla frozen BERT, a BERT-LSTM hybrid running a trainable LSTM on top of frozen BERT embeddings, and a Graph Attention Network. Everything except the BERT models is trained from scratch with no pretrained word embeddings, a hundred epochs, Adam at a learning rate of point zero zero one. Five thousand training stories per chain length, one hundred test stories per length.
[S] Averaged over how many runs, and runs of what exactly? Reseeding, or regenerating?
[G] Ten runs, and regenerating. Different randomly generated stories each time. So the error bars are a standard error across regenerated datasets and retraining, not just across seeds on one frozen dataset. That is a considerably stronger notion of variance than most benchmark papers of that period reported, and it deserves saying out loud.
[O] And the graph network is the odd one out.
[G] Structurally, yes. The Graph Attention Network is handed the story's underlying kinship graph directly as structured input. Every other model has to parse that structure out of English prose. Almost everything contentious downstream traces back to that one asymmetry.
[O] Give me the headline result.
[G] Train on chain lengths two and three, test on two through ten. The graph model is the only one that is near perfect at the training distribution length. It reaches one point zero at chain length two and stays close through three. Every text-based model is already well below one point zero at chain length two. BERT-LSTM is the strongest of the six at roughly point nine. Plain BERT is the weakest, at roughly point five.
[S] And out at chain length ten?
[G] Everything converges into a similar low band. BERT-LSTM around point three, plain BERT around point one five.
[O] So the text models degrade and the graph model holds?
[G] No, and this is the correction I would most want a listener to keep. The graph model degrades the most steeply in relative terms. It simply starts from the highest point. In the two-and-three training regime it remains the top performer through about chain length five or six, and then the text models' curves cross above it.
[S] That is a materially different story from the one the abstract tells.
[G] It is a more precise version of the same story. And training on the wider two-three-four regime lifts every model's curve, with the paper noting the graph model gains the most from that expanded training distribution.
[O] Take me to the noise grid.
[G] Table two. Train and test on chains of two and three combined, seven training-to-testing noise pairings, each averaged over ten runs. The graph model posts the highest average across those seven conditions at point seven seven, plus or minus point zero nine. Among the six text-based baselines, BiLSTM-Attention and MAC tie for best at point six one each.
[S] So structure wins and we go home.
[G] Not everywhere, and the exception is the single most interesting cell in the paper. Train the graph model on clean data, then test it with supporting noise added, and it collapses to point two four. That is the worst score of all seven models in that row.
[O] The graph model loses to a bidirectional LSTM.
[G] On that condition, badly. Because a supporting fact closes a cycle in the kinship graph and creates an alternative, longer proof path that a model trained only on clean acyclic graphs has never seen. The paper attributes it specifically to message passing being confused by the new cycle.
[S] Is that an inherent weakness or is it distribution shift?
[G] Distribution shift, and the paper demonstrates it cleanly. Train the graph model with supporting noise present and the supporting-to-supporting condition reaches point nine eight. So it can learn the robust strategy. It just cannot transfer into it zero-shot.
[O] What about disconnected noise?
[G] Comparatively cheap for it. Clean-to-disconnected is point eight zero, which is the second highest among the four clean-trained rows, behind only clean-to-clean. Disconnected facts sit in an isolated clique that message passing never has to traverse. Though I would keep the framing honest — across all seven conditions in the table that same point eight zero ranks only fifth, well below the three noise-matched training rows at point nine eight, point nine six and point nine three.
[S] Now the genuinely odd result. The text models get better when you add noise?
[G] Several of them do, and the paper's description of this has to be read as two sentences rather than one. First sentence: all the text-based models excluding BERT actually perform better when testing on examples that have supporting or irrelevant facts added. Second sentence, immediately following: in contrast, the BERT-based models do not benefit from the inclusion of this extra content.
[O] Models. Plural.
[G] Plural, and the appendix defines exactly two BERT variants, vanilla BERT and BERT-LSTM. So check it cell by cell against the clean-trained row. BiLSTM-Attention goes from point five eight clean, up to point seven six with supporting noise and point seven zero with irrelevant. BiLSTM-Mean, point five three up to point six four and point seven six. Relation Networks, point four nine up to point five eight and point five nine. MAC, point six three up to point seven one and point six nine. All four improve on both noise types.
[S] And BERT-LSTM?
[G] Does not. It goes from point six seven on clean-to-clean to point six six on clean-to-supporting, and point five five on clean-to-irrelevant. Which is exactly what the paper's own second sentence predicts. And that supporting-noise gap is point zero one, sitting entirely inside the printed error bars — point six seven plus or minus point zero three against point six six plus or minus point zero six.
[O] So it is not a counterexample at all.
[G] Only under a literal single-model reading of the phrase excluding BERT. Read as the two sentences intend, the claim holds for all six non-graph baselines. And plain BERT itself, for the record, goes from point three seven down to point two eight, point two four and point two four. It does not benefit from anything.
[S] Why would extra irrelevant content help a model in the first place?
[G] The authors' explanation is linguistic cues. Extra content about the entities, gender in particular, that the weaker models can exploit even though none of it is needed for the inference. And their account of why the BERT-based models fail to get that lift is that a strong pretrained language model already captures those cues adequately.
[O] Before we argue about what it means — is the task even solvable at chain length ten?
[G] The appendix answers that and it is the number I would most want kept. Time-limited Mechanical Turk annotators score point eight four eight at chain length two and point seven seven three at three, then fall off sharply — point four seven seven, point four two four and point four zero six at four, five and six.
[S] So humans degrade with chain length too. That weakens the whole framing.
[G] Time-limited humans do. Expert annotators given unrestricted time solve one hundred percent of examples at every tested length from two through six, taking an average of about six minutes per puzzle.
[O] That is the argument in a single line. The ceiling is perfect. The degradation is not the task becoming unsolvable.
[G] It is the task requiring sustained attention. And perceived difficulty tracks it closely. Turkers rate it one point four nine on a five point scale at chain length two, rising to four point four six at six, with a small dip from three point eight one to three point seven eight between four and five that is almost certainly noise.
[S] All right. My deflationary case, and it is short. The headline comparison is not apples to apples, and the paper knows it is not.
[G] Make it, and then let me tell you where the paper concedes it.
[S] The graph model is handed the ground-truth symbolic kinship graph. Every other model has to recover that same graph from prose written by crowd workers, in phrasings deliberately held out from training. Those are two different tasks. Calling the resulting gap systematic generalization attributes to reasoning what may simply be parsing.
[G] The paper's own appendix runs precisely that control. They re-ran the generalization test with the same set of natural language paraphrases used in both the train and test splits. The models still face held-out logical patterns, but the difficulty of parsing unseen phrasing is essentially removed. In that simplified setting the text-based models become, in the paper's own words, competitive with the graph model.
[O] That is an honest ablation to have run.
[G] It is a genuinely useful one. And it also means the paper's most quoted result, the cross-model gap in Figure five, partly measures parsing difficulty on unseen phrasing rather than reasoning composition in isolation. The paper is candid about this in the appendix. The headline framing does not foreground it.
[S] Point to me, then.
[G] Point to you on the framing. Not on the honesty.
[O] Let me make the optimist case, because I do not think that ablation kills the result. Even granting that most of the gap is parsing, that is still a real and important finding about text models in 2019. A system that cannot recover a relational structure from unseen phrasing cannot reason over that structure either. The bottleneck being upstream does not make it stop being a bottleneck.
[G] That is fair, and I would add the design point that has aged best of anything here. CLUTRR is a generator, not a dataset. Fresh kinship graph, fresh entity names, fresh paraphrase composition, drawn on demand. A leaderboard cannot simply be memorized from a frozen released split. And the paper is explicit that the concrete released datasets are just one sampling from a generator whose code is public.
[O] Which is the dynamic evaluation argument, five years early.
[G] And arrived at for a completely different reason. Nobody in 2019 was worried about a pretraining corpus swallowing the test set. They wanted a length dial. The contamination resistance falls out as a side effect of wanting experimental control, which I think is the more general and more useful lesson.
[S] I will give ground there. That is a property I would want in a benchmark today, and here it came for free.
[O] Which means we are agreed on the design and still have your table problem outstanding.
[S] We do. So let us go to the thing I flagged at the top.
[G] Table two's Average row.
[S] BERT's printed average is point three zero. The row's own seven cells are point three seven, point two eight, point two four, point two four, point three two, point two five and point one seven. Add them and you get one point eight seven. Divide by seven and you get point two six seven, which rounds to point two seven.
[O] Not point three zero.
[S] To print point three zero you would need those cells to sum to two point one zero. That is not a rounding gap. That is a different number.
[G] And the reason it is worth stating on air rather than shrugging at is the calibration. Every other column reconciles. The worst of them is MAC, whose cells sum to four point two three — divide by seven and you get point six zero four three against a printed point six one. A gap of point zero one, which is exactly what cell-level rounding produces. BERT's is off by a full point zero three.
[O] Could Average simply mean something other than the mean of that column?
[G] The paper never defines what it averages. Four alternative populations were checked against the printed value and none of them produces point three zero.
[S] And you said it happens twice.
[G] Table four, the placeholder-variant robustness table. BERT's printed Average there is point five eight. Its twelve cells mean point five two seven five. And the worst deviation among the other six columns in that same table is five thousandths.
[O] What about table three?
[G] Reconciles cleanly. BERT's column there sums to two point seven one, divides to point two two five eight, and prints as point two three. So the discrepancy is specific to BERT's column, and specific to two of the paper's three noise tables.
[S] On its own I would call that a typesetting slip and move on.
[G] Except for the separate observation, which is the one I would actually flag. The Average row's seven printed standard errors are byte-identical across all three tables. Plus or minus point zero eight, point zero eight, point zero seven, point zero six, point zero seven, point zero five, point zero nine. The same seven values, in the same column order, three times.
[O] While the means differ.
[G] While all six text-model means differ completely between the tables. And before anyone reaches for an explanation, the seventh column actually corroborates the observation rather than weakening it. The graph model's Table three and Table four columns are byte-identical across all twelve cells, which is exactly what should happen, because the graph model reads the graph and never sees the placeholder substitution that Table four varies.
[S] So the ablation moved the text models and left the graph model alone.
[G] Which is the correct behaviour. And it is the text columns' identical spreads that have no such explanation. Let me be precise about the epistemic status, because it matters. That is an observation about the printed tables. The paper offers no account of it either way, and I am not going to supply one.
[O] You are not saying the numbers were copied.
[G] I am saying the numbers are identical and the paper does not say why. Those are two different claims and only the first one is mine.
[S] Which is exactly the right place to leave it. And the practical consequence for a reader is narrow: BERT's Table two and Table four averages should be read with a discrepancy noted, not treated as internally verified the way every other column is.
[O] Other caveats worth a listener's time?
[G] Two. The baselines were dated even for their own moment. MAC and Relation Networks were reasonable 2017 and 2018 choices for models with an inductive bias toward relational reasoning, and BERT-base was the frontier pretrained language model in mid-2019, but none of the seven were purpose-built for symbolic multi-step inference the way later reasoning architectures would be. And the paper discloses that a further baseline it tried, the Relational Recurrent Memory Core, performed significantly less across all the tasks and was dropped from the reported results because the authors could not determine whether that was a bug or a real result.
[S] I respect the disclosure and dislike the situation.
[G] Both of those are correct. It is honest. It also means one candidate result was excluded from the paper on grounds the reader cannot independently audit.
[O] And the linguistic diversity of the stories?
[G] Bounded, but genuinely measured. The Jaccard unigram overlap between paraphrases of the same logical clause is only point two zero one, which is real diversity. But it is still six thousand and sixteen crowd-sourced templates and simple family vocabulary, with gender roles that the authors' own footnote calls oversimplified compared to the real world, for tractability. A model that memorizes a finite template inventory rather than parsing genuinely novel phrasing has a far smaller space to memorize than a natural corpus would offer.
[S] What would raise my confidence in the headline claim?
[G] A text-based baseline given the same symbolic graph as auxiliary input. That is the apples-to-apples, reasoning-only comparison the paper never runs. Reconciliation of BERT's Average cells in Tables two and four, and of the identical printed error bars across all three noise tables. And a note on whether the withheld Relational Recurrent Memory Core result was ever resolved.
[O] What carries forward to today?
[G] The generator-as-benchmark pattern, mostly. If your evaluation can synthesize a fresh instance at a specified difficulty, you get three things simultaneously: contamination resistance, a controlled difficulty axis, and the ability to test out-of-distribution length without building a second dataset by hand.
[S] And mine is the discipline of checking a table against itself. Two of three tables in a well-cited EMNLP paper have an average that does not reconcile for one column, and the printed spreads repeat identically across all three.
[O] Seven years and two hundred and seventy seven citations later.
[S] Apparently nobody had run the arithmetic.
[G] The paper's takeaway: CLUTRR shows that the neural language models of 2019 generalized poorly to unseen rule compositions and longer reasoning chains relative to a model handed symbolic structure directly, with the paper's own appendix showing that much of that gap is a language-parsing bottleneck rather than a pure reasoning one.
[O] Mine is that the generator design was the real contribution, and it solved a problem the field would not name for another five years.
[S] And mine is simpler. Read the tables. Both the ones that hold up and the two that do not.
[O] The full writeup, with the figures, the complete noise grid and the cell-by-cell arithmetic, is on the litsearch site under the CLUTRR entry. Imogen, thank you.
