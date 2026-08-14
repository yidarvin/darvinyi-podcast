---
slug: li-2026-agentskillos
title: "AgentSkillOS: Organizing, Orchestrating, and Benchmarking Agent Skills at Ecosystem Scale"
description: "A capability tree over a skill marketplace, DAG orchestration on top, and a thirty-task benchmark that is never given a name — plus an abstract that says tree retrieval approximates the oracle while its own ablation figure shows it losing that comparison at every scale tested."
date: 2026-07-28
guest_name: "Perrin"
guest_voice: "bm_daniel"
---
[G] The abstract says tree-based retrieval effectively approximates oracle skill selection. The paper's own ablation figure shows the tree-retrieved system losing more comparisons than it wins against that oracle, at every single ecosystem size they tested.
[S] Ten wins against fourteen losses at two hundred skills. Eleven against twelve at a thousand. Ten against eleven at two hundred thousand. Three for three, on the wrong side of even.
[O] And the paper's word for that is modest, which I actually want to defend, because the trend does what they say it does. The net margin goes from minus four to minus one to minus one. That is a real narrowing.
[S] Narrowing to a persistent deficit is not approximating. And the sentence a reader carries away is the one in the abstract, which has no numbers attached to it at all.
[G] Both readings are defensible, and the distance between them is most of what makes this paper worth arguing about.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Today it is Organizing, Orchestrating, and Benchmarking Agent Skills at Ecosystem Scale.
[S] Hao Li and Chunjiang Mu as joint first authors, with colleagues at the Shanghai Artificial Intelligence Laboratory. It went up on arXiv on the second of March, twenty twenty-six. The system is called Agent Skill O S.
[O] Our guest is Perrin, who has been through this one down to the cells of the tables. Perrin, why does this earn a slot?
[G] Because it is one of the first serious attempts to treat a skill marketplace as an infrastructure problem rather than as a list, and because it ships a benchmark alongside the framework. That benchmark has some properties we should talk about carefully.
[S] Start with what a skill even is here, because the word is doing a lot of load-bearing work.
[G] Claude introduced skills in October twenty twenty-five. A skill is a markdown file that defines a structured folder — declarative instructions, executable scripts, and auxiliary resources — that a model can load and run at inference time. The difference from a tool is granularity. A tool exposes one function or one endpoint. A skill packages an entire procedure.
[O] And they caught on quickly.
[G] They did. Skills have been adopted by several model providers and integrated into platforms like Coze. The paper's motivating number is that as of late February twenty twenty-six, more than two hundred and eighty thousand skills were publicly listed on one marketplace, and the overwhelming majority come from decentralized third-party contributors.
[S] I want to fence that number off right now, because it is the one that gets misquoted. Two hundred and eighty thousand is the marketplace. It is not what this system organizes. Perrin, what does it actually organize?
[G] The experiments construct three ecosystems, of two hundred, one thousand, and two hundred thousand skills. And even at two hundred thousand, the capability tree only covers the top ten thousand of them. Everything else sits in a dormant index.
[O] So the honest framing is that a marketplace of two hundred and eighty thousand motivates the problem, and the largest structure they actually build a tree over holds ten thousand skills.
[S] What is the failure mode they claim this causes?
[G] Two of them. From the user's side, no global view — you cannot see what exists, what capabilities are exposed, where things overlap. From the agent's side, no composition mechanism at all. The paper's own phrasing is that skills increasingly become fragmented and isolated contributions, and that many skills remain underused.
[S] Many, not most.
[G] Many, and they do not quantify it. Worth preserving that hedge, because it is theirs.
[O] Right. Take me through the tree, then.
[G] Two stages, and the split matters. Manage Skills runs offline, once, and builds the capability tree. Solve Tasks runs per task, and does retrieval, orchestration, and execution.
[G] The tree is built breadth-first by recursive categorization. At each node you have a set of skills. An L L M does Group Discovery — propose category names and descriptions for that set, guided by a branching factor. Then a second pass does Skill Assignment — place each skill into one of those groups. Any node whose skill count exceeds a per-node capacity threshold gets split again. Leaves are individual skills.
[S] Why two passes rather than one?
[G] Their claim is that separating the naming from the assignment sharply reduces the chance of dropping skills during construction. Which is a real failure mode, and they handle it explicitly. If a skill comes back unassigned because of hallucination, it gets a second assignment attempt, and if that also fails it goes into whichever category is largest.
[O] That last part is a garbage bin.
[G] It is a garbage bin, yes. And there is a second one. Any category that ends up holding exactly one skill gets merged into its nearest relevant neighbour, and the neighbour's name and description get rewritten to cover it.
[S] Hyperparameters.
[G] Branching factor of seven for the two hundred and one thousand ecosystems, twelve for two hundred thousand. Each node is asked for somewhere between three below the branching factor and two above it. The capacity threshold is one and a half times the branching factor, rounded down. And after retrieval, the shortlist keeps the top eight skills.
[O] The root categories are not discovered, though.
[G] Correct, and I read that as an honest design choice rather than a cheat. The five root categories are fixed by hand — content creation, data processing, software development, automation, and domain-specific. Their stated reason is stability. You do not want the top-level partition of your entire ecosystem to be a sample from a language model.
[S] Now the ten thousand cap. How do they choose which skills make it into the tree?
[G] Install count on the marketplace. They maintain what they call a usage-frequency queue, take the top K by that score, union it with anything the user has manually added, and that set becomes the tree. Everything else goes into a vector index over skill names and descriptions, retrievable by embedding similarity, and promotable into the tree if it proves useful during a task.
[O] So popularity is standing in for quality.
[S] Which is a real assumption, and it cuts directly against the paper's own motivation. If the problem is that good skills are invisible because the ecosystem is enormous, then ranking by install count keeps the already-visible ones visible and leaves the rest exactly where they were.
[G] That tension is in the paper and it is not resolved. They frame the queue as reducing the inclusion of low-quality skills, which is plausible on its own terms, but you are right that it is the same selection pressure that produced the discovery problem in the first place.
[O] Alright. A user types a request. What happens?
[G] The L L M walks the tree layer by layer, choosing relevant category nodes and descending into them, and every leaf it reaches becomes a candidate. The prompt explicitly encourages inclusiveness — include anything that could help achieve the goal. Then a pruning pass deduplicates and ranks by relevance down to the top eight.
[O] And the pitch for a tree over plain embedding search is what, exactly?
[G] That walking a hierarchy lets the model reason its way to complementary, non-obvious skills, rather than retrieving whatever happens to sit nearest the query text in embedding space. If your task is promote my paper, semantic search finds paper-adjacent skills. Tree traversal can land you in a social media node you would never have matched lexically.
[S] Is that claim tested anywhere?
[G] Not directly, and I think that is the single largest hole in the method section. There is no experiment isolating tree traversal against embedding retrieval over the same pool. The closest thing is one of the ablations, and that compares tree retrieval with orchestration against tree retrieval without orchestration. So the tree-versus-embeddings comparison is asserted, not measured.
[O] Then the graph.
[G] The shortlist goes to an L L M that decomposes the task into sub-tasks, assigns each one a skill, and states each sub-task's dependencies and expected outputs. Those dependencies become directed edges in a Directed Acyclic Graph — a D A G. It emits three alternative plans under three strategies. Quality-First adds preparation and refinement stages. Efficiency-First maximises parallelism by cutting sequential hops. Simplicity-First produces the minimal graph in which every node is load-bearing.
[S] And the user picks one.
[G] The user picks. Then execution is layered — nodes in the same layer run in parallel, layers run in sequence. Each node gets a prompt restating the user task, naming the skill to invoke, listing upstream artifacts with brief usage hints, and stating what downstream nodes will consume. Completed plans get cached in what they call a recipe pool, and reused for similar task descriptions by vector similarity, skipping retrieval and orchestration entirely.
[O] The recipe pool is the part I would most want numbers on.
[G] There are none. It is described in the method and never evaluated. No hit rate, no latency saving, no quality delta on reused plans.
[S] So let us talk about the benchmark, because I have opinions and I would like them checked.
[G] Thirty tasks. Five categories — data computation, document creation, motion video, visual design, and web interaction — six tasks in each. Human experts first curated high-quality skills from public marketplaces and GitHub, then wrote task descriptions and deliverable requirements around them, sometimes targeting a single skill and sometimes cross-composing several.
[O] And the outputs are artifacts, not answers.
[G] That is the design principle they lead with. Every task requires a complete, end-user-facing deliverable — a P D F, a slide deck, a Word document, an H T M L page, a video, generated images — where layout, design, and aesthetics all count. Not a code snippet, not a question-answering pair.
[S] Here is my first objection, and it is not about the numbers. What is the benchmark called?
[G] It is not called anything. Fifteen pages, and section three is titled just Benchmark. It is referred to throughout as a benchmark, or our benchmark. There is no proper noun anywhere in the paper.
[S] Is it released?
[G] The only link the paper gives for its own materials is the Agent Skill O S code repository. There is no separate dataset release, no license statement for the tasks, no standalone artifact.
[O] I will concede that is a problem, and I do not think it is an oversight. Look at how they introduce it. To evaluate the agent's ability to invoke skills, we construct a benchmark, in the abstract. And to systematically evaluate Agent Skill O S, we construct a benchmark of thirty tasks, in the introduction. Twice, instrumentally. It is an evaluation harness for their system that also appears in the contributions list.
[S] Which matters, because it earns a full related-work comparison against ToolLLM, A P I Bank, Gorilla, TaskBench, and the concurrent SkillsBench. If you are going to argue you fill a gap those leave open, you have to be citable.
[G] That is a fair read. And I would add that thirty tasks, six per category, is small for the amount of ranking machinery bolted on top of it.
[O] Say more about the machinery.
[G] Artifacts come back in heterogeneous formats, so a scripted pipeline converts everything into something a judge can consume. Documents and slides render as page images. Web pages are captured as full-page screenshots. Videos are represented by uniformly sampled frames plus metadata — duration, resolution, frame rate. Images are resized to a standard resolution. Text files are included verbatim up to a length limit.
[G] Then Claude Opus four point five judges pairs. Two systems, same task, and the judge picks the better artifact on correctness, completeness, quality, and aesthetics. Every comparison runs in both presentation orders. If the two orders agree, that preference stands. If exactly one order errors out, the valid judgment is used. If the two orders disagree, the outcome is recorded as a tie.
[S] So a tie is two entirely different things wearing the same label.
[G] Yes, and that is a genuine gap. A tie means either the judge saw real parity, or the judge flipped its answer when you swapped the order. Those are opposite epistemic situations, and the paper never reports the split between them.
[O] And then Bradley-Terry on top.
[G] Win counts fill a matrix, ties contribute half a point to each side, and they fit a Bradley-Terry model by maximum likelihood using the M M algorithm with Laplace smoothing at alpha equals one. That yields a latent strength parameter per system, centred at zero mean, and those are linearly rescaled onto zero through one hundred.
[S] Rescaled per ecosystem size, or globally?
[G] Per ecosystem size. Which means one hundred at two hundred skills and one hundred at two hundred thousand skills do not denote the same absolute quality. Each one just means top of this block.
[O] Give me the main table.
[G] Five methods, three ecosystem sizes. Quality-First scores one hundred at all three. Efficiency-First is fifty-eight point five, then seventy-six point one, then eighty-nine. Simplicity-First is fifty-three point six, fifty-six point three, fifty-six. Full Pool — the entire ecosystem handed to flat, native Claude Code invocation — is twenty-four point three, forty-eight point one, seventeen point two. And Vanilla, no skills at all, is zero at all three.
[S] Stop there. Quality-First scores one hundred three times and Vanilla scores zero three times. Those are not findings. Those are the endpoints of a min-max rescaling. By construction the best method scores one hundred and the worst scores zero, whatever the actual margin between them happens to be.
[G] That is correct, and it is worth being blunt about. The informative quantity is the runner-up. Quality-First's lead over Efficiency-First is forty-one and a half points at two hundred skills, twenty-three point nine at a thousand, and eleven points at two hundred thousand.
[O] Hold on, that is the opposite of what I would have guessed. The elaborate strategy's advantage shrinks as the ecosystem gets harder?
[G] It does, and the paper does not discuss it. My read, going beyond the text, is that at two hundred skills the curated pool nearly guarantees you retrieve the right skill, so the only thing separating methods is how well they compose. At two hundred thousand, retrieval noise dominates and both variants end up working from a similar shortlist.
[S] Now the Full Pool row, because that is the one that misbehaves.
[G] Twenty-four point three, up to forty-eight point one, back down to seventeen point two. It improves from two hundred skills to a thousand before collapsing at two hundred thousand.
[S] And the paper's explanation is that as the pool grows, an increasing fraction of skills becomes invisible to the agent, nullifying the benefit of a larger ecosystem. That story predicts a monotone decline. It does not predict a doubling in the middle.
[G] It does not, and the paper does not address the rise. The endpoint supports the invisibility story. The middle is unexplained.
[O] Let me take the honest version of the optimist case. The two hundred pool was deliberately curated — the best-performing skill for each benchmark task, plus hand-picked high-quality extras. So at two hundred, flat provisioning has a small near-perfect pool and still does badly. At a thousand it picks up more coverage without yet being overwhelmed. Then two hundred thousand buries it.
[S] That is a plausible story. It is also a story, and it is yours, not theirs.
[G] Agreed on both counts. And it points at something we should say plainly. The two hundred skill condition — the first one every method is evaluated on — is seeded with the single best-performing skill for each benchmark task. Only the thousand and two hundred thousand pools are extended by raw install count from the marketplace.
[O] Applied identically to every method, though.
[G] Applied identically, yes. So it is not an unfair advantage for Agent Skill O S specifically. It does mean the easiest condition is not a sample of the messy, decentralized ecosystem the introduction is about.
[S] The ablation is where I think the paper earns its keep. Walk it.
[G] Quality-First against four variants, thirty tasks each time, reported as wins, ties, and losses. Against Full Pool: twenty-one, two, seven at two hundred skills; eighteen, three, nine at a thousand; twenty-one, two, seven at two hundred thousand. Against Retrieval-only: twenty-two, five, three; then fifteen, seven, eight; then eighteen, five, seven.
[O] So tree retrieval on its own does not close the gap.
[G] Not close. And then the comparison I would frame as the paper's actual contribution — against Oracle Skills, which is the flat Claude Code agent handed the ground-truth skill set for each task, with no orchestration whatsoever. Quality-First wins eighteen with six ties and six losses at two hundred, seventeen, seven and six at a thousand, and nineteen, three and eight at two hundred thousand.
[S] Say the shape of that out loud, because it is the interesting result.
[G] You give the flat agent perfect skill selection — the exact skills a human expert designated for that task — and the same skills arranged into a D A G still beats it, somewhere between seventeen and nineteen wins out of thirty at every scale. Skill availability is not the bottleneck. Structure is.
[O] That is the finding. And it survives everything we are about to say about the judge.
[S] It survives the design objections. Whether it survives the judge objection is exactly what I want to argue. But I will grant the ablation is a clean shape.
[G] And then the fourth comparison, which is where we opened. Against Quality-First with Oracle skills — oracle selection plus D A G orchestration, the upper bound — Quality-First goes ten, six, fourteen; then eleven, seven, twelve; then ten, nine, eleven.
[O] Losing all three.
[G] Losing all three. Net margin of minus four, then minus one, then minus one.
[S] And the paper's sentence is that Quality-First shows only a modest deficit, and the gap narrows as the ecosystem grows, and that this validates that tree-based retrieval effectively approximates oracle skill selection.
[O] Here is my honest position. Every clause of that is defensible on its own. The deficit is modest — one comparison out of thirty at the two larger sizes. It does narrow. And approximates is a weaker word than matches.
[S] And the abstract puts tree-based retrieval effectively approximates oracle skill selection right next to D A G orchestration substantially outperforms native flat invocation. Two claims, one sentence, identical confidence register. One of them is a nineteen-out-of-thirty win. The other is a loss.
[G] I would score that to the skeptic. The claim is technically defensible and rhetorically misleading, and the fix costs one clause. A small deficit that narrows with scale would have been both accurate and still favourable to them.
[O] Let me make the strongest case for the system anyway, because the structural analysis backs it. They measure node count, edge count, maximum width, and maximum depth across all thirty tasks and all three ecosystem sizes, and the three strategies come out separable. Quality-First produces the largest and deepest graphs with the most edges. Efficiency-First keeps a comparable node count but goes wider and shallower. Simplicity-First is the most compact on every metric.
[G] That is right, and it is a real result. The strategies are not three prompts producing the same plan with different labels attached. They produce genuinely different topologies.
[O] And the case studies show what those topologies buy you. Vanilla Claude Code on a scrolling space-exploration exhibit page gives you a functional page with small, low-fidelity images. Agent Skill O S composes image generation and frontend design skills into full-screen sections with layered scrolling. On a calculus teaching package, vanilla produces basic matplotlib plots with no transitions. Agent Skill O S invokes an animation skill and produces a Manim-rendered video with a secant-to-tangent progression, plus a structured P D F handout.
[S] Both sides running the same backbone.
[G] Both sides executing on Claude Sonnet four point five. So the paper's inference is that the gap comes from skill discovery and composition rather than base model capability. Within this setup, that inference is sound.
[S] Then let me make the deflationary case, and it fits in one sentence. Claude Opus four point five builds the capability tree. Claude Opus four point five writes the D A G plans. Claude Sonnet four point five executes every node. And Claude Opus four point five judges which artifact is better.
[O] That is a closed loop.
[S] It is a closed loop with no exits. There is no human agreement study on the judge. There is no second judge from a different model family. There is no report of how often the two presentation orders actually disagreed. And there are no confidence intervals on the Bradley-Terry scores, which are fit from twenty-four judged comparisons per cell in the main table and thirty in the ablation.
[G] All four of those are accurate, and none of them are addressed anywhere in the paper.
[O] The self-preference concern specifically. How much weight do you put on it, Perrin?
[G] Meaningful weight. Judge self-preference is well documented in pairwise L L M evaluation, and the failure mode here is a sharper version of it. Opus wrote the plans that shaped the artifacts it is now grading, so this is not only same-family preference, it is preference for outputs downstream of its own reasoning. Their position-bias mitigation is real work, genuinely done, but it addresses presentation order, not judge identity.
[S] And the second gap, which I think is under-discussed. Every baseline in the results section is an ablation of Agent Skill O S. Vanilla, Full Pool, Retrieval, Oracle Skills — all the same Claude Code Agent S D K with different skill provisioning.
[G] There is no external orchestration framework in the comparison at all. Not a HuggingGPT-style planner, not a general multi-agent system, nothing from the tool-learning literature the related work section positions against.
[S] So the demonstrated claim is that Agent Skill O S's two components help each other. Not that this approach beats the field. Those two get quietly conflated by the word first.
[O] I will take that one. What I will not give up is the oracle-skills ablation, because it is internally valid on its own terms and it is genuinely counterintuitive. Perfect retrieval, no structure, loses. That reframes where people should think the bottleneck is.
[G] I would score it the same way. The ablation gradient is the paper's contribution and it is cleanly constructed. The absolute quality claims are the part resting on a single unvalidated judge.
[O] So what changes if this holds?
[G] If structure beats availability, the interesting engineering surface for agent systems shifts from which tools does the model have to what shape does the plan take. That is a different research programme from tool retrieval, and it has different failure modes.
[S] And what it means for evaluation practice is less comfortable. This is a benchmark with no name, no separate release, thirty tasks, one judge model that shares a family with the system under test, ties that conflate genuine parity with judge instability, and a scoring function whose top and bottom values are guaranteed by the rescaling rather than earned. Each of those is individually defensible. Together they describe an evaluation harness, not something other groups can run against.
[O] Which is roughly what the authors say it is, in fairness to them. They introduce it as something constructed to evaluate their system.
[G] And that is the honest read. It is this paper's harness first and a community benchmark second. The pairwise-plus-Bradley-Terry design is genuinely well suited to artifact-quality tasks, where absolute scoring is hopeless. It just needs a human agreement check and a second judge before anyone treats the numbers as portable.
[G] The paper's own takeaway is that structured composition, not skill availability, is the key to unlocking the skill ecosystem — and the oracle-skills ablation supports that specific claim well. The oracle-retrieval claim beside it is weaker than the abstract makes it sound.
[O] Mine is that the counterintuitive result held up. Handing an agent exactly the right tools and no plan loses to the same tools in a graph, at every scale they tested. That is worth building on.
[S] And mine is that when one model family builds, executes, and judges, the only numbers you can trust are the ones comparing two of its own configurations against each other. Read the ablation. Discount the scores.
[O] The figures, the full tables, and the eval critique are in the writeup on the litsearch site.
