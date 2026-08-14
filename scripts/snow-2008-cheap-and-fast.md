---
slug: snow-2008-cheap-and-fast
title: "Cheap and Fast – But is it Good? Evaluating Non-Expert Annotations for Natural Language Tasks"
description: "In 2008, twenty five dollars and eighty two cents bought twenty one thousand six hundred and ninety labels across five NLP tasks, and the answer to a question nobody had asked properly: how many anonymous strangers does it take to equal one trained annotator? The answer was four. The reasons to distrust that four are also in the paper, including two cells of a table that hold each other's numbers."
date: 2026-08-03
guest_name: "Rosalind"
guest_voice: "bf_alice"
---
[O] Twenty five dollars and eighty two cents. Twenty one thousand six hundred and ninety labels. Five different natural language tasks. And the finding that four anonymous strangers on Mechanical Turk, averaged together, agree with expert annotators about as well as an expert does.
[S] And the number everyone quotes from this paper is the one I trust least, because on four of those five tasks the expert baseline is borrowed from somebody else's study, and on the fifth there is no expert baseline at all.
[O] All fair. But hold the training experiment, because that one is internal and controlled, and it is the result that should genuinely have unsettled people. Cheap labels did not merely evaluate as well as expert labels. They trained better systems.
[S] That sentence has a hidden qualifier in it and I want it out in the open before we are done.
[O] It does, and we will get it out. Welcome to Litsearch Audio. Today's paper is Cheap and Fast, But is it Good? Evaluating Non-Expert Annotations for Natural Language Tasks, by Rion Snow, Brendan O'Connor, Daniel Jurafsky and Andrew Ng, at EMNLP 2008.
[S] Two thousand five hundred and twenty citations as of today. It is the founding empirical study of crowdsourced annotation for our field, and it is old enough that reading it now is a slightly strange experience.
[O] Joining us is Rosalind, who knows this paper and the annotation literature around it closely. Rosalind, welcome. Set the scene for us. 2008. What did the world look like?
[G] Thank you. The framing to hold onto is that this is a paper about a bottleneck, not about a technology. By 2008 the field's landmark resources all had the same shape. The Penn Treebank, PropBank, TimeBank, FrameNet, SemCor. Each of those is years of trained annotator labour, and each one enabled a generation of work.
[S] And the demand curve was going the wrong way.
[G] Exactly the wrong way. The authors cite Banko and Brill from 2001, the result that scaling data reliably beats improving the algorithm. If you believe that finding, and by 2008 most people did, then your appetite for labelled data grows faster than any expert annotation pipeline can possibly feed it. That is the tension the paper opens on.
[O] And Mechanical Turk had existed since 2005.
[G] It had, and this is the part that surprises people. It was not that nobody had used it. There was already a scattering of work. Su and colleagues had workers do hotel name entity resolution. Kittur and colleagues had them rate Wikipedia article quality, and found that validation tests mattered a great deal. Sorokin and Forsyth collected machine vision data and reported speed and costs the authors say match their own.
[S] So what is left to contribute?
[G] Task generality, and a controlled comparison. Every one of those was a single task in isolation, and several ran without any external gold standard to check against at all. What had not been done was a rigorous, task general test. Take several genuinely different linguistic tasks, each of which already has an expert gold standard, and ask a set of questions as a set.
[O] And there is a prehistory before Mechanical Turk too.
[G] There is, and it is a different philosophy. Luis von Ahn's games, the ESP Game for image labels, Verbosity for word relations. The Open Mind Initiative. Those were volunteer efforts, where the design problem was making annotation fun enough that people would do it free. Mechanical Turk replaced fun with money, and money scales more predictably.
[S] Give me the questions, then. What is the actual list?
[G] Four, and they are refreshingly concrete. How many non-expert labels does it take to equal one expert's? Does the answer depend on the task? Can non-expert labels train a machine learning system as well as expert labels can? And when individual annotators are unreliable, is there a cheap way to correct for that without collecting more data?
[O] Take us into the design, Rosalind. What is the same across all five tasks?
[G] Two constraints do a lot of work. First, every task is restricted to a multiple choice response or a numeric input within a fixed range. No free text, no spans, no structure. That is a real scoping decision and it is why aggregation is easy later. Second, for every item they collect exactly ten independent annotations, which is what makes the whole subset analysis possible.
[S] And the five tasks?
[G] Affect recognition, word similarity, recognizing textual entailment, event temporal ordering, and word sense disambiguation. Each chosen because a pre-existing expert gold standard existed for it.
[O] Start with affect, because that is where the headline number comes from.
[G] Affect is the richest, because it is the one task where they have a live pool of experts rather than a single frozen gold file. It builds on the SemEval affective text task. An annotator sees a short news headline and gives numeric judgments from zero to one hundred for six emotions, anger, disgust, fear, joy, sadness and surprise, plus a single valence rating from minus one hundred to plus one hundred. Seven numbers per headline.
[S] Sample size?
[G] One hundred headlines, sampled from the original SemEval test set, ten annotations for each of the seven label types. Seven thousand labels.
[O] And crucially, six experts had already labelled those same headlines.
[G] They had, and that is what makes the comparison unusually clean. The metric is inter-annotator agreement, and the authors define it carefully. You take one annotator's labels and compute the Pearson correlation with the average of the other five annotators' labels. Do that for each expert against the other five, and average, and you get the column the paper calls E versus E.
[S] So every annotator is being scored against a five person consensus that excludes them.
[G] Precisely. And then you do the same thing for a single non-expert against those same sets of five experts, and that is NE versus E. There are two more columns where the comparison pool is experts and non-experts together, E versus All and NE versus All.
[O] What does that table say?
[G] It says exactly what a sceptic would predict, and the authors say so plainly. Experts agree with experts more than non-experts agree with experts, on every single emotion. Anger, point four five nine for experts against point four four four for non-experts. Fear, point seven one one against point four one eight. Surprise, point four six four against point two zero one.
[S] That surprise gap is enormous. More than a factor of two.
[G] It is, and it is worth pausing on because it prefigures a real limitation. The emotions are not equally learnable by an untrained person. Surprise and joy are where non-experts are weakest, and joy is the emotion that will haunt the training experiment later.
[O] So individual non-experts lose. Then comes the move the paper is famous for.
[G] The move is pooling. Take every possible subset of n of the ten non-expert annotations, average them into a single score, and treat that average as though it were one annotator. The authors call it a meta-labeler. Then ask, at what n does that meta-labeler's agreement first reach or beat a single expert's? They call that number k.
[S] And the answers.
[G] Wildly variable by emotion, which is itself a finding. Anger needs two, point five three six against a single expert's point four five nine. Disgust needs two, point six two seven against point five eight three. Sadness needs two. Valence needs five. Joy needs seven, and only barely, point six zero zero against point five nine six. Surprise needs nine, point four eight one against point four six four.
[O] And fear?
[G] Fear never crosses. All ten pooled non-experts reach point six eight nine, and a single expert is at point seven one one. Ten is not enough, and the paper does not hide it.
[S] So the famous number, four, is an average across seven quite different situations that range from two to never.
[G] That is a fair characterisation. Pooling across all seven of the affect and valence sub-tasks, the minimum crossing point is four, where four pooled non-experts reach point six one three against a single expert's point six zero three.
[O] And the cost of that.
[G] Two dollars bought all seven thousand affect labels. That is three thousand five hundred non-expert labels per dollar. Divide by four, and the authors' framing is at least eight hundred and seventy five expert-equivalent labels per dollar.
[S] Rosalind, I want to interrupt the tour, because you just quoted point six zero three as the single expert average, and I have read this paper's first table, and I do not think it can add up.
[G] You are right, and I was going to come to it, but let us do it now because it is the sharpest checkable thing in the paper. Table one's expert-versus-expert column prints an all-task average of point five eight zero. The mean of its own seven cells is point six zero two.
[S] That is not a rounding difference.
[G] It is not. And the same table's expert-versus-all column prints a six emotion average of point six zero three, where the mean of its own six cells is point five eight zero. Those are each other's numbers. Two cells, transposed.
[O] How confident are you that it is a transposition and not two independent errors?
[G] Quite confident, and here is the evidence. The two non-expert columns in that same table reconcile cleanly with their own cells, both of them, both summary rows. And the identical seven expert values are reprinted in table two as the one-expert column, where the reported all-task average is point six zero three, and there it reconciles. So the correct value exists elsewhere in the paper. I will report it as a transposition and I will not speculate about how it happened.
[S] Does it change a conclusion?
[G] No conclusion moves. But it does change the apparent size of one claim, and this is worth a researcher's attention. The paper says that adding non-experts to the gold standard pool improves agreement. With the printed numbers that looks like a jump from point five eight zero to point six zero seven, nearly three points. With the corrected numbers it is point six zero two to point six zero six. The direction survives. The magnitude mostly does not.
[O] That is a genuinely useful correction and I am glad it is on the record. Let us do the other four tasks, because they are quick.
[G] Word similarity first, and it is the one that reads as almost comic. Thirty word pairs, replicating Miller and Charles from 1991. Ten annotators rate similarity from zero to ten. Boy and lad at one end, noon and string at the other. Ten pooled annotators reach a correlation of point nine five two with the published gold ratings. Resnik's 1999 benchmark with ten human subjects was point nine five eight.
[S] So essentially indistinguishable.
[G] Essentially. And the speed is the headline. Three hundred annotations, completed in under eleven minutes from the moment of submission. That is one thousand seven hundred and twenty four annotations per hour. It cost twenty cents.
[O] Twenty cents.
[G] Twenty cents. Then recognizing textual entailment. This is PASCAL RTE-1, binary judgments about whether a hypothesis sentence follows from a text sentence. They collected the full eight hundred pair set, eight thousand labels, for eight dollars. The accuracy analysis runs on a one hundred pair subsample, and ten annotator majority voting reaches eighty nine point seven percent.
[S] And the expert range for that corpus.
[G] Ninety one to ninety six percent agreement, reported over various subsections. So majority voting lands under the band, not inside it.
[S] Good. Then let us be honest about that one, because the summaries of this paper never are. On its flagship semantic task, the crowd does not reach expert agreement.
[G] I want to give the paper its due here, because that is only half the sentence. Eighty nine point seven is raw majority voting. Majority voting is not what the paper is proposing. The proposal is the bias corrected model, and in figure seven the gold calibrated curve climbs past the ninety one percent lower bound by ten annotators. The dashed reference line in that figure sits at exactly point nine one.
[O] So the correction is what closes the gap.
[G] The correction is exactly what closes the gap that majority voting leaves open. If you cite eighty nine point seven as the paper's RTE result, you are citing its baseline rather than its method.
[S] That is a fair correction of me. Accepted. Keep going.
[G] Event temporal ordering. This is a deliberately simplified version of TimeBank. TimeBank has fourteen temporal relations over both nouns and verbs. The authors restrict it to two labels, strictly before and strictly after, and to verb events only. Four hundred and sixty two verb pairs, four thousand six hundred and twenty labels. Ten annotator voting reaches point nine four accuracy.
[S] Against what?
[G] Against nothing matched. And the paper says so directly. The only expert number available is point seven seven inter-annotator agreement on the full fourteen label task over both nouns and verbs, and the authors' own words are that it is the more general task. That is the fifth task with no like-for-like baseline.
[O] It also cost the most, by a wide margin.
[G] Thirteen dollars and eighty six cents for four thousand six hundred labels. Three hundred and thirty three labels per dollar, against three thousand five hundred for affect. Harder tasks cost more, which is worth noting for anyone budgeting from this paper's headline rate.
[S] And word sense disambiguation.
[G] The smallest and the most charming. Disambiguating the word president in SemEval sentences. Three senses. Executive of a firm, head of a country other than the US, head of the US. One hundred and seventy seven examples. Majority voting plateaus at point nine nine four accuracy, above the best automatic system's point nine eight.
[O] And there is a story in the remaining error.
[G] There is. There was exactly one disagreement between the crowd vote and the gold standard, and the crowd had voted nine to one against the gold label. On inspection it was an error in the original SemEval gold annotation. The sentence began, the Egyptian president said he would visit Libya today, and it had been marked as the head of a company sense. Correct that, and non-expert accuracy is one hundred percent.
[S] I will concede that is a lovely result, and it is the one that generalises furthest. Crowd disagreement as a gold standard audit.
[O] Totals across everything?
[G] Twenty five dollars and eighty two cents, twenty one thousand six hundred and ninety labels, one hundred and forty three point nine hours. Eight hundred and forty labels per dollar overall.
[S] One caution on that hours figure. Read the definition.
[G] You are right to flag it. The paper defines time as the total elapsed hours from submitting the group of tasks until the last worker submits the last assignment. It is wall clock latency, not aggregate worker labour. RTE shows eighty nine point three hours, and that is a queue draining, not eighty nine hours of anyone working.
[O] Let us do the bias correction properly, because it is the contribution I think gets under-read.
[G] It follows Dawid and Skene from 1979, who were the first to handle multiple annotators per example with unknown true labels. Each worker's response is modelled as conditionally independent of every other worker's given the true label. So each worker gets a confusion matrix, and the votes integrate through Bayes' rule into a posterior log odds.
[S] Which in practice is what?
[G] Weighted voting. Each worker's vote is weighted by their own log likelihood ratio. And the intuition is the nice part. Workers who are better than fifty percent accurate get positive votes. Workers whose labels are pure noise get votes near zero, so they cost you nothing rather than actively hurting. And systematically wrong workers, anti-correlated ones, get negative weights.
[O] So a reliably wrong worker becomes useful signal rather than something to throw away.
[G] That is exactly the elegance of it. The fitting is modest. Laplace smoothing of one pseudocount, uniform label priors, twenty fold cross validation across examples. And a Gaussian variant for the numeric affect task, where each worker gets a mean offset and a variance rather than a confusion matrix.
[S] And the gains.
[G] Four percent on RTE and three point four percent on event ordering, both averaged across two through ten annotators. Point six percent on the numeric affect correlations. Word sense disambiguation was left alone because it was already at ceiling. And all of that comes from re-weighting labels they had already paid for. Not one additional annotation.
[S] Here is my objection, and I think it is the real one. Dawid and Skene's original method is EM with unknown true labels. It needs no gold. These authors deliberately went the other way and used gold labelled training data to fit the worker models. So the method that rescues the crowd requires the expert you were trying to avoid.
[G] That is a correct reading of what they did, and the paper does not hide the choice. They cite Albert and Dodd from 2004, who reviewed the latent class models that need no gold, argued they have various shortcomings, and emphasised the importance of having a gold standard. So it is a considered decision rather than an oversight.
[O] But your point stands that it changes the economics.
[G] It changes the shape of the claim. It is not annotation without experts. It is annotation with a small amount of expert calibration data amortised across a large volume of cheap labels. Which, for a large collection effort, is still an enormous saving. For a small one, less so.
[S] I will take that formulation. It is more honest than how the paper is usually summarised.
[O] Now the training experiment, which is what I have been waiting for.
[G] The classifier is deliberately trivial, modelled on the SWAT system that did well at SemEval. For each token, its weight for an emotion is just the average emotion score of the headlines it appears in. To score a new headline, average the weights of the tokens you have seen. No lemmatisation, no synonym expansion, whitespace tokens.
[S] Training data?
[G] The one hundred headlines that got the crowd labels. Test on the remaining nine hundred, with gold being the average of five held out experts. Then train one system per individual expert, six of them, average their performance. That is the one-expert column.
[O] And the crowd systems beat them.
[G] On five of the seven emotion and valence rows, a single set of non-expert annotations is already enough. Anger, point one seven two against the expert's point zero eight four. Disgust, point one eight five against point one three zero. Fear, point one seven six against point one five nine. Sadness, point one four one against point one two seven. Surprise, point zero six one against point zero six zero.
[S] Surprise by one thousandth. Let us not oversell that one.
[G] Agreed, that row is a tie in all but the ordering. Valence needs two sets, and joy never crosses at all. Ten pooled non-expert sets reach point one two five against the expert's point one three zero.
[O] Rosalind, this is where I want to make sure the listener gets the scoping right, because I have seen this claim mangled.
[G] Please, because it matters and the mangling is easy. The paper's sentence is that for five of the seven tasks, the average system trained with a single set of non-expert annotations outperforms the average system trained with the labels from a single expert. That is scoped to one annotation set. It is the k equals one column, and exactly five rows sit at one. The paper is correct as written.
[S] And the other true thing that is not that thing?
[G] Separately, pooling all ten non-expert sets beats the single expert on six of seven, with joy the exception. Both statements are true. They are different statements about different columns, and merging them misattributes the six to the paper's headline claim.
[O] Now, what is a single set of non-expert annotations, actually? Because I think that phrase misleads people.
[G] It misleads badly, and this is the crux of the result. A single set is one label per item, but the labels in that set are not from one person. They come from whichever workers happened to take each item. So a single non-expert set is already a diverse committee spread across items, whereas a single expert set is genuinely one person on every item.
[S] So the comparison is not one amateur against one professional.
[G] It is not, and the authors offer exactly that as their hypothesis for what they call the non-intuitive result. Individual labellers, including experts, tend to have strong biases. The annotator diversity inside a single non-expert set reduces that bias. It is a variance reduction argument, not a competence argument.
[S] That reframing takes most of the sting out of it for me. It is not that amateurs are better than experts. It is that six different amateurs are better than one expert repeated six hundred times, because one person's idiosyncrasy is correlated across all their labels.
[G] That is a fair statement of it, and I think it is the durable lesson.
[O] Let me make the optimist case and then you can take it apart. This paper did something rare. It asked a question that had a number as its answer, it ran five genuinely different tasks, it used pre-existing gold standards it did not control, it published its data and its full experimental design, and it found a method that improves results with zero additional spend. And it did all of that for twenty five dollars.
[S] Here is mine. Not a single confidence interval appears anywhere in this paper. Not on the agreement curves, not on the bias correction gains. And the samples are thirty word pairs, one hundred headlines, a one hundred pair RTE subsample, one hundred and seventy seven word sense examples. Thirty word pairs.
[O] The word similarity task is replicating a 1991 study that also used thirty pairs.
[S] Which explains it and does not fix it. Every headline number in this paper is a single point estimate on a small sample, and several of the crossings are separated by thousandths. Joy crosses by four thousandths. Surprise, in the training table, by one.
[G] Both of you are on solid ground and I can score it. The absence of variance reporting is real and it is the paper's clearest methodological gap by modern standards. On the other side, the effects that carry the argument are not the marginal ones. Anger going from point four five nine to point six seven five with ten annotators is not a thousandths-level effect.
[S] I also want to say something about the training table that neither of you has. Look at the absolute numbers. The best system in that table correlates at point two four seven. The worst expert-trained system is at point zero six zero. These are all very weak systems.
[G] That is a correct observation and the paper does not draw attention to it. It is a bag of words model trained on one hundred headlines. The comparison between the two training regimes is internally valid, because both sides get the same architecture and the same one hundred headlines. But you should not read those correlations as a statement about achievable affect recognition.
[O] I will take that. The claim is relative, not absolute.
[G] And there is one more slip in that table, smaller than the first but the same kind. Its k column is defined as the number of non-expert annotations needed to match one expert. Valence lists k of two, against a two annotation score of point one four six, which is below the single expert's point one five nine that it is meant to have reached. It is the only row of seven where the table's own k fails its own definition.
[S] So two arithmetic problems, in two different tables, both findable by a reader with a calculator.
[G] Both findable, neither consequential to the conclusions, and both worth knowing if you are going to cite the exact figures. Which people do, because this paper is cited two and a half thousand times.
[O] What about the thing that has changed since?
[G] This is the one that would keep me up. The entire study rests on a premise about a population. Anonymous, unvetted, paid humans. Multiple studies since 2023 have found that a meaningful fraction of Mechanical Turk workers now use large language models to generate their responses.
[S] Which quietly collapses non-expert human judgment into human-relayed model judgment.
[G] For exactly the kind of bounded, multiple choice, text-in task this paper pioneered. So a literal rerun today would not be a replication. It would be measuring a different thing under the same name, and you would not be able to tell from the response format.
[O] Does the paper's machinery still help there?
[G] Interestingly, some of it does. The worker level bias model does not care why a worker is reliable or unreliable. It measures their error pattern against gold and weights accordingly. That framework survives the population change even if the interpretation of the result does not.
[S] What is the honest inheritance of this paper, then? Because I think it is not the number four.
[G] I think the inheritance is the question form. Before this, human evaluation was assumed to be a fixed quantity, you had annotators or you did not. This paper made annotator quality a dial with a price attached, and made how many annotators do you need a question with a measurable answer.
[O] And every human evaluation protocol since has had to argue about annotator expertise, whether it wanted to or not.
[G] Precisely. The line runs straight from here. How many crowd workers, then how many crowd workers on Prolific, then how many model judges, and now how do you calibrate a judge against a small gold set. That last one is this paper's bias correction with the nouns changed.
[S] I will grant that the gold calibration idea aged better than the headline. Weighting a noisy annotator by their measured error pattern against a small trusted set is precisely what a serious judge calibration protocol does today.
[O] Rosalind, one sentence takeaway. The paper's, not yours.
[G] Across five tasks, a small pool of cheap non-expert annotations reaches or approaches single expert quality, four on average for affect, and a gold calibrated worker bias model recovers several more points of accuracy from labels you have already bought.
[S] Mine. The finding is real and the evidence is thinner than its reputation. No confidence intervals anywhere, one task with no matched baseline, two tables that do not reconcile with themselves, and a bias correction that quietly needs the experts the paper is arguing you can do without.
[O] And mine. Twenty five dollars, five tasks, a crowd that caught a genuine error in a published gold standard, and a reframing that survives everything the skeptic just said. Not amateurs beating experts. Diversity beating one person's consistent idiosyncrasy. That idea is still doing work in every evaluation protocol we run.
[S] The full writeup, with the tables, the figures, and the arithmetic laid out cell by cell, is on the litsearch site. Go check the transposition yourself. It takes a calculator and about ninety seconds.
