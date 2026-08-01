---
slug: james-2020-rlbench
title: "RLBench: The Robot Learning Benchmark & Learning Environment"
description: "A manipulation benchmark of one hundred hand-designed tasks with an unlimited supply of motion-planner demonstrations — and a preprint that reports no learned-agent results at all."
date: 2026-07-31
guest_name: "Fabian"
guest_voice: "bm_fable"
---
[O] Here is a paper cited roughly nine hundred and ninety-six times that contains not one experimental result. No score, no reward curve, no success rate, for any learned agent, on any task.
[S] My first instinct is that this is a red flag. I came around to it, partly, and I want to be honest that the coming around was work.
[O] Mine went the other way. I think it is the cleanest example we have covered of a paper whose whole contribution is infrastructure, and I think we systematically undervalue that.
[G] You are both describing the paper accurately, which does not happen often. It is a proposal. The only interesting question is whether it proposed well.
[O] Welcome to Litsearch Audio. Today we are on RLBench, The Robot Learning Benchmark and Learning Environment, by Stephen James, Zicong Ma, David Rovick Arrojo, and Andrew Davison, from the Dyson Robotics Lab at Imperial College London.
[S] Published in I triple E Robotics and Automation Letters — R A L — in twenty twenty, with the preprint posted to arXiv in September twenty nineteen.
[O] And we have Fabian with us, who knows this paper and the literature that grew on top of it. Welcome.
[G] Thank you. Can I plant a flag before anything else, because it governs the rest of the conversation?
[O] Go ahead.
[G] This preprint reports no learned-agent results at all. There is no experiments section, no results section, no evaluation section under any heading. There is not a single table in the entire document. No figure and no caption carries a numeric result for any method. If you scan the text, the words experiment, baseline, success rate, and ablation do not occur even once. Anyone describing an RLBench leaderboard from this paper is describing a different paper.
[S] That is a stronger statement than I expected. Not thin results. Zero.
[G] Zero. And one caveat that scopes every criticism we are about to make. arXiv carries only version one, from September twenty nineteen. That is the preprint. The published R A L version from twenty twenty is a separate, later camera-ready that was not accessible for this reading. So when we say the paper omits something, we mean the preprint omits it. The journal version may well have added things, and I am not going to pretend otherwise.
[O] Noted, and I want that carried through the whole episode, not just parked here.
[S] Then let us start with why anyone thought a new manipulation benchmark was needed in twenty nineteen.
[G] The paper's argument has two halves. First, continuous-control reinforcement learning already had standard benchmarks — OpenAI Gym and the DeepMind Control Suite — and the authors are blunt about them. They call them, and I am quoting, toy-benchmarks, and they say their focus is not on real-world problems, and that algorithms tuned there often do not scale to more complex, real-world tasks.
[O] That is a strong swipe for a related-work section.
[G] It is. The second half is sharper and, to me, the better argument. Manipulation had no standard at all. So every group built its own task set alongside whatever method it was proposing. The paper's own phrasing is that a method could fail on a more challenging task, and so results would only be presented for a simpler set of tasks.
[S] Which makes the task set a hyperparameter of the result. That is a genuinely serious methodological point and I will grant it immediately.
[O] And it is the argument for a benchmark that nobody involved has an incentive to tune.
[G] There is a third thread running underneath, which is few-shot learning for robotics. The paper says the existing few-shot work — including the authors' own prior work — used a very narrow definition of task. Their example is that placing a peach into a red bowl and placing an apple into a green bowl get counted as two different tasks, when they are obviously two settings of one task.
[S] So the field was inflating its task counts by calling variations tasks.
[G] That is the claim, and it sets up the taxonomy we will get to shortly.
[O] What about existing benchmarks that were closer to what RLBench wanted to be?
[G] Two get named specifically, and I want to be careful here, because the paper gives fewer comparison numbers than people assume. On RoboTurk, an imitation-learning benchmark built by crowdsourcing demonstrations, the paper says the system has only three tasks, and it says that is a direct consequence of crowdsourcing being expensive. On Simitate, a hybrid real-and-simulated benchmark using an R G B D camera calibrated against a motion-capture system, the paper says the addition of new tasks requires time-consuming calibration and motion capturing.
[S] Those are the only two prior task counts?
[G] Three is the only prior task count the paper prints anywhere. It never says what the field's typical task count was, it never calls any number the norm, and it gives no range. If you hear someone quote a range of prior benchmark sizes, that did not come from this paper.
[O] So the entire diagnosis reduces to one thing: demonstrations are expensive, so task suites stay small.
[G] Yes, and the fix follows directly. Decouple the number of tasks from the cost of demonstrations. Do not pay a human, do not run a motion-capture rig. Script the solution once at authoring time with a motion planner, and after that demonstrations are free and unlimited.
[S] Free and unlimited is exactly the kind of phrase that should make us look at what got traded away, and I want to come back to that hard.
[O] Hold it for the debate. Fabian, walk us through what actually ships.
[G] The environment is built on V REP, which later became CoppeliaSim, through PyRep, a robotics toolkit from the same group. There are one hundred tasks, described in the abstract as one hundred completely unique, hand-designed tasks, and every one of them loads into an identical scene. A Franka Emika Panda seven DoF arm bolted to a wooden table, surrounded by three directional lights, watched by an over-the-shoulder stereo camera and an eye-in-hand monocular camera. Both supply R G B, depth, and segmentation masks every frame, alongside proprioception — joint angles, velocities, torques, and end-effector pose.
[O] One scene for all one hundred tasks. That is a real design commitment.
[G] It is the commitment that makes cross-task transfer even askable. And there is a deliberate difficulty choice inside it. Every episode starts with the gripper empty. So a task that uses a tool has to grasp the tool first, rather than starting pre-grasped the way a lot of prior setups did. The paper's justification is that household robots will one day work under such conditions.
[S] That is a harder setting than most contemporaneous work, and I will give them credit for taking the harder one on purpose.
[G] The reward is completely sparse. Plus one on task completion, nothing otherwise. And the action space is a menu — five categories, each offered in an absolute and a delta form, so ten selectable options. Joint velocities, joint positions, joint torques, end-effector velocities, and end-effector poses.
[O] Now the taxonomy, because you said it governs how to read every downstream result.
[G] Three terms, and they must not be merged. A task is a set of variations. Each variation can be sampled for an unlimited number of episodes. Across variations, the paper says, usually target objects or colours are changed. Across episodes, positions are changed.
[S] Give me the concrete case, because that is where these definitions usually go soft.
[G] Figure four does it on the stack blocks task, and the strings are printed inside the figure image rather than in the body text. Variation zero is, quoting exactly, stack one red block on the target. Variation one is stack two red blocks on the target. Variation two is stack three red blocks on the target. So the first three variations vary the count.
[O] And the last one shown?
[G] The last column in the figure is labelled variation V, and it reads stack one maroon block on the target. So that one holds the count at one and varies the colour instead. Which tells you a single task's variation list can change different attributes between different pairs of variations.
[S] And V is a symbol, not a number.
[G] Correct, and this matters. V and E in that figure stand for arbitrary totals. The paper never prints a total variation count, not for stack blocks and not across the suite. So one hundred tasks is a task count. It is not a variation count, and nobody should convert between them.
[O] There is a language piece here too that I think gets underrated.
[G] Each variation ships a list of natural-language descriptions of its goal. In figure four you can see several per variation — alongside stack one red block on the target there is place one of the red blocks on the target, and build a tower out of one red block, and set one red cube on the target. The stated aim is to open the benchmark to human-robot-interaction and natural-language work, not just control.
[S] In twenty nineteen. That is genuinely forward-looking, and it aged well.
[O] How do the demonstrations get made?
[G] There is an expert algorithm, written pi-star, built on the Open Motion Planning Library. When someone authors a task they place a series of waypoints, and the planner executes them. That is the whole demo generator. Authoring a new task means a scene file plus a Python file wiring up the success conditions, and then a validation tool re-collects demonstrations to check the planning side holds up before the task can go into the public repository by pull request.
[S] What is the bar the validation tool enforces?
[G] That the path planning only fails a small number of times. Those are the paper's words, and that is the whole specification. No threshold, no number.
[S] For a benchmark explicitly designed to grow through community submissions, that is a soft gate, and I am going to bank it.
[O] Fair. So then what is in the paper instead of results?
[G] A specification, a challenge protocol, and exactly one quantitative characterisation of the suite itself — figure seven, which is two histograms. Neither one is about a learned agent. They describe the benchmark's own shape.
[O] Take the top one.
[G] Word frequency across the variation descriptions, with function words stripped out so only content words remain. Reading the bars in order, and these are chart readings rather than printed figures, the top eight are: open at about forty-eight, put at about forty-three, table at about thirty-three, slide at about thirty-one, place also around thirty-one, cup at about thirty, pick at about twenty-eight, and take at about twenty-six.
[S] So the suite's vocabulary is open, put, place, pick, take. That is a pick-and-place benchmark with doors and drawers attached.
[O] That is a fair read of the histogram, but I want to say plainly that the paper does not make that argument. It presents the chart descriptively. The inference is ours.
[G] That is the right distinction and I want to hold both of you to it. The paper never uses figure seven as evidence for or against its own diversity claims.
[S] And the second histogram?
[G] Average episode length for a sample of seventy-five of the one hundred tasks, first variation only, averaged over five demonstrations each. The caption states the range explicitly — task lengths vary from one hundred to one thousand timesteps. That range is printed. The individual bar heights are not.
[O] What is the shape?
[G] Heavily skewed. Most tasks cluster short, with a small tail of long-horizon ones. Set the table is the longest bar, close to the one-thousand ceiling. Reach target is essentially the shortest. And the caption gives a nice decomposition of what long means here — the empty dishwasher task involves opening the washer door, sliding out the tray, grasping a plate, and then lifting the plate out of the tray.
[S] So the difficulty tiering they claim as a design goal is at least visible in the data.
[G] Visible, yes. Measured against a stated coverage metric, no.
[O] Then the challenge protocol. This is the one thing that is actually specified.
[G] The RLBench Few-Shot Challenge, version one point zero. Ten percent of the one hundred tasks are held out as the meta-test set, spanning a range of difficulties. The rest are meta-train, and the splits go on the benchmark webpage. At test time the system gets K demonstrations of an unseen task and must succeed on new episodes of it. The paper asks people to report one-shot, five-shot, and twenty-shot results.
[S] And the isolation condition?
[G] Stated directly. There must be no prior knowledge of the unseen tasks given to the system beyond what is in the training tasks. And they version it one point zero on purpose, because they expect the task count to grow and want results to stay comparable within a version.
[O] Which is good benchmark hygiene, and rarer in twenty nineteen than it should have been.
[S] Agreed, genuinely. Now here is my problem, and Fabian I want you to check me on it. Section six proposes five more things RLBench could be used for. Reinforcement learning, imitation learning, sim-to-real, multi-task learning, and SLAM. How many of those five come with a protocol?
[G] None of them. Not one of the five states a train-test split, a metric, a success criterion, or a named baseline. They are one paragraph each. The multi-task paragraph is the clearest case — it says all tasks from both meta-training and meta-testing can be used during training, and then stops. It never says which tasks, how many, or what counts as success.
[S] So a multi-task RLBench result is not reproducible from this document, whereas a few-shot one is.
[G] In the preprint, correct. That is the sharpest fair criticism available, and it is the one I would lead with. And it stays scoped to the preprint.
[O] Let me make the optimist case, because I do not think any of that is fatal. Proposing infrastructure is a legitimate research contribution. The paper is honest about being a proposal — it says outright that it looks forward to seeing how existing few-shot methods perform on this benchmark. It is not smuggling in an empirical claim. And the field voted with its feet: nine hundred and ninety-six citations, and a lineage running through LIBERO and the benchmarks after it.
[S] I will concede the honesty point completely. There is no overclaiming here, and that is worth something. But citations measure adoption, not correctness of design. What I actually worry about is baked in silently and shapes everything built on top.
[O] Name the worry.
[S] Every demonstration for a given task and variation comes from one motion planner executing waypoints that one author placed. That is one solution style per task. It is not sampled from a distribution of viable solutions and it is not a human's. So an imitation-learning method trained on RLBench is being scored on how well it reproduces the planner.
[G] That is accurate, and I will score it to the skeptic. The paper is explicit that this is the trade it is making for infinite free demonstrations. What it does not do is discuss whether planner trajectories resemble what a real robot or a teleoperator would produce. That question is simply not raised.
[O] Which is the closest thing this benchmark has to a contamination problem, even though there is no scraped training data anywhere near it.
[G] Exactly the right analogy. Not data leakage. Solution-style leakage.
[S] Second worry. Diversity is asserted, never measured. Section three lists design goals — diversity, reproducibility, scale, extensibility, tiered difficulty, realism — and the diversity one says a truly diverse range of tasks is needed. But there is no skill taxonomy, no count of multi-object versus single-object tasks, no inter-task similarity measure. Nothing that would distinguish a genuinely spanning suite from one hundred things that happened to be easy to script with a waypoint editor.
[G] I score that one to the skeptic as well, with a note. The word-frequency histogram is the closest thing to relevant evidence, and it points slightly against the claim. But again, the paper does not offer it as evidence either way.
[O] Then let me take the one where I think the paper deserves credit rather than criticism. On realism, it says flatly that it cannot claim full photorealism in its rendering system, or general realistic physics. That is a paper declining to oversell itself in the exact place where overselling would have been easy.
[S] I will take that. Though it also means the sim-to-real story is an offer, not a result. There is a domain-randomisation rendering option, and an arm you can swap out with one line of code, and no sim-to-real experiment anywhere in the document.
[G] Both true simultaneously, and I think that is the honest summary of the whole paper. Every capability it describes is a capability it has built and not yet exercised.
[O] There is one piece of history here I love, and I want you to tell it, Fabian.
[G] RLBench and Meta-World were essentially simultaneous. RLBench went up in September twenty nineteen, Meta-World in October. And RLBench's related work section has a parenthetical acknowledging, quoting, the very recently announced Meta-World project — and then saying that full documentation describing the aims of that project is not available at the time of writing.
[S] So they could not read it.
[G] They could not read it. The citation in the bibliography points at Meta-World's website, because there was no paper yet to point at. And Meta-World's later revision cites RLBench back.
[O] Two groups reaching the same conclusion about the same gap, within a month, without being able to read each other. That is about as clean a signal as you get that a gap was real.
[S] I will grant that entirely. Convergent discovery is decent evidence, and it is the strongest argument in the episode for RLBench's premise, even though it is not evidence about RLBench's execution.
[G] That is precisely the right split, and I would leave it there.
[O] So what should someone take from this for evaluation practice more broadly?
[S] Mine is a reading discipline. When a benchmark paper reports nothing, every difficulty claim about it comes from somewhere else, and you should go find out where. How hard is RLBench is not a question this paper answers, or tries to.
[G] Mine is about counting units. Task, variation, episode are three different things, and this paper defines them carefully and then, notably, does not print a total variation count. Any downstream comparison that treats a variation count as a task count is comparing nothing to nothing. That failure mode is exactly what the paper was complaining about in the few-shot literature, so it would be a shame to reintroduce it here.
[O] And mine is that infrastructure papers should be judged on whether the thing works and gets used, not on whether they include a results table. This one built a scene, a taxonomy, a demonstration generator, an authoring toolkit, and one fully specified protocol, then handed all of it over. That is a real contribution and I do not want the absence of a table to obscure it.
[S] The absence of a table is fine. The absence of a protocol for five of the six proposed uses is the thing I would actually fix — and I say that about the preprint, because that is the version we could read.
[G] The paper's own takeaway, in one line: RLBench is a specification and a toolkit, not a finding, and it says so about itself with unusual clarity.
[O] Figures, the exact quotes, and the full critique are in the writeup on the litsearch site. Fabian, thank you.
[G] My pleasure.
