---
slug: li-2025-legalagentbench
title: "LegalAgentBench: Evaluating LLM Agents in Legal Domain"
description: "A three-hundred-task agent benchmark over seventeen real Chinese legal databases — and the metric named process rate that never actually reads the process."
date: 2026-07-31
guest_name: "Alistair"
guest_voice: "bm_daniel"
---
[O] Here is a benchmark that finally scores the work and not just the answer. It has a second metric called process rate, and the whole pitch is that it gives an agent credit for surfacing the right intermediate facts on the way to a conclusion.
[S] That is the reading I would love to be true. I do not believe it is what the authors implemented.
[O] It is right there in the name. And the motivation is exactly the thing we complain about every week, that a final-answer score cannot distinguish an agent that got most of the way there from one that never engaged with the problem at all.
[G] The name is doing an enormous amount of work there. The appendix settles it. Both metrics are computed against the same string, the agent's final answer. Process rate simply scores that answer against a larger set of keywords. It never inspects the trajectory, and it never checks which tools were called.
[S] So the metric that is supposed to audit the process does not read the process.
[G] It does not. And what I find genuinely interesting is that the paper's own tables prove it, if you know where to look.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Today it is LegalAgentBench, Evaluating LLM Agents in Legal Domain, by Haitao Li, Junjie Chen, Jingli Yang, Qingyao Ai and colleagues, out of a Tsinghua-led group, published at A C L twenty twenty-five in the main track.
[S] And we have Alistair with us, who has read this one closely. Alistair, before we go anywhere else, there is a framing point I want nailed down in the first minute.
[G] You want me to say that this is a Chinese-law benchmark, and it is. Every corpus in it is Chinese data. Chinese company registrations, Chinese court and law-firm directories, Chinese statutory articles, Chinese guiding cases. The queries and answers were written in Chinese and translated only for the figures in the paper.
[O] And the authors are not coy about that.
[G] Not at all, they state it in their limitations. The dataset is, in their words, primarily constructed in Chinese, they plan an English-supporting version later, and they note that the task design primarily covers the statutory law system, and that performance in case law systems requires further exploration. So nothing here is evidence about common-law jurisdictions or English-language legal work.
[S] Good. Because the title just says legal domain, and I have watched that kind of framing get laundered into a general claim two citations downstream.
[O] Fine, but caveat noted and logged. Alistair, set up the gap. Why build this at all when we already have general agent benchmarks?
[G] The argument is about tolerance for error. Benchmarks like AgentBench and ToolBench test planning, tool calls, and error recovery, but in domains where getting the gist right is usually good enough. The authors argue legal work does not have that slack. A case number parsed one digit wrong, a filing date confused with a trial date, a court jurisdiction misattributed, those are not near misses, they are wrong answers with consequences.
[S] And the existing legal evaluations?
[G] They tend to stop at narrower tasks. Legal case retrieval, judgment prediction. Things you can do with a single model call. None of them require an agent to chain several tools against a live knowledge base the way actual legal research does. The authors claim this is the first dataset to evaluate LLM agents, as opposed to LLMs, in legal scenarios.
[O] That is their claim, not ours, I take it.
[G] Correct, it is their framing, and I would treat it as a positioning statement rather than a settled fact.
[O] So what is actually in the box?
[G] Three pieces. An environment, a toolset, and tasks. The environment is seventeen real-world corpora. Fourteen of them are tabular databases you look things up in, company registrations, court directories, law-firm records, enforcement and dishonesty case lists, administrative penalty records. The other three are retrieval corpora, and those are sizeable, roughly twenty-six thousand nine hundred and fifty-one legal-knowledge entries drawn from legal books, fifty-five thousand three hundred and forty-seven enacted legal articles, and two thousand three hundred and seventy officially published guiding cases.
[S] Real data, or a synthetic rendering of real data?
[G] Real, publicly available Chinese government and corporate filings. That matters for their contamination argument later.
[O] And thirty-seven tools on top.
[G] Thirty-seven. Three text retrievers backed by Zhipu A I's Embedding three model, five arithmetic tools, sum, subtraction, multiplication, division and ranking, twenty-eight database lookup tools tied to specific tabular corpora, and one system tool called Finish that the agent calls to submit its answer.
[S] Twenty-eight lookup tools is a lot of surface area. Is tool selection the actual difficulty here, rather than legal reasoning?
[G] That is a fair challenge and the paper's error analysis partly concedes it. But the tools are deliberately narrow, each one maps to a corpus and a key type, so the difficulty is in knowing which chain of them answers the question.
[O] Tell me about the task construction, because three hundred hand-written multi-hop tasks would be a heroic annotation effort.
[G] They did not hand-write them, and this is the cleverest engineering in the paper. It is a six-step pipeline. First, planning tree construction, where they build a tree out of the call relationships between tools and corpora. Each node is an entity, each edge is a tool that takes you from one entity to the next.
[O] So the graph of what is reachable from what.
[G] Precisely. Second, path selection, which samples paths through that tree at a controlled depth. That is where the difficulty tiers come from, one-hop through five-hop serial chains, plus parallel-path tasks they call Writing tasks, where you need several independent pieces of information at once. Drafting a legal defense document, for instance, needs the plaintiff, the defendant, and their lawyer looked up in parallel, alongside retrieved legal knowledge.
[S] Third?
[G] Entity selection, picking concrete entities, real company names, case numbers, court names, that actually resolve along that path. Then the templated question, which reads like what is entity three of entity two of entity one, gets rewritten by G P T four into something natural that hides the underlying solution path.
[S] Stop there. G P T four rewriting the questions is a contamination vector and a difficulty confound at once.
[G] It is worth flagging, though I would scope it narrowly. The rewriting is cosmetic, it changes the surface phrasing only. The answers are not generated by a model at all, they are produced by actually running the known toolchain, which is why they can be correct even for a five-hop question. And then step six, human verification. The authors state they manually validated all questions, solution paths, and answers, revising incompatible queries and tools.
[O] That is a genuinely scalable recipe. You could extend that to a new domain in a month.
[G] That is explicitly their pitch, yes, that the pipeline extends to new knowledge bases and tools.
[S] All right. The metrics. This is where we started and I want it airtight.
[G] Then let me give you the formula, because it is the crux of the episode. Appendix E point two defines it. You have a dataset of data points, each with a keyword set K and a model output O. The rate for a data point is the size of M over the size of K, where M is the set of keywords in K that appear in O. That is it. Keyword recall.
[O] And the two metrics differ only in K.
[G] Only in K. When K is the key underscore answer set, the keywords a correct final answer should contain, you get success rate. When K is key underscore answer union key underscore middle, where key underscore middle holds keywords from the intermediate tool-call results along the gold path, you get process rate.
[S] But O is the same O in both cases.
[G] The same O in both cases. The final answer text. There is no second pass over the trajectory, no check that a tool was invoked, no parse of the action sequence. The main text says it plainly too, that success rate calculates the proportion of key answer elements included in the LLM's answer, and process rate further incorporates key middle, measuring the ratio of both sets present in the answer.
[O] I will be honest, I read that as a trajectory audit on first pass. So did the writeup on the site, for several drafts.
[G] It is an easy misread, and the naming does not help. The paper itself calls it process rate in the main text and progress rate in the appendix, for the same quantity.
[S] You said the tables prove it. Show me.
[G] Here is the proof. If process rate scanned the trajectory, it would be strictly easier to satisfy than success rate on hard tasks, because the agent visits far more intermediate facts than it reports. So process rate should sit above success rate almost everywhere, and especially at depth. It does not. At five-hop, under ReAct, G P T four oh scores sixty-one point one seven on success and only forty-eight point eight on process. Qwen Max, same scaffold, same bucket, sixty point eight three success against forty-nine point oh eight process. G L M four Plus, forty-three success against forty point two six process.
[S] Process below success, at the hardest depth, for three different models.
[G] And that is only possible if the larger keyword set is being checked against the same, limited final answer. Because at five-hop the average task carries five point six key middle keywords against two point two five key answer keywords. You are diluting a fixed answer string against a much bigger target vocabulary, and the recall falls.
[O] That is a clean piece of forensics. I concede the point entirely.
[S] I want to be fair to the authors here, though. Is the metric useless, or just badly named?
[G] Badly named, and weaker than it sounds. It does carry real signal. An answer that mentions the intermediate jurisdiction it had to look up is, on average, more likely to have actually looked it up. But it is a proxy, not an audit, and the paper never quantifies the gap between the two.
[O] Let us get to results, because there is a headline here and I want to defend it.
[G] The headline is G P T four oh under ReAct, seventy-nine point oh eight percent aggregate success rate across all three hundred tasks. That is the best cell in the table, across twenty-four model-by-scaffold combinations. And it gets there on roughly eleven point two million tokens, which is not the most expensive run by a distance.
[O] Then G L M four Plus and Qwen Max.
[G] Both under ReAct, seventy-four point nine nine and seventy-four point two two. And at the bottom, G P T three point five turbo and LLaMA three point one eight B Instruct never clear thirty percent aggregate under any scaffold. G P T three point five's best is twenty-nine point eight six, LLaMA's is twenty-three point five nine, both with ReAct.
[S] Good, the benchmark discriminates. A benchmark where everything scores the same is a thermometer with one marking.
[O] And the difficulty gradient by hop count?
[G] Real, but I want to be careful with the word. The best one-hop cell is G P T four oh mini under ReAct at ninety-three point three three percent. The best five-hop cell is G P T four oh under ReAct at sixty-one point one seven. So the gradient is there in aggregate. It is not monotonic per row, though. Thirteen of the twenty-four rows break it somewhere. G L M four under Plan-and-Solve, for instance, sits at eighteen point oh six at three-hop and rises to thirty-seven point oh eight at four-hop.
[S] Thirteen of twenty-four is more than half. That is not a rounding error, that is bucket noise.
[G] With twenty tasks in the five-hop bucket and forty in the four-hop, I would agree the per-bucket estimates are loose. The aggregate trend survives, the per-row story does not.
[O] What about scaffolds? Because ReAct looks dominant.
[G] Typically strongest, which is the paper's own word, and I would keep it. There are real counter-cells. The Writing tasks are where it reverses for several models, though not most. For G P T four oh, ReAct's Writing score is sixty-five point four one, and it trails both Plan-and-Solve at seventy-nine point seven one and Plan-and-Execute at eighty-six point four three.
[O] Because Writing needs parallel gathering, and ReAct is a serial correction loop.
[G] That is the authors' explanation, yes. Claude three point five Sonnet shows the same reversal, as do G P T four oh mini and LLaMA. The other four models actually do best or near-best on Writing under ReAct, so it is a real but partial effect.
[S] And the cost of ReAct?
[G] Substantial and uneven. Claude's ReAct run burns roughly thirty-two point nine million tokens against seven point one million and thirteen point six million for its Plan-and-Solve and Plan-and-Execute runs on the same three hundred tasks.
[S] So a more-than-four-times cost multiplier, and for Claude it does not even win. Its aggregate under Plan-and-Execute is sixty-seven point oh three against ReAct's sixty-five point seven nine, at well under half the tokens. That is a live engineering trade-off, not a free win.
[O] Alistair, there is one result I want you to adjudicate, because it is the one that made me sit up. The process rate reranks the models.
[G] It does, and this one holds. G L M four Plus's aggregate process rate beats G P T four oh's under all three scaffolds. Sixty-three point oh four against fifty-four point seven four under Plan-and-Solve, sixty-four point one six against fifty-seven point nine three under Plan-and-Execute, and seventy-two point eight against seventy-one point nine nine under ReAct.
[O] So the model that loses on final answers is more likely to be surfacing the right supporting facts. That is exactly the kind of thing a single headline metric hides.
[S] Careful. Under ReAct that gap is eight tenths of a point. I would not build a thesis on it.
[G] Both of you are right about different scaffolds. Under Plan-and-Solve and Plan-and-Execute the gap is eight and six points respectively, which is substantial. Under ReAct it is under a point, and I would call that a tie. And there is a scoping correction I want on the record, because the paper overreaches slightly here.
[S] Go on.
[G] The paper's prose says G L M four Plus surpasses G P T four oh in progress rate across all tasks. That is true for the aggregate column under all three scaffolds. It is not true cell by cell. If you go through the individual task-type columns, G L M four Plus loses five of the eighteen. Under ReAct it loses one-hop, two-hop, three-hop and five-hop, and under Plan-and-Execute it loses Writing.
[O] So say aggregate, not across all tasks.
[G] Say aggregate. The claim survives, the universal quantifier does not.
[S] While we are auditing the prose against the tables, was there anything else?
[G] There is one discrepancy worth airing, and I want to state it carefully because I am not accusing anyone of error. The paper's section four point two says the performance gap between different reasoning methods for the same LLM can reach sixty-five percent. The largest such gap I can locate anywhere in the paper's own table is forty-seven point five points, G P T four oh at three-hop, seventy-five percent under ReAct against twenty-seven point five under Plan-and-Solve.
[S] And you checked exhaustively, not just the obvious rows?
[G] Every model against every column, fifty-six groups in total. Forty-seven point five is the maximum, and nothing comes within seventeen points of sixty-five. What I cannot tell you is where the sixty-five came from. It may reference a computation not shown, or an earlier version of the table. So the honest statement is that the table does not show a sixty-five point gap, not that the sentence is wrong.
[O] That is the right way to put it. Let me make the optimist case, then, and I will keep it narrow. This is real data, real tools, and a construction pipeline that scales. Three hundred tasks verified by hand over seventeen live corpora is a serious instrument, and more than sixty points of spread between the weakest and strongest agents means it measures something.
[S] My deflationary case is about what the score actually certifies. Keyword recall rewards an answer for containing the right tokens. It says nothing about whether the reasoning that produced them was sound. An agent that pads its answer with plausible court names and case numbers it half-retrieved scores well.
[G] That is the strongest objection in the room and the paper does not close it. There is no audit of false-positive keyword matches on either metric. No human or judge spot-check asking whether a keyword-matched answer was actually correct. And process rate, as you two just worked out, cannot close it either, because it is scored against the same answer text.
[O] Counter-pressure, though. Exact match on free-text legal writing is brutally brittle, and an LLM judge brings its own validity problems. Keyword recall is a defensible middle.
[G] It is, and the paper does report BERTScore as a third metric. But it notes that BERTScore compresses the spread between baselines considerably, which is why they lean on the two keyword rates for their main comparisons. So the discriminating metrics are the ones with the unaudited failure mode.
[S] What about contamination? Real public filings sound memorizable to me.
[G] Argued structurally, not measured. The authors note the underlying corpora evolve over time, which mitigates overfitting, and the tasks are assembled by their own pipeline rather than scraped from something a model could have swallowed whole. That is a reasonable argument. But there is no direct check, no run with tools disabled to see how many tasks a frontier model can answer from parametric memory alone.
[S] That control is cheap. One run, tools off. It would have taken an afternoon.
[G] I agree, and it is the single addition that would most raise my confidence.
[O] Anything on the baselines?
[G] Eight models across three scaffolds is a broad sweep for a first benchmark paper, and the bookends are well chosen. But all three scaffolds are prompting strategies from twenty twenty-two and twenty twenty-three. There is no fine-tuned agent, no legal-domain-adapted one, and nothing from the more recent planning and tool-use literature. So it is genuinely unclear how much of the headroom above seventy-nine percent is real difficulty and how much is a limitation of generic scaffolds.
[O] The error analysis is worth a mention before we close, because it is the most legally specific part.
[G] It is. Agents confuse filing date with trial time. They misread structured fields inside case numbers. And they routinely fail to notice that a query requires consulting the legal-knowledge corpus rather than answering from what the model already thinks it knows. The trajectory-level failures fall into four buckets, wrong tool-call arguments, wrong tool or wrong sequence, blowing the context length, and looping until the ten-iteration cap fires.
[S] Ten iterations is a tight budget for a five-hop task, incidentally.
[G] It is. Five hops with any recovery from a bad call and you are close to the ceiling.
[O] So what changes if this holds? For me it is that domain benchmarks with real tool surfaces and real records are buildable at reasonable cost, and that the scaffold you choose can swing a model's score by more points than the gap between two model generations.
[S] For me the lesson is a metric-naming one, and it generalizes well past this paper. A metric called process rate that never reads the process will be cited as evidence of process fidelity by people who only read the table. That is not a Chinese-law problem or a legal-domain problem, that is a benchmarking hygiene problem, and we do it constantly.
[G] And I would add the thing the paper gets right that survives all of it. Reporting two metrics that rank models differently is more honest than reporting one. The instinct is correct even where the implementation is weaker than the name suggests.
[O] Alistair, your one-sentence takeaway.
[G] LegalAgentBench is a carefully built, real-data agent benchmark for Chinese statutory legal work, whose two-tier scoring is a genuine idea implemented as keyword recall over a single output string, and validated structurally rather than empirically.
[S] Mine, read the metric definition before you cite the metric name. The appendix is where the claim actually lives.
[O] And mine, the construction pipeline is the durable contribution here. Planning tree, path selection, run the toolchain for ground truth, verify by hand. That recipe outlives whatever the current models score.
[S] The full writeup, with the figures, the table, and the references, is on the litsearch site. Thanks Alistair.
[G] A pleasure.
