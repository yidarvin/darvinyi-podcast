---
slug: valmeekam-2022-planbench
title: "PlanBench: An Extensible Benchmark for Evaluating Large Language Models on Planning and Reasoning about Change"
description: "GPT-4 solves thirty four percent of Blocksworld planning problems. Rename every block and action, change nothing else, and it solves two percent. That control condition is in an appendix."
date: 2026-07-25
guest_name: "Theo"
guest_voice: "bm_george"
---
[S] GPT-4 solves thirty four point three percent of the plan generation problems in this benchmark. Rename every object and every action in the domain, change nothing else about the problem, and it solves two percent.
[O] And that is exactly the experiment this benchmark was built to make cheap. Most eval papers can only speculate about contamination. This one ships the control condition in the box.
[S] It ships it in Appendix A point three. Table two. The abstract does not mention obfuscation at all.
[O] That is a presentation complaint, not a science complaint. The experiment is there, and the authors draw the right conclusion from it in their own words.
[S] It is a presentation complaint that decided what the field remembers. Ask a researcher what PlanBench found and you get thirty four percent. You do not get two.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Today it is PlanBench, an extensible benchmark for evaluating large language models on planning and reasoning about change.
[S] Karthik Valmeekam, Matthew Marquez, Alberto Olmo, Sarath Sreedharan, and Subbarao Kambhampati. Arizona State University, with Sreedharan at Colorado State. First posted to arXiv in June twenty twenty two, published at NeurIPS twenty twenty three in the datasets and benchmarks track.
[O] Our guest is Theo, who knows this work and the automated planning literature it comes out of. Theo, welcome. Why is this paper on the docket now?
[G] Because it set the terms of an argument that is still running. Every time somebody claims a new model can plan, the first question is whether they ran PlanBench, and the second is whether they ran the obfuscated version. That vocabulary starts here.
[S] Then start with the gap. What were the planning claims resting on before this?
[G] Commonsense reasoning benchmarks. The paper names them: BIG-Bench, GSM8K, AQuA, SVAMP, CommonsenseQA, StrategyQA. And the complaint is one sentence long, and it is the thesis of the whole paper. On those tasks it is hard to tell whether the model is planning, or merely retrieving from its vast world knowledge.
[O] Because the scenarios are things the pretraining corpus is saturated with.
[G] Right. Ask a model to plan a trip or make coffee and a plausible answer is available by paraphrase. There is no way to separate search from recall, because the ground truth is itself a common piece of internet text.
[S] And planning has a formal definition that does not have that problem.
[G] It has a formal definition that is decades old. A classical planning problem is a domain, an initial state, and a goal. The domain is a set of fluents, which are the state variables, and a set of actions. Each action has preconditions, the facts that must hold for it to execute, and effects split into add effects and delete effects, the facts it makes true and the facts it makes false. There is nothing subjective anywhere in that object.
[O] And crucially, that gives you a checker instead of a judge.
[G] That is the whole move. If the problem is written in PDDL, the planning domain definition language, then a candidate plan is either valid or it is not, and a program decides which. You execute the plan against the domain model. Every action's preconditions must hold when it fires, and the final state must satisfy the goal. No rubric, no grader model, no human in the loop.
[S] Walk me through the architecture, then, because you are telling me the contribution is the harness and not the numbers.
[G] Two halves. The domain independent half is built around a real planner and a real plan validator. They use Fast Downward as the planner and VAL as the validator. That half generates the test instances for each curriculum item and verifies whatever the model returns.
[O] So the planner is not a baseline in this setup. It is part of the grading apparatus.
[G] It manufactures the ground truth, yes. The domain dependent half is what you have to write when you add a new domain, and it is three pieces. A lifted domain model in PDDL, meaning the actions are defined over variables rather than specific objects. A problem generator that samples random initial states and goals. And a translator.
[S] The translator being where the natural language enters.
[G] Template based, in both directions. Every predicate and every action gets a natural language template, and states and plans are assembled by concatenating those strings. Going the other way, the model's free text answer is parsed back into grounded PDDL actions, either by template matching or by treating the verb as the action and each noun as one of its arguments.
[O] That parser is carrying a lot of load for a template system.
[G] It is, and the paper is honest about the failure mode. The prompt requires one action per line, and the demonstration plan ends with an explicit plan-end tag so a plan can be extracted even if the model adds commentary. If the extractor cannot get a plan out of the response, that instance is marked incorrect.
[S] So a formatting failure and a reasoning failure score identically. That is a real measurement decision.
[G] It is, and the paper does not report how often it fires. My read, going beyond the paper, is that with a one-shot prompt and temperature zero the rate is low. But you cannot verify that from the text.
[O] Eight test cases. Give me the shape of the curriculum.
[G] Two of them are actual planning problems, and the authors say so explicitly. Plan generation, produce a valid plan for a new instance. And cost optimal planning, where each action carries a cost, framed as minutes or money, and the plan has to be valid and cheapest.
[S] And the other six?
[G] Auxiliary abilities that any planning-capable agent should also have. Plan verification, where the model is given a candidate plan and has to say whether it works, and if not, name the first inexecutable action and at least one missing precondition, or at least one missing goal condition if the plan runs but does not reach the goal. Reasoning about plan execution, where it gets a state and an executable action sequence and has to predict the resulting state. Then robustness to goal reformulation in three variants. Then plan reuse, replanning, and plan generalization.
[O] Unpack goal reformulation, because I suspect it matters for the results.
[G] All the example problems share one initial state, and the final query has the same initial state and the same goal as the example, just written differently. Either the goal facts are shuffled, or a fully specified goal is shown and a partial one is queried, or the reverse, partial to full. In every case the demonstrated plan still works.
[S] So the answer is sitting in the prompt.
[G] Essentially. It tests recognition, not search.
[O] And replanning, and generalization?
[G] Replanning executes a random prefix of a valid plan, then perturbs the world. In Blocksworld they stop at a point where a block is being held, stack that block onto another random clear block, and empty the hand. The change is reported, and the model has to finish from the new state. Plan generalization is different in kind. Every plan in the prompt was produced by a fixed program containing loops and conditionals, so the question is whether the model can extract the procedural pattern and run another iteration of it.
[S] And the domains.
[G] Blocksworld and Logistics, both International Planning Competition domains. Six hundred Blocksworld instances, varying in object count and optimal plan length, plus five hundred separate curated instances for plan generalization. Two hundred and eighty five Logistics instances, where trucks move packages within a city and planes move them between cities. About twenty six thousand two hundred and fifty prompts across everything.
[O] And then the obfuscation, which is the part people actually cite.
[G] The Mystery domains. Identical PDDL problems, but the object names, predicate names and action names are replaced, either with misleading words or with random alphanumeric strings. The key property is stated in a single line: for a standard planner, the original domain and the obfuscated version are identical.
[S] Give me the misleading-word version concretely, because I think people picture something milder than it is.
[G] The four actions become Attack, Feast, Succumb, and Overcome. The predicates become Province, Planet, Harmony, Pain, and Craves. A prompt reads: object b craves object c, harmony, planet object a, province object b, and so on. The goal is that object c craves object b. And the reference plan is feast object b from object c, succumb object b, attack object c, overcome object c from object b.
[O] That is genuinely disorienting, and let me steelman the skeptic before he gets there. Those words carry actively wrong associations. Attack sounds destructive, feast sounds like consumption. This is not a neutral relabeling, it is an adversarial one.
[S] I was going to put that less generously, so thank you. But there is a second condition.
[G] There is, and it is the cleaner one. Random alphanumeric strings, with no semantics to mislead anybody. And performance in that condition is worse than under the deceptive naming, not better.
[S] All right. Numbers. What was actually run?
[G] Two models. GPT-4, and InstructGPT-3, specifically text-davinci-002. OpenAI API, temperature zero, all other parameters default, one in-context example. The GPT-4 they used had an eight thousand token context window and was accessed between March and June of twenty twenty three. And one thing worth stating plainly up front: Table one is Blocksworld only. The Logistics instances exist in the dataset, but no Logistics results are reported anywhere in the paper.
[O] Headline first.
[G] Plan generation. GPT-4 gets two hundred and six out of six hundred, thirty four point three percent. InstructGPT-3 gets forty one out of six hundred, six point eight percent. Cost optimal planning is almost identical: one hundred and ninety eight out of six hundred for GPT-4, thirty three percent, and thirty five out of six hundred for InstructGPT-3.
[S] So on the two tasks the authors themselves call real planning, the frontier model of the day sits at a third.
[G] Correct. Verification is easier, three hundred and fifty two out of six hundred, fifty eight point six percent, against twelve percent for InstructGPT-3. Reasoning about plan execution lands near plan generation for GPT-4, one hundred and ninety one out of six hundred, thirty one point eight percent. But InstructGPT-3 gets four. Four instances out of six hundred. Zero point six percent.
[O] That is the widest gap in the table, and it is a pure state-tracking task.
[G] Replanning, two hundred and eighty nine out of six hundred for GPT-4, forty eight point one percent. Plan generalization, one hundred and forty one out of five hundred, twenty eight point two percent. Plan reuse is the strongest of the planning-adjacent tasks, three hundred and ninety two out of six hundred, sixty five point three percent.
[S] And the goal reformulation trio, which you told me is recognition rather than search.
[G] Shuffling goal predicates, GPT-4 at seventy six point eight percent, InstructGPT-3 at seventy seven point eight. Full to partial, GPT-4 at eighty seven percent, InstructGPT-3 at seventy seven point eight. Partial to full, GPT-4 at fifty eight percent, InstructGPT-3 at sixty point five.
[S] Stop there. On two of those three, the older and far weaker model matches or beats GPT-4.
[G] It does. On shuffling, and on partial to full. And I think you are entitled to the inference.
[S] The inference is that those three rows are not measuring capability, because an axis that fails to order the models by capability is not measuring the thing it claims to.
[O] I will half concede that. Those three are the easy end of the curriculum by construction and the authors label them auxiliary. But look at the other half of what you just said. GPT-4's partial-to-full score, fifty eight percent, is below its own plan reuse score of sixty five point three. A task where the answer is literally in the prompt is harder than a task where it has to truncate a plan it was shown. That is strange, and the paper does not explain it.
[G] It does not, and it is the most under-discussed row in that table.
[O] Now the obfuscation result.
[G] Mystery Blocksworld, plan generation only. Under deceptive naming, GPT-4 falls from thirty four point three percent to twenty six out of six hundred, four point three percent. Under randomized naming, twelve out of six hundred, two percent.
[S] An order of magnitude, on problems a symbolic planner cannot even distinguish from the originals.
[G] And the authors' conclusion is right there in the appendix, in their own words. Whatever planning performance was shown in the Blocksworld domain was more likely due to pattern matching rather than reasoning, which should have been robust to this kind of obfuscation.
[O] What happens to InstructGPT-3 in that table?
[G] Fourteen out of six hundred deceptive, six out of six hundred randomized. And there is an arithmetic slip worth flagging. The table prints zero point two three percent next to that fourteen out of six hundred. Fourteen out of six hundred is about two point three percent. The raw count is the number to trust.
[S] Take the counts, then, and the weak model degrades by a factor of about three under deceptive naming while the strong model degrades by a factor of eight.
[G] That is what the counts say. Six point eight percent down to roughly two point three, against thirty four point three down to four point three. The larger the un-obfuscated advantage, the more of it evaporates.
[O] There is one more analysis I want on the record, because it defends against the obvious objection.
[G] The relaxed-validity study. The objection is that binary validity is harsh, and a plan one action away from working scores the same as complete nonsense. So the authors re-grade GPT-4's plans against relaxed domain models, borrowing the relaxations the planning community uses to derive heuristics. Delete relaxation ignores delete effects. Precondition relaxation ignores preconditions entirely, so any action can fire in any state.
[S] And under the most permissive grading?
[G] Reading off figure five, GPT-4 still fails to reach the goal on roughly one hundred and forty of six hundred Blocksworld instances, and roughly three hundred and sixty of six hundred on Mystery Blocksworld. The paper's own phrasing is that it still fails in a lot of instances.
[O] So these are not near misses. They are plans that do not arrive even when you turn the physics off.
[G] With one structural caveat. Under full relaxation nothing can be inexecutable, by construction. Inexecutable plans only appear once preconditions are restored, and there, on Mystery Blocksworld, they dominate the failure modes.
[S] There is a distributional result in that appendix I liked too.
[G] Figure four. The distribution of instances GPT-4 solves, plotted over optimal plan length, does not concentrate on the short ones. Shallow instances are not reliably easier. The authors note this deviates from intuition for a classical planner but is unsurprising for a next-token predictor, which has no notion of search depth to begin with.
[O] Let me make the optimist case, and it is not about the scores. This is a benchmark design argument that happens to also run an experiment. Mechanical grading with a real validator, so no human judges and no model judges. A contamination control built into the artifact rather than bolted on afterward. Eight decomposed sub-skills instead of the single word planning. And extensibility, so the domains are not the benchmark, the generator is. Nearly every property people now demand from an agentic eval is sitting in this paper from twenty twenty two.
[S] My deflationary case is that the specimen evaluation is thin enough that it should not have become the citation it became. Two models, both long deprecated. One in-context example. Temperature zero, one sample per instance. No chain of thought, no self-consistency, no tool use, no agentic scaffold. And the GPT-4 checkpoint is an unspecified snapshot pulled from an API over a four month window, so the headline number is not independently reproducible by anyone, ever again.
[O] Agreed on reproducibility, and that is a genuine loss.
[S] There is also no trivial baseline reported. Nobody states what Fast Downward scores, which is a hundred percent by construction, since Fast Downward generated the ground truth. Saying that out loud frames the exercise honestly. The question was never whether these problems are solvable. It is whether a next-token model reinvents search.
[G] Let me score these. Skeptic, on the specimen evaluation you are right, and the authors partly agree with you. They call it a specimen evaluation, they say the point is to give useful baselines, and they point to a companion study for the deeper prompting work, including zero shot, chain of thought, and PDDL-style prompts. But none of that criticism touches the framework, which is what the paper claims to contribute.
[O] So the numbers were designed to expire.
[G] They were, and they did, almost immediately. Optimist, on design I score it to you, with one deduction. The obfuscation result is the paper's strongest evidence and it lives in an appendix table while the abstract never mentions it. That is not a neutral editorial choice. It is the difference between a paper that says LLMs score thirty four percent and a paper that says thirty four percent is mostly vocabulary.
[S] I want one more concession from the optimist side, and it is about the contamination control itself.
[O] Go ahead.
[S] Obfuscation scrambles the surface lexicon. It does not remove the model's exposure to the abstract structure. Blocksworld has been in textbooks, homework sets and planner papers for decades. A model might have internalized the stacking constraints in a form that survives renaming, or it might not, and this experiment cannot separate those two worlds.
[G] That is fair, and the paper does not address it. What obfuscation establishes is an upper bound on how much of the un-obfuscated score is lexical familiarity. It does not establish that the remaining two to four percent is search.
[O] So what changes downstream if you take this seriously?
[G] The concrete lesson for evaluation practice is that if your task has a formal model, grade against the formal model. The planning community had mechanically checkable correctness for decades, and this paper simply ported the apparatus across. No rubric drift, no judge-model bias, no argument about what counts as right.
[S] And the second lesson is the control condition. Ship a version of your benchmark where the semantics are preserved and the surface form is destroyed. If performance moves, you have learned what your benchmark was measuring.
[O] Which is cheap here precisely because the domain is formal. You cannot obfuscate a medical question-answering benchmark this way.
[G] You cannot, and that is the honest boundary of the technique. It generalizes to anything with a symbolic ground truth and not much further.
[S] Takeaways. Theo, you first.
[G] My one sentence on the paper: PlanBench's contribution is the harness rather than the leaderboard, and the obfuscation control is the part that should have been in the abstract.
[O] Mine is that this is what a benchmark looks like when it is designed to outlive the models it was built to test, and it did exactly that.
[S] And mine is that the thirty four percent figure has been quoted far more often than the two percent figure, which tells you something about benchmarks that no benchmark measures.
[O] The full writeup, with the figures, the results table and the references, is on the litsearch site. Theo, thank you.
