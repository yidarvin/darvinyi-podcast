---
slug: zhang-2026-bio-uplift
title: "LLM Novice Uplift on Dual-Use, In Silico Biology Tasks"
description: "Fifty-seven biology novices, a fleet of frontier models, and up to thirteen hours each reveal a four-times uplift in dangerous-task accuracy — with safeguards that barely registered as an obstacle."
date: 2026-07-19
guest_name: "Marcus"
guest_voice: "am_fenrir"
---
[S] Marcus, before we even say the title of this paper, give me one number.
[G] Eighty-nine point six percent of participants using these models reported no trouble at all getting past the safety guardrails.
[O] And I'd counter with a different number from the same paper: novices with model access beat human experts on three of four benchmarks where the two groups were directly compared.
[S] Two numbers, one study, and together they're scarier than either one alone.
[O] Welcome to Litsearch Audio. Today we're covering LLM Novice Uplift on Dual-Use, In Silico Biology Tasks, out of Scale AI and SecureBio.
[S] Joining us is Marcus, who has studied this paper closely. Marcus, welcome.
[G] Glad to be here.
[O] This one earned a slot because it isn't another single-shot benchmark — it's a genuine human experiment, and the design choices matter as much as the headline number.
[S] Marcus, set up the gap this paper is filling. We already have benchmarks like the Virology Capabilities Test and LAB-Bench showing models can match or beat expert virologists on isolated questions. Why isn't that enough?
[G] Because a single-shot benchmark measures one query, scored in isolation, and that's not how anyone actually uses these tools. The authors argue the risk-relevant quantity is uplift — how much better a person does with model access than without it, over a sustained interaction.
[O] Which cuts both ways. Uplift could run higher than single-shot scores suggest, because a person can rephrase past a refusal. Or lower, because a novice might not be able to tell a confident wrong answer from a correct one.
[G] Exactly, and that ambiguity is why you need the human-in-the-loop experiment instead of just querying the model directly.
[S] There's prior work here too. Anthropic ran uplift trials as part of the safety case for Claude Opus 4, and those trials contributed to its ASL-3 safety designation. What is this paper adding on top of that?
[G] Two things. Anthropic's trials tested one model at a time, with something like eight to ten participants over a short horizon. This paper gives fifty-seven novices access to a whole fleet of models at once, because a real adversary wouldn't commit to a single model — they'd cross-check answers and route around whichever one refuses.
[O] So it's simulating a mosaic strategy, stitching capability together across models rather than depending on any one guardrail.
[G] That is their term for it. And they stretch the time horizon substantially, up to thirteen hours on the hardest task, specifically so they can watch uplift accrue instead of catching one snapshot.
[O] Walk us through who actually did this, Marcus.
[G] Two cohorts, both screened as biology novices by self-report. A STEM cohort of forty-seven people with Python experience, each assigned to a single condition, Control or Treatment, for one long coding or agentic task. And a non-STEM cohort of ten people, backgrounds like English, philosophy, political science, who worked many written tasks and were deterministically alternated between conditions, so the same person did both, controlling for individual ability.
[S] And Control means what exactly? "Internet access" can mean a lot of things these days.
[G] Internet only, and specifically no AI-powered search. They used Google's plain Web tab so the AI Overview panel never appeared. Treatment participants got a tool wired to the model fleet — o3, o4-mini, Gemini 2.5 Pro, Claude 3.7 Sonnet, and Claude Opus 4 once it released mid-study — plus Gemini Deep Research capped at one request per hour.
[S] That control condition is doing real work. If it had allowed AI Overview, the whole contrast would already be contaminated.
[G] Right, and they were deliberate about closing that gap.
[O] What were people actually asked to do?
[G] Ten tasks across eight benchmark suites. Some are multi-select knowledge tests — the Virology Capabilities Test, VCT, the Human Pathogen Capabilities Test, HPCT, and a Molecular Biology Capabilities Test, MBCT — one and a half hours each. Some are longer form: World Class Biology at six hours, Humanity's Last Exam, HLE, at four. And two are agentic coding benchmarks, including one Long-Form Virology task, LFV, that ran up to thirteen hours across six sequential subtasks.
[S] Thirteen hours is a real commitment for a study participant.
[G] It is, and that's the point — they wanted to see whether uplift keeps compounding or saturates, which you can't observe from a fifteen-minute single-shot query.
[O] And there were two more comparison groups beyond Control and Treatment — experts and standalone models?
[G] Yes. Human experts answered the same questions with any non-LLM resource they wanted, but in a tight fifteen-to-thirty-minute window. Standalone models were run zero-shot through the UK AI Safety Institute's Inspect framework, ten trials each on four frontier models, with refusals scored as zero.
[S] I want to flag something already — fifteen to thirty minutes for the expert against up to thirteen hours plus a model fleet for the novice. Hold that thought, I'm coming back to it.
[G] Fair — that's worth coming back to.
[O] How did they protect the integrity of the data itself?
[G] The team members running data collection were blind to ground-truth answers throughout, and the platform logged every model call on Treatment, specifically to deter Control-group participants from cheating with an off-platform model.
[O] Okay, give us the headline number, Marcus.
[G] Novices with model access were four point one six times more accurate than internet-only controls, with a ninety-five percent confidence interval running from two point six three to six point eight seven. In absolute terms, after adjusting for variability across tasks and people, that's accuracy moving from roughly five percent up to just over seventeen percent.
[S] So the eye-catching ratio is riding on a low base rate.
[G] It is, and I'll come back to that. But the relative and absolute pictures point the same direction. Treatment beat Control on seven of eight benchmarks. On VCT, twenty-seven point seven percent versus five point one percent. On HPCT, forty-one point three percent versus ten point four percent, nearly a four-times gap. The single largest gap was a fragment-decomposition coding sub-task inside the agentic benchmark: seventy-seven point eight percent versus sixteen point seven percent.
[O] What's the one benchmark where it didn't hold?
[G] LFV. Control scored fifty-eight point two percent, Treatment fifty-three point four percent, statistically indistinguishable. There's a clean explanation: both groups were handed the same published reference paper up front, which turns the task from finding the literature into interpreting a document already in hand, and that erases the search advantage a model normally provides.
[S] Now here's what I actually want to know — how did Treatment do against real experts?
[G] Beat them on three of the four benchmarks with expert data. HPCT, forty-one point three versus thirty-one percent. VCT, twenty-seven point seven versus twenty-two point two. Experts only held the line on MBCT, thirty-two point five versus twenty-five point three.
[O] Non-experts, given a model and enough time, matching or beating credentialed professionals. That is the sentence that should worry a policymaker.
[S] Or the sentence that needs the most caveats attached, and we'll get there. What about model-alone versus human-plus-model?
[G] This is the part the authors themselves flag as surprising. On several benchmarks the standalone model beat the LLM-assisted human. On MBCT, model-alone scored forty-nine point two percent against the human Treatment score of twenty-five point three. On LAB-Bench, sixty point five versus forty-two point two.
[O] Wait, Marcus — is under-optimal reliance the only explanation for that, or could this just be a skill gap that narrows with practice, not a fixed ceiling on what humans plus models can do?
[G] The paper can't fully separate those two stories from one study, to be fair. What it does show is that participants who deferred more to the model tended to score better, which points toward under-reliance rather than over-reliance as the dominant failure mode here, but whether that closes with training is outside what this data can answer.
[S] So the human is, on some tasks, actively subtracting value.
[G] That's the authors' read — on well-structured tasks, the human sometimes adds noise to an answer the model would have gotten right alone. The exception is HLE, the open-ended benchmark, where Treatment humans scored twenty-seven point eight percent, clearly ahead of both the average standalone model at ten point seven and the best standalone model at twenty-one point one. When the task is unstructured, the human-model back and forth earns its keep.
[O] Structured multi-select tasks favor just letting the model answer, open-ended tasks favor real collaboration.
[G] That's the split, and it lines up with the qualitative data too.
[S] Tell me about confidence and calibration.
[G] Both conditions were overconfident, the calibration curve sits below the diagonal either way. But Treatment tracked closer to the diagonal at moderate-to-high confidence. At one hundred percent stated confidence, Treatment participants averaged roughly forty-five percent accuracy, versus roughly thirty-five percent for Control.
[O] Still badly overconfident, just less badly.
[G] Right. And the qualitative pipeline shows the model changed how people wrote, not only what they knew. Treatment responses carried twenty-two point three more percentage points of explicit chain-of-thought structure, and ran almost thirty-eight words longer on average. The strongest measured driver of the score gain was error correction — LLM access lifted major error-correction behavior by thirty-seven point two percentage points. But when you ask participants what felt most useful, only twelve percent said error correction; most said conceptual explanation or basic information retrieval.
[S] So the thing that actually moved the score and the thing people credited for it are two different things.
[G] Exactly that mismatch. And on the safety side: eighty-nine point six percent of Treatment participants gave no indication of any difficulty getting past a model's safeguards. Refusal rates themselves barely moved with LLM access — the measured effect was negative one point nine percentage points, not statistically significant.
[O] Let me make the strongest case for taking this seriously. This is the first study I know of that measures sustained, multi-model uplift instead of a single query, with real people, real time, and serious statistical machinery — mixed models, false-discovery-rate correction, the works. The finding survives that scrutiny: uplift above four times, novices clearing the expert bar on three of four benchmarks, and safeguards that functionally did nothing. If I'm setting policy, that combination is the whole ballgame.
[S] I'll grant the method is the right method, sustained and multi-model is real progress over one-shot benchmarks. But some of the individual headline numbers don't survive close reading. Start with "novices beat experts." Marcus, walk me through the actual comparison there.
[G] Novices had between one and a half and thirteen hours, with a fleet of frontier models. Experts had fifteen to thirty minutes and nothing but their own knowledge. So it isn't a test of whether AI makes a novice as good as an expert, it's a test of whether hours plus model access beats minutes without. The paper's own stated limitations don't flag that asymmetry directly — it's visible if you read the method section carefully, but it isn't in their caveats list.
[S] Which is exactly my complaint. "AI closes the novice-expert gap given a huge time advantage" is still real, but it's a more modest claim than "novices beat experts."
[O] Fair, but even the modest version is notable — hours of self-directed study with search alone presumably wouldn't close that same gap, or Control would have scored higher too.
[S] Agreed, that part holds. My second issue is the "standalone models beat the humans" comparison, and that's not apples to apples either. Marcus, the model-only numbers come from a clean pipeline, right?
[G] Correct. Zero-shot, the Inspect harness, refusals auto-scored zero. Clean, structured, one number per model per question. The human numbers come from messy multi-hour transcripts scored after the fact. So "the human is a bottleneck" is plausible, but it's partly an artifact of comparing two different measurement pipelines, not the same test administered two ways.
[O] Okay, I'll concede that one — that comparison is shakier than the topline framing suggests.
[S] And here's the piece that worries me most. The one result that favors humans, HLE, is exactly the benchmark the authors admit got contaminated. Some questions were found posted online mid-study, so they cut data collection short.
[G] That's accurate. They handled a smaller contamination risk on LAB-Bench with a trust-based instruction rather than stopping collection there too. So the one result arguing that human-in-the-loop still adds value sits on the least clean data in the paper.
[O] That's a real problem for that specific finding, I'll grant it. But it doesn't touch the core uplift number — the four-times gain over Control isn't built on the contaminated benchmark.
[S] No, and to be fair, the core Treatment-versus-Control result is the most robust thing here. My last point is about what's being measured at all. Everything in this study is in silico — purely computational, no wet lab, no materials acquisition, no hands-on tacit skill. Historically that's been the real bottleneck for biological misuse, and this paper doesn't touch it.
[G] The authors say so themselves, and they call it an open question for future work. I'd add that the eighty-nine point six percent safeguard figure is inferred from an absence of complaints in free-text notes, read by an LLM annotator. It is not a measured jailbreak-success rate, and participants weren't necessarily trying to break anything in the first place.
[O] Which is still meaningful. If determined users routinely didn't even need to try circumventing anything, that's a failure mode in itself.
[S] Sure, but "nobody complained" and "safeguards don't work" are different claims wearing the same headline number.
[G] Scoring it the way the paper's own evidence supports: the central uplift finding, Treatment beating Control by roughly four times on seven of eight benchmarks, is solid and holds up to the scrutiny. The "beats experts" and "loses to standalone models" comparisons are real effects built on asymmetric or cross-harness baselines, so they need the caveats attached before you repeat them. And the eighty-nine point six percent safeguard number is suggestive, not a direct measurement of anything adversarial.
[O] So what changes if this holds up?
[G] For evaluation practice specifically, it argues that a benchmark suite alone under-describes risk. You need the sustained, interactive, multi-model condition to see where uplift actually accrues and where it saturates.
[S] It's also a case study in why baseline choice matters more than the topline number. Every one of the paper's punchiest claims traces back to which baseline you compare against — expert time budget, harness consistency, benchmark contamination. That's a lesson for evaluation design generally, not just this paper.
[G] There's a subtler point buried in the qualitative results too. Participants' self-reported sense of what helped didn't match what the statistics showed actually moved their scores. Any evaluation that leans on user self-report as a proxy for what a system is doing should take that mismatch seriously.
[O] And there's the safeguards point — refusal rate as a metric barely moved, even though functional access to information apparently did. That's a construct-validity warning for anyone treating refusal rate as a safety metric on its own.
[G] If you take one thing from the paper itself, it's that sustained, multi-model human uplift is a real and previously under-measured signal, and one-shot benchmarks alone are no longer sufficient to characterize this kind of risk.
[O] My takeaway is that the underlying capability story here is more real than any single headline number — three of four benchmarks with novices matching trained professionals given model help is not nothing, even with caveats attached.
[S] Mine is to read every one of those percentages next to its baseline before repeating it, because asymmetric time budgets and cross-harness comparisons can turn a real effect into a much louder headline than the data alone supports. For the figures, the full method, and our detailed critique, head to the writeup on the litsearch site.
