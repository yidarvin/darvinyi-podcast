---
slug: dellacqua-2023-jagged-frontier
title: "Navigating the Jagged Technological Frontier"
description: "Seven hundred fifty eight Boston Consulting Group consultants were randomly given GPT-4 on real consulting work: inside the model's sweet spot, quality jumped more than forty percent, with the biggest gains going to the weakest performers; on a task built to sit outside it, correct answers fell from eighty four point five percent to as low as sixty. Our hosts fight over whether the resulting jagged frontier is a durable map of AI's limits or a stress test that proved exactly what it was built to prove."
date: 2026-07-19
guest_name: "Daniel"
guest_voice: "am_fenrir"
---
[O] Picture this: the exact same tool, the exact same consultants, two completely opposite verdicts depending on which task you hand them.
[S] On one task, GPT-4 makes people faster, more complete, and forty percent higher quality. On another, it drags accuracy from eighty four and a half percent down into the sixties.
[O] And nobody could see that line coming. Not the consultants, not the researchers going in.
[S] Which is why the honest headline is not "AI helps knowledge work." It is "AI helps knowledge work until it does not, and you often cannot tell which situation you are in until you are already wrong."
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take apart one paper at a time. I am the optimist.
[S] I am the skeptic, and this one gave me a great deal to work with.
[O] Today's paper is Navigating the Jagged Technological Frontier, by Fabrizio Dell'Acqua, Edward McFowland the third, Ethan Mollick, and six colleagues from Harvard and Boston Consulting Group. It circulated as a Harvard working paper in twenty twenty three and has since been published in Organization Science. Joining us is Daniel, who knows this study closely. Daniel, welcome.
[G] Thanks for having me. This is one of the more ambitious field experiments I have seen on how AI changes what a skilled professional produces, run inside a real consultancy instead of a lab.
[S] Why did this need a real consultancy at all, Daniel? Why not another lab study?
[G] By the spring of twenty twenty three, there was decent evidence that language models sped up narrow, well defined tasks: Peng and colleagues on Copilot, Noy and Zhang on writing. Missing was evidence on a full, realistic workflow done by elite professionals, where some parts of the job suit a language model and other parts do not.
[O] Which matters, because most of us do not do one narrow task all day. We do a messy bundle of them.
[G] Exactly, and prior debates about AI and expertise were mostly fought in the abstract, or on older, narrower machine learning making discrete predictions from structured data, not on a general purpose model that will attempt almost anything you ask it, well or badly, with no warning label attached.
[S] No warning label is the phrase that matters to me. If the model does not announce when it is out of its depth, a confident wrong answer looks identical to a confident right one.
[G] That is the premise the whole paper is built on. They call it a jagged technological frontier: AI capability does not form a clean line separating what is hard for humans from what is easy for AI. Two tasks that look equally hard to a professional can sit on opposite sides of what the model can actually do well, invisibly.
[O] So the real question is not "is AI good or bad for knowledge work." It is "what happens when skilled people cannot see the line."
[G] Right, and testing that seriously required a task realistic enough that getting it wrong would actually look like getting it wrong. That is why they partnered with an actual consultancy instead of crowdworkers or students.
[S] Walk through the design, because a lot rides on how tightly this was controlled.
[G] Genuinely tight. BCG and the academic team ran two pre-registered, randomized field experiments, registered before any data was collected and IRB approved, with seven hundred fifty eight consultants, about seven percent of BCG's global cohort at that level, volunteers whose performance was tied to their annual review.
[O] Real stakes, not a survey people click through for a gift card.
[G] Everyone first completed a baseline task without AI, giving a within-subject skill measure. People were then randomly assigned to no AI, GPT-4 only, or GPT-4 plus a short prompt engineering overview, all on the identical GPT-4 snapshot as it existed at the end of April twenty twenty three.
[S] Same model, same access, so any difference is about training and prompting, not about who got a better tool.
[G] Exactly. The sample then splits in two. Three hundred eighty five consultants got the inside the frontier task: a creative product innovation exercise, invent a footwear concept for a niche market, built with an executive from a real footwear company, broken into eighteen subtasks spanning creativity, analysis, writing, and persuasiveness.
[O] Graded how? Self-reported quality on a creative task would be worthless.
[G] Two human graders scored every response, BCG staff or top program MBA students, and GPT-4 independently scored the same responses too, so you get a human read and a model read on the same output.
[S] Now the other half, the one I want to spend time on.
[G] Three hundred seventy three consultants got the outside-the-frontier experiment, deliberately built to be hard for GPT-4: a business case with channel and brand data plus interview transcripts, where the correct recommendation depends on subtle details buried in the interviews, not the headline numbers. It is a task type BCG uses to screen job candidates.
[O] So it is not a toy trap. It is a real signal BCG already trusts.
[G] Right, and the authors are upfront about how they got there. Their own words: they iterated to, quote, design a task where consultants would excel, but AI would struggle without extensive guidance.
[S] I want to flag that sentence, because we are coming back to it hard later. That is the authors telling you, in their own methods section, this task was built to make the model fail.
[G] It was. It is a legitimate way to prove the frontier exists somewhere. It is also, by construction, not a random sample of a consultant's Tuesday.
[O] Give me the numbers. Inside the frontier first, because I think this part gets undersold.
[G] Every AI condition beat control on every outcome. Task completion rose from eighty two percent in control to about ninety three with the overview and ninety one without, a twelve point two percent average increase. AI users were also faster, over twenty two percent quicker with the overview and nearly twenty eight percent quicker without it.
[S] Faster and more complete I believe easily. Quality is the number I trust less by default.
[G] Fair, but it holds on two measures. Human graders gave the overview group forty two and a half percent higher scores than control, and the GPT-4-only group thirty eight percent higher. GPT-4 grading the same responses found the same direction, a smaller but real gain, roughly seventeen to nineteen percent.
[O] Two different graders, human and machine, telling the same story. That is what makes me trust it.
[G] There is a heterogeneity result here I think is the most important sentence in the paper. Splitting by pre-task assessment score, bottom-half performers improved forty three percent versus their own baseline. Top-half performers improved seventeen percent.
[S] So it is not just "AI makes strong people stronger." It is compressing the gap.
[G] That matches what Noy and Zhang, and separately Choi and Schwarcz, found elsewhere. There is a less flattering finding too: a semantic similarity analysis found AI-assisted responses were more similar to each other than non-AI responses were. Individual quality went up. Variety across the group went down.
[O] A real cost, even inside the part of the frontier where AI is unambiguously helping.
[S] Now flip to the task built to break it.
[G] The pattern fully reverses. Control answered correctly eighty four point five percent of the time. The AI-assisted groups scored sixty percent with the overview and seventy point six without it, roughly a nineteen point average drop, and the group with more AI training dropped further, twenty four points, than the group with less, thirteen.
[O] More training on the tool made the outcome worse?
[G] On this task, yes, and it gets sharper. AI-assisted consultants were also faster here, thirty percent less time with the overview, eighteen percent less without it. They were not struggling and slowing down. They were moving briskly toward the wrong answer.
[S] That is the sentence that should worry anyone deploying this at work. Confidently wrong, and fast about it.
[G] One more twist. A separate quality rubric, independent of correctness, still rose for AI users whether they landed the right answer, a twenty one percent rise, or the wrong one, eighteen percent. AI-assisted write-ups simply read as more polished, right or wrong.
[O] So the advice itself could be wrong and still look more convincing on the page.
[G] Right, and the authors describe two patterns among people who handled this task well: Centaurs, who cleanly divide labor with the model, and Cyborgs, who interleave their work with it line by line. That typology is qualitative, drawn from interviews and session logs, not a headline number.
[O] Let me make the strongest case here. This is a rigorous field experiment, pre-registered, IRB approved, randomized inside an elite population doing real work, with a within-subject baseline that actually tests the leveling claim. The headline for me: the people who benefit most are the ones currently struggling most. A democratizing story, not just a productivity one.
[S] I will grant the design is unusually strong. But the number everyone quotes from the other experiment is, I think, the least generalizable part of the paper. The authors iterated until they found a task AI would struggle with, so that drop is not a random draw from real work, it is a stress test built to fail. Treating it as a general accuracy tax is not what the data supports.
[G] Exactly right, and worth being precise about what survives it. The durable claim is not a specific accuracy penalty, it is that the jagged boundary exists at all and is invisible to the person standing on it. The engineered task is strong evidence for the boundary existing, weak evidence for its exact size in the wild.
[O] Fair split, and I will take it. The existence claim is the one that changed how people talk about this. Jagged frontier is basically industry shorthand now.
[S] Second point, and this bothers me more. BCG is a co-author, three of nine authors, including people from its own Henderson Institute, and it supplied the tasks, the graders, and the subjects. That is a tighter industry partnership than an arm's length replication would be.
[G] Worth stating both sides. The pre-registration and design were led by the academic team, across Harvard, Wharton, MIT, and Warwick. And BCG's incentive is not obviously one directional, a splashy result is good marketing either way the data lands, so the conflict is plausible, not a smoking gun.
[O] The outside-the-frontier result also cuts against a simple hire-us-to-roll-it-out narrative. That is an odd result to publish if BCG were purely optimizing for flattery.
[S] Or it is exactly the nuance that makes the flattering half more credible by contrast. Not disqualifying, but a reason to want independent replication before treating the magnitudes as settled.
[G] Agreed on wanting replication regardless of how you read the incentives.
[S] Third point, the sharpest one. Quality scores rose for AI-assisted work whether the answer was right or wrong, and the paper never disentangles whether that is AI making wrong answers more persuasive, or graders rewarding fluent prose over substance, which matters for any organization using "reads like a good memo" as a proxy for a good decision.
[G] Correct, that is a real gap and it cuts against the authors' own framing too. If graders partly reward fluency, the outside-the-frontier story is partly about a measurement weakness on the human side, not just task difficulty.
[O] Which, to be fair, is a human failure mode, not an AI-specific one. People have always been swayed by well-written bad advice.
[S] Sure, but AI is what is now generating the well-written version at scale for everyone. Last point: the appendix reports that the single most common retainment score, near word-for-word copy-paste of GPT-4's output, sits at point eight seven. Not the average. The mode.
[O] That is a lot of pasting.
[S] It is, and it sits awkwardly next to the Centaurs-and-Cyborgs, thoughtful-collaboration framing. That typology may describe a minority of careful users sitting on top of a much larger group that mostly copied the output straight through.
[G] Fair tension. The typology is grounded in real session data but is explicitly qualitative, while the retainment number is quantitative and suggests it may not describe the median user. A lot of the raw gains inside the frontier may still be coming from people who mostly accepted what GPT-4 wrote.
[O] Which, if anything, makes the inside-the-frontier gains more impressive to me. Even a lot of copy-paste use still produced a forty two percent quality jump over control's own from-scratch work.
[S] Or it means the control baseline was mediocre and GPT-4's median output cleared it easily on this exercise. I do not think the paper lets us fully separate those two stories.
[G] Neither can I, honestly, and that is a fine place to land. It is a real open question the paper raises but does not close.
[O] So what actually changes for how people work?
[G] The practical message is close to the Centaur and Cyborg framing itself: either cleanly hand off tasks you already know are inside the model's strengths, or work interleaved with it closely enough to catch it the moment it drifts. The bad mode is treating it as uniformly reliable across your whole workflow.
[S] A genuinely hard skill to teach, since the entire premise here is that the boundary is invisible. You cannot know when to check the AI's work if you cannot see where the frontier sits on a given day.
[G] That is the honest tension the paper leaves open. It demonstrates the jaggedness convincingly. It does not hand you a way to detect which side of the line you are on in real time.
[O] There is a broader evaluation lesson too. The outside-the-frontier task is basically an adversarially constructed eval, built by people who already knew what would break the model, the same critique you would apply to any benchmark hand-crafted to make a system fail.
[S] Right, a demonstration case and a random sample of real-world difficulty are two different things, and conflating them is a mistake this field makes constantly.
[G] The flip side matters too: the inside-the-frontier task was also chosen by the researchers, not sampled randomly. Both halves of this paper are demonstration cases. Fine for proving the frontier is jagged, weaker for predicting how your own organization's task mix will land.
[O] So do not read the sixty-to-ninety-three range as "this is what AI does to my job." Read it as "the gap between AI's best and worst performance, on tasks that look similarly hard, can be enormous."
[S] Agreed, and given an April twenty twenty three snapshot, whatever this frontier looked like then has almost certainly moved by now. The paper's own thesis says the frontier keeps shifting, which is a reason to treat this as a method demonstration more than a permanent scorecard.
[G] The paper's own takeaway, in one line: AI can be a genuine booster on some tasks and a genuine disruptor on others, and skilled professionals often cannot tell which one they are facing until after they have acted.
[O] Mine: the leveling effect is what I will keep coming back to. Forty three percent gains for the people who needed it most, on a real test, inside a real company. That is the kind of result that should shape how organizations roll this out.
[S] Mine: respect the design, doubt the magnitudes. This is one of the most rigorous field experiments on AI and expert work out there, and its most quoted number, the drop from eighty four and a half to sixty percent, comes from a task built specifically to produce it. For the figures and the full writeup, head to the Litsearch site. Daniel, thank you.
[G] Thank you both, this was a great one to dig back into.
