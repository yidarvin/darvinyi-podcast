---
slug: joshi-2017-triviaqa
title: "TriviaQA: A Large Scale Distantly Supervised Challenge Dataset for Reading Comprehension"
description: "Trivia buffs write ninety-six thousand questions with zero contact with any evidence, six hundred fifty thousand documents get hunted down afterward, and even 2017's best reading model still can't close the forty-point gap to a human."
date: 2026-07-19
guest_name: "Gideon"
guest_voice: "bm_george"
---
[O] Gideon, thanks for coming in — if I read this paper the way I think we should, it says something almost sneaky: stop the person writing the question from ever seeing the passage that will answer it, and the whole benchmark gets vastly harder.
[S] Or the alternate read: make evidence collection fully automatic, after the fact, and you quietly reintroduce a pile of noise that the older, human-curated benchmarks never had.
[O] Both true at once, which is exactly why we're spending a full episode on it.
[S] Fine, but I want the noise number on the table early, because it is not small.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a guest scholar sit down with one paper at a time.
[S] Today's paper is TriviaQA, out of the University of Washington and the Allen Institute for Artificial Intelligence, published at the Association for Computational Linguistics in 2017 — Mandar Joshi, Eunsol Choi, Daniel Weld, and Luke Zettlemoyer.
[O] Joining us is Gideon, who has spent a lot of time inside this dataset and the reading comprehension literature around it. Gideon, welcome.
[G] Thanks for having me. TriviaQA is a fun one, because it is simultaneously a clever methodological fix and a cautionary tale about what you trade away to get scale.
[S] Set the stage for us. What was actually wrong with reading comprehension datasets before this one?
[G] By 2017 there were two families, and both smuggled in a shortcut. Cloze-style datasets — CNN and Daily Mail, later LAMBADA — blank out a word in real text and call the blank a question. That scales beautifully, because a script can do it, but the result is not a question anyone would actually ask.
[G] The other family is crowdsourced, and SQuAD is the landmark example — a hundred thousand questions written by annotators paid to read a Wikipedia paragraph and ask something about it.
[O] Which sounds like the fix, honestly — real humans, real questions.
[G] It fixes the naturalness problem and opens a subtler one. The annotator has the passage open while writing the question, so the question and the answer sentence end up sharing vocabulary and structure almost by construction — the writer is essentially paraphrasing what they just read.
[S] So a model can win by string matching instead of reading.
[G] That is the authors' own diagnosis, yes. Their argument is that the real problem is not crowdsourcing versus automation, it is coupling. As long as whoever writes the question can see the evidence, you bake in overlap.
[O] So what is the actual fix here?
[G] The authors decouple the two steps completely. They start with questions scraped from fourteen trivia and quiz-league websites — people writing for other trivia enthusiasts, with no passage in front of them and no idea their question would ever touch a reading comprehension model. Only afterward do they go find evidence for each question, automatically.
[S] Automatically how?
[G] Two pipelines. For the web domain, they take the bare question — deliberately without the answer, so the search itself is not biased — and send it to the Bing search API. The top fifty results come back, they strip out the original trivia sites and anything with "trivia," "question," or "answer" in the URL, then crawl the top ten survivors.
[G] For Wikipedia, they run an entity linker called TAGME over the question text, find which Wikipedia entities it mentions, and pull in those pages as evidence.
[O] And then they just hope the answer is in there somewhere?
[G] Essentially, yes — that is the distant supervision assumption. If the answer string shows up in a retrieved document, they treat that document as explaining the answer. Anything that does not contain the answer string gets thrown out entirely.
[S] That is a fairly strong assumption. The string being present does not mean the document actually supports the reasoning.
[G] Correct, and the authors say as much themselves — they call it an assumption, not a guarantee, and they built a whole verification step specifically because of that gap. We will get to the number.
[O] Walk me through scale, because that is the headline.
[G] After filtering: ninety-five thousand, nine hundred fifty-six question-answer pairs, forty thousand, four hundred seventy-eight unique answers, and six hundred sixty-two thousand, six hundred fifty-nine evidence documents. Put together, well over six hundred fifty thousand question-answer-evidence triples. Average question length is about fourteen words; average document length is nearly three thousand words.
[S] Nearly three thousand words per document is enormous for a reading comprehension task at that time.
[G] It is, and that mismatch matters a lot once we reach the baselines. The two domains behave differently, too. Web evidence is redundant, about six documents per question, so each question-document pair becomes its own training example. Wikipedia evidence is sparser, under two documents per question on average, so all of a question's Wikipedia documents get pooled into a single example instead.
[O] Why the split?
[G] Because a fact usually gets stated once on Wikipedia but stated six different ways across six different websites. Treat them the same and you would either waste the web redundancy or over-count the Wikipedia signal.
[S] Now give me the noise number you promised, Gideon.
[G] Right. Because distant supervision is inherently noisy, the authors had a human annotator manually check a sample — nine hundred eighty-six Wikipedia questions and thirteen hundred forty-five web questions — and confirm whether the retrieved evidence actually contained the facts needed to answer. The result: seventy-nine point six percent of Wikipedia evidence held up, seventy-five point three percent of web evidence held up.
[S] So call it roughly one in four automatically retrieved documents is mislabeled. The answer string is there by coincidence, not because the document explains anything.
[G] That is a fair read of the number, yes. Which is exactly why they carved out a small, human-verified subset — nineteen hundred seventy-five question-document-answer triples — that ships alongside the six hundred fifty thousand noisy ones, specifically so evaluation does not have to trust the noisy label entirely.
[O] So there is a clean gold set sitting inside a much bigger noisy ocean.
[G] Precisely, and both get reported side by side in the results.
[O] Let's get to the baselines, then. How hard is this thing, really?
[G] Three of them. A random-entity baseline for the Wikipedia domain — just guess a random candidate entity off the page. A feature-based classifier that ranks candidate answer phrases using a boosted-tree ranker called LambdaMART, over context and Wikipedia-catalog features. And a neural model — a modified version of BiDAF, bidirectional attention flow, which was the strongest SQuAD reader at the time.
[S] Modified how?
[G] BiDAF was built for SQuAD's roughly hundred-and-twenty-word paragraphs. TriviaQA's documents run to nearly three thousand words, so the authors truncate every document to its first eight hundred words before BiDAF ever sees it. When a question has multiple Wikipedia documents, BiDAF scores each one separately and sums the confidence scores to pick a final answer.
[O] Give me the headline numbers.
[G] On the Wikipedia dev set: the random baseline scores twelve point seven two percent exact match. The classifier reaches twenty-three point four two percent. BiDAF, the best of the three, gets forty point two six percent. And the paper's own human evaluation puts people at seventy-nine point seven percent.
[S] Twenty-three, forty, eighty. That is the whole abstract in three numbers.
[G] It is literally how the authors frame it — the classifier and the neural model land around twenty-three and forty percent, and, in their words, neither approach comes close to the human baseline.
[O] That seventy-nine-point-seven number — is it even a fair ceiling? It is one annotator's accuracy, not some large panel.
[G] Fair question. It is one annotator per question, but applied consistently across well over a thousand questions per domain, and the paper treats it as a baseline estimate rather than a hard ceiling — the point is the order of magnitude, not the decimal.
[O] Fine — and worth saying, this is the same BiDAF that was scoring around sixty-eight percent on SQuAD. Same architecture, same year, and it loses almost thirty points just from the dataset switching under it.
[S] Which is the strongest evidence in the whole paper that decoupling actually buys you difficulty, not just noise.
[G] On the verified, human-checked subset, every score climbs — BiDAF reaches forty-seven point four seven percent exact match on verified Wikipedia dev, fifty-one point three eight percent on verified web dev — but the gap to human performance never closes.
[S] What about the oracle numbers? Those are the ones I actually want, because they tell you how much of that forty-point gap is real reasoning difficulty versus the pipeline getting in its own way.
[G] Good instinct. The oracle score asks: if the model always picked correctly from whatever evidence it was actually given, what is the ceiling? For BiDAF on Wikipedia dev, that ceiling is eighty-two point five five percent. For the classifier, seventy-one point four one percent.
[S] Both well under a hundred.
[G] Right, because the eight-hundred-word truncation and imperfect retrieval sometimes cut the actual answer out of the evidence before the model ever gets a chance. So even a hypothetically perfect reader, working only from what BiDAF was shown, tops out around eighty-two, not a hundred.
[O] Which is suspiciously close to the human number of about eighty.
[S] Which is my whole point. Some meaningful fraction of that famous forty-point gap between BiDAF and humans might just be data engineering — truncation and retrieval noise — not a deeper reasoning failure.
[G] The paper does not disentangle the two, to be fair to both of you. It reports the oracle and lets the reader draw the conclusion.
[O] What did the error analysis actually find? Where does BiDAF break?
[G] The authors hand-checked a hundred wrong predictions on Wikipedia dev. Paraphrasing was the biggest single cause, twenty-nine examples. Insufficient evidence in any retrieved document, nineteen. Reasoning across multiple sentences, eighteen. The answer literally truncated out of the clipped document, fifteen. Distractor entities confusing the model, eleven.
[O] Paraphrasing being the top cause is basically the paper's thesis working as designed — that is exactly the shortcut they built the dataset to remove.
[S] Sure, but "answer truncated out of the document" landing as the fourth-largest cause is basically an artifact of their own eight-hundred-word cutoff, not a reading comprehension failure at all.
[G] Also fair. Separately, the compositional-question story checks out independent of the error analysis — sixty-nine percent of Wikipedia questions show a different syntactic structure from their evidence sentence, forty-one percent show lexical divergence, and questions require multi-sentence reasoning about three times as often as they do in SQuAD.
[O] Okay, let's actually argue this one out. My case: the decoupling idea is genuinely elegant, and it is not just claimed, it is demonstrated — same model, same year, drops thirty points purely because the questions no longer leak into the evidence. That is a real methodological contribution, and it is why this dataset is still cited a decade later.
[S] My case: you bought that difficulty by trading verified ground truth for scraped, automatically labeled evidence, and the paper's own audit shows roughly a quarter of it does not actually hold up. That is not a minor caveat. A training and evaluation set with something like one in four mislabeled examples is a real cost, and it is baked into every number except the small verified subset.
[G] I will adjudicate. The noise critique is real and quantified — credit to the authors for measuring it themselves rather than hiding it. But the same-model, cross-dataset comparison to SQuAD is close to a controlled experiment, and that result survives the noise critique, because BiDAF's score does not need clean labels to drop that hard — it just needs harder questions.
[S] I will take that. Where I do not fully back down is the web domain — averaging six evidence documents per question and scoring at the document level means a system can win by finding the one easy, redundant document out of six, without ever handling a hard one.
[G] That is the strongest specific critique in the whole conversation, and it comes from the paper's own design, not an outside gripe. The Wikipedia setting — sparser evidence, question-level scoring — is the more honest reading comprehension test for exactly that reason, and it is not a coincidence that is also where the oracle-to-actual gap is largest.
[O] I will take the point on Wikipedia being the harder, more honest half. I still think the headline achievement holds regardless of which domain you look at.
[S] Where does this actually leave someone building evals today?
[G] A few lessons transfer directly. First, if you are using automatic or distant labeling to scale a dataset, measure your noise floor the way this paper did, and publish a small verified subset rather than only reporting the noisy aggregate. Second, watch what your scoring granularity rewards — document-level scoring over redundant evidence quietly tests retrieval as much as comprehension.
[O] And practically, TriviaQA had a second life nobody in 2017 was planning for.
[G] Right — because the evidence is scraped straight from live Wikipedia and the open web rather than a held-out curated corpus, it is almost certainly sitting inside the pretraining data of most modern language models by now. It shows up as a closed-book factual recall check in eval suites, and newer benchmarks built for factual question answering tend to point at it as their "this one is basically saturated now" comparison point.
[S] Which is a nice closing irony — the dataset built to be hard for 2017's best reader is now the easy sanity check you run before moving on to something actually hard.
[G] If there is one thing to remember, it is the design idea itself — separate who writes the question from who finds the evidence, and you get harder, more natural questions than any single-annotator pipeline produces, at the cost of a real, measured noise floor.
[O] My takeaway: decoupling works, and the SQuAD-to-TriviaQA comparison on the same model is about as close to a clean before-and-after as this field gets.
[S] Mine: never trust the aggregate number over the verified subset, and always ask what your scoring rule is quietly rewarding.
[O] Gideon, thank you for walking us through it.
[G] My pleasure.
[O] That's it for this episode of Litsearch Audio — for the full writeup, figures, and citation trail, head to the site.
