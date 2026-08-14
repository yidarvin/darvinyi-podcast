---
slug: xiong-2024-mirage
title: "Benchmarking Retrieval-Augmented Generation for Medicine"
description: "Retrieval lifts GPT-3.5 by almost eighteen percent on medical question answering. Read the table task by task and almost all of it comes from one dataset where the benchmark deleted the answer and the retriever found it again."
date: 2026-07-26
guest_name: "Imogen"
guest_voice: "bf_alice"
---
[O] Retrieval takes GPT-3.5 from sixty point six nine percent to seventy one point five seven percent on medical question answering. That is a seventeen point nine percent relative gain for the price of a search index. No fine-tuning, no bigger model.
[S] And the same pipeline makes GPT-4 worse on three of the five tasks in the benchmark. Worse on MMLU Med, worse on MedQA US, worse on MedMCQA.
[O] Both of those are true at once, which is exactly why this paper is interesting rather than just another leaderboard.
[G] They are both true, and I would add that the second one is the more informative fact. The headline average hides a task-by-task pattern that I think is the actual finding of this work.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Today it is Benchmarking Retrieval-Augmented Generation for Medicine.
[S] Guangzhi Xiong, Qiao Jin, Zhiyong Lu, and Aidong Zhang. University of Virginia and the National Library of Medicine at the National Institutes of Health. Posted to arXiv in February twenty twenty four, published at ACL that year.
[O] Our guest is Imogen, who knows this benchmark and the medical retrieval literature around it well. Imogen, welcome. Before any numbers, set the frame.
[G] Happily, and I want one boundary up front because it governs everything after. Every score in this paper is accuracy on multiple-choice questions. Four options, or yes-no-maybe, or yes-no. Nothing in this work evaluates whether the system's reasoning is correct, and nothing in it evaluates anything on a patient. The authors are explicit about that in their own limitations, and we will come back to the exact sentence.
[S] Good. I will hold you to it.
[O] So what was broken before this? Medical language model evaluation was hardly a neglected field in early twenty twenty four.
[G] It was not, but it was measuring one thing. The big evaluations, Med-PaLM from Singhal and colleagues, the GPT-4 medical board work from Nori and colleagues, tested the model naked. No documents. Pure parametric recall. That tells you what is in the weights, not what a deployed system would do.
[S] And the people who did test retrieval?
[G] There were a few, and this is the sharp bit. Liévin and colleagues, and PaperQA from Lála and colleagues, both did retrieval-augmented generation on medical questions. But they gave the retriever the answer options along with the question.
[O] Which is not a thing that can happen in the world.
[G] No. Nobody types their multiple-choice options into a search engine. So the paper defines four settings it thinks a realistic medical retrieval benchmark needs simultaneously. Zero-shot, so no in-context exemplars. Multiple choice, so scoring is automatic and scales. Retrieval, obviously. And question-only retrieval, meaning the retriever sees the question text and nothing else.
[S] And Table 1 is the claim that nobody had all four.
[G] Correct. Nori and Singhal have zero-shot and multiple choice, no retrieval. Liévin and Lála add retrieval but leak the options into it. MIRAGE is the first to take all four at once, and that is a modest, checkable claim rather than a grand one.
[O] Let us build the thing. What is actually in the benchmark?
[G] Seven thousand six hundred sixty-three questions from five existing datasets, in two families. Three examination sets: MMLU Med, one thousand eighty-nine questions; MedQA US, one thousand two hundred seventy-three, which is licensing-exam style and by far the wordiest at an average of one hundred seventy-seven tokens a question; and MedMCQA, four thousand one hundred eighty-three, which is more than half the benchmark by volume.
[S] And the other family?
[G] Two literature sets. PubMedQA star, five hundred questions, three options, yes-no-maybe. And BioASQ yes-no, six hundred eighteen questions, two options. The star on PubMedQA is load-bearing. The original dataset ships each question with the supporting PubMed abstract attached. The authors strip that abstract out.
[O] So they deliberately break the task and then ask retrieval to repair it.
[G] That is a fair description, and remember it, because it comes back in the results with some force.
[S] Now the toolkit, because the ablation is the contribution here, not the question set.
[G] MedRAG, and it has three swappable axes. Corpora, five of them. PubMed, twenty three point nine million abstracts. StatPearls, point-of-care clinical reference, nine thousand three hundred documents chunked into three hundred one thousand snippets, and the authors note this is the first time StatPearls has been evaluated in this literature. Textbooks, just eighteen books, the standard US licensing exam reference set, chunked to one hundred twenty-five thousand snippets. Wikipedia, twenty-nine point nine million snippets. And MedCorp, which is simply all four unioned together.
[O] Retrievers?
[G] Four, chosen to span training regimes rather than to be exhaustive. B M twenty five, purely lexical. Contriever, a general dense retriever trained on Wikipedia and CCNet. SPECTER, a scientific retriever trained on Semantic Scholar. And Med C P T, a biomedical retriever contrastively trained on two hundred fifty-five million user clicks from PubMed search logs. Then two fusions on top, using reciprocal rank fusion. A two-way fusion of B M twenty five and Med C P T, and a four-way fusion of everything.
[S] Six backbone models, and the default is thirty-two retrieved snippets prepended to the question, temperature zero, chain-of-thought prompting. Baseline is the same chain-of-thought prompt with no documents.
[G] Right. Forty-one configurations in total, over one point eight trillion prompt tokens. And there is one wrinkle in the method that I want on the record, because it sits slightly awkwardly against that zero-shot pillar.
[O] Go on.
[G] The released MEDITRON checkpoint is pretrained only. No instruction tuning. It cannot follow the system prompt. So for MEDITRON, and only MEDITRON, the authors insert what they call a pseudo one-shot demonstration into the prompt.
[S] That is a demonstration. In a zero-shot benchmark.
[G] It is, and the mitigation is real: the appendix shows the demonstration contains no actual question content. It is a skeleton with ellipses and a placeholder answer letter. It teaches output format, not medicine. But one of six models is running a structurally different prompt from the other five, and if you are comparing across that row, you should know it.
[O] Fair. Numbers. Table 6, everything held at the combined corpus and the four-way fusion.
[G] GPT-4 leads on both settings. Seventy three point four four percent average with chain-of-thought, seventy nine point nine seven with retrieval. GPT-3.5 goes from sixty point six nine to seventy one point five seven, the largest relative gain in the table at seventeen point nine percent. Mixtral, sixty one point four two to sixty nine point four eight. Llama 2 at seventy billion, fifty point two four to fifty three point three eight. MEDITRON, fifty seven point zero four to sixty point one eight. And PMC LLaMA at thirteen billion gains one percent, essentially nothing.
[O] And this is where the abstract's framing comes from. Retrieval brings GPT-3.5 and Mixtral to roughly GPT-4 level.
[S] To GPT-4's no-retrieval level. That is the sleight of hand and I want it named. Seventy one point five seven versus GPT-4's seventy three point four four is a comparison against GPT-4 with one hand tied. Run GPT-4 through the same pipeline and it is at seventy nine point nine seven, eight and a half points clear of the model that supposedly caught it.
[G] I score that entirely to you. It is a same-model, different-configuration result presented in cross-model language. GPT-4 with retrieval is the best system in the paper by a wide margin and nothing in the results threatens that.
[O] I will take the hit, but the underlying point survives, doesn't it? A cheaper model plus a search index closes most of a very large capability gap. That is an interesting deployment fact even if the sentence overreaches.
[G] It is, and now let me complicate it for both of you, because the average is doing a lot of concealing. Take GPT-4 apart task by task. Retrieval moves it from eighty nine point four four down to eighty seven point two four on MMLU Med. Down on MedQA US, eighty three point nine seven to eighty two point eight. Down on MedMCQA, sixty nine point eight eight to sixty six point six five.
[S] Three of five, all negative.
[G] Then PubMedQA star goes from thirty nine point six zero to seventy point six zero. Thirty-one points. And BioASQ from eighty four point three to ninety two point five six.
[O] So the entire average gain is those two.
[G] Do the arithmetic and it is starker than that. GPT-4's average rises six and a half points. Thirty-one points on one of five tasks contributes six point two of them. One dataset accounts for essentially the whole gain, while three of the five tasks move backwards.
[S] And that dataset is the one where the benchmark deleted the abstract that contains the answer.
[G] Yes. And the paper hands you the smoking gun in section six point one. Seventy nine point six percent of ground-truth snippets are retrieved at rank one on PubMedQA star. Accuracy peaks at a single retrieved snippet and then declines as you add more.
[O] That is not really a test of retrieval-augmented generation. That is a test of whether an index can undo a deletion.
[G] I would put it slightly more gently. It is a genuine retrieval task, but it is a nearly-solved one, and it is not representative of the questions people actually bring to a medical system. So using it to carry the headline average is a reporting choice worth flagging.
[S] Does the pattern hold for GPT-3.5, where the gain is biggest?
[G] Better, and this is where the optimist gets paid. GPT-3.5's exam scores all move up: plus two point five seven on MMLU Med, plus one point five seven on MedQA US, plus two point seven nine on MedMCQA. Positive across the board rather than negative.
[O] Thank you.
[S] How much of the total is that, though?
[G] The three exam tasks contribute about one point four points of the ten point nine point average gain. The two literature tasks contribute nine point five. So roughly eighty-seven percent of GPT-3.5's headline improvement still comes from the two datasets where PubMed simply contains the answer.
[S] And the error bars? The paper reports standard deviations and I notice people never read them.
[G] You should read them here. MedQA US has a standard deviation around one point three, so a plus one point five seven is inside the noise. MMLU Med, plus two point five seven against one point three, is marginal. The one that is solid is MedMCQA, plus two point seven nine against a standard deviation of zero point seven seven, because there are four thousand one hundred eighty-three questions in it. That is the real exam-task result and it is a small, honest one.
[O] I will take a small honest result on the largest dataset over a spectacular one on five hundred questions.
[S] Agreed, actually. Now explain PMC LLaMA to me. One percent gain. And Llama 2, six point three percent. Why do the weakest models get almost nothing from retrieval, when retrieval should help them most?
[G] The paper's reading is that the helpful snippets are harder to retrieve for examination questions. I think there is a more mechanical explanation sitting in the tables that the paper never discusses, and I flag it as my read rather than theirs.
[O] Please.
[G] Table 5 lists context windows. GPT-4 and Mixtral have thirty-two thousand seven hundred sixty-eight tokens. GPT-3.5 has sixteen thousand three hundred eighty-four. Llama 2 and MEDITRON have four thousand ninety-six. PMC LLaMA has two thousand forty-eight.
[S] And the default is thirty-two snippets.
[G] At an average snippet length of two hundred twenty-one tokens in the combined corpus. That is roughly seven thousand tokens of retrieved context before you add the question, the options, and the instructions.
[O] Which does not fit in four thousand. And really does not fit in two thousand.
[G] It does not. So the two models that gain least from retrieval are also the two models that physically cannot receive most of the retrieved evidence. The paper does not report how it truncates, and it does not raise this as a confound.
[S] That is a significant hole. The clean reading of that table is "retrieval helps big models more". The alternative reading is "retrieval helps models that can see the retrieval".
[G] I think you have to hold both. It does not overturn anything on the GPT rows, and MEDITRON does genuinely beat its own Llama 2 base by thirteen point five percent with chain-of-thought and twelve point seven with retrieval, which is a like-for-like context window comparison. But the small-model rows should not be read as clean evidence about retrieval.
[O] Let me get the corpus and retriever findings on the table, because I think this is the part that actually earns the paper its keep.
[G] Agreed, and this is the deliverable. On corpora, task preference is sharp. Textbooks with the two-way fusion gives the best MMLU Med score in the whole grid, seventy six point six eight. StatPearls with Contriever gives the best MedQA US, sixty seven point four eight.
[S] And those same corpora on the literature tasks?
[G] Actively harmful. StatPearls with B M twenty five puts PubMedQA star at twenty seven point six percent, against a no-retrieval baseline of thirty-six. You have made the model substantially worse by giving it confident, well-written, irrelevant documents.
[O] Which is the practical lesson, isn't it. A wrong corpus is worse than no corpus.
[G] That is the single most transferable finding in the paper, and it holds well beyond medicine. PubMed is the only individual corpus that improves every task. The combined corpus is close behind and more robust, which is why it is the default.
[S] Retrievers.
[G] Med C P T and B M twenty five are the reliable individuals. SPECTER is consistently the worst on the combined corpus, about seven percent behind the others, and the paper gives a proper mechanistic reason rather than shrugging: SPECTER was trained to make similar documents sit near each other, not to make a query sit near its answer. Wrong objective for this job.
[O] And fusion?
[G] Helps, with a caveat I like. The four-way fusion on the combined corpus is the best configuration overall at seventy one point five seven. But more fusion is not monotonically better. On Wikipedia, where SPECTER is poor, the two-way fusion beats the four-way by one point seven percent, because you are averaging in a bad ranker.
[S] Good. That is a real engineering result with a mechanism attached. What about the two general findings, the scaling and the position effect?
[G] Scaling first. Sweeping snippet count from one to sixty-four, the three examination tasks rise roughly log-linearly up to about thirty-two. Two things bracket that. Below about eight snippets, retrieval actively hurts, and the paper's interpretation is that a thin, partly irrelevant context crowds out the model's own knowledge. And past the peak, accuracy falls again as signal-to-noise degrades.
[O] So there is an interior optimum, and it is not small.
[G] For exam questions. For PubMedQA star it is one, for the reason we discussed. And the position finding is the one from Liu and colleagues, lost in the middle: on the two tasks where ground-truth snippets are labelled, accuracy is a U-shape against where the correct snippet sits. Best at the ends, worst buried in the middle.
[S] Which is a fact about transformers, not about medicine.
[G] Precisely, and the paper is honest that it is replicating a known effect in a new domain rather than discovering it.
[O] Let me make the optimist case cleanly. The paper is a controlled factorial over three axes that everyone building these systems tunes blind, and it produces defensible defaults: use PubMed or the union, use a biomedical retriever or lexical search, fuse carefully, use around thirty-two snippets, put your best evidence at the edges of the context. That guidance is worth having and nobody had measured it.
[S] I will grant all of that and make my case. First, the sole baseline is the same model without retrieval. There is no comparison against any published medical retrieval system, no few-shot, no self-consistency. So "state of the art" here means "beats its own ablation."
[G] Sustained. It is an ablation study, and read as a leaderboard it overclaims.
[S] Second, contamination. Every one of the five component datasets is public, years old, and heavily mirrored. GPT-4 scores eighty nine point four four on MMLU Med and eighty three point nine seven on MedQA US with no documents at all. The paper runs no contamination check of any kind. No canary strings, no post-cutoff split.
[G] Also sustained, and it cuts in a direction the skeptic might not expect. If the no-retrieval baselines are inflated by memorisation, then the measured lift from retrieval is an underestimate of what retrieval would give you on a genuinely unseen question.
[O] That is the first thing today that has moved my priors in the paper's favour.
[G] It should. But it also means the absolute numbers should not be quoted as medical capability figures.
[S] Third, and this is my real objection. Section six point four recommends models for deployment. It says Mixtral is a viable option for, and I am quoting the paper's framing, high-stakes scenarios such as medical diagnosis where privacy matters.
[G] That recommendation is not supported by anything measured in this paper, and I will say so plainly. What was measured is the ability to select a letter on exam-style and literature yes-no questions with the options visible at answer time. There is no diagnostic task here, no free-text generation scored by anyone, no clinician review.
[O] And the authors themselves seem to know it.
[G] They do, and it is the sentence I promised at the top. In the limitations they write that the rationales generated by MedRAG remain to be evaluated. That is the whole ballgame. The benchmark can tell you the final letter was right. It cannot tell you the reasoning used the retrieved document, or used it correctly, or used it at all.
[S] So a model could retrieve a perfect abstract, ignore it entirely, answer from memorised training data, and score as a retrieval success.
[G] It would be scored identically, yes. And the diagnostics that could partly detect that, the rank-one hit rate and the position study, only run on the two literature tasks, because the three examination datasets have no labelled supporting documents. Which is exactly where retrieval performs worst. The analysis cannot reach the place that needs it.
[O] What would fix it?
[G] Attribution scoring of the rationale against the retrieved snippet. Contamination probes on post-cutoff questions. Ground-truth supporting documents for the examination sets. And re-running the corpus and retriever conclusions on newer backbones, since every model here is a twenty twenty three vintage.
[S] Does anything from twenty twenty four still transfer, in your view?
[G] The component-level findings, I think yes, because they are about the retrieval stage, which is largely model-independent. A wrong corpus still poisons; SPECTER's objective is still mismatched; lost-in-the-middle is a property of attention. The model-level rankings I would treat as expired.
[O] One last thing, since we are being pedantic about tables.
[G] Go on.
[O] Table 3 gives the combined corpus as fifty four point two million snippets, which is exactly the sum of the four parts. Table 7 labels the same corpus sixty five point three million.
[G] It does, and I have no explanation. It looks like a stale figure in a header. It changes nothing in the results, but it is a small reminder to read the tables rather than the abstract.
[S] Which has been the theme of the entire episode.
[O] Takeaways. Mine: this is the first honest factorial over the medical retrieval design space, and its corpus and retriever guidance is the most reusable thing in it, because a wrong corpus makes systems worse and now we can show that with numbers.
[S] Mine: the headline is a same-model comparison, and almost all of the measured gain comes from two datasets where the answer is sitting in PubMed. Retrieval helps least on the questions designed to be hard, which is the opposite of the story the abstract tells.
[G] And the paper's own: MedRAG improves six language models on a seven thousand six hundred sixty-three question multiple-choice benchmark, with a log-linear snippet scaling curve and a lost-in-the-middle position effect. And by the authors' own statement, whether the generated reasoning is sound remains unevaluated. Nothing here says any of these systems is ready to be near a patient.
[O] The full writeup with the tables, the figures, and the citation map is on the litsearch site. Imogen, thank you.
