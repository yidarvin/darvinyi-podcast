---
slug: jia-2017-adversarial-squad
title: "Adversarial Examples for Evaluating Reading Comprehension Systems"
description: "A single human-approved sentence, quietly appended to a SQuAD paragraph without changing the right answer, collapses sixteen published reading-comprehension models from 75% F1 to 36% — while human readers barely notice it's there."
date: 2026-07-19
guest_name: "Julian"
guest_voice: "bm_george"
---

[O] Picture a leaderboard in the summer of twenty seventeen where the best reading comprehension model sits at eighty-four point seven percent F one, and the human ceiling is ninety-one point two. That gap looks like it's about to close.

[S] And then two Stanford researchers append one grammatical sentence to the end of the paragraph — a sentence that doesn't even touch the correct answer — and the same model's score collapses by nearly forty points.

[O] Which either means these models were never really reading in the first place, or it means the test was measuring the wrong thing all along.

[S] Today those sound like the same accusation to me, but let's actually find out.

[O] Welcome to Litsearch Audio. I'm your optimist host, and across the table, as always, is our skeptic.

[S] Present and skeptical, as billed.

[O] Today's paper is "Adversarial Examples for Evaluating Reading Comprehension Systems," by Robin Jia and Percy Liang, published at EMNLP in twenty seventeen. It's usually just called Adversarial SQuAD, and joining us to walk through it is a researcher who's studied this work closely, Julian. Julian, welcome.

[G] Glad to be here. This is one of those papers that's short, almost stubbornly simple in its central idea, and still gets cited constantly nine years later.

[S] Simple ideas that hold up are exactly the ones worth an hour of anyone's commute.

[O] So set the scene for us, Julian. Why did SQuAD look like a benchmark that was basically solved?

[G] The Stanford Question Answering Dataset has over one hundred seven thousand human-written questions, each answered by a span of text lifted directly from a Wikipedia paragraph. By mid-twenty seventeen the state of the art had climbed to eighty-four point seven percent F one, with the human ceiling at ninety-one point two. The leaderboard read like a countdown.

[S] A countdown to what, exactly? Passing a test isn't the same as understanding the material.

[G] That's precisely the objection the authors raise, and they weren't alone in raising it. Concurrent work by Weissenborn and colleagues had already argued that a lot of SQuAD questions are answerable by pure type- and keyword-matching — find the sentence that shares the most vocabulary with the question, then grab the nearest span of the right type: a person, a date, a number.

[O] Which would mean a model could be very good at SQuAD without doing anything you'd actually call reading.

[G] Right, and standard test-set accuracy has no way to catch that, because the test distribution never forces the model to prove otherwise. Jia and Liang's opening example is the whole argument in miniature. There's a paragraph about Super Bowl fifty, a question asking which thirty-eight-year-old quarterback played in Super Bowl thirty-three, and a strong model called BiDAF Ensemble answers correctly: John Elway.

[S] So far, so good.

[G] Then they append one sentence to the end of the paragraph: "Quarterback Jeff Dean had jersey number thirty-seven in Champ Bowl thirty-four." Nothing in that sentence contradicts the real answer. No human reader would mistake "Champ Bowl thirty-four" for "Super Bowl thirty-three." But the model switches its answer to Jeff Dean.

[O] Because the sentence echoes the question's own vocabulary — quarterback, jersey number, a bowl name that rhymes with the real one.

[G] Exactly. It's lexical overlap dressed up as an answer, and the model can't tell the difference.

[S] Okay, walk us through the actual method, Julian, because "add one sentence" undersells how deliberate this is.

[G] The framing is a generalization of standard accuracy. Instead of scoring a model on the original example — paragraph, question, answer — you score it on an adversarially perturbed version. For that number to mean anything, the adversary has two obligations: the new example has to stay valid, meaning a human would still judge the answer correct, and it has to stay reasonably close to the original.

[O] Which rules out just rewriting the whole paragraph.

[G] It also rules out the vision playbook. Adversarial images add imperceptible noise, because a tiny pixel change doesn't alter what's actually in the picture. Language doesn't work that way — change one word in a sentence and you can flip its meaning entirely. So instead of a perturbation that preserves semantics, the paper does the opposite: it takes a semantics-altering change and constrains it so the result never contradicts the answer. They call this a concatenative adversary — append one new sentence to the end of the paragraph, and leave the question and the gold answer untouched.

[S] Why the end, and not somewhere in the middle, where it might actually confuse a human reader too?

[G] Two reasons the authors give. Prepending would break the convention of the first sentence being the topic sentence, and inserting mid-paragraph risks breaking coreference — a "he" or an "it" that no longer points where it used to. Appending is the safest place to add information without a human noticing anything is wrong.

[O] And this is where the vision-versus-language framing gets sharp. It's not that the model is oversensitive, flinching at noise. It's overstable — it can't tell a sentence that actually answers the question from one that just sounds like it might.

[G] That's the paper's own term for it, and it's the right one. There are two main attacks. AddSent is the primary one, and it's a four-step pipeline. Step one mutates the question itself: swap nouns and adjectives for WordNet antonyms, swap named entities and numbers for their nearest neighbor in GloVe vector space, matched by part of speech. Step two invents a fake answer matched to the original answer's type, drawn from a hand-built list of twenty-six categories. Step three converts the mutated question plus the fake answer into a declarative sentence, using roughly fifty hand-written grammar rules over the sentence's parsed structure. Step four hands the raw sentence to five crowd workers to fix the grammar, then three more workers to filter out anything still broken or that accidentally answers the question. Only after that does the full attack query the target model on every human-approved candidate and keep whichever one hurts it worst.

[S] Hang on, Julian — doesn't querying the model during that last step stack the deck? You're handing the attacker information a real deployment adversary might not have.

[G] It's a fair worry, and the authors address it head-on with a variant called AddOneSent — completely model-blind, it just adds one already-approved sentence at random, no queries at all. It still drops BiDAF Ensemble from eighty percent down to forty-six point nine. So the shortcut isn't an artifact of query access. It's there even when the attacker gets zero information back from the model.

[O] What's the second main attack?

[G] AddAny throws out grammaticality entirely. It's a local search over ten words, six rounds of coordinate descent, greedily swapping one word at a time using the model's own predicted answer distribution as the climbing signal. The result doesn't have to be a real sentence at all. The paper's own example converges to, quote, "tesla move move other george."

[S] That's not language, that's noise that happens to share vocabulary with the question.

[G] Which is the point — it's a stronger, less constrained attack, precisely because it doesn't have to satisfy a human reader. One more variant worth naming: AddCommon restricts AddAny's word choices to the thousand most frequent words in the Brown corpus, to check whether rare or unnatural tokens were doing the work, or whether ordinary vocabulary alone is enough.

[O] So we've got four flavors of the same idea, each one stripping away a different assumption to see what's actually load-bearing.

[S] Give me the headline number.

[G] Across sixteen published, independently trained SQuAD models, AddSent drops average F one from seventy-five point four percent to thirty-six point four percent.

[O] That's the entire supposed narrowing of the human gap, gone.

[G] And it's not a cherry-picked result. Four of those models — Match-LSTM and BiDAF, single and ensemble — are what the authors developed the attack against. The other twelve were never touched during development at all: ReasoNet, Mnemonic Reader, structural embedding of dependency trees, jNet, Ruminating Reader, and more, run only afterward as a genuine held-out generalization check. None of them were robust.

[S] Was there any model that held up noticeably better than the rest?

[G] Mnemonic Reader Ensemble was the strongest under attack — seventy-nine point one percent down to forty-six point two percent, about six points ahead of the pack. The authors' guess is that its self-alignment layer, which tracks long-distance relationships across the paragraph, makes it better at gathering all the evidence for the real answer instead of just the local match. But six points ahead of a field that's collapsing is still collapsing.

[O] What about AddAny, the ungrammatical version?

[G] That one only ran on the four development models, because it needs the model's full output distribution, and not every published model exposes that. Average F one across those four falls to six point seven percent. The worst case, BiDAF Ensemble, drops all the way to two point seven percent.

[S] From eighty percent down to two point seven. That's not a benchmark result anymore, that's a coin flip that lost badly.

[G] AddCommon, restricted to only the thousand most common English words, still cuts average F one to forty-six point one percent.

[O] So even playing nice with vocabulary doesn't save the models.

[G] It doesn't. Now, the question every skeptic in the room should be asking next: did they check whether a human would also get confused by these sentences?

[S] That's exactly what I was going to ask.

[G] They did, and it's the part of the paper I'd point to as its real methodological achievement. Three crowd workers scored ninety-two point six percent F one on the original examples, and seventy-nine point five percent under AddSent — a thirteen point one point drop. But the authors show most of that drop is ordinary human error, not the adversarial sentence, because AddSent keeps whichever sentence hurts the model worst out of up to five human-approved candidates — so across five independently graded groups of workers, at least one is likely to slip up regardless of the sentence's content. Isolate the effect with AddOneSent, one fixed sentence and no cherry-picking, and humans drop only three point four points — ninety-two point six down to eighty-nine point two.

[O] So the models are losing close to forty points, and humans are losing three and a half.

[G] And they checked the mechanism directly, not just the outcome. In ninety-six point six percent of model failures, the predicted answer span comes from inside the injected sentence. Success tracks lexical overlap almost exactly — forty-one point five percent of BiDAF Ensemble's successes shared a four-word run with the original passage, versus only twenty-one percent of its failures. Shorter questions succeeded more too, because in a short question, changing just one word does proportionally more damage to the overlap.

[S] Did any of these sentences actually sneak in a real answer, though? That would undercut the whole result.

[G] They hand-checked a hundred BiDAF Ensemble failures for exactly that. One sentence out of a hundred could plausibly be read as answering the question — a case where swapping "Muslim" for "Islamic" left the distractor too close to the truth. Zero out of a hundred for AddAny. The attacks are respecting their own validity constraint almost perfectly.

[O] Alright, time for the actual argument. My case: this is a landmark paper precisely because it built a rigorous, human-controlled instrument, and it worked not just on the models it was built against, but blind, on twelve more it never touched during development. That generality is about as strong a form of evidence as this literature gets.

[S] I'll give you that the design is careful. What I won't give you is the interpretive leap the citing literature makes constantly — "SQuAD models don't understand language." That's a bigger claim than what actually got tested. This paper found one specific shortcut: telling apart a sentence that answers the question from one that merely echoes its words. Closing that one shortcut doesn't mean you've found the ceiling on what these models were doing right.

[G] That's a fair distinction, and to the paper's credit, it doesn't make that leap itself — it claims overstability to this particular kind of semantics-altering distractor, not a verdict on reading comprehension as a whole. The overclaiming happens downstream, in how people cite it.

[O] I want to push on that a little, Julian. Ninety-six point six percent of failures tracing straight back to the injected sentence sounds like about as total an effect as this literature is going to produce. Isn't that closer to "these models are not reading" than you're allowing?

[G] It's total within the condition they tested — one appended distractor sentence. That's a strong, clean result. But total within one condition isn't the same as total across every possible test of language understanding, and the paper is careful not to conflate the two, even where its citations later do.

[S] Fine, but here's the part that should worry an optimist more than reassure one. Walk me through AddSentMod, Julian, because that reads like a trap the authors set for their own fix.

[G] The retraining experiment first: train BiDAF on raw AddSent sentences mixed into its training data, and it recovers from thirty-four point eight percent to seventy point four percent on AddSent test examples. Looks like a real fix. Then AddSentMod changes two small things — a different set of fake answers, and the sentence gets prepended instead of appended. The retrained model, which looked so robust a moment ago, falls right back to thirty-nine point two percent, barely above the thirty-four point three percent the untrained model started at.

[S] So point to me. That's not robustness, that's memorizing the shape of one specific attacker.

[O] I'll concede that one — it's the paper's own evidence and it's unambiguous. But I'd still say the bigger contribution is discovering the test was broken in the first place, not any single fix for it.

[G] If I'm adjudicating claim by claim: on "does the phenomenon replicate broadly, with a real human control" — strong yes, and that is the paper's genuine contribution. On "have they characterized all of what reading comprehension failure looks like" — no, and it doesn't claim to. On "is training against a fixed adversary a real fix" — their own Table 6 says no, which is honestly the most self-aware moment in the paper. And it's worth being explicit about what the paper simply cannot speak to: every one of the sixteen models tested is a twenty sixteen or twenty seventeen discriminative, span-extraction reader with no pretrained contextual representations at all — roughly a year before ELMo, and about fifteen months before BERT. Whether the shortcut survives contextualized pretraining wasn't answerable in twenty seventeen, and the paper doesn't pretend otherwise.

[S] So the honest headline is narrower than the famous one.

[G] Narrower, and I'd argue more interesting, because it's the part that's actually held up for nine years.

[O] So does the shortcut survive into the pretrained era, Julian, or did BERT just turn this into a period piece?

[G] The paper itself can't answer that, it predates the relevant models entirely. But its lineage answers it indirectly. SQuAD two point oh added unanswerable questions specifically so a model can't just pattern-match its way to some span. HotpotQA added supporting-fact distractors, which are a structural cousin of AddSent's appended sentence. The field's actual answer has turned out to be "partially" — contextual pretraining closed some of the gap and relocated the rest of it.

[S] Which is Table 6's caution playing out again, a decade later, at a different scale. The contamination and benchmark-gaming fights around large language model evaluation are the same shape. A fix that only survives the attacker you built it against isn't a fix, it's a mirror of that attacker.

[O] And that's really the paper's lasting export, more than the sentence-appending trick itself — the idea that adversarial training against one fixed generator can look like robustness and be nothing of the kind.

[S] Which is precisely what the paper's own Table 6 says it would take to raise real confidence — evidence against an attacker you didn't design the defense around, not just the one you did. Advice the field keeps needing to relearn.

[G] If there's one line to take from the paper itself, it's this: a leaderboard-topping F one score can certify lexical pattern-matching just as easily as it certifies understanding, and you don't find out which until you go looking.

[O] My takeaway is the optimist's version of that same lesson. This is what a benchmark's second act looks like — SQuAD didn't die from this paper, it got better because of it, and so did the benchmarks that followed.

[S] Mine's the skeptic's: read Table 6 twice before you believe the next robustness fix this show covers. For the full write-up, the figures, and the complete results tables, head over to the litsearch site.
