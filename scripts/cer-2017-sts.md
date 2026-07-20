---
slug: cer-2017-sts
title: "SemEval-2017 Task 1: Semantic Textual Similarity Multilingual and Crosslingual Focused Evaluation"
description: "A multilingual SemEval shared task that, almost as an afterthought, produced the STS Benchmark, the fixed sentence-similarity yardstick the field still cites a decade later, even though the paper's own hard-case table shows top systems scoring a sentence and its near-exact reversal as almost identical."
date: 2026-07-19
guest_name: "Julian"
guest_voice: "bm_george"
---
[O] Here's a benchmark that's been the default yardstick for sentence embeddings for the better part of a decade, and buried in its own appendix is a sentence pair where every single top system got the meaning almost completely backwards.
[S] "A man is carrying a canoe with a dog" versus "a dog is carrying a man in a canoe." Same content words, opposite meaning, and the best systems in twenty seventeen scored those two sentences as nearly identical.
[O] And yet this exact test set is still the one InferSent, Sentence-BERT, and SimCSE all report a number against.
[S] Which is exactly why we should look hard at what that number is actually measuring.
[O] Welcome to Litsearch Audio, where each episode we dig into one paper from the litsearch dot darvinyi dot com atlas.
[S] Today's paper is SemEval twenty seventeen Task One, Semantic Textual Similarity, Multilingual and Crosslingual Focused Evaluation, by Daniel Cer and colleagues, spanning Google Research, George Washington University, the University of the Basque Country, and the University of Sheffield.
[O] It's the paper that quietly created the STS Benchmark, now cited well over two thousand times, and joining us to walk through it is Julian, who's studied this shared task and its aftermath closely.
[G] Thanks for having me. It's a strange paper to talk about, because the multilingual shared task is the nominal subject, but the artifact everyone actually cites today is introduced almost in passing, in section eight.
[S] Let's set the stage first. Before twenty seventeen, what was actually wrong with Semantic Textual Similarity as a shared task?
[G] STS had run every year since twenty twelve, and it measures something specific: how similar two sentences are in meaning, on a graded scale, rather than a binary judgment like textual entailment. But each year pulled from a different grab bag of sources, news headlines, image captions, forum posts, glosses from lexical resources. There was no fixed split and no single citable snapshot.
[O] So if you were building a sentence-embedding method and wanted to report an STS number, you were kind of picking your own adventure.
[G] Exactly. You'd choose which years' data to evaluate on, and that made comparing papers to each other unreliable, right as the sentence-embedding literature was taking off. Deep averaging networks, LSTM encoders, weighted word-embedding baselines were all being proposed around then.
[S] And the second problem was language coverage.
[G] Right. Twenty twelve and twenty thirteen were English only. Twenty fourteen and fifteen added a Spanish track. Twenty sixteen added a small pilot for Spanish-English cross-lingual pairs. But Arabic, Turkish, and genuinely cross-lingual evaluation across four languages together had never happened in one task before this one.
[O] So Julian, walk us through how twenty seventeen's task actually works.
[G] Annotators score a pair of sentences from zero to five. Zero is completely dissimilar, five is meaning-equivalent, with interpretable half-steps in between. The paper's own example for a five is "the bird is bathing in the sink" against "birdie is washing itself in the water basin."
[S] And systems are scored how?
[G] By Pearson correlation between a system's predicted score and the human gold label. Six tracks span four languages: Arabic, Arabic-English, Spanish, two flavors of Spanish-English, English, and Turkish-English. Each track contributes two hundred fifty pairs, so seventeen hundred fifty evaluation pairs total. But the primary leaderboard number only averages tracks one through five. Turkish-English is scored separately, because it runs as a genuine surprise-language track, with the language pair's identity withheld until the evaluation data ships.
[O] Two flavors of Spanish-English?
[G] Track four A draws from the same source as everything else. Track four B is different, and it's the most interesting design choice in the paper. It pulls from the WMT, the Workshop on Machine Translation's, quality-estimation data instead, so you're scoring how similar a translation is to its source sentence, not two independently written sentences.
[S] Why build an entire separate track for that distinction?
[G] Because judging the subtle meaning drift introduced by translation errors is a genuinely different, harder task than judging two sentences someone wrote independently. The authors treat it differently end to end. It gets a single expert annotator instead of crowd workers, and no attempt is made to balance the data by similarity score, because translations of the same sentence are, almost by construction, going to score fairly high.
[O] Where does the underlying sentence pool come from for the other tracks?
[G] Mostly the Stanford Natural Language Inference corpus, SNLI, which itself derives from Flickr thirty-k image captions. Here's a subtlety worth dwelling on: SNLI's own pairings come bundled with entailment labels, and the authors deliberately don't reuse those pairings, because entailment strongly cues semantic relatedness. Reusing them would let the entailment label leak straight into the STS score.
[S] So how do they choose which sentences to pair instead?
[G] They compute fifty-dimensional GloVe word embeddings, sum them into a crude sentence vector, and use cosine similarity as a heuristic to surface pairs that look interesting, not too similar, not totally unrelated. Only then do they send the newly constructed pairs out for human annotation.
[O] And translation into the other languages?
[G] Human translation, not machine. Arabic comes from CMU-Qatar, where native speakers post-edit a machine-translation draft. Spanish is done entirely by one graduate student at Sheffield who's a native speaker. Turkish comes from a commercial vendor, SDL. The English gold score just carries over onto the translated pair.
[S] That Spanish pipeline is one person doing all the translation for an entire language track. That's a single point of failure sitting underneath every Spanish and Spanish-English number in this paper.
[G] It's worth flagging. The paper doesn't discuss inter-translator variance, because there's only one translator, so there's nothing to compare against.
[O] What about the actual scoring, who's giving the zero-to-five labels?
[G] Crowdsourcing on Amazon Mechanical Turk, for every track except four B. Annotators need the Master qualification, they're paid one dollar per twenty-pair batch, and five separate workers rate each pair. The gold score is just the mean of those five ratings.
[S] Do they report any inter-annotator agreement number, anything that tells us how noisy that mean actually is?
[G] No. That's genuinely absent from the paper, and it matters, because literally every ranking in this task depends on the reliability of that five-worker mean.
[O] Now the part that actually outlived the shared task, the Benchmark itself.
[G] Right, tucked into section eight. The authors take the English-only slice of all STS data from twenty twelve through twenty seventeen and package it into one fixed, partitioned set: eight thousand six hundred twenty-eight sentence pairs, split five thousand seven hundred forty-nine for training, fifteen hundred for development, and one thousand three hundred seventy-nine for test, spanning three genres, news, image and video captions, and forum posts.
[S] And that's the artifact everyone now just calls STS-B.
[G] That's the one. It's explicitly framed as a standing evaluation set, not a one-off snapshot, and that framing is exactly why it stuck.
[O] Let's get to the actual numbers. How many teams showed up?
[G] Strong participation, thirty-one teams, eighty-four submissions total, with seventeen teams contributing forty-four systems that covered every track.
[S] Who won?
[G] ECNU took the overall top spot, with an average Pearson correlation of seventy-three point two across the primary tracks. To be clear, the paper reports these on a zero-to-one-hundred scale, so seventy-three point two means a correlation coefficient of about zero point seven three. ECNU is an ensemble, three feature-engineered regressors, random forest, gradient boosting, and XGBoost, stacked together with four different deep sentence-embedding models: averaged, projected, a deep averaging network, and an LSTM encoder.
[O] So the winning recipe in twenty seventeen was still explicitly hybrid, hand-engineered features plus neural embeddings, not neural alone.
[G] Correct, and that's a real signal about where the field was. ECNU also won track two, Arabic-English, at about seventy-four point nine, track three, Spanish, at about eighty-five point six, and track six, the surprise Turkish-English track, at about seventy-seven point one.
[S] What about the tracks ECNU didn't win?
[G] BIT took Arabic at seventy-five point four. CompiLIG won the Spanish-English SNLI track at eighty-three. And on English, RTV narrowly beat DT Team, eighty-five point five versus eighty-five point four, a gap the paper's own significance test says isn't statistically distinguishable.
[O] And track four B, the machine-translation one?
[G] That's the one worth sitting with. SEF@UHH won it, and their winning score was thirty-four point one. Compare that to every other track's winner, which lands in the seventies or eighties. It's by far the weakest winning score of any track in the whole task.
[S] Do we know why it's so much harder?
[G] The paper measures this directly. They correlate the gold machine-translation-quality scores against the gold STS scores on the same sentence pairs and get a Pearson r of point four one. Translation quality and semantic similarity are related, but they're genuinely different signals, even on pairs that are translations of the same source sentence.
[O] What's the baseline doing, for context?
[G] A simple cosine similarity over binary sentence vectors, using machine translation for cross-lingual pairs, scores fifty-three point seven on average across tracks one through five. That would place it twenty-third out of the forty-four systems that ran every track, respectable for something this dumb, and a useful floor for judging how much the fancier systems actually buy you.
[S] Now the Benchmark results, the ones that actually get cited for the next decade.
[G] On the STS Benchmark test split, ECNU again tops the table at eighty-one, BIT right behind at eighty point nine, DT Team at seventy-nine point two, UdL at seventy-nine, and HCTI at seventy-eight point four. Then the paper compares those shared-task systems against sentence-embedding baselines from the wider literature that weren't built for this task at all.
[O] Like InferSent.
[G] Right, InferSent scores seventy-five point eight, Sent2Vec seventy-five point five, SIF seventy-two, PV-DBOW sixty-four point nine, C-PHRASE sixty-three point nine. Then plain averaged word embeddings trail further behind: Word2vec fifty-six point five, LexVec fifty-five point eight, FastText fifty-three point nine, Paragram fifty point one, and GloVe forty point six.
[S] That's a genuinely useful ladder, task-specific ensembles at the top, pretrained sentence encoders in the middle, averaged word vectors at the bottom, all measured on the same fixed test set.
[G] Which is precisely the property STS data was missing before this paper, and precisely why the sentence-embedding literature adopted it almost immediately.
[O] Okay, Julian, time to actually argue about what this means. My case is simple: this paper solved a real coordination problem. Before STS-B, you couldn't fully trust a cross-paper comparison. After it, every serious sentence-embedding paper, InferSent, SentEval, Sentence-BERT, SimCSE, reports the same one thousand three hundred seventy-nine test pairs, same metric, same split. That's the difference between a field that argues past itself and one that actually accumulates progress.
[S] I don't disagree that fixed benchmarks are valuable. My problem is what a single Pearson correlation quietly averages away. Table twelve is the paper's own hard-case audit, and it's damning. On the canoe-and-dog pair, reversed argument structure, human score one point eight, every one of the top five English systems scored it between three point two and five, "substantially similar" to "completely equivalent." On the negation pair, a swimmer with versus without goggles and a cap, scores ranged from point one all the way to four point eight against a human score of three. One correlation coefficient can't tell you whether a model is uniformly decent or specifically blind to negation and word order.
[O] Sure, but that's true of basically any single-number metric. You could level that critique at accuracy on any classification benchmark too.
[S] Except the paper hands you the tool to fix it and doesn't use it. The authors name five specific failure modes themselves, word-sense disambiguation, attribute importance, compositional meaning, negation, semantic blending, and then report exactly one aggregate number per system anyway.
[G] You're both right, and the paper's own data supports each side. On the coordination point, you're correct, this solved the field's real practical problem, and the adoption by InferSent, Sentence-BERT, and SimCSE proves it.
[S] So which of us is more right?
[G] I'd score it as: coordination win, real and durable; diagnostic power, genuinely limited, and the authors know it, they just don't act on that knowledge within this paper. There's a third point neither of you has raised, and it's arguably more consequential than either.
[O] Which is?
[G] Distributional familiarity, as distinct from label leakage. The authors are careful, they deliberately re-pair SNLI sentences so entailment labels can't leak into the STS scores, a sensible fix for a real problem, and they say so explicitly. But the underlying sentence surface distribution is still SNLI, and SNLI is a standard supervised training corpus for sentence encoders, InferSent is trained directly on SNLI's entailment objective. So a model trained on SNLI sentences, then evaluated on STS pairs built from SNLI sentences, is partly being tested on text whose style it's already seen. That's a different risk from the leakage problem the authors addressed, and the paper doesn't address it at all.
[S] That's a sharper point than mine, honestly. Contamination isn't just did you see the test label, it's did you see this distribution of language.
[O] I'll concede that one. It doesn't undercut the coordination benefit, but it means later papers citing a high STS-B number as proof of general sentence understanding are overclaiming a little.
[G] That's the right way to hold both conclusions at once.
[S] Zooming out, Julian, what does this mean for how we should build benchmarks in general, not just this one?
[G] A few things generalize well beyond STS. First, a single scalar metric, Pearson r, accuracy, F one, whatever, can hide structured failure modes if you don't report a category breakdown alongside it. The authors had the categories. They just didn't score against them per system.
[O] Second?
[G] Second, deliberately deduplicating labels from training pairings, which the authors did here for entailment, is necessary but not sufficient. You also have to ask whether the surface distribution of your evaluation text overlaps with common training corpora, independent of whether the specific label leaked.
[S] And third?
[G] A benchmark that never refreshes ages in a specific way, not necessarily by getting easier, but by increasingly measuring how well a system fits one static test set rather than the capability it was meant to proxy. STS-B's test split has been the same one thousand three hundred seventy-nine pairs for close to a decade now.
[G] If there's one line to take from this paper, it's that the artifact people actually remember, the STS Benchmark, was introduced almost as an afterthought to a multilingual shared task most people have forgotten, and it stuck because it gave the field one number to argue over, for better and for worse.
[O] My takeaway is that fixed, shared evaluation sets are underrated infrastructure. This one quietly organized a decade of sentence-embedding research, and that's a genuine public good.
[S] Mine is the opposite emphasis: before you cite a single correlation number as evidence a model understands meaning, go look at what the evaluation set is built from. There's a full writeup with the actual figures and complete results tables on the litsearch site, this has been Litsearch Audio, thanks for listening.
