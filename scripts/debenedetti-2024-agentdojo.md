---
slug: debenedetti-2024-agentdojo
title: "AgentDojo: A Dynamic Environment to Evaluate Prompt Injection Attacks and Defenses for LLM Agents"
description: "A deterministic, extensible gym pits tool-using agents against hidden instructions in their own data — and finds the most capable models are the easiest ones to knock off course."
date: 2026-07-19
guest_name: "Lucius"
guest_voice: "am_fenrir"
---
[S] Here's a problem every security benchmark runs into eventually: if your grader is itself a language model, and the thing you're testing is designed to hijack language models, how do you know your grader wasn't just hijacked too?
[O] Which is exactly why the paper we're covering today refused to use a language model as the judge at all.
[S] And here's the twist that should worry anyone shipping an agent: across ten frontier and open models, the ones that were best at getting the job done were also the easiest to knock off course.
[O] Not because they were more gullible. Because they were competent enough to actually carry out a malicious multi-step plan once the door was open.
[S] Being good at your job, it turns out, is also being good at someone else's job, if that someone else hijacks you first.
[O] Welcome to Litsearch Audio. Today's paper is AgentDojo, A Dynamic Environment to Evaluate Prompt Injection Attacks and Defenses for LLM Agents, from Edoardo Debenedetti, Jie Zhang, Mislav Balunovic, Luca Beurer-Kellner, Marc Fischer, and Florian Tramer, out of ETH Zurich and Invariant Labs, published at NeurIPS twenty twenty four in the Datasets and Benchmarks track.
[O] Joining us to dig into it is Lucius, a researcher who's spent real time inside this benchmark. Welcome, Lucius.
[G] Glad to be here. Usual disclaimer up front: I'm not one of the authors, so when I say "the authors show," I mean I've read the paper closely, not that I wrote it.
[S] Good, we'll hold you to that. Give us the one-sentence version. Why does the field need a whole dedicated environment for this?
[G] Because before AgentDojo, nobody could tell you, reproducibly, whether a given agent both does its job and resists a hidden instruction planted in the data it reads. Those two things had never been measured together.
[O] Let's set the scene. What's the actual vulnerability, at the mechanism level?
[G] An LLM agent reads tool outputs, an email, a webpage, a bank statement, as plain text. There's no formal boundary between "this is an instruction" and "this is just data to summarize." The model reads both the same way.
[S] So if an attacker gets any text into that data stream, they can potentially write instructions the model treats as legitimate.
[G] That's indirect prompt injection, and by twenty twenty four it was well documented as a threat — what was missing was rigorous measurement. The closest prior benchmark, InjecAgent, just feeds a model one adversarial tool output and checks the reaction, without ever asking it to plan and finish a real multi-step task under attack.
[S] And on the other side, you had capable agent benchmarks with no attacks in them at all.
[G] Exactly. WebArena, AgentBench, the Berkeley leaderboard, they all measure whether an agent finishes a task, nothing adversarial in the environment. ToolEmu is closer, more agentic, but it scores utility with an LLM judge — which brings us back to my opening line. If your evaluator is a language model, and the environment contains text engineered to hijack language models, the judge becomes a liability, not a safeguard.
[S] So the brief was: realistic and multi-step, scored without an LLM in the loop, and not stale the day a new attack shows up.
[G] Close to the paper's own three design goals — realistic and stateful, deterministically scored, and dynamic rather than a frozen set of prompts.
[O] Walk us through what it actually looks like when you open it up.
[G] Four simulated environments: a workspace with email, calendar, and cloud drive; a Slack-style messaging workspace; a travel booking assistant; and a banking assistant. Each keeps a mutable state object, with its own tools the agent can call.
[S] How big is "a set of tools," concretely?
[G] The first release ships seventy tools across those four environments, with ninety-seven realistic user tasks built on top of them. Things like summarizing a set of emails, or booking a hotel under a budget.
[O] And the security side?
[G] Twenty-seven injection tasks. Each is an attacker goal, described only at the level of a category, things like exfiltrating data or an unauthorized transaction, paired with a hidden check that inspects the environment state to see whether that goal actually happened.
[S] So a user task and an injection task get graded the same way, structurally.
[G] Same pattern. A user task pairs a plain-language instruction with a function called utility, checking the model's output and the environment state before and after the run, true or false. An injection task pairs an attacker goal with a matching function called security — same idea, deterministic, no LLM anywhere in the grading.
[O] That's the part I keep coming back to. No judge model in the scoring path.
[G] Deliberately so. The environment's state has designated spots where injected content can be inserted, inside a tool's returned data, never anywhere the user directly controls.
[S] And the six hundred twenty-nine number in the abstract, where's that from?
[G] It's a cross product. Roughly one user task times one relevant injection task, per environment, summed across all four environments, gives six hundred twenty-nine distinct security test cases.
[O] You said the framework itself is dynamic. What does that mean in practice?
[G] Both attacks and defenses are pluggable. An attack is a function that takes an injection goal and returns text for that environment's injection points. The paper's strongest baseline frames the malicious instruction as a higher-priority message addressed directly to the agent — I'll stay at that level of description rather than exact wording — and it clearly outperforms the older, more generic phrasings the authors also test.
[S] And the defenses on the other side?
[G] Four families. Delimiting the untrusted text, telling the model anything inside those markers is data, not instructions. A classifier that scans each tool output for injection patterns and aborts the run if it fires. Repeating the user instruction after every tool call, so it stays salient. And a tool filter, where the agent commits to the tools it needs before it's seen any untrusted data. That last one turns out to be the standout defense in the results, though it has a very specific failure mode we should get to.
[S] Save it. One more mechanism question first. How do you measure "did the agent complete the job" without an LLM judge, for something as open-ended as booking a hotel?
[G] Every user task ships a ground-truth sequence of tool calls that would solve it, and the utility check inspects the resulting state directly — was the hotel actually booked, does the calendar have the new event, rather than grading the model's prose about what it claims it did.
[O] Okay, numbers time. Who did they actually test?
[G] Ten models. GPT-3.5 Turbo, GPT-4 Turbo, GPT-4o, Claude 3 Sonnet, Claude 3 Opus, Claude 3.5 Sonnet, Gemini 1.5 Flash and Pro, Llama 3 70B, and Command R Plus.
[S] Start with the boring but important number. Can these things even do the job with nobody attacking them?
[G] Not reliably. The best models solve under 66 percent of the user tasks with zero attack present — actually harder than the Berkeley function-calling leaderboard, so this isn't an easy testbed even before security enters the picture. Hold onto that number, it matters later. Under the paper's strongest generic attack, the best agents still get hijacked in under 25 percent of cases. Add a prompt-injection detector on top, and that drops to around 8 percent.
[O] Those actually sound like decent numbers for a young field.
[G] They read well in isolation. But here's the finding that got the most attention: capability and vulnerability move together, and the authors call it a form of inverse scaling.
[S] Walk me through the mechanism, because on the surface that's a strange result.
[G] A weak model can fail to execute the attacker's plan even after the injection lands, simply because it can't reliably chain the tool calls needed to pull it off. Its low attack-success rate is incompetence, not robustness. A stronger model completes multi-step plans reliably, including the attacker's, once steered onto it.
[O] So "safe" and "just bad at the task" are getting mixed together in that raw number.
[G] That's exactly the tension, and we'll come back to it in the debate, because it cuts both ways in how you read the whole benchmark.
[S] Who came out on top overall?
[G] Claude 3.5 Sonnet had the best benign utility, GPT-4o close behind, and also the best utility-security trade-off. But no model was both highly useful and robust — most lose 10 to 25 percent of absolute utility just from operating in an adversarial environment, attack success aside. That's partly a denial-of-service effect: the agent gets distracted by the injected content even when it doesn't fully take the bait.
[S] Did difficulty vary a lot by environment?
[G] Enormously. The Slack suite hit a 92 percent attack success rate, since the attacker controls a large share of what the agent reads there, like web pages it's asked to browse. One travel-booking injection task, at the other extreme, succeeded zero times — it required two unrelated malicious actions in the same run, and models could usually manage only one.
[O] Now the part I wanted to ask about. Does attack phrasing really move the number that much?
[G] A lot. The paper compares several phrasings, including a well-known "ignore previous instructions" style, against their strongest one, and the strongest clearly wins. An adaptive version that just picks whichever phrasing works best per task adds roughly another 10 points on top.
[S] And does knowing more about the target actually help the attacker?
[G] Surprisingly little. Correctly naming both the real user and the real model only lifted targeted attack success from forty-five point eight percent to forty-seven point seven percent. But guessing wrong was expensive — the wrong user dropped it to twenty-three point two percent, the wrong model to twenty-three point seven percent. A bad guess costs roughly twenty-two points; a correct guess barely helps.
[S] Now the defenses. You said the tool filter was the standout.
[G] It cuts targeted attack success down to seven point five percent, the best result in the paper. The logic: if the user's task only needs read access, like reading emails, and the attacker's goal needs write access, like sending one, locking the toolset in advance blocks the attack outright.
[G] It does have two failure modes, though. It fails when the tools needed to solve the task can't be decided up front, because a later tool call determines what's needed next. And it fails outright when the tools required for the legitimate task are also sufficient to carry out the attack, true for 17 percent of the test cases.
[S] What about the other defenses?
[G] The injection detector also lands near 8 percent, but its false positives noticeably hurt benign utility. Repeating the user's instruction after every tool call helps against this specific attack, but the authors say directly it's unlikely to hold up against an attacker adapting to that defense. Several of the cheap defenses actually raised benign utility slightly, apparently just by keeping the original instruction more salient.
[O] But nothing gets you both full utility and full security.
[G] No. Every defense still loses 15 to 20 percent of utility once it's actually under attack. No free lunch on this leaderboard yet.
[O] Okay, my turn to make the strongest case for this paper. Before AgentDojo, prompt injection research was a pile of one-off demos. This gives the field one shared, reproducible yardstick, and a genuinely important empirical finding nobody predicted going in, the inverse scaling result. That alone reshapes how you think about deploying your most capable model as an autonomous agent.
[S] I'll grant the yardstick. I don't grant that the numbers on it mean what they look like. Every attack here is generic and non-adaptive, hand-written prompts, not something optimized against a specific defense, the way adversarial robustness gets evaluated elsewhere, with attacks that explicitly search for whatever breaks the defense in front of them.
[G] Fair, and that's the paper's own framing. The authors say explicitly their repeat-prompt defense is unlikely to withstand an adaptive attacker. So "8 percent with a detector" is what a fixed, public attack achieves, not a ceiling on what a motivated one could do.
[O] Sure, but that's true of basically every new benchmark on day one. Somebody has to publish the first floor before anyone can push against it.
[S] Agreed, that's a fine reason for the benchmark to exist. It's not a fine reason to read "defenses get attack success into single digits" as good news about deployed systems.
[G] I'd score that mostly to the skeptic's side — the paper is careful about the distinction, but a fixed, non-adaptive attack suite as your only attacker model is a real limitation, not just a footnote.
[O] Fine. Let me push on inverse scaling instead, because I think that one's real regardless of the adaptive-attack question.
[S] I want to complicate that too. Targeted attack success isn't conditioned on whether the model could do the benign task at all — part of "weak models are safer" may just be "weak models fail at everything." That's not the same as robustness.
[G] That's precisely the entanglement worth flagging. Benign utility sits under 66 percent even for the best models, and attack success is measured over the full set of cases, not the subset a model could actually solve. The paper doesn't report that conditional number, so you can't cleanly separate "resisted the injection" from "would have failed regardless."
[O] Okay, that lands. I still think the qualitative direction, more capable equals more attackable, holds up even with that caveat. A model has to be competent to execute a multi-step attacker plan at all.
[S] I agree with that much. I just don't fully trust the size of the gap between models until someone reports it conditioned on task success.
[S] One more thing. The environments are synthetic and single-session — four office-style domains, text only, no persistent multi-task context where an injection could sit and wait across turns. Real deployments increasingly look like exactly that.
[G] The authors are upfront about the scope, and they flag the multi-session gap themselves, specifically that a defense like the tool filter assumes the attacker's goal and the user's task never need the same tools inside one bounded run. That assumption gets shakier the longer an agent's context lives.
[O] There's also a dual-use question the authors address directly in their own broader-impact section — they acknowledge a benchmark like this could help someone prototype new injections, and conclude the benefit of a shared, public, defensive tool outweighs that risk.
[S] The right call, in my view, but worth naming rather than skipping past. An open benchmark is a defensive good precisely because it lets defenders iterate faster than any single team could alone.
[G] One more limitation, named honestly in the paper: the dummy data was partly generated with the very model families under test, though manually inspected — a plausible small thumb on the scale for those families.
[O] Stepping back, why should someone who cares about evaluation broadly, not just agent security, pay attention to this paper?
[G] Because it's a clean example of getting a security eval's scoring right — deterministic, state-based checks instead of a model grading a model, on a task specifically designed to fool language models. That principle generalizes well beyond prompt injection.
[S] It's also a useful template for reporting a trade-off honestly. Utility and security plotted against each other, not one headline number pretending the other axis doesn't exist.
[O] And being extensible rather than frozen matters here in a way it wouldn't for a static leaderboard. A security benchmark that can't absorb new attacks goes stale within a year.
[G] The paper frames itself exactly that way, a live environment rather than a fixed test set, because static security benchmarks elsewhere go stale fast.
[S] Whether the field actually kept using it that way, adding real adaptive attacks over time, is outside what this paper itself can tell us.
[G] Correct. That's beyond what's in the text in front of me.
[G] If there's one sentence to take away, it's this: AgentDojo showed that today's best agents aren't just occasionally trickable, they're systematically more trickable the more capable they are, and no cheap defense fully closes that gap yet.
[O] Mine is that the tool filter result is the most actionable thing here for anyone building agents right now. Lock in your toolset before the untrusted data arrives, and you buy real protection for free in a lot of realistic cases.
[S] And mine is a caution: every attack-success number in security research is a floor set by however hard people tried to break it that year, not a ceiling. Read this one, and the ones that will inevitably follow it, that way.
[O] Full paper, our writeup, and every figure we mentioned are up on the litsearch site. Thanks for joining us, Lucius.
[G] Thanks for having me.
