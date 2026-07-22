---
slug: zhou-2023-lima
title: "LIMA: Less Is More for Alignment"
description: "A 65B-parameter LLaMA fine-tuned on just 1,000 hand-curated examples — no RLHF — ties or beats GPT-4 in 43% of head-to-head comparisons, until a footnote reveals the test writers talked to the training writers first."
date: 2026-07-19
guest_name: "Nora"
guest_voice: "bf_emma"
---
[S] One thousand examples. That's it. No RLHF, no reward model, no hundred thousand human preference labels — just one thousand hand-picked question-and-answer pairs, and the resulting model ties or beats GPT-4 in forty-three percent of head-to-head comparisons.
[O] Which is either the most important alignment result of twenty twenty-three, or a very persuasive magic trick built on a suspiciously convenient test set.
[S] There's a footnote in this paper — an actual footnote — where the authors admit their training-prompt writers and their test-prompt writers talked to each other before the study. That's not a detail I'd bury on page three.
[O] It's on page three because the authors put it there themselves, unprompted. Let's dig into what "less is more" actually means here, and whether it survives the footnote.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the litsearch site. Today's paper is LIMA: Less Is More for Alignment, by Chunting Zhou, Pengfei Liu, and colleagues at Meta AI, Carnegie Mellon, U S C, and Tel Aviv University, posted in May of twenty twenty-three and later published at NeurIPS.
[S] It's on the docket because it's racked up over thirteen hundred citations by making a claim that, if true, changes how you'd spend your alignment budget: maybe you don't need millions of examples, you need one thousand really good ones.
[O] Joining us is Nora, who's studied this paper closely. Nora, welcome.
[G] Thanks for having me. This is one of those papers where the headline number is almost a distraction from the more interesting question underneath it.
[S] Set up the gap, Nora. What was the standard alignment recipe in early twenty twenty-three, before this paper?
[G] Two expensive stages stacked on top of pretraining. First, large-scale instruction tuning — fine-tuning on multi-million-example datasets like FLAN or the T-zero-style corpora. Second, reinforcement learning from human feedback, the InstructGPT and Constitutional AI recipe, built on millions of collected human interactions.
[G] Both stages are treated as load-bearing — the assumption is that a pretrained model needs a lot of additional teaching to become a good conversational assistant.
[O] And this paper says, not so fast.
[G] It asks a sharper question than "how do we make alignment better." It asks whether alignment needs to teach the model anything new at all, or whether a pretrained model already has the knowledge, and alignment is just teaching it which slice of its own output space to use when talking to a user. The paper names this the Superficial Alignment Hypothesis.
[S] Superficial is a loaded word to put in your own hypothesis.
[G] It's deliberately provocative, and it's also precise. The claim is that a model's knowledge and capabilities are learned almost entirely during pretraining, and alignment mainly teaches style and format, not new facts or new skills. If that's right, a small, carefully curated set of examples should be enough to unlock strong instruction-following, without RLHF and without a massive tuning set.
[O] That's a falsifiable claim, which I like. It's not "small data is good," it's a specific mechanistic story you can go test.
[S] So how do you test it? Walk us through what's actually in the one thousand examples.
[G] Seven hundred fifty come from online communities, filtered and curated, not scraped wholesale. Two hundred are Stack Exchange questions from the STEM exchanges, two hundred more from non-STEM exchanges — cooking, travel, English — sampled with a softened temperature across all one hundred seventy-nine exchanges so the topics don't collapse onto just programming.
[G] Two hundred come from wikiHow, "how to" articles used essentially verbatim as prompt and response pairs. One hundred fifty come from the WritingPrompts subreddit, creative pieces like poems and short stories. And fifty are drawn one-per-task from fifty different Super-Natural Instructions tasks, just to inject some format diversity.
[O] That's six hundred fifty. What's the rest?
[G] The remaining two hundred are written from scratch, by two groups of the paper's own authors. Group A wrote two hundred training prompts and fifty held-out development prompts, deliberately optimizing for prompt diversity and a single consistent helpful-assistant tone across every response.
[S] And the test set?
[G] Three hundred prompts: seventy self-contained questions pulled from r-slash-AskReddit, and two hundred thirty written by a second author group, Group B.
[O] Let's get to training, because the recipe itself is almost anticlimactic.
[G] That's the point being made. A pretrained sixty-five billion parameter LLaMA model, fine-tuned for fifteen epochs with plain supervised next-token loss — nothing exotic. AdamW optimizer, learning rate starting at one times ten to the minus five and decaying to one times ten to the minus six, batch size of thirty-two, context length of two thousand forty-eight tokens.
[G] The one genuinely unusual choice is the dropout schedule: residual dropout starting at zero at the bottom of the network and linearly rising to zero point three at the top layer, borrowed from the original InstructGPT recipe. And they add a dedicated end-of-turn token so the model has a clean signal for when a turn is over, without overloading the pretrained end-of-sequence token's existing meaning.
[O] No reward model, no preference pairs, none of the RLHF machinery.
[G] None of it. Just supervised fine-tuning on one thousand conversations, full stop. If this model performs well, the entire training stack that RLHF represents becomes, at minimum, optional for reaching that level of quality.
[S] That's a big "if." What counts as performing well here?
[G] The centerpiece is a pairwise human preference study. For each of the three hundred test prompts, crowd annotators see one LIMA response and one response from each of five baselines, and pick a winner or call a tie. The baselines are Alpaca sixty-five B — same base LLaMA, fine-tuned on fifty-two thousand examples — RLHF-trained DaVinci-zero-zero-three, Bard, Claude, and GPT-4, all sampled in April of twenty twenty-three.
[O] Give me the headline.
[G] Quoting the paper directly: responses from LIMA are either equivalent or strictly preferred to GPT-4 in forty-three percent of cases. Fifty-eight percent against Bard. Sixty-five percent against DaVinci-zero-zero-three.
[S] And against Alpaca, the apples-to-apples comparison, same base model?
[G] LIMA wins fifty-three percent outright and ties another twenty-one, so seventy-four percent win-or-tie against a model trained on fifty-two times more data. That's the strongest single result in the paper, because it holds the architecture and pretraining fixed and only varies the fine-tuning data.
[O] Fifty-two times less data and it still wins the majority of the time. That's the number that would make me rethink a training budget.
[S] Hold on — before we crown a winner, what does "equivalent" mean in that forty-three percent? Folding ties into the win column is a choice, not a neutral fact.
[G] Good catch, and worth being precise: against GPT-4 specifically, it's eighteen percent strict wins and twenty-five percent ties, adding to that forty-three. Read narrowly, LIMA outright beats GPT-4 on eighteen percent of prompts and loses on fifty-seven percent.
[S] So the sentence that made it into the abstract is the generous framing.
[O] It's also not wrong, though — it's the "win or tie" statistic, and it's clearly labeled as such.
[G] Both framings are honest. Only one made the headline. There's also a check on the human judgments: they repeat the whole comparison with GPT-4 as the annotator instead of crowd workers, and it reproduces the same ranking of baselines, with agreement clustering tightly — eighty-two percent crowd-to-crowd, seventy-eight percent crowd-versus-GPT-4.
[G] There's also an absolute evaluation, independent of any baseline: annotators grade fifty sampled LIMA responses as fail, pass, or excellent. Fifty percent are rated excellent, thirty-eight percent pass, and only twelve percent — six of fifty — fail to meet the prompt's requirements.
[S] What about prompts nothing like the training data? That's the real test of "did it generalize" versus "did it memorize a format."
[G] They check that directly. Of the original fifty graded examples, forty-three have some related training example in terms of format. So they add thirteen more deliberately out-of-distribution prompts to get twenty total, and on that set forty-five percent are still excellent and twenty percent fail — close enough to the in-distribution numbers that the authors read it as genuine generalization, not pattern-matching.
[S] And safety? A helpful-assistant model with just thirteen safety-flavored training examples out of one thousand makes me nervous.
[G] It should, a little. On thirty safety-adjacent test prompts, LIMA responds safely eighty percent of the time, including six of ten prompts with explicit malicious intent. This is not a safety-tuned model, and the paper doesn't claim otherwise.
[O] Now the ablations — this is the part I actually find more convincing than the leaderboard numbers.
[G] Rightly so, because these hold everything fixed except the one variable being tested, on a smaller seven-billion-parameter LLaMA. Diversity: train on two thousand diverse, quality-filtered Stack Exchange examples and score three point eight three on a six-point ChatGPT-graded helpfulness scale. Train on the same size of homogeneous wikiHow prompts and get three point four nine. Train on unfiltered, lower-quality Stack Exchange and get three point three three.
[S] So diversity and quality each independently move the number.
[G] Independently, and by a similar amount, roughly half a point on a six-point scale. Now the sharper ablation: hold the source fixed at Stack Exchange, and scale the training set exponentially, from two thousand examples up to thirty-two thousand — a sixteen-fold increase.
[O] And?
[G] Flat. Essentially no movement, hovering around three point eight throughout. Quantity alone buys almost nothing once quality and diversity are already controlled for.
[S] That's a genuinely strong result, because it's the one place in the paper where they're not just showing LIMA beats something, they're isolating the mechanism.
[O] Agreed — that ablation is doing more work for the paper's thesis than the GPT-4 comparison is.
[G] One more piece: multi-turn dialogue. The base one thousand examples contain zero multi-turn conversations, yet LIMA can hold one — fragile, but present. Across ten live conversations it fails within three turns in six of them. Add just thirty hand-authored dialogue chains — one thousand thirty examples total — and the excellent-response rate jumps from forty-five point two percent to seventy-six point one percent, with the failure rate dropping from fifteen failures per forty-two turns down to one failure per forty-six turns.
[S] Thirty examples buying that much improvement is a striking number on its own.
[O] Alright, let me make the strongest case for this paper. It's not just "small data works," it's a controlled demonstration that data quality and diversity dominate quantity, verified three separate ways: the Alpaca same-base-model comparison, the diversity-versus-quantity ablation, and the dialogue result from thirty examples. Believe those three results and you should be rethinking where alignment budget goes.
[S] Here's my deflationary case, and it starts with that footnote I flagged earlier. Section two point two, footnote one, in the authors' own words: "despite our efforts to prevent leakage, there was significant contact between the groups before the annotation process, which resulted in certain shared priors that can be observed in the data." Group A wrote the training and dev prompts. Group B wrote most of the test prompts. If those two groups of researchers were talking to each other before writing supposedly independent prompt sets, the test set isn't a clean sample of "what a real user would ask" — it's biased toward what a small circle of NLP researchers who know each other find worth asking.
[G] That's a fair and precise reading of the footnote, and it's genuinely unusual for a paper to surface it that plainly rather than bury it or omit it.
[O] Unusual in a way that should count in their favor, though — they didn't have to write that sentence.
[S] Disclosing a problem isn't the same as it not being a problem.
[G] Both things are true at once. It's honest disclosure, and it's also a real threat to the generalization claim, since the eval has an admitted train-test relationship, not full independence.
[S] Second issue, and this one the paper doesn't flag itself: nowhere in the methodology is there any mention of randomizing which response — LIMA's or the baseline's — is shown first versus second to annotators. That's not hypothetical. A separate paper already sitting in this same graph, on large language models as evaluators, shows GPT-4 and ChatGPT judges systematically favor whichever response lands in a particular position, strongly enough to flip which model "wins" a close pair.
[O] But the GPT-4 annotation arm reproduces the same ranking as the human arm — doesn't that corroborate the result rather than undercut it?
[G] It's suggestive, but it doesn't fully rule out the worry: if both arms share the same uncontrolled ordering — say, baseline responses consistently shown in the same slot — agreement between them is also exactly what you'd see if both were biased the same way.
[S] Which is precisely the mechanism the position-bias paper documents.
[O] Fine, I'll concede that one — the paper simply doesn't tell us whether position was controlled, and that's a real gap, not a nitpick.
[G] I'd score it that way too. It's not evidence the result is wrong, it's evidence the result is under-specified in a way that matters. There's a smaller third point worth a mention: the baselines are single-sample snapshots from April twenty twenty-three, so those exact win-rate numbers against GPT-4, Claude, and Bard were stale within the year, since none of those three systems are the same today.
[O] That one I'll grant without a fight, and it doesn't touch the Alpaca comparison, which is the paper's best evidence and doesn't depend on any external company's release schedule.
[G] Agreed, and that's the right place to land: the controlled, same-base-model comparisons — Alpaca, and the diversity and quantity ablations — are the load-bearing evidence for the Superficial Alignment Hypothesis. The showcase numbers against GPT-4, Claude, and Bard are the weaker, more perishable half of the paper, resting on a self-disclosed leakage footnote and an unaddressed position-bias question.
[O] To be fair to the authors, they say something similar themselves in the discussion — this was never framed as a robustness claim. They write plainly that LIMA is not as robust as product-grade models, and that an unlucky decoding sample or an adversarial prompt can produce a weak response.
[S] Which is the honest caveat missing from most "small data is all you need" summaries that quote this paper.
[G] They also flag the practical limitation that matters for anyone trying to replicate this: the mental effort of constructing genuinely high-quality, diverse examples by hand is significant and doesn't scale easily. One thousand excellent examples took real human curation labor, not a script.
[O] Zoom out — what's this paper's actual legacy, a couple years on?
[G] My own read, going a little beyond the paper itself, is that it reframed the conversation: "how good and how diverse is your curated set" became as legitimate a question as "how many examples do you have."
[S] It's a useful case study for evaluation practice too, not just alignment — a paper whose own footnotes and gaps matter more than most citations of it seem to realize, because the headline number gets quoted and the caveats get skipped.
[O] Which is exactly why an eval protocol needs the same scrutiny as the method it's judging. The hypothesis might still be right, but "right" and "proven beyond this eval's flaws" are different claims.
[G] Fair place to land. The mechanistic claim and the showcase eval are two different things, and they don't stand or fall together.
[G] If there's one line to take from the paper itself: pretraining teaches the knowledge, and a small, carefully curated set of examples can be enough to teach the format for using it — but "carefully curated" is doing enormous, labor-intensive work in that sentence.
[O] My takeaway: the Alpaca comparison and the quantity-versus-diversity ablation are real, controlled evidence that curation beats scale, and that's worth acting on regardless of how the GPT-4 leaderboard numbers age.
[S] Mine: read the forty-three percent number next to the footnote about shared priors, not instead of it. Go read the full writeup on the litsearch site for the figures and the exact numbers.
