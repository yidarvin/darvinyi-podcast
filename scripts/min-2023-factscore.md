---
slug: min-2023-factscore
title: "FActScore: Fine-grained Atomic Evaluation of Factual Precision in Long Form Text Generation"
description: "A model wired to a live search engine still gets almost three in ten facts about a person's life wrong — FActScore is the metric that caught it by grading biographies fact by fact instead of pass or fail."
date: 2026-07-19
guest_name: "Alistair"
guest_voice: "bm_george"
---
[S] A model plugged straight into a live search engine still gets nearly three in ten facts about a person's life wrong.
[O] But it's also the first time anyone measured "wrong" without collapsing an entire biography into a single pass or fail.
[S] Grading facts one at a time doesn't fix the model. It just gives the error somewhere to hide.
[O] Or somewhere to be found. That's the whole point.
[O] Welcome to Litsearch Audio. I'm your optimist host, and across the table, as always, is our skeptic.
[S] Today we're on FActScore: Fine-grained Atomic Evaluation of Factual Precision in Long-Form Text Generation, by Sewon Min and colleagues, out of the University of Washington, U Mass Amherst, the Allen Institute for AI, and Meta, published at EMNLP twenty twenty-three.
[O] And joining us is Alistair, a visiting scholar who has spent real time with this paper. Alistair, welcome.
[G] Thanks for having me. It's a paper worth spending time with — it's quietly become close to the default way people report factuality in long-form generation.
[S] Start with the problem they're solving. Why wasn't a simple "is this biography accurate" judgment good enough?
[G] Because a long generation is never uniformly true or false, it's a blend. The authors point out that a single ChatGPT sentence carries about four point four separate pieces of information on average, and in roughly forty percent of sentences, those pieces are a mix — some supported, some not.
[O] So a binary label throws away exactly the information you'd want.
[G] Right. And prior work had tried two escapes, neither satisfying. One added a "partially supported" label, but where you draw that line is subjective, and annotators disagree on it. The other took the strict route: every single piece of information must be supported, or the whole generation fails.
[S] Which sounds rigorous.
[G] It sounds rigorous, but it's blind. The paper's own example is two biographies of the actress Bridget Moynahan. One gets two-thirds of its atomic facts right. The other gets one in ten. Under the strict rule, both score zero.
[O] That's a striking illustration — a model that's mostly right and a model that's mostly making things up, indistinguishable on paper.
[S] And there's a second problem underneath that: validating claims by hand is slow. What did it cost them?
[G] About four dollars per generation, and a single biography can carry anywhere from twenty-six to forty-one atomic facts. That's not a budget you scale to hundreds of models.
[O] So walk us through what FActScore actually does differently, Alistair.
[G] Two ideas. First, the unit of evaluation isn't the sentence, it's the atomic fact — a short statement that conveys exactly one piece of information. Second, and this is the part I think is underappreciated, factual precision isn't measured against some global notion of truth. It's measured against a specific knowledge source the user has chosen to trust.
[S] Why does that distinction matter?
[G] Because sources disagree with each other, and treating "truth" as one fixed target hides that. The authors formalize it plainly: take a generation, break it into its atomic facts, and the score is simply the fraction of those facts a chosen source supports.
[O] So FActScore of a model is just the average of that fraction across a set of prompts.
[G] With one important wrinkle — the average is taken only over prompts where the model actually answers. If it abstains, that generation doesn't count against it. So this is explicitly a precision metric. It says nothing about how much the model covered.
[S] Hold that thought, I want to come back to it later. What are the assumptions baked in here?
[G] Three. That whether a fact is supported by the source is undebatable. That every atomic fact matters equally, regardless of how significant it is. And that the source itself doesn't contradict itself.
[S] None of those are free assumptions.
[G] No, and the authors are upfront about that. Which is why they chose a domain where the assumptions mostly hold: generating biographies of people, checked against English Wikipedia. Biographies are specific and mostly non-debatable, and Wikipedia has broad coverage of people. They sampled one hundred eighty-three entities from Wikidata, deliberately spread evenly across rarity buckets — very frequent people down to very rare ones.
[O] And the annotation pipeline itself was carefully staged.
[G] Four steps. Sample the entity. Prompt the model with "tell me a bio of," and filter out anything that's clearly an abstention. Break the generation into atomic facts — InstructGPT drafts the breakdown, and a human annotator revises it. Then a second annotator labels each fact Supported, Not-supported, or Irrelevant against Wikipedia.
[S] And you said four dollars a generation — who's doing that labeling?
[G] Freelancers through Upwork, paid fifteen to twenty-five dollars an hour. It's real, careful human labor. They cross-checked ten percent of the data with two annotators each and got agreement rates of ninety-six, ninety, and eighty-eight percent for InstructGPT, ChatGPT, and Perplexity AI respectively — high enough to trust the labels.
[O] Let's get to the headline numbers. What did the humans find when they actually scored these models?
[G] All three subject models struggled. InstructGPT scored forty-two point five percent. ChatGPT scored fifty-eight point three percent. And Perplexity AI, which is wired to a live commercial search engine, scored seventy-one point five percent.
[S] Say that last one again. A model with search access, that in principle could just copy the correct Wikipedia page, still gets less than three-quarters of its facts right.
[G] Exactly the paper's point. If Perplexity AI just retrieved and echoed Wikipedia, it should approach a perfect score. It doesn't.
[O] Do we know why?
[G] The authors did a qualitative pass on thirty of its wrong answers. The biggest chunk, about a third, are flat contradictions with a specific Wikipedia sentence — wrong dates, wrong titles. Almost a quarter are page-level contradictions, where a claimed fact simply isn't anywhere on the person's page. And there's a smaller slice of genuinely subjective language copied straight out of Wikipedia's prose, presented as fact.
[S] So it's not that search fails to find information, it's that having search doesn't guarantee faithful use of it.
[G] Right, and there's a nice supporting detail — Perplexity AI often provides citations, but the authors checked, and citations barely correlate with accuracy: thirty-six percent of its supported sentences carry a citation, and thirty-seven point six percent of its unsupported sentences do too.
[O] A citation that doesn't predict correctness. That's a warning for anyone building citation-based trust signals.
[S] What about the abstention numbers, Alistair — I think those are doing real work in these scores.
[G] They are. InstructGPT almost never abstains, half a percent of the time. ChatGPT abstains fourteen point two percent of the time. Perplexity AI, nine point three percent. Both of those FActScores are computed only over the prompts each model chose to answer.
[O] Beyond the headline scores, what's the more diagnostic finding?
[G] Two patterns hold across every model. First, precision collapses as the person gets more obscure — ChatGPT goes from about eighty percent accurate on very frequent entities down to sixteen percent on very rare ones.
[O] That's a steep drop for a model people treat as a general reference.
[G] It is, and here's what makes it interesting for anyone who's read the entity-frequency literature — prior work on short-answer question answering found that giving a model retrieval access made it robust to how rare the entity is. Perplexity AI has retrieval, and its score still drops fifty percent relative at the fact level, sixty-four percent at the sentence level, moving from common to rare subjects.
[S] So retrieval helps with short factual questions but doesn't rescue long-form generation the same way.
[G] That's the paper's read, yes. Second pattern: precision decays across the length of a generation — later sentences are reliably less accurate than earlier ones, likely because the opening, nationality and profession, is overrepresented in training data, and errors compound as the generation goes on.
[O] Which a short-answer benchmark would never catch, because there's no "later in the generation" to measure.
[G] Right — that's the paper's own argument for why long-form generation needs a metric like this in the first place.
[S] Human annotation at four dollars a pop doesn't scale though. What's the automated version actually doing?
[G] It reuses InstructGPT to do the same atomic-fact decomposition, then validates each fact with a second model — the evaluator — using zero-shot true-or-false prompting. They test four ways of doing that validation: asking the evaluator cold with no context, retrieving Wikipedia passages first, a nonparametric method that scores likelihood under a masked language model, and an ensemble that only labels a fact supported if the retrieval-based method and the nonparametric method agree.
[O] And the metric for judging the judges?
[G] Error rate — the gap between the true, human-measured FActScore and the estimated one — plus whether the estimator preserves the ranking between models. It's worth flagging that error rate is an aggregate number. An estimator can mislabel plenty of individual facts and still post a low error rate if its mistakes cancel out in both directions.
[S] That's a real blind spot. You could have a bad judge that happens to average out.
[G] The paper is honest about that limitation, and reports individual-judgment accuracy separately in an appendix for exactly that reason. But headline results: retrieval matters enormously. The no-context evaluator, just asking the model cold, either has a high error rate or scrambles the ranking between subject models entirely.
[O] So retrieval is close to necessary.
[G] Close to necessary, but not sufficient on its own — retrieval alone can overestimate by up to seventeen percent. Ensembling it with the nonparametric check is what brings the error down. The best combination, a LLaMA-based evaluator ensembled with that nonparametric method, lands an error rate of one point four points on InstructGPT and zero point four points on ChatGPT.
[S] Under two percent error, which is the number that made this paper famous.
[G] It is, with a caveat — there's no single best estimator across the board. For Perplexity AI specifically, a plain retrieval-plus-ChatGPT setup does better than the ensemble. The authors' actual recommendation is to run both variants and check that they agree, and across ten-plus models the two best variants correlate at point nine nine Pearson.
[O] With that estimator in hand, they went and scored a lot more models.
[G] Six thousand five hundred generations, thirteen subjects — twelve language models plus a set of human-written biographies for comparison — which they estimate would have cost twenty-six thousand dollars to annotate by hand.
[S] What came out of that?
[G] Every model, including GPT-4, trails human-written biographies by a wide margin, even though writing a biography is not a hard task. GPT-4 and ChatGPT land close to each other, but GPT-4 abstains less often, twelve percent against sixteen percent, and produces far more facts per response, sixty point eight against thirty-seven. Inside a model family, size predicts precision cleanly — the sixty-five B Alpaca beats the thirteen B, which beats the seven B. But across families at the same size, the gaps are large: seven-B Alpaca and Vicuna land near forty percent, while seven-B StableLM sits around seventeen.
[O] So base model and training recipe matter more than raw parameter count at a fixed size.
[G] That's the paper's conclusion, yes.
[O] Okay, time for the actual argument. I'll go first, and I'll make the strongest case for why this paper matters beyond its own numbers. Before this, "is the model factual" was a single bit — pass or fail on some benchmark of short questions. This gives you a graded, source-relative measurement that generalizes to any domain where you can name a trusted source, and it comes with a cheap estimator that got scaled to thirteen models overnight for a fraction of the human cost. That's not just a metric, that's an evaluation capability the field didn't have.
[S] I'll grant the framing is good. Graded beats binary, source-relative is more honest than pretending there's one global truth. But I want to push on how gameable the headline number is. FActScore only conditions on prompts the model answers. Say less, and your score goes up. Perplexity AI's seventy-one point five percent sits on top of nine point three percent abstention. ChatGPT's fifty-eight point three percent sits on top of fourteen point two.
[G] That's the paper's own limitation section, almost word for word. They even give a concrete example — a generation about Mary the First of England that's entirely accurate, high precision, but it never mentions how she got back into the line of succession and became queen. High score, low recall, and the authors know it.
[O] To be fair, they flag it explicitly and tell readers to report FActScore alongside abstention rate and fact count, not alone.
[S] Sure, but a headline number invites people to quote it by itself anyway, and plenty of downstream papers did exactly that.
[G] There's a second seam the authors actually ran an audit on. FActScore's ground truth is whatever's on Wikipedia. They sampled thirty facts from ChatGPT marked not-supported for rare people, and checked them against the wider web. Ten percent, three of thirty, turned out to be true and just missing from Wikipedia — one was a memoir that only turns up in Google Books.
[S] So the rarity collapse we talked about earlier isn't purely a model failure. Some of it is Wikipedia's own coverage gap.
[G] Some of it, though the authors also argue Wikipedia's overall coverage of people is high, so they don't treat it as the dominant effect. It's non-zero, though, and it compounds with something the paper doesn't fully untangle: the subject models were themselves trained on web text that includes Wikipedia. So the rarity curve is partly a memorization curve, not purely a verification failure.
[O] That's a fair point I hadn't fully weighted — frequent entities aren't just easier to look up, they're also more likely to have been in the model's own training data.
[S] And my last one: that under-two-percent error rate everyone quotes is aggregate, not per-judgment. A validator can mislabel plenty of individual facts and still land a low error rate if its mistakes cancel out. And there's no single best validator — the winner depends on which model you're scoring.
[G] All fair, and here's how I'd score it. The framing — atomic, graded, source-relative — has genuinely aged into something close to a default. But every one of those caveats holds up: precision without recall, ground truth bounded by one source, and an aggregate error rate that can mask individual mistakes. Treat FActScore as one coordinate, not a verdict — which is literally what the authors themselves recommend.
[O] Zoom out for a second — why does this matter beyond one metric for biography generation?
[G] Because the pattern generalizes to evaluation practice broadly. Any time you're using an LM to judge another LM's output — which is now most of how people grade agents, summaries, retrieval-augmented answers — you inherit the same two risks. An aggregate score can look clean while individual judgments are noisy, and your ground truth is only as good as the source you picked to check against.
[S] And the contamination point generalizes too. Any benchmark where the source of truth was plausibly in the model's own training data has to ask whether it's measuring verification or memorization.
[O] Right, and on the positive side, the estimator design here — retrieve, then validate, then cross-check with a second method — is basically a template a lot of later LM-judge pipelines borrowed, whether they cite this paper or not.
[G] They usually do cite it, actually. Within about four months of release, the authors note it was already being used to evaluate follow-up models, and it's kept compounding since.
[S] Which is exactly why the caveats matter — this isn't a niche paper, it's load-bearing infrastructure for a lot of factuality claims in the field now.
[G] If there's one line to take from the paper itself, it's this: don't collapse a mixture of true and false into one bit, and don't trust a number without checking what it's silently not counting.
[O] My takeaway is that this unlocked scalable, graded factuality checking for a fraction of the human cost, and that's a genuine capability upgrade for the field.
[S] Mine is the opposite emphasis — a precision-only, single-source, aggregate score is still a partial picture, and it's on all of us to keep reading it that way. For the full write-up, figures, and citation trail, head to the Litsearch site.
