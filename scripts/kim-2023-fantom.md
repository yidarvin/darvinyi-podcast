---
slug: kim-2023-fantom
title: "FANToM: A Benchmark for Stress-testing Machine Theory of Mind in Interactions"
description: "Characters step out of a group chat and come back. Six differently-shaped questions about the same missed fact. GPT-4 answers one of them at seventy three percent — and gets all six right twelve percent of the time."
date: 2026-07-26
guest_name: "Elliot"
guest_voice: "am_puck"
---
[O] GPT-4 answers the belief question on this benchmark at seventy three point three percent. That is a model correctly tracking what someone who stepped out of the room does not know.
[S] The same model, the same conversations, the same underlying fact. Ask it in five different shapes instead of one and require it to be right about all of them. Twelve point three percent.
[O] So either that is a devastating result about machine social reasoning, or it is what happens when you multiply five imperfect numbers together.
[S] That is the entire episode, and I want to know which one it is before we finish.
[O] Welcome to Litsearch Audio, where an optimist, a skeptic, and a visiting scholar take one paper apart. Our guest today is Elliot.
[S] The paper is FANToM, a benchmark for stress-testing machine theory of mind in interactions. Hyunwoo Kim, Melanie Sclar, Xuhui Zhou, Ronan Le Bras, Gunhee Kim, Yejin Choi, and Maarten Sap. Allen Institute for AI, University of Washington, Carnegie Mellon, and Seoul National. EMNLP twenty twenty three.
[O] Elliot, welcome. The word the paper coins is illusory theory of mind. Give us the one-sentence version.
[G] Illusory theory of mind is when a model answers one phrasing of a mental-state question correctly and fails a differently-phrased question that requires exactly the same inference. The paper's argument is that if that happens, the first success was never evidence of belief tracking. It was evidence of a phrasing the model handles.
[S] Which is a claim about every single-format benchmark in this literature.
[G] It is. And that is the more important contribution here, more than the leaderboard.
[O] Then start with why conversations. Theory of mind has been evaluated on narratives for years. ToMi, Social IQa, the whole Sally-Anne lineage.
[G] Two objections in the paper. The first is reporting bias, and they give a sharp example. A narrative written for a theory of mind test might contain the sentence, Carlos did not see this, so he does not know where the apple is. That sentence hands the model the exact mental state it is supposed to infer. A curator decided what to include, and the inclusion itself is a signal.
[S] That is a real problem. Narratives are compressed reports, and compression is editorial.
[G] The second objection is that narratives are static. Theory of mind matters most in live interaction, where you reason through intermediate steps from scratch and nobody annotates the gaps for you.
[O] So the move is to put the test inside a conversation.
[G] Inside a multiparty conversation with information asymmetry that is structural rather than stated. Characters leave the conversation and rejoin it. Whatever was said while a character was away is inaccessible to that character. Nobody ever writes down that they missed it.
[S] Before the construction, I want the theoretical scaffolding, because the paper leans on it hard.
[G] They take two criteria from Quesque and Rossetti, twenty twenty, on what a valid theory of mind task requires. The first is non-merging. The evaluation has to force a real gap between what the respondent believes and what the other party believes. If both believe the remote is on the sofa, and you answer sofa, nobody can tell whether you reasoned about the other mind or just reported your own.
[O] And information asymmetry manufactures that gap.
[G] Deliberately. The model gets the whole conversation as input, so it is an omniscient observer. The absent character is not. The two mental states are guaranteed distinct with respect to that information.
[S] And the second criterion.
[G] Mentalizing. A lower-level process must not explain the success. If the correct answer has high word overlap with a salient part of the input, you cannot distinguish mental-state reasoning from pattern matching. So FANToM does something I think is genuinely clever. It deliberately designs the wrong answers to have more word overlap with the conversation than the right ones.
[O] That is adversarial in the right direction. The lazy heuristic is made actively harmful.
[S] Fine. How are the conversations actually made, because I am assuming a language model made them.
[G] InstructGPT davinci-003 generates the full conversations. Small talk on topics like pets, risk-taking, personal growth, each topic with several subtopics. It starts with two or three characters and goes up to five present at once. Characters are scripted to leave with an explicit utterance, drawn from a predefined list of sixty four reasons for leaving, and to rejoin with something like, I am back, what are you guys discussing now.
[S] Sixty four reasons is an oddly specific piece of engineering.
[G] It is in the appendix. Coffee break, parking meter expiring, pet needs attention. It is there so the leaving utterance does not become its own template artifact.
[O] And then you need to know exactly what the absent character missed.
[G] That is the step I would flag as load-bearing. They prompt GPT-4, the March twenty twenty three snapshot, with the previous conversation and the current one, separated by an inserted marker that says PersonX joined the conversation, and they ask what was shared before PersonX joined but not mentioned after. The paper notes that inserting that marker measurably improved the output quality.
[S] So the ground truth about what was missed is itself a GPT-4 summary. Hold that thought.
[G] Hold it, because we come back to it and it is more nuanced than it looks.
[O] Walk us through the question set, because six formats over one fact is the actual apparatus.
[G] It starts with a fact question. GPT-4 generates three non-yes-or-no fact questions from the missed information. What is the breed of Linda's dog. Then two answers for each. The full fact answer, grounded in the conversation the character missed. Linda has a golden retriever. And the limited fact answer, grounded only in what that character actually witnessed. There is no information on the breed of Linda's dog.
[S] And that pair becomes the belief question's two options.
[G] Rephrased into belief form. Kailey believes Linda has a golden retriever, which they call the omniscient-view belief. And Kailey does not know the breed, the PersonX-centric belief. The correct answer is always the PersonX-centric one.
[O] So the six types.
[G] One, belief question distance, free-form. Two, belief question choice, the same question as a forced binary. Three, answerability question list. List all the characters who know the correct answer to this question. Four, info accessibility question list. You are given the full fact answer and asked to list all characters who know this information. And five and six, the yes-no versions of both, asked once per character present.
[S] Why both a list and a yes-no version of the same thing.
[G] Because that pair is the illusory theory of mind detector. They are the same question. A model that has a belief state should answer them identically. The paper's finding is that models do not.
[O] And answerability versus info accessibility differ how, exactly.
[G] Reasoning depth. Answerability requires two steps. Work out the answer, then work out who has access to it. Info accessibility hands you the answer directly, so only the second step remains. That gives a clean complexity contrast between two otherwise identical questions.
[S] Scoring.
[G] Accuracy for the two belief questions and the two list questions, weighted F one for the yes-no formats. The list questions get no partial credit. Every character must be correctly included and every character correctly excluded.
[O] And the free-form belief question is scored how, because free-form scoring is where benchmarks go to die.
[G] Cosine distance between SentenceBERT embeddings of the response and each of the two options. A correct response has to be closer to the PersonX-centric belief. And because a nonsense response, repeating character names for instance, can land deceptively close, they also compute token F one on the responses that passed the distance check. The paper is explicit that a model must do well on both.
[S] Now the two aggregates, and I want these separated cleanly because I think people conflate them.
[G] They should be separated. The paper writes the strict one as ALL with an asterisk, and it requires the model to answer all six question types correctly for the same piece of information. The plain ALL score is that minus the free-form belief question, so five types. ALL is the one they compare against humans, because humans were never asked the free-form belief question.
[O] So every human-versus-model headline number is the five-type ALL, not the six-type one.
[G] Correct, and that distinction matters more than it sounds. Hold onto it.
[S] Scale and validation.
[G] Two hundred fifty six conversations, roughly ten thousand questions. One thousand four hundred fifteen of each belief question type. Seven hundred three each of fact, answerability list, and info access list. And two thousand six hundred eighty nine each of the two yes-no types, because those iterate over every character present.
[O] And the conversations are substantially longer than the prior benchmark.
[G] Thirteen point eight turns for the short input, twenty one point nine words per turn. The paper's reference point for ToMi is four point nine turns. It is a different scale of context entirely.
[S] Human validation.
[G] Thirty two Mechanical Turk annotators who passed a qualification test, three per conversation, flagging incoherence and unsafe content. Ten conversations got some incoherence votes, none by majority, and all ten were refined anyway. None were flagged unsafe. Separately, workers verified the answer options for the multiple-choice belief question, and roughly eight point six percent of question sets were discarded as erroneous.
[S] Only the choice question. Note that.
[G] Note it. I will come back to it.
[O] Results. Thirteen instruction-tuned models. Give me the headline.
[G] Short conversation input. Humans score eighty seven point five on the five-type ALL, ninety three point eight on the choice belief question, and ninety point six on both list questions. GPT-4 zero six one three, evaluated in June, is the strongest model. Seventy three point three on the choice belief question, thirty seven point eight and thirty six point four on the two list questions, and twelve point three on ALL.
[S] And the six-type version.
[G] Eight point two.
[O] What about the other GPT-4.
[G] This is the part I find most interesting for evaluation practice. The same model identifier, zero six one three, evaluated again in October, scores sixty eight point four on the choice question but four point one on ALL and two point four on the strict six-type score. The paper reports both snapshots and does not explain the gap.
[S] Same model name, three times the aggregate score four months apart. That should terrify anyone who has ever cited a GPT-4 number without a date.
[O] I will concede that fully. That is a genuine methodological finding hiding in a results table.
[G] Below GPT-4 it collapses. ChatGPT zero six one three scores fifty three point five on the choice question and zero point one on ALL. Falcon Instruct forty B scores fifty four point three on the choice question and zero point zero.
[S] There it is. That is the whole illusory theory of mind argument in two numbers, and it is also exactly where I get suspicious. Fifty four on one format and zero on the conjunction of five is what you would predict from a model answering each format semi-independently at moderate accuracy.
[G] That is the right objection and the paper has a partial answer, which is the second finding. Look at the choice belief question against the random baseline. It is a binary choice, so random is fifty. Mistral Instruct scores twenty seven point six. InstructGPT davinci-003 scores seventeen point seven. GPT-4 zero three one four scores thirty nine point zero.
[O] Those are all below chance.
[G] Substantially below chance, and that is not noise. It is the mentalizing design working. The wrong option has higher word overlap with the conversation by construction, and models are systematically pulled to it. That is not a model answering independently at moderate accuracy. That is a model reliably answering wrong.
[S] All right, that lands. A below-chance binary score is a real signal, not a scoring artifact.
[O] There is a second comparison I want, the one about facts versus beliefs.
[G] And I want to be careful about the metrics here, because the figure mixes them. The fact question is reported as token F one, word overlap between the response and the answer. The free-form belief question is reported as accuracy, the distance metric. Those are different scales and the figure puts them on the same axis.
[S] So what does the comparison actually show.
[G] That fact recall does not predict belief tracking. InstructGPT davinci-003 gets sixty point nine token F one on the fact question but sixteen point five accuracy on the belief question. Llama-2 Chat and Mistral Instruct score lower on the fact question, fifty two point seven and fifty six point six, and higher on the belief question, seventeen point eight and twenty six point two.
[O] Being good at finding the fact is uncorrelated with knowing whose fact it is not.
[G] The sharpest instance is GPT-4 zero three one four. It has the highest fact question token F one of any model tested, seventy seven point six. Its strict six-type score is zero point four.
[S] That is the best number in the paper and it is not the headline.
[O] Does chain of thought fix it.
[G] It helps and it does not close the gap. GPT-4 June with chain of thought goes from twelve point three to twenty six point six on ALL, and from eight point two to eighteen point four on the six-type score. Its combined answerability score reaches forty point two and its combined info access score fifty seven point seven, against humans at ninety point six on both.
[S] And it does not help everyone.
[G] It actively hurts some models on consistency. Llama-2 Chat seventy B drops from twenty seven point one to fifteen point two on the per-character all-six score when chain of thought is applied, and its answer consistency drops from forty three point three to twenty four point three.
[O] Why would reasoning aloud make a model less consistent.
[G] The error analysis gives a mechanism. On the list questions, the dominant error without chain of thought is including characters who are unaware. Chain of thought reduces that error and increases the opposite one, excluding characters who are aware. So it is not uniformly improving the belief model. It is shifting where the model's caution sits.
[S] That is a much more useful finding than the aggregate delta.
[O] What about fine-tuning. The paper says fine-tuning can beat humans on individual question types.
[G] The introduction says that, and I want to flag a discrepancy, because the table does not obviously support it. Fine-tuned Flan-T5-XL reaches fifty three point seven on ALL, twenty six point five on the strict six-type score. On individual types it gets ninety three point four on the choice belief question against a human ninety three point eight, seventy eight point seven on the answerability list against a human ninety point six, and seventy five point zero on the info access list against ninety point six.
[S] So none of those exceed the human number.
[G] None of them, on the short context. And the paper's own footnote softens the claim to comparable with human performance rather than higher. The stronger phrasing is in the introduction. I would trust the table.
[O] That is a fair catch, and it is the kind of thing that gets repeated as a fact.
[S] Two more breakdowns and then I want the argument.
[G] Reasoning complexity holds up cleanly. On the yes-no formats, models consistently do worse on answerability, the two-step question, than on info accessibility, the one-step question. GPT-4 October, seventy five point seven against ninety one point five. GPT-4 June, eighty five point nine against ninety point three. Llama-2, sixty one point four against eighty point four. The ordering does not reliably hold on the harder list versions, and the paper's own explanation is that models struggle so much there that no pattern survives.
[O] And belief order.
[G] Models do better on second-order beliefs than first-order, which echoes a pattern Le and colleagues found on ToMi. Within second-order, they split cyclic, meaning A's belief about B's belief about A, from acyclic, which tracks a third character. The general pattern is cyclic beats acyclic, because acyclic requires tracking one more person. Mistral Instruct is thirty five point five cyclic against twenty five point one acyclic.
[S] General pattern. Say the exception.
[G] GPT-4 June is the exception and it goes both ways. Without chain of thought it is better on acyclic, sixty seven point one, than cyclic, sixty six point three. With chain of thought it flips back in line, cyclic sixty nine point one and acyclic sixty six point zero. Which also contradicts the paper's stated trend that chain of thought helps acyclic more, since for GPT-4 June it raised cyclic and lowered acyclic. ChatGPT goes the same wrong direction.
[O] So the belief-order story is directional, not universal.
[G] Directional. And one more caveat I would put on that whole table. The paper labels it belief question results without stating which of the two belief metrics it aggregates. I could not resolve it from the numbers.
[S] Then let me start the argument, because I have three objections and I want them scored.
[O] Go.
[S] One. This benchmark is entirely synthetic and generated by the model family that tops it. Conversations from InstructGPT davinci-003. Fact questions, both fact answers, and the belief questions and options, all from GPT-4. The only human verification covers conversation coherence and the multiple-choice belief options. Any systematic GPT-4 error becomes ground truth.
[G] Partly sustained and partly not, and the split matters. The belief and fact answers are GPT-4 authored, and the free-form belief question is not described as independently verified anywhere. That is a real hole. But the list questions are not model-authored at all. Who knows the answer falls out mechanically from the scripted leave-and-rejoin structure. Those gold labels are deterministic.
[O] Which is convenient, because the list questions are where the models fail hardest.
[G] Thirty seven point eight for the best model against a human ninety point six, on labels that a script generated. That failure cannot be a GPT-4 annotation artifact.
[S] Two. Home-field advantage. The entire linguistic distribution of this benchmark comes from OpenAI models, and OpenAI models win. That is a confound with nothing to do with theory of mind.
[G] I score that one against you, and on the paper's own numbers. GPT-4 zero three one four wrote the labels. It scores zero point four on the strict six-type metric and thirty nine point zero on the choice belief question, which is below random. The model that authored the ground truth cannot answer the questions it authored.
[S] That is a genuinely good rebuttal and I did not have it. I will still say the paper should have run the pipeline with a disjoint generator family to close it properly, but the strong form of my objection is dead.
[O] Third objection.
[S] The human baseline. Eleven student volunteers, thirty two question sets total, one person per set. And every human number in that table is a multiple of one thirty-second. Ninety three point eight is thirty of thirty two. Ninety point six is twenty nine of thirty two. Eighty seven point five is twenty eight of thirty two.
[G] That is correct, and it is my read going slightly beyond what the paper states. It follows from the sample size they report.
[S] So a single differently-answered question moves the human bar by three points. And there is a worse version. Humans were never asked the yes-no formats. The paper says so explicitly. But the ALL score they compare against requires five types, including both yes-no types.
[G] And this is where I think the paper genuinely underspecifies. It never states how the human ALL was computed. Given the humans only answered three of the five, the human eighty seven point five cannot be requiring the same five-way conjunction the models face. Twenty eight of thirty two is consistent with a conjunction over the three types they were asked.
[O] Which would make the flagship comparison a three-way conjunction against a five-way one.
[G] Which would inflate the gap. The paper does not answer that question, and I think it should have.
[S] Then the headline, that models trail humans by more than seventy percent on average, is doing more work than it has earned.
[G] On the aggregate metrics, I sustain that. On the individual question types, where humans and models answered identical questions, the gap stands untouched. Ninety three point eight against seventy three point three on the choice question. Ninety point six against thirty seven point eight on the answerability list. Those are clean.
[O] Let me make the optimist case, because I think it survives all three of those.
[S] Make it.
[O] The contribution is not the leaderboard. It is the instrument. Six question shapes over one fact, scored conjunctively, is a reusable design that any benchmark can adopt, and it detects something no single-format benchmark can even represent. A model at fifty four percent on one format and zero on the conjunction is telling you the fifty four was never a capability measurement. That is worth knowing regardless of whether the human bar is thirty two questions or three thousand.
[S] I accept the instrument. What I reject is reading the near-zero scores as a calibrated measure of how much theory of mind a model has. And I have a concrete reason. Most non-fine-tuned models sit in a band from zero point zero to zero point four on the strict six-type score. That metric cannot rank them. It can only tell you they all fail.
[G] Sustained, and the paper effectively concedes it by never ranking on that metric. All the discrimination comes from the per-type breakdowns.
[O] Where does that leave the free-form belief metric, since it is the one the strict score adds.
[G] Fragile, and there is a striking example. Falcon Instruct forty B with chain of thought scores seventy two point one accuracy on the free-form belief question, higher than GPT-4 June's sixty five point three. Its token F one on the same responses is eighteen point four, against GPT-4's forty eight point two.
[S] So it is producing short degenerate text that lands near the right embedding.
[G] Which is exactly what the paper's dual metric was designed to catch, and it catches it. But the accuracy column alone would have told you Falcon beats GPT-4 at belief tracking. Its ALL score is zero point zero.
[O] Implications. What does an evaluation team take from this on Monday.
[G] The transferable idea is the conjunction. If you have a construct you care about, do not measure it once. Ask it in several formats that demand the same inference and score the intersection. The gap between any single format and the intersection is a direct measure of how much of your headline number is phrasing.
[S] And the corollary. Contamination is not the only way a benchmark score can be hollow. This benchmark is freshly synthesized, so classic pretraining leakage is essentially off the table, and the scores are still hollow, just for a different reason.
[O] The other one I would take is the version drift. Three times the aggregate score from the same model name, four months apart, is an argument for date-stamping every proprietary model number you publish.
[G] And the authors' own hedge belongs in the record. Section eight is explicit that they do not believe current models possess theory of mind, and that the term is not meant anthropomorphically. Their reading of their own results is that models rely primarily on word correlations.
[S] Limitations they name.
[G] Small talk on a narrow set of topics, one relationship type where characters have no prior knowledge of each other, English only, and text only. They point at multimodal theory of mind as the obvious next step.
[O] Takeaways. Mine first. This paper's real product is a detector, not a score, and the detector generalizes to any evaluation where you can ask the same question two ways.
[S] Mine. The near-zero aggregate is strong evidence that models are inconsistent across formats about the same belief, and weak evidence about how much theory of mind any given model has. Believe the first claim, not the second. And notice that a thirty two question human baseline is holding up the paper's most quoted sentence.
[G] The paper's own takeaway is that coherent theory of mind reasoning has not emerged in any of the thirteen models tested, that chain of thought and fine-tuning both help and neither closes the gap, and that previous reported successes on classic psychology tests may reflect pretraining exposure rather than reasoning.
[O] The full writeup is on the litsearch site, with the figures, the question-type table, and the citation map around this paper. Elliot, thank you.
[G] Thank you both.
