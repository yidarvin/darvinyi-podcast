---
slug: mu-2021-maniskill
title: "ManiSkill: Generalizable Manipulation Skill Benchmark with Large-Scale Demonstrations"
description: "ManiSkill asked whether a manipulation skill transfers to an object the policy has never seen, and answered with a collapse — point nine zero success on one fixed drawer, point one two on held-out ones. The collapse is real and it is also confounded, and the paper's own appendix holds the one experiment that half-separates it."
date: 2026-08-03
guest_name: "Ansel"
guest_voice: "bm_lewis"
---
[O] Here is the number that made this benchmark matter. Behaviour cloning on a point cloud, trained on one single cabinet drawer, gets to point nine zero success. Same architecture, same algorithm, trained across many drawers and tested on drawers it has never seen — point one two.
[S] And here is my problem with that sentence, said in exactly that order. Those two numbers differ in two ways at once, not one. You changed from one object to many, and you changed from seen objects to unseen objects. The headline attributes the whole drop to the second change.
[O] The paper does not actually claim that.
[S] The framing invites it. And the sentence you just said is the sentence everyone remembers.
[O] Fine. But hold this, because there is an experiment buried in the supplement that speaks directly to your objection, and the paper never connects it to the main results. That is the most interesting thing in here.
[S] Then let us go find it.
[O] Welcome to Litsearch Audio. Today's paper is ManiSkill: Generalizable Manipulation Skill Benchmark with Large-Scale Demonstrations, by Tongzhou Mu, Zhan Ling, Fanbo Xiang, Derek Yang and colleagues, out of UC San Diego, at the NeurIPS 2021 Datasets and Benchmarks track.
[S] Two hundred and forty five citations as of today. For a robotics environment suite that is a healthy number, and the successor landed two years later, so this one has to be read as the first draft of an idea rather than the finished version.
[O] And joining us is Ansel, who knows this line of work and the simulator stack underneath it. Ansel, welcome.
[G] Thank you. And I would sharpen the opening framing before you two run at each other. Nearly every manipulation benchmark of that era asked whether a policy could repeat a task. This one asked whether a skill transfers to an object instance the policy has never encountered. That is a different question, and the paper's own name for it is object-level generalizable manipulation skill.
[S] Set the scene. 2021. What was there?
[G] Two clusters, and the paper's complaint about each is different. The first cluster is the interactive household simulators — AI2-THOR, VirtualHome, Gibson, Habitat, ThreeDWorld. Rich scenes, but the action space is abstract. The manipulation is already assumed. You can study high-level planning in them, and you cannot pose a low-level physics problem at all.
[O] And the second cluster does have physics.
[G] The second cluster is robosuite, RLBench, Meta-World — full physics, and a genuinely wide range of task types. The complaint there is orthogonal. Many tasks, very few object instances per task. So you can test whether a policy learns twenty different skills, and you cannot test whether one skill survives contact with a new chair.
[S] Was there nothing in between?
[G] DoorGym is the honest answer, and the paper says so. It is a door-opening benchmark with procedurally generated doors — varying knob shapes, board sizes, physical parameters. That is real object-level variation. The authors' argument against it has two parts. First, procedural generation, in their words, often fails to cover objects with real-world complexity, which is why 3D vision has largely moved to crowd-sourced and scanned assets. Second, a single task type cannot cover different motion types. Opening a door and pushing a swivel chair are not the same problem wearing different hats.
[O] And there is a perception argument too.
[G] There is, and it is the one that most shapes the benchmark. DoorGym and others use fixed cameras returning 2D images. The authors want robot-mounted 3D sensing, because that is what real platforms have, and because 3D deep learning had matured to the point where they wanted point-cloud researchers to be able to compete here directly.
[S] So four complaints, four features. Take me into the build, Ansel.
[G] Four tasks, each chosen to exemplify a different class of motion constraint. OpenCabinetDoor is a revolute joint — a single-arm robot opens a designated door. OpenCabinetDrawer is a prismatic joint — same robot, a designated drawer. PushChair is planar motion through wheel-ground contact — a dual-arm robot pushes a swivel chair to a target without tipping it. MoveBucket is unconstrained — a dual-arm robot lifts a bucket with a loose ball inside onto a platform.
[O] Why the ball?
[G] Because the centre of mass of the bucket-and-ball system is constantly shifting. It turns a lifting problem into a balancing problem, and it makes two-arm coordination genuinely load-bearing rather than decorative.
[S] Object counts.
[G] One hundred and sixty two objects across three categories, re-modelled from PartNet-Mobility. Fifty-two cabinets for the door task, eighty-two doors among them, forty-two cabinets for training and ten held out. Thirty-five cabinets for the drawer task, seventy drawers, twenty-five train and ten test. Thirty-six chairs, twenty-six and ten. Thirty-nine buckets, twenty-nine and ten.
[O] Ten test objects per task, every task.
[G] Ten test objects per task. That number is worth holding onto, because it is the denominator on every generalization claim in the paper.
[S] The robot.
[G] One platform across all four tasks. A moving base, a Sciurus body, and either one Franka Panda arm — thirteen joints total — or two, which is twenty-two. PID joint controllers, with an operational-space Cartesian option available. Three cameras on the robot head, one hundred and twenty degrees apart, fused into one egocentric panoramic view.
[O] And three observation modes.
[G] State, point cloud, and RGB-D. And the paper is unusually direct about the first one. It says state mode is not suitable for studying generalizability, because object states are not available in realistic setups. So the generalization experiments run on point clouds only. That is a design commitment with teeth — it rules out the easiest way to make your own benchmark numbers look good.
[S] Now the demonstrations, because that is the part I want to understand mechanically. Thirty-six thousand trajectories. Nobody teleoperated thirty-six thousand trajectories.
[G] Nobody did. And the first thing they tried does not work either, which is the part I find genuinely useful. The obvious move is to train one reinforcement learning agent per task, across all the objects, and let it generate demonstrations. The authors report that this fails badly as object count rises. So they go divide-and-conquer.
[O] Two stages.
[G] Two stages. Stage one is reward design. For each task they author a single shared dense reward template — shared across every object in the task, not hand-tuned per object — and it is multi-stage. For the cabinet tasks, three stages: get the gripper to the handle, then reward the opening angle or distance, then penalise the link's speed so the scene ends static. For MoveBucket it is four stages, and one of the terms is the angle between the two vectors pointing from each gripper to the bucket's centre of mass, which pushes the grippers to opposite sides.
[S] That is a lot of human prior baked into a benchmark that is measuring learning.
[G] It is, and the authors are explicit that it comes from human prior. Their defence is that the reward is used to manufacture the dataset, not to solve the benchmark. A benchmark user in the main track never sees the reward.
[O] How do they check a template is any good before committing hours to it?
[G] This is the neat bit. They verify the template with model-predictive control using the cross-entropy method. Parallelised across twenty CPUs, it can find a successful trajectory from a single initial state in under fifteen minutes when the template is workable. That is fast enough to iterate on reward design.
[S] But not fast enough to be the dataset.
[G] Correct, and the reason is precise. The planner has to be re-run independently from every initial state. There are three hundred initial states per training object per task. Re-running it three hundred times per object does not scale. So stage two swaps in a model-free agent — a separate SAC agent trained per object instance — and those agents generate the bulk of the data.
[O] Which gets you to the number.
[G] Three hundred trajectories per training object, one hundred and twenty two training objects summed across the four tasks, and you land at roughly thirty-six thousand trajectories and about one and a half million point-cloud and RGB-D frames. Stored as internal environment states rather than rendered images, to save disk, with scripts to render them on demand.
[S] Quality control on the assets?
[G] More than most benchmarks bother with, and it is worth stating because it is a real cost the paper paid. First pass, they render every PartNet-Mobility asset and manually exclude annotation errors — their example is door hinges annotated on the same side as the handle. Second, collision shapes. The standard convex-decomposition algorithm, VHACD, introduces artifacts on some geometries — bumps and seams — and agents exploit those. So the buckets were decomposed by hand in Blender. Third, and this is the strong one, every object is verified end-to-end by actually attempting to learn a policy for it. If no policy can be learned, the object is reprocessed until one can.
[O] So every environment in the benchmark is certified solvable.
[G] Certified solvable by their own pipeline. That is not the same as easy, but it does mean a failure is a failure of the method, not of the asset.
[S] Tracks. The paper defines three, and I have opinions.
[G] Three tracks, and the intent is to let different communities compete on the piece they study. No Interactions: train only from the provided demonstrations, no further environment access — a pure offline setting aimed at 3D vision researchers. No External Annotations: online fine-tuning on top of that is allowed, but no new labelled data or new objects — aimed at reinforcement learning researchers. No Restrictions: anything, including new annotations, motion planning, hand-designed control.
[S] Hold that thought until the critique.
[O] Architectures, then results.
[G] Two, both on point clouds. The features per point are position, colour, and segmentation masks, with the robot state concatenated onto every point — which lets the network reason about the robot's relation to each point rather than having to infer it. Architecture one is a single global PointNet feeding an MLP. Architecture two is PointNet plus Transformer.
[O] Explain the second one properly.
[G] The point cloud is split by segmentation mask into K plus two sub-clouds — one per masked part, one for the unsegmented remainder, and one for the whole cloud. Each sub-cloud gets its own PointNet. Those per-part features go through a Transformer encoder, then attention pooling, then a final MLP to the action. The stated motivation is to let the model reason about relations between distinct parts and objects in the scene.
[S] And the algorithms on top.
[G] Three. Behaviour cloning, which is just L2 between predicted and demonstrated action. BCQ, which is batch-constrained Q-learning, an offline reinforcement learning method. And TD3 plus BC, the minimalist offline baseline. All three train purely from the static dataset.
[O] Results. Start with the single environment.
[G] Table 2 is the cleanest experiment in the paper and I wish more benchmark papers ran it. Fix everything to one single OpenCabinetDrawer environment — one object instance — and sweep the number of demonstration trajectories: ten, thirty, one hundred, three hundred, one thousand, with gradient steps scaled alongside, from two thousand up to forty thousand. Evaluate over one hundred trajectories.
[S] Numbers.
[G] PointNet plus Transformer with behaviour cloning: point one six, point three five, point five one, point eight five, point nine zero. Plain PointNet with behaviour cloning: point one three, point two three, point three seven, point six eight, point seven six. The Transformer variant is ahead at all five counts.
[O] So architecture matters and data matters.
[G] Both, and the data effect is the larger one. Going from ten demonstrations to a thousand moves you from point one six to point nine zero on a fixed object. That is the paper's own framing — learning manipulation from demonstrations is hard without a lot of trajectories even in one single environment.
[S] What about the offline reinforcement learning?
[G] Loses. BCQ with the Transformer: point zero two, point zero five, point two three, point four five, point five five. TD3 plus BC: point zero three, point one three, point two two, point three one, point five seven. Behaviour cloning with the same architecture is strictly higher than both at every one of the five trajectory counts. Five out of five, no exception.
[O] Why?
[G] The authors' explanation is that every demonstration in the dataset is a successful one. Offline reinforcement learning is built to extract a good policy from mixed-quality data by learning value. If the data is all good, supervised imitation is simply the easier fit, and the value-learning machinery is solving a harder problem for no benefit. They also point at the robot's high degree of freedom.
[S] Is that explanation supported or is it a conjecture?
[G] They say conjecture, and I would keep that label on it. There is a supporting hint in the appendix — a sweep over the weight that TD3 plus BC puts on its behaviour-cloning term. Whenever that weight is non-zero, TD3 plus BC comes out worse than plain behaviour cloning, even after turning it far below the value the original TD3 plus BC paper used. At zero it is literally behaviour cloning. So the offline method only wins by becoming the imitation method.
[O] That is a cleaner statement of the finding than the paper makes.
[G] It is in the supplement rather than the main text, so it reads as an implementation note. It is more than that.
[S] Now the generalization table.
[G] Table 3. Each task trains on its full training-object pool, three hundred demonstrations per object, one hundred and fifty thousand gradient steps. That is about five hours for behaviour cloning, thirty-five for BCQ, nine for TD3 plus BC, on one RTX 2080Ti. Five runs, and both training and held-out test success are reported, with the test numbers averaged over the ten test environments at fifty evaluation trajectories each.
[O] Give me the best row.
[G] Best anywhere in the table is behaviour cloning with PointNet plus Transformer on OpenCabinetDrawer: point three seven training, point one two test. Door is point three zero training, point one one test. PushChair is point one eight and point zero eight. MoveBucket is point one five and point zero eight.
[S] Point three seven training. On the objects it was trained on.
[G] On the objects it was trained on. And that is the first of the two patterns worth carrying out of this table. Training success is low before generalization is even asked for. MoveBucket never exceeds point one five on training objects under any algorithm.
[O] And the second pattern.
[G] Test success never exceeds training success. Four tasks, four algorithm-and-architecture columns, sixteen cells — training is strictly higher in every single one. The narrowest gap is MoveBucket under plain PointNet behaviour cloning, point zero three training against point zero two test, where both numbers are close enough to the floor that the gap barely means anything.
[S] Sixteen out of sixteen is not cherry-picked. I will grant that outright.
[O] So can I say the headline now? Point nine zero on one drawer, point one two on unseen drawers.
[S] No, and this is the thing I opened with. Look at what changed between those two settings. In Table 2 you have one object and three hundred to a thousand demonstrations on it. In Table 3 you have twenty-five drawers, three hundred demonstrations each, seven and a half times the gradient steps — a hundred and fifty thousand against twenty thousand — and vastly more total data. And you are also asking for transfer to unseen objects. Two changes. Every number in the comparison mixes them.
[G] That is a fair criticism and I want to state precisely how fair. The optimization problem — fitting one policy to many objects — and the generalization problem — transferring to held-out objects — are confounded in every number the main paper reports. There is no intermediate condition. Nothing trains on many objects and reports only training-object success against a matched single-object baseline.
[O] Except there is. That is what I flagged at the top.
[G] There is something adjacent, and it is in the supplement. Table 5 trains SAC from scratch on OpenCabinetDrawer with one, five, ten, and twenty cabinets, and reports one hundred percent, eighty-two percent, two percent, and zero percent success.
[S] One to twenty objects and you go from solved to nothing.
[G] From solved to nothing. And crucially, there is no generalization anywhere in that experiment. Every one of those cabinets is a training cabinet. The agent is evaluated on the objects it trained on. So that collapse is driven purely by object count.
[O] Which means the optimization half of the problem is severe on its own.
[G] The optimization half is severe on its own. That is exactly what it licenses, and no more.
[S] Why no more? That looks like it settles my objection.
[G] Because it cannot be laid alongside either main table. It is SAC trained from scratch, in state mode, with dense rewards, and no demonstrations at all. Table 2 is demonstration-driven behaviour cloning on point clouds. Table 3 is demonstration-driven learning on point clouds with held-out objects. Different algorithm, different observation mode, different supervision. So Table 5 tells you that multi-object optimization is brutally hard in one setting. It does not tell you how the point nine zero to point one two drop splits between optimization and generalization in the setting the headline is about.
[S] So the paper has the experiment and it is the wrong experiment.
[G] The paper has an experiment that establishes the confound is real and substantial. It does not have the experiment that resolves it. And notably it never connects Table 5 to the main results at all — it appears in the supplement purely as justification for the divide-and-conquer demonstration pipeline.
[O] I will take that trade. It moves the criticism from "you have not shown the collapse is generalization" to "you have shown both halves are hard and have not partitioned them". That is a much smaller complaint.
[S] It is a smaller complaint and it is still the complaint. The experiment that would settle it is cheap — sweep the training-object count at fixed total demonstrations, in the same observation mode, with the same algorithm, reporting training and test success at each point. That is a plot, not a research programme.
[G] I agree it is the missing experiment. And I would note the authors were plainly aware of the object-count effect, since they ran the state-mode version of it to justify their pipeline.
[O] Let me get one more thing on the record, because it cuts against my own side. The paper calls behaviour cloning with PointNet plus Transformer its best agent, without qualification.
[G] And on PushChair's test column, it is not. Plain PointNet with behaviour cloning scores point zero nine there. PointNet plus Transformer scores point zero eight — tied with BCQ and with TD3 plus BC, both also at point zero eight.
[S] So on that task all four are indistinguishable and the simple architecture is nominally on top.
[G] Nominally, and with standard deviations of one to two hundredths on those cells, I would not read the ordering as meaningful. The honest statement is that on PushChair's test set nothing separates the four. But the superlative in the text does not survive it.
[O] How isolated is that?
[G] Compare the Transformer variant against plain PointNet across all eight training-and-test columns of Table 3. It wins seven. PushChair's test column is the one exception. So it is the exception that establishes the pattern rather than one that refutes it — but a benchmark paper writing "our best agent" should carry the qualifier.
[S] Second thing I want on the record. How were the train and test objects split?
[G] The paper does not say. Section 2.1 states that objects are partitioned into training objects and test objects, and that is the whole of it. No randomisation procedure, no category balancing rule, no de-duplication check against near-identical variants, in the main text or in the supplementary system details.
[S] That is the structural analogue of contamination, and it is unaddressed.
[G] It is. These are re-modelled crowd-sourced assets, not independently sourced ones. It is entirely plausible that a category contains two very similar office chairs. If such a pair straddled the split, the reported generalization gap would understate the true difficulty. Nothing in the paper rules it in or out.
[O] Which direction does that cut?
[G] Against the paper's optimism about its own test set, not against its headline. If anything, near-duplicates would make the collapse look milder than it is. So it does not threaten the finding. It threatens the ability of a future paper to claim it has closed the gap.
[S] Third. The three tracks.
[G] Every baseline reported — behaviour cloning, BCQ, TD3 plus BC — trains solely from the static dataset with zero further environment interaction. That is the No Interactions track alone. The No External Annotations and No Restrictions tracks ship with no numbers whatsoever.
[O] Two thirds of the declared protocol is unpopulated.
[G] Two thirds of the declared protocol is unpopulated. And the sharpest version of that: Table 1 rates both cabinet tasks as Easy to solve by motion planning. Motion planning is explicitly permitted in the No Restrictions track. The paper flags the relevance and never runs it. That is a natural ceiling that would tell you how much of the difficulty is perception and how much is control, and it is one table away.
[S] There is a segmentation asymmetry too that I do not think gets enough attention.
[G] Say it, because it is a good one.
[S] The supplement lists the masks per task. The two cabinet tasks get three — the handle of the target link, the target link itself, and the robot. PushChair and MoveBucket get one. The robot.
[G] That is right, and it compounds with the architecture. The Transformer variant partitions the cloud by mask. On the cabinet tasks it therefore has several genuinely distinct sub-clouds to relate. On chair and bucket it has the robot, the remainder, and the whole cloud — the mechanism it was designed around has almost nothing to work with. Going beyond the paper, my read is that some of the Transformer's smaller margin on those two tasks is structural rather than about task difficulty per se.
[O] And there is no ablation to check that.
[G] There is none. It would be a straightforward one.
[S] Alright. Optimist case, best version.
[O] It asked the right question first. In 2021, with everyone racing to add tasks, this group added objects, held ten of them out per task, refused to let the policy see privileged state, and reported a table where training beats test in sixteen cells out of sixteen. They shipped the assets, the demonstrations, the code, and the evaluation kit, on a fully open stack, when the comparable environments all depended on commercial simulators. And they were right — object-level generalization was the hard part, and it is now a standard axis. Being early and correct about what to measure is worth more than a tight ablation.
[O] Now yours. Deflationary case, best version.
[S] The paper measures one third of its own protocol, does not describe how its test set was constructed, and reports a headline comparison that conflates two distinct failure modes while holding, in its own supplement, evidence that one of those modes is severe on its own and choosing not to connect them. The absolute numbers are so low across the board that most architecture comparisons in Table 3 sit inside the noise. It is a good asset release with a thin experimental spine.
[G] I will score it. On the question chosen and the assets shipped, the optimist. That is not close — the four-way motion-type task design and the certified-solvable asset pipeline are real work, and the sixteen-of-sixteen sweep is not cherry-picked. On the tracks and on the split construction, the skeptic, without qualification; those are omissions, not judgement calls. On the confound, I put it between you. It is a genuine gap in the paper's argument, and Table 5 shows the authors had the instinct even if they aimed it elsewhere.
[O] What did the field do with it?
[G] The direct answer is ManiSkill2, from largely the same group two years later, which is on the site as well. It expands the task and object set substantially, and it is fair to read it as built to close exactly the gaps we have been discussing. This paper's own limitations section names three: only one hundred and sixty two objects, only four tasks, and no sim-to-real experiments at all.
[S] No sim-to-real. Stated plainly in the paper.
[G] Stated plainly, as future work. Which matters for how you read the whole thing — everything here is a simulator claim.
[O] Implications for evaluation practice, and I want the general version, not the robotics version.
[G] Then here it is. When a benchmark reports a large drop between an easy condition and a hard condition, count how many things changed between them. If it is more than one, the headline attributes the drop to whichever change is more interesting, and that attribution is usually unearned. The fix is an intermediate condition, and it is almost always cheaper to run than the two endpoints already reported.
[S] And check the supplement before you accuse anyone of not running it. The intermediate condition here half-exists.
[O] Takeaways. Ansel, the paper's.
[G] Object-level generalizable manipulation was measurable in 2021, and once measured it was nowhere near solved — the strongest baseline reached point three seven on training objects and point one two on held-out ones, with training exceeding test in every cell reported.
[S] Mine. The finding survives, the attribution does not. Two variables moved together in the headline comparison, and the one experiment that isolates either of them is in the appendix under a different algorithm, a different observation mode, and no demonstrations.
[O] Mine. This is what a benchmark looks like when the authors are more interested in a hard question than a clean result — low numbers everywhere, three tracks they could not fill, and a diagnosis the field then spent years working on. I will take that over a saturated leaderboard.
[S] The full writeup is on the litsearch site, with the figures, both results tables in full, and the link through to ManiSkill2.
