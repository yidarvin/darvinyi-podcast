---
slug: goyal-2022-news-summ
title: "News Summarization and Evaluation in the Era of GPT-3"
description: "Humans preferred zero-shot GPT-3 summaries by more than twenty points while every reference-based metric said it lost — a case study in an evaluation stack pointing the wrong way."
date: 2026-08-03
guest_name: "Tobias"
guest_voice: "bm_george"
---
[O] Three annotators read a news article and three summaries, and they pick the zero-shot GPT-3 one by more than twenty percentage points over a fine-tuned state-of-the-art model. No training data, no gradient updates, just a one-sentence instruction.
[S] And on the field's own benchmark test splits, that same model loses to that same baseline by as much as twenty ROUGE-L points. Twenty points is not a rounding error. One of those two measurements is lying to us.
[O] That is exactly the paper's argument, and my read is that the benchmark is the one lying.
[S] My read is that we should be careful about which of those two experiments we trust, because they were not run on the same articles. That distinction is going to matter a lot today.
[O] Welcome to Litsearch Audio. Today's paper is "News Summarization and Evaluation in the Era of GPT-3," by Tanya Goyal, Junyi Jessy Li, and Greg Durrett at UT Austin, posted in 2022.
[S] It's on the docket because it's one of the cleanest documented cases of an evaluation stack failing. Not being noisy, not being slightly miscalibrated. Pointing the wrong direction, with confidence, at scale.
[O] And we have Tobias with us, who has read this one closely. Tobias, welcome.
[G] Thank you. It's a paper worth revisiting, partly because the headline everyone remembers, that GPT-3 beat the fine-tuned summarizers, is the least interesting claim in it.
[O] Set the stage for us. What was the state of summarization research when this landed?
[G] For roughly five years the recipe had been stable. Take a pre-trained model, fine-tune it on a large corpus of article-summary pairs scraped from news sites, then score the output against those same references with ROUGE, or BERTScore, or a purpose-built factuality metric.
[S] And the references themselves were never really quality-controlled, were they.
[G] They were not, and the paper is blunt about it. The CNN Daily Mail dataset treats the bullet points that happened to accompany an article as the gold summary. XSum takes the article's own first sentence and calls that the summary, then hands the model the rest of the article. Newsroom scrapes whatever summary-like metadata publishers attached.
[O] So the gold standard is an artifact of what was scrapeable, not of what anyone decided a good summary looks like.
[G] The paper puts it almost exactly that way in its discussion. Producing a bullet-point summary of a news article became the standard task because CNN's data was available, not because anyone showed it was the best way to present information.
[S] Fine, but that critique predates this paper by years. What's new here?
[G] What's new is the test case. Every one of those metrics was built and validated exclusively against fine-tuned systems, which are trained to imitate those references. A model that produces summaries without ever having seen the references is precisely the case the measurement apparatus was never checked against.
[O] And nobody had run that check.
[G] Not properly. The paper's framing is that prompting had only been studied for summarization with unreliable automatic metrics, or in non-standard settings. Nobody had put a prompted model through the field's actual human evaluation machinery and asked whether people still preferred the incumbents.
[S] Alright. Three systems, I take it. Tell me how they were chosen, because that's where I expect the trouble to start.
[G] Three systems spanning the space from full fine-tuning to pure prompting. BRIO, a task-specific model that reported state-of-the-art results, fine-tuned separately on CNN Daily Mail and on XSum. T0, which is instruction-tuned across many tasks, including summarization on those same two datasets. And the Instruct-series GPT-3 checkpoint, text-davinci-002, used purely zero-shot.
[O] Zero-shot meaning no in-context examples at all, not even one.
[G] Correct. No demonstrations, no fine-tuning. The only adaptation is a sentence-count instruction in the prompt. Summarize the above article in N sentences, with N set per dataset to match that dataset's reference length. Three for CNN and DailyMail, two for Newsroom, one for XSum and BBC.
[S] That's a suspiciously small amount of prompt engineering. Was it doing real work?
[G] It was doing exactly one job, and the paper measures it. GPT-3 honoured the sentence-count constraint in ninety-eight percent of the human-study instances. No other style property was controlled at all. The authors say so explicitly: they know these datasets differ on other attributes, like CNN's lead bias versus XSum needing whole-article inference, and they deliberately don't try to control any of that.
[O] Which is generous to the baselines, if anything. The fine-tuned models get to match the reference style perfectly because they were trained on it.
[S] Now the part I actually care about. What data was the human study run on?
[G] Fresh data, and this is the paper's most careful methodological decision. Because GPT-3's pre-training and instruction-tuning corpora are undisclosed, the standard test splits are a contamination risk. So the human study uses one hundred CNN articles and one hundred BBC articles collected between March and June of 2022, which they call CNN-2022 and BBC-2022.
[O] Chosen specifically so the model couldn't have memorised them.
[G] Chosen to reduce that chance. The paper is honest that it doesn't actually know GPT-3's training cutoff or its data.
[S] And the study design itself?
[G] An A/B test. For each article an annotator sees all three summaries and marks their most preferred and least preferred summary, plus a free-text justification for both. Multiple selections are allowed on each question, for the case where two systems are genuinely indistinguishable.
[O] What definition of quality were they given?
[G] None, and that's deliberate. The authors say providing definitions would impose their own biases, and that a unified definition across these very different summary styles is hard to write anyway. Annotators were told to rely on what they would want to see browsing the web.
[S] That's a defensible choice and also a costly one. Hold that thought. Who were the annotators?
[G] Recruited on Prolific, paid roughly eleven dollars an hour. Sixty unique participants per dataset, each annotating five articles, each article annotated by three people. So three hundred judgments per dataset.
[O] Tobias, there's a detail in here about repairing one of the baselines. Walk us through that, because it sounds like the authors going out of their way to be fair.
[G] It is, and it's also the messiest part of the setup. Remember XSum builds its gold summaries by removing the article's first sentence. So a model trained on XSum has only ever seen headless articles. Hand BRIO-XSum a complete article and about thirty percent of its outputs are visibly broken.
[S] Broken how?
[G] Degenerate. The paper's example is a summary that reads "All images: Strule Shared Education Campus." So the authors first try to rescue it by picking a cleaner candidate from a beam of ten. If that fails, they strip the article's first sentence and re-sample, to match BRIO's training distribution.
[S] And that second fallback has a known cost.
[G] It does, and the paper flags it in the same paragraph. That strategy often results in factually incorrect summary generations. Their own citation, to prior work on faithfulness in abstractive summarization.
[O] Let's get to the second study, because this is the one the paper's central claim rests on.
[G] The metrics study is run separately, and on different data. Five hundred articles randomly sampled from the standard test split of each of four datasets: CNN, DailyMail, XSum, and Newsroom. Five hundred was chosen for statistical power at a fixed API budget, citing Card and colleagues on power analysis.
[S] Different data. Say that again, because I think it's the load-bearing fact of this episode.
[G] Different data. The human study runs on fresh 2022 articles. The metrics study runs on the older standard test splits, which were all released before 2020. And a fourth system, PEGASUS, is added there because BRIO fine-tuned checkpoints aren't available for every dataset.
[O] And the metric suite?
[G] Thirteen metrics across four families. Reference-based overlap: ROUGE, METEOR, BLEU. Reference-based similarity: BERTScore and MoverScore. A reference-based QA metric, QAEval. And then reference-free: two overall-quality metrics, SUPERT and BLANC, and five factuality metrics, QuestEval, QAFactEval, FactCC, DAE, and SummaC.
[O] Numbers. Give me the human study first.
[G] On CNN, out of a hundred articles, GPT-3 is voted best on fifty-eight and worst on nine. BRIO is best on thirty-six, worst on twenty-four. T0 is best on eight and worst on sixty-seven.
[S] T0 got buried on CNN.
[G] Buried. Annotators' stated reasons were shorter length, irrelevant details like long quotes while missing key points, and some found them less coherent. On BBC the ordering changes: GPT-3 best on fifty-seven, worst on fifteen. T0 best on thirty, worst on twenty-nine. BRIO best on twenty, worst on fifty-six.
[O] So BRIO and T0 swap places between the two datasets, and GPT-3 wins both.
[G] By twenty-two points on CNN over BRIO, and twenty-seven points on BBC over T0. Statistically significant on a paired bootstrap, with a p-value of about point zero zero two on CNN and point zero zero zero six on BBC.
[S] Those are majority-vote percentages though. What did the individual annotators look like?
[G] Much less decisive, and the paper reports this itself rather than hiding it. Inter-annotator agreement is Krippendorff's alpha with MASI distance, to handle the multiple-selection design. Point zero five for best summary on CNN, point one one for worst on CNN. Point one eight and point one five for best and worst on BBC.
[O] For anyone doing the arithmetic in their head, those are not percentages.
[G] They are not, and it's an easy misread. Krippendorff's alpha is a chance-corrected reliability coefficient running from minus one to one, where zero is what you'd expect from raters guessing. So point zero five is essentially chance agreement on CNN's best-summary question.
[S] So the majority vote is lopsided and the individuals are nearly independent. Those two facts sit uncomfortably together.
[G] They do, and the paper gives the frequency version, which I find more useful on air. GPT-3's win is unanimous across all three annotators for fewer than thirty percent of articles. And BRIO or T0 still received at least one best vote on more than sixty percent of articles.
[O] That's a real qualifier. But the aggregate signal is still there and still significant.
[G] The authors' own reading is that there is no universal definition of a good summary, that different properties appeal to different readers, and that the aggregate preference is nonetheless strong enough across the board to be credible. I think that's a fair statement of what the data supports.
[S] Now the metrics. This is the part I came for.
[G] Every reference-based metric puts GPT-3 last. On ROUGE-L specifically, GPT-3 trails the best available fine-tuned model by six point seven points on CNN, eleven point one on DailyMail, twenty point four on XSum, and thirteen point five on Newsroom.
[O] Twenty points on XSum. That's the size of gap the field treats as unambiguous.
[G] That's the crux. Prior work had established that small ROUGE differences are unreliable, but that large differences, on the order of five points or more, do track human preference. This paper's finding is that the guarantee breaks. And there's a sharper version of it: GPT-3's scores here come in below the trivial lead-three baseline reported in prior work.
[S] Below lead-three. So by ROUGE, the model humans prefer is worse than copying the first three sentences of the article.
[G] By ROUGE, yes.
[S] What about T0? It's the middle case and I'd expect it to be informative.
[G] It's the most diagnostic result in the table, and it's underrated. T0 outscores GPT-3 on the overlap and similarity metrics across CNN, DailyMail, and XSum. It flips on exactly one dataset, Newsroom. And Newsroom is the one dataset of the four that T0 was not trained on.
[O] That's close to a controlled experiment on the metric itself.
[G] It is the paper's cleanest evidence that these metrics are rewarding exposure to dataset-specific reference summaries rather than summary quality.
[S] And the reference-free metrics were supposed to be the escape hatch. Did they rescue the human ranking?
[G] No. The two quality metrics, SUPERT and BLANC, rank GPT-3 below BRIO on CNN and DailyMail, matching the reference-based direction, but flip on XSum. The factuality metrics disagree with each other. On CNN, among the three systems in the human study, FactCC scores GPT-3 highest, at point two four, while DAE scores it lowest, point six seven against BRIO's point seven six.
[O] Two factuality metrics, opposite verdicts, same summaries.
[G] They only agree on XSum, where both put GPT-3 clearly ahead. And the paper offers a mechanism for the pattern: the scores run roughly inverse to abstractiveness. Systems producing more abstractive summaries get scored lower. XSum is the one dataset where GPT-3's summaries are the less abstractive ones, and that's exactly where its scores flip favourable.
[S] So the reference-free metric is partly measuring surface overlap with the source. That's not factuality, that's extractiveness.
[G] The paper connects it to prior work on spurious correlations in reference-free evaluation. And it gives two structural reasons. First, some of these metrics, FactCC and DAE among them, use reference summaries as positive training examples, so they are reference-free only at test time. Second, even the genuinely reference-free ones had their components chosen against the error space of fine-tuned models.
[O] Which is a lovely, uncomfortable point. The metric's design decisions encode the failure modes of the systems that existed when it was built.
[S] Alright, let me make my case, because I think the paper's framing outruns its design in three specific places.
[O] Go.
[S] One: scale. GPT-3 here is a hundred and seventy-five billion parameters, which is the only model size this paper states. T0 is eleven billion, per its own paper. BRIO fine-tunes a sub-billion-parameter backbone, per its own paper. So we are running prompting-versus-fine-tuning and enormous-versus-small at the same time, and the paper does not separate them.
[O] That's fair, but is it disqualifying?
[S] Here's what makes it sting. The Limitations section runs three paragraphs. Task design for human evaluation. English news only. Unknown RLHF data. Model size is never raised at all.
[G] That's accurate, and I'd score it to you. The paper never quantifies its baselines' sizes, and it never names scale as a confound. A reader can't tell from this paper alone whether annotators are rewarding the prompting paradigm or simply a much larger and more fluent model.
[S] Two: contamination, handled asymmetrically. The human study went to real trouble to use fresh 2022 articles. The metrics study, which is where the central claim lives, runs on pre-2020 splits GPT-3 may well have trained on.
[G] And the paper's response to that is a footnote saying they do not observe a qualitative difference in performance on the older articles. It's an anecdotal check, not a quantified one.
[S] For exactly the claim that most needs it ruled out. Point three: the instrument. One omnibus best-worst vote standing in for quality, with alpha between point zero five and point one eight.
[O] Let me push back on that one specifically. What would the alternative have shown?
[S] Per-dimension ratings. Fluency, coherence, factuality, scored separately. Annotators were told to check factuality carefully, but it's folded into a single vote, so we can't tell whether people preferred GPT-3 because it was more accurate or because it read more smoothly.
[G] The paper concedes precisely that in its Limitations, and says a multi-dimensional design could surface which style properties give GPT-3 its edge, but calls that outside its scope. So it's a known, acknowledged gap rather than an oversight.
[O] Then let me make the optimist case, and I want to make the narrow version rather than the loud one.
[S] Please.
[O] Every one of your three objections is an objection to the model comparison. None of them touches the metric result. Whatever GPT-3's advantage comes from, scale or prompting or RLHF, the fact remains that a system humans prefer at fifty-eight to thirty-six scores below a trivial lead-three baseline on the field's primary metric.
[S] That's the strongest form of it, and I'll concede the shape of the argument. The metrics don't need to know why the model is different, only that it is.
[O] And the paper ran the obvious robustness check on itself. GPT-3's summaries are longer. Did preference just track length?
[G] It checked, in Appendix B. GPT-3 summaries average nine words longer in total than BRIO's on CNN. Then per article, they plot the difference in summary length against the difference in annotator votes between GPT-3 and the next-best system.
[S] And the correlation?
[G] Pearson's rho of point one seven on CNN and point zero two on BBC. The paper's own conclusion is carefully worded: these correlation values cannot solely explain the large differences in annotator judgments.
[O] Cannot solely explain. That's a hedge, not a dismissal.
[G] It is, and I'd keep it as one. There's a related statistic worth separating out, because it's easy to conflate. Table 2 shows GPT-3 averaging twenty-three point four words per sentence on CNN against BRIO's fifteen point eight. That's a per-sentence gap of about seven and a half words. The nine words is the total difference across the whole summary. Different quantities, and running them together roughly triples the apparent length effect.
[S] Good. Then let me ask you to adjudicate directly, Tobias. What is the defensible version of this paper's contribution?
[G] Not that GPT-3 is a better summarizer than BRIO. The defensible version is narrower and more durable: the evaluation apparatus built for fine-tuned summarization stops tracking human preference the moment a genuinely different generation process enters the comparison. That holds regardless of which of the three confounds explains the model gap.
[O] And the authors seem to know that's the real claim.
[G] They say it almost outright in the Limitations. Their arguments do not rely on the specifics of this GPT-3 system, merely that such a system exists. I read that as the authors correctly identifying which half of their paper is robust.
[S] Though it's also a slightly convenient move. It waves off the confound by declaring the confound irrelevant to the conclusion they want.
[G] It's convenient and it's correct, which is an awkward combination. It's correct for the metrics claim and it does not license the paradigm claim, and the paper's own abstract leans on the paradigm claim more than the design supports.
[O] There's a third research question we haven't touched, on going beyond generic summarization.
[G] Two settings, unequally evidenced. Keyword-focused summarization gets a full human study: same hundred CNN articles, two named entities per article, one drawn from the first three sentences and one from later on, GPT-3 against the fine-tuned CTRLSum baseline. Annotators preferred GPT-3 on sixty-nine point eight percent of article-keyword pairs.
[S] And aspect-based?
[G] No human study at all. Only worked examples, and the paper calls the results mixed. The documented failure is sharp: asked who is a defendant or under investigation, GPT-3 answers Donald Trump, the FBI, the Department of Justice, and Sandy Berger. Four entities, two of them institutions, where the article names one defendant.
[O] So the flexibility story is real for keywords and unproven for aspects.
[G] And there's a similar limit in the appendix on long documents. Segment the article, summarize each piece, concatenate. The individual segment summaries are good, the concatenation is incoherent and repeats introductory sentences, and GPT-3 still shows lead bias within each segment.
[S] What does all this actually change for evaluation practice? That's the part I want the listener to leave with.
[G] Three things, I'd say. First, a reference-based metric is only valid over the family of systems it was calibrated on, and a large gap does not restore validity outside that family. Second, reference-free is not the escape hatch, because some of those metrics train on the same references, and the rest inherited design choices from an older error space.
[O] And third?
[G] Third is a cost fact people underrate. The paper spent about a hundred and fifty dollars on API calls for roughly two thousand six hundred summaries, and about a thousand and twenty dollars on the two human studies. The human evaluation cost seven times the generation. That ratio is why the field automated evaluation in the first place, and it's why the automation is hard to give up even once you know it's broken.
[S] That reframes it usefully. The metrics weren't kept because anyone believed in them. They were kept because they were cheap.
[O] To their credit, the authors released the artifacts too: ten thousand generated summaries across four benchmarks and four systems, and a thousand human preference judgments.
[G] Which is the right response to a paper like this. If you argue the field's measurement instrument is broken, the useful contribution is the data someone else needs to build a better one.
[O] Takeaways. Mine: this is the paper that showed a twenty-point metric gap can point the wrong way, and after four years of LLM evaluation work I don't think we've fully absorbed it.
[S] Mine: the metric result is solid and the model result is confounded three ways, and the paper's own framing blurs those two. Read it as a case study in measurement failure, not as a scoreboard.
[G] The paper's own: reference-based and reference-free metrics both fail to evaluate prompted summaries, and news summarization needs an evaluation framework distinct from the automatic metrics that dominated the previous decade.
[O] The full writeup, with the tables, the vote distributions, and the figures we've been describing, is on the litsearch site. Tobias, thank you.
[G] A pleasure.
