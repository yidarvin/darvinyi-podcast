---
slug: chan-2024-negotiationtom
title: "NegotiationToM: A Benchmark for Stress-testing Machine Theory of Mind on Negotiation Surrounding"
description: "Three hundred ninety five real human negotiations, annotated for desire, belief, and intention at every round. The best model reads a snapshot at sixty three percent and holds a coherent model of a person for a whole conversation at seventeen."
date: 2026-07-27
guest_name: "Idris"
guest_voice: "am_puck"
---
[O] Here is a number that should stop you. On this benchmark's strictest metric, the one that asks a model to get desire, belief, and intention all correct for the same moment in the same conversation, the best model on the board scores three point six eight percent.
[S] And the humans score forty three point seven eight. So yes, roughly twelve times better. But hold on the absolute number for a second. Whatever that metric is measuring, people are failing more than half the time at it too, on a task the authors designed the labels for.
[O] Take it dimension by dimension and it looks different. The best model reads what someone wants at sixty three percent. That is a long way from nothing.
[S] It is a long way from ninety one, which is where the people are. And I think both of us are about to find out that the more interesting result is not in that table at all.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Our guest today is Idris.
[S] The paper is NegotiationToM, a benchmark for stress-testing machine theory of mind on negotiation surrounding. Chunkit Chan, Cheng Jiayang, Yauwai Yim and colleagues, out of the Hong Kong University of Science and Technology, with Hongming Zhang at Tencent AI Lab in Seattle. Posted to arXiv in April twenty twenty four, published at EMNLP that November.
[O] Idris, welcome. We have already done ToMi on this show, and FANToM, and ToMBench, and MMToM-QA. Make the case that this one earns its slot.
[G] It earns it on provenance. Every benchmark you just named generates its own text. ToMi is templated. FANToM's conversations are machine-generated. BigToM, which this paper calls the work most related to its own, is explicitly a framework for producing theory of mind items from synthetic templates. NegotiationToM generates nothing. It takes a corpus of real people negotiating with each other and annotates the mental states on top of it.
[S] Spell out the complaint against synthetic data, because "it is synthetic" is not on its own an argument.
[G] The argument is shortcuts and spurious correlations, and they cite Sclar, Ullman, Shapira, and Ma and colleagues for the evidence. A template has a generator, and a generator has regularities. A model can learn the regularity and answer correctly without ever representing what another agent believes. Their second complaint is coverage. Most prior work tests belief, in isolation, and stops.
[O] Which is a real gap. Belief is one leg of a three-legged stool.
[G] That is exactly the frame. The benchmark is built on Bratman's belief-desire-intention agent model from nineteen eighty seven, and it scores all three, on the same conversation, at every round.
[S] And the source corpus.
[G] CaSiNo, from Chawla and colleagues at NAACL twenty twenty one. Two people role-play campsite neighbors and bargain over food packages, water bottles, and firewood. Three of each. Each participant is privately assigned a preference order over the three items before they start, and then they just talk. There is real small talk, real appeals to fairness, real invented emergencies about the car overheating.
[O] The linguistic surface is human, which is the part that matters to me.
[G] The paper lists four design criteria and that is the first. Second, natural conversation rather than a synthetic template, to avoid reporting bias and shortcuts. Third, rich argument content rather than pure numeric haggling, which is their complaint against the earlier deal-or-no-deal style negotiation corpora. Fourth, mitigate contamination risk.
[S] Walk me through the three question types, because this is where a benchmark lives or dies.
[G] Desire first. At each round, given only the dialogue so far, what is agent one's high preference, medium preference, and low preference among the three items? Three separate multiple choice questions. And critically, the option set is four wide, not three. Not given, water, food, firewood.
[O] So abstention is a first-class answer.
[G] It turns out to be the whole ballgame, and we will come back to it. Belief is the same three questions displaced by one level of recursion. What does agent one think agent two's high, medium, and low preference is, given the same history.
[S] Which is a first-order belief about a preference. That is not a false belief task in the Sally-Anne sense.
[G] It is not, and the paper does not claim it is. What it has that a false belief vignette does not is dynamics. The annotation is done on truncated dialogues, so for an N-round conversation you get an item at round one, at round two, and so on, and the correct answer changes as information arrives. In their own worked example, agent one's belief about agent two flips between round three and round four, from high preference food to high preference firewood, because the offers on the table revealed something the words had not.
[O] So you can measure whether a model updates, not just whether it knows.
[G] That is the consistency metric, and we will get there.
[S] Intention.
[G] Intention is the odd one out and I want to be precise about why. It is multi-label classification over nine categories. Build rapport, show empathy, promote coordination, callout fairness, undermine requirements, discover preference, describe need, no need, and no intention. Those nine are not new. They are a renaming of CaSiNo's existing expert strategy annotations, with self-need and other-need collapsed into one describe-need class.
[S] So desire and belief are fresh annotation and intention is inherited.
[G] Correct, and I think that matters a great deal for how you read the intention column.
[O] Tell me about the fresh annotation then.
[G] Five graduate students at English-speaking universities. They were calibrated on the first hundred rounds of conversation, with their typical errors explained back to them, and then annotated desire and belief for both participants at every truncated round. Overall Fleiss's kappa is seventy nine point oh three percent.
[S] Give me the breakdown, because an aggregate kappa hides things.
[G] It does, and the breakdown is quietly the most useful table in the paper. On desire, high preference is eighty three point oh two, medium is seventy two point two three, low is seventy nine point three two. On belief, high is eighty five point two five, medium is seventy four point oh three, low is seventy eight point eight one.
[O] The middle is the hard one.
[G] In both dimensions, by more than ten points. Humans agree least about the medium item. Hold that thought, because it comes back and it does real damage.
[S] Size of the thing.
[G] Three hundred ninety five dialogues, two thousand three hundred eighty truncated rounds, four thousand six hundred eighteen utterances. Seven questions per utterance, three desire, three belief, one intention, and the paper reports about thirteen thousand eight hundred questions in total. The statistic I would put on the poster is average turn length. Forty two point two tokens, against four point seven for ToMi and twenty one point nine for FANToM.
[O] Nine times ToMi.
[G] Real people are wordy. Though the questions-per-context figure is less flattering. Seven point oh, which sits between ToMi's six point oh and FANToM's twelve point nine.
[S] Small thing, and I want it on the record. Seven questions times four thousand six hundred eighteen utterances is over thirty two thousand, not thirteen thousand eight hundred. The arithmetic in that paragraph does not obviously close.
[G] It does not, and the paper never shows the derivation, so I cannot tell you which of those counts is the one being multiplied. It is a bookkeeping ambiguity rather than a claim I would challenge, but you are right that it is unexplained.
[S] Contamination. CaSiNo has been public since twenty twenty one, and every model tested has a later cutoff.
[G] They ran a check, following Golchin and Surdeanu. Sample a hundred CaSiNo instances, prompt ChatGPT and GPT-4 to finish the dialogue exactly as it appears in the dataset, and have a human verify whether any continuation matches the real one. None did. They also tried a second prompt, asking the model to produce a CaSiNo example outright, with the same outcome.
[S] That rules out verbatim regurgitation and nothing else.
[G] And the paper says so, nearly in those words. It says no systematic approach can address contamination unless all the training data used for these models is made public. I think that is the right posture to take. But your reading of the scope is correct.
[O] Metrics, and then numbers.
[G] Desire and belief are exact match across all three sub-questions. Get high and low right and medium wrong and you score zero. Intention gets micro and macro F1 because it is multi-label. Then two composites. The all score, which requires desire, belief, and intention all correct for the same piece of the conversation. And the consistency score, which requires being correct across an entire dialogue.
[O] Now the numbers.
[G] Six models, all mid twenty twenty three. GPT-4 oh-six-one-three, ChatGPT oh-six-one-three, Claude version one point three, Claude version two point one, and LLaMa-2 chat at thirteen and seventy billion. Three prompting regimes. Zero shot as multiple choice, zero shot chain of thought, and a few-shot setting with four exemplars for desire and belief and seven for intention.
[S] Start with the humans, since that is the reference everything is measured against.
[G] Ninety one point one four percent exact match on desire, the same ninety one point one four on belief, eighty three point seven five micro F1 and eighty four point six five macro F1 on intention.
[O] And the best machines.
[G] On desire, GPT-4 with chain of thought, sixty three point two nine. On belief, the same configuration, fifty eight point one eight. On intention, Claude two point one with chain of thought, thirty nine point nine three micro and thirty five point six seven macro.
[S] So four gaps, not one.
[G] Four gaps on four metrics. Twenty seven point eight five points on desire, thirty two point nine six on belief, forty three point eight two on intention micro, forty eight point nine eight on macro. They are not interchangeable, and the paper reports them separately rather than blending them, which I appreciate.
[O] And there is a dissociation buried in there that I think is the most interesting thing on the page.
[G] Go on.
[O] GPT-4 owns desire and belief. About thirteen points clear on desire and sixteen on belief over the next best configuration from any other model. And then on intention, zero shot, GPT-4 scores twenty nine point eight four micro F1, which is below LLaMa-2 seventy billion at thirty three point two three and below ChatGPT at thirty three point nine five.
[S] The best mind-reader in the room is a below-average strategy-labeler. That is either a deep finding or an artifact, and I would like to know which.
[G] My read is that it is mostly an artifact, for the reason I flagged earlier. Intention is not asking a model to infer a mental state from scratch. It is asking it to reproduce CaSiNo's annotation conventions over a nine-way label set where one utterance can legitimately carry several labels. That rewards matching a labeling policy, and there is no reason the model best at tracking preference orders should also be best at guessing how many labels a human annotator would have applied.
[S] So the intention column is measuring something meaningfully different from the other two.
[G] Partly different, yes. And the error analysis supports it. They sampled a thousand responses, and on intention the dominant error types are including incorrect intentions, and doing both, meaning including wrong ones while also missing correct ones. Models over-select from the nine choices.
[O] What does chain of thought do overall?
[G] It helps most models on most dimensions, but not uniformly. LLaMa-2 seventy billion goes from twenty four point four to thirty point three four on desire with chain of thought, while its intention micro F1 falls, thirty three point two three down to thirty point five seven. The largest single jump anywhere is Claude one point three on desire, twenty six point two seven up to forty four point six three.
[S] Few-shot?
[G] Generally better than zero shot, generally worse than chain of thought. One exception the paper flags. GPT-4's intention scores with few-shot exemplars, thirty five point one micro and thirty three point two one macro, beat its own chain of thought result of thirty four point nine and thirty one point two six.
[O] The subclass breakdown is where I think this paper earns its keep. Take us through it.
[G] Table eight in the appendix. Every model is comparatively strong on build rapport and describe need, and poor on undermine requirements, no need, and no intention. And chain of thought does something dramatic on no intention specifically. LLaMa-2 seventy billion goes from seven point eight five to thirty four point one four. GPT-4 from nine point one two to twenty eight point six four. Claude one point three from two point one four to forty point one six.
[O] Those are not incremental gains. That is a class going from broken to functional.
[S] Before we celebrate, is the boring explanation just frequency? Build rapport and describe need are presumably the common labels, and undermine requirements is rare.
[G] Partly, and I am glad you pushed, because the answer is genuinely mixed. The CaSiNo strategy counts are in the appendix. Small talk, which becomes build rapport, one thousand fifty four instances. Self-need plus other-need, which merge into describe need, nine hundred sixty four plus four hundred nine. Undervalue-partner, which becomes undermine requirements, one hundred thirty one. No-need, one hundred ninety six.
[S] So frequency explains it.
[G] It explains two of the three failures. It does not explain the third, because non-strategic, which becomes the no intention class, is the single most frequent label in the corpus at one thousand four hundred fifty five instances. And models are terrible at it before chain of thought.
[O] So what is going on with no intention?
[G] My read, and this goes a step beyond what the paper argues explicitly, is that no intention is a residual class. It is defined by absence. Nothing here. And the paper's own error analysis says models over-select labels. A model biased toward adding labels will almost never pick the label that means none of the above. Chain of thought makes it deliberate before committing, which suppresses the over-selection, which is precisely the intervention that would rescue a residual class.
[S] That is a clean story. Does anything break it?
[G] ChatGPT breaks it. On no intention, ChatGPT moves the other way with chain of thought, from twelve point two down to two point one six. So it is a strong tendency, not a law.
[S] I will add one thing about that class. In the original CaSiNo annotation table, there is an agreement statistic for every strategy except the non-strategic one.
[G] That is correct, that cell is empty. The residual class is the one nobody measured agreement on, which is not a coincidence I would call reassuring.
[S] Now the thing that worries me most in this paper.
[G] The question format ablation. Same model, same data, same items, three ways of asking. Ranking format, where the model returns one ordered list. Individual format, where high, medium, and low go out as three separate prompts. Combined format, all three in one prompt, which is what the main table uses. GPT-4 zero shot on desire is twenty point one with ranking, forty point oh one with individual, and sixty two point seven seven with combined.
[O] Three times, from formatting alone.
[G] And on ChatGPT it is worse. Desire goes from two point eight eight with ranking to eighteen point six with combined. More than sixfold.
[S] So the main results table is a table of prompt formats as much as it is a table of models. And the ablation runs on two of the six.
[G] That is a fair charge for desire and belief, and yes, only ChatGPT and GPT-4 were tested. We do not know how Claude or LLaMa would reorder under a different format.
[O] Does the paper explain why combined wins?
[G] It does, and this is the part I find genuinely illuminating. They case-study GPT-4's errors in the individual format and find the model correctly identifies, say, the highest item as water and the lowest as food, and then answers the medium question more or less at random, when the only remaining item is firewood. Three items, two pinned, the third follows by elimination, and the model does not close the deduction because that question arrived as a separate call with no sight of the other two.
[S] So the combined format is not measuring theory of mind. It is supplying the constraint that lets the deduction happen.
[G] It supplies the constraint. Whether that is a confound or a fair affordance is a judgment call. But now set it next to the annotation agreement numbers from earlier. The medium tier is where the human annotators agree least, seventy two and seventy four percent kappa against eighty three and eighty five on the high tier. The medium tier is where the models flail. And exact match requires all three to be right.
[O] So the headline metric is gated on the noisiest and hardest sub-question.
[G] That is my strongest single criticism of the scoring design, and I do not think it is fatal. It is a reason to want a partial credit variant reported alongside, so a reader can distinguish a model that understood nothing from a model that got two of three.
[O] There is one more experiment I want on the record, because it is what makes me think these annotations are worth something beyond scoring models.
[G] The strategy prediction transfer. They take CaSiNo's original task, predicting the negotiation strategy behind an utterance, and inject the annotated desire and belief states into the prompt. All six models improve. Claude two point one gains seven point four four points of micro F1, twenty seven point one two up to thirty four point five six, and five point five four macro. GPT-4 goes from twenty six point three one to thirty two point seven one micro.
[S] Careful. Those are not the intention numbers from the main table.
[G] They are not, and thank you for saying it out loud. Different task, different label set, CaSiNo's ten strategies rather than the mapped nine intentions. Those two tables are not comparable and should not be quoted against each other.
[S] And the states being injected are gold states.
[G] Gold, human-annotated.
[S] Then this is an oracle experiment. It shows the annotations carry signal. It does not show a pipeline. The models' own desire and belief predictions top out at sixty three and fifty eight percent exact match, so a self-supplied version of this experiment would be feeding the downstream task states that are wrong more than a third of the time. And the paper does not run that version.
[G] That is a correct reading, and it does not. Score that one to you.
[O] Let me make the optimist case then, and I will make it narrowly. The text is real. The annotation agreement is decent. The contamination check is more than most benchmark papers bother with. The three dimensions are scored separately, so you can see a dissociation instead of a blur. And the annotations demonstrably carry information a model can use downstream. That is a good artifact regardless of which model happens to top the table.
[S] And my deflationary case. The reported gaps characterize six model snapshots frozen in mid twenty twenty three. By the time the final version went up in October twenty twenty four, Claude three and LLaMa three had both shipped, and neither is here. The desire and belief numbers move by three to six times on prompt format alone, tested on two of six models. The intention dimension is partly a label-convention matching task. The consistency metric is identically zero for intention across every model by construction, because it demands an exact multi-label match over a whole conversation. And the human baseline is three computer science graduate students, majority voted, with no stated sample size and no reported agreement statistic for that panel, which is a strange omission in a paper that does report Fleiss's kappa for its five-person annotation study.
[G] Let me adjudicate. On staleness, you are right about what the numbers describe, and I would add that the paper's own text calls these state of the art without flagging the vintage. On format, you are right, and it is the paper's own ablation that convicts it, which is both to their credit and to their cost. On the intention dimension, I already gave you that one. On the human baseline, appendix C point two does report only a majority vote with no sample size, so that stands.
[O] Then where does the skeptic lose?
[G] On the core claim, because none of those objections touch the direction of the result. The best format for the best model still lands at sixty three percent on desire against ninety one for people. And the numbers I would actually hang the paper on are the consistency scores. GPT-4 with chain of thought answers correctly across an entire dialogue seventeen point seven two percent of the time on desire and fourteen point one eight on belief, against seventy five point four four for humans. That is not a formatting artifact. That is a model that can often answer a snapshot and rarely hold a coherent model of a person across six rounds of conversation.
[S] I will take that. The snapshot-versus-trajectory gap is the finding, and it survives everything I just complained about.
[O] Does it update you?
[S] On the finding, yes. On the specific per-model rankings in the main table, no. Nobody should quote an ordering out of a table that moves threefold under formatting.
[O] So what does this change for how we build evals?
[G] Three things I would take away. First, the abstention option. The dominant desire and belief error is the model choosing an item when the correct answer is not given. If your benchmark has no "I cannot tell" option, you are not measuring whether the model knows what it does not know, and here that turned out to be where most of the difficulty lived.
[S] Second, and I will say this one. Format sensitivity belongs in the results, not the appendix. A benchmark that publishes one format's numbers is publishing a point estimate whose unreported variance can be three or six times the spread between the models it is ranking.
[O] And third?
[G] Conjunctive metrics need a companion. The all score and the exact match score are both conjunctions, and conjunctions collapse. The paper reports them honestly, including a human all score of only forty three point seven eight, which tells you how unforgiving that conjunction is. But a reader who wants to know what a model actually understands needs the decomposition sitting next to it.
[S] The paper is also candid about its largest limitation, which is that this is a passive benchmark. The model is an observer marking up transcripts. It never negotiates.
[G] The limitations section says exactly that, and names the successor as the obvious next step. Put the model in the seat, let it form a belief and act on it. That is a harder instrument to build, and it is the direction the field has been moving.
[O] Takeaways. Mine is that this is the rare benchmark whose difficulty comes from real language rather than a constructed puzzle, and the abstention finding is what I will carry into my own eval design.
[S] Mine is that the headline is the gap between snapshot accuracy and trajectory coherence, and every other number in that table should be read with a threefold formatting error bar drawn around it.
[G] The paper's is that language models evaluated on real human negotiation track desires, beliefs, and intentions substantially worse than people do, on every dimension measured, and chain of thought narrows that gap without coming close to closing it.
[O] The full writeup, with the figures, the tables, and the citation graph, is on the litsearch site. Thanks Idris.
