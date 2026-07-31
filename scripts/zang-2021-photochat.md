---
slug: zang-2021-photochat
title: "PhotoChat: A Human-Human Dialogue Dataset with Photo Sharing Behavior for Joint Image-Text Modeling"
description: "A dataset where only one person can see the photo. Two tasks, one headline number with a wrinkle in it, and a retrieval baseline that tops out around ten percent."
date: 2026-07-31
guest_name: "Everett"
guest_voice: "am_puck"
---
[O] Here is a benchmark where the best model retrieves the right photo about ten percent of the time, and I think that is the most exciting number in the paper.
[S] Ten point four percent recall at one. Out of one thousand candidates. You are calling that exciting.
[O] I am calling it honest. A benchmark that ships saturated is a benchmark nobody can make progress on. This one has headroom for a decade.
[S] Or the task is underdetermined and no model can do it, which looks identical from the outside. That is the thing I want to settle today.
[O] Welcome to Litsearch Audio. Today we are on PhotoChat, a human-human dialogue dataset with photo sharing behavior for joint image-text modeling, by Xiaoxue Zang, Lijuan Liu, Maria Wang, Yang Song, Hao Zhang, and Jindong Chen, out of Google Research and Kuaishou Technology, at ACL twenty twenty-one.
[S] And joining us is Everett, who has spent a lot of time with this one.
[G] Happy to be here. And I want to flag the framing straight away, because the ten point four is a real number but it belongs to exactly one of the paper's two tasks, and those two tasks get blurred constantly when people cite this dataset.
[O] Then let us not blur them. Everett, set up the problem first. Why did this dataset need to exist in twenty twenty-one?
[G] Because essentially every image-text dataset of that era ran in one direction. Given an image, describe it, as in M S COCO or Conceptual Captions. Given an image, answer a question about it, as in V Q A. The paper's move is to reverse the arrow. Select an image from an understanding of text, rather than generate text from an image.
[S] Image retrieval from text is not new though. That is a well-worn task.
[G] Retrieval from a caption is well-worn. Retrieval from a conversation is the different thing, and the paper is specific about why. First, the dialogue, in their words, does not often explicitly mention the main visible content in the image. Their own opening example has the sharer talking about a court and an attorney, while the photo's main annotated object is a lady.
[O] So the words and the pixels are not describing each other at all.
[G] Right. And second, the dialogue is not guaranteed to be relevant to the image. Real conversations open with greetings and small talk and only drift toward the photo. So a model has to first work out which part of the conversation is even about the picture.
[S] What about the image-grounded dialogue work that already existed? I do not want to grant novelty for free.
[G] Fair, and the paper engages with it. There is I G A, roughly four thousand dialogues, which the paper notes can only be used for evaluation given its scale. And Image-Chat, which is much larger at around two hundred thousand dialogues. But both of them seat two crowd workers in front of the same visible image and ask them to talk about it.
[O] Symmetric. Both sides see it.
[G] Symmetric. And the paper's argument is that neither can be used to build a photo-suggest system, because the entire problem is that one side holds a photo the other side has not seen. The paper describes itself as, quote, the first dataset that captures the photo sharing activities, and elsewhere as the first of its kind to the best of their knowledge. That is their claim, and I would attribute it to them rather than assert it independently, but the hedging is the kind you want to see.
[S] Alright. So how do you actually collect asymmetric data? That sounds fiddly.
[G] It is genuinely the contribution, more than either baseline. They start from Open Images V four and they do not sample randomly. They take Open Images' own object-label annotations, and from roughly six hundred labels they hand-pick eighty-nine that fall under four themes they judged people actually share photos about. People, food, animals, and daily products.
[O] What gets cut?
[G] The paper gives examples in both directions. Girl, bagel, and camera are kept. Traffic light, nail, and reptile are excluded. And for the people category specifically there is an extra geometric filter, because a label saying a person is present does not mean the person is the subject.
[S] Define the filter.
[G] Two conditions, both in the paper's footnotes. The object's center must not sit within zero point one of the image width or height from the border. And the object's width or length must be at least zero point three times the image's. So a person standing tiny at the edge of a landscape shot does not qualify as a people photo.
[O] That is more care than I expected from a dataset paper.
[S] It is care, but it is also a taste judgment being hardcoded into a benchmark. Eighty-nine labels chosen from, what did they say the basis was?
[G] Their words are their investigation of image-grounded dialogues and daily experiences. So yes, partly principled, partly vibes. I think that is a legitimate thing to put pressure on, and I will come back to it.
[O] Take us through the collection itself.
[G] For each selected image, two Amazon Mechanical Turk workers get randomly paired. One of them is given the photo, and a description listing its object labels. If there are people in it, one gets assigned a random name and relationship so there is a way to refer to them. Both are told to imagine talking with a friend.
[S] And the constraint that makes it asymmetric?
[G] Only the holder sees the photo at the start. They are told to drive the conversation until sharing feels natural, and critically they cannot share until the total number of conversation turns reaches five. After the share, the pair keeps chatting until they decide to end and submit.
[O] So every single dialogue has at least five turns of pure text context before any pixel information can leak in.
[G] Exactly. That floor is what makes the intent task well-posed at all. And there is one more stage. A separate pool of what the paper calls in-house professional crowd workers, distinct from the Turk pair, filters the results. A dialogue gets discarded if the association between image and dialogue is, their term, in-evident before the photo sharing act. Or if the text is unnatural, has inappropriate words, too many typos, or broken English.
[S] Hold on. They are throwing away conversations where the photo comes out of nowhere.
[G] They are, and the paper says so directly, and even concedes that this kind of dialogue can happen in a real conversation.
[S] Then the dataset is not a sample of photo-sharing behavior. It is a sample of predictable photo-sharing behavior. Those are different populations, and the intent task is being graded on the easy half.
[O] I think that is a fair hit, but I would soften it. If your product goal is a photo-suggest system, an unforeseeable share is not something you wanted to predict anyway. Filtering it out is scoping, not cheating.
[S] It is scoping that inflates the achievable ceiling, and the paper reports no rejection rate. We do not know if they threw out five percent or forty.
[G] That is correct and it is the sharpest thing you can say about the collection. No rejection rate, no inter-annotator agreement number for the verification step. So the data quality is asserted rather than checkable. I would put that on the skeptic's side of the ledger.
[O] Give us the size.
[G] Twelve thousand two hundred eighty-six dialogues, paired with ten thousand nine hundred seventeen unique images. One photo shared per dialogue. Split ten thousand two hundred eighty-six train, one thousand dev, one thousand test. One footnote, the running prose says ten thousand eighty-six for train, but the table says ten thousand two hundred eighty-six, and that is the figure that reconciles with the twelve thousand two hundred eighty-six total, so use the table and move on.
[O] And the shape of the conversations?
[G] Counting every message as its own turn, dialogues average twelve point seven turns at six point three tokens per turn. If you merge consecutive same-speaker messages, which is how most dialogue datasets count, that becomes nine point five turns at eight point five tokens. And on average, people converse for seven turns before sharing the photo. It is English throughout.
[S] Now the two tasks. Precisely, please.
[G] Task one, photo-sharing intent prediction. For every turn up to the share point, a binary classifier answers, will a photo be shared immediately next. It should fire one only at the turn right before the share and zero everywhere else. Scored with F one, precision, and recall.
[S] And task two.
[G] Image retrieval. Given only the dialogue up to the share turn, pick the correct photo out of a candidate pool. During training the pool is the in-batch images. At evaluation the pool is every image in the test set, so one thousand candidates. Scored with recall at one, five, and ten, plus a summed recall the paper defines as just those three added together.
[O] Different tasks, different metric families.
[G] Completely different, and they are not commensurable. An F one from task one and a recall at one from task two cannot be quoted side by side as if one is better than the other. That is the confusion I flagged at the top.
[S] Let us do intent prediction. What did they run?
[G] Four fine-tuned baselines. BERT base, ALBERT base, T five base, and T five three B. For BERT and ALBERT they concatenate the previous turns with a separator token, use speaker identity as the segment id, and feed the classification token through two fully connected layers. For T five they prepend the literal instruction, predict share intent. Cross entropy for all of them.
[O] And the headline?
[G] Here I want to be careful, because it is the one place in this paper where you should quote precisely. The abstract and the introduction both state that the best photo-sharing intent prediction baseline achieves fifty-eight point one F one, with fifty-eight point two precision and fifty-seven point nine recall. Those three numbers are exactly the T five base row.
[S] And the rest of the table?
[G] ALBERT base is fifty-two point two F one. BERT base is fifty-three point two. And there is a T five three B row at fifty-eight point nine F one, with fifty-four point one precision and sixty-four point six recall.
[S] So the three billion parameter model has a higher F one than the model the prose calls best.
[G] That is what is on the page. And the table's own typography bolds each column's maximum. Fifty-eight point nine for F one, which is T five three B. Fifty-eight point two for precision, which is T five base. Sixty-four point six for recall, which is T five three B again.
[O] So the table marks the big model as the top F one while the prose names the small one.
[G] Yes. And my recommendation is simply to say what you mean rather than to litigate it. If you want the paper's stated headline, it is fifty-eight point one with T five base. If you want the highest F one printed in the table, it is fifty-eight point nine with T five three B. I would not assert that fifty-eight point one is the maximum, because the table does not support that, and I would not call it an error either, because we do not know their selection criterion.
[S] They did say they pick checkpoints by best dev F one. So it is possible T five three B was better on test and worse on dev.
[G] Entirely possible, and the paper does not report dev numbers per model, so that stays a hypothesis.
[O] Either way both are under sixty. Why so low for a binary task?
[G] Class imbalance is the paper's own explanation. There is exactly one positive share turn per dialogue and many negatives. On train it is sixty-eight thousand seven hundred ninety-five negatives against ten thousand two hundred eighty-six positives, which the paper describes as roughly seven to one. They suggest that is what drags precision down across all four models.
[S] Fine, but a seven to one imbalance is not exotic. You can reweight. Nobody tried.
[O] Agreed, that is a gap. Everett, on to retrieval, and I want the dual encoder explained properly because it is the authors' own contribution.
[G] The dual encoder has two towers and no interaction between them until the very end. Image side, resize the photo to two twenty-four by two twenty-four, run it through a pretrained ResNet to get a pixel vector, separately run the photo's object labels through a BERT and take the classification token, then concatenate those two into one image embedding. Text side, a second BERT encodes all the prior utterances of the person who will share.
[O] And they meet where?
[G] Two fully connected and normalization heads project both into a shared space of dimension five hundred twelve, and their dot product is the similarity score. Training is a bidirectional in-batch sampled cross entropy loss. They also tried an in-batch hinge loss and report cross entropy worked better in preliminary experiments.
[S] What is the negatives situation? Because in-batch negatives are where these things live or die.
[G] Thirty-two core pod slices of Cloud T P U V three, per-replica batch size of four, and the loss is computed over item pairs aggregated from all replicas, so a global batch of one hundred twenty-eight.
[S] There it is. One hundred twenty-eight in-batch negatives at training time, one thousand candidates at evaluation. That is roughly an eightfold jump in pool size between train and test, and the paper does not discuss the effect.
[O] Is that actually a problem or is that just how contrastive retrieval works everywhere?
[G] It is how it works everywhere, but the skeptic's version is still right that it goes unexamined here. Nobody sweeps batch size. So we cannot tell how much of the ceiling is the task versus the negative sampling.
[O] Give us the retrieval table.
[G] Eleven rows. Bottom is B M twenty-five, treating each image's object labels as a document, at six point six recall at one and a summed recall of forty-five. Top overall is SCAN, at ten point four recall at one, twenty-seven at five, thirty-seven point one at ten, for a summed recall of seventy-four point five.
[S] SCAN being the stacked cross attention model.
[G] Yes, and this is the load-bearing distinction in the whole table. SCAN is the only baseline here with full cross attention between image regions and word features. It uses Faster R C N N with ResNet one oh one for region embeddings and a bidirectional G R U for text. Everything else scores an image and a text independently and takes a dot product.
[O] So the winner is the one model allowed to let the words look at the image regions while deciding.
[G] Precisely. And the paper's own framing is that this is consistent with prior work, demonstrating the power of bottom-up cross attention.
[S] Then the authors' dual encoder loses. Let us not dress it up.
[G] It loses overall, and the paper's claim is scoped exactly that way. Their best configuration, ResNet one fifty-two with a Bert tiny label encoder, M S COCO pretrained, cross entropy loss, reaches nine point oh recall at one, twenty-six point four at five, thirty-five point seven at ten, summed seventy-one point one. The paper claims best among models without cross attention, not best overall.
[O] And against V S E plus plus, which is the other external non-cross-attention baseline?
[G] This is the nuance worth getting right. V S E plus plus posts a summed recall of sixty-nine point eight, so the dual encoder beats it on the sum. It also beats it at recall at five and recall at ten. But it loses at recall at one. V S E plus plus gets ten point two there, against the dual encoder's nine point oh.
[S] So the authors' model is better on aggregate and worse on the metric a product would actually care about.
[O] That is a real point. If you are suggesting one photo, recall at one is the metric.
[G] I will grant both of you that. Though note that even V S E plus plus's ten point two does not beat SCAN's ten point four. SCAN clears every other row at recall at one.
[O] What actually moved the dual encoder's numbers? The ablation ladder is the useful part for anyone building on this.
[G] Four rungs, all read off the summed recall column. Swapping the image encoder from ResNet fifty to ResNet one fifty-two, both label-free, adds four point two points, sixty point nine to sixty-five point one. Adding the object-label branch on top adds one point three more, to sixty-six point four. Pretraining that configuration on M S COCO before fine-tuning adds three point five, to sixty-nine point nine.
[O] And the fourth?
[G] The counterintuitive one. Holding everything else fixed, shrinking the label encoder from Bert base down to Bert tiny adds a further one point two, to seventy-one point one. A smaller text encoder is better.
[S] Why would that be?
[G] The authors' explanation is that the labels are a compact list of tokens, so a large encoder overfits them. And it is not a one-off, because the same Bert base to Bert tiny swap under the hinge loss adds two point four points, sixty-one to sixty-three point four. Two independent settings, same direction.
[O] I like that finding a lot. It says the label branch is doing lookup, not language understanding.
[S] It also says the visual side is carrying almost everything, and the visual side is a frozen-era ImageNet ResNet.
[G] Which brings up the honest caveat about the whole table. Every one of these baselines predates CLIP-style contrastive vision-language pretraining. So ten point four recall at one is a twenty twenty-one representation ceiling, not a task ceiling.
[O] That is my whole optimist case, actually. Let me make it. The dataset is the durable artifact and the baselines are disposable. The asymmetric protocol, the five-turn floor, the one thousand candidate evaluation, all of that survives. Someone reruns this with a modern joint encoder and we learn something real about how much of the gap was representations.
[S] And my deflationary case is that we do not know what the number should be, because there is no human baseline. Nobody measured what a person scores at picking the right photo out of one thousand given the same dialogue. Without that, ten point four is uninterpretable. It could be near-ceiling.
[O] That is the strongest thing you have said.
[G] I will score that one to the skeptic without hesitation. No human ceiling on either task, and no inter-annotator agreement. So neither fifty-eight point one F one nor ten point four recall at one has a denominator.
[S] I also want variance. Every row in both tables looks like a single training run.
[G] Also correct. No error bars, no seeds. Which specifically matters for the tight clusters. The dual encoder variants sit at six point seven, six point seven, and six point eight recall at one in the early rows, and we have no idea whether those orderings would survive a reseed.
[O] Counterpoint, the ablation deltas that the paper actually leans on are bigger. Four point two and three point five on summed recall are less likely to be noise than a zero point one gap.
[G] That is a fair defense, and I would score that one to the optimist. The conclusions they draw are drawn from the larger gaps.
[S] What about the error analysis? Qualitative, but it usually tells you whether a metric is measuring the right thing.
[G] Two examples, and both are instructive. In the first, the model ranks images of wine glasses and black tea above the ground truth, which is a man holding a wine glass. Topically correct, factually wrong.
[O] So it found the theme and missed the event.
[G] Right. And in the second example the paper reports two separate failures. The model fails to distinguish puffins from ducks, and it fails to infer the background from the keyword atlantic. So it misses both the fine-grained object identity and the scene cue.
[S] And recall at one scores both of those identically to retrieving something completely unrelated.
[G] That is the paper's own point, essentially. It says this illustrates that the task requires attending to details and to the event, not just topical similarity.
[O] There is a deployability wrinkle too, and I want to credit the paper for raising it against its own winner.
[G] Yes, and it is unusually candid. The paper says of SCAN that it does not scale well to large-scale retrieval problems due to the high computational cost of cross attention. So the model topping their table is the one they flag as impractical to actually deploy.
[S] Which quietly justifies their dual encoder existing at all.
[O] It does, and I think that is legitimate rather than defensive. Cross attention means you score every query against every candidate jointly. A dual encoder lets you precompute image embeddings and do a nearest-neighbor lookup. At one thousand candidates that is irrelevant. At a real photo library it is the entire ballgame.
[G] Agreed, and the paper flags the tension without resolving it, which is the appropriate move for a dataset paper.
[S] One more thing that bothers me. The paper notes some images in the training set are used in multiple dialogues.
[G] It does, and it does not quantify it or say whether the reused images are held disjoint from dev and test. Which means a retrieval model could learn an image-specific prior untethered to any particular conversation. It is a small hole, but it is a real one.
[O] Implications. What changes if this holds?
[G] I would put it narrowly. The lasting contribution is the collection protocol, not the numbers. Asymmetric information between two humans, with a hard floor on context before the reveal, is a template you could apply well beyond photos.
[S] And from an evaluation standpoint, my takeaway is about metric selection. This paper is a case study in why you report a metric family rather than a single scalar. The dual encoder wins on summed recall and loses on recall at one, and if the paper had only printed the sum you would have read that as a clean win.
[O] Mine is that a benchmark at ten percent is an invitation, not a failure. And the eighty-nine hand-picked labels and the discarded unforeseeable dialogues are exactly the kind of scoping that makes a hard problem tractable enough to make progress on.
[G] And the paper's own takeaway, in its framing, is that both tasks are far from solved and it is releasing the data to let the community work on them. I would only add, quote whichever intent number you mean and say which one it is.
[O] The full writeup with the figures, both tables, and the references is on the litsearch site. Thanks Everett.
