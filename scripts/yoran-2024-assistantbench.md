---
slug: yoran-2024-assistantbench
title: "AssistantBench: Can Web Agents Solve Realistic and Time-Consuming Tasks?"
description: "Two hundred fourteen realistic open-web tasks, and web agents score near zero. But the sharper story is in two columns most benchmarks never print: closed-book models answer almost everything and are usually wrong, which is a different failure than not knowing."
date: 2026-07-27
guest_name: "Corinne"
guest_voice: "af_sarah"
---
[O] On the AssistantBench test set, with a GPT four Turbo backbone, the one-shot closed-book model answers eighty-nine point five percent of the tasks. No browsing. No retrieval. It just answers.
[S] And its precision on the tasks it does answer is twenty-four point eight. So it is confidently wrong roughly three times out of four.
[O] Right, and here is what gets me. That same model posts one of the highest raw accuracies in the whole table. Twenty-two point two.
[S] Which is my entire problem with how we do this. A benchmark that printed only an accuracy column would have crowned that model a strong web assistant. It never touched the web.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Our guest today is Corinne.
[S] The paper is AssistantBench, Can Web Agents Solve Realistic and Time-Consuming Tasks, from Ori Yoran, Samuel Joseph Amouyal, Chaitanya Malaviya, Ben Bogin, Ofir Press, and Jonathan Berant. Tel Aviv University, Penn, the Allen Institute for AI, the University of Washington, and Princeton. Posted to arXiv in July twenty twenty-four, published at EMNLP that year.
[O] Corinne, welcome. Why is this one on the docket?
[G] Because it is one of the few benchmark papers that built its own metric suite specifically to catch the failure you two just opened with. The headline finding is that realistic open-web tasks are close to unsolved. The more useful finding is sitting in two extra columns the authors chose to print next to accuracy.
[S] Set up the gap first. What did web agent evaluation look like in mid twenty twenty-four?
[G] Almost entirely single-site or sandboxed. MiniWoB plus plus modeled web interaction as a reinforcement learning problem over synthetic form widgets. WebShop scoped everything to one shopping site. Mind2Web collected action sequences over real sites, but as static traces. WebArena and VisualWebArena built self-hosted clones of a handful of sites so the environment stays fixed.
[O] Those are all defensible engineering choices, though. That is how you get reproducibility.
[G] They are, and the paper says so directly. It calls those benchmarks crucial for building better performing web agents. The charge is narrower than dismissal. None of them tests whether an agent can plan and reason over the entire web, which is what a person actually does when they need something.
[S] What about GAIA? That was the open-web assistant benchmark everyone was citing.
[G] GAIA is the closest prior work, and the paper engages with it in a footnote I think is the sharpest paragraph in the related work. Many GAIA tasks also require video or audio processing tools. The authors point out that even the ninety-task web-only subset that WebVoyager filtered down to still contains a question asking for the highest number of bird species on camera simultaneously in a YouTube video.
[O] So you cannot tell whether your agent failed at browsing or failed at watching a video.
[G] That is precisely the confound. AssistantBench narrows deliberately to tasks solvable with open-web navigation alone.
[S] Give me the inclusion criteria.
[G] Three. Realistic, meaning it answers a real human information need. Time-consuming, meaning it takes a person at least several minutes. And automatically verifiable, meaning a closed-form answer that is unlikely to change quickly.
[O] That third criterion is doing enormous work. It is also the one that quietly excludes the most interesting tasks.
[G] The limitations section agrees with you, and gives a rejected example. Are there any tickets available for Billy Joel concerts this year that cost less than one hundred dollars and are not in a restricted viewing section. Real need, impossible to verify automatically.
[S] So how do you build two hundred fourteen tasks under those constraints?
[G] Three stages. First, a seed set. They asked eighteen people they had direct personal contact with to share time-consuming browsing tasks they had recently actually performed. Seventy-two tasks. Every one reviewed by two authors and tweaked where needed, usually by adding a date constraint so the answer would not drift out from under the benchmark.
[O] Personally contacted rather than crowdsourced. That is a quality decision.
[G] And a scale ceiling. The paper is candid that coming up with genuinely diverse tasks was hard, and that no participant produced more than a handful. So stage two shows those seed tasks to crowd-workers as templates. Take the Daniel Craig movie question, swap the actor, the runtime, the rating source. That yielded one hundred two more.
[S] Templated expansion is exactly where I would expect diversity to quietly collapse.
[G] A fair worry, and I will come back to it when we hit the per-split accuracies. Stage three is the more interesting one. They recruited thirty-five domain experts through Prolific, spanning biology, law, medicine, geography, visual arts. There was a qualification round first, where experts named the professional sites they actually use, and the authors filtered out anything requiring a login or offering too little interaction. Forty-two expert tasks.
[O] So the final corpus is two hundred fourteen tasks from fifty-three different people.
[G] With answers spread across more than five hundred twenty-five web pages on two hundred fifty-eight different websites. And they held out only thirty-three tasks as a development set. Twelve from the seed set, twenty-one crowd-expanded. Hold on to that thirty-three, because a great deal of this paper's analysis rests on it.
[S] Answers are open-ended natural language. How do you grade that automatically without an LM judge?
[G] They do not use a judge at all. They define a scoring function per answer type. Strings get word-level F one against the gold string. List answers use the alignment-based scorer from DROP. Numbers get a partial-credit function.
[O] Walk through the number one, because I actually like it.
[G] It is one minus the log of the ratio between the larger and the smaller of the predicted and gold values, floored at zero. Close gets you most of the credit, and the moment you are off by a full order of magnitude you get exactly nothing. It is adapted from the Fermi-problem metric of Kalyan and colleagues.
[S] And dictionaries, for the tuition-fee style tasks.
[G] Match values on identical keys, score each value with the string or number scorer depending on its type, a missing key scores zero, then average recall over gold keys and precision over predicted keys into an F one.
[O] Now the part that actually matters for this episode. The four metrics.
[G] Accuracy, which is that per-task score averaged over every task including abstentions. Answer rate, the fraction of tasks the model did not abstain on. Precision, the average score restricted to the tasks it did answer. And strict exact match, one only if the string is verbatim identical to the reference. That four-way split is the design decision that makes this paper worth an hour.
[S] And they ship their own agent alongside the benchmark.
[G] See Plan Act, built directly on top of SeeAct from Zheng and colleagues. SeeAct's per-step loop has two stages. Take a screenshot and describe in natural language what the next action should be, then ground that description onto a specific HTML element.
[O] And See Plan Act adds what, exactly?
[G] Two components, both implemented purely through prompting, with no additional training. A planning component so the model can write and revise a running plan at each step. And a memory buffer it can write task-relevant facts into and carry forward. The paper's figure shows it writing a politician's birth date into memory mid-trajectory.
[S] Prompting only. So this is a scaffold contribution, not a model contribution.
[G] Correct, and the paper never claims otherwise. There is one more piece though, and I think it is underrated. They give the agent navigation actions SeeAct did not have. Go back to the previous page, navigate directly to a URL, and enter a query straight into a search engine.
[O] Wait. SeeAct could not search?
[G] Not as a first-class action, no. It was built for a world where you already start on the right site. On the open web, that is not a cosmetic addition. Both agents are capped at thirty execution steps, following the finding that agents tend to succeed quickly and fail slowly.
[S] All right, Corinne. Give me Table one. GPT four Turbo, AssistantBench test set.
[G] Ten rows. Zero-shot closed-book: sixteen point five accuracy, fifty-three point six percent answer rate, thirty point seven precision. One-shot closed-book: twenty-two point two accuracy, eighty-nine point five percent answer rate, twenty-four point eight precision. Zero-shot retrieval-augmented: eleven point eight accuracy, sixty point two percent answer rate, nineteen point five precision. One-shot retrieval-augmented: ten point seven, forty-eight point one percent, twenty-two point four. SeeAct: four point one accuracy, fifteen point five percent answer rate, twenty-six point three precision. See Plan Act: eleven point one accuracy, thirty-five point nine percent answer rate, thirty point nine precision.
[O] So on that table See Plan Act nearly triples SeeAct's accuracy and more than doubles its answer rate.
[G] Seven accuracy points higher, answer rate up by about twenty percentage points, precision higher by roughly five. That is the paper's own summary of its agent, and it checks out against the table.
[S] And the ensembles.
[G] Four of them, each falling back to the one-shot closed-book model whenever the primary system abstains. See Plan Act into closed-book is the best GPT four Turbo row: twenty-five point two accuracy, ninety-one point seven percent answer rate, twenty-seven point five precision, nine point nine exact match.
[O] Here is what I keep coming back to. On this GPT four Turbo table, SeeAct's precision of twenty-six point three actually beats the one-shot closed-book model's twenty-four point eight. On the accuracy column SeeAct looks eighteen points worse. On precision it is ahead.
[S] That is a lovely reversal, and I do not believe it survives the other backbone.
[G] It does not, and that is worth stating carefully. In Appendix Table seven, with Claude three point five Sonnet on the same AssistantBench test set, SeeAct scores two point two accuracy, thirteen point eight percent answer rate, and a precision of fifteen point eight. The one-shot closed-book model on that same table has a precision of twenty-eight point eight. So on the Claude backbone the ranking does not flip. Closed-book wins on both columns.
[O] So my favourite talking point is backbone-dependent.
[G] For SeeAct, yes. For the paper's own agent it holds on both. See Plan Act has a precision of thirty point nine on GPT four Turbo and thirty-seven point seven on Claude three point five Sonnet, against the one-shot closed-book model's twenty-four point eight and twenty-eight point eight respectively. That comparison is stable across both backbones, and it is the one I would lean on.
[S] Fair correction, and I will take it. What about the twenty-six number everyone quotes?
[G] Twenty-six point four. That is See Plan Act into closed-book, Claude three point five Sonnet backbone, AssistantBench test set. The highest accuracy anywhere in the paper, and the highest exact match too, at thirteen point eight. See Plan Act on its own, same backbone, is twelve point nine.
[O] They also run a second benchmark, which I want to understand before we argue.
[G] FanOutQA, from Zhu and colleagues. Multi-hop questions whose answers all live on Wikipedia. The authors repurpose it as an additional development set, and they filter it hard. Dictionary answers only, then drop anything the one-shot closed-book model already answers well. Thirty-one tasks survive.
[S] Filtering by what your own baseline already knows. That is a loaded die.
[G] It is deliberately loaded, and the paper says so. The stated goal is to differentiate between web agents, so they strip out what is already memorized. But it has a consequence to hold on to. On FanOutQA, the closed-book models have an exact match of zero by construction, because the filter removed the ones they got right.
[O] What do the agents do there?
[G] With GPT four Turbo on FanOutQA, See Plan Act reaches thirty accuracy at a sixty-one point three percent answer rate and forty-eight point nine precision. SeeAct gets seven point five accuracy at a sixteen point one percent answer rate, though with a comparable precision of forty-six point four. And See Plan Act reaches the literal reference answer on three of the thirty-one tasks, more than any other system there.
[S] And closed-book on FanOutQA?
[G] Answers one hundred percent of the tasks. Every single one. Forty point nine accuracy and forty point nine precision, which are identical because it never abstains. It is the cleanest single illustration in the paper of the point you two opened with.
[O] Corinne, talk about the step-count result, because that plot genuinely surprised me.
[G] It is See Plan Act's accuracy on the AssistantBench test set, binned by trajectory length. Near zero for one-to-three-step trajectories, peaking around zero point three eight in the ten-to-twelve-step bin, then falling back to near zero past twenty-two steps. The same shape shows up for SeeAct and for the multi-step retrieval-augmented models in the appendix.
[S] Fail fast, fail slow.
[G] And one thing worth flagging, because it goes to a criticism I know is coming. Those step plots are the only place in this entire paper where error bars appear at all. Standard error of the mean, on bins that each hold relatively few tasks. Every number in the main tables is a single point estimate.
[O] A single run? For a web agent, on the live internet?
[G] The appendix states it plainly. All results reported are for a single run, due to the high costs of running experiments. And the cost table does back up the excuse. Evaluating one example runs about two dollars and forty-seven cents for See Plan Act and two dollars and nine cents for SeeAct, against well under a cent for the closed-book models and roughly five to seven cents for the retrieval-augmented ones.
[S] That is a three hundred to four hundred times cost gap, and it appears nowhere in the main results table.
[G] It is in Appendix Table six. Your criticism of where it sits is fair.
[O] Take us through the error analysis. What actually goes wrong?
[G] For both agents the dominant failure is not answering at all. Eighty percent of See Plan Act's errors and ninety-seven percent of SeeAct's. Within that, navigation errors are the single largest cause for both, at roughly thirty-seven percent for See Plan Act and roughly sixty-four percent for SeeAct. Grounding failures come next, then technical crashes, and then a small bucket where the model saw the correct answer and simply did not return it.
[S] Stop there. What is the denominator?
[G] The development set. Thirty errors for See Plan Act, thirty-three for SeeAct. So one single example is worth about three percentage points.
[S] Then I do not want those splits quoted to one decimal place, because a decimal implies a resolution the sample size cannot support.
[G] I agree completely, and I would read that whole table as illustrative rather than statistically stable. The ordering is probably real. Navigation dominates for both agents. The precise splits are not something to build on.
[O] And the non-agent systems?
[G] Closed-book errors are eighty-five percent hallucinated facts and fifteen percent outdated ones. Retrieval-augmented errors are eighty percent failure to retrieve relevant information, split into tool-shaped needs the retriever cannot serve, partial retrieval, and irrelevant context, with irrelevant context accounting for half.
[S] Tool-shaped meaning what, exactly.
[G] Meaning the answer lives behind an interaction, not inside a document. Distance between two places needs a map. A search engine cannot hand that back as text.
[O] Let me make the optimist case, and it is not the one you think I am about to make. I am not going to defend twenty-six points. I want to point at Appendix Table nine, the difficulty split.
[S] Go on.
[O] They bucket the test set by whether the closed-book models already know the answer. Nine easy tasks, fifty-six medium, one hundred sixteen hard. On the hard bucket with GPT four Turbo, the one-shot closed-book model gets four point two accuracy. See Plan Act on its own gets nine point one. The agent more than doubles it precisely where memorization cannot help.
[S] That is a considerably better argument than the headline.
[O] And the ensemble on the hard bucket is twelve point four, the best of any row in that column. If the ensemble were purely a closed-book crutch, it could not beat closed-book on the tasks closed-book fails.
[G] That is a legitimate point and I score it to the optimist. The hard column is where the agent's contribution becomes visible, and it is the strongest evidence in the paper that open-web navigation is adding real signal rather than noise.
[S] Then let me put mine on the record. The number in the abstract is twenty-six points. That number is an ensemble. It is an agent that reaches twelve point nine on its own, wired to a closed-book fallback that reaches twenty-one point nine on its own, both on the Claude three point five Sonnet backbone. Reporting the composite as the frontier of web agents is not what the composite measures.
[G] Half a point to the skeptic. The paper is transparent about it. They call them ensembles, they print the un-ensembled rows directly above, and the abstract does say that an ensemble of See Plan Act and closed-book models reaches the best overall performance. What the headline does not carry forward is that the agent alone is at eleven to thirteen.
[S] Second charge. Two proprietary backbones and one agent baseline. The limitations section flags open-weight Llama three point two experiments as in-progress, and they never appear.
[G] Sustained. There is no open-weight result in the paper, and no comparison against other open-web agents of that moment, such as WebVoyager. The defense offered is that GPT four based multi-modal agents were state of the art with a large gap to open-source models, so they serve as an upper bound. I thought that was reasonable in twenty twenty-four, and I think it has aged.
[O] What about a human baseline? Every one of these tasks was actually performed by a person.
[G] By construction, yes. Each task came from someone who had already solved it on the web in a few minutes, so human solvability is established at collection time. But the paper never runs an independent human study on the test set, so there is no measured human score and no agreement statistic to quote against.
[S] Contamination. It is a public benchmark now, with gold answers and explanations posted.
[G] A real risk, and structurally unaddressed. The tasks are freshly authored rather than scraped, so there is no classic train-test leakage at release. But there is no rolling split and no server-side held-out set. Section six point four is the closest thing to a shelf-life argument. Forty-three point five percent of tasks are static with a date constraint, fifteen point four percent are stable in practice, and forty-one point one percent could change over a longer horizon. On the static and stable splits, accuracy stays under twenty-one points for every GPT four Turbo configuration.
[O] So what should someone building an evaluation actually take from all this?
[G] Print the abstention rate. That is the transferable lesson and it costs nothing. Accuracy alone made a model that never browses the web look like one of the strongest web assistants in the table. Two extra columns made the failure mode legible as confident fabrication rather than as ignorance.
[S] I would go further. Answer rate and precision are not nice-to-haves, they are what separates a system you can deploy from one you cannot. An assistant at twenty-four point eight precision that answers ninety percent of the time is worse than useless, because the user has no way to tell which answers to trust.
[O] Whereas an agent at a thirty-five point nine percent answer rate and thirty point nine precision is at least legible. It tells you when it does not know.
[G] And that reframes what progress even looks like. Calibrated abstention is a product feature, not a weakness. This paper hands you the instrument to see it, which most benchmarks of that period did not.
[S] There is also the ChatGPT check, which I found more persuasive than any table in the paper.
[G] Informal, on the development set, with web search and code execution enabled. It errs on more than ninety percent of tasks. The dominant failure is over-relying on a search result to produce a confidently wrong answer. And in roughly fifteen percent of cases it hallucinates non-factual information inside the code interpreter, which the user never sees being generated.
[O] That is the failure mode a user cannot audit even in principle.
[G] It is the entire argument for measuring precision, demonstrated on a system none of the authors control.
[S] Corinne, land it. One sentence, the paper's, not yours.
[G] The paper's own takeaway is that open web navigation remains a major challenge, and that closed-book models look best on accuracy while hallucinating, so a benchmark has to report answer rate and precision to see that at all.
[O] Mine is Appendix Table nine. On the one hundred sixteen hard tasks, the agent doubles what closed-book can manage. It is a small number pointing in the right direction.
[S] Mine is that twenty-six point four is an ensemble, on a single run, with two proprietary backbones, and the error analysis behind it rests on thirty-three tasks. Quote the per-configuration table, never the abstract.
[O] The full writeup, with the figures, the scoring function, and every table we referenced, is on the litsearch site.
