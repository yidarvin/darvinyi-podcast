---
slug: wang-2023-voyager
title: "Voyager: An Open-Ended Embodied Agent with Large Language Models"
description: "A frozen GPT-4 writes its own Minecraft curriculum, hoards reusable code skills, and grades its own homework, becoming the only agent in its comparison to ever mine a diamond, though only once in three tries."
date: 2026-07-19
guest_name: "Theo"
guest_voice: "bm_george"
---
[O] Picture a game character that never stops improving, no save-scumming, no retraining, no human handing it a walkthrough. Years of Minecraft player wisdom, condensed into an afternoon of prompting a frozen GPT-4.
[S] Or picture a language model that has almost certainly read the Minecraft wiki cover to cover, given itself a task, and then graded its own homework on whether it finished.
[O] Both are true, and that's exactly why this paper is fun to argue about. It's the only agent in its comparison that ever mines a diamond.
[S] In one of three tries. With error bars wide enough to drive a minecart through.
[O] Welcome to Litsearch Audio, where an optimist and a skeptic argue about a paper until someone who actually knows it settles the score.
[S] Today's paper is Voyager, An Open-Ended Embodied Agent with Large Language Models, from Guanzhi Wang and colleagues at NVIDIA, Caltech, U T Austin, Stanford, and U W Madison, posted in May twenty twenty-three and published in Transactions on Machine Learning Research.
[O] Joining us is Theo, who's spent real time inside this paper's prompts and its skill library. Welcome, Theo.
[G] Glad to be here. One disclosure up front: I'm not one of the eight authors, so when I say "they show" or "the paper argues," that's the paper talking, not me.
[S] Theo, set the scene. What's broken that this paper is trying to fix?
[G] Two traditions, both stuck. Classical embodied agents learn from reinforcement or imitation learning over raw, primitive actions, which is sample-hungry, hard to interpret, and brittle. Then came the LLM-agent wave, ReAct, Reflexion, AutoGPT, injecting real world knowledge through prompting, but they're short-horizon: reason and act inside one episode, then forget everything when it ends.
[O] Neither one is actually a lifelong learner.
[G] Right, and the authors are explicit about what a lifelong learner should look like, using human Minecraft players as the model. Propose a task that fits your current skill level, so you harvest sand and cactus in a desert instead of chasing iron you don't have the tools for. Refine a skill from feedback and bank it for later, the way fighting a zombie transfers to fighting a spider. And keep exploring under your own steam, without someone handing you the next goal.
[S] Why Minecraft specifically, and not, say, a robot arm?
[G] No fixed storyline, no scripted ending, just a procedurally generated world and a tech tree, wood to stone to iron to diamond, rewarding exactly the compositional, long-horizon skill-building they're after. It's also cheap to run thousands of times, which you can't say about a real robot.
[O] Walk us through the architecture. Three pieces, right?
[G] Three, and one load-bearing decision underneath all of them: the action space is code, not joystick commands. GPT-4 writes JavaScript against a control interface called Mineflayer, not raw keypresses.
[S] Why code specifically?
[G] Because programs are naturally temporally extended and compositional. A function can call another function. That single property is what lets skills compound instead of just piling up side by side.
[O] Start with the curriculum, since that decides what the agent even tries next.
[G] GPT-4 looks at the agent's live state, inventory, biome, health, hunger, what's already been completed or failed, and proposes the next task under one standing directive: discover as many diverse things as possible. The authors call it an in-context form of novelty search. It runs at a small nonzero temperature, point one, specifically to keep proposals from getting repetitive.
[S] So there's no fixed lesson plan. GPT-4 is inventing the syllabus on the fly, from a paragraph of instructions.
[G] Correct, and that's a genuinely different design from the manually scripted curricula earlier Minecraft agents used, which need a human expert to write good progressions and can't adapt to where the agent actually stands in the world.
[O] Then the skill library, which I think is the cleverest piece.
[G] Every time a task succeeds, the code that solved it gets committed to an external library, indexed by embedding rather than by name. GPT-3.5 writes a short natural-language description of what the program does, that description gets embedded with OpenAI's ada-002 embedding model, and that embedding is the key. The program itself is the value.
[S] And retrieval?
[G] For a new task, GPT-3.5 first drafts a general suggestion for solving it, that suggestion plus environment feedback becomes the query, and the system pulls the top five most similar skills by embedding distance into the prompt. They measured that retrieval directly: across three hundred nine held-out samples, top-one accuracy is eighty point two percent, and by the top five, it's ninety-six point five percent.
[O] That's a real, measured number, not a vibe. I like that.
[S] It's a solid retrieval benchmark, sure. It's also a much easier problem than "did the agent actually get better at Minecraft," so let's not let it stand in for the harder question.
[G] Fair, it only tells you the memory system finds the right skill, not that the skill was worth having, we'll get to that. What matters architecturally is that this memory lives outside the model weights entirely, so there's no catastrophic forgetting the way a fine-tuned continual-learning setup would worry about.
[O] And new skills can literally call old skills.
[G] Exactly. Craft a stone pickaxe becomes a building block inside craft a furnace, which becomes a building block inside smelt an iron ingot. That's the compounding the paper is betting on.
[S] What about the third piece, the iterative prompting?
[G] Three feedback signals get folded back into the prompt on every retry. Environment feedback, plain text like "I cannot make an iron chestplate because I need seven more iron ingots." Execution errors, the raw JavaScript stack trace when generated code is simply invalid. And self-verification, a separate GPT-4 call acting as a critic, given the agent's current state and the task, returning success or failure plus, on a failure, a critique like "find and mine an amethyst shard underground."
[O] So GPT-4 checks GPT-4's homework.
[S] Say that again, slower, because that's going to matter a lot in a few minutes.
[G] It is a second, separately prompted GPT-4 call, checking whether the first GPT-4 call's code actually accomplished the stated task. If the agent is still stuck after four rounds of code generation, the system gives up on that attempt and just asks the curriculum for a different task instead.
[O] Give us the headline numbers before we start litigating them.
[G] With GPT-4, Voyager discovers sixty-three unique items across one hundred sixty prompting iterations, three point three times more than the best comparison, and travels two point three times farther across the map. On the tech tree it clears the wooden tier fifteen point three times faster, stone eight point five times faster, iron six point four times faster, and it's the only method in the paper that ever reaches the diamond tier, at one hundred two iterations, in one of three runs.
[S] Give me the actual table, not just the multiples.
[G] ReAct and Reflexion never unlock a single tier, zero out of three runs, every tier. AutoGPT does clear wood, stone, and iron in all three runs, but slowly: ninety-two plus or minus seventy-two iterations for wood, ninety-four plus or minus seventy-two for stone, one hundred thirty-five plus or minus one hundred three for iron, and it never touches diamond. Voyager clears wood in six plus or minus two, stone in eleven plus or minus two, iron in twenty-one plus or minus seven.
[O] And there's a version without the skill library, right, the cleanest ablation in the paper?
[G] Right. Voyager without the skill library gets wood in seven plus or minus two, stone in nine plus or minus four, iron in twenty-nine plus or minus eleven, and it also never reaches diamond.
[S] Hold on, replay stone for me. Nine for the version without the library, versus eleven for the full system?
[G] Correctly heard. On that one tier, dropping the skill library is numerically faster, though well within each other's error bars.
[O] Okay, that's worth sitting with for a second, we'll come back to it.
[G] There's also a zero-shot test: clear the inventory, drop the agent into a brand-new world, unseen tasks, fifty-iteration budget. Voyager solves all four target items, a diamond pickaxe, a golden sword, a lava bucket, a compass, in nineteen plus or minus three, eighteen plus or minus seven, twenty-one plus or minus five, and eighteen plus or minus two iterations. Every baseline, including Voyager without its skill library, is slower and less reliable there, and ReAct, Reflexion, and plain AutoGPT solve exactly zero of those four tasks.
[O] And here's a detail I love: they bolted the skill library onto AutoGPT itself.
[G] They did, and it helped. AutoGPT with Voyager's skill library goes from solving nothing to solving the diamond pickaxe, the golden sword, and the compass in some of its runs. The authors call that plug-and-play evidence that the library is a genuinely portable asset, not just a Voyager-specific trick.
[S] That's a legitimately interesting result. I'll give them that one for free.
[G] Then three ablations the authors call decisive. Swap the automatic curriculum for a random one, and discovered items drop ninety-three percent. Remove self-verification specifically, and items drop seventy-three percent, the single most damaging removal they tested. Swap GPT-4 for GPT-3.5 in code generation, and you get five point seven times fewer unique items.
[O] So if I had to bet on which piece matters most, it's the curriculum and self-verification, with the skill library earning its keep more gradually.
[G] That's a fair reading of the ablation chart, yes.
[O] Alright, my turn to make the case. This is a genuinely elegant blueprint: zero gradient updates, a frozen model, and it's the only agent here that ever sees a diamond. Code as the action space is the real insight, it's why skills compound, and the plug-and-play result on AutoGPT is independent evidence the library generalizes beyond Voyager itself.
[S] My case: the multipliers are doing a lot of marketing for a very small, very noisy experiment. Ninety-two plus or minus seventy-two isn't a number, it's a shrug with a mean attached. The diamond result, the one everyone quotes, happened in exactly one of three runs. The other two just failed.
[G] Both of those are accurate readings of Table one. Every cell in it is an average of three runs, and yes, the diamond tier is one success out of three attempts.
[S] Second point: ReAct and Reflexion were built for text and web tasks, not an embodied three-D game. Losing zero out of three isn't evidence Voyager's architecture is uniquely good, it's evidence those two agents were never designed for this at all.
[O] I'll grant that reading. AutoGPT is the more informative baseline, since it was at least re-implemented with the agent's own state, feedback, and errors as input.
[G] Correct, and even against that stronger baseline, Voyager wins by a wide margin on wood, stone, and iron, and is the only one to ever reach diamond, so the gap doesn't vanish, it just narrows to something more defensible than fifteen times.
[S] Third point, and this is the one I actually think matters most: the fair ablation isn't Voyager versus AutoGPT, it's Voyager versus Voyager without its own skill library. On the earliest, easiest tiers that gap is tiny, six versus seven on wood, and on stone the ablated version is literally faster, nine versus eleven.
[O] But it's not tiny everywhere. Iron is twenty-one versus twenty-nine, that's a real gap, and the skill library is the only configuration that ever reaches diamond at all.
[G] That's the honest shape of the result. The skill library barely matters on the first two tiers and matters a great deal on harder, longer-horizon tasks and in the zero-shot transfer test, where it roughly halves the iteration count on the diamond pickaxe.
[S] So "the skill library is what makes Voyager work" is true later in the curve and basically not true at the start.
[G] That's a more precise claim than the paper's own headline framing gives you, but I think it's the correct one.
[S] Fourth point, and Theo, I want you to referee this one directly. GPT-4 almost certainly has the Minecraft wiki memorized, recipes, the whole tech tree, it's exhaustively documented online. How much of "open-ended discovery" is really just recall?
[G] The paper doesn't run a decontamination test, so I can't give you a number, but the authors' own failure cases cut both ways here. The curriculum at one point proposes crafting a "copper sword," which doesn't exist in the game, and GPT-4 at another point tries to use cobblestone as furnace fuel, which is invalid. So the knowledge is clearly baked in, but it's also demonstrably imperfect, not a lookup table.
[O] Imperfect recall is still recall. I don't think that fully lets them off the hook.
[G] Agreed, it's a real caveat the paper doesn't address head-on, and I'd flag it as the biggest open question the writeup leaves unanswered.
[S] Last point: self-verification is both a core component of the method and the thing deciding whether a run counts as a success. GPT-4 grading GPT-4. The appendix even admits a specific miss, it once failed to recognize spider string in the inventory as proof the agent had actually beaten a spider.
[G] All true, and it matters because self-verification is also the ablation with the single biggest effect, minus seventy-three percent when you remove it. The component doing the most work in the results is also the one grading itself. The tier counts and item totals are objective game-state checks the authors can verify externally, but the per-task pass or fail that drives the whole curriculum forward is not.
[O] Where does that leave the two of us?
[S] Genuinely persuaded the architecture is sound. Much less persuaded the specific multipliers would survive ten runs instead of three, or an outside judge instead of GPT-4 judging itself.
[O] And I'd still call it a landmark design, even discounting the numbers. Nobody else in this comparison ever reaches a diamond tool, full stop.
[S] Does any of this connect to how people should actually run agent evaluations, beyond Minecraft?
[G] Directly, and I think that's the paper's quieter legacy: self-graded success checks, author-defined metrics with no shared benchmark, and baselines re-implemented outside their native setting. All three show up constantly in agentic evaluation today, well beyond this one game. Voyager isn't unusually guilty of any of them, it's just an unusually clean, documented example of all three at once.
[O] So the method deserves to be studied, and the numbers deserve a second, more skeptical run before anyone treats them as settled. That's actually a nice place to land.
[S] Then let's land the plane. Theo, give us the paper's own version first, sticking close to the text.
[G] Voyager pairs a self-written curriculum with an external, code-based skill library and a self-verifying feedback loop, and against baselines never built for Minecraft, it's the only one that reaches a diamond tool, once.
[O] Mine: this is what an agent that actually keeps learning looks like, and I think a lot of the field is still catching up to the code-as-memory idea underneath it.
[S] Mine: exciting architecture, thin evidence, three runs is a pilot study wearing a leaderboard's clothes.
[O] The full writeup, with the figures, the ablation charts, and the citation count, is up on the litsearch site. Thanks for joining us, Theo.
[G] Thanks for having me.
