---
slug: yu-2019-meta-world
title: "Meta-World: A Benchmark and Evaluation for Multi-Task and Meta Reinforcement Learning"
description: "Fifty Sawyer-arm manipulation tasks, six evaluation protocols in two different families, and seven algorithms that mostly fail — plus a table that disagrees with its own figures."
date: 2026-07-31
guest_name: "Marlowe"
guest_voice: "af_bella"
---
[O] Fifty distinct robot manipulation tasks, one arm, one action space, one observation format. That is a benchmark you can actually build a general manipulation policy against, and nobody had one before this.
[S] And the headline result is that seven state-of-the-art algorithms could not learn ten of those tasks at the same time. The paper's own abstract says these methods, quote, struggle to learn with multiple tasks at the same time, even with as few as ten distinct training tasks.
[O] Which is exactly what a good benchmark is supposed to do on day one. If everything saturated immediately you would have built a weak benchmark, not a strong field.
[S] Agreed, actually. My worry is not the failure. My worry is that this paper defines six evaluation protocols in two completely different families, and I think most people who cite it cannot tell you which one a given number came from.
[O] Welcome to Litsearch Audio. Today we are on Meta-World, a benchmark and evaluation for multi-task and meta reinforcement learning, by Tianhe Yu, Deirdre Quillen, Zhanpeng He, Ryan Julian, Avnish Narayan, Hayden Shively, Adithya Bellathur, Karol Hausman, Chelsea Finn and Sergey Levine, out of the third Conference on Robot Learning, twenty nineteen.
[S] It sits at roughly seventeen hundred citations, which makes it the most-cited paper this project has covered. That is part of why it is on the docket. A paper that heavily cited gets summarized a lot, and summaries drift.
[O] Marlowe, welcome. You have spent real time inside this one.
[G] Thank you. And before we touch a single number, there is a housekeeping fact that matters more than it sounds. If you pull the PDF from the arXiv identifier, you do not get the CoRL camera-ready. You get version two, posted in June of twenty twenty-one, almost two years later.
[S] How do you know what changed?
[G] You do not. That is the point. The first page carries exactly one sentence about it: quote, this manuscript is an update on a manuscript that appeared at the third Conference on Robot Learning, CoRL twenty nineteen, Osaka, Japan. There is no changelog, no erratum, no list of revisions anywhere in the document. I swept the full text for that language and found nothing beyond that one line.
[O] So every number we say today is a version two number.
[G] Every number we say today is a version two number, and none of us can tell you whether it matches what was presented in Osaka. I would rather say that plainly than guess.
[S] Good. Let us do the problem statement, because the motivation here is sharper than the usual we need a benchmark boilerplate.
[G] The authors describe two unsatisfying extremes in twenty nineteen. On one side, multi-task reinforcement learning was mostly evaluated on Atari, which is genuinely diverse but shares almost nothing across games. The paper says, quote, many prior multi-task learning methods have observed substantial negative transfer between the Atari games. Learning one game actively hurts you on another.
[O] Which kills the whole premise. Multi-task learning is supposed to be cheaper than single-task learning. If transfer is negative, you would be better off training separately.
[G] Right. And on the other side, meta reinforcement learning was evaluated on very narrow parametric families. The paper's example is choosing different running directions for simulated legged robots. Their verdict on that, quote, while these are technically distinct tasks, they are a far cry from the promise of a meta-learned model that can adapt to any new task within some domain.
[S] So diversity without shared structure, or shared structure without diversity.
[G] Exactly the tension. Meta-World's contribution is a task suite that sits in the gap. Fifty manipulation tasks, all executed by the same simulated Sawyer arm, in MuJoCo, behind a Gym-compatible interface built on the Multiworld environment library. Same robot, same workspace, same action space, genuinely different objectives.
[O] Give me the interface details, because this is the part that makes it usable as infrastructure rather than a paper artifact.
[G] The action space is described in the paper as a two-tuple: the change in the end effector's three-D position, followed by a normalized torque the gripper fingers should apply. Every component ranges between negative one and one. Identical in shape on every task.
[S] And observations?
[G] Fixed. The paper's sentence is, quote, the observation space is always thirty-nine dimensional. It packs end effector position and gripper state, first and second object position and orientation, a copy of that same block holding the previous timestep, and the goal position. If a task has no second object, or if the goal is deliberately withheld, those slots are zeroed rather than the vector being reshaped.
[O] That zero-padding choice is the whole trick for a single multi-task policy. One network, one input shape, fifty tasks.
[S] What about rewards? Hand-shaped rewards across fifty tasks is where I start getting suspicious.
[G] They are hand-engineered, and the authors are open about it. They compose them from shared reaching, grasping and placing components, and they normalize magnitudes deliberately. The stated goal is that, quote, reward functions across all tasks have a similar magnitude that ranges between zero and ten, where ten always corresponds to the reward function being solved.
[S] So the reward is shaped and comparable. What is the reported metric, then? Because if they report reward I am going to be unhappy.
[G] They do not. Success is scored separately and much more strictly. Appendix Table twelve defines, per task, a binary indicator, usually that the tracked object is within a fixed Euclidean distance of its target. The thresholds vary by task, roughly from two centimetres out to twelve. A handful of tasks use a different geometric criterion instead of a raw distance, hammer and lever-pull and disassemble among them.
[O] Binary success, not shaped reward. That is the right call for cross-method comparison.
[S] It is the right call, and it is also lossy, but let us come back to that. Marlowe, the protocols. This is the thing I said I was worried about at the top.
[G] Then let me be very precise, because this is where readings of this paper go wrong. The paper's own words are, quote, we hence divide our evaluation into five categories. Those categories produce six named protocols, and they split into two families that are solving fundamentally different problems.
[O] Family one.
[G] Family one is meta-learning. M L one, M L ten, M L forty-five. The task identity is not given to the policy. The policy meta-trains on a set of tasks, and then at meta-test time it is dropped into a task it has never seen and has to adapt from a few trials of experience. Generalization to new tasks is the whole point.
[S] Family two.
[G] Family two is multi-task. M T one, M T ten, M T fifty. The policy is handed a one-hot task identifier as input, it trains on all the tasks jointly, and it is evaluated on those same tasks. There is no held-out task set at all. It is a capacity and interference question, not a generalization question.
[O] So M L ten and M T ten are not the same experiment with a different algorithm.
[G] They are not even the same problem. Different task counts, different splits, different baselines, different quantity being measured. If you take a number from the meta-learning table and read it as a multi-task number, you have said something false. That is the single easiest mistake to make with this paper.
[S] Walk the ladder for me, smallest to largest.
[G] M L one is few-shot adaptation to goal variation within a single task. They run it on three individual tasks: reach, push, and pick and place. Meta-train on fifty random initial object and goal positions, meta-test on fifty held-out positions of that same task. Critically, the goal is not in the observation, so the policy has to find it by trial and error.
[O] That is the easy rung. Same task, new goal.
[G] The easy rung by design. M T one is its multi-task mirror: one policy over fifty goal positions of a single environment, and here the goal is provided in the observation. No generalization is tested.
[S] And M T one's results?
[G] There are none. The paper defines M T one and never reports a number for it. I checked every mention of that string in the full text, and both hits are inside the definition paragraph.
[S] That is worth saying out loud, because five categories sounds like five result sets.
[G] It is five categories, six named protocols, and not all of them carry reported results. M L one does have results, but as figures rather than table cells. Figure four gives M L one maximum success rates on ten seeds for reach, push and pick-place, and appendix figures twelve through fourteen give the learning curves. The headline Table one covers M T ten, M T fifty, M L ten and M L forty-five only.
[O] Then the big four. M T ten and M T fifty, ten and fifty environments trained jointly.
[G] Yes, with the one-hot task identifier as input. And M L ten and M L forty-five: meta-train on ten or forty-five tasks, meta-test by few-shot adaptation on five held-out tasks never seen in meta-training, with no task identifier given.
[O] So M L forty-five is just M L ten with thirty-five more training tasks.
[G] No. And this is the second trap, and it is a real one.
[S] Go on.
[G] The two protocols do not share a split. M L ten holds out door-close, shelf-place, drawer-open, sweep-into, and lever-pull. M L forty-five holds out bin-picking, door-unlock, hand-insert, door-lock, and box-close. Those two sets of five are completely disjoint. Not one task in common.
[O] Wait. So where do M L ten's held-out tasks live in M L forty-five?
[G] In the training set. All five of M L ten's test tasks appear in M L forty-five's forty-five training tasks. I read that off the figure axes directly. So M L forty-five is not a harder version of M L ten with the same evaluation. It has its own held-out five, and M L ten's held-out five lose their held-out status entirely.
[S] Which means a cross-protocol comparison of meta-test scores is comparing performance on two different task sets.
[G] Correct, and you should hold that thought for the results.
[O] One small thing while we are on the figures. There is a labelling wobble, isn't there.
[G] A trivial one. The image in figure three labels one task simply sweep, where figure six's axis says sweep-into. Nothing turns on it, but the writeup flags it so a reader cross-referencing the two does not think they have found a third task.
[S] Baselines. Seven algorithms, the abstract says.
[G] Seven, all run in Garage, the reinforcement learning library the authors developed alongside the benchmark. On the multi-task side: multi-task P P O, multi-task T R P O, multi-task S A C, each given the one-hot task identifier, plus an on-policy version of task embeddings, T E P P O, which parameterizes policies through a shared skill embedding space.
[O] And the meta side.
[G] R L squared, which is a recurrent network with hidden state carried across episodes within a task, trained with P P O. MAML, gradient-based meta-learning that embeds policy gradient steps into the meta-optimization. And PEARL, an off-policy actor-critic that encodes experience into a probabilistic task embedding fed to both actor and critic.
[S] I have seen MAML in this paper labelled two different ways.
[G] You have, and it is genuinely ambiguous in the document. The body prose on page seven says MAML is trained with P P O. But every figure legend calls it MAML-T R P O, and the MAML hyperparameter table lists a max K L step, which is a trust-region parameter. So the figures and the hyperparameters say T R P O and the prose says P P O. I would state both and not pick a winner, because the paper does not.
[O] Before results, there is a sanity check I liked. They verify the tasks are individually solvable.
[G] They do, in appendix B. Independent single-task P P O and S A C policies, three seeds each, trained per task across all fifty. The finding is, quote, S A C can solve all of the tasks and P P O can also solve most of the tasks. And they are careful to say it is validation only, quote, not an official evaluation protocol of the benchmark.
[S] That framing matters. It establishes that the failures we are about to discuss are multi-task and meta-learning failures, not the tasks being impossible.
[O] Okay. Numbers. Multi-task first.
[G] Table one, average maximum success rate over all tasks, on ten seeds. On M T ten: multi-task S A C reaches sixty-eight point three percent. Multi-task T R P O, thirty-one point three. Multi-task P P O, thirty point five. Task embeddings, twenty point nine.
[O] S A C more than doubles the field.
[G] On M T ten, yes. Now M T fifty, five times the task count. S A C falls to thirty-eight point five. T R P O falls to twenty-one percent. Task embeddings falls to eleven point eight.
[S] And P P O falls to what?
[G] P P O rises. Thirty point five on M T ten to thirty-five point four on M T fifty.
[S] Say that again.
[G] Multi-task P P O is higher on the fifty-task benchmark than on the ten-task benchmark. So the tidy story that everything degrades as you add tasks is not what the table says. Three methods drop, one goes up.
[O] Why would more tasks help?
[G] The paper does not decompose that, so I will not invent a mechanism. What I can say is that these are different task sets, not nested difficulty levels, and the metric is a maximum over the training curve, which we should get to.
[S] Now, I have read that S A C wins M T fifty. I have also read that P P O wins M T fifty. Which is it?
[G] Both, depending on which part of the paper you are holding, and the resolution is more interesting than a mistake.
[O] Explain.
[G] Table one's printed cells put multi-task S A C at thirty-eight point five against multi-task P P O's thirty-five point four. S A C ahead. But figure seven's caption says the opposite: that S A C's M T ten lead does not scale, and quote, M T P P O exhibits the better performance in this benchmark.
[S] So the caption contradicts the table.
[G] The caption agrees with the chart it is captioning. Someone measured figure seven's own average bars against its printed axis. M T S A C comes out around forty-one. M T P P O comes out around forty-eight. The bars back the caption, not the table cells.
[S] How much do I trust a bar measurement?
[G] It was calibrated first. The same method applied to figure six reproduces Table one's M L ten column to within about two tenths of a point on all three algorithms. So the reading technique is sound. What it shows is that Table one's multi-task cells are systematically a different statistic from the average bars in figures five and seven, in the same direction on both.
[O] So Table one is not wrong, it is measuring something else.
[G] That is the honest framing. And figure sixteen's caption supplies the mechanism directly. It reads, and I am quoting including the paper's own typo, quote, M T S A C vastly outperforms is on-policy counterparts in sample efficiency. Its performance tapers off, and with more training, M T P P O outperforms it.
[S] There it is. S A C spikes early and decays. P P O climbs slowly and passes it.
[G] So which method a peak-crediting statistic calls the winner depends on where in training each method's own peak happens to land. And I want to be careful here: a reader following the captions and the charts would reach the correct conclusion about the crossover. The captions, the bar charts and the seed-sensitivity curves all tell one consistent story. Table one's cells are the outlier among the paper's own artifacts.
[O] Meta-learning side.
[G] M L ten, meta-train then meta-test. R L squared: eighty-six point nine percent on training tasks, thirty-five point eight on the five held-out ones. MAML: forty-four point four training, thirty-one point six test. PEARL: twenty-three point two training, thirteen percent test.
[O] R L squared's training number is enormous.
[S] And its test number is a third of that. That is the largest train-test gap in the paper, and it reads to me like memorizing the training tasks rather than learning an adaptable prior.
[G] The figure six caption puts it more gently but does not disagree: quote, R L squared shows the highest performance on the training tasks, eighty-six point nine percent, however its ability to generalize is not that much greater than MAML, thirty-five point eight percent for R L squared and thirty-one point six percent for MAML.
[S] Twice the training score, four points of test advantage.
[G] Now M L forty-five, and remember, different held-out five. R L squared: seventy percent train, thirty-three point three test. MAML: forty point seven train, thirty-nine point nine test. PEARL: fourteen point five train, twenty-two percent test.
[O] PEARL goes up from train to test?
[G] It does, and the paper notices. The figure eight caption says, again with the paper's own spelling, quote, though PEARL has week training performance, it has comparable performance on test tasks. Week spelled like the calendar. It is a typo for weak.
[S] Which is a strange result to leave unexplained. Test above train on a held-out set usually means the held-out tasks are easier, not that the method generalizes better.
[G] The paper does not resolve it, and I will not either. What it does report elsewhere is that PEARL's weakness may be difficulty training its task encoder, which is the figure four caption's read on the M L one results.
[O] One more discrepancy I want on the record.
[G] Yes. There is a body sentence on page seven that says the prior meta-RL methods, MAML and R L squared, reach thirty-five percent and thirty-one percent on M L ten test tasks. That pairs the algorithms with the numbers in the opposite order from Table one and from the figure six caption, both of which give MAML thirty-one point six and R L squared thirty-five point eight. Table one and the caption agree with each other. That one sentence is the odd one out. Use the table's pairing.
[S] Let me put the deflationary case, then. This paper's headline metric is average maximum success rate over the training curve, on ten seeds, with binary threshold-crossing success. Every one of those choices is generous.
[O] Make the specific charge.
[S] Maximum over the curve credits a method for a peak it hit at any point, even if the policy later fell apart. We just saw that happen to M T S A C. Ten seeds is few enough that a lucky spike survives into the headline. And a binary threshold means two policies that both pass can differ arbitrarily in efficiency, smoothness, or margin, and the metric cannot tell you.
[O] And no error bars on Table one.
[G] Careful. Table one carries no dispersion. The paper does report variance.
[S] Where?
[G] Appendix C. Figures fifteen through eighteen are titled seed sensitivity, with n equals ten, and they plot shaded across-seed bands for the same runs. In figure fifteen, M T S A C's band sits at roughly sixty to sixty-eight percent, and it is disjoint from the roughly five to twenty-five percent bands of the other three multi-task methods.
[O] So the M T ten gap is not seed noise.
[G] It is not. And that is exactly the kind of thing you can only say because the dispersion was reported. The accurate criticism is narrower than no variance: it is that the headline table alone carries no uncertainty, and the reader has to go to appendix C to find it. That is a presentation complaint, not a rigor complaint.
[S] I will take the correction. That is a meaningfully weaker charge than the one I would have made from the table alone.
[O] Score one to the paper.
[S] Then here is my charge that survives. Task selection for the held-out sets. Section four point three says, quote, we randomize object and goals positions and intentionally select training tasks with structural similarity to the test tasks.
[G] That is verbatim, yes.
[S] So the generalization being measured is generalization to tasks hand-picked to resemble what the policy already saw. And the paper's framing repeatedly says entirely new tasks. Those are not the same claim.
[G] I think that critique lands, with one caveat in the authors' favour. A completely unrelated held-out task would make few-shot adaptation near-impossible for any method, and you would learn nothing from a floor of zero. Structural similarity is a defensible design choice. What is missing is any quantification of how similar, so a reader can calibrate what the meta-test number means.
[O] Let me make the optimist case, because I think it is stronger than the numbers make it look. The contribution here is not the baselines. It is that somebody finally built a task suite where diversity and shared structure coexist. Same arm, same action space, same thirty-nine dimensional observation, fifty qualitatively different objectives, each with its own parametric variation in object and goal position.
[G] That distinction is the real design insight, and it is worth stating carefully. All reach-the-puck tasks, for any puck position, are one task with continuous parametric variation. Reach-the-puck versus open-the-window is non-parametric: no continuous parameter interpolates between them. Prior meta-RL benchmarks only ever exercised the parametric case within a single task. Meta-World gives you fifty non-parametrically distinct tasks that each still carry parametric variation.
[O] And that is why the failure result is credible rather than a strawman. The tasks are individually solvable, single-task S A C does them, and the multi-task and meta methods still cannot hold ten at once.
[S] I will grant that. If the tasks were unsolvable the result would be uninteresting. Appendix B closes that hole.
[G] The authors' own summary is blunt: quote, despite some impressive progress in multi-task and meta-reinforcement learning over the past few years, current methods are generally not able to learn diverse task sets, much less generalize successfully to entirely new tasks.
[O] And their diagnosis of where the difficulty lives?
[G] This is the line I find most useful. They note that even meta-training performance, before any generalization is asked of the policy, has considerable room for improvement, and they read that as evidence that, quote, optimization challenges are generally more severe in the meta-learning setting.
[S] Which is a different bottleneck than everyone assumed. The story people tell is that meta-RL fails to generalize. The paper is saying it also fails to fit.
[O] That reframes what to work on. Fix the optimization before you blame the generalization gap.
[S] What does this mean for evaluation practice generally? Because that is the thread this show keeps pulling.
[G] Three things, and only the first is about robots. One: benchmark design has an axis people underweight. Diversity and shared structure are usually traded off, and Meta-World's contribution is showing you can hold both if you fix the interface.
[O] Two?
[G] Two: name your protocol next to every number. This paper has six protocols across two families, and the most likely error a citing paper makes is reading a meta-learning number as a multi-task number, or an M L ten number as an M L forty-five number. Those are different task sets with different held-out splits. A number without its protocol and its train-or-test label is not a number.
[S] And three.
[G] Three: peak-crediting statistics change rankings. Table one and the paper's own figures order the M T fifty methods differently, and the reason is that a maximum-over-training statistic and an end-of-training comparison genuinely measure different things. Neither is wrong. But if your leaderboard credits a best-ever checkpoint, you are ranking by luck of the training curve as much as by method quality.
[O] Takeaways. Marlowe, the paper's.
[G] The paper's takeaway is that fifty tasks on one arm expose a failure the field had not measured: current multi-task and meta reinforcement learning methods cannot learn diverse task sets, and the binding constraint may be optimization rather than generalization.
[O] Mine: this is what infrastructure looks like. Seventeen hundred citations later, the reason people still use it is not the baselines, it is that the interface was designed so a single policy could be pointed at all fifty tasks without reshaping anything.
[S] Mine: the result is real and the failure is credible, because the tasks were shown to be individually solvable. But treat Table one as an ordering, not as precise figures, and never quote one of its numbers without saying which protocol it came from and whether it is train or test.
[O] The full writeup is on the litsearch site, with the figures, the protocol definitions side by side, and the table-versus-chart discrepancy laid out in detail. Thanks, Marlowe.
[G] My pleasure.
