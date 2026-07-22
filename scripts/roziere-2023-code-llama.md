---
slug: roziere-2023-code-llama
title: "Code Llama: Open Foundation Models for Code"
description: "Meta turns its general-purpose Llama 2 into a family of open code models that fill in the blanks around a cursor, hold a hundred-thousand-token context, and land within a point of GPT-4's own reported HumanEval score — then reveals, in its own results table, exactly how fragile that headline number is."
date: 2026-07-19
guest_name: "Marcus"
guest_voice: "am_fenrir"
---
[S] Somewhere in this paper's own results table, the bigger, more expensive instruction-tuned model scores worse than the medium-sized one. Not by a hair. Six points worse. And that's the version they shipped.
[O] Sure, but bury that for a second and look at the number right above it: sixty-seven point eight percent on HumanEval, from a fully open, commercially licensed model, essentially matching what OpenAI reported for GPT-4 that same year.
[S] "Matching" is doing a lot of work in that sentence, and we're going to unpack exactly how much.
[O] Fair. But step back — eight months earlier, the best open code models were trained from scratch and topped out well behind that. This family closed the gap by not starting from scratch at all.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the litsearch site. Today it's Code Llama, Open Foundation Models for Code, from Baptiste Rozière, Jonas Gehring, and colleagues at Meta AI, posted in August of twenty twenty-three.
[S] Joining us is Marcus, who's spent real time with this paper and the models it produced. Marcus, welcome.
[G] Glad to be here. This is worth taking seriously less for any single benchmark number and more for the recipe — how you turn a general language model into a specialized code model without starting over.
[O] And that recipe is exactly why it's on the docket. Within weeks it became the base checkpoint under a wave of open coding tools, including the first serious attempt at SWE-bench.
[S] So set the scene. Where does code generation stand going into mid twenty twenty-three?
[G] Split down the middle. Closed models — Codex, GPT-3.5, GPT-4 — strong, but not inspectable, not fine-tunable, and off-limits commercially without going through someone else's API. Open models like AlphaCode, InCoder, and StarCoder, trained on code from random initialization.
[O] What's wrong with training from scratch on code?
[G] Nothing exactly, but it's expensive in a specific way — every token of compute goes toward learning code and language at once, from nothing. Llama 2 had already spent two trillion tokens learning general language. Code Llama's bet is that specializing that model is a better use of a fixed compute budget than starting a code model over from zero.
[S] Is that bet just asserted, or do they actually test it?
[G] Tested directly. The paper compares initializing from Llama 2 against training the identical architecture on code only, same compute budget both ways. Llama 2 wins, by enough that Llama 2 seventy billion, with zero code specialization, performs roughly on par with Code Llama seven billion on Python benchmarks.
[O] That's a striking equivalence. A ten-times-smaller model, specialized, matching a giant generalist.
[S] It's also the paper's strongest argument for the whole approach, and it's worth saying plainly that it's Meta's own ablation, not an independent check.
[G] Fair, but it's controlled and apples-to-apples inside the paper, which is more than most cross-paper comparisons can claim.
[O] Beyond the starting point, what capabilities were actually missing?
[G] Three specific gaps. Autoregressive models can only continue text forward, but an editor needs to fill a hole with code on both sides of the cursor — that's infilling. Llama 2 topped out at four thousand ninety-six tokens of context, nowhere near enough to reason about a whole repository. And instruction-following that's actually useful for programming and doesn't produce unsafe code.
[O] Walk us through the pipeline, then. It's not one training run.
[G] Four stages, stacked. Start from Llama 2 at seven billion, thirteen billion, thirty-four billion, and seventy billion parameters. Stage one: continued training on five hundred billion tokens of a code-heavy mix — eighty-five percent code, eight percent natural language about code, seven percent general text, to keep language ability from decaying. The seventy-billion version saw twice that, one trillion tokens, since it was trained months later on a bigger budget.
[S] And that code-training stage is where infilling gets baked in, not bolted on afterward.
[G] Right, for the seven-billion, thirteen-billion, and seventy-billion sizes. The thirty-four-billion model skipped infilling training entirely — a deliberate compute trade-off at the time.
[O] How does infilling actually work, mechanically?
[G] Take a document, split it at random character positions into a prefix, a middle, and a suffix. Move the middle to the end and train the model to predict the reordered sequence autoregressively, so it learns to fill the middle given both sides. Half the examples order it prefix-suffix-middle, half suffix-prefix-middle, and four new special tokens mark the boundaries. No architecture change, just a data transformation applied about ninety percent of the time.
[S] So the model doesn't know it's "filling a hole." It's predicting the next token in a rearranged sequence.
[G] Exactly, and that's what makes it cheap. No new objective, no separate model.
[O] Then there's a Python-only branch.
[G] Right, stage two forks off: an extra one hundred billion tokens of a Python-heavy mix, on top of the five-hundred-billion-token checkpoint, to study single-language specialization.
[S] Let's get to long context, because "sixteen thousand training tokens generalizing to one hundred thousand" needs the mechanism spelled out.
[G] The lever is the rotary position embedding, RoPE, that Llama 2 already uses. Instead of interpolating the position frequencies, Code Llama simply increases the base period they're derived from, from ten thousand up to one million, then fine-tunes on sixteen-thousand-token sequences for twenty billion tokens.
[O] What does raising that base period actually buy you?
[G] It reduces the model's bias toward attending to nearby tokens, so it extrapolates well past its sixteen-thousand-token training length instead of falling apart, which is what normally happens once a transformer runs past its training length.
[S] "Normally falls apart" is worth dwelling on. That's the actual problem this stage solves.
[G] Right, most transformers see a sharp jump in perplexity the moment you push past their training context. This recipe avoids that cliff, and it became something like the standard playbook other groups copied afterward.
[O] Last stage, instruction tuning — the one that avoids paying for human-labeled code data.
[G] Three ingredients. First, Meta's own proprietary instruction data from Llama 2 — supervised fine-tuning plus millions of rejection-sampling examples scored by a reward model — where most of the safety behavior comes from. Second, a self-instruct set with no human labelers: prompt Llama 2 seventy billion for around sixty-two thousand interview-style questions, dedupe to about fifty-two thousand, then have Code Llama seven billion generate unit tests and ten candidate solutions per question, keeping the first solution that actually passes its own tests.
[S] So the model is grading its own homework.
[G] With one safeguard — the tests have to execute and pass, so it's a program running, not just the model's opinion. That process keeps around fourteen thousand question, test, and solution triplets. Third ingredient: a small rehearsal slice, six percent code and two percent natural language, to stop general ability from regressing.
[O] Self-instruct plus execution feedback instead of a small army of annotators. Real cost saving, if it works.
[S] "If it works" is exactly what the results need to answer.
[G] Headline first. Code Llama-Instruct seventy billion reaches sixty-seven point eight percent pass at one on HumanEval, greedy decoding, zero-shot. Code Llama-Python seventy billion reaches sixty-five point six percent on MBPP, three-shot.
[O] And the closed-model comparison people quote is GPT-4 at sixty-seven percent on HumanEval, as OpenAI reported it.
[G] Right, "essentially matching." We'll come back to what that comparison actually means.
[S] Before the seventy-billion headline, what does specialization buy at each step, in isolation?
[G] Two effects. Specialization: the extra one hundred billion Python tokens add somewhere between four point three and eight point three points of HumanEval pass at one, and one point two to six point four points of MBPP, depending on size. Scale: on MBPP pass at one, seven billion to thirteen adds five point six points, thirteen to thirty-four adds about eight, thirty-four to seventy adds about seven more.
[O] Give me the number that actually proves the "specialize, don't restart" thesis, not just the ablation.
[G] Code Llama-Python seven billion scores thirty-eight point four percent on HumanEval and forty-seven point six on MBPP. Llama 2 seventy billion, ten times larger and never specialized, scores thirty point five and forty-five point four. The one-tenth-the-size specialized model wins both.
[S] What about harder problems, not just standard function completion?
[G] APPS is the stress test — competitive-programming problems, much more prompt-dependent. Code Llama thirty-four billion, sampling one hundred candidates per problem, hits fifty-six point three percent introductory, twenty-four point three interview-level, fifteen point four competition-level. Strong on easier problems, degrading fast as they get genuinely hard.
[O] And beyond Python, the abstract claims every model here beats every other open model on MultiPL-E.
[G] That holds up. Across seven languages — Python, C++, Java, PHP, TypeScript, C#, Bash — Code Llama seventy billion averages around forty-five percent pass at one, ahead of StarCoder, CodeGen, everything else tested. Bash is the weakest language in every model's row, including this one.
[S] The part I actually want scrutinized is long context. Does one hundred thousand tokens really work, or does it just not immediately break?
[G] It works, by the paper's own perplexity numbers. On large source files, perplexity keeps decreasing past the sixteen-thousand-token fine-tuning length, only ticking up slightly after one hundred thousand — no blow-up. On a synthetic key-retrieval task around sixteen thousand tokens, the bigger models stay near one hundred percent accuracy regardless of where the key sits. The seven-billion model is the exception, dropping to around fifty-four percent when the key sits at the very start.
[O] So long context is basically free for the big models, bounded cost for the small one.
[G] Mostly free, one honest caveat: long-context fine-tuning costs a little on short sequences, and the paper reports that rather than hiding it.
[S] And the safety numbers?
[G] For the thirty-four-billion model, TruthfulQA rises from thirty-four point six four to forty-seven point three seven, and ToxiGen toxicity drops from seventeen point six two percent to essentially zero — the least toxic model in their table. Meta also ran red-teaming with twenty-five employees across offensive-security, malware, and responsible-AI exercises, and found only limited evidence of false refusals.
[O] Strongest optimist case, before the deflationary one gets its turn. This is a fully open, commercially licensed family that closes the gap to GPT-4, invents a long-context recipe the field copied wholesale, and does it with a self-supervised pipeline that needed almost no human-labeled code. Eight months earlier, nothing open came close.
[S] Now the deflationary case. Start with "matches GPT-4." That sixty-seven point eight percent is Instruct seventy billion, greedy, pass at one — a single best-case cell in a messier table. One row up: thirty-four-billion Instruct scores forty-one point five percent, worse than the thirteen-billion Instruct's forty-two point seven, and far worse than the thirty-four-billion base model's forty-eight point eight. The paper never explains why that size specifically regresses.
[G] Both readings are grounded in the same table. The scaling and specialization ablations really do show a clean trend, and that part of the optimist case is solid. But the skeptic's right that the dip is real and unexplained, a reminder that one greedy pass-at-one run carries variance the paper never bounds.
[O] Fine, I'll take that dent. The overall trajectory across sizes is still clearly upward.
[S] In aggregate, sure. My bigger issue is the GPT-4 comparison itself — sixty-seven percent, quoted from OpenAI's own report, not re-run under Code Llama's harness. GPT-4's MBPP number is simply absent.
[G] Accurate, and it's a real methodological gap, not a nitpick. "Matches GPT-4" really means "matches a number someone else measured," on the one benchmark where both numbers exist.
[O] Is contamination a live concern? HumanEval and MBPP were both public well before this paper.
[G] The paper runs no contamination check at all, no memorization scan. Training data is scraped heavily from GitHub, and both benchmarks had been public for years — that's a real gap. The field later built LiveCodeBench and MLE-bench partly to answer exactly this with continuously refreshed problems.
[S] There's also the model that got the headline result and vanished. "Unnatural" Code Llama thirty-four billion, trained on a GPT-4-distilled instruction set, scores sixty-two point two percent on HumanEval, the best thirty-four-billion result in the paper. Never released.
[G] A teaser more than a shipped capability, and the paper is upfront about that. It supports the underlying thesis, but you can't build on a checkpoint you don't have.
[O] Where does "does this actually matter for real coding" land?
[G] That's the sharpest limitation, and it's about scope, not numbers — HumanEval and MBPP measure isolated function-level synthesis, not repository-scale engineering. The clearest evidence came two months later, when SWE-bench fine-tuned SWE-Llama from Code Llama and pointed it at real GitHub issues. It resolved zero point seven zero percent of them, still under one and a half percent even on the easier SWE-bench Lite split.
[O] Brutal gap between the benchmark story and the repository-scale story.
[S] That's the whole debate. Sixty-seven point eight percent on a function-level benchmark and zero point seven percent on real GitHub issues are both true statements about the same paper's models.
[G] Not a contradiction, a scope mismatch. The benchmarks were never designed to measure repository-level engineering, and the paper never claims they do. The long-context work was aimed at exactly that gap — it just hadn't been tested against it yet.
[O] So what actually changes, if you take this paper at face value?
[G] The specialize-from-a-strong-generalist recipe became close to a default playbook, well beyond code. The RoPE base-period trick got copied across labs building models that had nothing to do with programming.
[S] For evaluation practice, three lessons straight from what we covered. Don't quote a single greedy pass-at-one cell without checking whether it's monotonic across the table. Don't treat a number pulled from another paper's report as equivalent to one measured on your own harness. And function-level accuracy isn't repository-level competence — they need separate benchmarks, which is exactly what SWE-bench supplied two months later.
[G] Add contamination to that list. This paper had the means to run a memorization check and didn't, on two benchmarks already years old and fully public.
[O] Even with all three caveats, I don't think it undersells what shipped: infilling, real long context, safety-tuned instruction following, in a family anyone could download and build a commercial product on. That combination didn't exist in the open ecosystem before this.
[G] If I leave you with one line: Code Llama showed that specializing a strong general model beats training a code model from scratch, and shipped that proof as an open, commercially usable family that became the base for the next wave of coding agents.
[O] My takeaway is the long-context recipe. A hundred-times increase in RoPE's base period, fine-tuned on just sixteen thousand tokens, and it holds all the way out to one hundred thousand. An unusually cheap fix for a genuinely hard problem.
[S] Mine is the caveat that outlived the paper. Sixty-seven point eight percent on HumanEval and zero point seven percent resolving real GitHub issues both came from checkpoints in this same family. Know which number you're being sold before you let a benchmark score stand in for real-world coding competence.
[O] There's a lot more in the paper than we could fit here — the full ablation tables, the qualitative examples, every language in MultiPL-E. The writeup is up on the litsearch site if you want to go deeper.
[S] Thanks for walking through this with us, Marcus.
[G] Thanks for having me.
