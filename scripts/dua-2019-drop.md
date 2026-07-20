---
slug: dua-2019-drop
title: "DROP: A Reading Comprehension Benchmark Requiring Discrete Reasoning Over Paragraphs"
description: "A benchmark that made state-of-the-art reading comprehension models look like they'd never done a single subtraction problem in their lives."
date: 2026-07-19
guest_name: "Gabe"
guest_voice: "am_fenrir"
---
[S] BERT scored eighty-four point seven percent exact match on SQuAD, state of the art heading into twenty nineteen.
[O] Turn that same model loose on this paper's benchmark and it loses more than fifty points of F one. That is not a small dip.
[S] A model that can find the dollar figure in a sentence and stop, because nobody ever asked it to subtract two numbers.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a guest scholar take one paper apart. Today's paper is DROP, A Reading Comprehension Benchmark Requiring Discrete Reasoning Over Paragraphs, by Dheeru Dua and colleagues at U C Irvine, the Allen Institute for Artificial Intelligence, and the University of Washington, published at NAACL twenty nineteen.
[S] I'm the skeptic host, and this one's on the docket because DROP is the paper that made "solved reading comprehension" look premature, almost overnight.
[O] I'm the optimist, and joining us is Gabe, a visiting scholar who's spent real time with this paper. Gabe, welcome.
[G] Thanks for having me. This is one of those benchmark papers that quietly reset what "solved" meant for reading comprehension, so there's a lot worth digging into.
[S] Set the scene for us. Why did the field need a new reading comprehension dataset in twenty nineteen? SQuAD was already famous.
[G] Because SQuAD-style span extraction had essentially become a solved task. Systems were matching human performance on SQuAD and on CNN slash Daily Mail, and the paper is blunt about it — that whole family of datasets reduces to one operation, find the span of text that answers the question.
[O] Which is a real skill. Just not the whole skill.
[G] Right. Take the example the authors lead with. A passage says a painting sold for sixteen point three million dollars, above a twelve million dollar high estimate. A SQuAD-style question would ask what it sold for, and locating that span solves it. DROP's question asks how many more dollars it sold for than the estimate — that needs subtraction, four point three million, and no span in the passage states that number.
[S] So the model has to do arithmetic it was never explicitly trained to do.
[G] Exactly. And there was already a literature built around compositional reasoning — semantic parsing, datasets like WikiTableQuestions — asking count, filter, and comparison questions. But those operate over clean structured tables, not raw paragraphs. Nobody had combined that compositional question style with actual paragraph understanding.
[O] So DROP's whole pitch is: keep the passages messy and real, but make the questions demand a symbolic operation, not just a lookup.
[G] That's the authors' own framing, almost word for word. They call the arithmetic "a necessary means to force more comprehensive passage understanding," not a distraction from it. And notably, they strip out everything else that competing new QA datasets were adding at the time — conversational state, multi-hop retrieval across documents, external knowledge sources. Single passage, independent questions, no retrieval. The only added complexity is the reasoning demand.
[S] That's a deliberately narrow bet. If the numeracy layer is the whole story, fine. If models find a shortcut around it instead, the dataset doesn't teach anyone much.
[G] Which is exactly the tension the rest of this conversation is about.
[O] Walk us through how they actually built it, Gabe. Ninety-six thousand questions don't write themselves.
[G] They start with passage selection. They mined Wikipedia for passages with, quote, "a narrative sequence of events, particularly with a high proportion of numbers." Pilots showed two categories worked best — N F L game summaries and history articles — topped up with any passage containing at least twenty numbers. That yielded about seven thousand candidate passages.
[S] Sports box scores and battle histories. Numerically dense by construction.
[G] Exactly the point. Then onto Mechanical Turk. Each worker saw five passages and had to write at least twelve question-answer pairs, primed with five example categories borrowed from the semantic parsing literature — addition and subtraction, minimum and maximum, counting, selection, and comparison.
[O] And here's the part I think is the paper's smartest move — the adversarial filter.
[G] Yes. While a worker was writing, a live BiDAF model — a 2018-era reading comprehension system — ran in the background, and a question could only be submitted if BiDAF got it wrong. So "make it hard" isn't a vague instruction to a crowd worker, it's an operational gate enforced by an actual model's failure.
[S] Which also means the difficulty is calibrated to one specific model's blind spots, not to some abstract notion of hard. I'll flag that now, we're coming back to it.
[G] Fair, hold that thought. Answers were restricted to three types to keep evaluation tractable — a span from the passage or the question, a date, or a number, and numbers were only allowed when the question named a unit, like "how many yards."
[O] Did they check their own work? Any validation pass?
[G] Every dev and test question got at least two more independent answers, or was flagged invalid — that happened for under one percent of the data and was discarded. Overall inter-annotator agreement was a Cohen's kappa of point seven four, breaking down to point eight one for numbers, point six two for spans, and point six five for dates. That's solid, on par with other crowdsourced Q A efforts.
[S] What did they end up with, in total?
[G] Ninety-six thousand, five hundred and sixty-seven question-answer pairs over six thousand, seven hundred and thirty-five passages, split by passage — roughly seventy-seven thousand for training, around nine thousand five hundred each for dev and test. Total Turk budget, sixty thousand dollars.
[O] And they characterized what kind of reasoning is actually in there.
[G] They hand-annotated three hundred fifty questions. Subtraction is the biggest category, at twenty-eight point eight percent, then selection at nineteen point four, comparison at eighteen point two, counting at sixteen point five, addition and sorting each around eleven point seven. By automatic tagging, two-thirds of all answers, sixty-six point one percent, are just bare numbers.
[S] So structurally, this is a numeracy benchmark wearing a reading-comprehension costume.
[G] That's a fair one-line summary, and I doubt the authors would object to it.
[O] None of the standard extractive readers can produce a number that isn't literally copied from the passage. So what did the authors build to fix that?
[G] NAQANet, a numerically-aware version of QANet. It shares one passage-and-question encoder, then splits into four parallel output heads. A passage-span head, identical to a normal extractive reader. A question-span head, because some DROP answers actually live in the question text itself. A count head, a ten-way classifier that picks a number from zero through nine. And an arithmetic head, which pulls every number mentioned in the passage and assigns each one a sign — plus, minus, or ignore — so the chosen numbers sum to the final answer.
[S] And something has to decide which of those four heads to trust for a given question.
[G] Right, a categorical gate sits on top, trained to pick the answer type at inference time.
[O] How do you even train that, when the dataset only gives you the answer string, not which mechanism produced it?
[G] Weak supervision, borrowed from the semantic parsing literature. The training objective marginalizes over every possible execution — every span match, every count value, every sign assignment — that evaluates to the correct answer. The addition-slash-subtraction search is restricted to exactly two numbers, to keep the space tractable.
[S] That two-number ceiling is worth remembering. It caps what this model can even attempt.
[G] It absolutely does, and it shows up directly in the results.
[O] Okay, results. Give us the topline first.
[G] Three families of baseline. Heuristic checks — a majority-answer guesser, question-only, passage-only — score near zero, one point four four, eight point five nine, and two point two six F one respectively, which tells you DROP doesn't have an obvious shortcut sitting in the surface data. Semantic parsers ported from the WikiTableQuestions pipeline top out around eleven percent, the best of the three, using semantic role labeling, hits eleven point four five. And SQuAD-style extractive readers do best among the prior architectures — BiDAF at twenty-seven point four nine, QANet at twenty-eight point three six, QANet plus ELMo at twenty-nine point six seven, and BERT at thirty-two point seven percent F one, on test.
[S] Thirty-two point seven, that's the number in the abstract, "the best systems."
[G] It is. And human performance, measured on that same test set, is ninety-six point four two percent F one.
[O] A sixty-four point gap. That's the headline that made this paper famous.
[S] It's a real gap. I want to know what actually closes it before I call it damning.
[G] NAQANet closes some of it — forty-seven percent F one, forty-four point oh seven exact match on test, a fourteen point three point absolute F one gain over BERT. And the ablation is honest about where that gain comes from. Adding only the question-span head actually hurts, relative to QANet plus ELMo — it drops to twenty-eight point one eight. Adding the count head brings it back to rough parity with BERT, thirty-two point seven five. The arithmetic head is what actually moves the needle, jumping to forty-two point nine six. The complete model, all four heads together, reaches that forty-seven percent.
[O] So the count and arithmetic heads are doing essentially all the work.
[G] Precisely, and that tracks the dataset's own composition. Remember, two-thirds of answers are bare numbers.
[S] Does NAQANet actually win everywhere, by answer type?
[G] No, and it's an honest result. On the numbers category, sixty-two percent of dev answers, NAQANet scores forty-four point two F one against BERT's fourteen point eight. BERT literally cannot produce a computed number, it can only guess a nearby span. But on dates, under two percent of answers, it flips — BERT edges ahead, forty-two point eight versus thirty-five point five, because NAQANet has no date-arithmetic head at all.
[O] Which is a clean illustration that the model only wins where it was actually built to win.
[G] The authors also ran an error analysis on a hundred wrong NAQANet predictions. Arithmetic mistakes show up in fifty-one percent, counting errors in thirty percent, domain or common-sense gaps in twenty-three percent, coreference in six percent, and forty percent involve more than one type at once. The remaining failures track exactly the reasoning types it wasn't built to handle.
[S] And the semantic parsing baselines, why so weak, eleven percent?
[G] The paper diagnoses that on itself. Converting a paragraph into a structured table, the step semantic parsers need, produced a usable logical form for only thirty-four percent of training examples with the best schemes, and twenty-five percent with open information extraction. On a sixty-question sample, only a quarter of the resulting tables even contained the needed information, and of the logical forms found, only eight, thirteen percent, actually reflected the question's real meaning rather than accidentally landing on the right number.
[O] So eleven percent isn't a verdict on symbolic reasoning as an idea, it's a verdict on one particular information-extraction pipeline.
[G] That's a fair reading, and it's close to what the paper itself says.
[O] Time for the actual debate. I'll go first, optimist case. This paper called it, correctly, years before most of the field did — that matching humans on SQuAD did not mean models could reason, it meant models were good at alignment, not comprehension. Every "does the model actually compute, or just retrieve" benchmark that came after this is downstream of the diagnosis made right here. That's not a small contribution, that's setting the field's terms for a decade.
[S] I'll grant the diagnosis. I won't grant that the sixty-four point gap, as reported, is a clean measurement of it. There's a sentence buried in one line of the paper that bothers me — they say, quote, "we also omitted the training questions which cannot be answered by a span in the passage," and that's forty-five percent of the training set.
[G] That's accurate. BiDAF, QANet, QANet plus ELMo, and BERT are all pure span extractors — architecturally, none of them can output a number that isn't copied straight from the text. So nearly half of DROP's training signal, every question whose answer is a count or a computed number, was simply unavailable to them.
[S] Meanwhile NAQANet trains on the full set, including exactly the questions the other models never even saw. So part of that jump from thirty-two point seven to forty-seven percent is a training-data availability gap, dressed up as an architectural one. The abstract doesn't foreground that at all.
[O] Fair hit, but it doesn't touch the headline gap against humans, ninety-six percent versus even BERT's thirty-two — that's the number that actually shook the field awake.
[S] Which brings me to concern two, that ninety-six point four percent human number. Who exactly are the humans?
[G] The six paper authors, collectively answering five hundred sixty test questions.
[S] Not an independent crowd, not a held-out expert panel. Six people who designed the reasoning taxonomy are grading a test they wrote the rubric for. That's not a neutral upper bound.
[G] The paper does defend the choice. They argue it's fairer than holding out one gold annotation, since DROP answers can have multiple valid phrasings, and grading against a single reference would underestimate human performance. That's a legitimate methodological point.
[O] Defensible, just not independently verified.
[G] Right, and it's worth remembering the next time someone cites "ninety-six percent" as if it were an arm's-length number.
[S] One more, and it's the concern that ages worst — contamination. These passages are lifted verbatim from Wikipedia, N F L summaries and history articles. Exactly the kind of high-frequency, high-quality text every model trained on Common Crawl or Wikipedia dumps has since seen, probably many times over.
[O] The paper obviously can't be blamed for that, it predates the whole contamination-auditing conversation by years.
[S] Sure, but a current zero-shot DROP score on any modern model is confounded in a way the twenty nineteen baselines never had to worry about. There's no refreshed test set, no living benchmark mechanism.
[G] And the adversarial filter compounds that a little — it calibrated difficulty against one specific model, BiDAF, at one point in time. It isn't a moving target the way later, iteratively-filtered datasets are. "Hard for BiDAF" has drifted much further from "hard for a current model" than the authors could have anticipated in twenty nineteen.
[O] I'll score that round to the skeptics. The diagnosis stands, the specific headline numbers need footnotes.
[S] I'll take that trade.
[O] Let's zoom out. What's this paper's afterlife, practically?
[G] Directly, it's the reason numeracy became a first-class axis in reading comprehension evaluation, not an edge case. NAQANet's own heads look primitive today, a ten-way count classifier, two-number addition and subtraction only, but the pattern it introduced, dedicated symbolic output heads instead of free-text generation, echoes in later tool-use and calculator-augmented systems.
[S] For evaluation practice specifically, this paper is basically a case study in why a benchmark needs a maintenance plan. Build it once against one adversary, and the adversary goes stale.
[G] Within a couple of years, models built specifically for DROP closed most of the gap to that ninety-six percent ceiling. The static test set and single-model adversarial filter that made DROP hard in twenty nineteen are exactly what let it be climbed faster than SQuAD was.
[O] Which, to be fair, is also a success story. The benchmark did its job, forced the field to build numeracy-aware models, and then got outgrown. That's the healthy version of a benchmark's life cycle.
[S] Sure, as long as everyone remembers it's outgrown, and doesn't quote thirty-two point seven versus ninety-six point four as if it still describes a current model tested zero-shot.
[G] If there's one sentence to take from this paper, it's that solving span extraction was never the same thing as solving reading comprehension. DROP is the paper that made the field admit it.
[O] My takeaway: this is one of the cleaner examples of a benchmark paper actually changing what the field measures, not just what it optimizes for.
[S] Mine is the opposite lesson. Read the methods section before you quote the headline gap, because thirty-two point seven versus ninety-six point four is doing a lot of unstated work about which questions each system was even allowed to see. For the full writeup, figures, and citations, head to the Litsearch site.
