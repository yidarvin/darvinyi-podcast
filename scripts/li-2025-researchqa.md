---
slug: li-2025-researchqa
title: "ResearchQA: Evaluating Scholarly Question Answering at Scale Across 75 Fields with Survey-Mined Questions and Rubrics"
description: "A twenty-one thousand question, seventy-five field benchmark mined from academic surveys finds that even the best deep-research system misses citing the right paper eighty-nine percent of the time."
date: 2026-07-19
guest_name: "Lachlan"
guest_voice: "am_fenrir"
---
[S] Picture a benchmark that pits eighteen different AI research assistants against each other, and every single one of them, even the very best, still fails to cite the specific paper it should cite eighty-nine percent of the time.
[O] And the same paper says the fix might just be: let the systems write longer answers.
[S] Which is exactly the kind of number that makes me want to know what's actually being measured here.
[G] Both of those readings are defensible, and the authors spend a surprising amount of the paper trying to settle which one is right.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the research literature.
[O] Today's paper is ResearchQA: Evaluating Scholarly Question Answering at Scale Across Seventy-Five Fields with Survey-Mined Questions and Rubrics, by Li S. Yifei, Allen Chang, Chaitanya Malaviya, and Mark Yatskar, all at the University of Pennsylvania.
[S] It made our list because deep-research tools are suddenly everywhere, and almost nobody outside AI and NLP has a rigorous way to grade what they produce.
[G] Joining you both today — this is one of the more ambitious attempts I've seen to fix scholarly evaluation without just hiring an army of new experts.
[O] Glad to have you, Lachlan. Let's start with why this was even a problem. Grading research answers can't be that different from grading any other long-form output, can it?
[G] It's harder than it looks. A good answer to an open research question has a huge space of acceptable forms, so overlap metrics like ROUGE are gameable, and comparing against one fixed reference answer doesn't work well either.
[S] So the field's fallback has been expert annotation — get researchers to actually read the answers.
[G] Right, and that works, but it's expensive, so it only really happens where authors can conveniently enlist their own colleagues.
[O] Which in practice means NLP and computer-science-adjacent fields, over and over again.
[G] Exactly. The paper cites prior efforts — QASPER, QASA, KIWI, ScholarQABench — and they all top out at a few thousand queries in one or two domains. Oncology, ecology, materials science, economics: essentially unevaluated.
[S] So the bottleneck was never really about building better assistants, it was about building a way to grade them outside a narrow slice of computer science.
[G] That's the paper's framing exactly. And their insight is that research expertise is already written down. Survey articles exist specifically to consolidate a field's open questions and synthesize the evidence that answers them.
[O] So instead of paying a new expert for every question, you mine the experts who already wrote the surveys.
[G] That's the whole pitch — manufacture both the questions and the grading criteria from existing survey literature, without recruiting a single new expert for the bulk of the work.
[S] Okay, "mine surveys" is a mouthful. Walk me through the pipeline, step by step.
[G] It starts by ranking the top twenty publishing venues by h-index for each field on Google Scholar. They first had to consolidate Scholar's own field taxonomy, which is either too broad or too narrow, down from two hundred fifty-seven fields to ninety-four — that gives about six hundred sixty venues to work from.
[G] From there, keyword search across Crossref, Semantic Scholar, and S2ORC for terms like "survey" and "literature review" turns up over six hundred thousand candidate articles. A little over a hundred thirty thousand have downloadable full text, and a gpt-4.1-mini classifier filters that down to fifty-four thousand genuine surveys, with an F1 score of point eight zero and precision of point eight seven.
[O] So more than half a million candidates, filtered through three separate stages, just to get a clean pool of surveys to mine.
[S] And that's before you've generated a single question.
[G] Right — mining is still selective after that. They keep medium-length sections with at least three inline citations, dropping anything too short or absurdly long, which trims eight hundred eighty-six thousand candidate sections down to about three hundred nineteen thousand quality ones.
[S] What model is actually writing the questions and the grading criteria from those sections?
[G] gpt-4.1-mini, throughout the whole pipeline — chosen as a cost and quality trade-off, since this runs at enormous scale. For each section it extracts a tree-structured summary, then writes a query plus a reference answer grounded in the supporting sentences, and tags the query with a knowledge cutoff equal to the source survey's publication year.
[O] And I assume not every mined query survives.
[G] It doesn't. Queries are scored one to ten for how standalone they are, and separately for how much answer variability they'd invite among different experts. Anything too context-dependent, or too open to consistent grading, gets discarded. What's left is twenty-one thousand four hundred queries: about seventeen thousand for training, seven hundred for validation, and a thirty-seven-hundred-query test set that samples fifty queries from each of the seventy-five fields, so no single discipline dominates.
[S] The rubrics are what I actually care about, since that's what turns "did this answer say something good" into something checkable.
[G] Each query gets up to eight rubric items, generated two ways and then merged. Survey rubrics condition on the query and the reference answer together. Parametric rubrics condition on the query alone, to catch anything the survey section might have missed.
[G] The merged hybrid rubric dedupes the two, drops anything citing a paper that isn't matchable on Google Scholar, and keeps the top eight — about seven and a half items per query on average, and sixty-one percent of them traced back to the source survey.
[O] What do the criteria actually look like?
[G] Three types: information-based items, like citing the right paper or making the right comparison; depth-based items; and citation-based items specifically. Every item gets scored zero to four for coverage, so instead of a vague "is this good," you get an absolute, checkable measure per criterion.
[S] And on the judging side — they don't just trust an LLM's gut preference between two answers, do they?
[G] They tried that first, and it was mediocre on its own. So they built an ensemble judge: a direct "which answer is better" verdict, run in both orderings and worth four points each, added to the summed rubric-coverage scores for that answer. Pairwise battles are then aggregated with a Bradley-Terry model — the same machinery Chatbot Arena uses for its Elo ratings.
[O] So does folding the rubric in actually make the judge more trustworthy? That's the first thing I want to know.
[G] It does, and they measured it carefully. Thirty-one Ph.D. annotators across eight fields voted on which of two retrieval-augmented answers was better, and human-to-human agreement on those votes tops out at eighty-four percent — that's the ceiling for any judge.
[S] So how close does an LLM judge get to that ceiling?
[G] A direct judge with no rubric — just picking a winner — hits seventy-one percent agreement using proprietary models, and only sixty-four percent using open models. Fold in rubric coverage through the ensemble protocol, and that climbs to seventy-four and sixty-nine percent respectively.
[O] So the gap to the human ceiling shrinks from about thirteen points to under ten.
[G] Precisely — twelve point seven percent down to nine point six percent, a twenty-four percent relative reduction. Hybrid rubrics help in seven of eight validation fields, and they let the small open-source judge, Prometheus-2, match the direct-judging accuracy of Claude-Sonnet-4.
[O] That's a genuinely useful result — a cheap open judge closing most of the gap to a frontier model, just by handing it a checklist.
[S] Fine, the judge got better. Now tell me how the actual systems performed.
[G] This is the headline finding. Across seven thousand six hundred head-to-head battles over eighteen systems, split into four tiers — pure parametric memory, naive retrieval, production retrieval, and deep-research APIs — no parametric or retrieval system clears seventy percent coverage.
[G] The single best system is Perplexity's sonar-deep-research, at seventy-five point two nine percent coverage, and it wins eighty-two percent of its head-to-heads against the next-best system, Gemini-2.5-Pro.
[O] An eighty-two percent win rate is not a marginal edge. That's a system playing a different game.
[S] Or a system in a different length regime — we'll get to that. What about retrieval — does just bolting search onto a model help?
[G] Only selectively. On average, the same model swings by seven point six percentage points in coverage between naive and production-grade retrieval, and naive retrieval can actually score worse than a model's own parametric-only answer if it's poorly engineered.
[G] Retrieval also helps some models more than others: parametric Claude-Sonnet-4 trails Gemini-2.5-Pro with only a thirty percent win rate, but once both models retrieve, Claude leads with a seventy-five percent win rate.
[O] So raw model strength and retrieval engineering are genuinely separate axes — you can't infer one from the other.
[S] Now the part I actually want: where is the best system failing?
[G] Broken down by rubric type — citation items, where the criterion is citing a specific named paper, make up about eight percent of all items, and eighty-nine percent of those go not fully covered, even by sonar-deep-research. Limitation items, naming a weakness, are under three percent of the rubric, and fifty-two percent go uncovered. Comparison items sit at fourteen percent of the rubric, with fifty-two percent uncovered.
[G] Domain effects are smaller than you'd expect, within about six percentage points across domains — but Humanities is the weakest domain for all eighteen systems, and Health Sciences sits near the bottom too.
[O] So citing the right specific work is the single hardest thing to get right — harder than making a comparison or naming a limitation.
[G] By a wide margin, yes.
[O] Here's my optimist case. This is the most field-diverse scholarly benchmark that exists, it was built without paying for new expert annotation at the scale that would normally require, and it shows a real, measurable gap between deep-research tools and everything else. An eighty-two percent win rate is not noise.
[S] Here's mine. That seventy percent wall is partly a mirage. The headline numbers are all measured under a two-hundred-fifty-word answer cap. Lift the cap, and sonar-deep-research's answers balloon from two hundred sixty-seven words to over fourteen hundred words — a four hundred thirty-five percent increase — and its coverage jumps nine points, to eighty-five point three percent, plateauing around two thousand words.
[O] But the cap isn't arbitrary — it matches the roughly two hundred eighty-nine word average of real expert-written answers, so it's controlling for a known length bias, not hiding one.
[S] Sure, but then don't sell it as a "wall." Call it a length-normalized recall score, because that's what it is, and the leaderboard ordering rides on that normalization.
[G] Both points land, honestly. The authors are explicit about this — they ran the unconstrained-length ablation themselves and reported it, which is more self-auditing than most benchmark papers bother with. Coverage is a recall metric, full stop, and recall rises with verbosity. Whether you call that a wall or a recall ceiling is a framing choice, not a fact in dispute.
[S] Here's my bigger worry: one model family, gpt-4.1-mini, writes the queries, writes the rubrics, filters the hallucinations, and grades the final answers. That's the same model being question-writer and judge.
[G] The paper takes the self-preference literature seriously and cites it directly. Two things cut against the worst case: the top-ranked system is Perplexity's sonar, not an OpenAI model, so this isn't just crowning its own family. And the judge is validated against those thirty-one Ph.D. annotators — a Pearson correlation of point six three, and it tracks expert-assigned coverage within about a tenth of a point on average.
[O] That sounds like a reasonably well-calibrated judge to me.
[G] Mostly, but not at the extremes. gpt-4.1-mini rates an item "completely covered" twenty-six percent of the time, versus twelve percent for the human experts. So individual scores can run hot even where the overall rankings still hold up.
[S] And how carefully was the content of the rubric itself checked? A checklist is only as good as the items on it.
[G] That's the honest weak point. "Hallucination removal" only verifies that a cited paper is findable on Google Scholar, not that the criterion is actually correct or that the survey's underlying claim was sound. Parametric rubrics carry about a fifteen percent vacuous-or-error rate; the hybrid rubrics used for the actual leaderboard are cleaner, with eighty-seven percent passing expert review.
[O] And that expert review itself only covers eight of the seventy-five fields.
[G] Right, and that's worth sitting with. The test set is weighted toward Health Sciences and Medicine, around forty-four percent of it, but only a handful of biomedical annotators are standing behind validation for that whole slice. The other sixty-seven fields lean on the gpt-4.1-mini pipeline with much less direct human checking.
[S] So the parts of this benchmark I'd trust the most are exactly the parts that look most like the old NLP-only benchmarks it was built to replace.
[G] That's a fair way to put it, and it's a tension the paper doesn't fully resolve — the breadth is the contribution, but the validation stays concentrated.
[O] One thing in its favor, though: they actually checked for leakage, whether systems retrieving the source survey get an unfair boost, and found it's small — about a one percent aggregate difference, going up in eight of thirteen leaking systems and down in the other five.
[S] I'll grant that one. It's a real robustness check, and it came out clean.
[O] Step back for a second — if this holds up under more scrutiny, what actually changes?
[G] It gives fields outside AI and NLP their first real benchmark for whether a research assistant's answer is actually complete, not just fluent. An oncologist or a materials scientist wondering whether a deep-research tool is safe to lean on now has a number to look at, even an imperfect one.
[S] For evaluation practice more broadly, it's another data point that LLM-judge reliability is solvable — not by trusting the judge's gut, but by grading it against something concrete, the way rubrics do here.
[O] Which feels like a pattern worth stealing for other hard-to-grade tasks, not just scholarly question answering.
[G] The paper frames it that way too — rubric-based grading as a general recipe for evaluating open-ended, long-form generation, anywhere a reference corpus like surveys or documentation already exists.
[G] If there's one line to take from this paper, it's that no current system, however capable, comes close to fully answering a real research question the way an expert would — citations are the clearest gap.
[O] My takeaway is that deep-research tools are a genuine step change over plain retrieval, and this is the first benchmark broad enough to actually show that at scale.
[S] Mine is: read the coverage number as a length-sensitive recall score from a single-model judge, not an absolute grade, and go look at the full writeup on the litsearch site for the figures and the field-by-field breakdown before you cite the leaderboard.
