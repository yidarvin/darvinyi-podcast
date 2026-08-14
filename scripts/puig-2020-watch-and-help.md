---
slug: puig-2020-watch-and-help
title: "Watch-And-Help: A Challenge for Social Perception and Human-AI Collaboration"
description: "A helper agent watches one demonstration, infers the goal, then helps in an apartment it has never seen — and a wrong guess makes it worse than useless."
date: 2026-07-26
guest_name: "Soren"
guest_voice: "am_fenrir"
---
[O] Here is the result I cannot stop thinking about. You build a genuinely competent planner, you give it a wrong idea of what the person wants, and it does not merely fail to help. It walks over and undoes the work they already did.
[S] And the number attached to that is brutal. Conflicts show up in 40 percent of episodes overall, and 65 percent in two specific activity categories. That is not a rare edge case. That is the modal outcome for a confident helper with the wrong goal.
[O] Right, but flip it. The reason that number exists at all is that somebody finally built an environment where the helper has to guess. Every prior collaboration benchmark handed both agents the goal up front. This one makes the guess the whole experiment.
[G] And the part that gets underrated is that the same setup was run twice. Once with a synthetic stand-in for the human, and once with actual people driving the other avatar. That pairing is what makes the conflict finding more than a simulator artifact.
[O] Welcome to Litsearch Audio. Today we are on Watch-And-Help, a challenge for social perception and human-AI collaboration. Puig, Shu, Li, Wang, Liao, Tenenbaum, Fidler and Torralba, out of MIT, ETH Zurich, Toronto, NVIDIA and the Vector Institute, published at ICLR 2021.
[S] It is on the docket because it is upstream of a lot of what we now call embodied Theory-of-Mind evaluation, and because it does something most benchmarks of its era did not, which is close the loop with real humans instead of asserting the stand-in is fine.
[O] And we have Soren with us, a researcher who has spent a lot of time with this work. Soren, welcome. Start us before the paper. What did the landscape actually look like in 2020?
[G] Split down the middle, is the honest answer. On one side you had multi-agent platforms with rich strategic interaction. Overcooked, Hanabi, Malmo, the big game environments. Real coordination problems, but toy or game-like worlds with no household semantics. On the other side you had the realistic embodied simulators. Habitat, Gibson, AI2-THOR, VirtualHome itself. Photoreal homes, but built around a single agent doing navigation or question answering or task completion.
[S] I want to be precise on AI2-THOR, because people get this wrong. It did support multiple agents.
[G] It did, and the paper's own comparison table says so. What AI2-THOR lacked was a humanoid avatar and a built-in human-like agent to interact with. So you could put two agents in a scene, but neither of them looked like a person or behaved like one, which matters enormously if the task is watching someone and inferring what they want.
[O] And the human-robot interaction literature? That field has studied helping for decades.
[G] It has, and the paper is fair about it. The limitation there is the goal. In prior collaborative-planning work the goal was either shared by both agents from the start, or drawn from a small enumerable space. The helper never had to recover an intention from a single observed demonstration. Overcooked, in the comparison table, actually does have a human-like agent and multi-agent support. What it does not have is a realistic environment or humanoid agents.
[S] So the claim is not "nobody studied helping." The claim is that nobody put goal inference, an unseen environment, and a believable human in the same loop.
[G] That is exactly the claim, and I think it holds.
[O] So walk us through the structure. Two stages.
[G] Two stages. In the Watch stage, Bob, the AI agent, sees one demonstration of Alice performing a household task and has to infer her goal. In the Help stage, Bob is placed in a different apartment with Alice and has to get that same goal satisfied as fast as possible. The environment is different from the demonstration every single time, by construction, and two of the seven apartments are held out exclusively as test-time helping environments.
[S] Seven apartments total. That is a small world.
[G] It is small, and I would flag it as a real limitation, but hold that thought because the goal space is where the diversity actually lives.
[O] Define a goal for me concretely.
[G] A goal is a set of predicates with counts. Something like "on plate dinnertable, count two, on wineglass dinnertable, count one." Between two and eight predicates per goal. The objects are specified by class, not instance, so any plate will do, which the authors argue reflects genuine preference variation between people. There are 30 distinct predicate types drawn from five household activity sets. Setting a dinner table, putting groceries in the fridge, preparing a simple meal, washing dishes, and reading a book with snacks.
[S] And the splits?
[G] One thousand and eleven training tasks. Two test sets of a hundred each. Test-1 draws all predicates in a goal from a single activity set. Test-2 mixes predicates from two different activity sets, which is the compositional generalization probe. There is also a separate pool of five thousand three hundred demonstrations used only to train the goal inference model, never for helping. Episodes cap at 250 steps.
[O] Now Alice. This is the piece I find most interesting, because she is not scripted.
[G] She is not, and that is the enabling contribution. Alice is a planning agent with deliberately bounded rationality. Three parts. A belief module that holds a distribution over where each object might be, starting uniform. Monte Carlo Tree Search over sequences of subgoal predicates. And a regression planner that works backward from a subgoal to a concrete action sequence.
[S] What makes the belief module bounded rather than just wrong?
[G] The update rule. She only resamples an object's location when a new observation actually contradicts her current belief. So if she thought the wine glass was in the cabinet and she opens the cabinet and it is empty, she resamples. Otherwise the belief stays put across steps. That gives her coherent, slightly stubborn search behavior instead of an agent that re-randomizes its world model every tick.
[O] And she replans continuously?
[G] Every step, from her latest partial observation. About 0.05 seconds per replan, so it runs in real time. Which is what lets her react to Bob. If he moves something, she sees it and adapts.
[S] Here is my question. How do we know she is a good stand-in for a person? Because the entire external validity of the cheap, scalable half of this benchmark rests on that.
[G] The authors ran a separate rating study, and I would call the result supportive but not overwhelming. Eight subjects, fifteen videos each, rating on a five-point scale whether the character behaves similarly to a human given the same goal. The built-in agent scored 3.38, real humans scored 3.72. A paired test with twenty-nine degrees of freedom gives p equals point one nine, so no significant difference.
[S] No significant difference with eight raters. That is an absence of evidence, not evidence of absence.
[G] Fair, and the free responses are actually more informative than the p-value. Raters said human plans looked slightly more efficient because people do not search for objects in unlikely places and do not shuttle between rooms as much. The synthetic Alice occasionally searches rooms in a counterintuitive order, precisely because of the bounded rationality and stochastic plan sampling. So it is close, with a known and characterized failure mode.
[O] There is also a nice touch where she closes containers behind her.
[G] A heuristic on the high-level planner. She closes a container once she has found nothing relevant inside or has taken out everything she needed. The authors say it made behavior noticeably more human. Small thing, but it is the difference between a home and a warehouse.
[S] Let us get to Bob. What is he actually solving?
[G] Two models bolted together. The goal inference model encodes each demonstration state with a Transformer over visible objects, pushes that sequence through an LSTM, average-pools over time, and then runs 30 independent classifiers, one per predicate type, each predicting a count. And then for helping, every baseline shares a hierarchical structure. A high-level module picks the next subgoal predicate, a low-level module turns it into a primitive action.
[O] And the baselines instantiate that three ways.
[G] Three ways plus controls. HP is a hierarchical planner, MCTS on top and regression planning underneath. It is the same planner class as Alice, with two differences. It has its own partial observation and therefore its own belief. And when it is handed the true goal, the high-level planner removes whatever subgoal Alice is about to pursue from its own subgoal space, so it does not duplicate her work. Hybrid replaces the high-level planner with a reinforcement-learned policy but keeps the regression planner underneath. HRL learns both levels.
[S] And the action space they are searching over?
[G] Averages 167 distinct actions per step, because interacting with anything requires naming both an action type and a specific visible object instance. And it changes every step, since you can only act on what you can see.
[O] Metrics.
[G] Three. Success rate. Speedup, defined as Alice's solo episode length divided by the collaborative length, minus one. And a cumulative reward that folds both together, ranging from minus one for failure to one for instantaneous success. Plus two oracles as upper bounds. Oracle-B gives Bob full environment knowledge and the true goal. Oracle-A-B gives Alice full knowledge too.
[S] Good. Numbers. Watch stage first.
[G] On test-1, the full model gets precision of point eight five and recall of point nine six on predicate recognition. Chance is point zero eight and point zero nine, so it is far above floor. But the two ablations are the interesting part.
[O] Go.
[G] Feed it only the last observed state instead of the whole sequence and it drops to point seven nine precision, point seven five recall. Feed it Alice's actions directly instead of raw states and it goes to point nine nine and point nine nine.
[S] So the goal is essentially decodable from the action sequence, and the hard part is recovering the actions from states.
[G] That is the honest reading. The temporal sequence matters, the final state alone is not enough, and almost all the inferable signal lives in what she did rather than where things ended up. Which is a sensible finding for a paper about social perception, but it also means the perception problem here is closer to action recognition from symbolic state than to anything visual.
[O] Help stage.
[G] Planning wins. HP with the true goal is the best non-oracle baseline, because it explicitly reasons about Alice's plan and dodges redundant work and collisions. With the model's own inferred goal, both HP and Hybrid still help effectively. And then the deliberately-wrong condition, HP with a random goal, is where it breaks. That is the 40 percent conflict number, 65 percent for Put Groceries and Set Meal specifically.
[S] Two separate numbers, not a range.
[G] Correct. 40 percent overall, and 65 percent in those two categories. There is a worked example in the appendix that is almost comic. Alice puts a wine glass on the table. Bob, who has randomly decided she wants it in the dishwasher, immediately grabs it and puts it in the dishwasher. She takes it out and puts it back. He puts it back in. They loop.
[O] And HRL?
[G] HRL performs no better than a random-action agent. Not worse. Tied, with overlapping error bars, despite sharing its high-level policy architecture with Hybrid.
[S] That is the finding I want to push on hardest, so let us do the diagnosis properly. Why?
[G] The paper is specific. The high-level policy selects reasonable predicates. The low-level policy typically grabs the correct object and then fails to deliver it to the target location. So the failure is localized in low-level execution, not in subgoal selection.
[S] Which is a training problem, not a statement about what reinforcement learning can do on this task.
[G] I think that is right, and the appendix supports you. The low-level policy is off-policy advantage actor-critic, RMSprop, learning rate point zero zero one. Two-phase curriculum. Phase one trains grabbing for a hundred thousand episodes. Phase two trains put-after-grab for twenty-six thousand.
[S] Twenty-six thousand for the compositional half. Against a hundred thousand for the easy half. The stage that fails is the stage that got a quarter of the training.
[G] That is a legitimate observation, and the paper does not run the ablation that would settle it.
[O] Let me push from the other direction, because there is a control here that I think gets skipped. Random versus Alice working alone.
[G] No significant difference. Ninety-nine degrees of freedom, p equals point one seven. A random agent does not measurably help or hurt.
[O] But there is a mechanism for why random sometimes helps at all, and I love it.
[G] Belief updating. When Bob opens a container, Alice observes it and updates her belief about where things are. So a random agent that blunders around opening cabinets is doing free information-gathering for her. The paper names this as the main reason random actions can speed things up. Helping is not only about achieving predicates. It is also about changing what your partner knows.
[S] Which is genuinely a nice result and also a warning about the metric. If random noise can produce speedup through a side channel, the metric is measuring something broader than intentional collaboration.
[G] Both are true.
[O] Test-2. Compositional generalization.
[G] Goal inference falls to point six eight precision, point six four recall, down from point eight five and point nine six. The authors attribute it to overfitting on predicate combinations seen in training rather than genuine composition. Downstream, Alice alone succeeds 95.4 percent of the time. HP gets 88.6 percent success and a speedup of only point two one.
[S] So the helper makes her worse at finishing, and barely faster when she does.
[G] And the paper traces that directly to the weaker Watch-stage recognition. The two stages are coupled exactly as designed. Degrade perception, collaboration degrades with it.
[O] Now the human experiments, which is the part I think earns this paper its longevity.
[G] Two of them. Experiment one, six subjects controlling Alice alone across 30 tasks, same observation and action space as the synthetic agent. Humans were slightly faster, not significantly. Twenty-nine degrees of freedom, p equals point one one. Experiment two, twelve subjects, 90 collaboration trials on those same 30 tasks, each paired with HP, Hybrid, or HP with a random goal.
[S] And the headline is that the ranking replicates.
[G] The ranking of the three agents is the same with real humans as with the synthetic Alice, and the subjective one-to-seven ratings on goal knowledge, helpfulness and trust track the objective scores. There is one divergence, and I want to state it carefully because it is easy to garble.
[S] Please.
[G] The paired t-tests in the appendix are on cumulative reward. Three of them. HP with a random goal scores significantly higher when paired with real humans than with the synthetic agent. Twenty-nine degrees of freedom, p equals point zero three. HP shows no significant difference, p equals point one. Hybrid, no significant difference, p equals point six two.
[O] And the explanation for that one gap?
[G] Real people recognized that the AI had a conflicting goal and routed around it. Instead of fighting over the same wine glass forever, they went and finished their other subgoals first, then came back for the contested one at the end. That adaptation got them inside the step limit. The synthetic Alice cannot do that, because she has no model of Bob at all.
[S] So the stand-in is a conservative stand-in. It underestimates how well a bad collaborator does with a real person.
[G] In that one condition, yes. The paper says the higher cumulative reward was driven by a higher success rate, and I want to be exact here, because it reports no significance test on success rate itself. The tested quantity is cumulative reward.
[S] Noted, and that is a distinction worth keeping, because a claim about success rate would be a different claim.
[O] Alright. Debate. I will go first and I will make the strong version. The durable contribution is not the numbers, it is the shape. Split social intelligence into infer-a-goal and then act-on-it, force the second half into an environment the agent has never seen, and validate the whole thing against real people. Later Theory-of-Mind and embodied-collaboration benchmarks inherit both the framing and the machinery. MMToM-QA builds directly on this pipeline.
[S] I will grant the framing entirely and attack the evidence. The paper's central empirical claim is that planning-based approaches are the most effective. Look at what that claim is competing against. A random agent. An HRL baseline that ties the random agent because its low-level policy got a quarter of the training its grab policy got. And two oracles that are, by construction, out of reach. There is no comparably-tuned learned method in the comparison. "Planning wins" is close to true by default.
[O] The oracles do bound the space though.
[S] They bound it from above, which tells you headroom exists. It does not tell you whether a well-tuned learner closes it. Those are different questions and only one of them got tested.
[G] I score that mostly to the skeptic. The paper is a benchmark paper, so providing a planner and a couple of learned baselines is a legitimate scope. But the sentence "planning-based approaches are the most effective" is doing more work than the experiments support. What the experiments show is that this planner beats these two learned baselines, one of which is diagnosed as broken in low-level execution.
[O] Then let me take the other line. The conflict finding does not depend on baseline quality at all. HP with a random goal is a competent planner. The conflicts are caused by wrong beliefs about intent, not by weak policies. That result stands regardless.
[G] I score that to the optimist, and I would go further. It is the most transferable finding in the paper. It generalizes past this simulator to any system that acts on an inferred objective. A confidently wrong collaborator is worse than no collaborator, and the paper quantifies the "worse" at 40 percent of episodes.
[S] Then here is my sharper objection, and it is about what got validated. The paper names social perception first. Watch, then help. But the real-human validation is entirely on the Help stage. Every demonstration the goal inference model ever sees, in training and in testing, comes from the same bounded-rational planner playing Alice.
[G] That is correct and it is the gap I would most want closed. The realism study checks that the synthetic trajectories look human to raters. It does not check that a model trained on synthetic demonstrations can still infer a goal from a demonstration a real person produced. And people were in the system, driving Alice, in experiment one. Those trajectories existed.
[S] So the experiment was one analysis away.
[G] It was, and the paper does not run it. The perception half of a challenge named for perception is validated only indirectly.
[O] What else would you want?
[G] Three things. An ablation isolating why the low-level policy fails to deliver objects, which would turn the planning-versus-learning comparison into a fair fight. Goal inference tested on real human demonstrations. And effect sizes or confidence intervals next to those paired tests, because several "no significant difference" conclusions sit at p between point one and point two with thirty paired observations. HP at p equals point one is not a tight replication. It is an underpowered test that failed to reject.
[S] Which matters because the whole scalability argument is "train and test against the cheap synthetic agent, spot-check with humans." That argument needs the equivalence to be established, not merely un-rejected.
[G] Agreed, and I would say the paper's own conclusion is slightly stronger than its statistics.
[O] One more thing I want on the record, because it connects to how we evaluate agents now.
[G] The qualitative analysis. There is a figure cataloguing behaviors the metrics do not capture. Bob avoiding a collision over a shared fork. Bob helpfully opening a cabinet and improving Alice's belief. Bob physically blocking a doorway. And Bob inducing a false belief in Alice by moving an object she had already seen and placed.
[S] And none of those register as anything except step count.
[G] Correct. An agent that blocks its partner in a hallway and an agent that is merely slow score identically. There is no distinct harmful-collaborator signal in the metric. For anyone building agentic evaluations today, that is the structural lesson. Aggregate task metrics absorb qualitatively different failures into the same number.
[O] Also worth saying, all of this runs on ground-truth symbolic state within the field of view, not pixels.
[G] The authors are explicit that one could use raw pixels instead, and the environment renders RGB, depth, segmentation, skeletons, the lot. But the reported numbers are symbolic-state social perception. Not visual. That is a design choice, clearly stated, and it does bound what the results say.
[S] Fine. Takeaway from me. This is a well-built environment and a genuinely good task design, wrapped around a baseline comparison that is too loose to tell you how much headroom is left. Take the framing, take the conflict result, discount the leaderboard.
[O] Mine is the opposite emphasis. The two-stage watch-then-help structure plus a working interface for real humans is the thing almost nobody had built, and it is why this paper is still upstream of embodied Theory-of-Mind evaluation six years later. The framing outlived the baselines, which is what you want from a benchmark.
[G] And the paper's own, which I would put this way. Machine social intelligence decomposes into inferring a goal and acting on it, those halves are coupled, and the coupling is asymmetric. Good perception plus decent planning helps. Decent planning plus bad perception is actively destructive, in 40 percent of episodes, and 65 percent in the worst categories.
[O] The full writeup is on the litsearch site, with the figures, the ablation table, and the eval-rigor read. Thanks Soren.
[G] A pleasure.
