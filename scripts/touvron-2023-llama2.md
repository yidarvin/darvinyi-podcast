---
slug: touvron-2023-llama2
title: "Llama 2: Open Foundation and Fine-Tuned Chat Models"
description: "Meta writes down the actual recipe for turning an open base model into a chat assistant — two reward models, a margin loss, and five rounds of rejection sampling and PPO."
date: 2026-07-19
guest_name: "Julian"
guest_voice: bm_lewis
---
[O] Llama two-Chat wins thirty-six percent of its head-to-head match-ups against ChatGPT, ties another thirty-one and a half percent, and loses the rest.
[S] So it loses more often than it wins outright. That's the paper claiming it "may be a suitable substitute for closed-source models"?
[O] It wins more than it loses, and it's the first time an open-weight chat model got close enough that the gap sits inside a coin flip.
[S] A coin flip that Meta designed, ran, and graded itself. Let's get into it.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a guest scholar take one paper apart. Today it's Llama two: Open Foundation and Fine-Tuned Chat Models, from Hugo Touvron and colleagues at GenAI, Meta, posted to arXiv in July of twenty twenty-three.
[S] It's on the docket because it's less a model release and more a fully documented alignment recipe — reward models, RLHF loop, safety pipeline, all written down in one place at a scale nobody outside a frontier lab had shown before.
[O] Joining us to walk through it is Julian, a researcher who has studied this paper closely. Julian, welcome.
[G] Thanks for having me. By mid twenty twenty-three the pretraining race had basically been won in the open — B-L-O-O-M, the original Llama, and Falcon were all matching the raw language quality of closed pretrained models like G-P-T-3 and Chinchilla.
[S] So the open community could already build a base model that predicts tokens as well as a closed one.
[G] Right, but predicting tokens well doesn't make a helpful assistant. ChatGPT, Bard, and Claude all went through a heavy alignment step, instruction tuning plus reinforcement learning from human feedback, and that step was expensive, annotation-hungry, and essentially undocumented outside the labs doing it.
[O] So the gap wasn't pretraining anymore, it was the black box sitting on top of it.
[G] Exactly. A few open instruction-tuned models existed, but they mostly leaned on borrowed or synthetic preference data, used one reward model for everything, and rarely red-teamed at scale. The paper is direct about it — an open, documented, end-to-end RLHF recipe simply didn't exist yet.
[S] "Documented" is carrying a lot of weight there. Is that actually the contribution, more than the weights themselves?
[G] That's the paper's own framing — the stated goal is to let the community reproduce and scrutinize a production-grade fine-tuning stack, not just download some weights.
[O] Which is a very different pitch than "here's a bigger, better base model."
[G] The base architecture barely changes from Llama one, honestly — still a decoder-only transformer with R-M-S-Norm, SwiGLU activations, and rotary position embeddings.
[S] So what's actually new on the pretraining side?
[G] Three things, small on paper, load-bearing in practice. Context length doubles from two thousand to four thousand tokens, the training corpus grows to two trillion tokens of a new public-data mix, and the two largest models add grouped-query attention, so a seventy billion parameter model doesn't need a separate key and value head for every query head at inference time.
[O] And they release four sizes — seven billion, thirteen billion, thirty-four billion, seventy billion — though the thirty-four billion never actually ships.
[G] Right, held back explicitly for a lack of time to sufficiently red-team it — a small, honest signal about how seriously they take safety before release.
[S] Noted. Now the part I actually care about — how do you turn that base model into a chat model without just guessing?
[G] Three stages. Supervised fine-tuning first, to bootstrap a working conversational model. Then an iterative RLHF loop, five full versions, driven by two separately trained reward models — one for helpfulness, one for safety.
[O] Two reward models — why not one?
[G] Because helpfulness and safety trade off against each other, and a single reward model tends to average that tension away instead of resolving it. Splitting them lets Meta apply different guidelines to each and combine the two signals deliberately later.
[S] What's actually in the supervised fine-tuning set? People usually either dump everything they have or get precious about quality.
[G] They got precious, and it paid off. They set aside millions of third-party examples as too low-quality or undiverse, hand-curated their own, and stopped after twenty-seven thousand five hundred forty annotations — small enough that it clearly wasn't meant to be the point.
[O] Tens of thousands, not millions. That's a LIMA-style bet — a little very clean data goes a long way.
[G] Same spirit — they checked it too. Humans compared one hundred eighty of their own hand-written answers against the model's own generations, and the model's outputs were often competitive with what annotators wrote. That's when they redirected effort toward preference data instead.
[S] Okay, the SFT set is small and mostly a bootstrap. Walk me through the reward models — that's the real weight.
[G] Both are initialized from a chat checkpoint rather than the raw pretrained model, so the reward model, in the paper's words, "knows what the chat model knows" — it can't score based on knowledge the policy doesn't have.
[O] And the loss function itself?
[G] Standard binary ranking loss on chosen-versus-rejected pairs, the same form OpenAI used for InstructGPT. Meta adds one genuinely novel piece though — annotators don't just pick a winner, they rate how much better it is, on a four-point scale up to "significantly better." That rating becomes a margin term in the loss, so a clearly-better response has to beat a clearly-worse one by a wider score gap than a near-tie does.
[S] Does that margin actually help, or is it a paper flourish?
[G] It helps exactly where it should — on the "significantly better" pairs the margin was designed to sharpen — but push it too hard and accuracy regresses on the near-tie pairs.
[O] And the scale of data behind all this?
[G] Just under two point nine million binary comparisons total, folding in Anthropic's helpful-and-harmless sets, OpenAI's summarization and Web-G-P-T data, Stack Exchange, and a few others — but about one point four million are Meta's own newly collected pairs, the majority of the real signal.
[S] Does more data keep helping, or does it plateau?
[G] Not at the point the paper reports. Bigger reward models and more data both keep improving accuracy, and on the hardest split — the "significantly better" pairs — their seventy billion parameter reward model actually overtakes G-P-T-4 used as a judge.
[O] That's wild — a fine-tuned reward model beating G-P-T-4 at judging which response is better.
[S] On Meta's own held-out test set, judged by Meta's own guidelines. I'll come back to that.
[O] Fair. So you've got a strong reward model — how do you actually turn that into a policy update?
[G] Two algorithms, run in sequence rather than as alternatives. Rejection sampling first — draw K candidate responses per prompt, keep whichever the reward model scores highest, fine-tune on the winners. It's a breadth strategy, explore wide, then supervise on the best.
[S] And the depth strategy is PPO.
[G] Right, Proximal Policy Optimization, the standard on-policy RL algorithm, where each step's sample depends on the model as it was updated one step earlier. Through RLHF V4 they used rejection sampling alone; only at V5 did they layer PPO on top of the rejection-sampling checkpoint.
[O] Why run rejection sampling only on the seventy billion model?
[G] Compute, mostly — sampling K candidates per prompt at scale is expensive, so they run it only on the seventy billion model, then fine-tune the smaller thirteen and seven billion models directly on its selected outputs, distilling the biggest model's judgment into the smaller ones for free.
[S] What does PPO actually optimize against?
[G] A piecewise choice between the safety and helpfulness reward models — if a prompt is safety-tagged or the safety score drops below zero point one five, safety wins, otherwise helpfulness does, plus a K-L penalty against the original policy so it can't reward-hack a high score that isn't actually better.
[O] Last piece of method before results — earlier you mentioned the model forgetting instructions mid-conversation.
[G] Right, this is Ghost Attention, or GAtt, and it's a genuinely clever hack. Early RLHF models would follow something like "always answer with emojis" for a turn or two, then quietly drop it.
[S] Is that an architecture change?
[G] No, that's the elegant part — purely a data trick. Take a multi-turn dialogue, synthetically attach the instruction to every user turn, sample a response with the current model, then train on that dialogue with the instruction stripped back out of every turn but the first, zeroing the loss on the earlier turns so the mismatch doesn't confuse training.
[O] So the model learns to behave as if the instruction were still there, without ever seeing it restated.
[G] Exactly, and it works — they report the constraint holding for twenty or more turns, right up to the context limit.
[S] Let's get to numbers. Base model first — does the bigger pretraining corpus actually show up?
[G] Yes. The seventy billion base model lifts M-M-L-U from sixty-three point four up to sixty-eight point nine over Llama one sixty-five billion, and Big-Bench-Hard from forty-three point five to fifty-one point two. Strongest open base model of its moment, ahead of M-P-T and Falcon across the board.
[O] How does it stack up against the closed models — that's the number people actually cared about.
[G] Close on some axes, far behind on others. Against G-P-T-3.5 it's essentially tied on M-M-L-U, sixty-eight point nine versus seventy point oh, and close on grade-school math. Against G-P-T-4 it isn't competitive anywhere. And on code specifically, Human-Eval, it scores twenty-nine point nine against G-P-T-3.5's forty-eight point one — an eighteen-point gap.
[S] That code number is going to matter later.
[G] Hold that thought. The headline claim is about Llama two-Chat as an assistant, measured on roughly four thousand helpfulness prompts judged by human raters. Against open models it isn't close — the thirty-four billion wins more than seventy-five percent of comparisons against similarly-sized open models, and the seventy billion crushes Falcon and beats PaLM-Bison.
[O] And against ChatGPT, the number from our cold open.
[G] Thirty-six percent win, thirty-one and a half percent tie, so roughly a third loss. Not a win, but the closest an open-weight chat model had gotten — and that near-third loss rate is the honest way to read it.
[S] Did chasing helpfulness cost them on safety?
[G] Not obviously. On about two thousand adversarial prompts, rated on a five-point scale where a one or two counts as a violation, every Llama two-Chat size posts low single-digit violation rates — the thirty-four billion sits at four point four five percent, close to Falcon's three point eight eight, below ChatGPT and well below M-P-T and Vicuna.
[O] Without wrecking helpfulness to get there.
[G] Correct, and there's a specific number on the other side of that trade-off — false refusals. Even with the training mix pushed to one hundred percent safety data, the false-refusal rate on genuinely helpful prompts stayed around zero point oh five percent — it climbs faster on borderline prompts, but stayed manageable.
[S] One more before the debate — I remember something about the model using tools it was never trained to use.
[G] Real, and a fun one. With a calculator available, Llama two-Chat scored sixty-seven point one, sixty-nine point two, and eighty-two point four across three math test sets, well above Toolformer, a model explicitly trained for tool use, which scored in the twenties and forties on the same sets. Nobody annotated tool use into the training data — it emerged from alignment alone.
[O] That's the kind of result that makes people nervous and excited in the same breath.
[O] Debate time. My case — this is the moment open-weight models stopped being a curiosity. A coin-flip against ChatGPT, an honestly documented alignment recipe, and a novel reward-model trick the whole open-source ecosystem then built on.
[S] My case — nearly every headline number here was produced, graded, and refereed by Meta itself. The four-thousand-prompt set is theirs, the guidelines are theirs, the raters are contracted by them. The one outside check, G-P-T-4 as judge, shows the same direction but smaller margins — exactly what you'd expect from a home-field advantage.
[G] You're both right, and the paper says so itself — it flags directly that human evaluations "can be noisy" because of exactly the issues you're both raising, prompt-set limits, guideline subjectivity, rater subjectivity. That's the text, not me editorializing.
[O] Credit to them for saying it out loud — that's not nothing in a field full of overclaimed benchmark wins.
[S] It's a discount on the claim, not a refutation of it. Second thing — code. The abstract says "outperform open-source chat models on most benchmarks," and on the open side that's largely true, but the paper's own numbers show the seven billion model actually trailing M-P-T on code specifically, sixteen point eight against twenty point five, even while beating Falcon everywhere else.
[G] Accurate, and it's disclosed in the body of the paper, just not surfaced in the framing. Code Llama exists specifically to patch that hole a few months later.
[O] Okay, that one's a real ding — burying the one category where you're behind isn't great practice, even if it's technically disclosed.
[S] And model selection across the five RLHF rounds is picked by Meta's own reward models — the same figure that shows steady gains under their own reward model shows smaller gains under G-P-T-4. Textbook setup for a model learning to please its own grader.
[G] The paper is upfront about that risk too — they explicitly note the reward model "may favor our model," and the G-P-T-4 cross-check exists to partially defuse it. Doesn't fully defuse it, but it's disclosed, not hidden.
[O] Any of the same self-grading problem on safety?
[G] Same shape — the authors say so almost word for word, warning that the violation percentages should be read carefully given the same limited prompt set and rater subjectivity, and noting their own content standards likely favor their model. They also held the thirty-four billion model back entirely for lack of red-teaming time — a costly, credible signal the caution is real.
[S] Last point from me — "open" needs an asterisk. The weights ship. The one point four million Meta preference comparisons, the exact pretraining data mix, none of that ships. And the license is a custom commercial one with an acceptable-use policy, not an actual open-source license.
[G] Cleanest criticism of the bunch, and I don't see a strong counter to it in the paper. The recipe is described in more detail than almost anything before it, but it isn't reproducible — you'd need Meta's own annotation pipeline and budget to rebuild the reward models from scratch.
[O] Fine, I'll concede it's "here's exactly what we did," not "here's everything you'd need to redo it." Still miles ahead of what ChatGPT or Claude had published at that point, which was close to nothing.
[S] Agreed on the relative bar. I just don't want "detailed writeup" rounded up to "reproducible."
[G] For evaluation practice specifically, this is a clean case study in the failure mode this show keeps circling back to — a lab evaluating its own system, on its own prompt set, with its own guidelines, getting a result that looks stronger under its own reward model than under an outside judge.
[S] Which is why the G-P-T-4 cross-check matters more than it looks — "bring in a second, less-invested judge" is a cheap habit a lot of papers skip.
[O] And the reward-modeling piece outlived the paper — two specialized reward models instead of one, a preference-strength margin in the loss, iterating the reward model alongside the policy instead of freezing it. That structure shows up again and again in what came after.
[G] If I had to leave you with the paper's own frame — it's not "we built a model that beats ChatGPT," it's "we're publishing exactly how we built one that gets close, warts and all."
[O] My takeaway — the coin-flip result plus a documented recipe is what actually kicked the open-weight ecosystem into gear, more than any single benchmark number in the paper.
[S] Mine — read "may be a suitable substitute" exactly as carefully as they wrote it. Competitive with G-P-T-3.5-class chat on their own eval, well behind G-P-T-4, weak on code, and "open" here means open weights, not an open dataset. For the figures and the rest of the numbers, the full writeup is on the litsearch site.
