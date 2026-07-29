---
slug: zhou-2018-document-grounded
title: "A Dataset for Document Grounded Conversations"
description: "CMU DoG paired four thousand real two-human conversations with the Wikipedia movie article they were about, turn by turn. Conditioning a decoder on the right section halved perplexity — but none of the paper's three metrics tested whether the response was actually true to the document."
date: 2026-07-28
guest_name: "Imogen"
guest_voice: "bf_emma"
---
[S] The headline result here is that showing the model the document cuts perplexity from twenty-one point eight to ten point one one. Cut in half. And not one of the three metrics in this paper checks whether the generated sentence is actually true to that document.
[O] Which is a slightly unfair thing to ask of a paper from twenty eighteen that was mostly trying to prove its data was usable at all.
[S] It is an entirely fair thing to ask of a paper whose whole premise is grounding.
[G] Both of those are right, and the paper is more honest about which one it is making than people remember. It calls its models benchmark performance. It does not call them a solution.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Today's guest is Imogen, who knows this work well.
[S] The paper is "A Dataset for Document Grounded Conversations," by Kangyan Zhou, Shrimai Prabhumoye, and Alan Black, all at Carnegie Mellon. It went up on arXiv in September twenty eighteen and appeared at EMNLP that year. The corpus is called CMU Dog.
[O] It is on the docket because it is one of the earliest corpora that pairs a genuine two-human conversation with an actual reference document, aligned turn by turn. Every retrieval-augmented dialogue system since is standing somewhere near this.
[S] Imogen, set the scene. What did the dialogue-data landscape look like in twenty eighteen, and what was missing from it?
[G] Two camps, roughly. The first is scale without reality — corpora scraped from film scripts and movie subtitles. The paper's own comparison table puts the Cornell Movie corpus at three hundred and four thousand utterances, with an average of one point three eight turns per conversation. Those are lines an actor spoke. Nobody is exchanging information.
[G] The second camp is real conversation inside a very narrow world. The Ubuntu Dialogue Corpus is genuine multi-turn text, but it is technical support for one operating system. The Frames dataset is real, but it is grounded in a booking task rather than in explanatory text.
[O] What about PersonaChat? Same year, and it is explicitly about grounding.
[G] PersonaChat gives each worker a short list of predefined persona facts to draw on. That is grounding in a sense, but a handful of one-line facts is not a document. There is no larger source text a system could quote from, or be held accountable against. That is precisely the gap the authors name.
[S] So how do you build the thing they actually wanted?
[G] Thirty Wikipedia articles about movies. Deliberately movies — the authors say they experimented with other domains first and found that people genuinely stay on task when the topic is films. The full list is in the appendix and it is exactly what you would guess: Inception, Frozen, Zootopia, The Shape of Water, Dunkirk.
[G] Each article gets compressed into a document of four sections. Section one is basic information — year, genre, director, cast, review-site ratings, a few critical responses. Sections two, three, and four are three key scenes from the plot, one paragraph each, averaging seven sentences and one hundred and forty-three words. Pulled out automatically, then lightly hand-edited for consistent length and detail.
[O] And then you put two Mechanical Turk workers in a chat room.
[G] Under one of two scenarios, and the distinction really matters. In scenario one, only one worker can see the document. That worker is told to reveal what the movie is and persuade the other to watch it or not watch it, using the document. The other worker sees nothing at all, and is told to act interested and gather enough information to decide. Two thousand one hundred and twenty-eight conversations run that way.
[G] In scenario two, both workers see the same document, and they are asked to discuss its contents and say whether they liked the film. That is one thousand nine hundred and eighty-four conversations. Four thousand one hundred and twelve in total.
[S] What stops that from being twelve turns of "hi, how are you"?
[G] Two things. There is a hard floor of twelve turns. And the document is revealed in pieces. Both workers start holding only section one. After three turns of discussion — six on the first section, to absorb the greetings — the next section appears. So every transcript carries a map from a stretch of turns back to the section that prompted it.
[O] That map is the actual artifact here, isn't it. Not the conversations. The alignment.
[G] I think that is right, and the authors flag it as one of the salient features. It is what turns this into a supervised problem: given this section and this utterance, produce the next utterance. Which is exactly the setup they then test.
[S] There is also a quality score attached to each conversation. Explain that, because it is doing more work than it looks like.
[G] They score every conversation with BLEU against its own source document — overlap between the conversation's utterances and the document text. Rating one is a BLEU at or below point one, which they call low quality. Rating three requires more than twelve turns and a BLEU above point five eight seven. Rating two is everything in between.
[S] Where does point five eight seven come from?
[G] The mean plus one standard deviation of the BLEU scores among conversations that are not rating one. The mean is point three eight five, the standard deviation is point two zero two.
[O] And the buckets are lopsided. Rating one is enormous.
[G] One thousand four hundred and forty-three conversations at rating one, two thousand one hundred and forty-two at rating two, five hundred and twenty-seven at rating three.
[S] So roughly a third of a document-grounded corpus barely touches the document.
[O] It is labeled, though. That is the whole point of shipping the rating alongside the data. You can filter on it.
[G] And there is a cleaner check next to it. Workers who have the document average a BLEU of point two two against it. Workers without it average point zero three. So document-holders demonstrably use the content — and at point two two, they are clearly not copying it verbatim either.
[O] Let's do the models, because they are simpler than people remember.
[G] Deliberately simple. Two encoder-decoder models that differ in exactly one thing. Both use a two-layer bidirectional LSTM encoder and an LSTM decoder, hidden size three hundred, word embeddings of one hundred, dropout of point three, global attention in the Luong style with a copy mechanism borrowed from pointer-generator networks to handle unknown tokens. Adam at a learning rate of point zero zero one, and beam search of width five at generation time. The vocabulary is capped at the ten thousand most frequent of the corpus's forty-six thousand tokens.
[G] The baseline, which they call S E Q, sees only the current utterance and generates the next one. The grounded model, S E Q S, additionally encodes the current document section with that same encoder, and concatenates the resulting section vector onto the decoder's input at every time step, alongside the previous word's embedding.
[S] Every time step, as a fixed vector. So the model is not attending over the document at all.
[G] Correct, and I would underline that. There is no attention over the section. It is one encoded representation of an entire paragraph, bolted onto each decoder step. That is a genuinely weak way to read a document, and it matters when we get to what the numbers mean.
[O] Numbers, then.
[G] Perplexity first. They build a trigram language model on the training-set responses, then score the generated test responses against it. The baseline comes in at twenty-one point eight. The section-conditioned model comes in at ten point one one. An improvement of eleven point six nine points.
[O] That is not a nudge, that is halving it.
[S] It is halving a proxy. Perplexity against a trigram model trained on the corpus's own responses tells you the output looks like corpus text. It tells you nothing about whether the output is correct.
[G] That is the right reading, and the authors frame it that way themselves — they introduce perplexity as a way to automatically evaluate the fluency of the models. Their word is fluency. Not accuracy.
[S] And then the human studies.
[G] Two of them. Engagement is a pairwise comparison: annotators see one utterance of chat history, then both models' responses in random order, and pick whichever works better as a response, with a "no preference" option available. Ninety responses sampled per model, three unique workers on each, majority vote. The grounded model was chosen forty-three point nine percent of the time, the baseline thirty-six point four percent, and no preference nineteen point six percent.
[G] Fluency is a separate study on a one-to-four scale, where one is unreadable and four is perfectly readable. One hundred and twenty responses per model, again three workers each. The baseline scores two point eight eight. The grounded model scores three point eight four.
[O] Nearly a full point on a four-point scale, and every axis they measured moved the same direction. That is a coherent result.
[S] Three axes, all of which are about how the text reads. Not one of them about whether it is true.
[O] There is also the analysis arguing that workers really do pick up each newly revealed section.
[G] There is, and it needs care. They count tokens appearing in both the current utterance and the current section, after stripping stop words and anything already used in the previous three utterances or the previous section. In scenario one that count is point seven eight. In scenario two it is five point eight four.
[S] Those are wildly different numbers to put in the same column.
[G] Because they are measured over wildly different spans. The average response length being measured is twelve point eight five tokens in scenario one, and one hundred and seventeen point one two in scenario two, because scenario two aggregates every utterance tied to a section. The authors read both as evidence that people use new sections rather than fixating on old ones. My read is that the two figures are not comparable with each other — and to be fair, the paper never claims they are.
[S] Let me make the deflationary case properly. This corpus is built from thirty documents. Thirty. The split is eighty percent train, five percent validation, fifteen percent test — and the paper never says what unit that split is taken over.
[O] Meaning what, concretely?
[S] Meaning if the split is over conversations rather than over documents, then essentially every movie in the test set also appears in training, through other conversations about that same movie. The model may have memorized Inception's plot. Part of that perplexity gain would be recall, not grounding.
[G] I want to be precise, because that is the strongest objection in the room and it is also unproven. The paper states only the proportions. It does not state the unit, and it does not say whether documents are held constant across splits. So this is an omission, not a demonstrated leak. But with four thousand conversations spread across thirty documents, it is exactly the question a reader should want answered, and the paper does not answer it.
[O] Let me take the other side. The comparison itself is unusually clean for twenty eighteen. Same encoder, same decoder, same optimizer, same beam width, same data, same everything. One variable moves: does the decoder see the section. And every measurement moves with it. That is an ablation you can trust as an ablation.
[G] Point to the optimist. As an internal contrast it is well controlled, and that is genuinely the right way to demonstrate a dataset is usable.
[S] Then my second point. There is no other model family anywhere in this paper. No retrieval baseline, and retrieval was very strong on dialogue benchmarks of that era. No memory network, which would read the document far more explicitly than concatenating a single vector.
[G] Point to the skeptic. The paper does not claim a state of the art — it says benchmark performance — but anybody benchmarking against this corpus today should not read those numbers as a ceiling. They are a floor, produced by a deliberately weak reader.
[O] Conceded. So what is the strongest thing that survives all of that?
[G] The corpus and the alignment. Four thousand one hundred and twelve real two-person conversations, an explicit mapping from turn ranges to document sections, and a quality rating you can filter on. None of that existed before, and it is the part that actually gets cited.
[S] There is a number in here that trips people up. The abstract says an average of twenty-one point four three turns per conversation. The comparison table says thirty-one.
[G] Those reconcile by definition, and both definitions are stated in the paper. The table's figure is utterances divided by conversations, and it applies that same definition to every dataset in the table, which is the honest way to run a comparison. The twenty-one point four three uses the authors' own definition of a turn as an exchange between two speakers, so a run of consecutive utterances from one person collapses into a single turn. Different units, not a contradiction.
[O] Is anything in the reporting actually wrong, then?
[G] One small thing, in the rating statistics table. The printed average utterances per conversation for rating two is thirty-five point three nine. But that same table's own totals for rating two are eighty thousand one hundred and four utterances across two thousand one hundred and forty-two conversations, which comes to thirty-seven point four zero. Ratings one and three both reproduce cleanly from their own totals. So it reads as an isolated slip in that one column.
[S] Minor, but if you are citing that particular figure, go check the released conversation files.
[S] Imogen, what would have made this airtight?
[G] Four things, and all of them are cheap in hindsight. A document-held-out split, so a reader can separate grounding generalization from document memorization. A retrieval or memory-network baseline, to see whether the gap survives real competition. An automatic faithfulness metric scored against the source document, rather than fluency against a language model. And inter-annotator agreement on both human studies — with three raters, ninety items, and a nineteen point six percent no-preference share, a seven and a half point gap really wants a kappa next to it.
[O] In fairness, most of that was not standard practice for a short dataset paper in twenty eighteen.
[G] Agreement statistics certainly were. The others I will grant you.
[O] So what does this unlock?
[G] The task shape, far more than the models. "Here is a source document, here is a conversation so far, produce the next turn using that document" is the shape of every retrieval-augmented dialogue system that followed. This corpus made that a supervised problem with an alignment you could actually train against.
[S] And for anyone who does evaluation for a living, the lesson is the thing we just spent ten minutes on. The paper's thesis is faithfulness to a document. The paper's three metrics are perplexity, engagingness, and readability. All three moved, and not one of them tested the thesis.
[O] Which is a pattern, not an indictment of these particular authors. Measuring whether a model used its source correctly is genuinely hard, and the field spent years afterwards building metrics for it. This paper sits upstream of that problem being taken seriously.
[G] I would put it this way. The dataset is the contribution, and it holds up. The evaluation is the part that dates — and it dates in an instructive direction.
[G] The paper's takeaway: four thousand one hundred and twelve real conversations grounded in thirty movie documents with turn-to-section alignment, plus a controlled ablation showing that a decoder which sees the current section produces more fluent and more engaging responses than one that does not.
[O] Mine: the alignment is the asset. Simple models on well-aligned data beat elaborate models on unaligned data, and this corpus turned a hard problem into a supervised one.
[S] Mine: a clean ablation on a proxy is still a proxy. Read these numbers as evidence the data is usable, not as evidence the model is grounded — and find out how they split thirty documents before you cite that perplexity.
[O] The full writeup, with the tables and the references, is on the litsearch site. Thanks Imogen.
