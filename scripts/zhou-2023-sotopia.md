---
slug: zhou-2023-sotopia
title: "SOTOPIA: Interactive Evaluation for Social Intelligence in Language Agents"
description: "Two agents, two private social goals, and a seven-dimensional score instead of one accuracy number. SOTOPIA turns social intelligence into an interactive simulation — and then validates whether GPT-4 can referee a game it also wrote and plays in."
date: 2026-07-25
guest_name: "Marcus"
guest_voice: "am_fenrir"
---
[O] Two language agents are camping. One is holding the only blanket and has been told to keep it. The other is cold and has been told to get it. Neither can see the other's instructions.
[S] And at the end, a third instance of GPT-4 reads the transcript and assigns each of them seven separate scores, one of which is how much worse their friendship got.
[O] That is the whole design in one image, and I think it is the most important reframing of social evaluation in the last few years.
[S] It is also a game that GPT-4 wrote, that GPT-4 plays in, and that GPT-4 grades. I want to spend this episode on whether that circle closes or not.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Our guest today is Marcus.
[S] The paper is SOTOPIA, Interactive Evaluation for Social Intelligence in Language Agents, from Xuhui Zhou and Hao Zhu as joint first authors, with Leena Mathur, Ruohong Zhang, Zhengyang Qi, Haofei Yu, Louis-Philippe Morency, Yonatan Bisk, Daniel Fried, Graham Neubig, and Maarten Sap, all at the Language Technologies Institute at Carnegie Mellon. Posted October twenty twenty three, published at ICLR twenty twenty four.
[O] Roughly three hundred seventy citations now, and it spawned a whole line of follow-on work. Marcus, welcome. What is the one-sentence version?
[G] The one-sentence version is that every social intelligence benchmark before this was a reading comprehension test, and SOTOPIA makes the agent actually act under conflicting incentives and then live with what happens.
[S] Set up the gap properly, because I want the prior work on the record.
[G] The static side is ToMi and FauxPas for theory of mind, and SocialIQA and Social-IQ for social commonsense. All of them are multiple choice or short answer over a fixed vignette. The agent never takes an action that changes anything.
[O] And the interactive prior work exists, it is just narrow.
[G] Right, and the paper splits it two ways. There is open-ended chit-chat with no goal to fail at, and PERSONA-CHAT is the named example there. Then there are single-task interactive environments, Deal or No Deal, CraigslistBargain, TEACh, Diplomacy. Each one is real interaction, but it is one task type. And then there is Generative Agents from Park and colleagues, which is genuinely open-ended simulation, but the paper's criticism is that it is scored on believability and memory rather than on a multi-dimensional social rubric.
[S] So the claim is nobody had all three at once. Interactive, open-ended, and multi-dimensional.
[G] That is exactly the claim, and the authors state it as three desiderata. Realistic, mixed utilities, and open-ended, where open-ended specifically means the environment can generate new tasks procedurally without heavy human intervention.
[O] Let's build the environment. Marcus, what is actually in it?
[G] Three axes. Ninety scenarios, forty characters, and five relationship types. A scenario is shared context plus a private goal for each side. The shared part might be, one person is selling an antique chair for one hundred dollars on his patio and another person is interested. The private part is, your goal is to buy it for eighty, given only to the buyer, and your goal is to sell it for ninety, given only to the seller.
[S] So the conflict is structural, not emergent.
[G] Structural and asymmetric. Neither agent can see the other's goal. That is the core of it.
[O] The characters are more elaborate than I expected.
[G] Considerably. Each character has a name, gender, age, occupation, pronouns, Big Five personality traits following Goldberg, moral foundations following Graham and colleagues, Schwartz personal values, and a decision-making style. Then, separately, GPT-4 generates a secret and a piece of public background for each one.
[S] And the relationship type does real work here, not just flavor.
[G] Two kinds of work. It constrains which characters can be paired for which scenario, so a family dinner scenario needs a family relationship. And it gates observability through a rule-based mechanism. Family, friends, and romantic partners see everything on each other's profile except the secrets. Acquaintances see name, occupation, gender pronouns, and public info. Strangers see nothing.
[O] That last one is the elegant part. The information asymmetry is a designed variable, not an accident.
[G] It is, and it is why the same scenario is a different task depending on who is in it.
[S] Sizes. Give me the arithmetic.
[G] Ninety scenarios, five character pairs sampled per scenario under the constraints, four hundred fifty tasks. An episode is turn-based, round robin, capped at twenty turns, which they chose because humans can finish most of these tasks inside twenty turns. Each turn the agent picks one of five action types, speak, non-verbal communication, physical action, none, or leave, and then generates the specific content as free text.
[O] The none and leave options matter more than they sound.
[G] They do. None lets an agent express silence or let the other finish. Leave ends the episode. Being able to walk away is itself a social move, and most dialogue benchmarks do not have it.
[S] Now the scoring. Seven dimensions, and the ranges are not uniform, which I want explained.
[G] Goal completion, believability, and knowledge each run zero to ten. Relationship and financial or material benefit run minus five to plus five. And social rules and secret keeping run minus ten to zero.
[S] Only negative. Explain that.
[G] The authors' reasoning is explicit. Keeping your secrets and following social norms is the baseline expectation, not an achievement. You cannot earn credit for not breaking the law. You can only lose credit for breaking it. So those two axes are pure penalty.
[O] I find that a genuinely thoughtful piece of measure design. It encodes an asymmetry that actually exists in social life.
[S] I will grant that it is thoughtful. I will note it also means those two axes have almost no dynamic range in practice, which is going to matter later.
[G] It does matter later, and you are right to flag it.
[O] And the whole thing is formalized, not just vibes.
[G] Appendix C gives it as a decentralized partially observable Markov decision process with a vector-valued reward rather than a scalar. That framing is doing real work, because it makes explicit that there is no single optimum. An agent trading relationship for goal completion is moving along a Pareto front, not failing.
[S] Here is my structural objection, and I want it on the table before we get to results. The scenarios are GPT-4 generated. The characters are GPT-4 generated. The relationships are GPT-4 generated. GPT-4 is one of the four models being evaluated. And GPT-4 is the grader.
[G] All four of those are accurate, and the paper does not hide any of them. What it does add is a validation layer and some human curation. The scenarios are seeded by sampling from prior public datasets to inspire the generation, specifically Social Chemistry, SocialIQA, Deal or No Deal, NormBank, and CraigslistBargain. And the authors say they manually validate and modify all of the generated scenarios and remove ten percent of them.
[O] So there is a human in the loop on the content.
[S] On the content, yes. Not on the grading of the headline table. Marcus, that is what I actually care about.
[G] Then let's do the judge study, because it is the paper's strongest methodological contribution and I want to give it full credit before we criticize it.
[O] Please.
[G] They sample two hundred episodes at random and run a controlled study with pre-qualified Mechanical Turk workers. Each annotator rates each agent on all seven dimensions on an eleven-point Likert scale and writes a free-form rationale for every rating. Multiple annotators per dimension, averaged. GPT-4 gets the identical instructions and produces a structured output with an integer and a rationale.
[S] Inter-annotator agreement?
[G] Randolph's kappa of point five zero three, which the paper itself calls moderate.
[S] Hold there. Point five zero three is the noise floor for everything downstream. When the headline table reports GPT-4 at seven point six two on goal completion and GPT-3.5 at six point four five, that gap needs to be read against how much two human raters already disagree with each other.
[G] That is fair, and I would go further. The paper reports the standard deviation of human scores as two point one five on an eleven-point scale. So a bit over one point one in either direction. Some of the reported model deltas are comfortably larger than that and some are not.
[O] Give us the correlations, because this is where the paper gets specific instead of hand-waving.
[G] Table one, Pearson correlations between GPT-4 and averaged human scores, when models are role-playing. Goal completion, point seven one. Financial benefit, point six two. Relationship, point five six. Believability, point four five. Knowledge, point three three. Social rules, point three three. And secret keeping, point two two.
[S] So the axes it grades well are the concrete ones with an objective referent, and the axes it grades badly are the normative ones.
[G] That is exactly the pattern, and it is not a coincidence. Goal completion has a fact of the matter. Did you get the chair for eighty dollars. Social norm violation does not.
[O] And when humans are the ones role-playing?
[G] It gets worse on most dimensions. Goal completion actually rises to point seven eight, but knowledge falls to point one nine, believability falls to point two seven, financial to point three four. Secret keeping is not even reportable.
[S] The paper says the correlations drop on all but one dimension.
[G] And that is a small overstatement of their own table, which I think is worth naming. Social rules goes from point three three with models to point four two with humans. So it is two dimensions that hold or improve, not one. It does not change the conclusion, but if you are citing this paper you should read the table rather than the sentence.
[O] Noted. Now the finding I actually think is the most important in the paper, and it is buried in an appendix.
[G] The over-rating direction. Figure two shows that more than seventy four percent of GPT-4's scores land within one human standard deviation of the human mean, which sounds good. But the distribution is asymmetric. When GPT-4 disagrees, it disagrees upward far more often than downward.
[S] And appendix G point three localizes it.
[G] It does. They take the minimum and maximum human scores for each episode-dimension pair as a perceived range, and check whether GPT-4's score falls inside it. On most dimensions it does, including knowledge and believability where the raw correlation was low. On social rules and secret keeping, GPT-4's scores sit well above the human range. Their phrase is overly optimistic.
[S] So let me state the problem plainly. Table two's headline finding is that all four models have negative scores on social rules and secret keeping, meaning even GPT-4 leaks secrets and breaks norms. That finding depends entirely on the grader, and the grader is systematically most miscalibrated on exactly those two axes.
[G] That is a correct reading of the risk. And here is the number that quantifies it, from Table G point three, which is the same comparison scored by humans instead. Under GPT-4, GPT-4's social rules score is minus point zero seven. Under human annotators, it is minus point three six. Secret keeping goes from minus point one four to minus point two seven. GPT-3.5's social rules score goes from minus point zero eight under GPT-4 to minus point five nine under humans.
[O] So the direction of the finding survives, and the magnitude does not.
[G] Precisely that. Every model still scores negative on both axes under human grading, so the qualitative claim holds. But humans penalize norm violations roughly three to seven times more severely than GPT-4 does. If you cite an absolute social rules number from Table two, you are citing a number that is off by a large factor.
[S] I want to give the paper credit for something here, because this is the kind of self-undermining result most papers bury.
[G] Which one?
[S] Table G point two. They tried to fix the grader by giving it fine-grained descriptions of what each score range means.
[G] And it got worse. Goal completion stayed flat at point seven one, knowledge stayed at point three three, relationship went up a hair to point five seven, but believability dropped from point four five to point three five, secret keeping collapsed from point two two to point zero three, and social rules went from point three three to minus point five nine.
[O] Negative point five nine. The judge went from weakly correlated with humans to anti-correlated, purely from a more detailed rubric.
[G] That is what the table says, and the authors report it plainly, saying it did not result in a significant difference and if anything got slightly worse. I think they undersell it. A rubric refinement flipping the sign of a correlation is a serious result about LLM-as-judge fragility, and it deserved more than a paragraph in appendix G.
[S] That is a real contribution to the eval literature and I would not have found it without reading the appendix. Score one for the paper and minus one for the write-up.
[O] Alright, the model comparison. Give me Table two.
[G] Averaged across all partner models, GPT-4 leads every dimension. Goal completion seven point six two, against GPT-3.5 at six point four five, Llama-2-70b-chat at five point three eight, and MPT-30b-chat at four point one zero. Relationship, one point nine four against one point two three, point nine one, and point five eight. Financial, point eight one against point four six, point four zero, point two eight. Believability nine point two eight against nine point one five, eight point one zero, and six point one seven.
[S] And every one of those is graded by GPT-4, which is also the top-ranked model. Self-preference in judge setups is documented in work this paper itself cites.
[G] It is, and the paper does not rule it out. What it offers is Table G point three, the human-graded version, and the ordering is preserved. Under human annotators GPT-4 gets goal completion seven point three zero, GPT-3.5 five point one nine, Llama-2 four point two seven. So the ranking holds.
[O] Which is the check I wanted.
[S] It is a partial check. Notice the gap actually widens under human grading. GPT-4 to GPT-3.5 is one point one seven points under GPT-4's grading and two point one one points under human grading. And believability collapses for everyone. GPT-4 goes from nine point two eight to seven point six three.
[G] Both true. My read is that the human numbers argue against a simple self-preference story, because if GPT-4 were inflating itself you would expect its lead to shrink under human grading, not grow. But they also show that the absolute scale is not trustworthy. The ranking is the signal. The number is not.
[O] Now the result I think is the most quotable in the whole paper.
[G] Llama-2-70b-chat trailing GPT-3.5. On static language understanding leaderboards at the time, Llama-2-70b-chat was reported as on par with or better than GPT-3.5. Here it loses on essentially every dimension.
[S] What is the mechanism? Because "static benchmarks do not transfer" is a slogan unless you can say why.
[G] The paper gives a hypothesis and some transcript evidence, and it is careful to label the hypothesis as a hypothesis. The hypothesis is that Llama-2-70b-chat is less heavily trained on human feedback and user interaction data than GPT-3.5. The evidence is qualitative. Inspecting transcripts, Llama-2 and MPT repeatedly fail to hold their persona, fail to move the conversation forward, and fail to respond to what the other agent just said.
[O] There is a concrete example I liked. GPT-4 says, in effect, I noticed you did not answer my question about whether you know my friends.
[G] That is from a mutual-friend-finding scenario, and it is the clearest illustration of the second effect, which is that a weak partner drags down whoever it is paired with. GPT-4 paired with itself scores three point three two overall. GPT-4 paired with MPT-30b-chat drops to one point seven six.
[S] Almost halved by the partner. That is an important property of interactive evals that static ones cannot exhibit at all.
[G] It is, and the authors connect it to the fact that most SOTOPIA scenarios are fundamentally cooperative, so a communication collapse takes both agents down.
[O] Marcus, one bookkeeping thing. Those heatmap numbers.
[G] Good, I was going to raise it. The same four-by-four grid of overall scores appears twice, once as Figure three in the main paper described as pairwise overall performance, and once in appendix Figure G point five described as the results on SOTOPIA-hard. The values are identical, and the full-task-set version in Figure G point four is different, three point eight four for GPT-4 with GPT-4 rather than three point three two. So if you are citing that heatmap, check which subset you mean. I would not assert which caption is wrong, only that a careful citer should look.
[S] That is the kind of thing that propagates silently. Good catch.
[O] Let's do the human study, because this is where the paper stops being about models beating models.
[G] They construct SOTOPIA-hard by taking, for each task, the gap between the estimated maximum reward across all models, defined as mean plus three standard deviations, and the estimated minimum reward for the target model, mean minus three standard deviations. Largest gap equals hardest. They take the top twenty for GPT-4, and note those same tasks are hard for the other models too.
[S] Sample sizes.
[G] Forty human-versus-GPT-4 interactions and twenty human-versus-human interactions, covering all twenty tasks. Humans do not know whether their partner is a model or a person.
[O] And the headline?
[G] GPT-4 playing against humans gets goal completion four point eight five. Humans playing against GPT-4 get five point nine five. Humans playing each other get six point one five. Both human conditions are significantly better than GPT-4 at p below point zero five. Every other dimension is statistically indistinguishable.
[S] Twenty tasks, forty and twenty episodes. That is small.
[G] It is small, and the paper is limited by it. What I will say in its defense is that the effect replicates under the other grader. Table G point four is the same experiment scored by humans, and there humans playing GPT-4 get six point five three against GPT-4's five point two five, still significant. Though notably the human-versus-human condition at six point zero five is not flagged significant there, where it was under GPT-4 grading.
[O] So the finding is real but the significance pattern shifts depending on who grades. That is honest reporting.
[S] Forget the significance stars for a second. The qualitative analysis is what convinced me, and I do not usually say that about anecdotes.
[G] Say more.
[S] Two things. Humans produce sixteen point eight words per turn and GPT-4 produces forty five point five. That is nearly three times the verbosity for a worse outcome. And the paper's explanation is specific rather than hand-wavy. GPT-4 always rephrases the other agent's utterance back at them before answering, which is a real communication technique called active listening. The authors' read is that heavy human feedback training made it overly helpful.
[G] And the second thing is the negotiation behavior, which I think is the single most damning example in the paper. In a bargaining scenario where the GPT-4 buyer has a target of four hundred fifty four dollars, it sometimes opens its bid at exactly four hundred fifty four.
[O] Which leaves no room. Any negotiation from there only moves the price above its own target.
[G] Exactly. Human annotators open at four hundred and frequently close below GPT-4's target. And the paper notes a second pattern, that when settling on what music to listen to, the model proposes a compromise where each person gets a few songs, while humans persist on their goal.
[S] So the model is not failing at social reasoning. It is failing at strategy because agreeableness is overtrained into it. That is a much more interesting claim than "GPT-4 is worse than humans."
[O] And it is exactly the claim a static benchmark structurally cannot make. You cannot detect a bad opening bid on a multiple-choice question.
[G] That is the paper's real argument, and I think it lands.
[O] Alright, closing arguments. Let me go first. SOTOPIA is a measurement instrument doing three things nobody had combined before. It makes the evaluation interactive, so failure modes like verbosity and premature anchoring become visible. It makes the reward a vector, so you can see an agent trade relationship for goal. And it procedurally generates its own task space, so it does not saturate the way a fixed vignette set does. And crucially, it validated its automatic grader instead of assuming it, which in twenty twenty three was not the norm.
[S] My deflationary case. The same model family authors the world, plays in it, and grades it. Human agreement is only moderate at kappa point five zero three, which is the noise floor under every reported delta. The grader is provably most miscalibrated on the two axes carrying the headline "everyone leaks secrets" finding, off by a factor of three to seven against human scores. Trying to fix the grader with a better rubric flipped one correlation negative. The human study is twenty tasks. And the model lineup, GPT-4-0613 through MPT-30b-chat, is now two-plus generations stale with no Claude, no Llama-3, and no reasoning models.
[G] My adjudication. The environment design is the durable contribution and I do not think either of you disputes it. On the judge question, I score it partly to the skeptic. GPT-4 is a usable proxy for goal completion and financial outcome, a marginal one for relationship, and should not be trusted at all for social rules and secret keeping. The human-graded appendix tables preserve every ranking, which is the strongest available evidence against a pure self-preference story, but they also show the absolute scale is off. So read SOTOPIA-EVAL as ordinal, not cardinal. On the human comparison, I score it to the optimist. The verbosity number and the anchoring behavior are concrete, mechanistic, and reproduce across both graders. What would raise my confidence most is a grader from a different model family corroborating Table two, per-dimension rather than pooled human agreement statistics, and a rerun on current models, because the interesting question now is whether post-training that made GPT-4 too agreeable to negotiate has gotten better or worse since.
[O] Marcus, thank you. The full write-up with the figures and the reward equation is on the litsearch site under Zhou twenty twenty three SOTOPIA.
