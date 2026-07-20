---
slug: raghavendra-2026-agentic-rubrics
title: "Agentic Rubrics as Contextual Verifiers for SWE Agents"
description: "Scale AI teaches an agent to grade a coding patch with a repo-grounded checklist instead of running a single test, and the checklist wins anyway."
date: 2026-07-19
guest_name: "Julian"
guest_voice: "bm_lewis"
---
[S] Here's a sentence that should stop you. This paper's verifier never runs a single line of the patch it's grading.
[O] And it still beats the systems that do run tests. On SWE-Bench Verified, zero code execution, and it wins outright.
[S] Wins against a comparison set the authors chose, which we are absolutely getting into.
[O] Fair. But sit with the tension for a second. The whole argument is that reading code carefully can substitute for running it. That's a bigger claim than it sounds like.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a guest scholar take apart one paper from litsearch dot darvinyi dot com.
[S] Today's paper is "Agentic Rubrics as Contextual Verifiers for SWE Agents," out of Scale AI, by Raghavendra, Gunjal, Liu, and He, posted this January.
[O] And walking us through it is Julian, who's spent a lot of time inside this one. Julian, welcome.
[G] Thanks for having me. This is a paper about grading a coding agent's homework without running the code, which sounds backwards until you see the numbers.
[S] It's on the docket because verification has quietly become the bottleneck in agent training and agent evaluation, and this is a genuinely new answer to the question of how you verify without a sandbox.
[G] So set the stage. When a software engineering agent proposes a patch for a GitHub issue, you need to know whether it actually works. The dominant answer is execution: run the repository's unit tests, human-written or LLM-generated, and see what passes.
[O] Which sounds like the honest way to do it. Ground truth, no guessing.
[G] It is grounded, but it's expensive at scale. Every instance needs its own sandbox and its own environment setup, and that overhead is exactly the part that's hard to scale to a long tail of unfamiliar repositories. The paper also points to what it calls test toxicity, a sparse and brittle signal that doesn't distinguish well between two nearly-correct candidates.
[S] So the alternative is execution-free. Patch classifiers, similarity metrics, LLM judges just staring at the diff.
[G] Right, and those are cheap and easy to scale, but they're ungrounded. They latch onto surface cues, style and formatting, rather than functional correctness. The authors invoke what's called Verifier's Law: how easily you can train an agent on a task is bounded by how efficiently and reliably you can verify a candidate solution. If your verifier is too expensive or too shallow, that bounds everything downstream, in reinforcement learning and in test-time scaling alike.
[O] And rubrics are the middle path they're proposing.
[G] Rubrics already existed as a verification idea, breaking correctness into a checklist instead of one pass-fail bit. But a rubric written only from the issue text is under-specified. It doesn't know the repo's interfaces, its call sites, its conventions, so the criteria stay vague, something like "touches the right code path," and vague criteria are hard to grade consistently. The gap this paper is actually chasing is making that rubric grounded in the real codebase, without paying the cost of execution.
[S] Walk us through the pipeline, Julian.
[G] Two phases. In rubric generation, an expert agent, built on the SWE-Agent scaffold so it has file navigation, inspection, editing, and shell access, gets dropped into a sandboxed copy of the repository along with the pull request description. It explores: greps for the relevant functions, reads call sites, checks existing tests. Then it submits a structured file, rubrics dot yaml.
[O] So it's doing roughly what a human reviewer does when there's no test to lean on.
[G] That's the framing the authors use directly. It mirrors how a developer validates a fix when tests are missing: read the surrounding code, trace the contracts, reason about edge cases.
[S] And the second phase?
[G] In the inference phase, a candidate patch, produced completely separately by a different agent, gets scored against that rubric with zero code execution. Each rubric item is a pair: a short natural-language criterion, and an importance weight of one, two, or three, for nice-to-have, important, or must-have. Every item is filed under one of four axes.
[O] Which are?
[G] File Change, meaning the edit is minimal, local, and sufficient, not over-scoped. Spec Alignment, whether the patch actually satisfies what the issue asked for. Integrity, the no-cheating axis, so no weakening tests, no mass refactors, no dependency churn just to game the grader. And Runtime, whether the change implies correct execution behavior without obvious runtime issues. Each axis carries somewhere between three and eight items.
[S] And grading is just a sum?
[G] A weighted sum. An LLM judge, GPT-5 at low reasoning in the main experiments, assigns each item a binary score, zero or one, and the final verifier score is the weighted sum of satisfied items divided by the total weight. So you get a number between zero and one, used to rerank candidates.
[O] Here's the detail I like best in this whole paper. What the judge is not allowed to see.
[G] Grading only sees the problem statement, the rubric, and the final patch. It never sees the rollout trajectory, the agent's own reasoning or tool calls that produced the patch.
[S] Why hide that? More context usually helps a judge.
[G] Prior work, R2E-Gym, which this paper actually borrows its patch-classifier baseline recipe from, found that verifier decisions get unduly swayed by an agent's own thinking trace. A confident-sounding chain of reasoning can talk a judge into accepting a wrong patch. Withholding the trajectory keeps scoring uniform across every method being compared, and it closes off one obvious avenue for verifier hacking.
[O] That's a real design choice, not a footnote. It's the kind of thing that only shows up once you've tried hard to break your own system.
[S] Okay, numbers. What's the actual protocol?
[G] Best-of-K selection on the five hundred problems of SWE-Bench Verified. For each problem, a fixed generator model samples sixteen independent rollouts at temperature one. The paper uses two generators, Qwen3-32B and Qwen3-Coder-30B-A3B. The verifier scores all sixteen candidates, the top-scoring one gets submitted, and it counts as resolved only if it passes the hidden ground-truth tests.
[O] And there are reference points bracketing that.
[G] Oracle pass at sixteen, picking with the hidden tests as an upper bound, and random selection as a floor. On Qwen3-32B those land at 51.4 and 22.6 percent. On Qwen3-Coder, 65.6 and 39.6.
[S] So where does Agentic Rubrics land between those?
[G] 40.6 percent on Qwen3-32B, 54.2 on Qwen3-Coder. And in both settings it's the strongest verifier in the comparison. On Qwen3-32B that's plus 3.5 points over the best non-agentic baseline, a patch classifier at 37.1, and plus 4.6 over the best other agentic method, patch similarity, at 35.0. On Qwen3-Coder it's plus 4.0 over the best non-agentic baseline and plus 4.6 over the best other agentic one.
[O] And notably, executing actual generated tests didn't win.
[G] It didn't. Agentic Tests, where the agent writes its own problem-specific test file and executes it, scores 33.6 and 49.0, below both the rubric and the plain patch classifier. The authors' read is that generated tests are brittle: they have to compile and run cleanly in the sandbox, and if they don't discriminate well between near-correct candidates, the signal is weak even though it's grounded in real execution.
[S] Does the advantage hold as you scale K, or is this one lucky operating point?
[G] It holds. The scaling curve shows Agentic Rubrics staying above every baseline as K grows from one up through sixteen.
[O] What about whether the score actually tracks correctness, separate from the ranking task itself?
[G] They split rollouts by whether the patch passes the ground-truth tests, and the rubric-score distributions separate cleanly. Passing patches cluster around point eight five to one point oh. Failing ones spread lower, often around point four to point five. As a binary predictor of pass or fail, that's an ROC-AUC of point eight eight six and a PR-AUC of point seven two two.
[S] Which axis is doing the discriminating?
[G] Failing patches lose points mostly on File Change, Spec Alignment, and Runtime. They edit too much, miss part of the spec, or introduce a runtime issue. Integrity stays high across the board, which makes sense, a wrong patch usually isn't a devious patch, it's just an incomplete one. And when they score the actual human-written ground-truth patches from the original pull requests, those score above point eight on average across axes, for the frontier rubric-writers, with one interesting exception.
[O] Which is?
[G] File Change. The rubrics are sometimes more prescriptive about exactly which lines should change than the real human fix was. So a rubric can end up stricter about implementation location than a human reviewer would actually be.
[O] There's also a utility audit, right? Not just whether the score correlates, but whether a rubric is actually saying something useful.
[G] Yes. On a hand-checked subset of 100 instances, they label each rubric judgment as high or low utility. When the rubric and the tests agree, 78 percent of judgments are high-utility, mostly things like core semantics and A P I compatibility. The other 22 percent are noise, over-specification and low-signal criteria.
[S] And that sets up the more interesting case.
[G] Right, when a patch passes the tests but the rubric still rejects it, 54 percent of those rejections turn out to be flagging something real, most often a missed root cause or an edge case the available tests just don't exercise. The other 46 percent are the rubric being wrong in some way, over-specified, redundant, or actually misaligned with the reference fix.
[S] Before the fight, though, there's a set of ablations here that actually earn their keep. What happens if you swap out who's writing the rubric?
[G] That's the rubric-agent ablation. Holding the candidate-patch generator and the judge fixed, they swap in different models to write the rubric. Frontier coding models, Opus-4.5, Sonnet-4.5, Gemini-3-Pro, top out around 54 percent best-at-16. Open-weight coding models, Qwen3-Coder-30B-A3B and Meta's Code World Model, land closer to 45. A non-coding agent, Qwen3-32B itself, comes in around 43.
[O] What's actually driving that gap?
[G] Granularity, mostly. Sonnet-4.5 writes over 20 rubric items per instance on average, roughly double what Qwen3-32B or CWM produce. More criteria means finer-grained discrimination between two candidates that are both mostly right.
[S] Does the model actually need to touch the repository at all, or would the issue text alone get you most of the way there?
[G] They tested that directly. Strip repository access and generate rubrics from the issue text alone, and best-at-16 drops 4.0 points on Qwen3-32B rollouts, 1.4 points on Qwen3-Coder. The qualitative difference is what you'd expect: agentic rubrics name concrete files, classes, and methods, because the agent actually greps and views them, while non-agentic rubrics stay vague, something like "touches the right code path."
[O] So the grounding claim in the title actually earns its keep empirically.
[G] It does, on their own numbers. There's also a judge-sensitivity check, holding the rubric fixed and swapping the grading model's reasoning effort. GPT-5-mini gets 52.6. Low, medium, and high reasoning GPT-5 get 54.2, 54.3, and 55.0. Judge capability matters, but only a little, because the rubric items are designed to be atomic and self-contained, which doesn't demand much reasoning to grade correctly.
[S] That's actually a nice robustness result. The system doesn't collapse if you cheap out on the judge.
[G] There's a flakiness check that supports the same story. They regraded the same rubric items five separate times each and asked how often the score changed. Sonnet-4.5's rubrics were flaky only 2 percent of the time. Qwen3-32B's were flaky 9 percent of the time. Stronger rubric-writers produce more deterministic grading, not just higher scores.
[O] And that capability actually transfers, which I think is the single most important line in the paper. What did they train, exactly?
[G] They fine-tuned Qwen3-32B two different ways, using the same base model both times so the comparison stays clean. One version learned to write rubrics, using 2,000 rubric-writing trajectories from Sonnet-4.5. The other learned to be a straight patch classifier, following the R2E-Gym recipe, on about 4,696 labeled yes-or-no examples. The rubric-writing version wins clearly, beating both the fine-tuned classifier and both un-tuned base models.
[S] Which tells you what, exactly?
[G] That structured rubric generation is a stronger training objective than binary classification for this kind of verification, not just a stronger inference-time trick. The skill genuinely transfers into a much smaller, open-weight model.
[O] I want to make the strongest version of the "this is a real advance" case, and then Sam gets to come after it.
[S] Sam appreciates the warning.
[O] This solves an actual scaling problem. Execution needs a sandbox per repository, and that's exactly the cost that kills you as agents push toward long-tail, unfamiliar codebases, which is the paper's own stated motivation. A rubric, once written, needs no environment at all to grade against. And we already covered this, it isn't just a ranking trick, it distills into a smaller open model and beats a fine-tuned classifier doing the same job. That's a transferable skill, not a one-off frontier-model party trick.
[S] Here's my problem, and it's structural, not a nitpick. The paper's own framing is long-tail repositories, open-ended tasks, that's almost verbatim from the motivation paragraph. And then every number in the paper is on SWE-Bench Verified, five hundred instances from a dozen extremely popular, extremely well-maintained Python libraries. That's about the most heavily pretrained code that exists. An execution-free, "I understand this codebase" verifier is going to look its best exactly where the model already half-knows the repository. The actual hard case, an obscure repo the model has never seen, is never tested.
[G] That's a fair hit, and the paper doesn't dispute it. That gap is real and it's not addressed anywhere in the results.
[S] Second thing. The claim I find most seductive is that when a patch passes the tests but the rubric rejects it, 54 percent of those rejections are catching a real problem the tests missed. Who's checking that 54 percent?
[G] GPT-5, at medium reasoning, using the ground-truth tests and patch as its reference. No human confirms a single one of those labels.
[S] So the strongest evidence that rubrics see something tests can't is itself one large language model's opinion about another large language model's rubric. That's not nothing, but it's a much thinner claim than "rubrics catch real bugs."
[O] I'll grant that one. It needed at least a human spot check on a sample.
[S] And third, this cites R2E-Gym and borrows its patch-classifier recipe directly, but R2E-Gym's own headline result is that a hybrid of execution plus execution-free verification reaches around 51 percent, where either signal alone saturates in the low forties. Agentic Rubrics here is evaluated purely execution-free. The strongest published idea in the space isn't in the comparison table.
[G] I can push back on that one a little, because it's not quite the full picture. The appendix does run a hybrid, combining Agentic Rubrics with Agentic Tests in a simple aggregation, and reports it beats both signals in isolation. So the authors did test the hybrid idea, just not in the headline figure, and not benchmarked directly against R2E-Gym's own number under matched conditions.
[S] Okay, that's a real correction, I'll take it. Though putting the pure execution-free number in the main figure instead of the hybrid still feels like picking your best headline.
[O] What about cost, though? That's the thing I actually expected to sink the "lightweight" pitch.
[G] It's in the appendix rather than the main text, but there is a real accounting. Averaged over the dataset, the total cost to compute best-of-sixteen, generating the artifact plus grading all sixteen candidates, comes out to about twenty-nine cents per instance for rubrics, fifty-two cents for generated tests, and seventy-four cents for patch similarity. So among the agentic methods, rubrics are actually the cheapest, not just the strongest.
[S] Cheaper than the alternatives they tested, sure. It's still hundreds of frontier API calls standing in for what could, in a repo you already have set up, just be running the tests directly. That comparison, rubrics versus the floor cost of execution in an already-provisioned sandbox, isn't in the paper anywhere.
[G] That one holds up. The cost table compares agentic methods against each other, never against the actual floor of just running tests where the environment already exists.
[O] Step back, though, where does this actually matter if it holds up?
[G] Two places. As a test-time-scaling selector, it's a genuinely better best-of-K signal than what's been used before, and it's cheap enough to run at scale. The bigger one is upstream. The paper's framing is really about the reward signal for reinforcement learning with verifiable rewards, or RLVR. That use case, training a policy directly against rubric scores, is explicitly deferred to future work.
[S] Which matters, because reward hacking against a fixed rubric is a very different threat model than reward hacking against a rerank-only signal. Once a policy is being optimized against the rubric, it will find the weak criteria, the low-utility, over-specified ones this paper's own audit already flags at somewhere between 22 and 46 percent of judgments, and exploit them.
[G] The authors say as much themselves in the limitations section. Reward hacking and non-stationarity as the policy improves are named as open problems, not solved ones.
[O] And there's a broader evaluation angle too. Strip away the code, and this is an LLM-as-judge system, with all the calibration and contamination questions that come with any LLM-as-judge system, just applied to patches instead of prose.
[G] If there's one thing to remember, it's this: an agent-written, repository-grounded checklist is a better execution-free verifier than a patch classifier on the evidence the paper actually shows, and the skill to write that checklist distills into a much smaller model.
[O] My take: this is a real, well-instrumented step toward cheap verification, and the fact that it beats generated-test execution, not just other execution-free methods, is the number that should worry the "just run more tests" crowd.
[S] Mine: every headline result here is one frontier model grading another frontier model's rubric, on the most heavily pretrained benchmark in the field, with no long-tail test and no human check on the most interesting claim. Promising signal, not yet proof.
[O] There's a lot more in the paper than we had time for, the full ablation set, the worked examples of failing patches against their rubrics, the ground-truth patch alignment tables. Go read the full writeup on the litsearch site.
[S] Thanks for walking us through it, Julian.
[G] Thanks for having me.
