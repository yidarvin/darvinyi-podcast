---
slug: wei-2024-simpleqa
title: "Measuring Short-Form Factuality in Large Language Models"
description: "OpenAI built a benchmark of four thousand three hundred twenty-six trivia-simple questions with one indisputable answer each, and even the best frontier model still gets fewer than half of them right — because the real test isn't what it knows, it's whether it knows what it doesn't."
date: 2026-07-19
guest_name: "Soren"
guest_voice: "am_fenrir"
---
[S] Here's a number worth sitting with: the best model in this paper, tested on questions with one single indisputable answer, still gets less than half of them right.
[O] And here's the number that changes how you read that failure: the worst model in the same table doesn't hedge, it charges ahead answering almost everything, and is wrong ninety point five percent of the time it tries.
[S] So this isn't really a paper about what language models know. It's a paper about whether they know what they don't know.
[O] That reframe is the whole reason I wanted to cover it.
[S] Same. Let's get into it.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a guest scholar take apart one paper from the litsearch dot darvinyi dot com atlas. I'm your optimist host.
[S] And I'm the skeptic. Today's paper is Measuring Short-Form Factuality in Large Language Models, known as SimpleQA, by Jason Wei, Nguyen Karina, and colleagues at OpenAI, posted in November twenty twenty-four.
[O] And joining us is Soren, a researcher who's spent real time with this benchmark. Soren, welcome.
[G] Glad to be here. One note first: I'm not one of the authors, so "the authors show" or "they argue" means me describing their work, not claiming credit for it.
[S] Good, that distinction matters today, because this paper is unusually candid about its own limits, and we're going to hold it to that same standard.
[G] Fair enough, and honestly the paper invites that. It's short, it's direct, and it names most of its own weaknesses in the last two pages.
[O] Let's start with the gap. Soren, why did OpenAI think the field needed another factuality benchmark?
[G] Because hallucination, confidently stating false things, is one of the biggest barriers to trusting these systems, and factuality is brutally hard to measure. A long answer can contain dozens of separate claims, each needing its own check against the world.
[S] So there's no clean scalar to optimize.
[G] Right, so the move is to deliberately narrow the scope. Instead of grading sprawling completions, SimpleQA asks only short, fact-seeking questions with one single answer, trading away the open-ended case for something cheap and reliable to grade.
[O] What was wrong with the older benchmarks that already did this, TriviaQA, Natural Questions?
[G] They saturated. TriviaQA and Natural Questions were fine datasets in their day, but by twenty twenty-four frontier models scored high enough on both that they stopped separating strong models from weak ones. SimpleQA is explicitly built to still be hard: GPT-4o and Claude both score under fifty percent.
[S] So the design goal from the start was adversarial difficulty, not just topical coverage.
[G] Exactly, and that shows up directly in how the dataset was built.
[O] Walk us through construction, because I think the rubric is where the real engineering is.
[G] A two-stage human pipeline. First, an AI trainer, a human annotator, writes a question and answer pair. Then a second, independent trainer answers the same question blind, and the pair only survives if the two match.
[S] What stops someone from just writing an easy question that any model gets right?
[G] The adversarial-hardness rule. While writing a question, the trainer reviews four completions, mostly GPT-4 variants, and at least one has to be wrong, or the question gets discarded. Late in the process they swapped one completion to GPT-3.5, so smaller models would still get some signal instead of scoring near zero everywhere.
[O] That's a clever fix. Otherwise you'd have a benchmark that only separates frontier models from each other and tells you nothing about smaller ones.
[G] Two more rules matter. Single indisputable answer: the question pins down its own scope, so instead of "where did they meet," it asks "which city." And evergreen: answers can't drift over time, so a TV-show question specifies a season.
[S] And every answer needs a source?
[G] Two, from distinct domains. Each trainer cites a webpage backing their answer, and a question only survives if the two, taken together, cite at least two different domain names, catching a single unreliable source quietly deciding the ground truth.
[O] What's the cutoff for what a question can even ask about?
[G] Answerable as of December thirty-first, twenty twenty-three. That lets every model with a knowledge cutoff up to that date be compared on equal footing, nobody's penalized just for having an older training cutoff.
[S] And then there's cleanup on top of all that.
[G] Layered quality control. Few-shot ChatGPT classifiers flagged rubric violations, missing units, drifting answers, multiple valid answers, sending them back for revision, then a lightweight pass cleaned up grammar without touching content. At the end, a random one thousand questions went to a third trainer as a final audit.
[O] How'd that go?
[G] The autograder scored the third trainer at ninety-four point four percent. The authors manually read every one of the fifty-six flagged as wrong: fifteen were false negatives, and most of the rest were the trainer answering incompletely. Only about two point eight percent of the full one thousand were genuine dataset problems: ambiguous questions, sources disagreeing on a date.
[S] So the paper's own honest estimate is roughly a three percent error rate baked into the ground truth.
[G] That's their number, yes, and they say so plainly. It's worth remembering later, when we get to how finely the top models can actually be separated.
[O] What does the finished dataset actually look like?
[G] Four thousand three hundred twenty-six questions across ten topics. Science and technology leads at eight hundred fifty-eight, nineteen point eight percent, then politics at seven hundred nine, then art, geography, sports, music, TV, history, and video games trailing down. By answer type, about a third are dates, a quarter a person, fifteen percent a number.
[S] Where do the actual facts come from?
[G] Overwhelmingly Wikipedia, a source for about three thousand five hundred of the four thousand three hundred questions. After that it drops off fast: fandom dot com, U.K. academic domains, IMDb, each in the low hundreds.
[O] That Wikipedia concentration is going to matter later, isn't it.
[G] It is, hold that thought.
[S] Let's talk grading, because that's the mechanism the whole benchmark rests on.
[G] Grading is a prompted ChatGPT classifier that sees the question, the gold answer, and the prediction, and returns one of three labels. Correct: the prediction fully contains the reference answer, no contradiction. Incorrect: it contradicts the reference in any way, even a hedged "I think it's X, but I'm not totally sure." Not attempted: the answer isn't given, but nothing contradicts it, an honest "I don't know" lands here.
[O] And that third category is really the whole point of the paper.
[G] It is. Those three collapse into two metrics: overall correct, like recall, the percent of all questions answered right, and correct-given-attempted, like precision, the percent right among just the questions the model actually tried. The single number they report is the F-score, the harmonic mean of the two.
[S] I want to flag something in the appendix, because it's the kind of thing that should be on every eval scientist's radar. The F-score has a guessing loophole.
[G] It does, and the authors disclose it themselves, crediting Adam Kalai. Mathematically, if a model is more than fifty percent confident in a guess, its expected F-score is always higher guessing than abstaining. So F-score alone quietly rewards a little overconfidence.
[O] Do they offer a fix?
[G] A second metric: correct is worth one point, not-attempted zero, incorrect a penalty of negative p. Set p to nine, and a model only nets positive if it gets at least ninety percent of what it attempts correct. None of the eight models here clear that bar.
[S] None of them. That's a genuinely useful number to hold onto.
[O] Let's get to the leaderboard. Who actually wins?
[G] OpenAI's o1-preview, at forty-two point seven percent overall correct, an F-score of forty-four point eight. GPT-4o trails at thirty-eight point two percent correct. Claude-3.5 Sonnet is lower still on raw correctness, twenty-eight point nine percent.
[S] So even the best model gets fewer than half right, and these are questions the authors specifically call short and fact-seeking, not obscure trivia for its own sake.
[G] Correct, and that's deliberate, remember these were filtered to be hard for GPT-4-class models in the first place.
[O] Which raises the obvious worry: is this benchmark just hard for OpenAI's own models, and easy for everyone else?
[G] That's why they ran Claude as a sanity check. If SimpleQA were only overfit to GPT-4's blind spots, Claude should do noticeably better. It doesn't, decent evidence the difficulty generalizes rather than being an artifact of who wrote the questions.
[S] Now walk me through the two failure modes, because that table has a genuinely interesting split in it.
[G] GPT-4o-mini is the overconfidence case. It attempts almost everything, only zero point nine percent not-attempted, and is wrong ninety point five percent of the time it tries. The Claude-3 models sit at the opposite extreme: Claude-3-haiku declines seventy-five point three percent of questions outright.
[O] And Claude-3.5 Sonnet lands in an interesting middle spot.
[G] It does. It answers far fewer questions correctly than GPT-4o in absolute terms, but because it also attempts far fewer, thirty-five percent not-attempted versus one percent, the two end up with a similar F-score, thirty-five point oh versus thirty-eight point four. Two different strategies, nearly the same number.
[S] Which is exactly the argument for reporting more than the F-score. Two models can look equivalent on one axis and be doing completely different things underneath.
[G] That's the paper's core empirical point, yes. Raw knowledge and the willingness to bet on that knowledge are separate axes, and this benchmark is built to expose the gap between them.
[O] Let's get into calibration, because I think that's the most interesting result in the whole paper.
[G] Two ways. First, ask the model directly for a confidence percentage alongside its answer, then plot stated confidence against actual accuracy. Second, ask the same question one hundred times at higher temperature and treat the frequency of the most common answer as an implicit confidence signal.
[S] And the results diverge?
[G] Sharply. On stated confidence, every model sits below the perfect-calibration line, meaning every model overstates how sure it is. On the frequency method, calibration is much better, accuracy climbs smoothly with frequency, and o1-preview's curve comes close to the ideal diagonal.
[O] So the model's internal consistency, how often it lands on the same answer, is a more honest confidence signal than the number it says out loud.
[G] Fair read, and it's consistent with related work: Wang and colleagues found something similar for math word problems using self-consistency sampling. In both methods, bigger models are better calibrated: o1-preview beats o1-mini, GPT-4o beats GPT-4o-mini.
[S] So scale helps calibration, but even at the frontier, models trust their stated confidence more than they should.
[G] That's the finding, and I'd say it's the paper's most durable contribution: reframing factuality as a calibration problem, not just an accuracy problem.
[S] Alright, time for the actual debate. I'll go first this time, because I think the flaws here are structural, not cosmetic.
[O] Go ahead, I'll push back where I think you're overreaching.
[S] First: the model panel. Eight models, every one from OpenAI or Anthropic, almost all early-to-mid twenty twenty-four. No Llama, no Mistral, no Qwen, no Gemini. Not a benchmark of frontier models today, a snapshot of two labs, frozen a couple of release cycles back.
[G] Accurate, and there's a deeper version: difficulty is defined relative to GPT-4-class failures, since a question only makes it in if a mostly-GPT-4 completion got it wrong. The Claude check hedges against that being an OpenAI artifact, but the dataset is still curated on one family's mistakes.
[O] I'll grant the panel is thin, but the design, the rubric, the abstention grading, transfers cleanly to any model you'd run through it. The ideas outlive the eight rows in that table.
[S] Fine, portable. My second point is sharper: the grader's own validation is thin. The authors manually read one hundred correct, one hundred incorrect, and one hundred not-attempted completions and found, in their words, only two disagreements. No inter-annotator agreement statistic, no adversarial test of hedged phrasing.
[G] Fair, and there's a compounding version worth naming: the same autograder that scores the models also filters and audits the training data itself. If it has systematic blind spots, hedged answers, unusual number formats, they show up twice: once in what survives into the dataset, once in the leaderboard.
[O] I'd push back a little. Three hundred spot-checked completions with two disagreements is thin as a formal study, but the third-trainer audit independently landed near a similar low error rate. Two checks converging is some evidence the grader isn't wildly broken.
[S] Evidence it isn't wildly broken. Not evidence it's well calibrated near the margins, exactly where you'd want it reliable when separating a forty-two percent model from a thirty-eight percent one.
[G] And that connects to my last point, the sharpest one in the paper's own text: the roughly three percent estimated error rate in the ground truth sets a hard ceiling on resolution. Two models within a few points near the top, and you can't tell if that gap is real or just mislabeled questions.
[O] Now let me make the case for the paper. The abstention framing is a genuine methodological contribution. Most factuality evals before this only measured whether an answer was right. This one makes not-knowing a scoreable, first-class outcome, and that's the piece other benchmark builders are already borrowing.
[G] Agreed, and it's cheap too: gradable by a single API call each, low run-to-run variance from the large sample. That combination of adversarial difficulty and trivial grading cost is genuinely rare.
[S] I'm not disputing the design is clever, I'm disputing how far the headline numbers travel. Forty-two point seven percent from o1-preview is a real number about eight specific models on this specific dataset. It is not a general statement about how factual language models are.
[O] That's fair, and honestly the authors say almost exactly that themselves.
[G] They do. The discussion section is explicit: whether short-form factuality correlates with long-form factuality is an open research question. This paper measures one narrow, useful slice, and doesn't claim more.
[O] Let's zoom out. What does this mean for the field if it holds up?
[G] For evaluation practice broadly, the lasting idea is that "don't know" deserves its own scoring bucket. A lot of evals still treat abstention and wrong answers as equally bad, or don't allow abstention at all, which quietly trains models to guess.
[S] The contamination angle worries me going forward. Wikipedia sourced roughly eighty percent of these questions, and the dataset sits in a public GitHub repository. Evergreen design keeps answers from changing, but it does nothing to stop the pairs themselves leaking into some future model's pretraining data.
[G] Real tension, and the authors name it: their stated hope is that SimpleQA "remains relevant for the next few generations," but an openly released dataset with no private held-out split is exactly what leaks into training over time.
[O] So the honest way to use this benchmark going forward is probably: trust the framework, watch the absolute numbers decay in reliability as the years pass.
[S] About right. And for anyone building the next factuality benchmark, copy the three ideas, not the specific questions: adversarial difficulty against a real model, single-answer grading, abstention scored as a real outcome instead of an afterthought.
[O] Closing thoughts. Mine: the reframe from "is the model right" to "does the model know when it's not right" is the piece of this paper that'll outlast the leaderboard entirely.
[S] Mine: read every SimpleQA number with the three percent ground-truth error rate and the OpenAI-and-Anthropic-only model panel in mind, and treat the F-score specifically with real suspicion given its own documented guessing loophole.
[G] The paper's own bottom line: this measures one narrow, cheap, honest slice of factuality, whether a model gets short verifiable facts right and knows when it doesn't, and it says nothing yet about long, claim-dense answers.
[O] Soren, thank you for digging into this with us.
[G] Thanks for having me, it's a benchmark that's more interesting for what it admits it can't do than for the leaderboard itself.
[S] Full writeup, the results table, and the calibration plots are on the litsearch site if you want to see the numbers yourself. We'll see you next episode.
