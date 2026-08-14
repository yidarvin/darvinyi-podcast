---
slug: singh-2023-scirepeval
title: "SciRepEval: A Multi-Format Benchmark for Scientific Document Representations"
description: "A twenty four task benchmark for scientific paper embeddings, and the finding that multi task training buys nothing until you let one document have a different embedding per task format. The winning system is seventy one point two, and the paper's own significance test cannot separate it from two cheaper ones."
date: 2026-08-01
guest_name: "Cressida"
guest_voice: "bf_lily"
---
[O] Seventy one point two. Best average on a twenty four task benchmark for scientific paper embeddings, and it comes from giving a single document more than one embedding.
[S] Seventy point nine is second. And third. And the paper's own significance test says it cannot tell those two apart from the winner.
[O] On two of the three columns. Not on the third, and that distinction is load bearing.
[S] It is, and it is also the detail that decides whether the headline here is a result or a rounding error. Let us do this one carefully.
[O] Welcome to Litsearch Audio. Today, SciRepEval, a multi format benchmark for scientific document representations.
[S] Amanpreet Singh, Mike D'Arcy, Arman Cohan, Doug Downey and Sergey Feldman. The Allen Institute for A I, Northwestern, and Yale. It went up on arXiv in November twenty twenty two and landed at E M N L P in twenty twenty three.
[O] And with us is Cressida, who has read this one down to the appendix tables. Welcome. This paper does two things at once, and I want them kept apart all episode.
[G] Thank you, and that separation is the whole discipline here. Contribution one is a benchmark: twenty four tasks for evaluating scientific document embeddings. Contribution two is a family of models the same authors train on that benchmark, called SPECTER two. Every claim today belongs in one bucket or the other, and the paper does occasionally let them blur.
[S] Start with what was broken. What was the field measuring on before this?
[G] SciDocs, from Cohan and colleagues in twenty twenty, released alongside SPECTER. Seven tasks. Two classification, one recommendation, and four nearest neighbour tasks: predicting citations, co citations, co views and co reads from a query paper.
[O] That sounds reasonably broad on its face.
[G] It measures far narrower than it looks, and this paper proves that rather than asserting it. Appendix G takes every individual task result across all the model runs in the main tables and computes Pearson correlations between tasks. The four SciDocs nearest neighbour tasks correlate with each other above point nine nine. So four of the seven are close to one measurement wearing four hats.
[S] And the recommendation task?
[G] Dropped. The authors found it too noisy to separate models. The test set holds a thousand clickthrough events, and propensity weighting means an even smaller number of examples dominate the score. SciRepEval keeps SciDocs as a subset but excludes that one task.
[O] So six of SciDocs's seven carry over.
[G] Correct. And the third limitation is the one that shapes everything after it. The authors point out that SciDocs was built purely for evaluation, and that its task sets are small enough to make training on them impractical. You can score an embedding with it. You cannot study how training changes an embedding with it.
[S] What about general purpose embedding benchmarks? M T E B existed by then.
[G] They cite it, and make a modest claim: strong performance on general purpose text embedding benchmarks may not translate to scientific tasks. Hold that thought, because the measured size of that gap is smaller than the framing implies, and we will get to the number.
[O] Give me the shape of SciRepEval itself.
[G] Twenty four tasks across four formats. Classification. Regression. Proximity, where you rank candidate papers against a query paper. And ad hoc search, where the query is a short piece of text rather than a paper. Eight of the twenty four are new to this work.
[S] And a training split, since that was the complaint about SciDocs.
[G] Eight tasks are in train, sixteen are held out purely for evaluation. And I want to be exact about the selection rule, because it is not a coverage decision. It is a size threshold. Any dataset with at least two hundred thousand instances goes into the training pool. Everything smaller is evaluation only.
[O] So the split is mechanical.
[G] Entirely. And the consequence is that the training pool is lopsided across the four formats. Two classification tasks. Two regression tasks. Three proximity tasks. And exactly one search task. Not two per format. If you walk away thinking they trained on two of each, you will misread the cross format analysis later.
[S] Name the big ones.
[G] On classification, MeSH Descriptors, with over two point three million training instances, and a fields of study set with silver labels derived automatically from publication venues but only four hundred and seventy one gold labelled test examples. On regression, predicting a paper's citation count and its publication year. On proximity, same author detection, highly influential citations, which they define as four or more citations of the same paper inside the text of a single paper, and the citation prediction triplets inherited from SPECTER. On search, a new set of over five hundred thousand clickthrough events from Semantic Scholar.
[O] And the held out sixteen?
[G] Genuinely varied. Biomimicry and D R S M on classification, plus the two SciDocs classification tasks. Peer review score and author h index on regression, both new and scraped from OpenReview, plus tweet mentions. On proximity, author disambiguation via S two A N D, paper reviewer matching, RELISH, and the four SciDocs nearest neighbour tasks. And two search sets, N F Corpus and T R E C COVID.
[S] Sizes across those sixteen?
[G] Wildly uneven. T R E C COVID has fifty queries. Paper reviewer matching has a hundred and seven queries against seventeen hundred and twenty nine candidate pairs. Those are small enough to be noisy on their own, and they sit inside an average alongside tasks with tens of thousands of examples.
[O] How do you even score across formats that different?
[G] Frozen embeddings, lightweight downstream models. Classification and regression: train a linear support vector machine or regressor on the embeddings. Regression is scored with Kendall's tau rank correlation, deliberately not mean squared error, because unbounded values would skew the overall average. Proximity and search: rank candidates by Euclidean distance in embedding space. Then, following earlier benchmark practice, they average the individual metrics, each on a zero to one hundred scale.
[S] An unweighted average of heterogeneous metrics. Flag it. We are coming back to it.
[O] Now the model side. What is SPECTER two?
[G] Two layers. The base model first. SPECTER and SciNCL both fine tune a scientific language model with a triplet loss over citation links, so papers that cite each other embed near each other. The authors' complaint is coverage: about seventy percent of that pre training data comes from just two domains. So they build SPECTER two Base the same way, but with roughly ten times more data, spanning twenty three fields of study.
[S] Ten times more of what, precisely?
[G] Citation triplets. Up to ten per query paper, positives drawn from direct citations. Six easy negatives sampled by field of study, four from the query's own field and two from a different one. Four hard negatives, drawn from papers cited by one of the query's citations but not cited by the query itself. Six point two million training triplets in total, with SciNCL's own triplets folded in as a subset.
[O] And the multi format part sits on top of that base.
[G] Right. They pre fine tune it on the eight in train tasks simultaneously, with a loss appropriate to each format. Cross entropy for classification. Mean squared error for regression. And for both proximity and search, a triplet margin loss: push the query's distance to a positive candidate below its distance to a negative one by at least a margin, which they set to one. Distance is Euclidean throughout.
[S] Batching?
[G] Task heterogeneous. Every batch draws an equal number of examples from every task. They cap each task at six hundred thousand samples, which gives three point two seven million training instances, and they train for two epochs on two forty eight gigabyte GPUs at an effective batch size of two fifty six.
[O] Now the actual hypothesis. Why should one document have more than one embedding?
[G] Because the geometry a task wants is not the same across formats. Their first figure makes the argument visually. An embedding space can give you a perfectly linearly separable classification problem while its nearest neighbours are not reliably the same class. Optimizing one vector for both is a compromise. So they learn a distinct embedding per task format, four of them, out of one shared model.
[S] And the mechanisms for doing that?
[G] Two families. Control codes: prepend a special token per format, bracket C L F, bracket R G N, bracket P R X, or bracket Q R Y, and read the document representation off that token's final layer. Four new randomly initialized tokens. That is the entire parameter cost.
[O] And adapters.
[G] Three variants. Plain adapters, a small module per format inserted at each layer with the base encoder frozen. Adapter Fusion, from Pfeiffer and colleagues, which trains per format adapters first and then adds fusion layers that attend across all of them. And BERT PALs, from Stickland and Murray, which adds attention layers per format and trains the whole network.
[S] What is the control that tells us specialization is doing the work, rather than multi task training on more in domain data?
[G] That is the crucial one, and the paper has it. They call it M T L C L S. Identical multi task pre fine tuning on the identical eight tasks, but it emits a single shared embedding for everything. If multi task training alone were the win, that model would capture it.
[O] Numbers. Start with the baselines nobody trained.
[G] SciBERT is last at fifty eight point oh average. Then a band of general purpose embedders: Instructor base at sixty four point eight, E five base v two at sixty seven point two, MPNet at sixty seven point seven, OpenAI's Ada oh oh two at sixty seven point eight. Then the scientific ones. SPECTER at sixty seven point five. SciNCL at sixty eight point eight. And the new SPECTER two Base at sixty nine point one.
[S] Stop. Read SPECTER against that general purpose band again.
[G] Sixty seven point five. Which is below Ada oh oh two at sixty seven point eight, and below MPNet at sixty seven point seven.
[S] So the domain specific model this entire line of work is built on does not beat a general purpose embedding API on scientific tasks.
[G] It does not. Only SciNCL and the authors' own SPECTER two Base clear the general purpose field, and they clear it by roughly a point. The paper's framing is that domain and task specific embeddings are needed. Its own table puts the size of that need at about one point.
[O] Fine. Now the multi task rows.
[G] The shared embedding model gets sixty nine point oh average. SPECTER two Base, with no multi task training at all, gets sixty nine point one.
[S] It went down.
[G] By a tenth of a point. Call it on par, if anything a hair behind. And that is the paper's most important negative result. Training on eight large in domain tasks buys you nothing over just training on more citations, so long as the output is still one vector.
[O] And with format specialization switched on?
[G] Control codes, seventy point four. Adapters, seventy point nine. Fusion, seventy point nine. PALs, sixty nine point nine. And an ensemble that simply averages the control code and adapter embeddings, seventy one point two, which is the paper's best.
[S] PALs is the odd one out there.
[G] It is, and it matters. PALs clears the shared embedding baseline, but at sixty nine point nine it sits below the control code model's seventy point four. So the results section's sentence that the adapter variants are better than the control code model overall does not hold for PALs. It is behind on in train, on out of train, and on the average.
[O] Now the significance markers, because I know this is where people get it backwards.
[G] They do, so let me state the convention once and precisely. Bold marks the best score in a column. Underline marks a score that is not statistically significantly different from that best, by a one way analysis of variance with Tukey's test at alpha equals point oh five, over five seeded runs per model. So an underline is a tied with the winner flag. It is not a worse than flag.
[S] Then tell me who is tied with what.
[G] On the Average column, Adapters and Fusion, both at seventy point nine, are underlined. So the paper's own test says the ensemble's seventy one point two is not distinguishable from either of them. Same story on Out of Train, where Adapters and Fusion both sit at seventy three point nine against the ensemble's seventy four point one.
[O] And In Train?
[G] Different, and this is the part that gets flattened when people summarize. The ensemble's sixty two point nine is the only marked cell in that column. Nothing else there carries an underline. So on the held out sets of the training tasks, no rival is flagged as statistically tied with it.
[S] So the honest statement is: on the two columns most people will quote, the winner is in a three way tie with two cheaper systems. On the third, it stands alone.
[G] That is exactly right.
[O] I want to defend the result, because I think the decomposition is cleaner than either of you is granting. Cressida, walk the Average column from SciNCL up to the top.
[G] Happily, and it is legal arithmetic, since it is one column on one scale. SciNCL, the prior single embedding state of the art, sixty eight point eight. Ten times more citation data gets you SPECTER two Base at sixty nine point one. That is plus point three. Multi task training with a single shared embedding gets you sixty nine point oh. That is minus point one. Format specialized embeddings get you seventy point nine to seventy one point two. That is plus one point nine to plus two point two.
[S] So the data scaling contributes almost nothing.
[G] Almost nothing. Practically the entire gain is the format specialization. If you suspected the abstract's over two points absolute was really a data story wearing an architecture costume, the table says no. It is over two points measured against SciNCL, and the specialization step is where essentially all of it comes from.
[S] I will take that. Point to the optimist.
[O] And what does that specialization cost?
[G] This is my favourite table in the paper. Control codes: seven hundred and sixty eight parameters per format, which is one new token embedding each, and by construction one times the training time and one times the inference time. Adapters: one million parameters per format, measured at point nine six times training and one point oh five times inference. Effectively free.
[S] So the cheapest mechanism is also near the top of the leaderboard.
[G] Nearly. And now look at Fusion. It matches Adapters exactly, seventy three point nine on out of train and seventy point nine on average, identical to the tenth. It costs twenty two million parameters per format, one point three two times training, and one point six nine times inference. PALs costs two million parameters, more time than Adapters, and scores below both.
[O] And the ensemble that actually wins?
[G] One million parameters, but you are running two models. One point nine six times training, two point oh five times inference. For three tenths of a point of average that the significance test cannot distinguish from Adapters alone.
[S] So the practical recommendation is Adapters, not the paper's own winner.
[G] The paper agrees with you in its efficiency section, and it releases the base model and the adapters publicly. But it does not carry that conclusion into its results narrative, which singles out the fusion adapters as performing the best. On its own table, Fusion ties Adapters at every reported digit and costs twenty two times the parameters.
[O] Is there direct evidence that format specialization is doing what they claim mechanistically?
[G] Yes, and it is the cleanest analysis in the paper. They take one in train and one out of train task from each format, then score each of them using all four control codes. A four by four grid. If the hypothesis holds, the code matching a task's own format should win its row.
[S] Does it?
[G] For in train, cleanly, all four rows. For out of train, three rows cleanly: classification, regression and ad hoc search. Proximity is the exception, and it deserves precision. The proximity code scores forty five point one. The query code scores forty five point two.
[O] So the diagonal loses by a tenth.
[G] Numerically, yes. The paper still marks the proximity code there, because in that table the mark denotes the format matched cell, which is its analytical claim. But anyone repeating that the matching code always wins should know one row does not support it.
[S] I will note that the two codes involved, proximity and query, are the two formats that share a loss function.
[G] They are, the same triplet margin loss. And the task affinity appendix finds exactly that pattern independently: training on proximity and search together helps, but only on those related formats.
[O] Is there any test that format is the right partition at all, rather than just some partition?
[G] One, and it is a real control. They regroup the training tasks into five random partitions instead of by format. Format based partitioning wins by over two point seven points on average. That is a larger effect than any of the gaps between the format specialized variants themselves.
[S] Good control. It rules out that any partition would do. It does not rule out that some other partition would do better, and to their credit the authors say so in their limitations.
[O] Does any of this transfer off SciRepEval?
[G] One external test, and it is a well chosen one. M D C R is a citation recommendation benchmark from Medić and Šnajder where BM twenty five, plain lexical retrieval, had beaten neural encoders across most scientific fields. That is a genuinely hostile setting for this line of work.
[S] Results.
[G] BM twenty five: thirty three point seven mean average precision, twenty eight point five recall at five. SPECTER two Base: thirty eight point oh and thirty two point four. Control codes: thirty six point five and thirty point seven. Adapters: thirty eight point four and thirty three point oh. The ensemble: thirty eight point four and thirty two point nine.
[O] So the neural models take it back.
[G] Most of them do. And note who wins. On mean average precision, Adapters and the ensemble tie at thirty eight point four. On recall at five, plain Adapters alone has the single best score at thirty three point oh. The ensemble's thirty two point nine is not the best. So the SciRepEval champion is not the M D C R champion on that metric.
[S] And the shared embedding model on M D C R?
[G] Thirty four point six and twenty four point nine. That is the one row that loses to BM twenty five, on recall at five, by three point six points. The single embedding multi task model is worse than lexical retrieval at this task.
[O] That is a striking independent confirmation of the paper's core claim, actually.
[S] It is, and I will grant it. Now the caveat, because I assume there is one.
[G] The authors disclose it themselves. Twenty three percent of the papers in M D C R, though not the citation links between them, already appear in SPECTER two's training data. They call it a possible transductive advantage. They do not factor it out of the headline.
[S] Disclosed and uncorrected. That is better than most papers manage, and still not enough to quote thirty eight point four as a clean external win.
[G] Agreed, with one qualification: the ranking inside that table is largely unaffected, since every SPECTER two row shares the same overlap.
[O] Does the core result replicate at all?
[G] Yes, and for my money it is the strongest thing in the paper. Appendix D reruns the whole comparison using SPECTER and then SciNCL as the base encoder instead of SPECTER two. Both times, same ordering: shared embedding at the bottom, control codes above it, adapters above that, the ensemble on top.
[S] Same authors, same code, same benchmark, though.
[G] True. It is a robustness check across base encoders, not an independent replication. Nobody outside the group has rerun it in this paper.
[O] Let me make the optimist case cleanly. This isolates a real architectural fact. Multi task training on eight large in domain datasets, with a single output vector, buys nothing. Minus a tenth of a point. Change nothing about the data or the objectives, only let the model emit a different vector per task format, and you get two points. Clean intervention, clean control, replicated across three base encoders, validated by a cross format grid and a random partition baseline, and it costs one million parameters and no extra training time.
[S] And the deflationary case. The benchmark is an unweighted average of twenty four metrics of wildly different sensitivity, where a task with fifty queries counts the same as one with a quarter of a million. Several of those tasks correlate above point nine nine with each other, which the authors' own appendix demonstrates, so it is not an average of twenty four independent signals. And the one question that determines whether any of this matters, whether a higher SciRepEval score produces a better search product, is listed as future work.
[G] You are both largely right, and I would score it claim by claim. The specialization result goes to the optimist. It is the largest effect in the paper, it has a proper control in the shared embedding model, and it survives a change of base encoder twice. The ranking among the specialized variants goes to the skeptic. Three tenths of a point with overlapping variance, and the paper crowns a winner that costs twice the inference for a margin its own test cannot see.
[O] And the benchmark itself?
[G] Split. It is a real improvement on SciDocs: more formats, more realistic tasks, large enough to train on, and a documented correlation analysis showing better diversity than the thing it replaces. But the aggregation is unweighted and the correlation problem is reduced rather than eliminated. The authors say as much in their conclusion, listing higher fidelity metrics that account for the diversity of tasks as future work.
[S] I want a minute on where the paper's prose disagrees with the paper's tables, because there are two clear cases and both are the kind of thing that gets quoted downstream.
[G] There are. The first: the results section says every approach producing multiple representations beats the shared embedding model by one point four to two points. Re derive it from the Average column. PALs is plus point nine, below the stated floor. The ensemble is plus two point two, above the stated ceiling. Neither endpoint of that range survives contact with the table.
[O] And the second?
[G] Appendix E says that apart from Geology and History, the ensemble is equivalent or better than BM twenty five on all the scientific domains, which implies those two fields are where it fails. The per field table on the same page says otherwise. Geology: the ensemble is thirty four point one mean average precision against BM twenty five's thirty three point one, and twenty eight point four recall at five against twenty eight point oh. History: forty point three against thirty eight point one, and thirty four point seven against thirty two point nine. The ensemble is ahead on both metrics in both of the supposedly exceptional fields.
[S] Did you look for something that rescues it? A different protocol for those two fields?
[G] I did. The table caption, the aggregate table, the domain size table, and the main text discussion of the overlap caveat. Nothing scopes those two fields differently. The sentence simply does not match the numbers printed beside it.
[O] In fairness, that is an appendix sentence, not a headline claim.
[S] It is, and I raise it not to indict the paper but because this is a paper whose entire value is a scoreboard other people will quote from. When the prose around the numbers drifts, the quotes drift with it.
[O] Anything on contamination inside SciRepEval itself?
[G] Not reported. The M D C R overlap check is the only one in the paper, and that is against an external benchmark. There is no document level overlap audit between SciRepEval's own in train pools, the search clickthrough set and the citation triplets, and its own out of train test sets. My read, going beyond the paper, is that this is worth checking, because several of those held out sets draw on the same biomedical literature the training data does.
[S] Is that likely to be a large effect?
[G] The paper does not say, which is precisely the point. They demonstrated they know how to run that check and how to report it honestly. They just did not run it on their own split.
[O] There is one more ablation I want on the record, because it cuts against the whole citation objective lineage.
[G] Appendix F. They take SciBERT with control codes and remove the citation training objective entirely, along with its data. In train performance drops from sixty one point nine to sixty one point eight. Out of train drops from fifty seven point nine to fifty seven point five. The authors' own word for what that shows is hinting.
[S] Four tenths of a point out of train, no significance test, on a different base model. That is an honest hedge and a very thin result.
[O] What changes if this holds?
[G] Practically, if you are indexing paper embeddings at scale, the paper's own recommendation is the cheap one. SPECTER two Base plus format adapters. One million parameters per format, no measurable training overhead. Skip the ensemble.
[S] And for benchmark design, which is our beat, the thing I am taking away is the correlation audit. They computed inter task correlations across their own model runs and used it to argue their suite is more diverse than the one it replaces. More benchmark papers should print that matrix. It is the cheapest available check on whether an N task average is really N signals.
[O] And mine is the negative result. A large multi task training set is not automatically a better representation. The bottleneck was the output shape, not the data. That generalizes well beyond scientific papers.
[G] The paper's own takeaway: a single embedding per document limits generalization across task formats, and giving each document a separate embedding per format recovers a measurable part of that, consistently across three different base encoders.
[O] Mine: the cleanest thing here is the control. Multi task training alone bought nothing. Only the change in output shape did. That is a rare, well isolated architectural fact.
[S] Mine: a better benchmark than the one it replaces, and a worse scoreboard than its own headline suggests. The winner ties with two cheaper systems, two of the paper's own claims do not match its own tables, and whether any of these scores predict a better product is explicitly untested.
[O] The full writeup, with the figures, the tables and the references, is on the litsearch site. Thank you Cressida.
