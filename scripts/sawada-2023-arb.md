---
slug: sawada-2023-arb
title: "ARB: Advanced Reasoning Benchmark for Large Language Models"
description: "A graduate-level benchmark across math, physics, law and the MCAT that separates what a model can recognise from what it can produce, plus an early attempt at letting GPT-4 write and apply its own grading rubrics."
date: 2026-07-31
guest_name: "Sloane"
guest_voice: "af_bella"
---
[O] Here is one model, one benchmark, one afternoon of evaluation. G P T four answers roughly eighty-six percent of the M CAT science questions correctly. On the mathematics problems that ask it to produce a numerical answer, the same model lands at roughly four percent.
[S] Eighty-six down to four. And before anyone reaches for a story about reasoning depth, notice what else changed. The first set is multiple choice. The second asks the model to produce a number out of thin air.
[O] Which is exactly why I think this paper matters. It holds the difficulty level roughly fixed and varies the answer format, and the format turns out to be worth more than the model.
[S] Or the multiple choice questions were never measuring what we claimed they measured. That is the argument I want to have today.
[O] Welcome to Litsearch Audio. Today's paper is ARB, the Advanced Reasoning Benchmark for Large Language Models, by Tomohiro Sawada, Daniel Paleka, Alexander Havrilla, Pranav Tadepalli and colleagues. It appeared at the Math A I workshop at NeurIPS, twenty twenty-three.
[S] It is on the docket because it is a benchmark paper that quietly ships two contributions, and the second one, a language model writing rubrics to grade open-ended proofs, has aged into a far bigger topic than it was at the time.
[O] And we have Sloane with us, a researcher who has read this one closely. Sloane, welcome.
[G] Thank you. Before a single number, can I lay down some bookkeeping? Three different things in this paper get called the benchmark, and almost every misreading I have seen comes from letting them merge into one.
[G] The first is the set of task domains. Mathematics, physics, law, and the M CAT, which the paper splits into a reading comprehension portion and a science portion. The abstract phrases that same set as mathematics, physics, biology, chemistry and law, because the M CAT is where the biology and chemistry live. Inside math and physics there is also a symbolic subset the authors call out separately as their hardest slice.
[S] That is one. What is the second?
[G] The second is the answer format. Multiple choice, short numerical answer, short symbolic answer, and open-ended proof-like response. Those four are graded by completely different machinery, and a score under one of them is not comparable to a score under another.
[O] And the third?
[G] The third is the rubric-based evaluation experiment. That is the paper's second headline contribution, and it is not a subject area at all. G P T four is asked to turn a reference solution into a ten-point rubric, then, in a separate call, to grade a candidate solution step by step against that rubric for partial credit. Those scores are then compared against human annotators.
[S] So a rule for the rest of the episode. Every accuracy gets a domain and a format attached, out loud.
[G] Both, every time. And one further distinction that trips people badly. A number from the rubric experiment is a statement about the grader, not about the model being graded. When you hear a correlation of point nine one, that is two graders agreeing with each other. It is not anybody's accuracy at physics.
[O] Good. Then the gap. Why did this need to exist?
[G] Because by the middle of twenty twenty-three the standard reasoning yardsticks were losing their power to discriminate. G S M eight K, the MATH benchmark, M M L U, BIG bench, HELM. Scores were climbing while nobody believed the models had reached expert performance in those domains. The paper puts it as the race between language models and benchmarks having increasingly favoured the former, and traces the pattern back to GLUE being retired for SuperGLUE.
[S] That diagnosis was everywhere that year. What is the paper's actual causal claim about the mechanism?
[G] Two pressures. One, the material is public and easily scraped, so contamination risk only grows with time. Two, the multiple choice format is comparatively easy to game, and it never asks a model to produce an answer, only to recognise one among four or five.
[O] So the fix is harder sources and harder formats, pulled at the same time.
[G] Exactly those two levers. On sources: contest mathematics books, a Harvard Ph.D. qualifying exam in mathematics, a physics Ph.D. qualifying questions series, a practice bar exam, and M CAT practice books. On formats: a much larger share of problems that demand a produced answer rather than a selected one.
[S] Name the physics source properly, because I want to know how deep that well goes.
[G] It is the Major American Universities Ph.D. Qualifying Questions and Solutions series. And here I have to be careful, because the paper never tells you how many volumes it drew from. The bibliography entry carries a number, but that number identifies a volume, it is not a count of books used. So the honest description is a physics qualifying-exam series, quantity unstated.
[O] Fine. Give me the shape of the dataset.
[G] Twelve hundred and seven problems in total, and the distribution is lopsided in a way that matters enormously. Law is six hundred and twenty-seven problems, all multiple choice. The M CAT contributes three hundred and forty-six across reading and science. Put those together and it is nine hundred and seventy-three problems, a bit over eighty percent of the whole benchmark, every one of them multiple choice.
[S] Leaving what for the part everyone actually quotes?
[G] Two hundred and thirty-four math and physics problems, spread across seven subject-and-format cells. Mathematics: fifty-two numerical, thirty-four symbolic, nineteen proof-like. Physics: eighty numerical plus eighteen more that carry figures, and eighteen symbolic plus thirteen more with figures.
[S] So the headline difficulty story rides on cells of between thirteen and eighty items.
[G] It does, and I will come back to that, because it compounds later in an ugly way.
[O] How is each format graded? This is where your three-way split earns its keep.
[G] Multiple choice is exact match on the parsed final letter. Numerical answers get parsed with SymPy and are scored correct when the relative error against the ground truth is under one percent. Symbolic answers are normalised to a common variable naming scheme and checked for equivalence up to permutation of variables, again with SymPy, and the paper flags that method as error-prone and only usable when the response comes back in clean function form. Proof-like answers are graded entirely by hand, by authors with mathematical training, because natural language proofs cannot be evaluated automatically.
[S] There is an admission buried in that list.
[G] There is, and the paper states it outright. They skipped algebraic short-answer questions wherever they could, because a grading scheme robust to every equivalent form of an algebraic expression is, in their words, not feasible at dataset scale. Grading difficulty shaped which problems could be in the benchmark at all.
[O] And the rubric pipeline itself?
[G] For symbolic and proof-like problems only. The authors hand-write a small set of example rubrics, few-shot prompt G P T four with those plus the ground truth reference solution, and get back a ten-point rubric that breaks the problem into weighted intermediate steps. Then a separate prompt has G P T four grade a candidate solution against that rubric and assign partial credit. Note the scope carefully: there is no numerical column and no multiple choice column anywhere in that experiment. Rubrics only exist where there are steps worth awarding.
[O] Which models are on the board?
[G] Four, all contemporaneous with the paper. G P T four with eight K context, the oh three fourteen checkpoint. G P T three point five turbo, the oh three oh one checkpoint. Text davinci double-oh-three. And Claude v one point three with the hundred K context. All prompted with chain of thought and a required answer delimiter so the final answer can be parsed. And only the text-only problems were evaluated. The image-bearing physics and M CAT items were held out, because in the paper's framing good multimodal models did not exist yet.
[S] Now the numbers. And I want to know exactly how they were obtained.
[G] Careful here, and this is the single most important caveat in the episode. The mechanically scored results live in a bar chart, and that chart prints no values. No table underneath it, no labels on the bars. So everything I am about to say about it is a reading off a figure. It is approximate, and I am going to say roughly and mean it.
[O] Understood. Give me the shape anyway.
[G] Five groups: law, M CAT science, M CAT reading, physics numerical, math numerical. Four bars in each. On law, Claude v one point three is around forty-four percent, text davinci double-oh-three around thirty-eight, G P T three point five turbo around forty, and G P T four around sixty-three.
[S] Stop there. Sixty-three percent on multiple choice bar exam questions is not a saturated benchmark.
[G] It is not, and that deserves saying loudly, because the lazy summary of this paper is that models do fine on multiple choice and collapse everywhere else. The multiple choice law section is itself nowhere near solved. The other three models sit in the upper thirties to low forties on it.
[O] What about the two M CAT splits?
[G] M CAT science is the strongest column in the figure. Roughly seventy-eight for Claude v one point three, mid sixties for both text davinci double-oh-three and G P T three point five turbo, and around eighty-six for G P T four. M CAT reading runs roughly sixty-two, sixty-four, fifty-six, and eighty-four in that same model order.
[S] And then the numerical cells.
[G] This is the cliff. Physics numerical: roughly five percent, two percent, five percent, and around seventeen for G P T four. Math numerical: roughly two percent, essentially nothing, two percent, and about four for G P T four.
[O] Four percent, from a model doing eighty-six on M CAT science.
[G] Same model, same benchmark, different answer format. G P T four sits on top in all five groups, though on math numerical the entire cluster is so close to the floor that the ordering is not carrying real information.
[S] Before we move on, how much of that multiple choice spread is a parsing artefact rather than a knowledge gap?
[G] Good instinct, and the paper checks it directly. Across models, with appropriate prompting, more than ninety-seven percent of outputs are parsable. But there is one sharp exception. The paper names G P T three point five turbo as the model that cannot reliably follow the answer formatting instructions, and on the law set it fails to produce a parsable answer around twenty-five percent of the time, often by refusing to commit to a single choice. The other models are under five percent there, and G P T four is correctly parsed over ninety-nine percent of the time.
[S] So part of that model's law number is a compliance failure, not a legal reasoning failure.
[G] Partly, yes. And note that twenty-five percent is a parsing rate, not an accuracy. Do not fold it into the bars.
[O] Take us to the symbolic subset. That is the slice the paper seems proudest of.
[G] These are manually parsed, so a human read the final expression rather than trusting SymPy. On math symbolic: G P T four at eighteen percent, G P T three point five turbo at twelve, text davinci double-oh-three at three, Claude v one point three at three. On physics symbolic: G P T four at twenty-eight percent, G P T three point five turbo at six, text davinci double-oh-three at six, and Claude at eleven.
[S] So the field below G P T four runs from three to twelve percent. That is not a rounding error away from zero, but it is not a capability either.
[G] Right, and I would resist the phrase low single digits, because twelve percent and eleven percent are sitting in there. Within that table G P T four leads both columns.
[O] And interestingly it does better on physics symbolic than on math symbolic. Twenty-eight against eighteen.
[G] It does. Hold that gap, because there is a memorisation reading of it that comes up later.
[S] What is actually going wrong in the failures? Is it knowledge or is it execution?
[G] The authors hand-tagged an error taxonomy, on G P T four only, across five rows: math numerical, math symbolic, math proof-like, physics numerical, physics symbolic. Four error categories, and crucially the categories are not mutually exclusive. One graded response can carry several tags at once.
[G] Misreading the problem is rare: zero, sixteen, five, zero and zero percent down those rows. Wrong approach, meaning the chain of thought never converges on a workable method, runs twenty-five, fifty, fifty, eighty, thirty-seven. Logical error or hallucination runs eighty-eight, twenty-nine, seventy-two, fifty-three, sixty-eight. Arithmetic mistakes run forty-eight, four, sixteen, six, thirty-one.
[O] So which category dominates?
[G] Logical error or hallucination is the largest tag in three of those five rows: math numerical, math proof-like, and physics symbolic. Wrong approach is the largest in the other two, math symbolic and physics numerical. Those two categories split the field between them.
[S] And the arithmetic column?
[G] Arithmetic swings widely by row, from four percent on math symbolic up to forty-eight on math numerical. But I would not build a story on that swing by itself, because wrong approach and logical error both range at least as widely across the same rows. The honest summary is that all four categories are strongly subject-dependent.
[S] What sample sits under those percentages?
[G] Between twenty and forty problems per subject area, subsampled from the full cells. The authors say so plainly, and they defend it: enough for a ballpark estimate, and not worth increasing, because attributing an error type is inherently fuzzy work. I would read those as rough proportions at one significant figure.
[O] What about the proof problems? Those are the aspirational ones.
[G] And here the paper does something you have to read very carefully. In the error table, the correct-answer column for the proof-like row is marked not applicable. A proof does not reduce to a single checkable value, so the paper prints no strict correct-final-answer rate for that row at all.
[S] Then what is the sixteen percent I have seen quoted from this paper?
[G] That comes from a separate, more benevolent grading pass described in the prose. Some problems ask for several things to be proven or calculated. The graders awarded a score of one half when the model correctly derived at least half of those subproblems. Under that scheme, G P T four's proof-like performance jumps to sixteen percent.
[S] Jumps from what, though?
[G] From nothing the paper prints. There is no strict baseline for that row anywhere. So sixteen percent is a partial-credit figure with no published number to be compared against, and quoting it as an improvement over something is the standard error.
[O] It is also not the same thing as the correct-reasoning tag in the error table.
[G] Correct, and that is the specific conflation to avoid. The correct-reasoning tag is a stricter judgment about the whole chain of thought, measured differently, on a subsample. It is not the baseline for the sixteen.
[O] Take us into the rubric experiment properly. This is the part I find genuinely forward-looking.
[G] There are two validations, and they answer different questions. First, is the generated rubric any good? Humans rated G P T four's rubrics on a one to five scale for coverage of the reference solution's key steps: four point four two on physics symbolic, four point two six on math symbolic, three point nine four on proof-like. Then separately for how fairly the ten points are spread across those steps: four point one six, four point zero, and four point zero six.
[S] So coverage edges out point allocation on the two symbolic sets, and on proof-like they are basically level.
[G] That is the pattern. And there are failure counts alongside. G P T four awards extra credit, meaning points the rubric does not justify, twenty-seven percent of the time on physics symbolic, eighteen on math symbolic, and forty on proof-like. It unfairly reduces credit somewhere between five and twelve percent of the time. And on math symbolic, fifteen percent of the time it hallucinates a rubric line, awarding credit while citing a criterion that is not in the rubric it was handed. Zero on the other two columns.
[O] A grader inventing its own criteria fifteen percent of the time on one column is a real finding, and I am glad it is in the table.
[G] The authors report it rather than bury it, which I read as a good sign about the whole paper.
[S] Second validation?
[G] Human annotators independently graded the same solutions against the same rubrics, out of ten points. Physics symbolic: humans gave five point zero, the model gave five point zero five. Math symbolic: humans three point one three, model three point three seven. Proof-like: humans two point six five, model three point eight. Pearson correlations of point nine one, point seven eight, and point eight two respectively.
[O] Point nine one is a strong correlation by the standards of anything involving human graders.
[S] It is agreement, on a small sample, between G P T four and a human, grading G P T four's own solutions, against a rubric that G P T four itself wrote from the reference solution. Every link in that chain is the same model.
[G] That is the fair characterisation, and it is the paper's biggest scoping limitation. Nothing here tests whether the pipeline survives G P T four grading a different model's solutions, or a weaker model writing the rubric. The authors note in passing that G P T three point five turbo writes much worse rubrics, which tells you the rubric-writer is load-bearing.
[O] And the bias has a direction, which I think is the useful part.
[G] It does, and it is consistent. The model over-scores relative to the human on all three columns, and the gap widens as the problem gets less structured. About zero point zero five on physics symbolic, zero point two four on math symbolic, and one point one five on proof-like. The paper names the mechanism too: G P T four hands partial credit to attempts that fall completely outside the rubric, where the human evaluation score is always zero.
[S] Which is exactly the failure you would predict from a model asked to be generous about its own work.
[G] And the authors' own conclusion is appropriately narrow. Their words: this method is not yet reliable enough to replace human grading.
[O] Is there any counter-evidence on which way an automated grader tends to lean?
[G] There is, and it is my favourite thing in the appendix, because it points the other way entirely. On a narrower task, deciding whether two symbolic expressions are equivalent rather than grading against a rubric, they test G P T three point five turbo against human ground truth. Physics symbolic: three true positives, zero false positives, nine true negatives, six false negatives. Accuracy of point six seven on eighteen items. Math symbolic: four true positives, zero false positives, twenty-two true negatives, eight false negatives. Accuracy of point seven six on thirty-four items.
[S] Zero false positives in both columns.
[G] Zero. It never credits an answer that was actually wrong. But look at what it misses. It fails to credit six of the nine genuinely equivalent physics symbolic answers, and eight of the twelve genuinely equivalent math symbolic ones.
[O] So a cheap grader that systematically under-credits.
[G] The exact opposite failure from the rubric grader, which systematically over-credits. Two automated graders in one paper, biased in opposite directions, on tasks that look superficially similar. If you are standing up a language model as a judge, that pair is the lesson to carry away.
[O] Let me make the optimist case, and it is not about the scores at all. This paper picked the right axis to vary. Holding difficulty roughly fixed and moving the answer format shows you that a large share of what benchmarks were measuring in twenty twenty-three was recognition, not production. That is a structural insight, and it survives the model generation turning over underneath it.
[S] My deflationary case has three parts. One, the hard cells are tiny. Nineteen proof-like problems, thirteen physics symbolic with figures, and the error taxonomy subsamples on top of that. Two, the most-quoted figure in the paper prints no numbers, so the headline results are readings off bars. Three, the rubric contribution is a model agreeing with a human about the model's own work, on rubrics the model wrote.
[G] Let me score those one at a time, staying close to what the text supports. The format axis: point to the optimist. The gap between multiple choice and produced-answer formats is enormous, tens of points, and it appears on every subject where both formats were measured. No amount of sampling noise erases a gap that size.
[S] I will concede that one.
[G] Sample sizes: point to the skeptic, but a bounded one. When one cell reads four percent and another reads eighty-six, small samples do not rescue the low one. Where the skeptic is entirely right is on rankings. The ordering among the bottom three models on any single hard cell is not a signal, and nobody should cite it as one.
[O] And the unlabelled figure?
[G] Point to the skeptic, cleanly. Anyone quoting a precise percentage off that chart is quoting a measurement the paper did not print. The qualitative shape is solid. The decimals are not there.
[G] The rubric validation: point to the skeptic on scope, and to the optimist on direction. It is genuinely narrower than the phrase rubric grading works would suggest. But correlations in the point seven eight to point nine one range, with a bias that is consistent and mechanistically explained, is a real signal about where the method might go.
[O] I will take that split.
[S] So will I. Now what about contamination? A benchmark built out of published books has an obvious exposure.
[G] The paper is unusually direct about it rather than silent. Its own words: as with all other benchmarks that are not created anew and kept secret, it is possible there is data contamination. It singles out the M CAT books specifically. They are not freely available in most jurisdictions, but the authors say a model creator could certainly have trained on them anyway.
[O] And they did something structural about it.
[G] They gated dataset access behind an A P I rather than a public download, and they explain the reasoning. They considered dataset poisoning and canary text methods, and concluded that restricting accessibility to web crawlers seemed to be the only way to ensure the integrity of the dataset for future use.
[S] Did they look for memorisation, or only worry about it?
[G] Both, with two different signals. There is a qualitative case in the appendix where G P T three point five turbo reproduces a correct capacitance formula while its visible reasoning is wrong, whereas G P T four stays faithful to its own reasoning chain and lands on a slightly worse final answer. And there is a pattern claim: the authors note that many physics symbolic problems have correct symbolic answers even when G P T four's chain of thought is flawed, and attribute that to some kind of memorisation.
[O] Which lines up with the gap you flagged earlier. Twenty-eight percent correct answers on physics symbolic against twelve percent correct reasoning.
[G] More than double, and both of those numbers come from the paper's own error table. That is a fingerprint worth taking seriously.
[S] But there is no n-gram or exact-match audit against training-adjacent corpora.
[G] None at all. And their conclusion is a hedge rather than a clearance: overall performance across the models tested is still somewhat low, hence not majorly affected by memorisation of similar problems. Read that as no major red flag found, not as cleared.
[O] What changes downstream if this holds up?
[G] Two things carried forward. First, answer format is a first-class variable in benchmark design, not a convenience choice made by whoever has to write the grader. If you report one aggregate number over mixed formats, you have averaged away your most informative axis.
[S] And second, for my money, the grader-bias pair. An over-crediting rubric grader and an under-crediting equivalence checker, in the same paper, on the same subsets. Anyone deploying an automated judge should measure which direction their bias runs before trusting a single score it produces.
[O] The other line that has aged well is the honesty of the limitations. The authors say plainly that a model solving this benchmark perfectly could still be much worse than most educated people in many respects. That is a benchmark paper declining to overclaim its own construct validity, which was not the norm.
[G] My one-sentence takeaway is the paper's own. ARB shows that mid twenty twenty-three models handled multiple choice at graduate-adjacent difficulty far better than they handled producing numerical, symbolic or proof-like answers, and it offers rubric-based grading as a promising but unproven way to score the hard formats.
[O] Mine: the format axis was the right thing to isolate, and it is why a small hand-curated benchmark from twenty twenty-three still reads well.
[S] Mine: quote nothing from this paper without naming both the domain and the answer format, and treat the rubric result as a study of graders, not a measurement of capability.
[O] The full writeup, with the figures, the tables and the references, is on the litsearch site. Thanks Sloane.
