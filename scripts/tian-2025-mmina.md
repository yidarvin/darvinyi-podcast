---
slug: tian-2025-mmina
title: "MMInA: Benchmarking Multihop Multimodal Internet Agents"
description: "A 1,050-task benchmark chains web agents across up to ten live websites, and agents score exactly zero from the third hop onward — but the single best score in the paper's own table belongs to a text-only model reading image captions, not to the multimodal models its headline says should win."
date: 2026-07-28
guest_name: "Theo"
guest_voice: "am_fenrir"
---
[O] The number everyone quotes from this paper is twenty-one point eight percent. That's GPT-4V completing full web tasks that chain across multiple live websites, against a human baseline of ninety-six point three percent.
[S] And the number nobody quotes is twenty-three point zero seven percent. That's the highest score anywhere in the same table, and it belongs to a text-only model that never sees an image.
[O] In a paper whose first stated finding is that multimodal models do better.
[S] In a paper with the word multimodal in the title. So either the headline is wrong, or that table needs a far more careful read than it's been getting.
[G] It needs a more careful read. I'd call it the most misreadable table in this whole literature. Two different success metrics sit side by side with nearly identical column headers, and picking from the wrong half will make you say something false.
[O] Welcome to Litsearch Audio. I'm the optimist, and today's paper is more ambitious than its reception suggests.
[S] I'm the skeptic, and I'll grant the ambition up front. I want to spend our time on whether the measurement supports the conclusions.
[O] The paper is MMInA: Benchmarking Multihop Multimodal Internet Agents, by Shulin Tian, Ziniu Zhang, Liangyu Chen, and Ziwei Liu, from S-Lab at Nanyang Technological University. It went up on arXiv in April twenty twenty-four and landed in Findings of ACL twenty twenty-five. Joining us is Theo, who has read this one closely. Welcome.
[G] Glad to be here. And I'll say at the start, the benchmark design is better than the results discussion. That's an unusual way for a paper to disappoint.
[S] Start with the gap, Theo. There were already web agent benchmarks by twenty twenty-four.
[G] There were, and the authors make their case with a single column in their comparison table: average hops per task, meaning how many distinct websites a task actually requires. MiniWoB++, one. WebShop, one. Mind2Web, one, across the hundred thirty-one websites it covers. RUSS, one point one. WebArena, one point zero six. VisualWebArena, one point zero five. The most ambitious prior entry is WebVoyager at two point four.
[O] So every one of those is a single-site benchmark with rounding error.
[G] Effectively. And the authors argue real user tasks aren't shaped like that. Their running example is a chain: work out which city has a Ferris wheel at its center, book a flight there, book a hotel, then pull up videos of the city. Four unrelated websites, and at least one hop needs you to actually look at a picture rather than parse text.
[S] And the multimodal side was thin too.
[G] Thin and shallow. VisualWebArena added images to WebArena, but the paper argues those tasks need visual input at essentially one step. MMInA claims every one of its tasks requires both visual and textual content, across multiple turns.
[O] So what does MMInA put on the board?
[G] One thousand fifty human-written tasks across fourteen websites, two point eight five hops on average, twelve point nine actions per task, and the longest chain runs ten hops.
[S] How is the environment actually built? Because live websites is a phrase that can hide a lot.
[G] They follow WebArena and formulate browsing as a partially observable Markov decision process. The agent never sees a raw page. It gets an accessibility tree, a structured pruned representation where each node carries an element ID, a type, and text content. When a node is an image, the environment downloads that image and paints the element ID directly onto the picture, so a multimodal model can refer to a specific image by number.
[O] That's a nice touch. It grounds the reference between the visual stream and the text stream.
[G] It is. The action space is twelve summarized actions, following VisualWebArena. Everything runs through Playwright on an X graphics server, at a viewport of twelve eighty by twenty forty-eight.
[S] And the fourteen websites?
[G] Wikipedia through a Kiwix mirror. Car hire, hotels and trains through trip dot com. Flights through momondo. Then Eventbrite, Twitter, Amazon, YouTube, Time Out for food, XE for currency exchange, a travel guide site, and Allrecipes. Plus a shopping site called OneStopMarket.
[S] Which of those are genuinely evolving? That's the paper's central realism claim.
[G] Most are. Two aren't. OneStopMarket is an offline standalone site, and the Wikipedia access is a dated Kiwix snapshot the appendix pins to January twenty twenty-four. And Wikipedia alone supplies twenty-eight point four percent of all hops, with shopping another thirteen percent.
[S] So around forty percent of the hops run against frozen content, in a benchmark whose headline property is evolving real-world websites.
[G] That's a fair reading of their own appendix. In their defense they're transparent about it. The limitations section says the binding constraint is finding sites that let you fetch images out of the HTML at all.
[O] How were a thousand tasks written?
[G] Two ways, and one deserves a flag. They adapted question styles from the WebQA dataset, with a hundred eight QA pairs taken directly from it, and they used GPT-4V to generate similar multimodal questions. Then three human annotators wrote further tasks, following a shortest-path protocol where they act as omniscient readers and record every website node the optimal path touches. All of it was cross-validated.
[S] So GPT-4V generated part of the benchmark, and GPT-4V is the headline evaluated model.
[G] Correct, and the paper doesn't quantify that. It's a genuine self-preference concern. The mitigations are that humans authored and cross-validated the set, and that GPT-4V still only reaches twenty-one point eight percent, so if there's favoritism it isn't buying much.
[O] What's the mix look like?
[G] By domain, Wikipedia is twenty-eight point four percent of hops, shopping thirteen, flight ten point five, hotel ten point three, car rental nine point two, and everything else under eight. By intent, sixty-four point seven percent of hops are actions, meaning book, purchase, navigate, and thirty-five point three percent are information-seeking.
[S] Now the metrics. This is where I got lost on my first read.
[G] This is the whole ballgame, so let me be precise. There are two success rates and they are not interchangeable. Hop success rate is the percentage of successful visits to targeted websites. That's partial credit, scored per website. Task success rate is the percentage of tasks where every hop completed correctly, in order. That one is all-or-nothing.
[O] And in the table those sit side by side with the same four column headers.
[G] Exactly. One hop, two to four hops, five plus, overall, twice over. Eight numeric columns where the left four and the right four mean completely different things.
[S] Give me the concrete trap.
[G] Ten point one three percent. That is GPT-4o's figure at five-plus hops, and it's the best number in that column, but it is a hop success rate. GPT-4o's task success rate at five-plus hops is exactly zero. Same model, same row, same column heading, and one is a leader while the other is the floor.
[O] That's a brutal design for a table.
[G] It is, though the reason they need both metrics is sound. Task success rate on long chains is almost always zero, which gives you no gradient to reason about at all. Hop-level scoring recovers the signal.
[S] How is a hop actually verified? What makes a hop a pass?
[G] Reaching a target URL, or producing a target string. The paper is explicit that a task counts as complete only when all required websites are visited in order.
[S] So the metric is fundamentally about navigation. Did you go to the right places in the right sequence.
[G] Substantially, yes. Single-hop tasks add answer checking on top, either must-include, a strict keyword match where every required keyword has to appear, or fuzzy-match, where GPT-3.5-Turbo is asked whether the agent's statement lets you infer the reference answer.
[S] So there's an LLM judge in the loop, it's GPT-3.5-Turbo, and I don't see an agreement study for it anywhere.
[G] There isn't one. That's a real hole.
[O] One more structural point. The hops are gated, aren't they?
[G] They are. The agent may only proceed to hop k plus one once hop k is verified complete. So a task cannot recover from an early failure, and every deeper hop number is conditional on surviving everything before it.
[O] All right, let's do the numbers properly. What's the shape of the results table?
[G] Eighteen non-human agent rows plus a human row. The eighteen split into three input regimes: six text-only rows reading just the accessibility tree, five caption-augmented rows where BLIP-2 captions the images and a text model reads those captions, and seven genuinely multimodal rows where the model sees the images.
[S] And the human baseline?
[G] Averaged over three test takers. Ninety-six point two five percent overall task success rate, ninety-eight point four three percent overall hop success rate. The introduction rounds that to ninety-six point three.
[S] Three people. That's the ceiling the entire paper is measured against.
[G] Three. It's thin, and it isn't something you can put an interval around.
[O] And GPT-4V?
[G] Twenty-one point seven seven percent overall task success rate, thirteen point eight nine percent overall hop success rate. That's the twenty-one point eight the introduction quotes. And worth noting, both of those famous figures, the twenty-one point eight and the ninety-six point three, are in the introduction, not the abstract.
[O] So now the thing you opened with.
[G] The highest non-human overall task success rate anywhere in that table is twenty-three point zero seven percent, and it belongs to DeepSeek-R1-Distill-Qwen-32B in the caption-augmented setting. A text model reading BLIP-2 captions. It beats GPT-4V's twenty-one point seven seven.
[S] And the paper's own results discussion opens with a bullet headed multimodality-reliance, claiming multimodal models show higher performance on both metrics.
[G] It does, and that bullet is in tension with a row a few lines above it.
[O] Let me push back, because I don't think the claim is dead. Within model families, doesn't the pattern hold cleanly?
[G] It does, and that's the fair version. Gemini-Pro goes nine point five four percent text-only, fifteen point two two with captions, eighteen point four zero as Gemini-Pro-Vision. Monotone. GPT-4 goes nine point three four text, nineteen point eight five with captions, and GPT-4V reaches twenty-one point seven seven. Also monotone. Fuyu-8B goes from zero as a text decoder to thirteen point three nine as a multimodal model.
[O] So within a lineage, adding vision helps every single time.
[G] Every lineage in the table. What breaks is the cross-model claim, that multimodal models as a class beat text models as a class. The best text row beats every multimodal row.
[S] What about GPT-4o? That's the one that confused me most.
[G] GPT-4o is the strangest result in the paper. Multimodal GPT-4o gets eleven point six one percent overall task success rate. GPT-4V gets twenty-one point seven seven. The newer model scores roughly half.
[S] That should set off alarms about the harness rather than about the model.
[G] I think it should, and the paper doesn't investigate it. One caveat before anyone over-reads it. The appendix pins the checkpoints and they're all different: GPT-4o is the November twentieth twenty twenty-four build, GPT-4 is the zero one two five preview, GPT-4V is the vision preview. So GPT-4o against caption-augmented GPT-4 is a comparison within a lineage across checkpoints, not a controlled same-model ablation.
[O] Fine. What happens as the chains get longer?
[G] Collapse. At two to four hops, the best task success rate among all eighteen agent rows is ten point six one percent, from Gemini-Pro-Vision with memory augmentation. Second place is text-only GPT-4 at nine point zero nine.
[S] Worth noting the second-best multihop result in the paper is also a text-only model.
[G] It is. And at five-plus hops, fifteen of the eighteen rows are exactly zero. There are three nonzero entries in the whole column: Gemini-Pro-Vision at one point one three, memory-augmented Gemini-Pro-Vision also at one point one three, and caption-augmented Gemini-Pro at zero point three eight.
[O] So the five-plus band has essentially no discriminative power.
[S] How much of the benchmark is that? If it's a rounding slice, fine. If it's a quarter of the tasks, that's a design problem.
[G] It's roughly a quarter. The appendix breaks tasks down by hop count, and the five through ten hop buckets sum to two hundred sixty tasks out of one thousand fifty. So about twenty-five percent of the benchmark returns a flat zero for almost every system tested.
[S] And how much of it is single-hop? I want that on the record.
[G] That's arithmetic on their table rather than a figure they state, but the multihop buckets, two through ten, sum to five hundred twenty tasks. Which leaves roughly five hundred thirty single-hop tasks out of the thousand fifty.
[O] About half.
[G] About half. So the overall column, which is where the twenty-one point eight comes from, is dominated by single-hop performance in a benchmark named for multihop.
[S] That reframes the headline considerably.
[G] It does, and I want to be careful how I put it. The paper isn't hiding anything, the multihop columns are right there. But if you quote only the overall number, you are mostly quoting single-hop ability.
[O] Why do the chains break? The paper has a specific claim here.
[G] It does, and it's genuinely counterintuitive. You'd expect the success rate of hop one to be independent of how many hops the task has. Hop one is hop one. Instead, first-hop success degrades as total chain length grows. For GPT-4V, first-hop success is fifty-six point five zero percent on two-hop tasks, twenty-two point seven three on three-hop, twelve point five zero on four-hop. Gemini-Pro-Vision goes sixty-nine point two eight, then thirty-two point five six.
[O] So just knowing the task is long makes the agent worse at the first step.
[G] That's the finding. Their explanation is search space. When a prompt names several websites, an agent that fails on the expected site wanders to a different named site instead of retrying. On a single-hop task with one reference URL, it just keeps hammering until it succeeds.
[S] Plausible mechanism. Is it measured?
[G] No. It's a trajectory observation supported by an anecdote about booking a flight to Tokyo. There's no quantified breakdown of failure causes.
[O] What about the deeper hops?
[G] From the third hop onward, both GPT-4V and Gemini-Pro-Vision are exactly zero point zero zero in every hop-count bucket the main table reports, two through six. Not near zero. Zero.
[S] Now the appendix, because I understand the trend doesn't survive out there.
[G] It doesn't, and this is the honest caveat that stays buried. GPT-4V's first-hop rate by chain length reverses in the tail: twenty-five point four two percent at seven hops, forty percent at eight, fifty-six point six seven at nine, fifty-two point six three at ten.
[O] So the longest tasks have the best first hops. That's the opposite of the paper's story.
[G] It is. And the sample counts there are fifty-nine, thirty-five, thirty, and nineteen tasks. Nineteen tasks at ten hops. The paper says outright that success rates fluctuate due to randomness because there are fewer long-range tasks, which I think is the right call. But that caveat lives in the appendix and the main text never surfaces it.
[S] So the claim is really: agents fail earlier as tasks get longer, between two and six hops.
[G] That's the accurate statement, yes.
[O] Let's do the method contribution. The memory augmentation. Does it work?
[G] Partially, and the mechanism is simple. Three memory types: semantic, the world knowledge in the weights. Episodic, the running trajectory of the current task held in context. And procedural, the recorded action sequences of past completed tasks. The intervention is procedural. Append the K most recent similar task trajectories to the prompt.
[S] Which multiplies input length by K.
[G] It does, and that's the cost. They find K equals two near-optimal, with a non-linear relationship. Larger histories bring diminishing returns and, in their words, introduce biases and disturbances into the decision-making.
[O] And the gains?
[G] For Gemini-Pro-Vision, overall task success rate goes from eighteen point four zero to twenty point one three. The dramatic one is the two-to-four hop band: one point five one percent up to ten point six one. That's the best mid-length result in the paper.
[S] And five-plus?
[G] Unchanged. One point one three before, one point one three after. The floor does not move.
[S] What about GPT-4o?
[G] Overall task success rate goes eleven point six one to fourteen point zero four. But its two-to-four band actually drops slightly, three point eight five down to three point three two. The big GPT-4o gain is on the hop metric, where overall hop success rate goes from five point nine four to fourteen point three six.
[O] Which is real, but it's the partial-credit metric.
[G] Right. And here's the summary judgment on the method. Neither memory-augmented row is the best row in the table. Gemini-Pro-Vision with memory reaches twenty point one three overall, still below plain GPT-4V at twenty-one point seven seven and below caption-augmented DeepSeek at twenty-three point zero seven.
[S] So the paper's own method doesn't produce the paper's own best number.
[G] It doesn't. It produces the best two-to-four-hop number, which is a defensible but narrower claim.
[O] Let me make the optimist case, and it isn't about the scores. The contribution is diagnostic. Before this, the field had single-site benchmarks reporting numbers in the forties and a general sense that web agents were getting there. MMInA shows that if you chain three real websites, performance isn't degraded, it's annihilated. Zero from the third hop. That's a load-bearing fact.
[S] I'll concede that entirely, and go further. The hop versus task split is the part other benchmark designers should steal. Partial credit that tells you where in a chain the failure lands beats another aggregate score.
[O] So where's your objection?
[S] What the metric certifies. Task success is largely defined as visiting the required websites in the required order. That's navigation. It is not evidence the flight was booked correctly, or the hotel matched the constraint, or the answer was right.
[G] That's the sharpest criticism available and I score it to you. The URL-based criterion is chosen precisely because live web content changes and you can't pin ground truth to page contents. It's a real engineering constraint. But it does mean the metric is closer to followed the right route than completed the errand.
[S] Second objection: reproducibility. Every site is evolving. A number produced in twenty twenty-four against momondo and Twitter cannot be reproduced today. Twitter isn't even at that URL anymore. And no re-verification pass is reported, so you can't separate agent failure from ground truth that went stale between annotation and evaluation.
[G] Also scored to you. The paper reports no staleness estimate. And the tension is real: they market evolving websites as an anti-memorization feature, which it genuinely is, but the cost is that the benchmark isn't a fixed measuring stick.
[O] Counterpoint, though. Is a frozen benchmark better? WebArena's static sites are reproducible and also trivially memorizable once the tasks circulate.
[G] That's the honest trade and neither paper resolves it. My read, going a step beyond the text, is the field needs both: a frozen reproducible core plus a live rotating slice, reported separately.
[S] Third: the model era. These are the vision preview, Gemini one point zero Pro, the zero one two five preview. The strongest model here is a late twenty twenty-three checkpoint, in a paper published in twenty twenty-five. So agents collapse past hop two is a finding about that generation.
[G] Fair, though the revision does add DeepSeek-R1-Distill-Qwen-32B, which is why it's in the table at all. But no current agent scaffold is evaluated. This is a snapshot, not a live leaderboard.
[O] Let me take one back. On multimodality, I think the paper is more right than that single best row suggests. Every within-family comparison supports it, four for four. One cross-family exception from a reasoning-distilled model doing something quite different, long chain-of-thought over a text tree, doesn't overturn a consistent within-lineage effect.
[G] I'll score that to the optimist, with a qualification. The mechanism matters. DeepSeek-R1-Distill's forty-seven point six eight percent on single-hop is the best single-hop rate in the table, and its overall lead is essentially all single-hop. Its two-to-four hop task success rate is zero.
[S] So it isn't better at the thing the benchmark is named for.
[G] It is not. It's better at the half of the benchmark that's single-hop. And the paper's own text says as much, that reasoning models do well on single-hop tasks and struggle when they have to retain longer contexts. The bullet list just never reconciles that with the multimodality bullet three lines earlier.
[S] What should someone building an eval take from this?
[G] Three things. First, if your task is compositional, report partial credit and strict credit separately, and label them so they can't be confused. This table is a cautionary example of what happens when they share column headers. Second, check whether your aggregate is dominated by the easy slice. Here about half the tasks are single-hop and the overall column mostly reflects them. Third, if a difficulty band returns zero for nearly every system, it isn't measuring anything, it's just sitting there.
[O] And for anyone thinking about agent capability?
[G] The compositional gap is the finding that has aged well even though the specific models haven't. Chaining sites is not the sum of the individual site tasks, and something about knowing the chain is long degrades the very first step. That's worth re-running on current models.
[S] Let's land it. One sentence each, Theo first.
[G] My one sentence for the paper: MMInA shows that cross-website compositional web tasks collapse agents almost completely past the second hop, and that measuring hop-level and task-level success separately is what makes that visible at all.
[O] Mine: the design here is better than its own results discussion, and the diagnostic, zero from the third hop, is a genuinely important fact that no single-site benchmark could have surfaced.
[S] Mine: read the table before you quote it. The famous twenty-one point eight percent is an overall number dominated by single-hop tasks, the best score in the paper belongs to a text model, and success is measured by which URLs you visited in what order.
[O] The full writeup, with the figures, both results tables and the hop-by-hop heatmaps, is on the litsearch site. Thanks, Theo.
[G] Thank you both.
