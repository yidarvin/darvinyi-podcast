---
slug: foerster-2017-coma
title: "COMA: Counterfactual Multi-Agent Policy Gradients"
description: "A single centralized critic learns to ask each cooperative agent one counterfactual question, what would the team have gotten if only you had acted differently, and answers it in one forward pass instead of re-simulating the world."
date: 2026-07-19
guest_name: "Elena"
guest_voice: "af_bella"
---
[O] Picture three marines on a StarCraft map. The team wins the fight. All three get the exact same reward. Only one of them landed the killing blow, and from that shared number alone, none of them can tell if it was them.
[S] The classic fix, difference rewards, means rewinding the simulator, swapping one unit's action for a default, and replaying the fight to see what would have happened without it. You cannot rewind StarCraft. So how do you get the counterfactual without the replay?
[O] That is the whole trick here. They build the counterfactual out of a learned critic instead of a second simulation, in a single forward pass.
[S] And it only works because every agent shares one critic and one reward. The moment agents want different things, the design falls apart.
[O] Welcome to Litsearch Audio, where an optimist and a skeptic argue about a paper until someone who actually knows it settles the score.
[S] Today's paper is Counterfactual Multi-Agent Policy Gradients, COMA, by Jakob Foerster and colleagues at the University of Oxford. Posted to arXiv in May twenty seventeen, published at AAAI in twenty eighteen.
[O] Joining us is Elena, who has spent real time with this paper's proofs and its ablations. Welcome, Elena.
[G] Thanks for having me. One ground rule: I did not write this paper, so when I say "they show," that is the paper talking, not me.
[S] Elena, start with the actual gap. Why is cooperative multi-agent reinforcement learning harder than running single-agent RL five times over?
[G] Two reasons. First, if every agent's policy is changing at once, the environment looks non-stationary from any one agent's point of view. Second, and this is what the paper is actually built to fix, cooperative agents typically share one global reward. A winning joint action produces the identical number for the agent that made the decisive play and for one that did nothing useful. That is multi-agent credit assignment.
[O] And the classic answer is difference rewards.
[G] Right, from Wolpert and Tumer in two thousand two. Compare the real global reward to what it would have been if one agent had taken some default action instead, holding everyone else fixed. Powerful idea, but it needs a separate re-simulation per agent, per timestep, and nobody has a principled answer for what that default action should even be.
[S] Which a physics sandbox can afford, and StarCraft cannot.
[G] Exactly. You cannot freeze the game, swap one command, and replay it.
[O] So what were people actually doing to control StarCraft units before this?
[G] Two prior lines the paper compares against, Usunier and colleagues' greedy-MDP controller, and Peng and colleagues' bidirectionally coordinated networks. Both give one centralized controller the full game state plus the engine's built-in attack-move macro-action, which auto-paths a unit into firing range and fires automatically. That is meaningfully easier than genuine decentralized control, where each unit sees only its own local surroundings and issues raw move, attack, stop, or no-op commands.
[S] So prior "state of the art" wasn't solving the decentralized problem, it was solving an easier one and calling it StarCraft micromanagement.
[G] That's the authors' own framing. And the alternative, fully independent per-agent learners, throws credit assignment away entirely, each agent's critic only ever sees its own local reward.
[O] So the goal is: exploit the fact that training happens in a simulator, where every agent can see everything, but ship a policy that only needs local information once deployed.
[G] Exactly, centralized training, decentralized execution. The paper's contribution is a specific policy-gradient method built for it.
[S] Get into the mechanism, because "counterfactual baseline" is doing a lot of work in that title.
[G] Three ideas, stacked. First, a single centralized critic, Q of s, tau, u, learned only during training, conditioning on the true global state, every agent's action-observation history, and everyone's joint action. Each actor still conditions only on its own local history. Only the actor survives to execution.
[O] So the critic spies on the whole game while training the team, then disappears.
[G] Right. The naive way to use it is the plain temporal-difference gradient, and the paper shows this fails at exactly the thing it needs to do: every agent gets the same team-level error regardless of what it specifically did, and that shared signal gets noisier as more agents explore at once.
[S] Same disease as the shared reward, one layer deeper.
[G] Exactly, so second, COMA replaces that shared baseline with something computed per agent. Take the critic's Q value for the joint action actually taken. Subtract the expectation of that same Q value if you resampled only this agent's action from its own policy, holding everyone else's action fixed at whatever it actually did.
[O] Say that again slowly, because that's the whole idea.
[G] For agent a: given everyone else did exactly what they did, how good was this agent's specific choice, versus what the critic expects on average if this agent had done something else? That is precisely difference rewards, just computed by querying a learned model instead of re-simulating the world.
[S] There's a subtlety worth naming. Value-based versions of this, the aristocrat utility, have a nasty self-consistency problem, the utility and the policy depend on each other recursively.
[G] Good catch, and the paper addresses it directly. This term is a policy-gradient baseline, and a baseline's expected contribution to the gradient is always exactly zero, regardless of what it depends on. They prove that in the appendix. So it can depend on the policy without breaking anything.
[O] And the third idea is what makes it cheap enough to run.
[G] The critic is architected so the other agents' actions are part of its input, and in one forward pass it outputs a Q value for every one of this agent's possible actions at once. So the counterfactual sum costs one extra dot product, not a separate query per action, and because one critic is reused across every agent, all agents' advantages come out of one batched pass.
[S] One critic, reused by everyone. I want to come back to what that efficiency costs.
[G] We will. The resulting COMA gradient sums each agent's log-probability gradient weighted by its own counterfactual advantage, and Lemma one claims this converges to a locally optimal joint policy under the same assumptions as ordinary single-agent actor-critic convergence.
[O] Give us a sense of what's actually running under the hood, because a nice equation still has to be trained.
[G] Each actor is a small recurrent network, a hundred twenty-eight unit gated recurrent unit, turning one agent's local observation history into a hidden state, then a bounded softmax into that agent's action probabilities. The centralized critic is a feedforward network sitting on top of the global state and the joint action. Training uses a variant of TD lambda with lambda set to point eight, and exploration is annealed from fifty percent random down to two percent over the first seven hundred fifty episodes.
[S] And the reward that's driving all of this?
[G] Deliberately simple and fully shared: damage inflicted on the enemy minus half the damage taken, every timestep, plus ten points for each enemy killed, plus the team's remaining total health plus two hundred for winning the fight outright. Every agent sees that identical number. The counterfactual baseline is the only place individual credit ever gets teased back out of it.
[O] Move to the evidence. Where do they test this?
[G] Decentralized StarCraft unit micromanagement, harder than prior work's version. Each unit gets a field of view equal to its own firing range and issues raw commands itself. Four scenarios: three marines, five marines, five wraiths, and a mixed team of two dragoons plus three zealots.
[S] Averaged how?
[G] Thirty-five independent training runs per method per map, evaluated over the final one thousand episodes. On three marines, COMA's mean win rate is eighty-seven percent, give or take three points. The strongest ablation, central-V, gets eighty-three. The two fully independent baselines get fifty-six and forty-seven.
[O] Huge gap against the independent baselines.
[G] And it holds across every map. Five marines: COMA eighty-one versus the best ablation's seventy-one. Five wraiths: eighty-two versus seventy-six. Then the fourth map, mixed dragoons and zealots, is where it gets interesting. COMA's mean is forty-seven, its strongest learned rival gets thirty-nine, but a simple hand-coded heuristic, just run into range and focus fire, gets sixty-three. It beats COMA's mean outright.
[S] The dumbest baseline in the paper beats the paper's own method, on the one map with two different unit types.
[G] On the mean, yes. COMA's single best run out of thirty-five hits sixty-five, narrowly past the heuristic, but the average run does not. That's the one scenario where the headline doesn't hold, and it's the only one with heterogeneous units and mixed firing ranges.
[O] I want to isolate what's earning COMA its wins elsewhere, because there's an ablation built for exactly that.
[G] Central-QV. Same centralized critic, but the counterfactual baseline is swapped for a plain learned Q minus V advantage. COMA beats central-QV on every map, in both training speed and final win rate, direct evidence that the counterfactual term specifically, not just centralizing the critic, is doing the work.
[S] That's a clean ablation ladder. Independent versus centralized isolates one variable, Q versus V a second, counterfactual versus plain advantage a third.
[G] Agreed, that structure is one of the paper's real methodological strengths.
[O] What I find most impressive: how does this compare to the fully centralized, full-information controllers?
[G] Cautiously. Against Usunier and colleagues' greedy-MDP controller and a DQN baseline, both given the full state and the attack-move macro, COMA's best decentralized runs get close on five marines, ninety-five versus ninety-nine and one hundred. On five wraiths COMA's best actually beats that comparison, ninety-eight versus seventy-four, though that seventy-four was a policy trained on a larger map and only tested on five wraiths, so it's not fully apples to apples either.
[S] And that's COMA's best run out of thirty-five against someone else's number, not mean versus mean. You don't hire someone off their best day out of thirty-five interviews.
[G] Fair, and the paper is explicit this is a best-run comparison against a stronger baseline. Directionally impressive that a decentralized, partially observed policy gets close to a fully centralized one. Not a controlled experiment.
[O] Let's do the actual debate. Optimist's case: this solves a genuinely expensive problem, credit assignment, by replacing a physical re-simulation with one extra query against a critic you're already training. Central-QV proves that specific trick earns the wins, not just centralization. And the best runs approach or beat centralized state-of-the-art while giving up full observability.
[S] Skeptic's case: the whole method leans on one assumption, a single team reward to centralize a critic over. Competing or individually different rewards, and one shared critic stops making sense, untested here. On the one map with mixed unit types, the mean loses to a hand-coded heuristic, exactly the scenario closest to real deployment with varied agents. And on scaling, the authors tried a factored per-agent critic, found the bottleneck was exploration rather than the critic, and never published those numbers, so behavior past five agents is genuinely untested.
[G] Both fair, and I'd add one more: the original published proof of Lemma one had an actual error. The critic was supposed to depend on both the state and the joint history, and the first version's proof only accounted for the state. Frans Oliehoek and Chris Amato flagged this years later, the record was corrected, and follow-up work by Lyu and colleagues, running from twenty twenty-one through twenty twenty-four, has since studied whether centralized critics like this one actually converge well in general.
[O] So the theory wasn't as settled at publication as Lemma one implied.
[G] Correct, though the corrected proof still goes through, using the same underlying convergence argument applied properly to the history-dependent critic. It's a real caveat about confidence over time, not a fatal flaw.
[S] What about MADDPG, the other big twenty seventeen answer to centralized critics?
[G] The paper names it directly: Lowe and colleagues' concurrent work uses a separate critic per agent, doesn't address credit assignment the same way, and targets competitive, continuous-action environments. But nobody ever runs the two methods on the same benchmark. One shared, cheap critic with a purpose-built credit-assignment term, against N separate, more expensive critics that handle adversarial rewards natively. Neither claim, that COMA solves credit assignment MADDPG doesn't, or that MADDPG handles competition COMA can't, is demonstrated head to head.
[O] A narrative comparison, not an empirical one.
[G] Right, a real gap, not a damning one. It's the comparison a survey would need to run, not something either twenty seventeen paper was set up to answer.
[S] Last item: the four scenarios were chosen by the same lab that also designed the harder field-of-view variant of the benchmark. No independent check that the difficulty wasn't tuned around what COMA happens to do well.
[G] Fair structural point about any benchmark a method's own authors also design. In COMA's favor, the ablation ordering holds consistently across all four maps, including the worst one, which is some evidence against cherry-picking, even from a self-designed benchmark.
[O] Scoring this, the counterfactual baseline and the single-forward-pass trick are real, well-isolated contributions that survive every objection here.
[S] I'll concede that. What doesn't survive is "competitive with state-of-the-art" as an unqualified headline. True for three of four maps on best-run numbers, false for the fourth on the number that actually matters, the mean.
[O] Is there a broader lesson here for reading reinforcement learning papers generally?
[G] The ablation ladder is the model worth copying. Independent, centralized Q-minus-V, and counterfactual baseline each isolate exactly one design choice, which is what lets you say with confidence which piece earns the result. That discipline is rarer than it should be.
[S] And a reminder that one averaged headline number can hide the scenario where a method's advantage quietly disappears. You have to check every row of the table, not just the ones that got plotted.
[O] Closing thoughts. Elena, the paper's own takeaway.
[G] A single centralized critic, paired with a counterfactual baseline computed in one forward pass, solves multi-agent credit assignment without extra simulations, and it holds up against both independent learners and centralization without the counterfactual term.
[O] Mine is that this is elegant engineering, turning an expensive simulate-the-counterfactual idea into one cheap query against a critic you're training anyway, opening a real path toward decentralized coordination problems that were stuck between fully independent agents and infeasible re-simulation.
[S] Mine is that the method's cleanliness comes from an assumption, one shared reward to centralize over, that quietly limits where it applies, and the authors' own honesty about what they didn't test, scaling past five agents, competitive rewards, a real head-to-head with MADDPG, is exactly what you should read before citing the headline number.
[O] That's it for this episode. For the figures, the full ablation table, and the eval-rigor writeup this conversation was built on, head to litsearch dot darvinyi dot com and look up COMA.
