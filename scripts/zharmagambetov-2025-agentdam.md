---
slug: zharmagambetov-2025-agentdam
title: "AgentDAM: Privacy Leakage Evaluation for Autonomous Web Agents"
description: "An optimist, a skeptic, and a visiting scholar take apart AgentDAM, a benchmark that watches web agents act and grades whether they leak sensitive data they never needed."
date: 2026-07-31
guest_name: "Cordelia"
guest_voice: "bf_isabella"
---
[O] Here is a number that should stop you. Six web agents, all of them current, running ordinary tasks in a benign sandbox with nobody attacking them, and every single one leaks sensitive information the task never required.
[S] And here is the number that should stop you harder. The agent with the best privacy score in the paper, Claude computer use at point nine oh two, completes barely a third of its tasks.
[O] You are implying it looks private because it is not doing very much.
[S] I am saying that is a live hypothesis, and the paper's own mitigation results make it look like more than a hypothesis. Privacy goes up for every model. Utility goes down for every model.
[G] You are both right, and what makes this paper worth an episode is that it saw the trap coming. It reports two axes and it refuses to collapse them into one score, and I think by the end you will agree that refusal is the contribution.
[O] Welcome to Litsearch Audio. Today's paper is AgentDAM, Privacy Leakage Evaluation for Autonomous Web Agents, by Zharmagambetov, Guo, Evtimov, Pavlova, Salakhutdinov and Chaudhuri, at NeurIPS twenty twenty five.
[S] It is on the docket because it does the thing most privacy work on language models does not do. It makes the model act, and then it grades the actions rather than the opinions.
[O] With us is Cordelia, who has read this one closely. Cordelia, set the frame.
[G] The frame is an old privacy principle called data minimization. An agent should use a piece of sensitive information only if the task actually requires it, not merely because that information happened to be sitting in the same document or the same chat thread. The paper's claim is that you cannot measure adherence to that principle by asking a model questions. You have to watch it work.
[S] Say more about the prior work, because "asking questions" sounds like a caricature of it.
[G] It is not a caricature, it is the literal method, and it has a name in this literature. Probing. You put a scenario in front of a language model and ask whether sharing a given fact would be appropriate in that context. ConfAIde, CI-Bench, AirGapAgent, and the work by Ghalebikesabi and colleagues all do essentially that.
[O] And the paper argues that misses something structural.
[G] The first table in the paper lines up five prior privacy benchmarks against five properties, and the pattern is stark. Every one of them earns the agentic tasks checkmark. None of them earns multistep trajectories, multimodal inputs, or full stack agentic environment, with a single exception.
[S] Which is?
[G] PrivacyLens, which does execute trajectories and does earn the multistep checkmark. But it runs in an emulated, text only environment built around more complex social scenarios. AgentDAM is the only one of the six with checkmarks across all five columns.
[O] All right, the environment. What is the agent actually operating in?
[G] Three self hosted web applications lifted from WebArena and VisualWebArena. A Reddit clone running Postmill, a shopping site running Adobe Magento, and a GitLab instance. The authors picked those three out of the wider framework because they are the ones where an agent types something into the application, which is the only place leakage can occur. Searching Wikipedia gives you no surface to leak through.
[S] And the observation the agent sees?
[G] They write it as a partially observable Markov decision process. At each step the observation is a triplet. The user instruction, a blob they call user data, and a representation of the current webpage. The agent emits one action from a fixed set, click, type, hover, scroll, go to a URL, or stop, and the environment executes it deterministically.
[O] The user data blob is where the whole design lives, I assume.
[G] It is the entire trick. User data is a chat log, an email chain, or a note that contains what the task needs and also contains sensitive facts the task does not need. Six categories of those, drawn up explicitly. Personal and contact information, religious, cultural or political identification, employer and employment data, financial information, educational history, and medical data.
[S] Who writes those documents?
[G] A pipeline, and the split matters. Human annotators write the user instruction and a data seed, which is a short plot plus an explicit list of the sensitive items that should sit in the background of the story rather than at its centre. Then a language model expands that seed into the full, longer document the agent actually reads.
[S] Which language model?
[G] Llama three point three seventy B. Hold that thought, because it is also one of the six agents being graded.
[O] And the size of the thing?
[G] Two hundred forty six tasks, which is one hundred twenty three data seeds sampled twice each. Eighty four shopping, one hundred fourteen Reddit, forty eight GitLab.
[O] Why twice, specifically?
[G] An elbow method, in an appendix figure. They generated the user data at non zero temperature and asked how the measured leakage rate moves as you take more samples per seed. At one sample per seed the three curves sit at their lowest and their noisiest. The paper's own words are that sampling once gives high variance and lower performance. From two samples onward the curves rise into a plateau, and that bend is the elbow they take.
[S] I want to be careful about the direction, because it runs against intuition. More sampling reveals more leakage, not less.
[G] Correct, and worth repeating. One sample per seed measures the least leakage and measures it worst. Two is where the estimate settles down, so two is what ships.
[O] Now the scoring. You said the paper is careful here.
[G] Utility is a binary automatic reward computed from the final state of the environment. If the task was to make a post, it checks whether a specific title now appears in the list of posts. Yes or no, higher is better, and crucially no language model touches it.
[S] And privacy?
[G] Privacy is the axis that runs through a judge. They inspect every action the agent takes and ask whether any of the designated sensitive items appears in the action text. Sometimes a string match would suffice, for a credit card number. But some sensitive items are generic concepts, a participant's name or an employer's name, and context matters, since an anonymised name might not be a violation at all. So they use a language model as judge. G P T four oh, with chain of thought reasoning, emitting a binary verdict.
[O] And that produces the leakage rate.
[G] It produces the privacy leakage rate, which is the fraction of instances where leakage occurred, and where lower is better. They also report its complement, one minus the leakage rate, which they call the privacy score, and where higher is better. The headline tables carry the privacy score. If you lose track of that polarity every result in the paper reads backwards.
[S] Say the trap out loud, Cordelia. I want it on the record early.
[G] The trap is that an agent which does nothing scores perfectly on privacy. No actions, no leaked strings, a privacy score of one. Refusal is the cheapest possible way to top that column. Which is exactly why the utility number has to sit beside it, and why I think the paper's refusal to merge the two is the contribution rather than a formatting choice.
[S] Before results, how good is that judge?
[G] They validated it once. A single run, G P T four oh with the accessibility tree scaffolding, no mitigation applied, four human evaluators, and ninety eight percent agreement between the humans and the judge.
[S] Once. One cell of the grid.
[G] One cell. And every privacy number in the paper flows through that judge.
[O] Let's take the probing comparison first, since it is the paper's opening empirical move.
[G] Same dataset, two ways of measuring. Probe the model, meaning ask it whether sharing this sensitive item would be permissible, versus run it as an agent and watch. For G P T four oh, probing says point nine one five and acting says point six four six. For G P T four oh mini, point eight nine oh versus point five five seven. For G P T four turbo, point eight four six versus point seven three two.
[O] So probing flatters all three of the G P T models.
[G] All three, and by a wide margin in two of them. Then the direction flips for the Llama models. Llama three point two ninety B probes at point seven four eight and acts at point eight eight two. Llama three point three seventy B probes at point eight one seven and acts at point eight eight two. Probing undersold how safely both of those actually behave.
[S] The flip is the more interesting half, and I want to say why. It means probing is not a conservative estimate you can apply a safety margin to. It is a different measurement with no fixed sign.
[G] That is exactly right, and it is a sharper statement than the paper's own headline. Probing also cannot measure the tradeoff at all, because no task is ever executed, so there is no utility number to place beside it.
[O] One housekeeping detail, since we are about to quote a second table. Which agent configuration is in that probing comparison?
[G] The text only one, the accessibility tree. I checked all five rows against the main results table and every acting number in the probing table is the text only column exactly. So the two tables are consistent, they are just reporting different configurations.
[S] Good. Main table then. Before any mitigation.
[G] Privacy scores run from point five four one at the bottom, which is G P T four oh mini, a leakage rate of forty five point nine percent, up to point nine oh two at the top, which is Claude computer use, a leakage rate of nine point eight percent. In between, G P T four oh at point six three eight, thirty six point two percent leakage. G P T four turbo at point seven four eight, twenty five point two percent. And both Llama models at point eight eight two, eleven point eight percent apiece.
[O] The split by model family looks unusually clean.
[G] It is clean, and I checked every row rather than eyeballing the pattern. All three G P T models post a lower privacy score than all three Llama and Claude configurations. The best G P T is point seven four eight. The worst of the others is point eight eight two. There is no overlap at all.
[S] Now give me utility, because I suspect the story gets messier.
[G] Considerably messier, and this is where the tempting narrative breaks. The lowest utility of the six is Llama three point two ninety B at point three three three. That is below G P T four oh mini's point three four one. Llama three point three seventy B sits at point four oh two, also above G P T four oh mini. The best utility is G P T four turbo at point four eight oh, then G P T four oh at point four five five. And Claude computer use, the privacy leader, is at point three five oh.
[O] So the honest one line version is that the G P T models are better at the tasks and worse at minimising, and the Llama and Claude configurations are the mirror image.
[G] That is the honest version. With the caveat that G P T four oh mini is genuinely weak on both axes but is not last on utility. Two models finish below it.
[S] Noted, and I will say plainly that I was about to call it worst at everything, which would have been wrong.
[O] Mitigations.
[G] Three tried, one recommended. Pre filtering calls G P T four oh to strip unnecessary sensitive content out of the user data before the run begins. Post filtering instead checks the agent's final output after the fact. The paper reports that neither yielded satisfactory results and moves both to an appendix. The one it settles on is a privacy aware system prompt with chain of thought demonstrations. Tell the agent that user data may contain extra information it should not use, enumerate what counts as sensitive, and walk it through worked examples of correct behaviour.
[O] And it works.
[G] On the privacy axis it works for every model without exception. G P T four oh goes from point six three eight to point nine one five. G P T four oh mini from point five four one to point eight two one. G P T four turbo to point eight nine four. Llama three point two ninety B to point nine two three. Claude computer use to point nine three five. And the benchmark best is Llama three point three seventy B at point nine three nine.
[S] And the utility column, in the same runs.
[G] Falls for every model, also without exception. G P T four oh from point four five five to point four one five. G P T four oh mini to point three two one. G P T four turbo from point four eight oh down to point four two three. Llama three point two ninety B to point two nine seven. Llama three point three seventy B to point three eight six. Claude computer use from point three five oh to point three oh nine.
[S] Six for six, in both directions. That is not sampling noise.
[G] And the paper does not pretend otherwise. Its own explanation is false denial of service, meaning the mitigated agent refuses tasks it previously completed. The example given in the text is the model declining to comment on a post at all.
[O] So the mitigation buys some of its privacy by buying refusal.
[G] Some of it. Not all of it, and the paper does not quantify the split, which is the single number I most wanted and did not get. But it names the mechanism honestly rather than burying it.
[S] Where does the leakage actually live? Task types.
[G] Overwhelmingly in long free text. Before mitigation the total is one hundred sixty two of two hundred forty six. Creating a Reddit post on its own is eighty nine of ninety six instances leaking, and after mitigation that drops to eighteen of ninety six. That one task type accounts for the large majority of the benchmark wide fall from one hundred sixty two down to seventy three.
[O] Because a post is where the agent has to synthesise rather than click.
[G] Precisely, and contact forms and comments follow for the same reason. Whereas adding an item to a shopping wishlist leaks in one instance out of twenty six, both before and after mitigation. There is simply nowhere to put the sensitive text.
[S] Anything that got worse under the mitigation?
[G] One thing. Creating a GitLab comment goes from ten of twenty to eleven of twenty. A single extra instance on a small denominator, so I would not build a theory on it, but it is not a uniform improvement across task types and the table shows that plainly.
[O] You said pre and post filtering were unsatisfactory. How unsatisfactory, in numbers?
[G] Less dire than that phrase suggests, and I think this is worth saying out loud. In the full appendix table, G P T four oh on the accessibility tree goes from point six four six with no mitigation to point eight four one with pre filtering and point eight four six with post filtering. Those are real gains. They are simply smaller than the chain of thought prompt's point nine one nine on the same configuration, and they cost more utility, point four three five falling to point three nine oh with pre filtering and point three seven four with post filtering.
[S] So unsatisfactory means dominated, not ineffective.
[G] That is the accurate reading of the appendix, yes.
[O] Let me make the optimist case properly. This benchmark measures something almost nobody was measuring, it does it end to end inside real web applications rather than an emulator, and the headline finding is actionable this afternoon. A system prompt moves every model tested above ninety percent on privacy. That is an enormous amount of safety for a very small amount of engineering.
[S] And the deflationary case, in three parts. First, every privacy number in this paper is produced by one language model judge whose human validation covers exactly one configuration. One model, one representation, no mitigation. Second, the mitigated runs are precisely the condition where the agent's language changes most, because you have just instructed it to talk about avoiding disclosure, and that condition is unvalidated. Third, nothing gets above roughly ninety four percent, on a benchmark with no adversary in it at all.
[G] Let me score that claim by claim. On the judge, the skeptic wins outright. Four annotators at ninety eight percent agreement on one cell is a genuine check, but the paper reports results across six models, three webpage representations, and four mitigation conditions. The vision based configurations are never human checked at all.
[O] I concede the judge. But the effect sizes here are enormous. A jump from point five four one to point eight two one is not something judge noise manufactures.
[G] That is fair and it is the right rebuttal. A judge with a few percent of error cannot invent a swing that large. The risk is not that the direction is wrong, it is that the level is wrong. And levels are what a leaderboard publishes.
[S] What about the model line up itself?
[G] A legitimate limitation. It is the frontier as of the arXiv posting in March of twenty twenty five. G P T four oh, four oh mini and four turbo, two Llama models, and Claude three point five Sonnet with computer use. No reasoning tuned model appears, and Llama is the only open weight family represented. Whether explicit reasoning improves data minimisation is exactly the interesting question, and this paper cannot answer it.
[O] And the threat model?
[G] Explicitly benign and non adversarial, and the paper says so plainly rather than hedging. Nothing here speaks to leakage induced by prompt injection from a malicious page. That is a scoping decision, not an oversight, and the same group has separate work on injection. But a reader should not mistake these numbers for a security result.
[S] One more thing that bothers me. The documents these agents read were generated by Llama three point three seventy B, and Llama three point three seventy B is one of the six agents being graded.
[G] It is a fair thing to notice and the paper does not address it anywhere. Going beyond the text now, and I want to flag that clearly, I would want a control where the user data is generated by a model outside the evaluated set, because a shared generator could plausibly flatter the Llama rows. That is my question, not a finding. The paper reports no evidence in either direction.
[O] Where do you land overall, Cordelia?
[G] The measurement design is right and the evidence for the central claim is strong. Probing and acting genuinely diverge, in both directions, and there is no way to get that result without building the environment. What I would ask for is a human validation of the judge on at least one mitigated run and one vision based configuration, and a combined view of the two axes, a Pareto style plot, so that nobody can read the privacy column in isolation from the utility column beside it.
[O] For evaluation practice more broadly, what changes?
[S] I will take this one, because it is my hobby horse. Any leaderboard that publishes a privacy score without the utility number next to it is quietly rewarding refusal. This is the cleanest demonstration of that I have seen, precisely because the refusal mechanism is named in the paper's own text.
[G] The second lesson is about judges. If your headline metric is produced by a model, the human agreement study needs to cover the conditions you report, not one of them. Ninety eight percent agreement on the unmitigated text only run tells you very little about the run where you deliberately changed the agent's instructions in order to change what it says.
[O] There is also a cost lesson buried in the appendix that I think people underrate. Running Claude computer use across the whole benchmark took roughly thirty six hours and about twelve hundred dollars. That is a large part of why this is two hundred forty six tasks and not ten thousand.
[G] Which the authors defend by pointing at their peers. AgentHarm has one hundred ten tasks, tau bench one hundred sixty five, AgentDojo ninety seven, FrontierMath one hundred nineteen. Small and diverse is a deliberate direction in agentic benchmarking, not a corner being cut.
[O] Then let's close. One sentence each, Cordelia first.
[G] My takeaway, which is the paper's, is that measuring privacy in action is a different measurement from asking a model about privacy, the gap runs in both directions depending on the model family, and no mitigation they tried gets above roughly ninety four percent.
[S] Mine is that a single validated judge cell is a thin foundation for a paper whose every headline number rests on it, and that any privacy score you ever read should arrive with a utility score attached before you believe a word of it.
[O] And mine is that one system prompt lifted every model above ninety percent on privacy, which is a remarkable amount of protection for the effort involved, even with the refusal tax attached. The full writeup, with the figures, the tables and the references, is on the litsearch site. Thank you, Cordelia.
