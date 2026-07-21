---
slug: bowman-2022-scalable-oversight
title: "Measuring Progress on Scalable Oversight for Large Language Models"
description: "Ajeya Cotra's 'sandwiching' thought experiment for supervising a smarter-than-us AI gets its first real test: non-expert humans chatting with an unreliable 52-billion-parameter model on hard exam and reading questions beat both the model alone and their own unaided guesses by wide margins."
date: 2026-07-20
guest_name: "Emmett"
guest_voice: "am_fenrir"
---
[S] Here is an uncomfortable number buried in this paper's own footnotes. The two participants who scored best without any help from the model were quietly dropped from the results.
[O] Dropped because they didn't need the technique being tested. Everyone left in the study started in the high forties to high fifties percent accuracy, unaided, on hard multiple-choice questions.
[S] And by the end, with nothing more than a chat window to an unreliable fifty-two billion parameter model, they were routinely clearing seventy-five percent. That's either the most important small study in AI safety this year, or a selection effect wearing an impressive number as a disguise.
[O] Which is exactly the fight worth having, and exactly why we brought in someone who has actually sat with this paper's numbers.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper from the frontier of AI evaluation. Today's paper is "Measuring Progress on Scalable Oversight for Large Language Models," by Samuel R. Bowman and dozens of colleagues at Anthropic, working with recruiting partners at Surge AI, posted in November of 2022.
[S] It's the paper that turned a purely theoretical safety problem into something you can actually run a study on. That alone earns it a slot on this show.
[O] Joining us is Emmett, a researcher who has spent real time with this line of work. Emmett, welcome.
[G] Glad to be here. This is a paper people cite constantly for its framing, and much more rarely for its actual numbers, which I think is slightly backwards, so let's fix that today.
[O] Start us with the problem this is actually trying to solve, because scalable oversight is one of those phrases that gets used loosely.
[G] The term goes back to Amodei and colleagues' twenty sixteen "Concrete Problems in AI Safety" paper. Scalable oversight is the problem of supervising a system once it starts outperforming its supervisors on the skills that matter for the task at hand. Not if that happens, but what you do once it does.
[S] And in twenty twenty-two, when this was written, that system didn't exist yet.
[G] Right, and that's the paper's opening move. By then there were several serious technique proposals on the table, debate, market-making, recursive reward modeling, but almost no empirical evidence for any, because of a circular obstacle. To test an oversight technique on a model that broadly exceeds human ability, you need a model that broadly exceeds human ability. None existed.
[O] So how do you get empirical traction on a problem defined by a capability regime that hasn't arrived yet?
[G] That's precisely the question this paper answers, and its answer isn't a new technique. It's an experimental design that lets you study the problem today, years before the systems it's ultimately about.
[S] Walk us through that design, because "sandwiching" is a strange name for a research paradigm.
[G] It comes from Ajeya Cotra, who proposed it in twenty twenty-one, and this paper is the first to operationalize and run it. The idea: place a model's capability between two groups of humans on the same task. Expert evaluators have all the skill the task needs, and their only job is to grade the outcome at the end.
[O] And the model sits below them.
[G] Below the experts, but above the non-expert participants. The model has most of the relevant knowledge from pretraining but isn't reliably aligned to use it well when asked directly. The non-experts understand the task and are well-intentioned, but are missing key knowledge the model has. Their job is to reliably extract trustworthy answers from that model, without any help from the experts.
[S] So the non-experts are standing in for us, later, when the model genuinely does know more than we do.
[G] Exactly that analogy. If the non-experts can pull it off today, against a model that's only modestly more capable than they are, that's evidence the technique could, in principle, keep working against a future model that's dramatically more capable.
[O] That's an elegant way to make an unmeasurable future problem measurable now.
[S] Elegant, but the paper immediately relaxes two parts of Cotra's original design to make a first study tractable. What did they give up?
[G] Two things, both named explicitly. First, a static model: participants interact with it only through dialog, no fine-tuning, no inspecting its weights. The question becomes how much a human can extract through conversation alone. Second, labels in place of experts: instead of convening a live expert panel, they use two existing multiple-choice datasets and score against the published answer key.
[S] Which sidesteps the cost of expert panels at the price of a less faithful sandwich, to use their own words against them.
[G] Their own words exactly, and they say so directly in the paper. Both relaxations make the study cheap enough to actually run, at the cost of narrowing how much the results can tell you about the full paradigm.
[O] What were the two tasks, and why those two?
[G] MMLU, specialized exam questions across dozens of subjects, and time-limited Quality, multiple-choice reading comprehension over roughly five-thousand-word short stories, made artificially hard by giving participants a five-minute limit that rules out reading the whole story. Both were chosen because a present-day model could plausibly beat an unaided non-expert on them, while still making frequent mistakes.
[S] And the model itself?
[G] A fifty-two billion parameter dialog assistant, fine-tuned for helpfulness using the RLHF recipe from Bai and colleagues' twenty twenty-two paper. Helpfulness only, not helpfulness-and-harmlessness, which matters, because a model trained only to be helpful is more willing to just answer.
[O] And the humans?
[G] Two groups of five, recruited and managed through Surge AI, one group per task, each answering the same hundred randomly sampled validation questions. This is where the dropped-participant issue Skeptic opened with comes in.
[S] Let's get the actual numbers, because "dropped" undersells what happened.
[G] One outlier per task was excluded, after scoring far above the other four unassisted, eighty-four percent versus a fifty-seven percent average on MMLU, eighty-nine versus forty-nine on Quality, and beating the model outright. The paper calls this a deliberate but consequential trim, needed to satisfy the assumption that non-experts lack the task-relevant knowledge the model has.
[O] Deliberate, and disclosed. That's a paper being honest about a hard methodological choice, not hiding one.
[S] Disclosed doesn't make it free. We'll come back to what it costs.
[G] Five conditions were compared across the remaining eight participants: unassisted human, the model answering zero-shot, the model with five-shot prompting on MMLU only, since Quality passages don't fit multiple examples in context, the model with a best-of-twenty chain-of-thought strategy reranked by a preference model, and human-model team, the condition everything else exists to measure against.
[O] Give us the headline number.
[G] Individual accuracy first. The best model condition beat unassisted humans by a wide margin on both tasks, sixty-six percent versus fifty-seven on MMLU, sixty-seven versus forty-nine on Quality. Model-assisted humans then beat that same best model condition by a similarly wide margin, seventy-five versus sixty-six on MMLU, seventy-seven versus sixty-seven on Quality. Every participant exceeded seventy-one percent individual accuracy, assisted, on both tasks.
[S] That's the individual-participant story. What happens when you aggregate across the group?
[G] That's where it gets more interesting, and more mixed. Looking at weighted-majority-vote across the four participants per task, the model actually ties or beats the humans on their own. Sixty-six versus sixty-six on MMLU, roughly tied. Sixty-seven versus fifty on Quality, the model clearly ahead.
[O] So unaided humans, as a group, are not obviously better than the model at either task.
[G] Correct, and that's an important number in its own right, it's evidence the sandwich actually holds, the model really does sit above these particular non-experts on these tasks. But then human-model teams beat the best model result by large margins on both. Seventy-eight percent versus sixty-six on MMLU. Eighty-six versus sixty-seven on Quality.
[S] Eighty-six versus fifty is the number that actually matters to me, the humans' own unassisted weighted vote.
[G] That's the paper's largest headline gain, a thirty-six percentage point improvement over the humans' own unassisted weighted-vote score on Quality. And even that combined seventy-eight and eighty-six percent still falls short of the expert ceiling on both tasks, seventy-eight versus ninety on MMLU, eighty-six versus ninety-three point five on Quality.
[O] Which tells you there's real room left, but the direction and the size of the effect are both large.
[S] Those two ceiling numbers aren't the same kind of number though, and the paper buries that distinction. Emmett, is that right?
[G] It is. Quality's ninety-three point five is a genuinely measured untimed human-team result. MMLU's ninety percent is explicitly labeled a hypothesized estimate for a committee of experts, nobody actually measured it. One gap is real; the other is a guess treated as a target, so part of that twelve-point MMLU gap is speculative to begin with.
[O] Fair, but even discounting that, the direction holds on both tasks, and the Quality ceiling is real and still shows a large uplift from assistance.
[S] What about calibration, do people actually know when to trust their own answer?
[G] Mixed. On MMLU, unaided humans and the model alone are reasonably well-calibrated, error under ten. Human-model teams and chain-of-thought prompting are markedly worse, up to eighteen. On Quality it flips: unaided humans calibrate poorly, error of seventeen, teams much better, error of seven.
[S] Small-study noise, or a real pattern? I'd want that replicated before leaning on it.
[G] Fair caveat. Cleaner is the confidence-filtering result: restricting to answers where the weighted vote hit maximum confidence pushes accuracy to eighty-eight percent on Quality, on the eighty-nine questions that qualified, and eighty-one on MMLU's eighty-four. Average confidence itself rose sharply too, fifty-four to eighty percent on MMLU, thirty-eight to seventy-five on Quality.
[O] So that's not just people getting luckier, it tracked real accuracy gains.
[S] One objection that heads off: couldn't participants just be learning the answer key over a hundred questions, since answers were revealed after each one?
[G] The authors checked. Only two of four MMLU annotators and three of four Quality annotators improved from the first half of their work to the second, an average gain of just point seven of a percentage point. Whatever drives the headline numbers, it isn't memorizing the test.
[S] What were people actually doing in these chats? The mechanism matters as much as the number.
[G] A few patterns recur. On MMLU, participants trusted the model's factual recall but distrusted its arithmetic, and several cross-examined it by turning each answer choice into a separate true-or-false question. On Quality, the winning move was asking for an exact quote from the story, then fact-checking that quote against the text directly.
[S] Neat strategies, but both lean on a findable ground truth sitting right there to check against, exactly what real oversight won't hand you.
[O] Let's do the segment this show is built around. I'll make the strongest case for taking this result seriously, Skeptic gets to take it apart, Emmett adjudicates.
[S] Go ahead.
[O] Here's my case. This is the first paper to make scalable oversight measurable, with a large, consistent effect on two different task types. Sixty-six to seventy-five on MMLU, sixty-seven to seventy-seven on Quality individually, sixty-six to seventy-eight and sixty-seven to eighty-six on the aggregate vote, every participant clearing seventy-one percent. Not one lucky number, a real, reproducible mechanism.
[S] I'll grant the mechanism is real, on this task. My problem is what gets carried forward. The paper names six reasons not to over-read these results, and most retellings quote the eighty-six percent and skip the list. Start with the selection effect: removing the two who beat the model unassisted keeps the sandwich valid, but it's also, in the authors' own words, harder to observe cases where assistance fails to help at all. The uplift is measured on a population pre-filtered to need it.
[G] That's the paper's own phrasing, and it's a real tension, not a hypothetical one. My own read, going a step beyond what the paper states, is that it likely means the true population-level uplift is somewhat smaller than what's reported here, not that the effect is fake.
[S] Second, the answer-reveal design. Telling participants the correct answer after every question removes, in the paper's own words, the need to identify when they've developed a method reliable enough to deploy, one of the major points of difficulty in real oversight. This is closer to calibrated trial-and-error with instant feedback than to overseeing a question nobody in the room actually knows the answer to.
[O] That's a real gap between the experiment and the problem it models, I won't argue that one away.
[S] Third, and this is the one I keep coming back to, contamination-adjacent. MMLU and Quality are pre-existing public benchmarks. It's not classic train-test leakage, but the model plausibly saw supervised-style signal for exactly this task format during training, and the authors flag that themselves as their sixth limitation. It's not obvious this stress-tests oversight the way a genuinely novel task would.
[G] All three are limitations the paper names in its own words, not inferences Skeptic is drawing from outside. I'd add a fourth: nothing here is adversarial. The model is unreliable, not actively deceptive. Debate and market-making, the more sophisticated techniques this paper sets up empirical evaluation for, are specifically built for a model trying to mislead its overseers, and that's simply untested here.
[O] Sure, but naming your own failure modes in that much detail is a mark in the paper's favor, not against it. The limitations section here is nearly as long as the results section.
[S] Naming a problem and solving it aren't the same credit. What's shown: a dialog-based technique substantially helps non-experts on two proxy tasks with known answers and a non-adversarial model. What's not shown: whether that survives contact with a genuinely superhuman, potentially deceptive system, the actual problem the paper opens by describing.
[G] If I'm adjudicating, both of you are reading the same paper correctly. The effect Optimist describes is real, and the largest gain, eighty-six versus fifty on Quality, survives every stress test run on it. But Skeptic's list is the paper's own list, and its conclusion never claims more than that sandwiching is viable to study today, not that this technique is validated for future oversight.
[O] I'll take that as the honest read.
[S] Same. More careful than most work that cites it.
[O] Where does this actually touch how people evaluate models today, beyond the safety-research niche it was written for?
[G] Directly, it's foundational to how the field thinks about LLM-as-judge setups and chain-of-thought monitoring, both restatements of the same problem: a judge supervising output it can't fully verify. It also connects to a human-AI-team literature, including a finding from Bansal and colleagues that showing an AI's answer before a human attempts the problem hurts team performance, something these participants seem to have rediscovered on their own.
[S] Worth flagging the contamination point again, since it's what I'd want addressed before trusting this on a newer benchmark: is the uplift real knowledge extraction, or the model recognizing supervised-style answers it's seen before? Nobody has tested that version yet.
[G] Correct, that's an open follow-up, not something this paper claims to have ruled out.
[O] And the roadmap the paper lays out at the end is explicit about wanting exactly that kind of follow-up work, harder tasks, an adversarial model condition, and empirical trials of debate, market-making, and recursive reward modeling, the techniques this experiment was designed to eventually make testable.
[G] If I leave listeners with one sentence, it's that this paper's real contribution is methodological, not the eighty-six percent. It shows sandwiching is a runnable experiment today, and that's what the rest of the field has actually built on.
[O] Mine is that model-assisted non-experts beat both an unaided human and the model alone, on two very different tasks, by a wide and reproducible margin. That's a genuinely hopeful floor to build from.
[S] Mine is to watch the gap between the headline number and the six limitations the authors list themselves, especially the missing adversarial condition. That gap is basically the unsolved research agenda, in the paper's own words.
[O] That's Litsearch Audio for this episode. Full write-up, the results table, and the figures are on the site, go take a look.
[S] Thanks for listening.
[G] Thanks for having me.
