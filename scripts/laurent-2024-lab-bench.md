---
slug: laurent-2024-lab-bench
title: "LAB-Bench: Measuring Capabilities of Language Models for Biology Research"
description: "FutureHouse built a twenty-four-hundred-question exam for AI research assistants, then found the real story wasn't the leaderboard, it was what happened when they took the multiple choice away."
date: 2026-07-21
guest_name: "Fern"
guest_voice: "af_bella"
---
[S] Take Claude 3.5 Sonnet and GPT-4o, drop the multiple-choice options on the hardest biology tasks in this benchmark, and force them to answer in open text instead.
[S] Both models crash to twenty percent accuracy on multi-step cloning problems, and the two questions they do get right, they get there by guessing the most common antibiotic used in the lab.
[O] And yet on a different task in the same benchmark, reading a scientific table, one of those same models edges out PhD biologists.
[G] Those two facts sitting in the same paper are not a contradiction, they're the whole argument, and untangling them is what we're doing today.
[O] Welcome to Litsearch Audio, where we pull one paper off the map and stress-test it. Today's paper is LAB-Bench, "Measuring Capabilities of Language Models for Biology Research," posted in July twenty twenty-four by Jon Laurent, Joseph Janizek, and seven colleagues at FutureHouse.
[S] Joining us is Fern, who's spent real time with this one. Fern, welcome to the show.
[G] Glad to be here. I'd put this in the top tier of benchmark papers this year, mostly because of how much effort the authors put into undermining their own headline numbers.
[O] That's a hook. Let's start with why they built this thing at all.
[G] The authors' complaint is that the science benchmarks everyone cites, MMLU and GPQA, are essentially exams. Graduate-level, hard to Google, but still recall and reasoning over textbook questions.
[S] Which is a real skill, but it's not what a biologist actually does all day.
[G] Right, and that's their point. A real research workflow is finding a result that's attested exactly once in some paper from last year, reading a figure with no caption, pulling a specific number out of a database, noticing that a published protocol step is broken, planning a multi-enzyme cloning reaction.
[O] So they're arguing you can ace the quiz and still be useless in the lab.
[G] That's their framing, yes. They call strong performance on LAB-Bench necessary but not sufficient for a useful AI research assistant.
[S] Necessary but not sufficient is a hedge. Do they ever commit to a stronger claim anywhere?
[G] On one slice, yes. The hardest category, forty-one Cloning Scenarios, multi-step molecular cloning problems that take a trained biologist ten to sixty minutes. The authors argue that answering those well might be close to necessary and sufficient for a model to be a real molecular-biology collaborator.
[O] That's a much bigger claim than most benchmark papers are willing to make.
[S] It's also the category where, as you just told us, the models fall apart under open-response testing. Keep that in your pocket, we're coming back to it.
[O] Walk us through the actual construction, Fern. What are we scoring?
[G] Twenty-four fifty-seven multiple-choice questions in total, split across eight categories. Three are tool-free tests of raw reasoning: FigQA, reasoning over a scientific figure with no caption, TableQA, the same for a table, and ProtocolQA, where a published protocol has been deliberately broken and the model has to say what step needs fixing.
[S] And the rest?
[G] Five categories are deliberately tool-dependent, built so a model without retrieval or sequence software should struggle. LitQA2 asks for an esoteric finding attested once in a recent paper, not recoverable from the abstract, so it's a literature-RAG probe. SuppQA gives you a paper's title and DOI and asks for something only in the supplemental material. DbQA pulls facts from specific biology databases, spread across enough different sources that no single API answers them all. SeqQA is fifteen subtasks on DNA, RNA, and protein sequences, things like primer design and restriction digests. And Cloning Scenarios is the human-hard, multi-plasmid category we already mentioned.
[O] That's a genuinely broad slice of what a working biologist touches in a week.
[S] How were the questions actually written? I'd want to know if this is crowdsourced trivia or something more careful.
[G] Two pipelines. SeqQA and DbQA are scalable enough to generate programmatically. Everything requiring judgment, LitQA2, SuppQA, FigQA, TableQA, ProtocolQA, and Cloning Scenarios, was written manually by the authors and contracted biology experts.
[O] And there's a clever trick in there worth calling out. They'd ask a frontier model to propose candidate questions, then look for where it produced nonsense or unanswerable options, and hand-revise exactly those.
[S] Harvesting the model's own blind spots to build the exam.
[G] Exactly, and it's a genuinely reusable idea for other benchmarks, not just this one.
[O] Now the part I actually think is the paper's best contribution: the scoring.
[G] Every question includes an explicit "insufficient information" option, so a model can decline instead of guessing. That splits the metric into three numbers instead of one. Accuracy is correct over all questions, precision is correct over only the ones attempted, and coverage is how many it attempted at all.
[S] So a model that refuses constantly can look great on precision while its accuracy tanks.
[G] Right, and that gap between precision and accuracy is itself a finding, because in real research a confidently wrong answer is worse than admitting you don't know.
[O] How was this actually run on the models?
[G] Zero-shot chain of thought, no tools of any kind, no internet, no retrieval, no sequence software, answers parsed straight out of the text completion, averaged over three runs. Seven models: Claude 3.5 Sonnet, Claude 3 Opus, Gemini 1.5 Pro, GPT-4o, GPT-4 Turbo, Claude 3 Haiku, and Meta's Llama 3, at seventy billion parameters, which isn't multimodal, so it skips the two image categories.
[S] And the human side?
[G] A panel of PhD-level biology researchers, but unlike the models, they were allowed the internet and a free DNA-manipulation tool, and asked, on the honor system, not to use AI. About eighty percent of each subtask is public on Hugging Face, twenty percent is held back privately to monitor contamination, plus a canary string embedded in the data so future training crawls can filter it out.
[O] Let's get to the actual numbers. Who wins?
[G] Humans, clearly, across most categories, on accuracy, on precision, and they answer more questions too. But the category-by-category pattern is where this gets interesting.
[S] Start with the worst one for the models.
[G] FigQA. Almost every model sits at near-random precision reading figures, the one exception being Claude 3.5 Sonnet, which is dramatically better at parsing technical images than the rest of the field.
[O] And the best one?
[G] TableQA, which is strange, because tables here are also presented as bare images. Claude 3.5 Sonnet narrowly surpassed human precision and matched human accuracy. It's the one category where a model actually closes the gap.
[S] What about the literature-retrieval task, since that's the one everyone actually wants an AI assistant to nail?
[G] LitQA2 is a good example of the refusal problem. Every model clears about forty percent precision, comfortably above random. But the big frontier models often attempt well under twenty percent of the questions, and that low coverage drags their accuracy below random.
[O] So they know enough to be right when they answer, they just mostly decline to answer.
[G] That's the read. SuppQA is even more extreme, it has the lowest coverage of any category, models essentially refuse it outright, which the authors think reflects how underrepresented supplemental text is in training data compared to the main paper.
[S] And the sequence tasks, since that's the one closest to actual bench work?
[G] SeqQA lands around forty to fifty percent precision overall, but the subtask spread is huge. Above ninety percent precision on the easiest primer-design task, where the model is handed the actual gene sequence, and near collapse on anything requiring long-sequence manipulation, like counting restriction fragments or computing amplicon length from a template.
[O] There's a fun outlier in there too.
[G] On one translation-efficiency subtask, Claude 3.5 Sonnet actually beat the humans, eighty-eight percent precision to seventy-five percent. Though the honest caveat, straight from the paper, is that the human experts found that particular question genuinely confusing.
[S] So it's not entirely a capability story, it's partly the humans tripping on a badly calibrated question.
[G] Exactly the kind of caveat this paper doesn't hide. ProtocolQA clusters around fifty to sixty percent precision for every model, with fairly high coverage since it doesn't require lookup, just proposing a fix from training knowledge. Cloning Scenarios sit well below human performance across the board.
[O] Now give us the number that opened the show.
[G] Because the models were hitting above-random precision even on the hardest multiple-choice questions, the authors got suspicious and reran subsets of Cloning Scenarios, ProtocolQA, and FigQA as open-response questions, no options to choose from, just Claude 3.5 Sonnet and GPT-4o. Scores collapsed. Twenty percent accuracy for both models on Cloning Scenarios, thirty percent on FigQA, and on ProtocolQA, Claude 3.5 Sonnet beat GPT-4o thirty percent to twenty percent.
[S] And the mechanism behind those two correct cloning answers?
[G] Both models got the same two out of ten right, and in both cases they arrived there by guessing the single most common enzyme, or the single most common antibiotic used for selection. Not reasoning through the biology. Test-taking.
[O] That's a genuinely damning result, and I respect that they went looking for it themselves rather than letting the multiple-choice numbers stand.
[O] So let me make the strongest case for what this paper shows. The methodology is a real advance regardless of who wins the leaderboard, splitting accuracy from precision from coverage should be standard practice on any benchmark where a wrong guess is worse than an honest refusal. And TableQA is real evidence that on at least one practical skill, frontier models are already at expert level.
[S] I'll take the other side. The open-response collapse means most of this multiple-choice leaderboard was measuring test-taking ability, not lab competence, and that has to make you discount every precision number that isn't backed by an open-response check. On top of that, the comparison to humans isn't fair by the authors' own admission, models had zero tools, humans had the internet and a sequencing tool, and that handicap is concentrated exactly in the categories where humans look like they're crushing the models.
[O] But the fair test, tool-augmented agents, is explicitly left for someone else to run. That's not the authors dodging, that's scoping an initial benchmark honestly.
[S] Sure, but it means the current gap size is basically unknowable. It could shrink a lot once you hand a model retrieval.
[G] You're both right, and the paper actually gives you the evidence to referee this. Look at where the human-versus-model gap is smallest, FigQA, TableQA, ProtocolQA, the three tool-free categories, and it vanishes completely on TableQA. That's consistent with Sam's point, once you remove the tool handicap, models look a lot closer to expert.
[O] Which supports my case that the ceiling is higher than the headline suggests.
[S] It also means we don't actually know how much of "human wins everything" was ever a fair test in the first place.
[G] And there's a second complication that cuts against treating this as settled in either direction. On Cloning Scenarios specifically, the human evaluators often didn't think a ten-to-sixty-minute question was worth their time, and the authors admit outright that baseline may be unreasonably low. So models guess their way up on some categories while humans under-try on others, and the true gap sits somewhere you can't read directly off the chart.
[O] I'll concede that. The precise size of the gap is genuinely unstable.
[S] There's a third fairness problem, and it's on the human side. Overall human coverage is only sixty-nine percent, and on DbQA it drops to thirty-five percent, meaning the "human baseline" for over a third of the database questions is thin at best.
[G] That's fair. TableQA and SeqQA fare better, eighty-two percent and sixty-four percent coverage respectively, but DbQA is genuinely underpowered as a human comparison, and the paper says as much, recruiting and managing enough qualified experts was one of their acknowledged constraints.
[S] One more thing that struck me reading the actual PDF and not just the summary. There's no dedicated safety or dual-use discussion anywhere in this paper. Given they're testing whether a model can plan a multi-enzyme cloning workflow, I expected at least a paragraph on it.
[G] You're right, I checked too. Beyond a request not to post dataset examples online and a canary string for contamination, there's nothing on misuse. It's framed purely as a capability benchmark, and the questions themselves stay at the level of naming which enzyme fixes a plasmid, nothing approaching an operational protocol, but the silence on the broader question is a real gap in the discussion section.
[O] Worth naming, even if nothing in the dataset itself is operationally sensitive.
[S] What does this mean for how we should read benchmarks more broadly?
[G] The biggest exportable idea is treating "declined to answer" as a first-class outcome instead of folding it into wrong. Any agentic or tool-using benchmark has the same failure mode this paper caught, a model that games multiple choice by eliminating distractors instead of doing the task.
[O] And the contamination handling is a template worth copying too. Twenty percent held private, a canary string, and a parity check between public and private splits that came back within five percent on every model.
[S] With a real durability problem, though. Eighty percent of the data is public on Hugging Face, and the headline numbers are reported on the full set, not the private slice. As that public split leaks into future training runs, those full-set numbers will drift upward for reasons that have nothing to do with genuine capability. Worth remembering too, even with a clean parity check, every model's absolute accuracy on that split comparison still clustered down around twenty to thirty-five percent, so nobody was close to strong performance to begin with.
[G] Which is exactly why the authors flag it themselves, and why the private twenty percent is the number worth tracking going forward, not the leaderboard as published today.
[G] If I had to leave you with one line, it's this. LAB-Bench's real contribution isn't the leaderboard, it's proving that its own leaderboard needed an asterisk, and then publishing the asterisk.
[O] Mine is that TableQA is real evidence, not a fluke, the first concrete case I've seen of a frontier model matching a PhD biologist on a genuinely practical reading task. Fern, thanks for digging through this one with us.
[S] And mine is the opposite lesson from the same data. Until someone reruns this with tools and open-response grading as the default, read every multiple-choice number here as a ceiling, not a floor. That's LAB-Bench, full figures and the write-up are on the litsearch site.
