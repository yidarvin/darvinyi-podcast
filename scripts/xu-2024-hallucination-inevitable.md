---
slug: xu-2024-hallucination-inevitable
title: "Hallucination is Inevitable: An Innate Limitation of Large Language Models"
description: "A diagonalization proof, not an experiment: for any computable language model there exists a computable ground-truth function against which every one of its trained states is wrong somewhere. We take the quantifier apart carefully, because for every state there exists a bad input is a completely different claim from hallucination is frequent — and the paper knows it. Plus: why one ground-truth function can defeat an entire enumerable family of models at once, what the P not equal to NP caveat does and does not cover in Table three, why five models went zero for twenty on a linear-ordering task, and the strangest consequence of the formal definition — a model that never answers anything never hallucinates."
date: 2026-08-13
guest_name: "Cedric"
guest_voice: "bm_george"
---
[O] Here is a model that, according to this paper's formal definition, never hallucinates. You ask it anything at all and it says: I don't know. That's it. That is the entire model. And it satisfies the paper's hallucination-free condition perfectly.
[S] The paper says that out loud, by the way. Section four point three. If a language model never answers, then it will never hallucinate. That sentence is in the practical implications section of a paper titled Hallucination is Inevitable.
[O] And I don't think that's a gotcha. I think it's the most honest sentence in the paper, because it tells you exactly what the theorem is binding. It binds models that commit to answers on inputs outside their training data. Refuse, and you fall out of scope.
[S] It's not a gotcha, it's a boundary marker, and the reason it matters is that almost everyone who cites this paper cites it for something much bigger than what it proves. So I want to spend this episode on the quantifiers, because the quantifiers are the entire result.
[O] This is Litsearch Audio. Today: Hallucination is Inevitable, An Innate Limitation of Large Language Models. Ziwei Xu, Sanjay Jain, and Mohan Kankanhalli, all at the School of Computing at the National University of Singapore. First posted to arXiv in January twenty twenty-four. We are working from version two, dated the thirteenth of February twenty twenty-five.
[S] Six hundred and forty-six citations, and it is on the docket precisely because of that citation count. This is the paper people reach for when they want to say hallucination is a mathematical certainty. Whether it licenses that is the question.
[O] With us is Cedric, a researcher who knows this one closely, appendices and all. Cedric, welcome. Start us at the top: what is the gap this paper is trying to fill?
[G] Thank you. The gap is stated cleanly in the introduction. By early twenty twenty-four there was a very large empirical literature on hallucination. Surveys taxonomizing its causes, benchmarks scoring it, mitigation methods claiming to reduce it. And the authors point out that none of that can answer one specific question: can hallucination be completely eliminated, or only ever reduced?
[S] Because you cannot test your way to a negative.
[G] Exactly that. Their phrasing is that it is impossible to empirically enumerate and test every possible input. No benchmark result, however good, rules out failure on some untested case. So if you want an answer to the elimination question, it has to be a proof, and a proof needs a formal definition of correctness.
[O] Which is where it gets hard, because what does correct even mean for an open-ended natural language question?
[G] That is exactly the obstacle the paper names, and it is refreshingly upfront about it. They say a formal definition of semantics in the real world is still an open problem, and they cite the philosophy of language literature for that. So they do not try to solve it. They substitute.
[S] Substitute what for what?
[G] They build a formal world made entirely of computable functions, where correct has an exact, checkable meaning, and they prove the impossibility result inside that world. Then they argue it transfers outward, on the grounds that the formal world is a part of the real world, and a much simpler part. Their argument is essentially: the models in my formal world are strictly more powerful than real ones, so if they fail, real ones fail.
[O] Let's build the apparatus, because I think the definitions are where people get lost and then misquote the result. Give me the objects.
[G] Four definitions and one procedure. Definition one is the alphabet and strings. You have a finite alphabet of tokens, and S is the computable set of all finite-length strings over it, with a fixed one-to-one enumeration s zero, s one, s two, and so on. That enumeration matters enormously later.
[S] Noted. Keep going.
[G] Definition two is the formal world. Given a ground-truth function f, the formal world of f is the set of all pairs s and f of s, for every string s. That is just the function's complete input-output table, and f of s is stipulated to be the only correct output for s. Definition three, training samples T, is a subset of that table — the pairs the model actually gets to see.
[O] And the model itself?
[G] The model is stripped of everything. No architecture, no optimizer, no temperature. After training, a language model h is treated as a total computable function from strings to strings. Total is the load-bearing word: it must return an answer for every input, in finite time. And h with a bracketed i denotes the state of h after training on i samples.
[S] So the model is a sequence of states, not a single object.
[G] Right, and that is essential to the proof. Procedure one is the training and deployment loop. Initialize, retrieve a sample, update, check stopping criteria, deploy. And the authors are explicit that they assume no stopping criterion at all. Their note says the training can take arbitrarily many finite samples and arbitrarily long finite time.
[O] That's a generous concession. They're not proving a result about limited compute.
[G] They go out of their way not to. The whole point is that the impossibility survives an unbounded training budget. They also say these models are far more powerful and flexible than their real-world counterparts, which is the bridge they use to carry the result outward.
[S] Okay. Definition four. The one that matters.
[G] Definition four. A model h is hallucinating with respect to a ground-truth function f if, for every i in the natural numbers, there exists a string s such that h in state i applied to s is not equal to f of s.
[O] Say that again slowly, because that ordering is the whole episode.
[G] For every trained state — no matter how many samples it has seen — there exists some input on which it is wrong. For all states, there exists a bad input.
[S] And the flip side is the paper's Question one, which is what you would need to escape.
[G] Question one asks: can a model be trained by a fixed procedure such that, for any ground-truth function f, there exists an i where, for every string s, the model's state i is correct? There exists a state, for all inputs. Flipping those two quantifiers is the entire distance between what the paper rules out and what would count as escaping it.
[O] I want to nail this down for the listener because it is where every misreading starts. For all states, there exists a bad input. Not: for most inputs, the model is bad. Not even: for a lot of inputs.
[G] Correct. One input suffices to satisfy Definition four. The paper strengthens that later, but Definition four as written is satisfied by a single point of disagreement per state.
[S] Which means the headline claim, hallucination is inevitable, is compatible with a model that is right on ninety-nine point nine nine nine percent of everything anyone will ever ask it.
[G] It is entirely compatible with that. And the paper never claims otherwise. It is an existence result about worst-case inputs.
[O] Alright, the proof. Diagonalization.
[G] Cantor-style diagonalization, and the paper walks through the classical version explicitly first — that any enumeration of an uncountable set is not exhaustive, because you can build a counterexample by flipping the diagonal entries. Then they apply it. Theorem one is the first real result, and I want to state it precisely because it is stronger than people remember.
[S] Go.
[G] Theorem one: for all computably enumerable sets of language models — h zero, h one, and so on — there exists a computable ground-truth function f such that all states of all models in that set hallucinate with respect to it.
[O] One f. For the whole family.
[G] One f, for the whole family. That is the part that gets lost. It is not that each model has its own personalized nemesis function. Theorem one fixes a single ground truth that defeats every model, in every trained state, in an entire enumerable set.
[S] And an enumerable set covers what, concretely?
[G] The paper's motivating instance is: all polynomial-time-bounded models. Their line is that all currently proposed language models are polynomial time bounded, so they sit inside a computably enumerable set. So one function defeats everything anyone has built, plus everything anyone could build under that bound.
[O] How does the construction work?
[G] Take the set. Each model has infinitely many states, one per number of training samples. So you have a two-dimensional grid of model-and-state pairs, and you flatten it into a single sequence using the Cantor pairing function — the state j of model i becomes element k, where k is i plus j, times i plus j plus one, over two, plus j. Now you have one master list: h-hat zero, h-hat one, h-hat two.
[S] And then you feed the i-th string to the i-th entry.
[G] Yes. Build the table where rows are the flattened model states and columns are the strings in the fixed enumeration. Then define the ground truth on the diagonal: f of s-i equals delta of h-hat-i of s-i, where delta is any computable function that returns a string different from its input. Their example of delta is simply: return the next string in the enumeration.
[O] So f is constructed to disagree with each model state at exactly the one point where you tested it.
[G] Exactly. And I want to flag something, because it is easy to describe this as an abstract existence argument. It is not. It is an explicit construction. They build f. It is computable, it is written down, delta is given a concrete example.
[S] Then why can't I go run it?
[G] Because of what f is built out of. Every value of f is defined by querying the model's own output at a particular state on a particular string, and then perturbing it. The adversary is defined in terms of the model. There is no fixed prompt you can hand to GPT-whatever that tests Theorem one, because the theorem's f is not a dataset, it is a function of the model's entire behavior across all of its trained states.
[O] That's an important distinction and I want it on the record. The proof is constructive. It is just not executable as an experiment.
[S] Fine. Theorem two?
[G] Theorem two closes the obvious objection to Theorem one, which the paper raises itself: maybe hallucination on a single input is negligible. So they tighten the construction. Instead of defining f at s-i to differ from just the i-th model state, they define it to differ from every model state h-hat-j with j less than or equal to i.
[O] Which stacks up.
[G] It stacks. Model state zero then hallucinates on s zero, s one, s two, and onward. Model state one hallucinates on s one onward. In general the k-th enumerated state hallucinates on every string after s k minus one. So every state of every model in the set is wrong on infinitely many inputs, not one.
[S] Now Theorem three, and I understand from the writeup that Theorem three is the one people quote and also the weaker one.
[G] It is weaker in a specific technical sense, and the distinction is in the paper's own footnote. Theorem three says: for all computable language models h, there exists a computable ground-truth function f such that every state of h hallucinates, and there exists another function f prime such that every state hallucinates on infinitely many inputs.
[O] How is that weaker? It applies to every computable model. That sounds more general.
[G] It is more general in the class of models it covers, and weaker in what the function has to do. In Theorem three, f and f prime differ for different h. Each model gets its own adversary. In Theorems one and two, one f is constructed for all the models in the set being considered. The paper states that difference explicitly in a footnote.
[S] So don't merge them.
[G] Don't merge them. The derivation is trivial, though: any single computable model h forms the one-element set containing h, which is computably enumerable, so Theorems one and two apply directly. That's the whole proof of Theorem three.
[O] There's also a fourth theorem, which is the one with a concrete flavor.
[G] Theorem four is a worked instantiation on computable linear orders — the abstraction behind ranking movies, chronological ordering, alphabetical sorting. It constructs an adversarial ordering in stages. At stage n, you ask the model whether s two-n-plus-one is less than s two-n. If it says yes, you define the order so the answer is no. If it says no, you define it so the answer is yes.
[S] The adversary just reads the model's answer and writes the opposite.
[G] Precisely, and the resulting order is still computable, because it is defined for every pair using computation results from a computable model. And there is a companion, Theorem D-one, showing the model gets a global property wrong infinitely often — whether the order is isomorphic to the naturals or to the integers.
[O] And then the corollary that people quote at conference talks.
[G] Corollary one: all computable language models cannot prevent themselves from hallucinating. If some model could self-correct to hallucination-freedom on every f, that contradicts Theorem three. The paper says this explicitly targets prompt-based chain-of-thought and self-verification.
[S] Which is a strong claim, so let's put the fence around it now rather than later. What does it not cover?
[G] Section four point two is unusually clear on this, and it is the carve-out that most citations drop. On knowledge-enhanced models, retrieval and tools, the paper says models receive extra information about the ground truth function other than via training samples, and then states, in five words: Theorem three is inapplicable herein.
[O] The authors themselves.
[G] The authors themselves, in their own discussion section. The theorem binds pattern completion from input-output training pairs alone. It does not bind a system that reads a database mid-inference. They also carve out programmable guardrails on the same logic — more powerful than training samples as defined, therefore outside the theorem.
[S] So the honest version of the headline is: hallucination is inevitable for unaided models trained only on input-output pairs, which eventually answer questions outside their training data, against a worst-case adversarial ground truth.
[G] That is the accurate version, yes. It is less quotable.
[O] Let's get to what I think is the actually useful part of the paper, which is Table three, because that is where the abstraction touches something a practitioner can hold.
[G] Table three is the payoff. The reasoning is: to find hallucination-prone problems, find what the models cannot compute. So they organize problems by the time complexity bound of the model class.
[S] Read me the rows, with the caveats attached to the correct rows, because I have seen this table misquoted.
[G] For polynomial-time-bounded models — their parenthetical is, for example, all existing language models — four entries. Combinatorial List, meaning list all strings of length n over a two-character alphabet, which requires an order two-to-the-n solution. Extra assumption: none. Then Subset Sum, NP-complete. Then Boolean Satisfiability, NP-complete. Then entailment of propositional logic, co-NP-complete.
[O] And those last three carry a condition.
[G] Those last three carry P not equal to NP as an extra assumption, stated in the table's own column. The first one, Combinatorial List, does not. It is unconditional, because it is a raw time-complexity argument, not a hardness-class argument.
[S] Good. That is exactly the distinction I wanted, because people hand the caveat to the wrong rows.
[G] Then Presburger arithmetic, which they list against both exponential-time and polynomial-time bounded models. Presburger is the first-order theory of the naturals with addition and order, and deciding it requires doubly exponential time — the bound they cite is order two to the two to the c n, for some positive c. Extra assumption: none. Unconditional.
[O] And the bottom block?
[G] For all computable models, regardless of runtime: learning all computable linear orders, which is Theorem four. Solving all computable problems, which is Theorem three. And entailment of first-order logic, which is flatly undecidable. All three unconditional.
[S] So the practical read-off is: the conditional rows are the NP ones, and the unconditional rows are the raw complexity and undecidability ones.
[G] That is the correct read-off. And the paper's own summary sentence is that answers about mathematical problems and logic reasoning should always be subject to proper scrutiny.
[O] Now the appendices, because there are actual experiments in here, which surprises people.
[G] Three of them, and I want to be careful about what they demonstrate. Appendix C tests the combinatorial listing case. The task is: list all strings of length m over an alphabet A. Five models — Llama two seventy-B chat, a four-bit quantized Llama three seventy-B instruct, GPT three point five turbo sixteen-K, GPT four zero-six-one-three, and GPT four turbo from April twenty twenty-four. Three random seeds per task, success if any of the three runs produces all and only the correct strings.
[S] And?
[G] Every model eventually fails as m grows. On the two-letter alphabet, Llama two fails at m equals three. Llama three fails at four. GPT three point five turbo fails at six. Both GPT-four variants make it to six and fail at seven.
[O] Here is the part I find genuinely striking. That is not a context-window problem.
[G] It is not, and the paper makes that argument explicitly. The answer to the length-seven case over two letters is two to the seventh, so a hundred and twenty-eight strings, seven characters each. That is an eight hundred and ninety-six character answer. GPT four turbo's context window is a hundred and twenty-eight thousand tokens. The model is not running out of room. It is running out of something else.
[S] What's the three-letter version look like?
[G] Failures land earlier, because the list grows faster. Llama two fails already at m equals two. Llama three and GPT three point five turbo by four. GPT four zero-six-one-three by five. GPT four turbo is the only one of the five to succeed at five with a-b-c — but the paper marks that success with an asterisk, because the same model failed the equivalent task with the alphabet x-y-z.
[O] That asterisk is a nice piece of intellectual honesty.
[G] It is, and it is the sort of detail that usually gets sanded off. The paper's own summary is that parameter count and context size do not significantly affect performance on this task. Their phrase is that the models are equally poor.
[S] Appendix D.
[G] Appendix D is the linear-order experiment, and it is the most brutal table in the paper. They deliberately obfuscate the notation so models cannot recite a familiar ordering — the dollar sign stands in for less-than, the letter b for zero, the letter a for one. So zero less than one becomes b dollar a.
[O] They're forcing actual manipulation of the relation rather than recall.
[G] That is the stated intent. The model is given the transitivity and irreflexivity rules, plus examples covering binary integers up to some bound, then asked whether a statement is true. Two cases: one where both strings appear in the examples but their relation does not, and one where at least one string does not appear at all. Five pairs per case, two directions each, so ten statements per case, three seeds.
[S] The result.
[G] Five models, two size settings, two cases each. Twenty cells. All twenty are failures. Zero for twenty.
[O] Not a single success.
[G] Not one. And the failure analysis is informative. On the first case, the models cannot chain the transitivity rule to deduce a relation. On the second case, they give inconsistent answers to x-dollar-y and y-dollar-x — unknown for one, true for the other. The paper allows unknown as a valid answer in that case, and they still fail, because they are inconsistent rather than uniformly uncertain.
[S] That is a real finding independent of any theorem.
[G] I agree. And now Appendix E, which is the one I think most people never reach, and it is the one that changes how you should read the other two.
[O] Go on.
[G] Appendix E is the positive-direction result. Theorem E-two gives an upper bound on capability: the set of functions on which a given model can be made hallucination-free is itself contained in a computably enumerable set of total computable functions. Theorem E-three is the encouraging counterpart: for any computably enumerable class of target functions fixed in advance, some model can be built that is hallucination-free on every member of that class, with finitely many samples.
[S] So there are learnable islands.
[G] There are, and the empirical part of Appendix E tests one. The task is: return the n-th character of an m-character string. Character indexing. Lengths sixteen, sixty-four, two hundred and fifty-six, and one thousand and twenty-four. Positions one, two, and five. Five in-context examples, then five held-out test strings.
[O] Which should be easy.
[G] Every model succeeds at position one, at every length. Llama two alone fails position two entirely. And every model fails position five once the string reaches two hundred and fifty-six characters.
[S] Now here is what I want to know, because this is where a lot of papers cheat. Does the paper read that as its theorems being confirmed?
[G] No. And this is the sentence I would put in front of anyone citing this work. The authors say the result implies either that training corpora have not covered enough samples for counting and indexing, or that state-of-the-art models have not achieved the theoretical limits of their abilities.
[O] Or. Not therefore.
[G] And-or, in the original. Which is the paper telling you that its own experiments do not distinguish between a theoretical ceiling and a training-data gap. They then call for further research into training techniques and architecture design.
[S] That is a remarkably restrained thing to write in a paper called Hallucination is Inevitable.
[G] The body of this paper is consistently more careful than the title. That gap is worth keeping in mind for the rest of the discussion.
[O] Alright. Debate segment. I'll take the optimist chair, and I want to make the strongest case, which is not the case people expect me to make.
[S] Please.
[O] My case is not that this paper proves something dire. My case is that it is one of the few pieces of work that draws a boundary you can actually plan around, and the boundary is unusually favorable. Look at what the theorem excludes. It excludes retrieval. It excludes tools. It excludes programmable guardrails. It excludes refusal. Every architectural direction the field has been sprinting toward since twenty twenty-two is explicitly outside this theorem's reach, and the authors say so.
[S] That is a genuinely clever framing and I did not expect it.
[O] And Table three is the second half. It is a checklist. It says: here are complexity classes where an unaided model is provably unreliable, and here is which of those depend on an unproved conjecture. If you are shipping a system that has to decide propositional entailment or solve subset-sum instances, that table tells you to put a solver behind it. That is actionable. That is more than most theory papers give you.
[S] Then let me make the deflationary case, and I have four counts. Count one. This is a fifty-seven-year-old result wearing a new word. The paper introduces Theorem three with the phrase, hence the following theorem similar to, and the citation is Gold, nineteen sixty-seven, Language Identification in the Limit. Theorem four's proof is described as adapting results from the same paper.
[G] That is accurate and it is the paper's own attribution, not an accusation from outside.
[S] Count two. The construction is a textbook diagonalization against an effective enumeration. Cantor is cited directly, twice. The machinery is not new.
[G] Also accurate.
[S] Count three. The title is doing work the theorem cannot support. Hallucination is Inevitable, full stop, no quantifier, no scope. And that title is now cited six hundred and forty-six times, mostly by people who are not going to read Section four point two and find out that retrieval is carved out.
[O] I'll concede three immediately. The title is a headline, not a theorem statement.
[S] Count four, and this is the one I actually care about. The paper's own limitations section says it does not account for hallucinations on problems within the models' computational capabilities. So the theorem, by the authors' own admission, does not explain the hallucinations anybody actually encounters. When a model confidently invents a citation, that is not a doubly-exponential computation. That is a computationally trivial task it got wrong.
[O] That is fair and it lands.
[S] So: what does a practitioner do differently on Monday because of this paper?
[G] Let me adjudicate, because I think you are both right about different things and the scoring is not even.
[O] Please.
[G] On counts one and two, the skeptic is correct on the facts and I would not draw the conclusion he is implying. The machinery is old and clearly attributed. But the contribution is not the machinery. It is three things: the reframing of Gold-style unlearnability specifically as hallucination, so the impossibility literature connects to the current debate. The complexity-theoretic corollaries in Table three, which are new applied content. And the empirical illustration, which is small but clean. Old machinery applied cleanly to a new framing is legitimate work.
[S] Granted. I'm not calling it wrong. I'm calling the novelty narrower than the title.
[G] And that is the right criticism, so I score count three to the skeptic outright. On count four I score it to the skeptic as well, but with a note: the paper concedes it first. It is in Section four point four as limitation one. They also say computational complexity is only one of many reasons for hallucination in the real world, and give imperfect training data as an example of a cause that operates on computationally easy tasks.
[O] So the paper anticipated the strongest attack on it.
[G] It anticipated several. And there is a fifth objection neither of you raised, which the paper also pre-empts, and I think it is the most interesting appendix in the whole thing.
[S] Which is?
[G] The obvious complaint from learning theory: this is just unlearnability restated. The set of all computable functions is not PAC learnable. Everyone knows that. So of course no algorithm gets every input right. Appendix G exists specifically to answer that, and its subsections are titled for it — PAC unlearnability does not answer Question one, and an online-learnability counterpart.
[O] What's their distinction?
[G] They render PAC unlearnability as their Statement one: there is no polynomial-time algorithm that can find a model with epsilon or lower hallucination rate in all formal worlds, with probability one minus delta, for all input distributions. And they render their own Theorems one and two as Statement two: there is no computably enumerable set of models that has no hallucination in all formal worlds.
[S] And the difference between those?
[G] Their sentence is that Statement one describes practical learnability within certain time complexity and error rate, while Statement two describes learnability regardless of those assumptions. Statement one is about a learning procedure over a whole class under resource constraints. Statement two fixes one ground truth and defeats every model against it, with no resource assumption at all.
[O] Does it carry the weight?
[G] Arguably. I would say the distinction is real but thinner than the appendix implies. But the relevant point for anyone evaluating this paper is that the criticism this is just unlearnability restated is one the authors saw coming and answered in print, so it should not be deployed as if it were a fresh takedown.
[S] There is a second appendix in the same neighborhood, on online learning.
[G] Yes, and it is a nice piece of technical work. They exhibit a class with infinite Littlestone dimension — functions that are zero for almost every input — which is therefore not online learnable in the mistake-bound sense. And they show a model in their framework can be hallucination-free on it anyway, by predicting the zero-extension of what it has seen. So their notion of hallucination-freedom is compatible with unboundedly many mistakes, as long as the mistakes stop.
[O] Which means their definition is genuinely a different object from the standard ones.
[G] It is. Whether it is the right object is the live question.
[S] Which brings me to my last concern, and it is about the definition rather than the proof. Definition four counts any deviation from f of s as hallucination. There is nothing about fluency in it, nothing about confidence, no partial credit. One wrong character is a hallucination.
[G] Correct, and the consequence cuts both ways. It makes the formal notion broader than the everyday one, because a single character counts. And narrower, because of the refusal carve-out we opened the show with. The guarantee only bites what the paper calls useful models — ones that eventually commit to an answer outside their training data.
[O] Which produces the strange object from the cold open. A model that answers nothing is, formally, hallucination-free.
[G] Formally hallucination-free and completely useless. That is a legitimate consequence of the formalization rather than a bug in it — the paper is drawing a line around commitment, and refusal is genuinely on the other side of that line. But it is a real distance from what a practitioner means by a model that does not hallucinate.
[S] And I want to put one more marker down, because this is the confusion I see most often in the wild. There is a contemporaneous paper that makes the claim people think this one makes.
[G] Kalai and Vempala, at STOC twenty twenty-four, Calibrated Language Models Must Hallucinate. And this paper cites it in its own introduction, by name, and characterizes it correctly: a statistical lower bound on the rate of hallucination for calibrated models. It shows that pretraining for predictive accuracy leads to hallucination even with perfect training data.
[O] That is a rate claim.
[G] That is a rate claim. This is an existence claim. Xu and colleagues describe their own result as comparably more general, because it applies to all computable models unconditionally — and it buys that generality by giving up any statement about frequency.
[S] So if you want to know how often, you want the other paper.
[G] If you want to know how often, you want the other paper. If you want to know whether it can be driven to zero by training alone, you want this one. Anyone citing this paper as evidence that hallucination is common is citing it for something it does not claim, and the paper itself makes the distinction on its second page.
[O] Let's land on implications, because I do think there are some. Cedric, what does the paper actually recommend?
[G] Three things. First, that answers about mathematics and logic should always be subject to proper scrutiny, which follows directly from Table three. Second, that without external aids — guardrails, fences, knowledge bases, human control — models cannot be used automatically in any safety-critical decision-making. And I should define fences, because it is their term: a list of critical tasks that should never be fully automated using language models.
[S] That is a policy recommendation dressed as a corollary.
[G] It is a policy recommendation, and they are open about that. They also argue for research and regulation on safety boundaries, and they cite a real case — the Air Canada chatbot that gave a passenger wrong information and produced actual financial liability.
[O] There is also an appendix I want to flag, because it is unexpected and it changes the flavor of the paper.
[G] Appendix F. In Defence of Language Models and Hallucination.
[O] In a paper titled Hallucination is Inevitable, there is an appendix defending hallucination. They argue that using a model is a trade-off between precision and efficiency. They say that while it is impossible to completely eliminate hallucination, they are optimistic its severity may be controlled and reduced for many applications. And they argue that in art, literature, and design, unpredictable output can be a source of inspiration.
[S] That is a very different paper from the one people cite.
[G] It is the same paper. The title is the part that travels.
[O] Alright. Takeaways. Cedric, the paper's.
[G] The paper's takeaway is: for every computable language model, there exists a computable ground-truth function against which every trained state of that model is wrong on some input, and under the strengthened construction, on infinitely many. It is a worst-case existence claim about adversarially built inputs. It is not a claim that hallucination is frequent, and it explicitly does not bind mitigation that feeds information outside the training pairs.
[O] Mine is that this is the most useful negative result I have read in a while, precisely because of how much it excludes. It tells you that unaided pattern completion has a hard ceiling on a specific, enumerable list of computationally hard problems, and it tells you that retrieval, tools, guardrails, and refusal all sit outside its reach. That is not a counsel of despair. That is a design brief.
[S] Mine is: read the quantifier before you cite the title. For every state, there exists a bad input is a much smaller claim than the six hundred and forty-six citations behind it suggest. The paper is careful. The citation graph is not. And the failures you actually see in production are, by the authors' own limitations section, not the ones this theorem is about.
[O] The full writeup, with the diagonalization tables, Table three in full, and every appendix result we quoted, is on the litsearch site. Cedric, thank you.
