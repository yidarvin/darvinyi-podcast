---
slug: wu-2023-smartplay
title: "SmartPlay: A Benchmark for LLMs as Intelligent Agents"
description: "Six games, one text API, nine capability axes — and an appendix formula that contradicts the paper's own main table."
date: 2026-07-27
guest_name: "Elias"
guest_voice: "am_puck"
---
[O] There is a benchmark from late 2023 where GPT-4 scores zero point two six against a human baseline of one point zero zero, and I think that is one of the most useful numbers in agent evaluation from that year.
[S] And four columns to the left in the same table, a weaker model, text-davinci-003, scores one point oh four. Above the humans. Different game, different metric, same table.
[O] Both are real, both are in Table 2 of SmartPlay, and I would argue both are the benchmark working as intended.
[S] Maybe. My question is whether a benchmark whose entire ceiling is three people, one round each on the hard games, can carry the weight everyone wants to put on it.
[O] Welcome to Litsearch Audio. Today it is SmartPlay: A Benchmark for LLMs as Intelligent Agents, by Yue Wu, Xuan Tang, Tom Mitchell, and Yuanzhi Li, out of Carnegie Mellon and Microsoft Research, published at ICLR 2024.
[S] Six games, one text interface, nine named capabilities. It is on the docket because it is one of the earliest serious attempts to score a language model as an agent rather than as a question-answering machine.
[O] And we have Elias with us, who has read this one closely, appendix included. Welcome.
[G] Glad to be here. And I will flag up front that the appendix is where this paper gets genuinely interesting, in more than one sense.
[S] Elias, set the stage. Late 2023. What did evaluation look like, and what was missing?
[G] Two tracks dominated. Static knowledge and reasoning suites, so MMLU, HELM, BIG-bench, AGIEval. And helpful-harmless dialogue evaluation, so the HH-RLHF line, MT-Bench, AlpacaFarm. Both are single-shot, or single-conversation. Neither asks whether a model can hold a strategy across fifty turns and recover when it goes wrong.
[O] Which was exactly the year AutoGPT and BabyAGI were everywhere.
[G] Right. The authors name four capabilities they say prior benchmarks miss entirely. Long-horizon planning for multi-step tasks. Understanding the odds in probabilistic environments. Spatial reasoning for a three-dimensional world. And learning from interactions or mistakes when the agent hits an unseen situation.
[S] And their answer is games, which is a very old answer.
[G] Deliberately old. They cite the general-game-playing lineage, Atari, DeepMind Lab, NetHack, MineDojo. The argument from game design is that good games bundle problem-solving, calculation of odds, spatial reasoning, changing difficulty, and well-defined quantifiable outcomes. That is a convenient bundle if you are building an agent benchmark from scratch.
[O] And there is a contamination argument stacked on top of it.
[G] There is, and it is one of the sharpest points in the paper. Some of these environments are procedurally generated, so the state space grows exponentially and you cannot memorize it the way you memorize a fixed answer key. We should come back to how well they actually test that.
[O] Let's get concrete. What are the six games?
[G] Two-Armed Bandits. Rock Paper Scissors. Three-disk Tower of Hanoi. Messenger, from Hanjie and colleagues, which ships three difficulty levels. Crafter, from Hafner, a two-dimensional open-world survival game. And a simplified Minecraft creative navigation task built on MineDojo. Together they expose up to twenty distinct evaluation settings.
[S] Most models had no vision in 2023. How do you put Minecraft in front of a text-only model?
[G] With a visual descriptor. MineDojo hands you a block-level matrix from lidar rays. SmartPlay runs a connected-component pass to group adjacent blocks of the same type, then describes each group by its closest block. You get lines like "grass, three point eight seven blocks away, below you to north-west, taking thirty eight percent of screen." The scheme is adapted from the authors' own earlier SPRING work.
[O] So the agent navigates a three-dimensional world through a list of directional strings.
[G] Exactly. Hold onto that, because it explains the Minecraft results later.
[S] What does the interface look like from the model's side?
[G] One OpenAI Gym style interface for all six games. A text observation, a text manual, a rolling text history of past actions and observations, and a flat categorical action space. The manual's contents vary by game, and that variation is itself a design choice. Bandits gets background only. Rock Paper Scissors gets background plus rules. Hanoi gets background, rules, and worked examples. Messenger and Crafter get background, rules, and an advice string. Minecraft gets just an objective.
[O] Table 1 has the per-game knobs.
[G] It does, and the paper is emphatic that input, manual, action space, and rollout length must not be modified. Bandits and Rock Paper Scissors: history fifty, rollout fifty, twenty trials. Hanoi: history thirty, rollout thirty, six actions, ten trials. Messenger: history two, rollout anywhere from four to a hundred and twenty eight, a hundred trials. Crafter: history five, rollout ten thousand steps, seventeen actions, ten trials. Minecraft: history two, rollout two hundred, four actions, twenty trials.
[S] Ten thousand steps of Crafter, two prompts per step, ten trials. That is an enormous query bill.
[G] It is, and the paper says so directly. It narrowed from twenty possible settings down to seven specifically to reduce the cost of queries.
[O] What is the prompting recipe?
[G] Two calls per turn, following SPRING. First a free-form call: "What is the next action to take, let's think step by step," with the manual, the history, and the current observation as context. Then a forced-choice follow-up: "Choose the best executable action from the list of all actions. Write the exact chosen action." The second call is what maps the reasoning back onto one concrete environment action.
[S] So chain of thought is baked into the harness. Every model gets it, and there is no ablation on whether it helps.
[G] Correct. There is no prompting ablation anywhere in this paper. That is a real gap, and I would not argue otherwise.
[O] And the scoring?
[G] Three metrics. Reward, which matches each game's original reinforcement learning reward, for Bandits, Rock Paper Scissors, Messenger, and Crafter. Completion rate, for Hanoi, Messenger, and Minecraft. And then score, defined separately for each game so that every environment produces one comparable number.
[S] Define score per game. I want this precise, because I suspect it is where the paper's most confusing number lives.
[G] Then let me be precise. For Bandits and Rock Paper Scissors, the score is the number of times the agent's action matches the environment's optimal action. For Hanoi, the number of disks successfully moved to the goal peg. For Messenger, the score is the same as its reward. For Crafter, the number of unlocked achievements at every step, summed across the whole episode. For Minecraft, a binary indicator of whether the find objective was completed.
[O] Crafter's is the strange one. Summed at every step, across ten thousand steps.
[G] Which makes it a speed-weighted achievement measure. Unlock something early and you bank it for every remaining step. The human baseline's raw Crafter number is two thousand six hundred and eighty, and that is a sum, not a count of achievements.
[S] And the nine capabilities?
[G] Long text understanding, reasoning, instruction and rule following, planning, generalization, understanding the odds, learning from interactions, error and mistake handling, and spatial reasoning. Each has its own three or four point degree scale. Spatial reasoning, for example: one is none or one-dimensional, two is two-dimensional, three is three-dimensional.
[O] And then each game gets assigned a degree on each axis.
[G] In Appendix Table 3, hand-assigned by the authors. Minecraft is the only three on spatial reasoning. Crafter is the only four on learning from interactions, and the only four on long text understanding. Hanoi and Crafter are the only threes on planning and on reasoning.
[S] Why is Crafter alone at four on learning from interactions?
[G] Because its manual is incomplete on purpose. The context string does not state that a crafting table takes two wood, or that a furnace takes eight stone. The agent has to discover both by failing.
[O] That is a genuinely lovely piece of benchmark design.
[G] It is. And these degrees are not decorative, they are the weights. A model's capability score on an axis is the degree-weighted average of its human-normalized game scores. Sum of degree times score, divided by sum of degree. Those are the numbers plotted in the Figure 3 radar charts.
[S] All right. Table 2.
[G] One caveat before any numbers. The paper's text says it experiments with nine recent popular open-source and proprietary language models. Table 2 and Table 4 both show eight model rows plus a human baseline. I will use eight, because that is what the data supports, but the discrepancy is there in print and the paper never reconciles it.
[O] Eight models. Which ones?
[G] GPT-4-0613, GPT-4-0314, text-davinci-003, Claude, Bard, and three LLaMA-family open models: llama-2-13b, llama-13b, and vicuna-13b. Across seven settings: Bandit, Rock Paper Scissors, Hanoi, Messenger level one, Messenger level two, Crafter, and Minecraft. Messenger level three exists in the benchmark but is absent from Table 2.
[S] And every cell is normalized so the human row reads exactly one point zero zero.
[G] Every cell, every game.
[O] Give me the headline.
[G] The paper frames it as three gaps. About ten points on three-disk Hanoi, where GPT-4-0314 scores zero point nine zero. About forty points on Minecraft creative navigation, where the best score in that column is zero point six one. And about seventy points on Crafter, where the best score is GPT-4-0314's zero point three two.
[S] Three different games, three different score definitions, so I want them kept apart. The Hanoi number is disks moved to the goal peg. The Minecraft number is a completion indicator. The Crafter number is a summed achievement count. Those are not the same units wearing different hats.
[G] That is the right discipline, and the paper's prose does not always keep it. On Hanoi specifically, the raw human baseline is three disks. GPT-4-0314 averaged two point seven. That difference is the entire ten-point gap.
[O] Two point seven out of three sounds much closer to solved than the word "gap" implies.
[S] On a three-disk puzzle whose recursive solution is in every textbook, yes.
[G] And that is precisely where the contamination finding bites, which is worth taking in its own right.
[O] Minecraft next.
[G] The best score is zero point six one, and it is shared. GPT-4-0613 and llama-2-13b both land there. The spread across all eight models runs from zero point four three to zero point six one.
[S] Stop there. A thirteen-billion-parameter LLaMA-2 ties GPT-4, and the entire eight-model field sits inside eighteen points of each other. That is not a capability measurement. That is a task whose outcome is mostly determined by something other than the model.
[G] The paper says something close to that itself. It writes that all models behave similarly in the Minecraft creative tasks, with the best model at sixty percent of human baseline. It attributes the flatness to the difficulty of three-dimensional spatial reasoning.
[S] That is one explanation. Another is that finding a biome inside two hundred steps has a large luck component, and this paper reports no random-policy baseline anywhere. Not for Minecraft, not for Crafter, not for any game.
[G] That is correct and I will not defend it. There is no random or scripted floor in this paper. So for a column spanning zero point four three to zero point six one, you genuinely cannot tell how much of that range is skill.
[O] I will concede that one. Although the diagnosis, that these models cannot navigate in three dimensions from text, is supported by the qualitative section independently of the score.
[G] It is. The paper reports models issuing a run of "move north" followed by a run of "move south", undoing their own exploration. That is a mechanism, not just a number.
[S] Now the one I flagged at the top. Text-davinci-003, one point oh four on Bandit. Above the human baseline.
[G] Let me unpack that carefully, because it is easy to get wrong. Bandit's Table 2 entry is not expected reward. It is the normalized score, and Bandit's score is the count of rounds in which the agent picked the environment's optimal action, across a fifty-round rollout. In Table 4, text-davinci-003's raw number is forty six point nine two. The human baseline's raw number is forty five. Forty six point nine two divided by forty five is one point oh four.
[O] So the humans left about five rounds of exploration on the table.
[G] Roughly, yes. And note what is not available to any agent here. The arm payoff probabilities are hidden, and the paired probability-and-reward list is shuffled specifically so that a biased action cannot exploit the game. There is no fixed good arm sitting in a fixed position to be memorized.
[S] Then the honest reading is that this metric does not punish under-exploring. A model that locks onto the better arm early and never revisits scores near the top. A human who keeps sampling to be sure gives up matches.
[G] That is my read as well, and I will flag it as a step beyond the paper. It does not break down exploration behavior per model, so we are inferring the mechanism from the metric's definition rather than from reported evidence.
[O] Fine, but let me name what is right about it too. The metric is honest about what it measures. It says optimal-action match count, not reward. The paper never claims a model beat humans at bandits.
[S] Agreed. My complaint lands on the denominator, not on the metric.
[O] The finding I found genuinely surprising is Vicuna.
[G] Vicuna-13b scores below its own un-tuned base model, llama-13b, on six of the seven settings. Hanoi, zero point zero seven versus zero point three three. Messenger level one, zero point zero zero versus zero point one six. Rock Paper Scissors, zero point one seven versus zero point five zero. The only setting where it comes out ahead is Messenger level two, zero point one two versus zero point zero six.
[S] And Vicuna is supervised instruction tuning on conversation data. Not RLHF.
[G] Correct, and worth stating plainly because it gets misremembered constantly. Vicuna-13b is a supervised fine-tune of LLaMA-13b on shared conversations. The paper's own radar reading is that it loses reasoning, planning, long text understanding, and error handling after that fine-tuning.
[O] So the alignment tax shows up in agency, not just in style.
[S] On one model, at thirteen billion parameters, with ten Hanoi trials. I would call that a strong hypothesis, not a result.
[G] I would split it. The direction is consistent across six settings with different metrics, which is more than a fluke. But there is no variance reported anywhere in this paper. No error bars, no confidence intervals, in either table.
[O] What does the capability radar add on top of the raw table?
[G] Texture the aggregate hides. Both GPT-4 variants score comparatively lower on learning from interactions, error and mistake handling, and spatial reasoning than on the other six axes. Claude is described as overall better than Bard, especially in planning, reasoning, and instruction following. Text-davinci-003 comes out biased toward learning from interaction and randomness, and particularly weak at instruction following, planning, and reasoning.
[S] Which reads suspiciously like a restatement of "davinci did well on Bandit and badly on Rock Paper Scissors and Hanoi", run through a weighting matrix the four authors assigned themselves.
[G] That is a fair description of the mechanism. The radar is a linear re-weighting of the same seven numbers. It cannot contain information those seven numbers do not already carry. Its value is interpretive, not evidential.
[O] Bring in the Hanoi contamination finding. It is the part I keep thinking about.
[G] It is the best observation in the paper. Every model here has certainly seen Tower of Hanoi in training. And indeed, from the canonical starting configuration with all disks on the first rod, the models hand you the solution, some of them writing out the recurrence. But once play has scattered the disks across all three rods, most of them get confused within a few moves. The authors' inference is that those intermediate states do not appear often in training corpora.
[O] That is a memorization boundary you can point at. A static question-answering benchmark structurally cannot produce that.
[S] It is genuinely clever. It is also one game out of six. The claim in the introduction is that games in general are more robust to dataset contamination. That general claim rests on this one anecdote plus an untested assumption that procedural generation in Messenger, Crafter, and Minecraft does the same work. No seed-overlap test, no string-overlap test, nothing on the other five environments.
[G] Both of those are right. In fairness, the paper hedges rather than overclaims. It says the observation verifies their belief, which is a phrase doing a lot of work.
[S] Now let me make my strongest deflationary case, and it is about the denominator. Every number in Table 2, and every axis of the radar built on top of it, is divided by a human baseline of three players. Appendix D point one says those three players include the authors. Not blinded. Not independent of the benchmark's design.
[O] Familiarity with the API is arguably necessary to play these at all.
[S] It is, and that is exactly the trap. The trials are also wildly uneven. Each player did three rounds of Bandit and three of Rock Paper Scissors, five rounds each of Messenger levels one and two, and one single round each of Hanoi, Crafter, and Minecraft.
[G] Which is three total playthroughs on Crafter, three on Minecraft, three on Hanoi, summed across every player.
[S] Three Crafter playthroughs, setting the denominator for a ten-thousand-step, twenty-two-achievement game, on the exact axis where the paper reports its largest gap. Two thousand six hundred and eighty is a very thin draw from a very wide distribution.
[O] Here is where I push back, though. If the human number is noisy, the direction of the error is unknown. Three motivated players who built the environment could just as easily have set a low ceiling as a high one.
[G] That is right, and the size of the Crafter gap probably survives the noise either way. GPT-4-0613's raw Crafter score is seven hundred against a human two thousand six hundred and eighty. You would need the human number to be wrong by nearly a factor of four for the qualitative conclusion to flip.
[S] I accept that on Crafter. I do not accept it on Bandit, where the distance between one point oh four and one point zero zero is smaller than the noise in three players times three rounds.
[G] Agreed. Score that one to the skeptic.
[O] Elias, you said at the top that the appendix was interesting in more than one sense. Cash that in.
[G] Appendix D point two prints the normalization formula. As printed, the normalized score equals the human score minus the raw score, over the human score minus the minimum possible score.
[S] Say that again. Human minus raw, in the numerator?
[G] As printed, yes. And that is not the formula the tables were computed with. Take Crafter, GPT-4-0613. Raw seven hundred, human two thousand six hundred and eighty, minimum zero. The printed formula gives twenty six eighty minus seven hundred, over twenty six eighty, which is zero point seven four. Table 2 reports zero point two six.
[O] And zero point two six is one minus zero point seven four.
[G] Exactly. The complement, raw minus minimum over human minus minimum, gives seven hundred over twenty six eighty, which is zero point two six one. That matches. And I checked it against every cell, eight models by seven games, fifty six numbers. The complement reproduces all of them.
[S] Including the ones with a negative floor? Messenger's reward bottoms out at minus one.
[G] Including those. Messenger level one, GPT-4-0613: raw zero point eight, human one, minimum minus one. The complement gives one point eight over two, which is zero point nine zero, and Table 2 says zero point nine zero. The printed formula would give zero point one zero.
[O] And the cleanest tell has to be the human row itself.
[G] The cleanest tell is the human row. Put the human's own raw score into the printed formula and the numerator is human minus human. Zero. On every game. As printed, the formula assigns the human baseline a score of zero point zero zero across the board, while Table 2 shows the human row as one point zero zero everywhere.
[S] So let us be careful about what we are actually saying here. This is not fabricated data.
[G] It is not, and I want that stated flatly. The tables are internally consistent. Table 2 is exactly derivable from Table 4. Every conclusion the paper draws is unaffected. This is a copyediting slip in one printed equation, where the two terms in the numerator are swapped relative to what the authors actually computed.
[O] But it is a load-bearing slip, because that equation is the one thing in the paper that lets a reader independently re-derive the main table.
[G] That is the cost. Someone reproducing SmartPlay from the appendix rather than from the released code would invert every score in the benchmark and conclude that GPT-4 comfortably beats humans on Crafter.
[S] That is a nice inversion of the usual failure mode. The paper's results are fine and its instructions are wrong.
[O] Let me make the optimist case properly, then. This paper does something almost no evaluation in 2023 did. It produces failure modes with mechanisms attached. Hanoi shows you exactly where memorization stops. Minecraft shows the model undoing its own exploration. Crafter shows GPT-4 trying to build a crafting table with one wood and then recovering with two. Those are engineering targets. A leaderboard rank is not.
[S] And my deflationary case is that the top-line framing, a single human-normalized score plus a nine-axis capability profile, is a far more confident object than its foundations support. Three players including the authors. One round each on the three hardest games. A capability weighting the authors assigned with no independent annotation and no inter-rater check. No random baseline. No error bars. No prompting ablation.
[G] Let me adjudicate. On the per-game qualitative findings, the optimist wins outright. Those are well documented, they carry mechanisms, and they are what the benchmark is genuinely for. On the aggregate normalized score, the skeptic wins: three players, uneven trials, no variance reporting. On the capability radar the skeptic wins more narrowly, because it is a subjective re-weighting, but the paper does publish the weights in Table 3, so it is auditable rather than hidden.
[O] I will take that split.
[G] And on the Crafter gap specifically I score to the optimist. Seven hundred against two thousand six hundred and eighty is too large to be a baseline artifact.
[S] What would you actually want changed, Elias?
[G] Three things. A larger, blinded human baseline with equal trial counts across all seven settings, rather than three rounds on the easy games and one on the hard ones. A contamination check, seed novelty or string overlap, extended past Hanoi to Messenger, Crafter, and Minecraft. And either an independently validated capability weighting, or failing that, the release of raw per-trial transcripts so a reader can rebuild the radar without trusting the authors' own degree labels.
[O] And the broader lesson for agent evaluation?
[G] That the thing worth keeping from SmartPlay is the structure, not the leaderboard. Six environments behind one API, each tagged with which capabilities it stresses and at what degree, so that a failure can be traced to a skill instead of to a rank. That template outlived these particular numbers, and you can see it in the agent benchmarks that came after.
[S] I would add a practice note. When your metric is a bespoke per-game score, normalize with extreme care, and print the formula you actually used. This paper is a clean case study in what happens when you do not.
[O] Takeaways. Mine: SmartPlay is the rare benchmark whose failures arrive with mechanisms attached, and the Hanoi memorization boundary alone justifies the design.
[S] Mine: treat the human-normalized one point zero zero and the nine-axis radar as illustrative. The evidence lives in the per-game transcripts, not in the aggregate.
[G] And the paper's: six games behind one text API, nine capabilities, and the finding that even the strongest model tested falls well short of a human once the task gets hard. Zero point nine zero on three-disk Hanoi, zero point six one at best on Minecraft creative navigation, and zero point three two at best on Crafter.
[O] The full writeup, with the figures, both tables, and the normalization arithmetic worked out, is on the litsearch site. Thanks Elias.
[G] Thank you both.
