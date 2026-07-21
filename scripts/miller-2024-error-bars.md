---
slug: miller-2024-error-bars
title: "Adding Error Bars to Evals: A Statistical Approach to Language Model Evaluations"
description: "Evan Miller applies the statistics of clinical trials to LLM leaderboards, and shows that Meta's own Llama 3 confidence intervals were sometimes three times too narrow and sometimes needlessly wide -- with a fix that flips a textbook two-out-of-three benchmark win into a single real result."
date: 2026-07-19
guest_name: "Somerset"
guest_voice: "bm_lewis"
---
[S] Somewhere in a leaderboard, a bolded state of the art score is statistically indistinguishable from the row underneath it.
[O] Or the opposite happens: a real gap between two models gets waved off as noise because nobody attached an error bar to either number.
[G] The paper we're covering claims both mistakes are sitting in the same widely cited document, the Llama three technical report.
[S] A single statistician re-derived Meta's own confidence intervals from the raw eval structure and found some were too narrow, and others needlessly wide.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar dig into one paper at a time.
[S] Today's paper is Adding Error Bars to Evals, A Statistical Approach to Language Model Evaluations, written solo by Evan Miller at Anthropic, posted in November of twenty twenty-four.
[O] And joining us is Somerset, a visiting scholar who's spent real time with this one. Welcome, Somerset.
[G] Thanks for having me. This is a paper I think more people in the field should have actually sat down and read.
[S] Somerset, walk us through the actual gap here. Evals report percentages, models get ranked, the field moves on -- what's wrong with that?
[G] The paper's framing is that an eval is, in a literal sense, an experiment. You sample a set of questions, run the model over them, and compute a summary statistic. Every other experimental science treats that statistic as an estimate with uncertainty attached, and refuses to declare a winner until the uncertainty is accounted for.
[O] But language model evals didn't inherit that habit.
[G] Right. Miller calls it a highest-number-is-best mentality. Industry practice bolds the state of the art result in a table without testing whether it's actually distinguishable from the next row down.
[S] Is anyone doing this even partially right?
[G] Chatbot Arena is a partial exception -- it reports confidence intervals on its Elo scores. And the paper singles out Meta's Llama three technical report as the one real exception among traditional multiple-choice and free-response evals: it actually ships confidence intervals.
[O] So Llama three gets credit for trying.
[G] Credit for trying, and then the paper spends two sections showing where the attempt goes wrong -- the wrong formula in some places, no correction at all for correlated questions in others. We'll get to specifics.
[S] Give us the motivating example before we go deeper.
[G] Miller sets up two fictional models, Galleon and Dreadnought, being evaluated for a coding-and-math-heavy deployment. Three evals: MATH for mathematical reasoning, HumanEval for Python coding, and MGSM for multilingual grade-school math.
[O] And the raw numbers look like a split decision.
[G] Galleon scores sixty-five point five percent on MATH against Dreadnought's sixty-three percent, a two-and-a-half point edge. But Dreadnought comes out ahead on HumanEval by three point one points and on MGSM by two point seven points. Two wins to one for Dreadnought, if you just read the percentages.
[S] So on its face, you'd ship Dreadnought.
[G] That's the naive read. The entire rest of the paper exists to tell you whether that read survives contact with the actual uncertainty behind those three numbers.
[S] Let's build the statistical machinery. Somerset, start with the base case: independent questions.
[G] Miller's central move is to imagine the questions in an eval weren't hand-picked exhaustively, but drawn at random from an infinite, unseen population of possible questions probing some underlying skill. That's the same move behind survey sampling generally.
[O] So the eval score isn't the truth, it's an estimate of the truth.
[G] Exactly. Each question's score splits into a true conditional mean for that question, plus a random noise term from that one sampled answer. Average across the eval, and the Central Limit Theorem gives you a closed-form standard error for free, no bootstrapping required.
[S] How big a deal is skipping that, practically?
[G] Big enough that Miller flags a concrete error in the Llama three report. They used the Bernoulli standard error formula, the one built for right-or-wrong scoring, on every eval, including ones scored with fractional metrics like F1. That's not catastrophic, it makes the interval too wide rather than wrong, but it's still not the correct formula for that data.
[O] What does correct reporting look like instead?
[G] The paper's suggested table adds two things next to every score: the number of questions behind it, and the standard error in parentheses beneath the mean. MATH's five thousand questions gets a standard error of about point seven percent. HumanEval's mere one hundred sixty-four questions gets three point two percent.
[S] That HumanEval number should worry people. Three points of noise on a benchmark people compare to the decimal.
[G] It should. And that's before we get to the second big idea: clustering.
[O] What's a clustered question?
[G] Some evals don't draw questions independently. DROP, QuAC, RACE, and SQuAD ask multiple questions about the same reading passage. MGSM asks the identical question translated into many languages. Once a model handles one member of a cluster well, you already know something about how it'll do on its siblings.
[S] So the questions aren't independent draws, and the plain formula understates the uncertainty.
[G] Right, it understates it because it's implicitly treating correlated observations as independent, which shrinks your apparent noise. Miller imports clustered standard errors from econometrics: treat each passage or source question as the independent unit, and let correlation run free within it.
[O] How much does that actually move the number?
[G] On real Anthropic model data, not the fictional example: DROP's clustered standard error comes out three point zero five times wider than the naive one. RACE-H is a milder one point one times. MGSM is one point eight eight times.
[S] Three times wider is not a rounding error. That's the difference between a real result and total noise.
[G] Which is Miller's exact point about Llama three's reading-comprehension evals. He states directly that their confidence intervals are likely anti-conservative, meaning too narrow, because clustering on passage structure wasn't done.
[S] Move to variance reduction. What can you actually do about a noisy eval besides writing more questions?
[G] The total variance splits into two pieces: the variance from which questions you happened to draw, which is fixed and can't be engineered away, and the variance from a single sampled answer to a given question, which can be. Two levers attack that second piece.
[O] Lever one?
[G] Resampling: answer each question multiple times and average. In a worked example with binary scores, going from one sample to two cuts total variance by a third. Four samples cuts it in half. Six samples reduces it by five ninths. The ceiling, no matter how many samples you take, is two thirds off, because the question-selection variance never goes away.
[S] And lever two?
[G] Next-token probabilities. If the eval doesn't need chain-of-thought and the correct answer sits in the first token, score the model's probability on that token instead of a single sampled completion. That drives the per-question noise to exactly zero and hits the full two-thirds reduction without needing multiple samples at all.
[O] That sounds like a free lunch.
[G] It is, when the eval structure allows it. But there's a tempting third lever the paper explicitly warns against: turning down the sampling temperature to make outputs less random.
[S] Why not? Less randomness sounds like less noise.
[G] Because cooling the temperature doesn't remove variance, it relocates it. In one worked example, a true-false eval at temperature one has a certain spread across question difficulties. Forcing greedy decoding rounds every question to a hard right-or-wrong outcome and triples the variance of that spread, from one twelfth up to one quarter.
[O] So you traded noise you could fix for noise you can't.
[G] Precisely. In a second example the effect is worse: cooling the temperature doesn't just increase the variance roughly fivefold, it silently shifts the expected score itself, from two thirds up to three quarters. You've changed what the eval measures without meaning to.
[S] So the rule is: resample or use token probabilities, never touch the thermostat.
[G] That's more or less the paper's own name for the section, yes.
[O] Let's close the loop on Galleon and Dreadnought.
[G] Apply pairwise analysis, comparing the two models on the same questions rather than treating each score in isolation, and cluster where the eval demands it, and the picture flips. On MATH, the ninety-five percent confidence interval for Galleon's lead runs from one point two to three point eight percent, entirely on the positive side. That gap is real.
[S] And the other two?
[G] HumanEval's interval runs from minus seven point two to plus one percent. MGSM's runs from minus six point one to plus zero point seven. Both straddle zero. Dreadnought's apparent wins on those two evals are statistically indistinguishable from noise once you do this correctly.
[O] So the naive read was exactly backwards.
[G] The naive read said Dreadnought wins two of three. The correct read says only Galleon's MATH lead is real, and the other two comparisons tell you nothing you can act on.
[S] Where does the pairing trick get its extra power from? What's the intuition?
[G] Question difficulty correlates across models -- a hard question tends to be hard for both. Subtracting each model's score on the same question, rather than comparing the two averages separately, removes that shared difficulty and leaves a tighter estimate of the real gap. In the paper's own worked example, pairing with a correlation of point five cuts the variance of the estimated difference by a third.
[O] That's a genuinely free upgrade, no new data, just a better use of the data you already have.
[G] It is, and Miller recommends technical reports make it standard: the pairwise difference, its standard error, and the correlation between the two models' scores, every time two models share a question set.
[S] Now the fifth tool, power analysis. What does that add?
[G] It flips the question around. Instead of measuring the uncertainty you have, it tells you how many questions you'd need to reliably detect a difference of a given size before you ever run the eval.
[O] Give us the headline number.
[G] In a reasonable worked example, eighty percent power, a five percent false-positive rate, aiming to detect roughly a three-point gap, the formula says you need about nine hundred sixty-nine questions. Miller's practical takeaway: new evals should carry at least a thousand questions to have real signaling power.
[S] HumanEval ships with a hundred and sixty-four.
[G] Which is exactly the comparison the paper wants you to make. There's also a version for a fixed eval size. With one hundred ninety-eight questions, increasing the resample count per question from one to ten shrinks the smallest detectable gap from thirteen point two percent down to seven point five percent.
[O] So if you can't add questions, you can buy detection power with more samples per question.
[G] At the cost of more inference compute instead of more questions, yes. It's a real trade, but now it's one you can make on purpose instead of by accident.
[O] Here's my optimist case: this closes an embarrassing gap. We've been treating two-point gaps on five-thousand-question evals as gospel, and it turns out a chunk of them are coin flips. That's methodological hygiene the field should have had years ago.
[S] My skeptic case: precise error bars on a bad question don't make it a good question. The whole apparatus assumes the eval's questions are meaningfully sampled from some real distribution of skill. Benchmarks are curated by hand, not drawn at random -- the paper gives you rigor about noise and says nothing about whether the noise-free part is measuring the right thing.
[G] You're both right, and the paper itself only half-answers this. It says plainly that it's staying agnostic about the relative and qualitative merits of evals -- it's solving statistical validity, not construct validity, and those are genuinely different problems.
[S] So a benchmark can have beautifully tight confidence intervals and still be a bad benchmark.
[G] Correct, and that's less a flaw in the math than a scope boundary the paper draws for itself. Where I'd push harder is the boundary of the independence assumption.
[O] Meaning clustering doesn't catch everything.
[G] Right. Clustering handles one specific violation: questions sharing a passage or a translated source. It doesn't touch near-duplicate or template-generated questions scattered non-adjacently through an eval, systematic difficulty drift as an eval gets built over time, or a shared answer-extraction script failing the same way across superficially unrelated questions. Cluster correctly on passage and you can still be silently correlated in ways the paper gives no diagnostic for.
[S] That's a real hole. What about grading noise, judges, raters?
[G] That's the sharpest gap, in my read. Both variance-reduction levers, resampling and next-token probabilities, assume the noise comes from the model's own answer stochasticity on an exactly gradable question. Neither one addresses an LLM judge or a human rater scoring the same answer differently on different passes, which is arguably the dominant noise source in today's open-ended, rubric-graded evals.
[O] The paper's own reference list gestures at that problem without formally modeling it.
[G] It cites the Challenges in Evaluating AI Systems piece and leaves it there. Judge variance is a different noise source than the one this paper decomposes, and it doesn't average away the same way resampling the answerer does.
[S] One more: what happens when you run this apparatus across a whole leaderboard, not just one pairwise comparison?
[G] That's the multiple-comparisons problem, and the paper doesn't address it at all. Every worked example computes one confidence interval for one comparison. A real technical report runs dozens of comparisons across many models and benchmarks. Apply a five percent false-positive rate to thirty simultaneous comparisons in a table, and you're almost guaranteed one highlighted cell that's pure noise.
[O] So the paper's own recommended reporting format, one confidence interval per cell across a whole table, creates exactly the problem it's trying to solve.
[G] If you adopt it naively across an entire leaderboard, yes. Nothing in the five recommendations, or the conclusion, addresses family-wise error control. No Bonferroni correction, no Benjamini-Hochberg, nothing.
[S] And the clustering fix has its own hidden assumption, doesn't it?
[G] It assumes clusters are themselves drawn independently -- reasonable for passages inside DROP, less obviously true if an eval's clusters come from a small number of source documents or curricula sharing systematic bias. The paper's own numbers hint at how much this matters, RACE-H's clustering ratio is a mild one point one, DROP's is three, but it never flags that the independent-clusters assumption could itself be wrong.
[O] Even with all that, I don't think it undercuts the core contribution.
[S] Agreed, it's a scoping critique, not a correctness critique. The math that's there is right. It's the math that isn't there yet, judge noise, multiple comparisons, that determines how far you can trust a report built on it.
[O] What actually changes if labs adopt this tomorrow?
[G] Concretely: every eval table grows a parenthetical standard error, cluster-aware where it applies, and comparisons get reported as paired differences with a confidence interval rather than two bare percentages sitting side by side.
[S] Is there friction to that, or is it basically free once you know the formulas?
[G] Mechanically it's close to free -- the Central Limit Theorem formula is closed-form, no bootstrapping required, and the paper derives it fully in three appendices. The friction is cultural: it means some highlighted state-of-the-art cells stop being highlightable, and that's a harder sell than a new formula.
[O] For anyone building agentic or rubric-graded evals, that connects straight back to the judge-variance gap you flagged.
[G] It does. This paper hands you the tools for sampling noise. The next paper the field needs is the equivalent treatment for grader noise, and nobody's written that one with the same rigor yet.
[G] If there's one line to take from this: an eval score without a standard error is an unfinished sentence.
[O] My takeaway: this is the kind of unglamorous rigor that actually compounds -- every future eval table gets more honest because one person decided to sit down and do the arithmetic.
[S] Mine: rigor about noise is necessary but not sufficient -- the real fight ahead is judge variance and multiple comparisons, and this paper opens that door without walking through it. Find the full write-up, with the figures and derivations, at litsearch dot darvinyi dot com.
