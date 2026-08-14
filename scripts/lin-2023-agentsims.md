---
slug: lin-2023-agentsims
title: "AgentSims: An Open-Source Sandbox for Large Language Model Evaluation"
description: "A 2023 demo paper proposes an objective metric for evaluating language models, and then measures nothing. Is infrastructure a contribution without a demonstration?"
date: 2026-07-27
guest_name: "Freya"
guest_voice: "bf_emma"
---
[O] Here is a claim from a 2023 paper. A task passing rate does not rely on any black-box rating process, no neural network and no human brain, so it is, in their words, an objective and fair metric for comparison between language models. I think that sentence was ahead of its time.
[S] And here is what the same paper does with that sentence. Nothing. No task is run. No passing rate is computed. No model is compared to another model. There is not one experiment in the paper.
[O] It is a demo paper. It ships a sandbox and a paradigm.
[S] It ships a sandbox and an argument that the sandbox solves contamination, solves rater bias, and solves the narrowness of question-answering benchmarks. Three named problems, zero measurements. That is our episode.
[O] Welcome to Litsearch Audio. Today it is AgentSims: An Open-Source Sandbox for Large Language Model Evaluation, by Jiaju Lin, Haoran Zhao, Aochi Zhang, Yiting Wu, Huqiuyue Ping, and Qin Chen. It went up on arXiv on the eighth of August, 2023, from PTA Studio with co-authors at Penn State, Beihang, Sun Yat-sen, Zhejiang, and East China Normal University.
[S] Six pages, a pixel-art town, and a proposal to evaluate language models by dropping them into a simulated social economy. It is on the docket because it is the awkward case. The atlas lists it at a hundred and nine citations, and it reports no results.
[O] And we have Freya with us, who has read this one closely and knows the sandbox literature around it. Welcome.
[G] Thank you. And I want to establish at the top that "no results" is a description, not a jab. I went looking for a results section. What exists is a section called Example Application Tasks, and essentially every sentence in it is in the conditional. Researchers can appoint. We can embed. Pilot experiments can be conducted. It is a menu, not a study.
[S] Freya, set the stage. August 2023. What is broken about evaluation, in the authors' telling?
[G] They name three failures and they are worth taking seriously because the diagnosis is better than the treatment. One, evaluated abilities are limited by the task format. Most of the new suites of that year were single-turn question answering, so they fail, and this is their phrasing, to assess a model's proficiency in adhering to instructions in dialogue or mimicking human-like social interactions.
[O] That is MMLU, C-Eval, AGIEval, that whole cohort.
[G] Exactly that cohort, and they cite it explicitly, along with BIG-bench with its more than two hundred tasks, and a multi-turn dialogue benchmark where, as they note, every dialogue is limited to two turns for simplicity. Two, benchmarks can be easily hacked. As pretraining corpora grow, it has become more and more inevitable, they say, to inadvertently mix test cases into the training set.
[S] Contamination. Fine. That was true then and it is truer now.
[G] Three, and this is the one I find most interesting historically. For open-ended generation the metrics are not objective. Text-overlap metrics are obsolete, human rating is expensive, so the field moved to using GPT-4 as an automatic rater. And their objection is precise. That approach cannot evaluate models above GPT-4 level, and language models are biased toward specific features.
[O] Which is an argument people were still making three years later. In 2023 that is a genuinely sharp read of where judge-based evaluation was heading.
[S] I will give them that. The diagnosis is good. Now, the proposed cure.
[G] Task-based evaluation. Given an artificial social-economic environment, language-model-driven agents have to achieve predefined goals, the way a human demonstrates capability by accomplishing something in the world or in a game. They call it a one-for-all solution for the three problems, and they map it one to one. Social simulation exceeds simple question answering and demands everything from language understanding up to theory of mind. Task settings are diversified and emergent social behaviour is less likely to be described in a training corpus. And the pass rate needs no rater.
[O] So the pitch is not just a tool. It is a paradigm claim.
[G] Correct, and the paper then says the obstacle to the paradigm is the absence of a standard, easy-to-use, extensible platform. Their framing is that previous sandboxes chased implementation efficiency and ignored non-specialist users, and that poor readability produces poor extensibility and user churn. So the gap they identify is a tooling gap in service of a paradigm gap.
[S] Which conveniently means the thing they built is the missing piece.
[G] It does, yes.
[O] Let us get into the build. Freya, what is actually in the box?
[G] Two kinds of pieces. Generative agents driven by language models, and the buildings and equipment that make up the physical environment. The agent side decomposes into a backbone model plus three pluggable support systems, and this three-way split is the paper's real organising idea, borrowed from Generative Agents and Voyager and made explicit.
[S] Name them.
[G] Planning, memory, and tool use. The planning system reorganises a goal by decomposing the target, summarising the current condition, and generating subtasks. It is assembled from a series of pluggable prompt modules that check the memory system for progress toward the ultimate goal and decide the next step, and when a step completes it is written back into memory.
[O] So it is a prompt-scaffolding loop with a state store, not a learned planner.
[G] Precisely. The memory system is a vector database. Each agent's daily memory stream is encoded into embeddings and stored, then retrieved when the agent hits a situation that needs prior context. The example the paper gives is chatting with someone familiar, where the system retrieves the relationship to keep behaviour consistent.
[S] Standard for the era. What is the tool-use system doing? That is the one I do not see everywhere.
[G] This is the piece worth slowing down on. The tool-use system stores equipment-operation pairs learned from feedback. An agent picks a piece of equipment through planning and memory, then has to infer an initial operation from the equipment's text description. The equipment returns an outcome. And here is the mechanism: if the agent believes the result meets its operational purpose, that pairing is stored as a new skill.
[S] Wait. If the agent believes.
[G] If the agent believes. That is the paper's own wording.
[S] So the skill-acquisition loop is validated by the same model whose capability is under test. In a paper whose headline objection to the state of the art is that you should not let a language model be the black-box judge.
[G] That is a fair reading of the text, and the paper does not address it.
[O] Let me push back a little, because I think that is harsher than it needs to be. Skill acquisition and evaluation are different loops. The agent self-judging whether the stove gave it tea is an internal learning signal. The evaluation signal is supposed to be the external task outcome, the pass or fail.
[S] Which would be a good defence if any external task outcome existed in this paper. It does not. The only loop demonstrated is the self-judged one.
[O] That is a fair counter.
[G] And I would add the equipment layer complicates it further. Equipment is defined by descriptive text plus a support function, and the paper is explicit that the support function can either be hard-coded by the developer or be a language model supporting self-adaptive agent-equipment interaction. Their worked example is an agent asking a stove for a cup of tea. The hard-coded path returns "meaningless operation". The model path returns "you cannot get tea from a stove".
[S] So the environment itself can be a language model. The black box did not get removed. It got relocated from the rater into the physics of the world.
[G] That is the structural observation, yes. The objectivity claim is about the metric, and a pass rate genuinely is arithmetic. But the difficulty that pass rate measures is authored, and part of the authoring can be a model.
[O] Buildings, quickly?
[G] Buildings are defined purely by the equipment they contain. A store, a gym, a house. Two interaction modes sit on top. User Mode is a pixel-game front end where a researcher creates an agent from drop-down menus, choosing backbone model, memory system, planning system, goal, and biography, and constructs buildings by placing pre-configured equipment, with no code. There is also a nice touch where the researcher can play the mayor character and intervene by talking to agents, rather than reaching in and editing their memory or goals.
[O] That is a genuinely thoughtful bit of design. Intervening in-world instead of by surgery.
[G] I agree. Developer Mode is the other half, and it is small. An LLMCaller class and an Agent class, with methods plan, memory store, and use. Each one formats a prompt and calls the backbone. Then JSON configuration files for equipment and buildings, an equipment record carrying an identifier, a type, a support function, and a description, with a separate file for economic features like prices and salaries, and a building record with a type, a two-dimensional array of blocks, and the equipment identifiers placed in it.
[S] And the stack underneath?
[G] Ordinary and stated plainly. Python three point nine, a Tornado web server, the websockets library for push notifications, mysql-connector-python against MySQL, and a Unity front end built to WebGL, embedded in the page and served through nginx.
[O] Right. Results.
[G] There are none. I want to be careful and complete here, because this is the part a listener will not believe. No pass rates. No accuracy numbers. No comparison across models. No ablation of the planning, memory, or tool-use systems the paper spends its longest section describing.
[S] What is in the Example Application Tasks section, then?
[G] Three sketches. First, subject model as participant. You put the model under test into a scene constructed by baseline agents driven by stronger models. Their example is embedding colleague agents driven by GPT-4 with a strong desire to bully newcomers, then testing whether the new model can understand others' emotions and improve how the colleagues perceive it.
[O] That is a good scenario. I would want to run that.
[G] So would I, and nobody ran it here. Second, subject model as mayor. You appoint the model mayor of the town, or president of a company, among GPT-4-driven residents. It has to recruit residents, issue and revise policies, and found new buildings as problems emerge. The paper says that by analysing the success rate of the mayor under different difficulties, researchers can gain valuable insights.
[S] Under different difficulties. How many difficulty levels are defined?
[G] None are defined. No difficulties, no mayors, no success rates. Third, applications beyond evaluation: generating social-judgement data, pointing at prior work that used a simulated society for alignment data, and cheap pilot experiments for social scientists before they run a study on humans. No generated dataset and no pilot study appear.
[O] Are there any numbers at all in the paper?
[G] Only inside the interface mock-ups and the configuration snippets. A cash balance of ten thousand dollars on an example character. A total payment of twelve thousand dollars on the agent-creation screen. A store priced at two thousand. A menu entry pricing chicken at twenty. Those are placeholder values in screenshots and example JSON. They are not findings and nobody should cite them as any.
[S] Good. Then let us have the argument properly. My case is short. The paper asserts that task-based evaluation is a one-for-all solution to contamination, to narrow task formats, and to rater bias. Not one of those three is tested. The contamination claim in particular is asserted in the abstract-level framing and then never examined, and it points the wrong way once you notice the sandbox is open source. The demo is public, the town and its templates are public, and the paper actively hopes researchers will share the tasks they build. The moment transcripts of a specific task circulate, that task is exactly as crawlable as a leaked answer key.
[O] Now mine. Demo tracks exist for a reason, and the reason is that most researchers cannot afford to build a simulation stack before they can ask their question. Behavioural economists and social psychologists are named as the target users, and lowering that barrier is a real contribution even if the authors themselves never ask a question with it. Roads count as infrastructure before anyone drives on them.
[S] Roads get load-tested before they open.
[O] Some do. And I would note the honest thing here is that the paper never dresses a sketch up as a study. It says "we can embed", not "we embedded". The litsearch writeup makes the same point: the honesty is real, the framing is what oversells.
[G] Let me adjudicate, because I think you are each right about a different object. On the artifact, the optimist wins. A modular agent with swappable planning, memory, and tool use, a no-code authoring interface, and a JSON schema for environments is a legitimate systems contribution for August 2023, and the three-system decomposition became close to a standard vocabulary.
[S] And on the paradigm claim?
[G] On the paradigm claim the skeptic wins, and the decisive evidence is the paper's own limitations section. Read it and the one-for-all framing collapses from inside. They concede the simulation is limited by the accuracy of the models and the diversity of buildings and equipment, and can never fully reflect real-world cases. They concede that task-based evaluation can hardly reflect fine-grained abilities like mathematical reasoning. And they concede that the pass rate cannot provide insight into why a model succeeded or failed.
[O] That last one is a serious concession. An objective metric with no diagnostic content.
[G] It is the trade they made and did not price. You buy an unarguable number and you lose the ability to say anything about the mechanism behind it.
[S] There is a sharper problem, and it is the one that gets me. Their stated motivation for abandoning judge-based evaluation is that GPT-4 as a rater cannot evaluate a model better than GPT-4. Fine. Now look at both of their flagship scenarios. The hostile colleagues are GPT-4. The townspeople the mayor governs are GPT-4.
[O] So the environment's difficulty ceiling is set by the same model class you were trying to escape.
[S] The rater got demoted to a cast member. It did not leave the building.
[G] I think that is the strongest point either of you has made, and I will note the paper does not raise it. Whether it is fatal depends on something unmeasured. If a GPT-4-populated town produces genuinely emergent difficulty, the environment can exceed any single occupant. If it mostly reproduces GPT-4's idea of what a hostile colleague is like, the ceiling is real. The paper offers no evidence either way because it ran nothing.
[O] Which is where I land on what would have changed my view. One scenario, end to end. Two or three subject models, one success rate each. An ablation stripping memory or planning against a bare model on that same task. That is a week of compute and it converts the entire argument from a hypothesis into a finding.
[S] And a token cost per simulated day, since every background character is a frontier model. If a single simulated week costs more than a full MMLU run, the accessibility pitch to social scientists is decorative.
[G] Both are fair asks, and neither is exotic.
[O] What is the implication for how we evaluate now?
[S] Mine is a warning about vocabulary. Objective is not the same as valid. A pass rate is unarguable arithmetic over an environment somebody authored, and every judgement call migrates upstream into the design of the world. Moving the subjectivity is not deleting it.
[O] Mine is more generous. The shift from grading an answer to observing whether a goal was achieved is the right shift, and the field did move that way. That this paper argued for it before it could demonstrate it is a timing failure, not a thinking failure.
[G] And mine is about how to cite it. This is a platform paper. Cite it as infrastructure someone could build an evaluation task on, and never as an evaluation result, because there is no result in it to compare against.
[O] Freya, your one-sentence takeaway from the paper.
[G] The authors correctly diagnosed that static question answering, contaminated test sets, and model-as-judge were all failing at once, proposed task completion in a simulated town as a single cure, built a usable sandbox for it, and left the entire empirical burden to whoever came next.
[S] Mine. A paper that proposes an objective and fair metric and then never computes it has given us a definition, not a measurement, and the two are not the same contribution.
[O] And mine. Tooling that lowers the barrier for a non-specialist to ask a question is worth building even when the builders never ask one, and the field's willingness to keep citing this proves the need was real.
[S] The full writeup is on the litsearch site, with the architecture figure and the pixel-town interface, and a critique section that says all of this plainly.
[O] Thanks Freya. See you next episode.
