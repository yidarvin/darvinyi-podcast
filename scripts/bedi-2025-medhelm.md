---
slug: bedi-2025-medhelm
title: "MedHELM: Holistic Evaluation of Large Language Models for Medical Tasks"
description: "Stanford's HELM recipe applied to medicine — a clinician-validated taxonomy of clinical work, thirty-five benchmarks built to cover it, and an LLM jury whose headline validation number only survives when you pool it."
date: 2026-07-31
guest_name: "Nadia"
guest_voice: "bf_isabella"
---
[S] Here is a sentence from the abstract of a Stanford led medical evaluation paper. Reasoning models lead, but Claude three point five Sonnet achieved comparable results at forty percent lower estimated computational cost. Now open that paper's own cost table. The gap is thirteen percent.
[O] And that is one number in one abstract, attached to a paper whose real contribution is a clinician validated map of what doctors actually do all day, plus thirty five benchmarks engineered to cover every corner of that map. I do not want a bad percentage in an abstract to eat the infrastructure.
[S] It will not eat it. But when a headline number and the table underneath it disagree by a factor of three, I want that said out loud before we admire anything else.
[G] You are both correct, and the useful part is that you are correct about different levels of this paper. Keeping those levels apart is the whole episode.
[O] Welcome to Litsearch Audio. Today it is MedHELM, Holistic Evaluation of Large Language Models for Medical Tasks, from Bedi, Cui, Fuentes, Unell, Wornow and colleagues, a Stanford led consortium with eighty one authors, most of them clinicians. It is on arXiv, posted last spring.
[S] It is on the docket because it is the most serious attempt yet to benchmark medical language models on the work that fills a clinician's day, rather than on the exam they took to get the job.
[O] And our guest today is Nadia, who has read this one down to the appendix tables. Nadia, welcome.
[G] Thank you. And I want to plant a flag before we start, because this paper is unusually easy to misquote. There are three separate levels here that a listener will collapse if we let them.
[S] Name them.
[G] Level one is the taxonomy. Five clinical categories. A number attached to one category is not a number about the model overall. Level two is benchmark provenance. Thirty five datasets, and they are not all equally available. Level three is the grading method. There is an LLM jury, and it was validated against clinician ratings, which means a jury agreement number tells you about the grader, not about the model being graded.
[O] That last one is the one I would have fumbled.
[G] Everyone fumbles that one. Every number today gets its level named, and where both apply, its model and its dataset named too.
[S] Then let us start at the gap. Why does medicine need another benchmark at all.
[G] Because the existing one is finished. The paper's introduction points at licensing exam performance, MedQA style questions, where models are essentially at ceiling, near ninety nine percent. Optimizing that number further tells you nothing.
[O] Right, and the sharper version of the complaint is in the authors' own prior work. They ran a systematic review in JAMA, which this paper cites, and found that only about five percent of published healthcare language model evaluations use real electronic health record data. Roughly sixty four percent test nothing beyond licensing exams and diagnostic tasks.
[S] So the field has been grading itself on the smallest, cleanest slice of the job.
[G] And a synthetic slice. Exam vignettes are written to be answerable. Real clinical text has shorthand, missing context, contradictions, and a note that was dictated at the end of a shift. Writing a discharge summary, triaging a patient portal message, drafting a prior authorization letter, assigning billing codes — almost none of that was benchmarked at all.
[O] What about HealthBench. That came out the same month from OpenAI, and it is not exam questions.
[G] It is not, and the paper engages with it directly. HealthBench scores five thousand single turn free text conversations. And I want to be precise, because this gets garbled constantly. The five thousand is a count of conversations. Those conversations are graded against physician authored rubrics. It is not five thousand rubrics.
[S] Noted. So what is MedHELM's objection to it.
[G] Two things. First, HealthBench models the system as acting alone, like a direct to patient advice line, with no follow up questions and no human oversight — not as an assistive copilot inside an iterative workflow. Second, and this is the structural objection, there is no task taxonomy behind it. So you cannot say which parts of clinical work it covers and which it misses.
[O] Which is exactly the question MedHELM sets out to answer. Taxonomy first, then build the benchmarks to cover it.
[G] Yes. That ordering is the paper's actual method contribution, and it is the part I would defend hardest.
[S] Walk me through how the taxonomy gets built, because taxonomy papers are usually where rigor goes to die.
[G] They started from the tasks in their own JAMA review. One clinician co-author reorganized those into ninety eight tasks, twenty one subcategories, five top level categories. Then twenty nine practicing clinicians across fourteen medical specialties took a two part survey, about thirty minutes.
[O] What did the survey actually test.
[G] Two things. First, sort each subcategory into its parent category — a structural check. Clinicians placed them correctly ninety six point seven percent of the time, which the authors read as evidence the structure mirrors how clinicians organize their own work. Second, rate the taxonomy's comprehensiveness on a one to five scale. Mean of four point two one out of five, with one hundred and seven free text suggestions.
[S] And the suggestions moved it.
[G] They did. The final taxonomy is five categories, twenty two subcategories, one hundred twenty one tasks. The five categories are Clinical Decision Support, Clinical Note Generation, Patient Communication and Education, Medical Research Assistance, and Administration and Workflow. Hold those, because every category level number today attaches to one of them.
[O] Then the suite. Thirty five benchmarks, and the claim is complete coverage.
[G] Every one of the twenty two subcategories gets at least one benchmark. That is what complete coverage means here. The suite is assembled three ways. Seventeen existing benchmarks pulled from public or gated sources — HeadQA, Medbullets, A C I Bench, PubMedQA. Five reformulated from medical datasets that existed but had never been turned into evaluations, by adding standardized prompts, contexts and metrics. And thirteen genuinely new benchmarks, twelve of them built on electronic health record data.
[S] Why thirteen new ones.
[G] Because Administration and Workflow had almost nothing. Referral triage, billing code assignment, scheduling. Those were curated with Stanford Health Care. That is the category the authors went out and built datasets for because none existed.
[O] And of the thirty five, how many are open ended versus closed.
[G] Thirteen open ended, meaning free text generation like drafting a note or a patient message. Twenty two closed ended, exact match or classification. That split matters in a minute, when we get to grading.
[S] Here is my provenance question, and I think it is the most important structural fact about this suite. Can I download these.
[G] Some of them. This is level two, and the numbers are precise. Fourteen public. Seven gated, meaning you apply for approval. Fourteen private, not publicly released at all.
[O] Fourteen out of thirty five withheld. That is forty percent of the suite you cannot see, and I say that number carefully since we are already suspicious of forty percent today.
[G] And the paper is explicit about why, in a footnote on page three. I will read the reason as written. For privacy and regulatory compliance, as well as to prevent inclusion in LLM training data, fourteen datasets are not publicly released.
[S] Two reasons in one sentence, and they are doing very different work.
[G] Correct. The privacy reason is obvious — these are real patient records on a HIPAA compliant cluster. The second reason is a contamination defense, and it is prospective. They are keeping these datasets out of future pretraining corpora by never publishing them.
[O] Which is a real design choice, not a hedge. If you want a benchmark that stays hard for the next model generation, not publishing it is the only thing that reliably works.
[S] And it is simultaneously the thing that makes fourteen of the thirty five results unreproducible by anyone outside Stanford. You cannot have both. That is a genuine tradeoff and I want it labeled as a tradeoff, not as a feature.
[G] The paper does label it as a design choice with an explicit rationale. It does not, anywhere, weigh the reproducibility cost against the contamination benefit. That analysis is absent.
[O] Fine. Level three. The grading.
[G] Closed ended benchmarks get exact match accuracy, or micro F one where the task is multi label — I C D ten code assignment, for instance. The thirteen open ended benchmarks get a three model jury.
[S] Which three.
[G] G P T four oh, Claude three point seven Sonnet, and Llama three point three seventy B. Each judge rates a response one to five on three axes — accuracy, completeness, and clarity. Nine ratings total, three judges times three axes, and the final score is the mean of all nine. For one benchmark, NoteExtract, there is no gold standard response, so completeness is swapped for structure.
[O] And why an odd numbered panel of three.
[G] The paper cites prior work that odd numbered panels reduce ties while maintaining reliability. The composition rationale is a separate sentence, and I will read it exactly because we come back to it. The jury composition was chosen to represent diverse model architectures and training approaches, minimizing systematic bias from any single provider.
[S] Hold that thought. First: does the jury work.
[G] This is the validation study, and here is where I need everyone to keep level three straight. They collected independent ratings from twenty clinicians on a fifty six instance subset — thirty one instances from A C I Bench, twenty five from Mediqa Q A. Then they compared jury scores to clinician scores using an intraclass correlation, I C C three k, after z scoring each rater to remove individual scale bias.
[O] And the headline is that the jury beats the clinicians.
[G] The headline is that pooled across both benchmarks, the jury reaches an I C C of point four seven four against clinician ratings. Clinician to clinician agreement on the same instances is point four two six. Rouge L is point three six one. Bert Score F is point four four one. So in that pooled row, the jury is the highest of the four.
[S] And in the rows that are not pooled.
[G] Different story, and this is the part I would not repeat unqualified. On A C I Bench alone, thirty one instances, the jury is point three zero five. Rouge L is point four four five. Clinician to clinician is point four five eight. The jury trails both — the two things it is supposed to beat.
[O] That is worse than I expected.
[G] On Mediqa Q A, twenty five instances, the jury is point six two five, which does beat Rouge L at point three four three and the clinician baseline at point five two zero. But Bert Score F is point six six eight. So the jury loses there too, to a different comparator.
[S] So on each individual benchmark, something beats it, and only in the pooled average does it beat everything at once.
[G] That is exactly the situation. And the paper's discussion says, quoting, by beating clinician clinician agreement, this approach enables scalable evaluation of open ended model outputs. That sentence is true of the pooled row and of no individual row.
[O] Does the paper say how the pooled row is computed from the two benchmark rows.
[G] It does not. Fifty six pooled instances, thirty one plus twenty five, but the aggregation is not described.
[S] And this jury grades thirteen open ended benchmarks in the leaderboard.
[G] Validated on two of them. The paper says this itself in the limitations — the jury was validated on only two benchmarks, and expanding clinician annotation would strengthen the estimates. What it does not flag is that even on those two, the headline does not hold per benchmark.
[O] Let me pull us back up to the model results, because I do not want the leaderboard to vanish under the caveats. Who wins.
[G] Nine frontier models, temperature zero, uniform prompting. Deep Seek R one wins the most, sixty six percent of head to head comparisons, macro average of point seven five. Oh three mini is next at sixty four percent, but posts the single highest macro average, point seven seven, driven by Clinical Decision Support.
[S] Win rate and macro average are not the same metric.
[G] They are not, and that is a real trap in this table. Win rate is the share of benchmark by opponent pairs where a model's normalized score at least matches. Macro average is the unweighted mean normalized score across all thirty five. Deep Seek R one leads one, oh three mini leads the other.
[O] And below them.
[G] The two Claude Sonnets, sixty three and sixty four percent, identical macro averages of point seven three. G P T four oh at fifty seven percent. Gemini two point oh Flash at forty two. G P T four oh mini at thirty nine. Llama three point three seventy B at thirty. Gemini one point five Pro last, twenty four percent.
[S] What about consistency. There is a win rate standard deviation column.
[G] There is, and here is a trap I want to defuse because it has caught people. The paper describes Deep Seek R one as having a low win standard deviation, point one zero. Low, not lowest. The lowest belongs to Gemini one point five Pro at point zero eight — the last place model. The paper's own figure caption says it: Gemini one point five Pro ranked lowest with twenty four percent wins but had the lowest win standard deviation, showing the most consistent competitive performance.
[O] So the most consistent model is the worst one. It loses very reliably.
[G] Consistency is not quality. It is variance.
[S] Now the categories, and I want the level named every time.
[G] Category level, all of it. Across the five categories, every model scores highest in the two free text categories. Clinical Note Generation ranges point seven four to point eight five across the nine models. Patient Communication and Education, point seven six to point eight nine. Then Medical Research Assistance, point six five to point seven five. Clinical Decision Support, point six one to point seven six. Worst is Administration and Workflow, point five three to point six three.
[O] The paper hedges that to most models, I thought.
[G] The prose says most models. I checked all forty five cells of that figure — nine models times five categories — and for every single one of the nine, the top two categories are Clinical Note Generation and Patient Communication and Education. So the figure actually supports the stronger claim than the prose makes.
[S] That is a rare direction for a correction to run.
[O] And the narrowest spread is Administration and Workflow, since everyone is bad at it.
[G] Careful. That is the other superlative trap in this paper. Administration and Workflow spans point one zero, from point five three to point six three. Medical Research Assistance also spans point one zero, from point six five to point seven five. They are tied. Clinical Note Generation is point one one, Patient Communication point one three, Clinical Decision Support point one five.
[S] So Administration and Workflow is the lowest band, not the narrowest one on its own.
[G] Correct. Lowest and tied narrowest. Two different claims.
[O] What is the story on why administration is so bad. That is the category they built new datasets for.
[G] The paper's own explanation is distributional — administrative workflows use data types unlikely to appear in pretraining. Llama three point three posts the single lowest Administration and Workflow score of any model, point five three, while sitting at a respectable point eight one in Patient Communication. So it is not a general capability gap in that model.
[S] Take me to cost, since that is where we opened.
[G] Total cost per model, benchmark runs plus jury grading, all thirty five benchmarks, upper bound estimates using maximum output tokens, priced as of the twelfth of May, twenty twenty five. The range runs from eight hundred four dollars and seventy four cents to one thousand eight hundred six dollars and seventeen cents. One full nine model leaderboard refresh is estimated at eleven thousand seven hundred thirty nine dollars.
[O] So cheap models are cheap and bad, expensive models are expensive and good.
[G] No, and this is the genuinely interesting finding underneath the bad abstract number. The two cheapest models are G P T four oh mini at eight hundred four dollars and Gemini two point oh Flash at eight hundred fourteen dollars. Their win rates are thirty nine and forty two percent.
[S] Which is low.
[G] Which is not the lowest. The two lowest win rates belong to more expensive models. Gemini one point five Pro, twenty four percent, at one thousand one hundred thirty one dollars. Llama three point three, thirty percent, at nine hundred thirty nine dollars. Both cost more than either cheap model and win less than both of them.
[O] So the cheapest models winning the least is simply false.
[G] It is false, and it is the kind of thing everyone assumes. Cost is not monotonic with performance here.
[S] Now the forty percent.
[G] I went through this exhaustively, and I will give you the full ledger, because a specific checkable discrepancy is a different animal from a general accusation. Claude three point five Sonnet total cost, one thousand five hundred seventy dollars and eighty eight cents. Deep Seek R one, one thousand eight hundred six dollars and seventeen cents. That is thirteen percent lower, not forty.
[O] And against oh three mini.
[G] One thousand seven hundred twenty two dollars. Eight point eight percent lower. Against the mean of the two reasoning models, eleven percent lower. If you split total cost into its two components, Claude is eight point two percent lower than Deep Seek on benchmark cost, and two point one percent higher than oh three mini on benchmark cost. On jury cost, about seventeen percent lower against each. On cost per unit of win rate against Deep Seek, about eight point nine percent.
[S] Not one of those is forty.
[G] Not one. And the appendix list prices run the other way — Claude three point five Sonnet is three dollars per million input tokens and fifteen dollars per million output, against one dollar twenty and four dollars eighty four for both reasoning models. That is two and a half to three times more expensive per token.
[O] Could it be a rounding artifact.
[G] No. The cost table prints cents. And the word forty appears exactly once in the entire paper, in that abstract sentence. The body text, section two point three point three, only says the Claude models provide a good cost performance balance at reduced costs, with no percentage attached.
[S] So the qualitative claim is fine and the number is not supported by the authors' own table.
[G] That is the precise shape of it. One number in an abstract that the paper's own tables do not support. I would not extrapolate from it to the paper being unreliable — everything else I checked reconciled, including all five category ranges and every row sum in the cost table.
[O] Then let me make the optimist case, and I am going to make it about infrastructure rather than about the leaderboard. Nobody had a validated map of clinical work before this. Ninety six point seven percent structural agreement from twenty nine clinicians, four point two one out of five on comprehensiveness, one hundred twenty one tasks, and then thirty five benchmarks engineered so that every one of the twenty two subcategories is covered. That is the thing that outlives this model generation.
[S] I will grant the taxonomy without argument. Here is my deflationary case, and it is three items. One, the grader is validated on two of thirteen open ended benchmarks and does not beat every comparator on either one individually. Two, fourteen of thirty five datasets are unreproducible outside the institution that made them. Three, three of the nine models being ranked are also the three members of the jury doing the ranking.
[O] Say that third one again.
[G] It is accurate. G P T four oh, Claude three point seven Sonnet, and Llama three point three seventy B are simultaneously jury members and ranked contestants. I verified this across the appendices. And the paper reports no self preference check. Its only stated rationale is the sentence I read earlier — chosen to represent diverse model architectures, minimizing systematic bias from any single provider.
[S] That is a design argument, not a measurement.
[G] It is a design argument. The paper never reports whether those three models score their own outputs differently than they score the other six. Self preference in judge setups is documented in the literature this paper itself cites — the replacing judges with juries work. The diversity argument is a reasonable prior. It is not evidence.
[O] I will concede that one. It is a cheap ablation and it is missing.
[S] What about contamination on the public side.
[G] Here I want to be exact, because the sloppy version of this criticism is wrong. The words contamination, decontamination and memorization appear nowhere in the paper — I checked with normalized text, so hyphenation across line breaks and ligatures are not hiding a hit. The paper's only contamination facing measure is the prospective one we discussed: withholding fourteen datasets so they never enter training corpora.
[O] Which does nothing for the fourteen public ones.
[G] Nothing at all. HeadQA, Medbullets, PubMedQA are established public datasets plausibly sitting in frontier pretraining corpora already. No decontamination check, no contamination analysis is reported for any of them. That is the specific gap — not that the authors never thought about training data, because the withholding footnote proves they did, but that the diagnostic half is absent.
[S] Score it for me, Nadia. Where does each of us land.
[G] The optimist wins on the taxonomy and the coverage argument outright — that work is real, documented, and validated in the way a taxonomy can be validated. The optimist also wins on cost being non monotonic, which is a genuine finding. The skeptic wins on the jury: validated on two of thirteen, mixed per benchmark, and judging three of its own contestants without a self preference check. The skeptic wins on the forty percent, narrowly and specifically. On the private datasets I score it a draw, because it is a real tradeoff both of you described accurately.
[O] What would move you.
[G] Clinician annotation extended past two benchmarks, which the authors say themselves. A jury composition ablation that excludes judges from also being ranked. An explicit contamination check on the fourteen public datasets. And a corrected or removed forty percent.
[S] What does the paper do well on the statistics side that we have not mentioned.
[G] There is a minimum detectable effect analysis in the appendix, per benchmark, ranging from point zero zero seven to point zero nine two across the thirty five. That is a real strength — it tells you which benchmarks can actually resolve a difference between two models and which cannot. Run to run variance at temperature zero is not reported, which is a separate gap.
[O] For me the implication is about how you build an evaluation at all. Start from a validated map of the work, then commission datasets for the empty regions. That is the opposite of how benchmark suites normally get assembled, which is from whatever datasets happened to be lying around.
[S] My implication is narrower and it is about judges. This paper does the thing almost nobody does — it actually validates its LLM grader against humans and prints the table. And the moment it prints the table, you can see the headline only survives pooling. I would rather have that visible failure than a suite that never checked at all.
[G] The paper's own takeaway, as I read it, is that exam accuracy was the wrong target and here is a defensible replacement target, covering one hundred twenty one clinical tasks with a mix of public, gated, and private data. Treat the closed ended results as solid, and treat the open ended results as resting on a grader validated in two places out of thirteen.
[O] Mine is that the infrastructure is the contribution and it will outlast every model in the table.
[S] And mine is that when you read this leaderboard, name the level. A category number is not an overall number, a jury agreement number is about the jury, and forty percent is about nothing at all.
[G] The full writeup on the litsearch site has the tables, the figures, and the cost breakdown line by line if you want to check any of this yourself. It is worth checking. We did.
