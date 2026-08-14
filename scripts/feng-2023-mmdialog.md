---
slug: feng-2023-mmdialog
title: "MMDialog: A Large-scale Multi-turn Dialogue Dataset Towards Multi-modal Open-domain Conversation"
description: "A million scraped multi-modal conversations, two baselines the authors call weak, and a half-page CLIP-based metric that outlived the dataset it shipped with."
date: 2026-07-27
guest_name: "Imogen"
guest_voice: "bf_alice"
---
[O] Here is the number everyone quotes from this paper. Eighty-eight times. MMDialog ships more than a million real multi-modal conversations, and the paper says that makes it the largest multi-modal conversation dataset by dialogue count, by eighty-eight times.
[S] And here is the number nobody quotes. The platform it was scraped from is never named. Not in the abstract, not in the ethics statement, not anywhere. It is called, and I am reading this, one of the most influential online social platforms.
[O] Which everyone can figure out in about four seconds.
[S] Sure. But my real objection is different. Three years on, the thing people actually reuse from this paper is not the million dialogues. It is a metric that takes up about half a page.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Today it is MMDialog, by Jiazhan Feng and colleagues, out of Peking University and Microsoft, published at ACL twenty twenty-three.
[S] It is a dataset paper, a task-definition paper, and a metric paper stapled together, which is unusual, and it is why we can have an argument about which third mattered.
[O] Joining us is Imogen, who has read this one closely. Imogen, welcome. Set the stage for us. What was broken about multi-modal dialogue data in late twenty twenty-two?
[G] Thank you. The authors argue prior datasets split into two flawed families. The first is crowd-sourced image grounding. Visual Dialog, IGC, Image-Chat. You sit annotators in front of a shared image and have them talk about it. The paper's objection is structural, and I think it is a good one. It means the topics of the utterances are triggered by the image, which they say is inconsistent with daily communication, where utterances are not always image-related.
[S] So the image is a prompt, not a message.
[G] Exactly. And the second family derives images after the fact. OpenViDial one and two cut frames and subtitles out of movies and TV. Another line of work takes a text dialogue and swaps selected utterances for retrieved images. In both cases the visual content was bolted on, not exchanged.
[O] And PhotoChat is the one that gets closest.
[G] PhotoChat is the closest, yes. It is a human-human dialogue dataset with genuine photo-sharing acts. But it is about twelve thousand three hundred dialogues, built by crowdsourcing, and the paper's own comparison table marks it as not open domain. MMChat pulls from real Chinese social media, but the responses there are plain text.
[S] Imogen, let me push on the eighty-eight times immediately, because I think the framing is slippery. Eighty-eight times what?
[G] Eighty-eight times PhotoChat. A million and seventy-nine thousand dialogues against PhotoChat's twelve thousand two hundred and ninety. That is the multiplier.
[S] Right, and PhotoChat is not the biggest thing in that table. Image-Chat is two hundred and two thousand sessions. That is more than sixteen times PhotoChat right there.
[G] That is correct, and it is the sharpest reading of the claim. MMDialog is the largest entry in that table by dialogue count. But against Image-Chat, the runner-up, the lead is a bit over five-fold, not eighty-eight-fold.
[O] Although that is not quite apples to apples either, is it? Image-Chat's responses are plain text.
[G] That is the authors' defence, and it is legitimate. PhotoChat is the comparison point because it is the only prior dataset in their table that is human-human, casual, and lets the response itself be an image or text or both. The table caption is actually careful about this. It claims MMDialog is the only dataset satisfying three criteria simultaneously. Million-scale multi-turn sessions, flexible response modality, and casual open-domain human-human conversation.
[S] So the honest sentence is, eighty-eight times more dialogues than the only prior dataset with the same response format. Which is a real claim, and a much narrower one than largest by eighty-eight times.
[O] Fine, I will take the narrow version. It is still a million real conversations. Imogen, how did they get them?
[G] Three phases, and the middle one is the clever bit. First, they manually screened four thousand one hundred and eighty-four popular hashtags. Things like travel, friends, golf. Each hashtag had to have at least a thousand dialogues behind it, which is how they get topical breadth rather than one giant blob.
[O] Four thousand topics against PhotoChat's eighty-nine.
[G] Yes. Second phase. For each hashtag they crawled every turn containing it, and kept only the turns that had at least one image attached. They call those anchors. Then from each anchor they walked the reply chain recursively, up to the root and down to every leaf, and reconstructed the whole conversation around it.
[S] So the seed is an image-bearing turn, but the conversation you keep includes the text-only turns on either side.
[G] Precisely. And that is what produces the property the paper cares about. Images can land at any turn, not only the first, because you did not prompt anyone with an image. On average two point five nine images and four point five six turns per dialogue, with about fifteen point nine tokens per turn.
[O] Compare that to PhotoChat.
[G] PhotoChat averages under one image per dialogue and about six point three tokens per turn, though it has more turns, around twelve point seven. So MMDialog turns are longer and image-denser, PhotoChat sessions are longer in turn count.
[S] What did the filter throw away? Because a scrape is only as good as its filter.
[G] Quite a lot. They removed dialogues containing explicit offensive words. They removed any turn containing a GIF or a video, which they flag as future work. They stripped irregular characters, URLs, and at-mentions, and converted emojis and hashtags into natural-language text. They dropped dialogues with two or more consecutive self-replies, dropped ones with missing or broken images, and kept only dialogues with at least three turns.
[O] The self-reply filter is thoughtful. That is someone threading their own monologue, which is not a conversation.
[S] The toxicity filter is the one I would want documented. A keyword list on social media data is a blunt instrument, and it removes content non-uniformly across topics and communities. That is a distributional edit to the corpus, and we get one clause about it.
[G] The paper does not characterise what the filter removed, no. And I would connect that to the ethics statement, which is unusually confident. It says there will not be any ethical problems or negative social consequences from the research, and that the proposed method does not introduce ethical or social bias in the data.
[S] That is a remarkable sentence to write about a social media scrape.
[O] Let us move to what you can do with it. There are two tasks.
[G] Two tasks and a shared sub-problem. Task one is multi-modal response generation. Given a context that may mix text and images, learn the distribution over responses and synthesise a response that may itself be text, images, or both. Task two is multi-modal response retrieval. You get a candidate pool of text elements and a separate candidate pool of image elements, and you assemble the response auto-regressively, picking elements one at a time.
[O] And the shared sub-problem?
[G] Response modal intent prediction. At each step, before you produce anything, you predict one of three labels. The next element is text. The next element is an image. Or the response is complete, stop.
[S] Which only exists as a task because the dataset let images appear anywhere.
[G] That is exactly the dependency. In a fixed template, where the image always comes last, intent prediction is trivial. Here it is a real decision, and it is a decision a deployed assistant has to make too. Should I answer this with a picture.
[O] I like that framing a lot. Deciding whether to send an image is a skill, separate from picking the right image.
[S] Agreed, that is a genuine contribution. Now, Imogen, tell me about the metric, because that is where I think the paper's real weight is.
[G] So the problem the metric solves is this. Suppose the ground-truth response is text, then image. And your model produces image, then text. The content might be perfectly good. But if you diff position by position, you score it as a disaster, because you compared text to an image at every slot. You have conflated getting the content wrong with getting the ordering wrong.
[O] And BLEU has no idea what to do with an image in the first place.
[G] Right. BLEU and ROUGE assume one modality. So MM-Relevance does the following. Align the ground-truth sequence and the predicted sequence from the left. Encode every element with the matching pre-trained CLIP encoder, text encoder for text, image encoder for images, which puts them in a shared space. Then take the dot product of corresponding positions, and sum up to whichever sequence is shorter.
[S] And then normalise twice.
[G] Yes, and that is the part I would highlight. Divide the sum by the predicted length and you get a soft precision. Divide by the ground-truth length and you get a soft recall. Take the harmonic mean and you get the reported MM-Relevance. So a response that is too long is punished on precision, a response that is too short is punished on recall.
[O] That is a clean design. It is BLEU's precision-recall logic, but the token comparison is a CLIP dot product instead of an n-gram match, so it crosses the modality boundary for free.
[S] It is clean. It is also, at that point, an unvalidated similarity score. Which brings us to the part of this paper that is easy to miss, and Imogen, I want you to be precise here, because the preprint and the camera-ready are not the same document.
[G] They are not, and this matters. The ACL camera-ready contains a human correlation study that a reader working from the shorter preprint version would not see. Section six point three describes it, and section eight point four and table six report it.
[O] Walk us through it.
[G] They randomly selected two hundred contexts from the test set. Three English-speaking volunteers rated the response, generated or retrieved, on a one-to-five Likert scale, for satisfaction given the context. Each response got three valid ratings, and the average is the final human judgment. Then they correlated the automatic metrics against that.
[S] Which metrics were in the comparison?
[G] BLEU-1, BLEU-2, ROUGE-L, CLIP-Similarity, and MM-Relevance. They deliberately excluded the reference-free metrics, Inception Score and Recall at K, because those do not look at the ground truth. And they excluded intent F1, on the grounds that it only measures modality ordering and ignores the content of each element.
[O] And the result?
[G] MM-Relevance comes out on top in all six columns of table six. Pearson, Spearman, and Kendall, on both the generation side and the retrieval side. I checked each column individually. It beats every one of the four alternatives in all six.
[S] All right. So I have to retract the word unvalidated. It is validated. Now let me attack the validation.
[O] Give him the numbers first, Imogen.
[G] Generation side, MM-Relevance gets a Pearson of point four zero four three, Spearman point three eight one four, Kendall point two eight one eight. Retrieval side, Pearson point two eight six three, Spearman point three four zero eight, Kendall point two six three five. Inter-annotator agreement, Fleiss' kappa, is point five two on the generative labeling and point four seven on the retrieval labeling.
[S] So on generation, a Pearson of point four zero. Square it and the metric is tracking something like sixteen percent of the variance in what humans said.
[G] That is the right way to read it, yes.
[S] And on retrieval, the best coefficient it posts is the Spearman, point three four. The Pearson is point two nine. And retrieval is where the headline MM-Relevance number in this paper comes from.
[O] Hold on though. Compared to what? What did BLEU do?
[G] On generation, BLEU-1's Pearson is point three six zero nine and ROUGE-L's is point three five three three. So MM-Relevance's point four zero is ahead, but not by a chasm. On retrieval the gaps are wider in relative terms. BLEU-2's Pearson there is point one six six zero, and CLIP-Similarity's Spearman is point one seven four three, against MM-Relevance's point three four zero eight.
[O] So the honest summary is, it is the best available option, in a field where every option is mediocre.
[G] The paper's own explanation for why retrieval correlates worse is worth hearing. They suggest retrieved responses are simply less relevant to the ground truth overall, which compresses the range, lowers agreement, and degrades the correlation.
[S] That is plausible. Here is my structural complaint, and I want to be careful to complain about the right thing. Table six does break out generation and retrieval separately, so I am not asking for a split it already gives. What the paper never states is how the two hundred contexts map onto those two labelings. Two hundred total, split somehow. Or two hundred contexts each rated twice, once per system. The kappas differ across the two labelings, so something is being counted separately, but the sample size behind each column is not stated.
[G] That is accurate, and it is the gap. The paper says two hundred contexts and three raters, and reports two sets of coefficients, and does not reconcile the two.
[O] Three raters is thin.
[S] Three volunteers, one two-hundred-context sample, one test set. If you are proposing a metric that other papers will adopt, and they did adopt it, that is the load-bearing evidence and it is a single small study.
[G] I would agree it is thin. I would also note it exists, which puts this paper ahead of a great many metric proposals that ship with no human check at all.
[O] Let us do the actual results. What do the baselines score?
[G] Generation baseline is Divter, adapted from Sun and colleagues. It has two parts. A textual generator, DialoGPT-medium at three hundred and forty-five million parameters, fine-tuned. Context images are first converted into text descriptions using OFA-huge, so the entire context collapses into one token sequence. The generator emits either an utterance or an image description, tagged with special markers. Then a description-to-image translator, a DALL-E mega fine-tuned for one epoch, renders any description into a two hundred and fifty-six by two hundred and fifty-six image.
[O] And the numbers?
[G] Intent F1 seventy-one point seven seven. Inception Score twenty point five three, plus or minus point five. CLIP-Similarity twenty-six point zero seven. Then the text side. BLEU-1 nine point four four, BLEU-2 seven point four five, ROUGE-L eleven point one nine. Overall MM-Relevance sixty-one point eight five.
[S] A BLEU-1 of nine.
[O] Which the authors themselves flag. They do not spin it.
[G] They do not. The paper says Divter achieves relatively low textual response generation performance, and reads that as validating the difficulty of the task rather than as a broken baseline. They also observe the model does comparatively better on image generation than text generation, and attribute that to the pre-trained DALL-E doing the heavy lifting.
[S] I will give them full credit for that candour. It is rarer than it should be.
[O] And retrieval?
[G] DE++. A frozen CLIP encodes text and images. An intent module, a four-layer eight-head transformer with a five hundred and twelve hidden size, takes the context plus whatever has been retrieved so far and predicts stop or next modality. A ranking module scores candidates by dot product and takes the top one. Intent F1 eighty-two point six nine. Image retrieval Recall at one, five, and ten of eighteen point two three, twenty-six point nine nine, and thirty-one point seven three. Text retrieval Recall at one, five, ten of twenty-three point zero seven, thirty-nine point two one, and forty-seven point zero five. MM-Relevance sixty-eight point nine one.
[O] So retrieval beats generation on both intent F1 and MM-Relevance.
[S] Which I do not believe means what it looks like it means.
[G] You are right to distrust it, and the paper agrees with you. They give two reasons DE++ scores higher, and the first one is a caveat. The retrieval space in the test set is only a thousand candidates. They sample nine hundred and ninety-nine negative text candidates and nine hundred and ninety-nine negative image candidates per test dialogue. And they explicitly note that these metrics decrease as the retrieval space grows.
[S] There it is. So DE++ is picking from a thousand options while Divter is generating from an open space, and the sixty-eight point nine one versus sixty-one point eight five is not a fair fight.
[G] The second reason they give is that correct modality alignment improves the CLIP matching scores, which feeds MM-Relevance.
[O] That second one is uncomfortable for the metric.
[G] It is, and it is worth sitting with. The authors are saying part of DE++'s MM-Relevance advantage comes from getting the ordering right, not from better content. Which means MM-Relevance is partly rewarding the thing intent F1 already measures. The correlation study does not isolate those two contributions.
[S] So the metric might be double-counting modality ordering.
[G] The paper does not test that, so I would put it as an open question rather than a finding. But nothing in the paper rules it out.
[O] Let me make the optimist case, because I think it survives all of this. This paper did something that is genuinely hard and mostly thankless. It built a million-conversation corpus of real people exchanging images and text, with no annotator sitting in front of a prompt, across four thousand topics. That is a change in provenance, not just a change in scale. Everything downstream, including the fact that we can even ask whether a model knows when to send a picture, sits on top of that.
[S] And my case is that the artifact aged badly and the metric aged well. The dataset is a scrape from an unnamed platform, released under academic-only terms, English only, GIFs and video stripped out, with a toxicity filter nobody has characterised. In twenty twenty-six the models we care about are not DialoGPT and DALL-E mega. But MM-Relevance is a three-line formula that still does a job nothing else does, and that is why it travelled.
[O] It travelled to LoCoMo specifically.
[G] It did. The long-term conversational memory benchmark from Maharana and colleagues, in twenty twenty-four, adopts MM-Relevance for its multi-modal dialogue-generation task, alongside standard generation metrics. And the site's write-up on that paper notes something interesting. The MM-Relevance score falls as the dialogue history grows longer, and retrieval augmentation only partly offsets the fall.
[O] So the metric got used as a probe for something its authors never designed it for.
[G] That is the honest description, yes. It was designed to compare two modality-misaligned responses within a single exchange. LoCoMo uses it as a function of conversational distance.
[S] Which raises the question I actually want to end on. Why does a metric outlive the dataset it shipped with?
[O] I will take a swing. Because a metric is portable and a dataset is not. MM-Relevance needs a CLIP checkpoint and two sequences. It does not need anyone's API terms, or a platform's cooperation, or a hundred gigabytes of images that may or may not still resolve.
[G] I would add a second reason from the text. MM-Relevance solves a problem that is structural rather than topical. The problem is comparing two sequences whose modalities do not line up. That problem does not go away when the models change or the domain changes. Whereas a dataset encodes a snapshot of a platform in a particular year.
[S] I will offer the deflationary version of the same point. A metric outlives its dataset partly because a metric is cheap to adopt and expensive to audit. Two hundred contexts and three volunteers was enough evidence for adoption. Nobody re-ran that study before reusing it, as far as I can tell from the record. Portability and low scrutiny are the same property viewed from two sides.
[O] That is uncomfortably good.
[G] I think both readings hold, and the paper is not the villain in either. The authors did run a correlation study, they did report the correlations honestly rather than only the flattering ones, and they did flag the thousand-candidate retrieval space that inflates their own retrieval numbers. The thinness is real. The concealment is not.
[S] Agreed. My complaint is about the field's adoption behaviour, not about their disclosure.
[O] So what would each of you want before you trusted the numbers more?
[G] A larger and more diverse human study than two hundred contexts and three volunteers, with the design stated clearly enough to know the sample behind each coefficient. At least one non-CLIP or random-candidate reference point per task, because right now there is exactly one baseline per task and no floor telling you what bad looks like on this data. And a breakdown of performance across the four thousand hashtag topics, to check whether the claimed topical breadth translates into roughly uniform difficulty, or whether object-centric topics like albums and landmarks are simply easier for a CLIP-based retriever.
[S] I would add, name the platform. The provenance claim is the paper's central selling point, and it is the one thing a reader cannot verify.
[O] Takeaway from me. This is the paper that made deciding whether to send an image into a measurable task, on data where that decision was actually free rather than templated. That framing is worth more than either baseline in it.
[S] Mine. Read the camera-ready, not the preprint, because the human correlation study only lives in one of them. And then notice that a metric now being used to measure long-term conversational memory rests on two hundred contexts and three volunteers. That is not a scandal. It is just a much smaller foundation than the usage implies.
[G] And the paper's own takeaway, I think, is the one in its results section. A state-of-the-art generation baseline gets a BLEU-1 of nine point four four on this data, and the authors read that as the task being hard rather than the baseline being broken. Three years later, that reading looks correct.
[O] Imogen, thank you. The full write-up, with the figures, the collection pipeline, the metric derivation, and the complete tables, is on the litsearch site under the MMDialog entry.
