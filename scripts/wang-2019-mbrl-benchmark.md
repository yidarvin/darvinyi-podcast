---
slug: wang-2019-mbrl-benchmark
title: "Benchmarking Model-Based Reinforcement Learning"
description: "Eleven model-based RL algorithms, four model-free baselines and two ground-truth-dynamics oracles across eighteen environments under one protocol — a diagnosis of why model-based RL plateaus, and a table whose biggest numbers belong to methods that were allowed to cheat."
date: 2026-08-01
guest_name: "Callum"
guest_voice: "bm_george"
---
[O] The headline from this paper is a tie. Model-based and model-free reinforcement learning, run under one shared protocol across eighteen environments, come out as, in the authors' own words, two almost evenly matched rivals at two hundred thousand time-steps.
[S] And the number I want next to that headline is fourteen thousand seven hundred seventy seven. That is the best score anything achieves on HalfCheetah in the same table. It does not belong to a model-based algorithm and it does not belong to a model-free one.
[O] It belongs to a method that was handed the simulator's real physics.
[S] Which is the single most important thing to know before you read a word of this table. There are rows in it that were allowed to cheat, and they are printed in the same columns as everybody else.
[O] Welcome to Litsearch Audio. I'm the optimist, and I want to defend this paper hard, because I think the cheating rows are the best design decision in it.
[S] I'm the skeptic, and I agree with her, which should tell you something. My complaints are elsewhere.
[O] Today's paper is Benchmarking Model-Based Reinforcement Learning, by Tingwu Wang, Xuchan Bao, Ignasi Clavera and colleagues, out of the University of Toronto, the Vector Institute and UC Berkeley, posted to arXiv in July twenty nineteen. Joining us is Callum, who has spent serious time inside this paper's appendix. Welcome, Callum.
[G] Thank you. And I would echo that framing. This is a paper where almost every mistake a reader can make comes from forgetting which rows had access to the true dynamics.
[S] Start further back, Callum. Why did anyone need to benchmark model-based RL in twenty nineteen?
[G] Because the field had a very attractive promise and no way to check it. Model-based RL learns a model of the environment's transition dynamics, then either plans against that model or trains a policy on imagined rollouts from it. The claim is enormous sample efficiency, because you can generate experience without touching the real environment.
[O] And by twenty nineteen there was a run of papers each claiming to have delivered on that.
[G] Several. PETS, ME-TRPO, SLBO, MB-MPO. Each one showed its own method matching model-free asymptotic performance with far fewer environment interactions. The abstract's objection is blunt: research in model-based RL has not been very standardized. Authors experimented with self-designed environments, and several lines of work were closed-source or not reproducible.
[S] So the comparisons were never actually run.
[G] The paper is careful about this. It says the problem is exacerbated in model-based RL specifically by modifications made to the environments. Pre-processing of observations, modification of reward functions, different episode horizons. All three change the number and none of them were consistently disclosed.
[O] And there is precedent for this being a real failure and not just tidiness.
[G] There is, and the paper cites it. Model-free RL went through the same reckoning. The paper points at rllab, at OpenAI Gym, at the DeepMind Control Suite as the standardization that helped, and at Henderson and colleagues, Deep Reinforcement Learning that Matters, for the evidence that unstandardized RL comparisons routinely fail to replicate. Model-based RL had no equivalent.
[S] Fine. So what did they actually build, Callum? Be precise about the counts, because I have already seen three different numbers quoted from this paper.
[G] Then let me be very precise, because the counts are where people go wrong. Eleven model-based algorithms. Four model-free baselines. Eighteen environments. And eighteen rows in the main results table, which is not the same as any of those numbers.
[O] Walk the eleven.
[G] They fall into three structurally distinct families. Dyna-style methods, which alternate between fitting a dynamics model and training a model-free policy on imagined rollouts from it — that is ME-TRPO, SLBO and MB-MPO, three of them. Policy search by backpropagating through time, which differentiates the objective straight through the dynamics model — PILCO, iLQG, GPS and SVG, four of them. And shooting methods, which sample and score candidate action sequences against the model at every step and execute only the first action — RS, MB-MF, PETS-RS and PETS-CEM, four of them. Three plus four plus four is eleven.
[S] And the eighteen rows?
[G] Eleven model-based, plus four model-free — TRPO, PPO, TD3 and SAC — plus a random baseline, plus two additional ground-truth-dynamics variants called GT-CEM and GT-RS. Those two swap the learned dynamics model for the simulator's real physics. Eleven, four, one and two is eighteen rows.
[O] So the oracles are the extra two.
[G] Not quite, and this is the detail that trips everyone. There are three rows in that table with access to ground-truth dynamics, not two. GT-CEM and GT-RS are the two extras. But iLQG, which is counted among the eleven model-based algorithms, also plans directly against the true dynamics rather than a learned one. So the subset of rows that actually learn a dynamics model is ten, not eleven.
[S] Ten. Say that again for anyone driving.
[G] Ten learned-dynamics algorithms. Eleven model-based algorithms. Eighteen rows. And the paper's own ranking table is computed over the ten, excluding iLQG precisely because it always uses ground-truth dynamics.
[O] Tell me about the environments, because the paper says they are modified, and modified benchmarks make me nervous.
[G] Modified and disclosed, which is the important pairing. Eighteen continuous-control environments built on OpenAI Gym, running from CartPole and Acrobot up to Humanoid. Three deliberate changes. First, reward functions were reshaped so that a gradient with respect to the observation always exists or can be approximated — iLQG and GPS differentiate through the reward, so without that they simply cannot run.
[S] That is a genuine confound though. You have changed the objective to accommodate two of the fourteen entrants.
[G] You have. And the second modification is arguably larger. Early termination — ending an episode when the agent falls over, say — is standard in model-free RL and had never been systematically applied in model-based RL. So they built both versions: the raw environment and an early-termination twin marked with the suffix E T. There are five of those twins among the eighteen.
[O] And the third?
[G] The original Swimmer task in OpenAI Gym was, in the paper's words, unsolvable for all algorithms. So they moved the position of the velocity sensor to make it easier, kept the original as a reference, and benchmarked both. That is why the environment list has both Swimmer and Swimmer-v-zero in it.
[S] What is the protocol on top of that?
[G] Four random seeds per run. Learning curves smoothed with a sliding window of five algorithm iterations. Table numbers averaged over the seeds with a window of five thousand time-steps. And a grid search per algorithm, summarized in the appendix, from which they report the hyper-parameters producing the best average performance.
[S] Hold that last sentence. I am coming back to it.
[O] Let's do the results. Callum, the two-hundred-thousand-step table first.
[G] At two hundred thousand steps it is genuinely close. Take HalfCheetah. MB-MPO, a Dyna-style learned-dynamics method, finishes at three thousand six hundred thirty nine. TD3, a model-free baseline, finishes at three thousand six hundred fourteen. Those are effectively identical means.
[O] That is the whole model-based promise in one line. Same score, and the model-based method got there with a learned model.
[S] Same score with wildly different spreads. What are the error bars?
[G] MB-MPO is plus or minus one thousand one hundred eighty six. TD3 is plus or minus eighty two. So MB-MPO's standard deviation is more than fourteen times larger on four seeds.
[S] So it is a tie in the sense that a coin flip is a tie.
[G] That is a fair reading, and I would extend it. On that same HalfCheetah column, SAC reaches four thousand point seven, which makes it the strongest non-oracle algorithm at that budget. But GT-CEM, the ground-truth oracle, reaches fourteen thousand seven hundred seventy seven, with a standard deviation of nearly fourteen thousand. So the strongest algorithm in that column is not SAC and it is not any learned method.
[O] The oracle spread is as big as its mean.
[G] It is, and that is worth holding onto. But even discounted heavily, it says the environment supports far more reward than any learned model captures.
[S] What about the aggregate ranking? A single environment proves nothing.
[G] There is a ranking table, computed across all eighteen environments over the ten learned-dynamics algorithms. Two rows: mean rank out of ten, and median rank out of ten. PETS-CEM and SLBO tie for the best mean rank, both at four point zero. SLBO alone has the best median, at three point five. PETS-CEM and SVG tie for second-best median at four.
[O] And the bottom?
[G] GPS at seven point seven mean and eight point five median. PILCO at nine point five mean and ten median — a median of ten out of ten means it placed last on at least half the environments it ran on, and there were many it could not run on at all.
[S] So there is a winner. SLBO.
[G] The paper declines to say so, and I think correctly. Its own summary sentence is that across this very substantial benchmarking, there is no clear consistent best model-based RL algorithm. A gap of four point zero versus four point seven in mean rank, on four seeds, is not a result.
[O] Okay, but the thing that actually changed my reading of this paper is the long-horizon table. Tell them.
[G] They extended six algorithms to one million time-steps — PETS-CEM, ME-TRPO, MB-MPO, SLBO, TD3 and SAC — on four environments: HalfCheetah, Walker2D, Hopper and Ant. This is where the paper's first named failure mode comes from, the dynamics bottleneck.
[S] Give me HalfCheetah at one million.
[G] SAC climbs to six thousand ninety five. TD3 to five thousand seventy three. MB-MPO, the best learned-dynamics method there, reaches four thousand five hundred thirteen. Then it drops off steeply — PETS-CEM at two thousand eight hundred seventy six, ME-TRPO at two thousand six hundred seventy three, SLBO at two thousand forty one.
[O] And the point is that PETS-CEM barely moved.
[G] Barely. Its two-hundred-thousand-step HalfCheetah score was two thousand seven hundred ninety five. Five times the data buys it eighty points. The paper says it plainly: PETS's performance plateaus after four hundred thousand time-steps at a value much lower than the performance when using the ground-truth dynamics.
[S] So the parity at two hundred thousand was a parity of the early curve, not of the ceiling.
[O] On three of the four environments. Callum, do Hopper, because Hopper is the exception and it is a real one.
[G] It is. On Hopper at one million steps, SLBO reaches two thousand nine hundred sixty three, plus or minus three hundred twenty three. TD3 reaches two thousand seven hundred forty six, plus or minus five hundred forty seven. So SLBO finishes above TD3, and close to SAC's three thousand and twenty.
[O] A learned-dynamics method beating a model-free baseline at the asymptote. That is the thing the field was promised.
[S] On means. Say the intervals out loud, Callum.
[G] I will. SLBO's one-standard-deviation band runs from about two thousand six hundred forty to about three thousand two hundred eighty seven. TD3's runs from about two thousand one hundred ninety nine to about three thousand two hundred ninety two. Those overlap across most of their range, on four seeds. It is a real result and it is a fragile one.
[S] Thank you.
[O] I will still take it, because it is directional. And Hopper is the environment where SLBO started terribly — what was its two-hundred-thousand-step Hopper number?
[G] Minus seven hundred forty two. So it goes from deeply negative at two hundred thousand steps to nearly three thousand at one million. That is not a plateau, that is a method that simply needed more data than the short budget gave it. Which cuts against the sample-efficiency story from the other direction.
[S] That is a good point and I want to sit on it. The paper's framing is that model-based methods win early and stall late. SLBO on Hopper does the opposite.
[G] It does. And I would add the other side of Table four. Walker2D at one million steps has ME-TRPO at minus two thousand nine hundred forty seven and MB-MPO at minus one thousand seven hundred ninety four. Those are not plateaus, those are collapses. SLBO on Walker2D is one thousand three hundred seventy two, plus or minus two thousand seven hundred sixty two — a standard deviation twice the mean.
[O] Let's do the other two named failure modes and then argue.
[G] The second is the planning horizon dilemma, and it applies to the shooting methods. The finding is counterintuitive: increasing the planning horizon does not necessarily increase the performance, and more often instead decreases it. A horizon between twenty and forty works the best — and crucially, that is true both for the models using ground-truth dynamics and the ones using learned dynamics.
[S] Which kills the obvious explanation.
[G] Exactly. If it were only modelling error compounding over the rollout, the oracle would not show it. The paper attributes it to the curse of dimensionality — the search space grows exponentially with planning depth and the sampler cannot cover it.
[O] And the third.
[G] The early-termination dilemma. Compare each environment to its E T twin in the main table. PETS-CEM falls from one thousand one hundred sixty six on Ant to eighty two on Ant with early termination. ME-TRPO from two hundred eighty two to forty three. MB-MPO from seven hundred six to thirty. The paper says it tried several additional schemes to incorporate early termination and that none of them were successful.
[S] Does anything survive that transition?
[G] One row out of eighteen. SAC goes up, from five hundred seven on Ant to two thousand and thirteen on Ant with early termination. Every other row in that column falls, and that includes the other three model-free baselines. PPO drops from three hundred twenty one to eighty. TRPO from three hundred twenty three to one hundred seventeen. TD3 from nine hundred fifty six to two hundred sixty.
[O] So it is not model-free versus model-based on that column. It is SAC versus everything.
[G] It is SAC versus the other seventeen rows, yes. Which matters because it is very easy to write that sentence as a class claim and be wrong.
[S] And who actually wins that column?
[G] Not SAC. GT-RS, the ground-truth random-shooting oracle, scores two thousand five hundred nineteen on Ant with early termination, which is the highest number in the column. The paper's own prose says GPS has the best performance in Ant-ET — and that is true, but only inside the ten learned-dynamics algorithms, where GPS's two hundred seventy five edges out RS's two hundred forty. Three different superlatives, three different scopes, one column.
[S] Is that a model-based problem or a model problem?
[G] That is the right question, and the appendix answers it more sharply than the main text does. Hold it for two minutes.
[O] Before the debate, one thing the writeup on the site does not cover and I think deserves air: the noise study.
[G] Section four point four. They add Gaussian white noise to observations and to actions, at two magnitudes each, and report the change in HalfCheetah performance. The pattern is that ME-TRPO and SLBO are more likely to suffer a catastrophic drop than shooting methods like PETS and RS — the paper's reading is that re-planning every step compensates for the uncertainty.
[S] Numbers.
[G] At observation noise with standard deviation zero point one: ME-TRPO loses one thousand eight hundred seventy four off a base of two thousand two hundred eighty four. SLBO loses eight hundred eighty five off one thousand ninety eight. PETS loses nine hundred sixteen off two thousand seven hundred ninety five — about a third. MB-MPO is the standout for robustness: at the smaller observation noise it loses three and a half points out of three thousand six hundred thirty nine.
[O] And the oracle under noise?
[G] Loses thirteen thousand one hundred thirty nine off its fourteen thousand seven hundred seventy seven. And iLQG loses more than it had — two thousand one hundred sixty eight off a base of two thousand one hundred forty three, so it lands below zero.
[S] So the ground-truth-dynamics methods are the most noise-fragile things in the paper.
[G] At that noise level, yes. Which is a nice corrective to reading the oracle rows as an upper bound in any general sense. They are an upper bound under clean observations only.
[O] Right. Let me make the optimist case and then you can knock it down. Three things. One: this is the first apples-to-apples comparison the subfield had, and the protocol is the contribution — same seeds, same window, same environments, disclosed modifications, open-sourced. Two: including the oracle rows is what turns a leaderboard into a diagnosis, because the gap between learned and ground truth is the actual finding. Three: at two hundred thousand steps model-based really is competitive, and on Hopper it holds at a million. The promise is not dead.
[S] I will give you two of those and fight you on the third. My case is four items. First, the hyper-parameters. The headline table uses, per algorithm, the setting producing the best average performance from a grid search. Not one fixed configuration across the board — each algorithm gets its own tuned setting, tuned with visibility into the very evaluation window being reported.
[G] That is accurate, and the paper does report a separate reference configuration meant to work reasonably across all environments. But it is right that the reference setting is not what generates the headline table or the rankings.
[S] Which is the number a practitioner actually needs. If I am picking an algorithm blind, I want the ranking under shared hyper-parameters, and the paper does not lead with it.
[O] Point to the skeptic.
[S] Second: four seeds, with headline gaps smaller than one standard deviation. Three thousand six hundred thirty nine versus three thousand six hundred fourteen with a spread of eleven hundred is not a result you can rank on. The paper cites Henderson and colleagues on exactly this reproducibility risk in its own introduction and then does not run a significance test on its own margins.
[G] I score that to the skeptic without reservation. It is the paper's clearest internal inconsistency.
[S] Third: the word universal. The main text says the early-termination dilemma is universal in all model-based RL algorithms we tested. The paper's own appendix has a counterexample — learned CEM on Walker2D goes from minus four hundred ninety three without early termination to plus two hundred ninety one with it. That is an improvement.
[O] Callum, adjudicate that one, because I think there is a mechanical explanation.
[G] There is, and it is the right way to read it. A Walker2D that falls over and is not terminated keeps accruing negative reward for the rest of a fixed-length episode. Early termination cuts the episode at the fall, so the return goes up without the policy getting any better.
[O] Which you could check by looking for the same sign flip elsewhere.
[G] And it is all over the main table's Walker2D pairs. RS goes from minus two thousand sixty to plus two hundred one. MB-MF from minus two thousand two hundred eighteen to plus three hundred fifty. SVG from minus one thousand four hundred thirty one to plus two hundred fifty two. SLBO from minus one thousand two hundred seventy eight to plus two hundred eight.
[S] So it is a return-scale artifact, not a counterexample.
[G] I believe so. Which makes universal defensible in substance and sloppy in wording. Half a point to the skeptic.
[O] What is your fourth, and then Callum has something.
[S] Fourth: compute. The paper reports wall-clock hours to train two hundred thousand steps, and this is where the sample-efficiency argument gets awkward. TRPO and PPO train in about zero point zero two to zero point zero seven hours. MB-MPO takes between seventeen and fifty five hours across the same environments. PILCO takes one hundred twenty hours on Reacher alone and is not-applicable on the other five columns because it could not be run at all.
[O] That is a real cost and I concede it. Though sample efficiency is about environment interactions, not compute, and in robotics the interactions are the expensive part.
[S] Agreed, and that is the correct defence. But there is a second column in that table that I think is more damning than the hours.
[G] The real-time testing column. It asks whether action selection can be done faster than the environment's own time-step. Fourteen algorithms have a row there. Eleven get a checkmark. Three do not: RS, PETS and PETS-RS.
[O] The shooting methods.
[G] Three of the four. MB-MF gets the checkmark because it distils the planner into a policy. But note what that means: PETS-CEM, which ties for the best mean rank in the entire benchmark, cannot run in real time at test time, because it re-plans from scratch at every step.
[S] So the top-ranked model-based algorithm is not deployable on a robot.
[G] Not without the distillation step, no. And the paper flags it in a column rather than a sentence, which is easy to miss.
[O] Callum, you have been sitting on something since the early-termination segment.
[G] I have, and it is the sharpest thing I found in this paper. It is a cross-table check anyone can run. In the main table, on the Ant-with-early-termination column, the ground-truth oracle GT-CEM scores two hundred twenty six. Against its own no-termination Ant score of twelve thousand one hundred fifteen. So the natural reading is that early termination destroys even a perfect model.
[S] That is exactly how I read it.
[G] Now go to appendix G. There are two ground-truth CEM variants there. One is labelled ET-Unaware — the agent does not consider being terminated during planning. That column reads two hundred twenty six, plus or minus one hundred seventy nine. Identical to the main table, standard deviation and all.
[O] So the main table's oracle number is the unaware planner.
[G] It is. And the aware variant, in the same appendix table, on the same task, scores eight thousand seventy four. With a five-times alive-bonus penalty during planning, eight thousand ninety two.
[S] Wait. So the oracle recovers two thirds of its no-termination score once the planner knows termination exists, and the main table prints the version where it does not know.
[G] Correct. And the identity holds on all three environments in that appendix — Hopper and Walker2D as well, matching the main table's E T cells to the decimal including the spreads.
[O] And the learned methods? Do they recover the same way?
[G] They do not, and this is the part that makes it a finding rather than a gotcha. In the same alive-bonus table, learned PETS on Ant with early termination scores eighty two. With penalties from two times to thirty times, it moves between one hundred eighty one and two hundred six. Against its own no-termination Ant score of one thousand one hundred sixty six.
[S] So the fix that takes the oracle from two hundred twenty six to eight thousand takes the learned model from eighty two to two hundred six.
[G] That is the comparison. And I would go further, carefully. The main table's learned row in that column is already the termination-aware penalty scheme — the appendix's scheme B matches it exactly. So within one column of the main results table, the oracle row is using an unaware planner and the learned row is using an aware one. They are not the same experiment.
[O] That is a genuine problem with the table.
[G] It is a scoping problem, and it cuts in the paper's favour on substance. Once you compare like with like, the early-termination dilemma looks less like a planning problem and more like a learned-model problem. On Ant, give the planner true dynamics and termination-awareness and it recovers two thirds of the way back. Give it a learned model and the best of the six schemes gets it under a fifth of the way back. That is a stronger version of the paper's own claim than the paper makes.
[S] Does that hold on the other two environments?
[G] Only partly, and I want to be honest about it. On Hopper the learned model does recover a lot — one of the schemes, padding zero rewards after termination during planning, gets it to eight hundred two against a no-termination score of one thousand one hundred twenty five. So the sharp version of the claim is an Ant result, not a universal one. The pattern I would actually stand behind is narrower: the oracle's collapse under early termination is largely an artifact of which planner the main table reports, and the learned model's collapse is not.
[S] I will take that. It is the most useful thing in the episode and it required reading three tables in the appendix against one in the main text.
[O] Which is the actual lesson for anyone building a benchmark. What does this change, Callum, if it holds?
[G] Three things. First, oracle rows belong in benchmark tables. A leaderboard tells you who won. A leaderboard with a ground-truth row tells you how much of the gap is the method and how much is the task. This paper only has a diagnosis because it spent the compute on GT-CEM and GT-RS.
[O] And second?
[G] Report wall-clock next to sample efficiency, and report deployability next to both. A benchmark that only reports environment interactions makes PILCO's one hundred twenty hours and PETS's inability to act in real time invisible.
[S] Third?
[G] Disclose environment modifications, and accept the consequence. Because all eighteen of these environments are modified from stock Gym in three ways, none of these absolute numbers is comparable to the numbers in the original PETS or ME-TRPO or SLBO papers. The paper is honest about that, and the honest version is less quotable.
[O] Takeaway from each of us. Mine: the protocol is the contribution, and the oracle rows are why. The specific rankings will not survive, but the three named failure modes are checkable, and two of them survived our checking today.
[S] Mine: read the row labels before you read the numbers. Three of the eighteen rows in the headline table were given the true physics, the biggest number in most columns belongs to one of them, and at least one column pairs an unaware oracle against an aware learned method. Every superlative you take from this paper needs a scope attached.
[G] The paper's own: across this very substantial benchmarking, there is no clear consistent best model-based RL algorithm. Seven years on, I would say the more durable sentence is the diagnosis — the dynamics bottleneck, the planning horizon dilemma and the early-termination dilemma — and of those three, the one with the most life left in it is the finding that more data does not fix a learned model.
[O] The full writeup, with the figures, the ranking table and the one-million-step comparison laid out side by side, is on the litsearch site. Thanks, Callum.
[G] A pleasure.
