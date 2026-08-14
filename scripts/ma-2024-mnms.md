---
slug: ma-2024-mnms
title: "m&m's: A Benchmark to Evaluate Tool-Use for multi-step multi-modal Tasks"
description: "Thirty-three tools that actually run, on real images and real audio. The paper's recommendation is multi-step, JSON, with feedback — and its own appendix shows feedback costing GPT-4 six points of execution accuracy while buying a weak model thirty-three points of pass rate."
date: 2026-07-27
guest_name: "Rosalind"
guest_voice: "bf_emma"
---
[S] The paper's recommendation is one sentence: multi-step planning, in JSON, with feedback. Now open its own appendix, Table 17. GPT-4, multi-step, JSON, parsing feedback only: seventy percent execution accuracy. Same model, same format, same strategy, with the full verification and execution feedback stack: sixty-four point one two.
[O] So on the one metric that asks whether the plan actually did the thing the user wanted, feedback cost the best model six points. And feedback is in the headline recommendation.
[G] Both of those sentences are true, and neither is the whole story. That table has eighty-five examples in it, and the seventy carries an error bar of plus or minus six point four seven. But you have found the real seam in this paper, and it is not the one people normally pick at.
[S] Go on.
[G] All three of the headline recommendations are model-dependent. The paper states all three of them as universal.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Today it is m and m's, a benchmark to evaluate tool use for multi-step multi-modal tasks.
[S] Zixian Ma, Weikai Huang, Jieyu Zhang, Tanmay Gupta, and Ranjay Krishna. University of Washington and the Allen Institute for AI. On arXiv in March twenty twenty four, published at ECCV twenty twenty four.
[O] Our guest is Rosalind, who knows this benchmark and the tool-use evaluation literature around it closely. Rosalind, why is this one on the docket?
[G] Because of one design decision that sounds like table stakes and was not. Every tool in this benchmark actually runs. Thirty-three of them, on real photographs and real audio files, with real network calls to real public APIs. In early twenty twenty four that was close to unique, and it is what lets the paper ask a question nobody else could ask.
[S] Which question?
[G] When a tool-using agent fails, did it pick the wrong tools, or did it pick the right tools and one of them broke? Every benchmark before this one either could not tell you, or could tell you only because it never ran anything at all.
[O] Set up the prior work properly, because I think that framing does a lot of work.
[G] There are two families. The first is the classic downstream task suites: HotpotQA, WebShop, GQA, RefCOCO, NLVR. You give the agent a question, you score the final answer. None of them contains a ground-truth plan. So a wrong answer fuses two completely different failures into one number, and you cannot separate them after the fact.
[S] And the second family was supposed to fix that.
[G] It was. ToolEmu, TaskBench, GAIA. These do provide ground-truth plans. But they cannot execute them. TaskBench assumes a list of tools is available to plan over without providing any implementation, and it instantiates its queries with placeholder filenames like example dot png, which do not exist on disk. ToolEmu uses a language model to emulate tool execution instead of shipping the tools.
[O] An emulated sandbox, and plans over a toolset that is a list of names.
[G] Right. And the paper's argument is that this makes the study it wants to run impossible rather than merely difficult. If you want to know whether execution feedback helps a planner, you need executions. Not a language model's guess at what an execution would have returned.
[S] I want to be careful with their comparison table, because I have seen this paper described sloppily. Table 1 on page three compares five benchmarks. What does it actually say?
[G] Five columns: ToolBench, ToolEmu, TaskBench, MetaTool, and m and m's. On the row asking whether all tools are executable, the marks are check, cross, cross, check, check. So ToolBench is a check on that row. Its tools do run. Its problem is a different row.
[S] That is the correction I wanted, because people cite that table as though ToolBench is the non-executable one.
[G] It is not. ToolBench's cross is on the row asking whether queries are verified by human. On real multi-modal inputs, only m and m's has a check, and TaskBench's cross carries a footnote saying its queries contain textual placeholders for other modalities. So the claim m and m's is entitled to is narrow and specific: it is the only one of the five that has both real multi-modal query inputs and a fully executable toolset.
[O] And the price of that is scale, which the same table makes obvious.
[G] Brutally so. ToolBench has three thousand four hundred fifty-one unique tools and a hundred and twenty-six thousand queries. TaskBench, a hundred and three tools and seventeen thousand queries. MetaTool, three hundred ninety and twenty thousand. m and m's has thirty-three tools and about fifteen hundred queries. It is the smallest benchmark on that table by a wide margin, on both axes.
[S] So it buys realism with two orders of magnitude of coverage. Worth holding onto for the rest of this conversation.
[O] Take me through how the dataset gets built, because the generation pipeline is where I think the actual craft is.
[G] Five stages. First, they build a directed graph over all thirty-three tools, where an edge exists only when the output type of the source tool is a valid input type for the target tool. Image classification connects to Wikipedia simple search because image classification emits a text label and Wikipedia simple search consumes one. Then they sample subgraphs to get tool sequences with valid dependencies.
[O] So the plan skeletons are type-correct by construction.
[G] By construction. Second stage, they instantiate with real inputs. They pull examples from the validation sets of eleven existing datasets, including ImageNet, SQuAD, Visual Genome, MagicBrush, and LibriSpeech, and they sample an input matching the input type of the first tool in the sequence. If the sequence starts with image classification, you get an actual ImageNet photograph.
[S] Third stage is where GPT-4 enters, and I want that flagged clearly.
[G] Flag it. Third stage, they prompt GPT-4 with the tool sequence and the input to write realistic user queries. Five input examples sampled per sequence, two queries per sequence, and the prompt explicitly forbids the query from naming the tools involved. So the model has to phrase it as a user would.
[O] And the fourth stage is the one I think is genuinely smart.
[G] It is the best decision in the pipeline. The ground-truth plan is not generated by a language model. It is generated by a rule-based program. They populate each node's id and tool name from the sampled sequence, fill argument names from a predefined metadata document, fill the first tool's argument values from the sampled input, and chain later arguments with a node-id-dot-key notation. Then the same JSON is mechanically transformed into equivalent Python code.
[S] Why does that matter so much?
[G] Because it eliminates hallucinated ground truth. The paper says this explicitly as a contrast with TaskBench, which uses GPT-4 to produce its plans. If your labels come from a model, your labels have that model's error rate baked in, and you will never see it. Here the labels come from a program walking a type-checked graph.
[O] There is one exception, though.
[G] There is, and it is worth stating precisely. GPT-4 is used to rewrite the free-text argument values for two tools, text generation and image generation, so they match the query better. Their example is turning the argument value "a shark" into "a child-friendly book cover image of a shark". So the structure of every gold plan is rule-based. Some free-text argument values inside it are not.
[S] Fifth stage is human verification, and this is where I want to slow down. What are the actual numbers?
[G] Three expert annotators, described as undergraduate and Ph.D. students in computer science, rate every one of the four thousand four hundred twenty-seven generated query-plan pairs, zero or one, where one means the plan resolves the query perfectly. Fifteen hundred sixty-five get a one from all three.
[S] Unanimity across three raters. What was the agreement?
[G] The three pairwise agreement rates are seventy-four point nine five, eighty-one point four three, and seventy point eight eight percent. The average is seventy-five point seven five, with a standard deviation of four point three four.
[S] That is my first real objection. Seventy-six percent raw pairwise agreement on a binary judgment. Coin-flipping raters agree fifty percent of the time. That is not a wide margin over chance for a task the paper describes as verifying whether a plan resolves a query perfectly.
[G] It is a fair objection and I will split it. On the set they keep, the unanimity requirement works in their favor. Requiring all three to say yes makes the retained set high-precision, and that is the set the evaluation runs on. What the agreement rate tells you is something different: the judgment itself is genuinely ambiguous. And it tells you nothing at all about the two thousand eight hundred sixty-two examples that were discarded, because we never learn whether those were bad plans or just contested ones.
[O] But the discarded ones are not in the benchmark, so does it matter?
[G] It matters for what the benchmark represents. If ambiguous-but-valid plans were filtered out systematically, the survivors are the unambiguous cases, and the benchmark is easier and narrower than the raw pipeline suggests. The paper does not investigate that.
[S] And then there is more filtering after the human verification. Walk the chain, because I have seen these numbers quoted wrong.
[G] The chain is precise and it matters. Start at fifteen hundred sixty-five human-verified examples. Filter one: they manually remove three hundred forty-nine examples with poor execution results, the case where an intermediate tool returns a wrong or empty output. Their example is question answering sitting second in the sequence and emitting an empty string. Filter two: they remove three hundred thirty-four examples for over-representing image generation. Fifteen sixty-five minus three forty-nine minus three thirty-four is eight hundred eighty-two.
[O] Why was image generation such a problem?
[G] Because in the raw distribution, image generation appears nine hundred eighteen times out of fifteen sixty-five. It is more than half the verified set on its own. So they drop plans that use it and have more than four unique queries attached, to pull the distribution back toward the rarer tools without destroying plan diversity.
[S] So the final evaluation set is eight hundred eighty-two examples.
[G] Eight hundred eighty-two. Seventy of them need a single tool, a hundred fifty-nine need two, and six hundred fifty-three need three. Three hundred seventeen distinct tool graphs, averaging two point seven eight unique queries per graph. And the thirty-three tools break down as thirteen multi-modal machine learning models from HuggingFace, eleven image-processing modules borrowed from VisProg, and nine free public APIs from RapidAPI.
[O] Free is doing real work in that sentence, incidentally. A benchmark that requires paid API keys is a benchmark nobody reruns.
[S] Now the agent. What is actually being evaluated?
[G] A modular planning system built on Microsoft's AutoGen, with four components: the planning language model, a parser, a rule-based verifier, and an executor. Those last three are the three feedback types. Parsing feedback is the parser failing to turn the model's text into JSON or code. Verification feedback is a rule-based verifier checking three things: does the predicted tool exist in the tool list, does it form a valid connection with the previous tool, and do the argument names match the metadata document. Execution feedback is the executor actually calling the functions and returning the output or the error.
[O] And three metrics.
[G] Tool F one is the F one score over the set of predicted tool names versus the gold set. Argument-name F one, which they call argname F one, does the same over tool-name-and-argument-name tuples. Pass rate is the percentage of plans that execute without any error. And the paper is explicit and honest about that last one: it measures executability, not correctness.
[S] I want that on the record, because a lot of agent papers quietly treat "it ran" as "it worked". This one says in the metrics section that pass rate does not measure correctness.
[G] It does, and it earns credit for it.
[O] Alright. Results. And I understand there is a roster problem.
[G] There is, and it is the single easiest thing to get wrong about this paper. The abstract says ten popular LLMs, and the introduction breaks that down as five open-source, two code models, and three proprietary. But no single experiment runs the full roster. Each comparison has its own model subset.
[S] Give me the subsets.
[G] The planning strategy comparison, Figure 5, is eight models: Llama 2 at 7B, 13B, and 70B, Llama 3 70B, Mixtral, Gemini Pro, GPT-3.5, and GPT-4. No CodeLlama. The plan format comparison, Figure 7, is also eight models, but the two CodeLlama models, 34B and 70B, swap in for Llama 2 70B and Llama 3 70B. The feedback table, Table 3, has nine rows, because GPT-4o was added in the camera-ready.
[O] And the appendix?
[G] The appendix tables run six models. Llama 2 at 7B and 13B, Mixtral, Gemini Pro, GPT-3.5, and GPT-4. So if you ever see somebody say "the paper evaluated ten models on X", ask which X. The honest phrasing is that eleven distinct checkpoints appear somewhere in the paper and no experiment uses more than nine.
[S] And GPT-4o, specifically?
[G] Appears exactly once in the entire paper. One row of Table 3. It is not in Figure 5, it is not in Figure 7, it is in none of the appendix tables. So the strategy and format conclusions rest entirely on early twenty twenty four checkpoints.
[O] Fine. Finding one.
[G] Multi-step planning beats step-by-step on tool F one for all eight models in Figure 5. Every one, regardless of size. The gap narrows for the more capable models, Llama 3 70B and GPT-4. GPT-3.5 shows the largest jump at twenty-one point eight points. On pass rate, multi-step also wins for every model except Gemini Pro, which does slightly better step-by-step.
[S] Why does step-by-step lose? Because on priors it should be better. You get to see what happened before committing to the next move.
[G] The paper's qualitative analysis has a specific and slightly comic answer. Under step-by-step, models tend to output "Terminate" as soon as they receive positive feedback from the environment. Verification succeeded, execution succeeded, and the model concludes it is finished, regardless of whether the user's actual request has been resolved. So they predict fewer steps than required and simply drop the remaining tools.
[O] That is a prompting failure more than a planning failure.
[G] It may well be. And the paper concedes an adjacent point in its limitations: it does not study prompt style as a design axis. It uses direct prompting and ReACT-style prompting and excludes anything more elaborate, like tree-of-thoughts. So the step-by-step result is a result about this step-by-step harness.
[O] Here is the part I think gets undersold, though. Multi-step is not just more accurate. It is dramatically cheaper. Table 15 and Table 16.
[G] It is, and you are right that it is undersold. For GPT-4, multi-step planning averages between one point zero zero and one point zero seven conversation turns depending on the feedback setting. Step-by-step averages between three point two two and three point five nine. On input tokens, GPT-4 multi-step sits at about two thousand one hundred eighty-four to two thousand three hundred fifty-five. Step-by-step runs about eight thousand to nine thousand six hundred.
[O] So roughly a fourfold token cost for a strictly worse result. That is a rare thing in this literature. Usually the better option is the expensive one.
[S] I will grant that one cleanly. If both the accuracy and the cost point the same direction, the recommendation is easy.
[G] It is the most robust finding in the paper.
[O] Finding two. Feedback.
[G] Table 3, and the structure of that table needs stating or the numbers are meaningless. The baseline column, P, is parsing feedback only, under multi-step planning with JSON. Every other column is a delta against it: PV adds verification, PE adds execution, PVE adds both.
[S] So the numbers with signs are changes, not scores.
[G] Correct, and people misread that constantly. The pass-rate gains are large and they are concentrated in the weak models. Llama 2 7B starts at twenty-eight point two three pass rate and gains eighteen point one four under verification feedback. Llama 2 13B starts at thirty-eight point one zero and gains thirty-two point nine nine under execution feedback.
[O] Those are enormous.
[G] They are. Argname F one improves more modestly, roughly one to four points for most models, with one standout: Llama 2 70B starts at fifty-two point four nine and gains twelve point eight seven under verification feedback.
[S] And the cost.
[G] Tool F one goes down. Llama 2 13B's tool F one is forty-two point two seven at baseline and drops four point five seven under the combined feedback. GPT-3.5's tool F one row reads eighty point five two at baseline, then minus zero point six five, minus two point eight zero, and minus two point five six. So its execution-feedback number lands at seventy-seven point seven two.
[O] Why would telling a model about an error make its tool selection worse?
[G] The paper's explanation is over-correction. Models change correct tools to wrong ones, or remove them entirely, even though the feedback instructs them to fix only the erroneous part. And they add a mechanistic detail I find persuasive: verification feedback is more helpful than execution feedback for argument names, because the rule-based verifier pinpoints exactly where the error is, whereas the executor returns the raw error message, which can be vague and obscure and actively confuses the model into wrong fixes.
[S] So a well-designed error message beats a real one. That is a genuinely useful engineering lesson.
[G] It is one of the more transferable findings here.
[S] Now, I read Table 3 closely, and there is something in it I would like you to explain.
[G] I suspect I know what you found.
[S] The Mixtral row and the Gemini Pro row. Their baseline values differ, sixty-six point seven nine versus sixty-nine point three eight on tool F one, seventy-two point five two versus seventy-three point three seven on argname F one. But all six delta values are byte-identical between the two rows. One point one eight, minus zero point one one, minus zero point zero four on tool F one. Two point zero zero, one point eight nine, two point seven two on argname F one. Identical.
[G] You are reading it correctly, and I checked it against the published table rather than a text extraction. The deltas are identical across those two rows for tool F one and argname F one, while the base values differ and, notably, the pass-rate deltas differ. Ten point three two versus thirteen point two seven, and so on.
[O] So what is it?
[G] Almost certainly a transcription error in the camera-ready. Two different models producing identical deltas to two decimal places across six independent cells, while their pass-rate deltas diverge normally, is not something that happens by chance. The paper does not flag it and does not comment on it.
[S] Does it change any conclusion?
[G] No, and I want to be fair about that. The qualitative claim, that feedback slightly hurts tool selection and substantially helps invocation, survives regardless of which of those two rows is the erroneous copy. But it is the kind of thing that should have been caught, and it means one of those two rows should not be quoted as a measured value.
[O] Finding three. Format.
[G] JSON versus code. On tool F one they are comparable, within three points, for every model in Figure 7 except Llama 2 7B. On pass rate, JSON is markedly higher for every model shown. The failure mode is specific: in code generation, models fail to correctly access the output of a previous tool when chaining. The same error occurs in JSON, but less often, because JSON's structure is more rigid.
[S] And the paper notes the gap is smaller for the code models.
[G] It does, in the introduction. CodeLlama 34B and 70B close some of the executability gap, which is the result you would expect and a small sanity check on the whole comparison.
[O] So the composite recommendation is multi-step, JSON, with feedback.
[G] That is the paper's summary sentence, yes.
[S] Then let me make the deflationary case, because I think the headline metrics are systematically kinder than the paper's own appendix.
[O] Make it.
[S] Tool F one is a set F one. Set. It does not require the tools to be in the right order, and it does not require the arguments to be bound correctly. GPT-4 scores eighty-eight point four six on it. Now go to Table 9 in the appendix, plan accuracy, which asks whether the entire predicted plan matches the gold plan. GPT-4's best number there is seventy-one point four three, multi-step with execution feedback. That is a seventeen-point gap between "mostly chose the right tools" and "produced the correct plan".
[O] Seventeen points is real but it is not a collapse.
[S] For GPT-4 it is not. For everything else it is. Llama 2 13B has a tool F one of forty-two point two seven in Table 3. Its exact multi-step plan accuracy in Table 9 never exceeds thirteen point eight three. That is not a gap, that is a different picture of the model.
[G] Both of those readings are correct and I will add the number that makes it starker. Table 11 is the strictest variant, requiring tool names, argument names, and argument values to all match. Under exact matching, GPT-4's multi-step numbers top out at fifteen point five three. Under entailment scoring, where a predicted text value counts if it entails the label, GPT-4 tops out at forty-three point two zero.
[S] Fifteen. From an eighty-eight point four six headline.
[G] Yes. Though the paper itself cautions readers about argument-value metrics, and I think that caution is legitimate. Exact string matching on a free-text image-generation prompt is not measuring planning competence, it is measuring whether the model guessed the same adjective. The entailment column is the more meaningful one, and the paper says so.
[O] So the exact-match number is unfairly harsh and the tool F one is unfairly generous.
[G] That is the honest summary. The truth sits closer to Table 9's plan accuracy, which is neither.
[S] And code. Table 14.
[G] Table 14 is the harshest thing in the paper. AST accuracy, exact match of the predicted code's parse tree to the reference, never exceeds five point three three for any of the six models measured. That includes GPT-4, which reaches five point three three at its best. Llama 2 7B scores zero point zero zero in all four feedback conditions. Meanwhile CodeBLEU, a fuzzy similarity score, reads sixty-eight point six eight for GPT-4.
[S] So "JSON and code perform comparably" is true on the metric they report in the main paper and obscures the fact that under exact match, code output essentially never matches the reference.
[G] I want to push back on half of that. AST accuracy on free-form generated code is close to an unmeasurable quantity. Variable naming alone will sink it, and it says less about capability than it looks like it does. My read is that the right conclusion from Table 14 is not "code generation is terrible", it is "the paper's code-specific metric does not discriminate between these models", which is a different and weaker claim.
[S] I will take that, but it cuts the other way too. If your strict code metric is uninformative and your loose code metric is a fuzzy similarity score, then the format comparison is resting almost entirely on pass rate, which the paper already told us is executability and not correctness.
[G] That is a fair reformulation and I do not have a rebuttal from the paper.
[O] Let me put a point on the board for the authors, because there is a defense here that usually is not available.
[G] The alternative-plans analysis. Yes, and it deserves credit. The obvious objection to any gold-plan benchmark is that a query often has several valid plans and you are punishing the model for picking a different good one. The authors actually measured this. They generated alternative tools for each tool, syntactically by searching paths from a tool's input type to its output type, and semantically by prompting GPT-4, then human-verified the alternatives and composed them into alternative plans.
[S] And the effect size?
[G] Small. Table 10 reports the delta in plan accuracy from allowing alternatives, and it recovers between one and five percent of examples. The paper states that range itself. So the objection is real, it is measured, and it turns out to be worth a few points, not a reinterpretation.
[O] That is the kind of thing most benchmark papers assert and do not check.
[S] Agreed, and it moves me. Now let me return to the cold open, because I do not think we settled it.
[G] Table 17.
[S] Table 17. Human evaluation of execution outputs, eighty-five examples. GPT-4, multi-step, JSON, parsing feedback only: seventy point zero zero, plus or minus six point four seven. Same model with the full feedback stack: sixty-four point one two, plus or minus two point nine four. Multi-step code: sixty-one point one eight. Step-by-step JSON: forty-nine point four one. Mixtral multi-step JSON: forty-two point nine four.
[O] So multi-step wins, JSON wins, and feedback loses.
[S] Two of the three recommendations confirmed and the third inverted, on the paper's own most direct measure of whether the plan worked.
[G] Correct on the facts, and I want to adjudicate this carefully because it is the best exchange in the episode. Three things. First, the error bars overlap. Seventy plus or minus six point four seven against sixty-four point one two plus or minus two point nine four is not a clean separation on eighty-five examples.
[O] Second?
[G] Second, the automatic evaluation tells a different story. Table 19, two hundred ten queries, GPT-4 goes from sixty point five one with parsing feedback to sixty-one point seven three with the full stack. A small gain rather than a loss. So the two execution evaluations disagree about the sign for GPT-4, and neither has the sample size to resolve it.
[S] And third?
[G] Third, and this is the point that actually matters: look at who feedback helps. In Table 19, Llama 2 13B goes from twelve point two seven to twenty-five point four four with verification feedback. It doubles. Gemini Pro goes from forty-four point two five to fifty-five point one eight. GPT-4 moves about a point. That is the same pattern as the pass rates in Table 3, where Llama 2 13B gains thirty-two point nine nine and GPT-4 gains two point one five.
[O] So feedback is a scaffold for weak models and roughly a wash for strong ones.
[G] That is what the evidence supports. And the paper's own text does gesture at it, noting smaller improvements for larger models that already score highly. But the summary recommendation is stated flatly, as a universal design rule, and a practitioner reading only the abstract and the conclusion would over-apply it.
[S] Which was your opening claim.
[G] Which was my opening claim. And it generalizes to the other two axes. Gemini Pro is the exception on multi-step pass rate. Llama 2 7B is the exception on the JSON-versus-code tool F one comparison. In the automatic execution evaluation, Table 18, Llama 2 7B and Gemini Pro both do better step-by-step than multi-step. Every single recommendation has a named exception in the paper's own tables.
[O] Let me make the optimist case anyway, because I think it survives all of this.
[S] Please.
[O] The leaderboard is not the contribution. The contribution is that this is the first benchmark where you can point at a failure and say which half of the pipeline broke. Every number we have argued about for twenty minutes exists because thirty-three tools actually run on real inputs. In the emulated world, none of these questions have answers, they have simulations of answers.
[G] I agree with that, and the paper's design supports it structurally. Rule-based ground-truth plans, human-verified queries, an explicit statement that pass rate is not correctness, and a measured check on whether alternative valid plans change the picture. That is more methodological care than the median benchmark paper of that period.
[S] Then let me put my sharpest remaining concern on the table, because it is not about metrics.
[O] Go.
[S] GPT-4 wrote every query in this benchmark. GPT-4 also rewrote the free-text argument values. And GPT-4 is one of the two highest-scoring planners on it. That is a benchmark whose data-generation model is also a benchmarked model, and the paper never tests whether that inflates its standing.
[G] It does not test it, and that is a genuine gap. I will sharpen it and then constrain it. Sharpen: this is not classic contamination. Nothing was scraped, so there is no memorized test string. The risk is stylistic. GPT-4-authored queries may carry phrasing regularities that a same-family planner parses more easily, and the paper has no experiment that would detect that.
[O] And the constraint?
[G] Two constraints. First, the gold plans are rule-based, not GPT-4-generated, so the answer key is not GPT-4's output. The exposure is on the question side only. Second, the weak evidence we have points slightly against a large effect: GPT-4o, a different checkpoint from the same family, scores eighty-nine point two eight against GPT-4's eighty-eight point four six on tool F one. Barely distinguishable. If there were a strong family-specific advantage, you might expect it to move more across checkpoints, though that is a very indirect test.
[S] It is indirect enough that I would not lean on it.
[G] Nor would I. The clean experiment is regenerating a slice of the queries with a non-GPT-4 model and checking whether the planner ranking holds. It is not in the paper, and it is the single thing I would most want added.
[O] What else would you want?
[G] Two things. Report the plan accuracy from Table 9 in the main paper next to tool F one, rather than leaving it in the appendix, so that seventeen-point gap is visible to anyone reading the figures. And scale the execution-correctness check. Right now the strongest evidence that these plans do the right thing runs on eighty-five examples by hand and two hundred ten automatically, out of eight hundred eighty-two.
[S] Under a quarter of the benchmark, validating the claim that the benchmark's recommendations are correct.
[G] Yes. And the authors are upfront about why, in the limitations: some of their tools are suboptimal, generative, or non-deterministic, which makes automatic output scoring genuinely hard. It is an honest constraint. It is still a constraint.
[O] What are the other stated limitations?
[G] Three more. Only sequential plans, no dynamic plans that branch on a subtask's output. No study of prompt style, as we discussed. And only language-model planners, not multi-modal planners, which for a benchmark built on real images is a notable thing to leave to future work.
[S] What does this mean for evaluation practice now, two years on?
[G] Three transferable lessons. First, separate your executability metric from your correctness metric and say out loud which one you are reporting. This paper does, and the discipline is still not universal. Second, if you use a language model anywhere in your ground-truth pipeline, isolate it to the least load-bearing role. Rule-based plans and model-written queries is a much safer split than the reverse. Third, when your headline metric is a set-overlap score, publish the exact-match number beside it. The gap between those two is where the interesting failures live.
[O] And the caveats on generalizing it forward?
[G] Substantial. Thirty-three tools, at most three steps, strictly sequential, on checkpoints from early twenty twenty four. Modern agent settings involve hundreds of tools, dynamic replanning, and models that did not exist when this ran. The findings about design-space structure are more durable than the model rankings, which are now historical.
[O] Let's close. One sentence each. Rosalind, the paper's.
[G] m and m's is the first tool-use benchmark where the tools genuinely run on genuine multi-modal inputs, which lets it separate planning error from execution error and produce a real ablation of strategy, format, and feedback across eight hundred eighty-two human-verified tasks.
[O] Mine: the executable toolset is the contribution and it holds up. Multi-step planning is better and about four times cheaper in tokens, and that is a finding you can act on tomorrow.
[S] Mine: read the appendix. Tool F one of eighty-eight point four six becomes plan accuracy of seventy-one point four three, feedback is a scaffold for weak models and a wash for strong ones, and every one of the three recommendations has a named exception in the paper's own tables.
[O] The full writeup, with the figures, the filtering chain, and the appendix tables we argued over, is on the litsearch site. Rosalind, thank you.
[G] A pleasure.
