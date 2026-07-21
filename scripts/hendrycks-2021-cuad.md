---
slug: hendrycks-2021-cuad
title: "CUAD: An Expert-Annotated NLP Dataset for Legal Contract Review"
description: "Two million dollars of lawyer labor went into five hundred ten contracts so models could learn to find the clauses that matter — and at the recall threshold a cautious lawyer actually needs, nine out of ten models score exactly zero."
date: 2026-07-20
guest_name: "Isolde"
guest_voice: "bf_emma"
---
[S] Here's a benchmark that cost a conservative two million dollars in expert legal labor to build, and on the one operating point a risk-averse lawyer would actually accept, nine out of ten models score a flat zero.
[O] And the tenth model, the newest one, gets to seventeen point eight percent precision at that same point — which sounds bad until you remember the previous generation of models couldn't clear zero at all.
[S] Seventeen point eight percent precision means for every real clause the model finds, it also flags roughly four or five clauses that aren't there. That's noise with a diploma, not a first-pass assistant.
[O] Or it's the first rung of a ladder that didn't exist three years earlier. That's the tension worth spending an episode on.
[O] Welcome to Litsearch Audio. I'm your optimist host, and across the table, as always, is our skeptic.
[S] Today we're covering CUAD: An Expert-Annotated NLP Dataset for Legal Contract Review, by Dan Hendrycks, Collin Burns, Anya Chen, and Spencer Ball, out of UC Berkeley, The Nueva School, and The Atticus Project — a NeurIPS twenty twenty one Datasets and Benchmarks paper.
[O] And joining us is Isolde, a scholar who has spent real time with this dataset and what it measures. Isolde, welcome.
[G] Thanks for having me. CUAD is a good stress test for evaluation in general, because the hard part here was never the model, it was getting the labels at all.
[S] Why does that matter more than for other NLP tasks?
[G] Because you can't shortcut it. Most specialized domains have something to scrape — machine translation has parallel web text, code has GitHub. There's no free corpus of contract-review annotations sitting online. If you want labels, you pay lawyers.
[O] So set up the problem. Why does contract review need automating in the first place?
[G] Reviewing a contract is one of the most tedious, expensive tasks in law. Firms spend roughly half their time on it, at billing rates around five hundred to nine hundred dollars an hour in the U.S. A single transaction's review can run into the hundreds of thousands of dollars.
[S] And that cost doesn't stay contained to corporate deals.
[G] Right — that's the access-to-justice angle. Because review is so expensive, small businesses and individuals routinely sign contracts they never read carefully, which opens the door to predatory terms nobody caught.
[O] And before CUAD, nobody had built the dataset to test whether models could help with that.
[G] Correct. Prior legal NLP work covered judgment prediction, entity extraction, statutory question answering — mostly in Chinese or EU legislation. The closest prior contract-review dataset, from Leivaditi and colleagues in twenty twenty, covered one contract type, leases, fewer label categories, and over an order of magnitude fewer annotations than CUAD.
[S] So the honest baseline before this paper was: nobody actually knows whether transformers transfer to a domain like this.
[G] That's the framing almost verbatim. Models had already beaten humans on tasks like SQuAD two point oh and SuperGLUE, tasks any fluent adult can do. Whether that transfers to domains where humans need years of training was an open question, and answering it required a large expert-labeled dataset that didn't exist yet.
[O] Let's get into what CUAD actually is.
[G] CUAD stands for the Contract Understanding Atticus Dataset, pronounced "kwad" — like squad without the S. It's five hundred ten commercial contracts spanning twenty five contract types — license agreements, supply agreements, joint ventures, franchise agreements, and more — pulled from the SEC's public EDGAR filing system, since public companies are required to file certain contracts there.
[S] Why EDGAR specifically?
[G] It's free and public, which matters for an open dataset. And the authors are upfront that EDGAR contracts skew more complicated and heavily negotiated than the general population — a feature here, since a single filer can have dozens of contracts containing a clause type, like exclusivity, that would be rare almost anywhere else.
[O] And the labeling on top of those contracts?
[G] Thirteen thousand one hundred and one expert-labeled clauses across forty one categories lawyers specifically look for — governing law, change of control, non-compete, uncapped liability, and so on. They're grouped into general information like party names and dates, restrictive covenants that constrain how a business can operate, and revenue risks like uncapped liability or minimum purchase commitments.
[S] Forty one categories is a lot of surface area for a first benchmark.
[G] It's deliberate — a lawyer's review checklist has dozens of items on it, not one, and a benchmark testing only a handful wouldn't capture real review.
[O] Isolde, this is the part I think is the real contribution — not the models, the annotation pipeline. Walk us through it.
[G] Seven steps. Law student annotators first went through seventy to one hundred hours of training — video instruction from experienced attorneys, live workshops, quizzes — and worked from over one hundred pages of written annotation standards the authors wrote themselves.
[S] A hundred pages of instructions for forty one categories is closer to onboarding a junior associate than a labeling task.
[G] That's about right. After training: students label, then a keyword search catches anything missed, then students review their own work category by category and flag suspected errors, then experienced attorneys review those flags with the students until they reach consensus.
[O] And there's a step where they check against an AI tool's own suggestions?
[G] The sixth step. They ran an existing AI contract tool, eBrevia, and generated a list of clauses it flagged that humans hadn't caught. Attorneys and students reviewed every one of those "extras," repeating until almost all the remaining extras were genuinely wrong — so the tool served as a recall check on the humans, not as the label source.
[S] How many eyes on each final label?
[G] Every annotation was checked by three additional annotators beyond the original labeler, four passes total. Across the full set, over nine thousand pages were reviewed at least four times each, at five to ten minutes per page, at an assumed rate of five hundred dollars an hour. The paper's own conservative estimate of that labor's value is over two million dollars.
[O] That number is doing a lot of work — it's what makes CUAD hard to replicate casually.
[S] It's also a number I'd want audited independently, but the process described — four-pass verification with attorney sign-off — is a real standard, not a marketing line.
[O] How did they turn that labeling into an actual task?
[G] Extractive question answering, in the SQuAD two point oh format, so any off-the-shelf QA model applies. For each category, they write a short question — "highlight the parts, if any, of this clause related to" the category, plus a description — and the model outputs the start and end token of the relevant span, or nothing if it doesn't apply.
[S] Most paragraphs presumably match none of the forty one categories.
[G] Right, over ninety nine percent of the sliding-window segments contain none of the labels. Left alone, a model just learns to predict "nothing" every time. So training downweights the empty examples to roughly balance positives and negatives.
[O] And how do you feed a hundred-fifty-page contract into a model that reads five hundred twelve tokens at once?
[G] A sliding window — you chop the contract into overlapping chunks, run the question against each, and stitch predictions back together.
[S] How do you score whether a predicted span counts as correct? Legal text has a lot of nested sub-clauses.
[G] Jaccard similarity between the words in the prediction and the gold annotation, matched at a threshold of point five — fifty percent word overlap, chosen empirically as what the authors call qualitatively reasonable.
[O] And since most of a contract is irrelevant to any given label, plain accuracy would be meaningless.
[G] Exactly, so the headline metrics are precision-recall based: area under the precision-recall curve, called AUPR, plus precision at eighty percent recall and precision at ninety percent recall. Recall is the axis that matters here — missing a clause is the expensive failure, not flagging an extra one.
[S] Which models did they run?
[G] Ten fine-tuned encoders: BERT base and large, four sizes of ALBERT, RoBERTa base with and without extra contract pretraining, RoBERTa large, and DeBERTa extra-large — trained on eight A100 GPUs, with a grid search over learning rate and epochs, on an eighty-twenty random split of the five hundred ten contracts.
[O] What's the headline result?
[G] DeBERTa extra-large wins across the board: AUPR of forty seven point eight percent, precision at eighty percent recall of forty four percent, precision at ninety percent recall of seventeen point eight percent. BERT base gets an AUPR of thirty two point four percent and precision at eighty percent recall of just eight point two percent.
[S] So over roughly three years of model progress, that eighty-percent-recall precision number went from eight to forty four.
[G] That's the trend line the paper leans on, and it's real. But the number that gets less attention is precision at ninety percent recall — the stricter threshold. Nine of the ten models score exactly zero there. Only DeBERTa extra-large is non-zero, at seventeen point eight.
[O] Meaning the other nine models can't recover ninety percent of the true clauses without flooding the reviewer with false positives past any usable threshold.
[G] That's the honest read of a zero. Even at eighty percent recall, precision in the thirty-to-forty range means a lawyer reads roughly two irrelevant flagged clauses for every relevant one — the paper states that math itself.
[S] What's the most interesting negative result?
[G] That model size alone barely moves the needle. ALBERT extra-extra-large has about twenty times the parameters of ALBERT base, for only about three points higher AUPR. BERT base and BERT large score almost identically, thirty two point four versus thirty two point three.
[O] So what does move it?
[G] Two things. Model design — DeBERTa's disentangled attention clearly outperforms BERT-style architectures at similar scale. And training data volume, more strikingly. Holding RoBERTa base fixed, an order of magnitude more training annotations lifts AUPR from twenty seven point six to forty two point six percent — a fifteen-point jump.
[S] How does that compare to the entire spread across every model tested?
[G] It's almost the whole spread — fifteen point four points separates the worst and best model in the table. One order of magnitude more expert-labeled data buys nearly as much as swapping architecture from weakest to strongest.
[O] That's a striking result — the dataset itself, not the modeling, is the scarce resource.
[G] And it cuts the other way too. They pretrained RoBERTa base with masked language modeling on about eight gigabytes of unlabeled EDGAR contracts, and it only bought about three points of AUPR. Unlabeled data barely helps; labeled data helps enormously.
[S] Cheap unlabeled text is nearly worthless here, expensive expert labels are where the value sits.
[O] What about performance across the forty one individual categories?
[G] Wildly uneven. DeBERTa extra-large nearly ceilings on boilerplate — governing law, document name, party names, dates. But high-stakes, variably worded categories like covenant not to sue, IP ownership assignment, and right of first refusal sit around twenty percent AUPR.
[S] That's what worries me most — the categories the model is worst at are exactly the rare, high-stakes ones a lawyer is most likely to miss without help.
[O] Let's argue this properly. Optimist case first: this paper took a domain nobody had benchmarked and got a model finding forty four percent of relevant text cleanly at a usable recall level, in under three years of model progress, off one well-built dataset. Eight percent to forty four is exactly the kind of trajectory that tells a field where to invest.
[S] Deflationary case: the number that maps onto how a careful lawyer would actually use this is precision at ninety percent recall, not eighty, because missing a change-of-control or uncapped-liability clause is the failure that causes real harm. At that threshold, ninety percent of the models here are functionally useless, and even the best implies four or five false positives per true one.
[G] Both grounded in the paper. The eighty-versus-ninety split is the crux. The paper itself says eighty percent recall "may already be reasonable for some lawyers" — but that's asserted, not measured against any actual lawyer's tolerance.
[O] Fair hit. Though the paper is explicit that recall matters more than precision here, since it's a haystack problem — even a noisy eighty-percent-recall filter has value as a first pass, not a final answer.
[S] My second concern is the match criterion. Fifty percent word overlap counting as a hit is lenient, because the paper's own appendix admits often only a sub-part of a sentence is responsive — a carve-out, an exception, a dollar figure. A prediction can clear that threshold while capturing surrounding boilerplate and missing the operative words.
[G] That's the paper's own language, not an outside critique. Fifty percent overlap is a coarse bar for a domain where meaning concentrates in sub-parts.
[S] Third, and sharpest: the split. It's a random eighty-twenty over contracts, but these are EDGAR filings, where the same filer and contract type share heavy boilerplate. Near-duplicate clauses can land on both sides, flattering apparent generalization. No filer-disjoint or type-disjoint split is reported.
[G] A real open question, not a refuted one. And there's a smaller wrinkle nearby — one category, Price Restriction, drew zero test examples purely from how the random split fell, so results effectively cover forty of the forty one categories.
[O] I'll push back once more before we move on — whatever you think of the split, the paper doesn't oversell itself. Its own conclusion calls performance nascent, with substantial room for improvement.
[S] Granted, this paper is unusually honest about its own limits. My last concern is the target population. The motivation invokes consumers signing leases and terms of service they don't understand. But EDGAR contracts are, in the authors' own words, more complicated and heavily negotiated than the general population.
[G] That's a real gap between the stated motivation and the sampled distribution, in the authors' own description. Defensible — negotiated commercial contracts surface rare clause types a form lease never would — but transfer to the consumer-contract setting the introduction opens with is untested.
[O] So where does that leave us on what this paper actually proves?
[G] My read is that CUAD's lasting contribution is the dataset, not the model scores. The paper's own strongest evidence for that is internal: an order of magnitude more labeled data buys roughly as much as the entire architecture gap from BERT to DeBERTa, while eight gigabytes of unlabeled text buys almost nothing.
[S] And what's missing, not wrong: no baseline lawyer precision or recall number, no inter-annotator agreement statistic despite the four-pass process, and no evaluation of the released yes-or-no risk answers the dataset also includes. Those would raise my confidence a lot.
[O] Does this connect beyond legal NLP?
[G] It's become something of a template — later legal-NLP benchmarks, including LexGLUE and LegalBench, build on it as the canonical expert-annotated legal asset. More broadly, it's a clean lesson: reporting a score at one recall threshold can hide the exact failure mode that matters most for the application.
[S] The generalizable point worth keeping: a headline metric earns trust by matching the cost structure of the real error, not by looking good in a table.
[O] Isolde, one-sentence takeaway from the paper itself?
[G] That two million dollars of careful expert annotation unlocked a specialized domain that raw scale and unlabeled text could barely touch — expert-labeled data, not bigger models, moved this benchmark.
[O] Mine is that CUAD proved contract review is tractable enough to be worth serious research investment — the BERT-to-DeBERTa trajectory is the kind of early signal that tells you a field is about to move fast.
[S] And mine is that read at the recall threshold that actually matters for legal work, this benchmark is still a long way from something you'd let near a real contract without a lawyer checking every flag — which is what the authors themselves say, if you read past the headline forty four percent.
[O] That's CUAD. For the full precision-recall curves, the per-category breakdown, and the complete eval critique, head to the writeup on the Litsearch site. Thanks for listening.
