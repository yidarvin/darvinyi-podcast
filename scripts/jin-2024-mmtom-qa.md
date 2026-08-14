---
slug: jin-2024-mmtom-qa
title: "MMToM-QA: Multimodal Theory of Mind Question Answering"
description: "A 600-question benchmark that makes a model fuse what it sees a person do with what only the text can tell it about the world. Humans hit 93 percent. GPT-4V hits 44 — and scores zero on one question type, twice over."
date: 2026-07-25
guest_name: "Julian"
guest_voice: "bm_lewis"
---
[S] There is a cell in this paper's results table that reads zero point zero. Not near chance. Zero. Seventy five questions, two options each, and the method got every single one wrong.
[O] And that method is a prompting technique specifically designed to improve theory of mind in language models, wrapped around GPT-4.
[S] Which is the most informative number in the paper, and it is not the one in the abstract.
[O] The one in the abstract is pretty good too. Humans at ninety three percent, every large multimodal model between forty and forty seven, on a task where guessing gets you fifty.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Our guest today is Julian.
[S] The paper is MMToM-QA, Multimodal Theory of Mind Question Answering, from Chuanyang Jin at NYU, with Yutong Wu, Jing Cao, Jiannan Xiang, Yen-Ling Kuo, Zhiting Hu, Tomer Ullman, Antonio Torralba, Joshua Tenenbaum, and Tianmin Shu, across NYU, Harvard, MIT, UC San Diego, Virginia, and Johns Hopkins. ACL twenty twenty four, posted January twenty twenty four.
[O] Julian, welcome. That author list is essentially the computational cognitive science establishment. Does that show in the paper?
[G] It shows in every design decision, and I think that is the right frame for the episode. This is a cognitive science paper that happens to have a leaderboard in it. The benchmark is built backwards from a theory of what human theory of mind actually is, rather than forwards from what is easy to annotate.
[S] Then start with the theory, because the gap claim depends on it.
[G] The paper's position is that theory of mind is not text comprehension and it is not video understanding. It is building a causal model of another person's mind, connecting mental variables to possible actions, and that model can be fed by words, by vision, or by both fused together. They cite the Baker and Tenenbaum lineage, Saxe, Jara-Ettinger, on that framing.
[O] And existing benchmarks pick one modality and stay there.
[G] Exactly one. The video-based ones, AGENT from Gandhi and colleagues, Shu and colleagues' work, Netanyahu and colleagues, use animations of goal-directed agents. The text-based ones, and this is the larger family, adapt the Sally-Anne false belief test from Wimmer and Perner nineteen eighty three. Kosinski, Sap, Shapira, Gandhi's text work, Kim and colleagues. All text.
[S] So the fusion argument is the headline gap. What is the second one?
[G] The second is sharper and I think more important. Existing benchmarks isolate belief inference from goal inference. You ask what does she believe, or you ask what does she want, but never one conditioned on the other. The paper's claim is that real theory of mind requires joint inference, because a person's goal is often only decodable once you have inferred their belief, and the reverse.
[O] Give me the worked example, because it is the clearest thing in the paper.
[G] Figure one. The video shows a woman named Emily. In the first frame she can see a wine glass on a kitchen table. In the second frame she walks past it without picking it up. In the third frame she is heading somewhere ambiguous, either toward cabinets on the left or toward the microwave. The question is whether she is trying to get a cupcake or a wine glass.
[S] And the video alone cannot settle it.
[G] The video alone cannot, because you cannot see inside a closed microwave or a closed cabinet. The text says there is a cupcake inside the microwave and no cupcake in the cabinets. So the correct answer, cupcake, requires two inferences chained together. She passed the wine glass, so she does not want it. And the only place a cupcake could be is the microwave, which is where she is heading.
[O] That is a genuinely elegant item design. Neither stream is sufficient and neither is redundant.
[S] It is elegant. Now tell me the scale, because one beautiful example is not a benchmark.
[G] One hundred thirty four videos of a person searching for everyday objects in household environments. Each video averages one thousand four hundred sixty two frames and depicts thirty six human actions. From those, six hundred questions, every one paired with a video clip as RGB-D frames plus a text description of the scene and the actions.
[O] And the questions are two-choice, which I expected to hate and ended up liking.
[G] The reason to like it is the instruction. Neither option is surely true nor surely false. One is significantly more likely given the observations. That mirrors how people reason under uncertainty, and it avoids the trap of a benchmark that has a deductively forced answer.
[S] It also puts the chance floor at fifty, which is a high floor. Any real signal has to clear it by a lot.
[G] It does, and that turns out to matter enormously, because several baselines do not clear it at all.
[O] Walk the seven types, because the per-type table is where this paper lives.
[G] Three belief types, one hundred questions each, three hundred total. Type one point one, true belief short-term. A person is about to open a container, the question asks whether they believe a hypothetical goal object is inside, and it actually is inside. So the belief inference and the world state agree.
[S] The easy case.
[G] The easy case by construction. Type one point two, false belief short-term. Structurally identical, except the object is not in the container. The correct answer is still that the person believes it is in there, because that is what explains their action, even though they are wrong about the world.
[O] So one point one and one point two are a matched pair. Same surface form, opposite relationship between belief and reality.
[G] That pairing is the single most diagnostic thing in the benchmark and we will come back to it.
[S] Type one point three?
[G] Long-term belief tracking. The person walks past a container without checking it, and then continues searching for a while without going back. The inference is that they do not think the object is in the container they skipped. It tests whether you can use the whole action history rather than only the most recent action.
[O] And the four goal types?
[G] Seventy five questions each, three hundred total. Two point one, goal given true belief. The person walks toward a container holding an object they have not seen, having already passed up the other candidate object. Infer they want the unseen one. Two point two, goal given false belief. The question tells you the person does not think a particular object is in the container they are approaching, so their goal must be something else they think might be in there.
[S] Two point three is the one with the zero.
[G] Two point three, goal inference given updated belief. Here the video does not end with the person walking toward a container. They open it and close it without taking anything. The correct inference is that their goal is something they have not seen yet, precisely because they rejected the contents of the container they just opened.
[O] And two point four.
[G] Goal given future actions. The hardest spatially. One candidate object sits somewhere far away, not related to the person's most recent action, but on the path they appear to be taking. You have to reason about heading direction and continuous spatial layout to predict where they are going next.
[S] Now, how is this generated? Because six hundred hand-written multimodal items would be a lot of annotator hours.
[G] Not hand-written at all, and this is the part I would most want other benchmark builders to copy. Three steps. First, procedurally synthesize videos in VirtualHome-Social, an embodied household simulator from Puig and colleagues, which gives you ground truth state, actions, goals, and beliefs for free. Second, at each timestep, sample a question type and two competing hypotheses consistent with the trajectory. Third, hand GPT-4 the ground-truth state, the actions, and the sampled hypotheses, and have it write the natural-language scene description and the question.
[O] So GPT-4 writes the surface text but never decides the answer.
[G] Never. The answer comes from the simulator. And that is the crucial property. There is no crowd annotation noise floor to argue about, because there is no crowd annotation of the label.
[S] I want to be fair here, because I usually attack synthetic benchmarks and this design blunts most of my usual attacks.
[G] Which ones does it blunt?
[S] Contamination, mainly. These apartments and avatars were generated after any plausible pretraining cutoff and were not public as ground-truth pairs before publication. So the memorization story that haunts every scraped benchmark does not apply. And label ambiguity, which is the other standard complaint, is answered by construction.
[G] I agree with both, and I would add a third. Because the generator is a simulator, they could also produce a training set. One thousand procedurally synthesized videos with full annotations of scene, objects, goals, and beliefs, released alongside.
[O] And all evaluation is zero-shot on the questions themselves.
[G] That is the stated protocol. No example question-answer pairs are provided during training. A model is expected to learn how people update mental states and act from the behavior data, and generalize to the questions at test time.
[S] Hold that thought, because it is going to become the central fairness question.
[O] Let's do the human baseline first, since it anchors everything.
[G] One hundred eighty participants recruited through Prolific, evaluated on a random sample of one hundred twenty questions, which is twenty percent of the benchmark, spanning all types. Multimodal accuracy ninety three percent. And the paper notes that for each tested question the majority of participants chose the correct answer, which validates that the items are actually answerable.
[S] That is a real experiment, and I want to say so. A lot of benchmark papers assert a human ceiling. This one measured it with a sample size that supports it.
[O] The unimodal human numbers are the interesting part though.
[G] They are. Text only, humans drop to eighty two point five. Video only, humans drop to sixty eight point nine. So video alone is genuinely harder for people, not just for models, which tells you the modalities are not interchangeable even for the reference reasoner.
[O] And there is one place where humans do not drop at all.
[G] True belief and false belief. Multimodal human scores are ninety five point eight and ninety six point seven. Text only, ninety six point zero and ninety five point eight. Identical within noise.
[S] Which is a quiet indictment of the entire text-based theory-of-mind literature.
[G] It is precisely that, and the paper says so gently. Those two types are the main target of text theory-of-mind benchmarks, and they are exactly the types where multimodality buys a human nothing. Whereas long-term belief tracking drops for humans from one hundred percent multimodal to eighty one point three text only.
[O] So the field has been measuring the one thing that does not need the hard part.
[G] That is a fair summary of the paper's implicit argument, yes.
[S] Now the models. Give me the topline and then the breakdown, because I suspect the breakdown reverses the reading.
[G] Topline multimodal. Humans ninety three. InstructBLIP forty six point seven. LLaVA forty three point five. GPT-4V forty four point zero. Video-LLaMA 2 forty point two. Every one at or below chance.
[O] Text only?
[G] Humans eighty two point five. GPT-4 forty eight point zero. GPT-3.5 thirty eight point three. GPT-J fifty point seven. LLaMA 2 fifty point three. Then the two theory-of-mind prompting methods applied to GPT-4. SimToM from Wilf and colleagues, fifty two point five. SymbolicToM from Sclar and colleagues, sixty three point zero.
[S] So the best text result is a prompting scaffold, and it is still nineteen and a half points below humans.
[G] Nineteen and a half, yes.
[O] Before we get to the breakdown, there is a comparison in that data I did not expect and I want it named.
[G] Go ahead.
[O] GPT-4V multimodal is forty four point zero. GPT-4 text-only is forty eight point zero. Giving GPT-4 the video makes it worse.
[S] Four points worse on a benchmark whose entire premise is that fusing modalities is required.
[G] That is correct and it is worth sitting with. And it is not just the aggregate. On long-term belief tracking, GPT-4 text-only gets seventy seven point zero and GPT-4V multimodal gets fifty nine point zero. Eighteen points lost by adding video.
[O] Julian, is that a model failure or a harness failure? Because I can construct both stories.
[G] I think honesty requires saying it is partly both, and the paper does not fully disentangle them. Here is the harness side. The videos average one thousand four hundred sixty two frames. The paper says that for all large multimodal models they uniformly sample a few frames from each video, following prior work.
[S] A few frames. Out of fourteen hundred.
[G] Out of roughly fourteen hundred. So GPT-4V is not watching a video. It is looking at a handful of stills, sampled without regard to which moments carry the evidence. In the Emily example, if your sampling misses the frame where she walks past the wine glass, the entire item becomes unanswerable.
[O] So a substantial part of "large multimodal models cannot do theory of mind from video" might be "large multimodal models were not shown the video."
[G] Part of it, I would say. I would not say all of it, because the video-only human number, sixty eight point nine, shows the task is hard from video even with full temporal access. But the comparison is not clean, and I think the paper should have run a frame-density ablation.
[S] I want to press one step further, because there is an asymmetry here that goes to the heart of the paper's own method. BIP-ALM's visual module processes frames to build voxel maps and scene graphs. Does it get the same handful of frames?
[G] No. It processes frames to construct a scene graph per frame and then aligns those with the parsed actions, truncating the video into intervals corresponding to actions. So its visual pathway has far denser access to the temporal stream than the sparse uniform sampling given to the baselines.
[S] Then the video-only comparison is structurally unfair, and the paper does not flag it as such.
[G] I think that is a legitimate criticism and I will not defend against it. What I will say is that the multimodal and text-only comparisons do not suffer from it nearly as much, and the headline finding survives there.
[O] Alright, the per-type breakdown. This is the part that changed how I read the whole paper.
[G] Type one point one, true belief, multimodal. Humans ninety five point eight. GPT-4V ninety four point zero. Essentially human-level.
[S] And text-only GPT-4 on the same type?
[G] Ninety seven point zero. And SymbolicToM with GPT-4 gets one hundred percent. A perfect score.
[O] So on true belief, the frontier model is at the human ceiling.
[G] Now type one point two. Same structure, false belief instead of true. Humans ninety six point seven multimodal. GPT-4V, thirteen point zero.
[S] Thirteen. On a two-choice question.
[G] Thirteen multimodal, twelve text-only. GPT-3.5 eleven. SimToM with GPT-4, fifteen.
[O] Those are not chance failures. Those are systematically inverted answers.
[G] They are, and the paper's diagnosis is exactly right. The model can read the true world state off the text, and it confuses the true world state with the person's belief. When those two agree, it looks like a genius. When they diverge, it answers the wrong question with high confidence, which is why it lands near thirteen rather than near fifty.
[S] This is the point I would make to anyone citing the aggregate. Forty four percent sounds like uniform mediocrity. It is not. It is near-perfect performance on one type averaged against near-inverted performance on the matched type. Those are completely different diagnoses and the aggregate erases the distinction.
[G] And it is the strongest argument in the paper for why matched question pairs are better instrumentation than a single accuracy number.
[O] Now the zero.
[G] Type two point three, goal inference given updated belief. The person opens a container, closes it, takes nothing. GPT-4 text-only scores two point seven percent. GPT-4V multimodal, four point zero. SimToM with GPT-4, two point seven. And SymbolicToM with GPT-4, zero point zero.
[S] Seventy five questions. Two choices. Zero correct.
[G] Zero correct. And the interpretation is not that it is guessing badly. To score zero on a binary task you have to be reliably choosing the wrong option, which means the model has a consistent, confident, wrong theory.
[O] What is the wrong theory?
[G] The paper's hypothesis, and I find it convincing, is that the model assumes the goal must be one of the objects inside the container the person just opened. It cannot represent the inference that opening and then closing without taking is itself informative. That the null result updates the belief and moves the goal hypothesis to something unseen.
[S] Which is an absence-of-evidence inference. The action that carries the signal is the action not taken.
[G] Exactly, and it is the same structure as type one point three, where the informative event is walking past a container without checking it. Both require treating a non-action as data.
[O] And SymbolicToM, which was designed to help, scores worse than plain GPT-4 there.
[G] Worse on that type, better overall. It goes from GPT-4's forty eight to sixty three overall, and from twelve to sixty one on false belief, which is a genuine improvement on the classic case. But on two point three it goes from two point seven to zero. Its mechanism is removing text irrelevant to the target agent's perspective, and my read, going a step beyond the paper, is that a container the person examined and rejected looks exactly like irrelevant text to that filter.
[S] So the scaffold prunes away the evidence that mattered.
[G] That is my read. The paper does not say it, it just reports the number.
[O] Let's do BIP-ALM, the paper's own method, and then argue about whether the comparison is fair.
[G] Bayesian Inverse Planning Accelerated by Language Models. The structure is classical Bayesian inverse planning from Baker and colleagues, with one substitution. You model the person as a rational agent solving a partially observable Markov decision process. Given two hypotheses, each a goal-and-belief pair, you compute which one makes the observed action sequence more likely, as an odds ratio.
[S] And the classical bottleneck is the policy.
[G] The policy is the entire bottleneck. To score how likely an action is given a goal and a belief, you conventionally need to plan or run reinforcement learning in the environment, which does not scale to a household with dozens of objects and thirty six actions per episode. BIP-ALM replaces that with a language model that is prompted with the symbolic state, the goal, and the estimated belief, and reads the action likelihood off the output logits.
[O] So the language model is not answering the question. It is amortizing one term in a Bayesian computation.
[G] That is the cleanest way to put it, and I think it is the paper's real methodological idea. The language model never sees the question. It supplies a likelihood; the Bayesian structure supplies the reasoning.
[S] Inputs?
[G] Two pathways into a shared symbolic representation. The visual module, adapting Blukis and colleagues, builds a voxel map and scene graph per frame, converted to predicates like In-apple-kitchen-cabinet and Closed-fridge. GPT-4 parses the text into an initial state, an action sequence, and the two hypotheses from the question, in the same predicate vocabulary. Then a fusion step aligns the video-derived actions with the text-derived actions and merges the state predicates.
[O] Results.
[G] BIP-ALM with LLaMA-2 seven billion. Multimodal seventy six point seven, text seventy point five, video sixty one point two. With GPT-J six billion, seventy five point three, seventy one point seven, fifty nine point seven. So roughly thirty points above GPT-4V multimodal, from a seven billion parameter backbone.
[S] Now the fairness question, and it is the main one I have. That backbone is finetuned on the one thousand training videos, which come from the same simulator, the same predicate vocabulary, and the same household object distribution as the test set. GPT-4V is evaluated with no exposure to this domain whatsoever.
[G] That is accurate and the paper does not obscure it. What it offers in response is twofold. First, an ablation showing that BIP-ALM without any finetuning, using small pretrained language models, already beats GPT-4 alone. So the gain is not purely the in-domain data.
[O] Which is the important control, honestly. It attributes the win to the Bayesian structure rather than to the training set.
[S] Partly. It shows the structure contributes. It does not show the finetuning contributes nothing, and the finetuned numbers are the ones in the headline chart.
[G] Fair. The second response is the generalization set. They built an additional human test set, forty videos and one hundred twenty questions, using two apartments unseen in both the training set and the main test set, and recruited three participants with no prior exposure to the system to control the avatar through the human interface. So those are real human belief updates and real human action sequences, not planner output.
[S] Three participants. And still VirtualHome-Social, still the same predicate schema, still the same question generator.
[G] Both of those are true. It is a meaningful control against the specific worry that BIP-ALM only works on planner-generated trajectories, and it is not a control against distribution shift in general. I would call it necessary but not sufficient.
[O] Did they try the obvious counter-experiment, finetuning a baseline on the same data?
[G] They did, and I am glad you asked because it is buried in an appendix. They finetuned Video-LLaMA 2, the thirteen billion version, on the training set for video instruction tasks. It got moderately better on a few of the simpler types, type one point one among them, and its overall performance remained not better than chance.
[S] That is the control I wanted, and it substantially answers my objection. Same data, larger model, end-to-end rather than structured, still at chance.
[O] So the structure is doing the work, not the data.
[G] That is the most defensible reading, yes. They also report that few-shot and chain-of-thought prompting, and varying model sizes, produced no setting that consistently improved any baseline across all types.
[S] Alright. I will also credit them for reporting their own method's failures, which is rarer than it should be.
[G] Three named failures. First, BIP-ALM cannot imagine missing state information from video, so if the perception module does not extract a predicate, the planner has no way to hypothesize it. Second, it is purely symbolic, which they flag as the problem for type two point four. Predicting where someone is heading requires continuous spatial reasoning about paths and facing direction, and a predicate vocabulary cannot express that. Third, the language model's action likelihood is sometimes simply wrong, because language models are unreliable planners.
[O] Does the second one show up in the numbers?
[G] Not cleanly, and I want to be careful here rather than let the narrative pull the data. BIP-ALM with LLaMA-2 multimodal actually scores eighty percent on type two point four, which is its best goal type. Its weakest is type two point one at sixty two point seven. So the stated limitation is a conceptual argument about representation, not something the aggregate score demonstrates.
[S] That is worth saying out loud. A limitations section that names the right weakness for the wrong reason is still doing better than most, but it is not evidence.
[G] Agreed. Where the symbolic approach does visibly strain is backbone-dependent. With GPT-J instead of LLaMA-2, type two point three falls from seventy two to fifty six. And seventy two on type two point three is the number I would actually highlight, because that is the type where GPT-4V scored four percent and SymbolicToM scored zero.
[O] Closing arguments. Mine is about instrumentation, not about models.
[S] Go.
[O] This benchmark is built so that the failure is legible. Matched true and false belief pairs isolate exactly one variable, whether belief and reality agree, and produce ninety four percent versus thirteen percent from the same model. Procedural generation from a simulator makes the ground truth verifiable and contamination implausible. A hundred eighty human participants give a real ceiling with unimodal controls. And the proposed fix is not a bigger model, it is a claim about architecture, tested by finetuning a competitor on the same data and watching it stay at chance. Every one of those is a choice most benchmark papers do not make.
[S] My case is narrower than usual because the design is good. Three things. The video condition is not an apples-to-apples comparison, because the baselines get a few uniformly sampled frames from fourteen-hundred-frame videos while the paper's own method processes a dense per-frame scene graph, and no frame-density ablation is reported. The headline method carries an in-domain finetuning advantage the zero-shot baselines do not, and the generalization check is forty videos and three people inside the same simulator and the same schema. And the whole benchmark is one scenario family, a person looking for household objects, which the authors flag themselves, so we are measuring one narrow slice of theory of mind with no desires, no emotions, and no multi-agent reasoning.
[G] My adjudication. The core empirical claim, that current large models lack robust theory of mind on jointly conditioned belief-and-goal reasoning, is well supported and I score it to the optimist. It replicates across three input conditions, seven types, and eleven baselines, with a measured human control. The video-only comparison I score to the skeptic without qualification. It is not a fair harness and the paper should say so. The BIP-ALM fairness objection I score mostly to the optimist on the strength of the finetuned Video-LLaMA 2 control, which is the experiment that matters and which came out the paper's way. And the finding I would actually carry out of this paper is neither the ninety three versus forty four nor BIP-ALM's seventy six point seven. It is the pair of numbers ninety four and thirteen from the same model on structurally identical items, and the zero on type two point three. Those say something precise, which is that these models retrieve the world state and call it a belief, and cannot treat an action not taken as evidence. That is a diagnosis. An aggregate accuracy is not.
[O] Julian, thank you. The full write-up with the figures, the odds-ratio equation, and the whole per-type table is on the litsearch site under Jin twenty twenty four MMToM-QA.
