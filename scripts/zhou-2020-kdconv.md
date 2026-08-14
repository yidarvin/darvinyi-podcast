---
slug: zhou-2020-kdconv
title: "KdConv: A Chinese Multi-domain Dialogue Dataset Towards Multi-turn Knowledge-driven Conversation"
description: "Forty-five hundred Chinese dialogues, nineteen turns each, every utterance linked to the exact knowledge-graph triple it used. The paper says knowledge improved all the metrics in all the domains. We swept all ninety cells and it did not."
date: 2026-08-02
guest_name: "Odette"
guest_voice: "af_sarah"
---
[O] Here is the sentence at the center of this paper. After introducing the knowledge, all the models were improved in terms of all the metrics except perplexity, in all the domains. That is a clean universal claim, and it is the kind of thing a dataset paper earns the right to say once.
[S] Except it is not true. We swept the table cell by cell. Three domains, three model pairs, ten metrics that are not perplexity. Ninety comparisons. Eighty-five go up. Four go down. One is an exact tie.
[O] Eighty-five out of ninety is a real pattern, not a fabrication.
[S] It is a real pattern with a false sentence attached. And the four that went down are not random, which is the interesting part.
[G] They are not random at all. Three of the five non-improving cells sit on the same model, and the reason is one line in the implementation section that changes how you should read a third of that table.
[O] Welcome to Litsearch Audio. Today we are on KdConv, a Chinese multi-domain dialogue dataset towards multi-turn knowledge-driven conversation, by Hao Zhou, Chujie Zheng, Kaili Huang, Minlie Huang and Xiaoyan Zhu, from the Conversational AI Group at Tsinghua University. It appeared at ACL in 2020.
[S] I am the skeptic, and this one is on the docket because it built exactly the annotation you would need to measure knowledge faithfulness, and then measured something else entirely.
[G] Odette here, glad to be on. I would start by separating two things the paper keeps welded together. There is a corpus, which is genuinely good and genuinely hard to collect. And there is a benchmark section, which is a floor, not a result. Most disagreements about this paper dissolve once you decide which one you are arguing about.
[O] Set the 2020 landscape, Odette. What was already out there?
[G] Two camps. One grounds conversation in unstructured text. CMU Document Grounded Conversations uses thirty Wikipedia articles about popular movies. Wizard of Wikipedia gives one participant a retrieval system over up to 1,365 dialogue topics. India Document Grounded Conversations adds fact tables. The other camp grounds in graphs. OpenDialKG uses Freebase, and DuConv uses a Chinese knowledge graph, which the authors call the only existing Chinese human-labeled knowledge-grounded dialogue dataset.
[S] And the complaint against each?
[G] Against the text camp, prose gives a model something to draw on but nothing checkable. There is no explicit relation you can point at and say, that is the hop the speaker took. Against the graph camp, topic poverty. Table 1 puts it plainly. OpenDialKG averages 1.0 topics per dialogue over 5.8 turns. DuConv averages 2.0 topics over 9.1 turns.
[O] And DuConv gets a sharper criticism.
[G] It does, and it is the paper's best argument. DuConv samples two linked entities up front, one transitional topic and one goal topic, and steers workers toward that target. The objection is that humans do not make assumptions about the final topic of a conversation before it starts. That corpus is proactive by construction.
[S] Odette, I want to push on Table 1, because I think it is doing more rhetorical work than evidential work. OpenDialKG is graph-grounded. It is annotated at the sentence level. It spans four domains, film, book, sport and music. On the paper's own three headline axes, it matches KdConv.
[G] That is a fair reading and the table supports it. The differentiators are not knowledge type, annotation level, or multi-domain coverage. They are turn count and topic count. Nineteen turns against 5.8, and 2.3 topics against 1.0. That is where the daylight is.
[S] There is a second problem. Wizard of Wikipedia averages 2.0 topics per dialogue, not 1.0. If the framing is topic diversity in general rather than within graph-grounded work, 2.3 against 2.0 is a much thinner margin than the rhetoric suggests.
[O] I will concede both and still take the corpus. But there is a third number nobody has mentioned, and it cuts against the paper too. CMU Document Grounded Conversations averages 22.6 turns. KdConv averages 19.0. And the paper's own contribution bullet says the average turn number is about nineteen, remarkably longer than those in other corpora. Its own Table 1 contradicts that on the same page.
[G] Correct, and the paper would have lost nothing by writing it narrowly. Among graph-grounded corpora, KdConv is the longest and the most topic-diverse. Not the longest, full stop. The graph-grounded qualifier is where the contribution actually lives.
[O] Walk us through construction. How do you build three knowledge graphs without boiling the ocean?
[G] The framing is an explicit retreat from generality. They note ConceptNet holds over eight million concepts and twenty-one million relations, and say collecting conversations at that scale is too costly. So they narrow to three domains and crawl start entities. Top films and film stars from Douban Movie, top songs and singers from Douban Music, popular Beijing attractions from Qunar. After filtering start entities with too few triples, they keep 559 for film, 421 for music, 476 for travel.
[S] And then expansion.
[G] Three hops out from those seeds using XLORE, a large-scale English-Chinese bilingual knowledge graph. With one exception. XLORE had almost nothing for travel start entities, so the travel graph was built entirely from web crawling instead.
[O] Give me the scale.
[G] Table 2. Across all three domains, 13,072 entities, of which 1,456 are start entities and 11,615 came from expansion. 9,115 relation types. 157,029 triples. But the domains are wildly uneven. Film alone is 7,477 entities and 89,618 triples. Travel is 1,154 entities, 10,973 triples, and just seven relation types.
[S] Seven. Total.
[G] Seven, for the entire travel domain, because it was hand-crawled rather than pulled from a bilingual knowledge base with a messy open relation vocabulary. That asymmetry shows up later in the results.
[O] Now the collection, because this is where the design choice is genuinely good.
[G] Both workers see the knowledge graph. That is the explicit contrast with Wizard of Wikipedia, where only one party has the retrieval system and the roles are locked into expert-apprentice mode. Here either participant can lead or follow, and they swap dynamically. They start from one of the start entities, and they are encouraged, not required, to shift the topic elsewhere. No predefined goal and no target path.
[S] And the annotation.
[G] Whenever an utterance was written on the basis of some triples, the annotator records which triples. That is the signature contribution. Not one knowledge label per dialogue, as in DuConv, but a per-utterance link to specific triples. Low-quality dialogues were then filtered, defined as containing grammatical errors or inconsistencies with the knowledge facts.
[O] Result?
[G] Table 3. 4,500 dialogues, 1,500 per domain, split eight to one to one into 1,200 train, 150 dev, 150 test per domain. 85,596 utterances. An average of 19.0 utterances per dialogue, but that splits hard. Film runs 24.4, music 16.6, travel 16.1. Topics average 2.3, ranging from one to four.
[S] Define topic, because that word is load-bearing here.
[G] Operationally, a topic is a distinct head entity among the dialogue's annotated triples that is also a central node in the graph, meaning degree greater than one. Not a free-text subject label. A graph-structural definition, which is why they can count it precisely and compare it across corpora at all.
[O] There is a discrepancy in those tables I stared at for a while. Table 2 says travel has 1,154 entities. Table 3 says 699. Same domain, same paper.
[G] They count different things, and once you see it the tension dissolves. Table 2 is the knowledge graph they constructed. Table 3 is the subgraph the dialogues actually touched. Travel's built graph has 1,154 entities, of which 476 are start entities. The conversations only ever referenced 699 of them.
[S] Then the same gap should appear in film.
[G] It does, more dramatically. Film's constructed graph is 7,477 entities and 4,939 relation types. The dialogues touch 1,837 entities and 318 relation types. Across all three domains they built 157,029 triples and the conversations reference 22,909.
[O] So roughly one triple in seven ever gets used.
[G] About fifteen percent. And that matters more than the paper treats it. The graphs are largely scaffolding, and the grounded knowledge in KdConv is a much smaller artifact than the headline statistics imply.
[S] It also matters for anyone building retrieval on this. The memory is not searching 157,000 triples. It is handed the triples mentioned in that specific dialogue.
[G] Exactly right, and it bounds what the benchmark tests. The knowledge module never faces a retrieval problem. It faces an attention problem over a pre-filtered candidate set.
[O] Two analyses before the models. Figure 2 and Table 4.
[G] Figure 2 counts, per domain, how many dialogues have covered at least two, three, or four topics within the first n turns. Most dialogues involve at least two topics only once turns exceed fifteen, and the share touching three or four grows as dialogues run longer.
[S] That is close to tautological. Longer conversations contain more topics because they contain more utterances.
[G] Partly, and I would not call it a strong result. What it establishes is a floor. If your corpus averages 5.8 turns, as OpenDialKG does, you cannot study topic transition, because the phenomenon has not occurred yet.
[O] And Table 4?
[G] That one is a genuine methodological contribution. They enumerate the top three topic transition patterns in the film domain at one, two and three hops, dominated by Major Work, Star and Director. The finding concerns a relation they call Information, which points at unstructured text describing an entity rather than a structured fact. Information transitions are rare, appearing once in the top nine patterns. The authors read that as evidence that when a structured relation is available, people pivot along it rather than through free text.
[O] That says the graph is not decorative. It describes how the conversation actually moved.
[G] It is suggestive. Though the workers could see the graph, so preferring structured relations may partly reflect what was salient on their screen.
[S] Models. Give me the lineup, and be precise about what has a knowledge variant and what does not.
[G] Four base architectures. A plain language model over the concatenated dialogue. Seq2Seq, an attention encoder-decoder generating the k-th utterance from the previous k minus one, with k set to eight. HRED, hierarchical, with a context RNN feeding the decoder's initial state. And BERT, used as a retrieval ranker over ten BM25-retrieved candidates per turn, including the gold response.
[O] And the knowledge module.
[G] A key-value memory over the triples mentioned in that dialogue. The key is the average word embedding of the head entity and the relation, the value is the average embedding of the tail. A query attends over the keys, and the weighted sum of values is concatenated into the decoder's initial state, or into the classification vector for retrieval.
[S] Which means every architecture needs a query vector.
[G] And that is precisely why the language model has no knowledge variant. Seq2Seq uses its encoder's final hidden state. HRED uses its context vector. BERT uses the CLS output. The language model has no such vector to hand the memory, so there is no LM plus knowledge row anywhere in the paper. Seven rows per domain, not eight.
[O] Now the loss, because this part is under-appreciated.
[G] They add an attention supervision term. It is the negative mean log of the attention weight on the triples the gold response actually used. Total loss is the base loss plus lambda times that term. So they take the sentence-level annotation, the thing that makes the corpus distinctive, and use it to supervise attention.
[S] Which is elegant.
[G] It is, and here is the point I want to plant. That is the only knowledge-specific signal anywhere in the pipeline, and it is a training objective. It is never reported as an evaluation number. There is no attention-accuracy-against-gold-triples column in any table.
[O] Hold that. First, the line you said changes how we read the table.
[G] Knowledge-aware BERT is initialized from the already fine-tuned BERT, and the transformer parameters are frozen while the knowledge modules train. The stated purpose is to exclude the impact of the deep transformers and examine only the effect introduced by the background knowledge.
[S] So BERT plus knowledge is not BERT trained with knowledge. It is a frozen BERT with a shallow memory bolted on.
[G] Correct. Scientifically clean, and it also means those rows answer a much narrower question than the table's layout implies. Every other row is a model trained end to end. The BERT pair is an ablation of a memory module. The paper even says the improvement is slight because the memory network is rather shallow compared to the deep structure in BERT.
[S] Then let us do the sweep properly. What actually happens?
[G] Ninety non-perplexity comparisons. Three domains, three model pairs, ten metrics each, since perplexity is only defined for the five generative rows and prints as a dash for the BERT rows. Eighty-five strictly improve. Four strictly decrease. One is an exact tie.
[O] Name them.
[G] In film, HRED's Hits at three falls from 40.62 to 39.79. Also in film, BERT's Hits at three is 91.79 before and 91.79 after, an exact tie. In music, HRED's BLEU-1 falls from 29.92 to 29.73. In music, BERT's Hits at three falls from 86.90 to 86.87. And in travel, HRED's Distinct-1 falls from 4.15 to 3.98.
[S] Three of those five are Hits at three, and two of the three are the frozen BERT.
[G] Which is the pattern. A frozen transformer with a shallow memory appended will move Hits at three by hundredths in either direction. Those are not knowledge failures. They are noise around a deliberately crippled ablation.
[O] And the other two?
[G] More interesting, because those are real generative models trained end to end. Music HRED's BLEU-1 dropping while its BLEU-2, three and four all rise is a diversity-versus-overlap tradeoff. Its Distinct-4 in that same cell goes from 20.97 to 33.37. The model got dramatically more varied, and unigram overlap with the reference paid for it.
[S] Defensible, and I accept it. But it is exactly the nuance that a sentence claiming all the metrics in all the domains erases.
[G] Agreed, and I want to be precise about what kind of error this is. It is an overstatement, not a fabrication. Every specific number the paper itemizes is correct. BERT gains 0.4 on Hits at one in music, and the actual is 55.64 to 56.08. Seq2Seq gains 7.2 on BLEU-4 in travel, and the actual is 11.74 to 18.94. HRED gains 12.4 on Distinct-4 in music, and the actual is 20.97 to 33.37. All three check out exactly.
[O] So the itemized claims are sound and the universal quantifier is not.
[G] That is the whole of it. Quote the specific deltas and you are fine. Quote the all-metrics sentence and you will be wrong five times out of ninety.
[S] Is there a winning model?
[G] No, and the paper does not claim one, which I credit. In film, knowledge-aware HRED sweeps every BLEU and Distinct column among generative models, while knowledge-aware Seq2Seq takes both Hits columns. In music, knowledge-aware Seq2Seq takes all four Distinct columns instead, and plain HRED with no knowledge at all takes BLEU-1. In travel, knowledge-aware Seq2Seq takes almost everything.
[O] One result I want you to deflate. The plain language model has the lowest perplexity in all three domains.
[G] It does. 21.91 in film, 14.61 in music, 8.86 in travel, lowest of the five generative models each time. And you are right to deflate it. A model with no dialogue-history conditioning and a lower-entropy output distribution having the lowest perplexity is expected, not informative. It is a correctly scoped fact about one column, not evidence the language model is competitive.
[S] Domain effects?
[G] They run opposite for the two model families. Retrieval is best in film and worst in travel, tracking corpus size, 36,618 utterances against 24,093. Generation improves the other way, film to travel, which the authors attribute to travel's shorter dialogues, 16.1 utterances against film's 24.4, being an easier target.
[O] Human evaluation. This is where I expect the knowledge story to get its best evidence.
[G] It is, and the sample is thinner than most readings assume. They sampled about 500 contexts from the test sets of the three domains, and that is 500 total across all three combined, not 500 per domain. Three models generate a response each, HRED, knowledge-aware HRED, and knowledge-aware BERT. Plain BERT was dropped as performing similarly to its knowledge-aware version. That gives 1,500 context-response pairs, rated by three annotators.
[S] So per domain, per model, that is roughly a hundred and sixty.
[G] About 167. Not nothing, but far thinner than the headline five hundred suggests, and it is the only knowledge-specific signal in the entire evaluation.
[O] Agreement?
[G] Fleiss kappa ranges from 0.37 to 0.74. The low end is music fluency, the high end travel coherence. Overall three-of-three agreement runs from 68.14 percent to 81.33 percent.
[S] A kappa of 0.37 is weak. That is fair agreement at best, and it is on fluency, where you would expect raters to agree most easily.
[G] I read that as the zero-to-two fluency scale being under-specified rather than the outputs being ambiguous, but the paper does not investigate it.
[O] Give me the scores.
[G] Knowledge-aware BERT wins both metrics in all three domains. Fluency is exactly 2.00 everywhere, because it retrieves human-written sentences. Coherence is 1.79 in film, 1.80 in music, 1.76 in travel. For HRED, adding knowledge raises coherence in all three domains. Film 1.19 to 1.28. Music 1.30 to 1.36. Travel 1.10 to 1.31.
[O] That is the cleanest evidence in the paper for me. Human judges notice the grounding even where BLEU barely moves.
[S] With one caveat you did not mention, Odette, and I want to know whether I am reading it right. In music, HRED's fluency goes from 1.90 down to 1.86 when you add knowledge.
[G] You are reading it right. That is a sixth non-improvement, in the human evaluation rather than the automatic table, and the paper does not comment on it. It is small and reported without a confidence interval, so I would not build an argument on it. But it is there.
[O] Still, coherence up in three out of three is a pattern.
[G] It is, and here is the more important framing. Both HRED variants score above 1.00 and well below 2.00 on coherence. On that scale, one means relevant to the context but not coherent to the knowledge, and two means both. So the paper's own honest summary is that these models are relevant and ungrounded in most cases. The knowledge module moves them a little way up a scale they are still failing.
[S] Which brings us to the case study, because Figure 3 is the most damning thing in the paper and it is presented as a mild caveat.
[G] The markup is load-bearing and easy to miss. The caption defines underlined text as knowledge used correctly, and italic text as contradictory to the background knowledge.
[O] Travel first.
[G] The ground truth says a visit takes two to four hours, and a ticket is forty yuan. Plain HRED says about three to three hours, italic, and no, only ten yuan, also italic. Both fabrications. Knowledge-aware HRED gets both right, two to four hours and forty yuan, both underlined. That is the module working.
[S] And knowledge-aware BERT?
[G] Says about two to three hours. Italic. The best-performing model in the entire paper, on the paper's own chosen case study, contradicts the knowledge graph on the very first fact.
[O] I did not catch that on the first read.
[G] The paper does say it, to its credit, just gently. It notes that knowledge-aware BERT may focus on the semantic information of conversations but ignore the knowledge information, as shown in the travel conversation. An honest admission, placed where nobody will weight it properly.
[S] Now film, because this is the one that gets misread most often.
[G] Plain HRED invents a plot summary, a beautiful love story during World War Two, for a film that is actually Wreck-It Ralph. Fully fabricated, italic. Knowledge-aware HRED says it tells a strange and beautiful story. That is also italic.
[O] Which means, by the paper's own caption, contradictory to the background knowledge. Not a hedge, not a neutral non-answer.
[G] Exactly the same bucket as the World War Two fabrication. It is a smaller invention and much vaguer, but the authors classified it as wrong, not as safely uninformative. That distinction matters if you cite this figure as evidence that the knowledge module fixes fabrication. It reduces it. It does not eliminate it, and the paper's own markup says so.
[S] Here is my deflationary case, as hard as I can make it. The most valuable thing in this dataset is the per-utterance triple annotation. Nothing in the evaluation measures whether a response used the correct triple. Hits at one and three measure candidate ranking. Perplexity measures fluency. BLEU measures overlap with one reference. Distinct measures lexical variety. Every one of those is imported from ungrounded dialogue work.
[O] And the attention loss.
[S] Is a training objective. Never a test-time number. They built the ruler and did not measure with it.
[G] I give that point to the skeptic almost entirely. A triple precision or recall of a generated response against the gold annotation is a natural, cheap, fully automatic metric, and the annotation to compute it exists in the released data. The paper does not report it. The closest substitute is human-rated coherence on roughly 167 contexts per domain per model.
[O] Then let me make the optimist case, about the artifact rather than the benchmark. Forty-five hundred conversations averaging nineteen turns, where two humans both looking at the same graph negotiated through an average of 2.3 topics with no script, and recorded which triple each utterance leaned on. That is expensive, careful, and hard to fake. Six years later the models are obsolete and the corpus is not.
[G] I give that point to the optimist, and I would add the domain design. Film and music are deliberately similar. Travel is deliberately dissimilar, with seven relation types against thousands. That was set up so transfer and domain adaptation could be studied. The paper does not run those experiments itself, which is a missed opportunity but not a flaw in the data.
[S] Then adjudicate the collection methodology, because I have a real concern. Both workers can see the graph. So what is being collected, natural conversation between two people who happen to know a topic, or two people fluently narrating a graph at each other in dialogue form?
[G] The paper does not answer that, and its evidence does not bear on it. Its naturalness argument is a distinct-4 score, 0.54 for film, 0.51 for music, 0.42 for travel, compared favorably to DuConv's 0.46. That is a lexical diversity proxy. Beating another corpus by 0.05 on distinct-4 does not establish that either reads as natural human conversation rather than fluent knowledge transcription.
[O] Was there any human rating of the dialogues themselves?
[G] None reported. The fluency scores in Table 6 rate model outputs, a different question. Nobody rated the original crowdsourced conversations for naturalness.
[S] And quality control on collection?
[G] The largest reporting gap in the paper, and I want to be exact. It never states how many crowdworkers were recruited. It reports no inter-annotator agreement for the triple annotation itself. It says low-quality dialogues were filtered, but gives no count of how many were rejected and no measured accuracy of the triple labels. The only agreement statistic in the paper, that kappa from 0.37 to 0.74, covers the later evaluation of model outputs, a completely different task by different people.
[O] That is a fair hit and I will not defend it.
[S] One more. Contamination. Eight to one to one, and no statement of whether entities are held disjoint across splits.
[G] Correct. The paper says only that the split ratio is eight to one to one. With 1,456 start entities seeding 4,500 dialogues, test entities almost certainly appear in training dialogues. But I want to be careful. That is an unreported statistic, not a demonstrated leak. We cannot claim contamination. We can claim a reader cannot rule it out, and that matters, because apparent knowledge grounding could partly be memorized entity-triple pairs rather than generalization to unseen knowledge.
[O] What would you want if someone benchmarked on this today?
[G] Three things. An entity-overlap statistic across the splits. An annotator count and agreement figure for the collection stage. And an automatic knowledge-faithfulness metric, so the corpus's distinctive asset finally gets used at evaluation time.
[S] And on baselines, since we are in 2026.
[G] Every generative model here predates pretrained decoders. No GPT-2, no BART, no T5, with or without the knowledge module. BERT appears only as a retrieval ranker, never as a generator. The recurrent models use two-hundred-dimensional embeddings and GRU cells with two hundred hidden units. These are small models. Treat every number in Table 5 as a floor a modern conditioned model should clear easily, not a ceiling.
[S] The lesson I take is about eval design, and it is not specific to this paper. If you collect the supervision that would let you measure the thing you care about, build the metric in the same paper. Otherwise the field measures what is convenient, which here meant BLEU and Distinct, and the expensive annotation sits unused for years.
[O] I take a different lesson and I think both hold. The bottleneck in 2020 was not metrics, it was data. Nobody could study multi-hop topic transition in dialogue because no corpus had enough turns for it to occur. KdConv fixed that, in Chinese, with structure you can check. The metric gap was fixable later by anyone. The data gap was not.
[G] Both are right, and they are the two halves of the same paper.
[S] Odette, close it out. What is the paper's own takeaway?
[G] That knowledge grounding measurably helps across three domains and two model families, that the improvement is large where models are weak and small where the architecture was deliberately frozen, and that the gap between relevant and knowledge-coherent responses remains wide. Coherence above one and well below two, in every domain, for every generative model tested.
[O] Mine is that the artifact outlived the benchmark, which is the best thing that can happen to a dataset paper. Six years on the models are museum pieces, and the per-utterance triple links are still the reason anyone opens this repository.
[S] And mine is a warning about a single sentence. All the models improved in terms of all the metrics in all the domains is false. Eighty-five of ninety cells, four decreases, one tie. If you cite this paper's central result, cite the deltas it itemizes, which are all correct, and not the quantifier it wraps them in.
[O] The full writeup, with the tables, the figures, and the complete cell-by-cell sweep, is on the litsearch site. Odette, thank you.
[G] A pleasure.
