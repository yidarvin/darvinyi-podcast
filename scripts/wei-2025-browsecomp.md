---
slug: wei-2025-browsecomp
title: "BrowseComp: A Simple Yet Challenging Benchmark for Browsing Agents"
description: "OpenAI built a benchmark where the trainers who wrote the questions couldn't solve seven in ten of them, plain GPT-4o scores next to zero, and only a browsing agent trained on similar data breaks fifty percent."
date: 2026-07-19
guest_name: "Cerys"
guest_voice: "bf_emma"
---
[O] Here's a number to sit with. The people who wrote this benchmark's questions gave up, after two hours of trying, on seventy point eight percent of them.
[S] And here's the number that worries me more. The one model that actually clears the bar, OpenAI's Deep Research, was trained on data specifically built to make it good at this exact benchmark. So is fifty-one point five percent a browsing breakthrough, or a benchmark grading its own homework?
[O] I think it's both, and I think that tension is the whole episode.
[S] Agreed. Let's find out which side wins.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a guest scholar take apart one paper from the litsearch dot darvinyi dot com atlas. I'm your optimist host.
[S] And I'm the skeptic. Today's paper is BrowseComp: A Simple Yet Challenging Benchmark for Browsing Agents, by Jason Wei, Zhiqing Sun, and colleagues at OpenAI, posted in April twenty twenty-five.
[O] And joining us is Cerys, a researcher who's spent real time with this benchmark and the questions inside it. Cerys, welcome.
[G] Thanks for having me. And just to set expectations, I'm not one of the authors, so when I say "the authors show" or "the paper argues," that's me describing their work, not claiming it.
[S] Perfect, that's exactly the distinction we need today, because this paper makes some strong claims about what browsing agents can do.
[G] It does, and the claims are worth taking seriously precisely because the paper is honest about their limits. That's rare enough to notice.
[O] Let's start with the gap this fills. Cerys, why did OpenAI think the field needed a new browsing benchmark at all?
[G] Because the old ones had stopped measuring anything hard. Benchmarks like TriviaQA, HotpotQA, FEVER, Wizard of Wikipedia, and ELI5 all share a property the authors flag directly: they test information findable in a single hop or two of search, and language models had largely saturated them.
[S] Saturated meaning what, in practice?
[G] Meaning accuracy had climbed high enough to stop separating strong models from weak ones. Meanwhile AI was moving from chatbots to reasoners to genuine browsing agents, and there was no reliable yardstick for what those agents are actually built for: persistently hunting down obscure facts across many sources.
[O] I like the framing in the introduction. It's almost philosophical about why humans are bad at this in the first place.
[G] It is. The authors give three reasons human web navigation is, in their word, clunky: limited memory and world knowledge, distraction and fatigue, and attention that can't parallelize. A sufficiently capable machine should overcome all three and retrieve any well-specified piece of information from the open web, even from thousands of pages.
[S] That's a big claim to build a benchmark around. What's the actual engineering problem in testing it?
[G] The tension between difficulty and ease of grading. Hard information-seeking tasks produce long, messy answers, miserable to score. Easy-to-grade short answers tend to be easy to find. BrowseComp threads that needle: a short string trivial to verify but extremely hard to locate, difficulty raised until even the trainers mostly can't solve their own questions.
[O] So let's get into how they actually built it, because I think this is the cleverest part of the paper.
[G] It's called the inverted question, and it's a genuinely elegant trick. A human trainer starts from a seed, a person, an event, an artifact, whatever. They gather several characteristics of that seed, each one spanning a large search space on its own. Then they compose a question out of the conjunction of those characteristics.
[S] Give me the example, because conjunction of characteristics is abstract.
[G] The exemplar they gave trainers: what's the title of the scientific paper published at EMNLP between twenty eighteen and twenty twenty-three, where the first author did undergrad at Dartmouth College and the fourth author did undergrad at the University of Pennsylvania. The answer: a paper called Frequency Effects on Syntactic Rule Learning in Transformers.
[O] And you can verify that in about thirty seconds once you have the paper title.
[G] Exactly, a couple of searches confirm it instantly. But finding it from scratch would mean examining thousands of EMNLP papers and checking every author's undergraduate background for each one. That asymmetry, cheap to verify, brutal to find, is the entire design philosophy in one example.
[S] How do they enforce that the questions are actually that hard, rather than just annoyingly worded?
[G] Three checks. First, stump GPT-4o with and without browsing, OpenAI's o1, and an early Deep Research. Second, five Google searches must fail to surface the answer. Third, a softer check: another trainer shouldn't solve it within ten minutes, and trainers solved more than forty percent of the time were sent back to revise.
[O] So it's adversarially hardened against both machines and humans before it ever ships.
[G] That's fair. And there's one honest limitation baked into the method: answer uniqueness is, in their words, likely but not guaranteed. You can verify the reference answer is correct, but you can't cheaply prove no other answer also fits.
[S] That sounds like it could quietly break the whole grading scheme. How do they mitigate it?
[G] Mostly through trainer judgment. The Dartmouth example works partly because Dartmouth is a small school, and the trainer already knew no one else from there published at EMNLP in that window. Trainers add more constraints when unsure, and a question gets discarded if a second trainer finds a different valid answer within ten minutes.
[O] What did the final dataset look like after all that filtering?
[G] Twelve sixty-six questions, down from twelve eighty-seven after twenty-one were removed for bad ground truth, we'll come back to that. Topics were assigned post-hoc by a prompted ChatGPT model across ten categories, TV shows and movies, science and technology, art, history, sports, music, video games, geography, and politics, deliberately reflecting trainers' own interests.
[S] And grading itself?
[G] Deliberately simple. Every reference answer is one short string, so an AI model judges semantic equivalence, using the same grader prompt as Humanity's Last Exam. Models also output a confidence score, feeding the calibration work later. For contamination defense, the dataset ships a canary string, plus a request not to post examples online.
[O] Let's get to results, because this is where the paper earns its headline.
[G] The core table is stark. GPT-4o scores zero point six percent. GPT-4.5 scores zero point nine percent. Both essentially at zero. Giving GPT-4o browsing access barely moves it, up to one point nine percent, which the authors call their sharpest point: tool access alone is not the capability.
[S] Wait, browsing access only takes it from point six to one point nine percent? That's a rounding error on a hard benchmark.
[G] That's the finding. OpenAI's o1, which can't browse at all but reasons well over internal knowledge, reaches nine point nine percent, higher than either GPT-4o variant, meaning some answers surface from what the model already knows. Only Deep Research, trained explicitly for persistent browsing, clears the bar for real, at fifty-one point five percent.
[O] That's roughly a five-fold jump over o1, and nearly thirty-fold over browsing-enabled GPT-4o. That's not an incremental result, that's a different capability regime.
[S] Or it's a model trained on exactly this kind of task outperforming models that weren't. We'll get to that.
[G] Hold that thought, it deserves its own moment. Two more results first: performance scales smoothly with test-time compute, climbing from around nine percent toward fifty-two percent as browsing effort grows. Separately, sampling sixty-four answers per question and aggregating improves accuracy by fifteen to twenty-five percent over one attempt, and best-of-N wins outright at about seventy-eight percent.
[O] Seventy-eight percent is a completely different number than fifty-one point five. That's the same model, just spending more compute and picking its best guess.
[G] Right, and the interpretation matters. Even though confidence scores are poorly calibrated in an absolute sense, best-of-N working this well tells you the model frequently knows when it's right, even if it can't express that as a probability. Verifying really is easier than finding, exactly the asymmetry the benchmark is built around.
[S] Now give me the calibration numbers, because I suspect they cut the other way.
[G] They do, and it's the wrinkle I'd flag hardest. Calibration error is worst for the models with web access: ninety-one percent for Deep Research, eighty-two percent for GPT-4o with browsing, versus sixty-five percent for o1, which can't browse at all. Browsing appears to make models more confidently wrong, not less.
[O] That's a real caution flag for anyone deploying a browsing agent in a setting where a wrong answer with high confidence is worse than an honest "I don't know."
[G] Exactly the authors' read too. On the human side, trainers solved twenty-nine point two percent, three sixty-seven out of twelve fifty-five, and gave up on seventy point eight percent after the two-hour cap. Of the ones they solved, their answer agreed with the reference eighty-six point four percent of the time.
[S] That eighty-six point four is interesting on its own. That means even among questions humans solved, about fourteen percent of the time their answer didn't match the official one.
[G] A small but real signal about that uniqueness caveat. One more result: the pass-rate distribution across sixty-four trials per question. O1 sits at a zero percent pass rate on seventy-nine point three percent of tasks. Deep Research solves sixteen percent perfectly but fails completely on fourteen percent, bimodal, it nails a question nearly every time or almost never.
[O] What happened with the tasks Deep Research never solved?
[G] The authors ran a follow-up: they handed the model the correct answer and asked it to find supporting evidence. In most cases, it succeeded. So most of those failures weren't impossible, they were strategic, the model simply didn't search the right path within its budget.
[S] Alright, time for the case I actually want to make. Let's do the debate properly.
[O] I'll go first, then you take it apart. This paper demonstrates a benchmark can be brutally hard for both machines and the experts who built it, and dirt cheap to grade. That's a genuine design achievement, most hard benchmarks sacrifice one for the other.
[S] I'll grant that. The inverted-question trick is clever and I don't think it's a gimmick.
[O] Second, the scaling result is real evidence, not marketing. Accuracy climbing smoothly with test-time compute, and best-of-N reaching seventy-eight percent, tells you there's a genuine, extractable signal in the model's browsing behavior, not just noise around fifty percent.
[S] Now the deflationary case, starting with the footnote doing enormous work: Deep Research "is trained on data that specifically teach the model to be good at BrowseComp tasks." That fifty-one point five versus nine point nine gap isn't a clean capability comparison. Part of it, maybe a large part, is just training-distribution advantage.
[G] Fair, and worth being precise about what it does and doesn't undercut. It's fine as a demonstration that browsing agents of this kind can be built and work. It's weaker as a basis for ranking reasoning versus browsing on these exact numbers, because the comparison isn't apples to apples.
[S] Second point, and this one bothered me more the longer I sat with it. The entire comparison set is OpenAI's own models, GPT-4o, GPT-4.5, o1, Deep Research, even though the introduction names Gemini, Perplexity, and Grok as the target model class this benchmark is meant to evaluate.
[S] There's no cross-lab leaderboard here. This paper establishes a benchmark and one vendor's place on it, not the field's place on it. Anyone citing fifty-one point five as "the state of browsing agents" is reading past what was actually measured.
[G] The authors do invite outside researchers to evaluate other agents on BrowseComp, and the dataset is public, so the door is open. But as published, you're right that it's a single-lab result.
[O] Fine, point to you there.
[S] Third point, and this is the one I find sharpest: the "likely but not guaranteed" uniqueness assumption. An LLM grader checks a predicted answer against one single reference string. A genuinely correct alternative answer would just be scored wrong. Is there any evidence this actually happens, not just a hypothetical risk?
[G] There is, and it's internal to the paper. Of the one hundred eighteen tasks where Deep Research scored zero percent, the authors audited them by hand and found twenty-one with mismatched, ambiguous, or outright incorrect ground truth. Those were removed from the final twelve sixty-six.
[S] Twenty-one out of one hundred eighteen is close to eighteen percent of the tasks they actually checked.
[G] Correct, but that's the crucial qualifier: they only audited the zero-pass tail. The rest of the dataset wasn't audited the same way. So the label-error rate is meaningfully above zero somewhere in the dataset, but we don't know the rate across the whole twelve sixty-six.
[O] That's a real gap, but it's the kind of thing a version two fixes, not a reason to dismiss the benchmark.
[S] Agreed, a caveat, not a disqualifier. Last point: contamination defense here is entirely social. A canary string, plus a polite request not to post examples online. No enforcement mechanism.
[G] That's accurate. Because answers are short, findable strings by design, any leaked question becomes trivially gameable, you just need the leaked text, not the reasoning. The authors call it an incomplete but useful benchmark, analogized to CodeForces for coding agents, sidestepping the real user-query distribution of long answers and genuine ambiguity.
[O] So where does the debate land for you, Cerys, if you had to score it?
[G] Split, and that's the honest read. The design is genuinely clever and the difficulty is real, evidenced by trainers failing on seven in ten questions. But the headline fifty-one point five percent needs three asterisks: it's a same-lab comparison, the winner had a training advantage on this distribution, and the uniqueness auditing only covered the hardest failure tail.
[S] That's fair, and I'll say the scaling and best-of-N results survive my skepticism. Those are internally consistent findings about how the model behaves under more compute, independent of the vendor question.
[O] So we agree the benchmark itself is a good idea, well executed, and the interpretation of the current leaderboard is where the real caution belongs.
[G] That's exactly right, and I think that's how the authors themselves frame it too, if you read the discussion section closely rather than just the abstract.
[O] Let's zoom out for a second. What does this mean if it holds up, both for browsing agents and for evaluation practice more broadly?
[G] For browsing agents, it's evidence that persistent, creative, multi-hop search is a trainable, separable skill, distinct from raw reasoning and from simply bolting a browser tool on. That matters for anyone deciding where to invest: training data for search behavior, not just bigger reasoning models.
[S] For evaluation practice, here's the finding every benchmark builder should internalize: giving a model tools can make it more confidently wrong, not less. An evaluation that only reports accuracy and skips calibration misses exactly the failure mode that matters most in a deployed agent.
[O] And the verification-versus-generation asymmetry that makes this benchmark cheap to grade is a pattern showing up across a lot of agentic evals right now, not just browsing, short checkable answers sidestep the expensive judge-reliability problems that plague open-ended evaluation.
[G] Which is also its narrowness. The paper is explicit that it sidesteps long answers and query ambiguity entirely. It measures one important slice of browsing well. It is not a stand-in for the messier, more common case of an assistant answering an open-ended, ambiguous user question.
[S] Closing thoughts. Mine: treat fifty-one point five percent as a demonstration, not a leaderboard entry, until someone runs Gemini or Claude through the same twelve sixty-six questions with no home-field advantage.
[O] Mine: the inverted-question design is a real methodological contribution other benchmark builders should borrow from, difficulty and cheap grading don't usually coexist this cleanly, and here they do.
[G] And the paper's own bottom line: read BrowseComp as a clean measure of persistence and creative search on hard-to-find facts, not as a vendor-neutral ranking or a general proxy for browsing usefulness.
[O] Cerys, thank you for walking us through this.
[G] Happy to. It's a benchmark worth taking seriously exactly because the authors are so clear-eyed about what it can't tell you.
[S] Full writeup, tables, and figures are on the litsearch site if you want to dig into the calibration numbers yourself. We'll see you next episode.
