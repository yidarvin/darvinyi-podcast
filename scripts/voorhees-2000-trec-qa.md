---
slug: voorhees-2000-trec-qa
title: "Building a Question Answering Test Collection"
description: "The TREC-8 QA track, SIGIR 2000: three human assessors overlapped on only .641 of the correct answer strings, yet the system rankings barely moved — the founding measurement of judge disagreement, and the oldest paper in the atlas."
date: 2026-07-28
guest_name: "Rosalind"
guest_voice: "af_sarah"
---
[O] Three trained human judges read the same answer strings for the same questions. Take the set of strings each one called correct, and the three sets overlapped about two-thirds of the time. And the ranking of the systems barely moved.
[S] That's the sentence that should make you nervous, not confident. If your judges only agree on two-thirds of the cases that matter, part of what your leaderboard measures is the judges.
[O] Or it means comparative evaluation is more robust than you would guess from the disagreement rate. Both can be true. And this paper measured it instead of assuming it, in the year 2000.
[G] Which is exactly why it deserves an episode. The authors set out to test whether a document-retrieval evaluation methodology transfers to a different task, and they built the experiment so that it could have failed.
[O] Welcome to Litsearch Audio. Today's paper is "Building a Question Answering Test Collection", by Ellen Voorhees and Dawn Tice of NIST, published at ACM SIGIR in 2000.
[S] It is the oldest paper in the atlas by more than twenty years. The systems under test predate the transformer by about eighteen.
[O] Our guest is Rosalind, who knows this literature closely. Rosalind, why does a 2000 information-retrieval paper belong on a modern evaluation docket?
[G] Because it is the origin point for question answering as a benchmarked task, and because its central result is the ancestor of every argument we now have about judge reliability. SQuAD cites it. TriviaQA cites it. The vocabulary has changed completely. The problem has not.
[S] Set the scene for me. What did question answering look like in 1999?
[G] Fragmented. The paper's own related work runs from Winograd's SHRDLU in a toy block world, to Woods's LUNAR system answering geologists' questions about moon rocks, to MURAX pulling closed-class answers out of an on-line encyclopedia, to the FAQ Finder system matching user questions against Usenet question-and-answer files. And separately, the information extraction community, filling database-style templates from running text.
[O] What did those efforts have in common?
[G] Almost nothing measurable. No shared document collection, no shared question set, no shared definition of a correct answer. The paper notes that LUNAR was demonstrated at a lunar science conference in 1971 and answered seventy-eight percent of the one hundred eleven in-scope questions correctly. That is a real number. It is not comparable to anything.
[S] Whereas TREC had spent seven years building precisely the opposite thing for document retrieval.
[G] Right. A fixed corpus, a set of information needs, and relevance judgments, which together make a reusable test collection. You can score a system built years later without re-running the original assessment. That is the machinery NIST wanted to port over.
[O] And the paper treats the porting as the research question, not the plan.
[G] It does. Two goals are stated up front. Foster research on the task, and investigate whether the evaluation methodology is appropriate for a task other than text retrieval. The second goal is where the lasting contribution lives.
[S] Give me the task spec.
[G] The document collection was the existing TREC-8 ad hoc collection. Roughly five hundred twenty-eight thousand articles from the Los Angeles Times, the Financial Times, the Foreign Broadcast Information Service, and the Federal Register. Two hundred fact questions, all closed-class, meaning each has a definite answer typified by a noun phrase. For each question a system returned a ranked list of five document-id and answer-string pairs.
[O] Give me a few of the questions.
[G] How many calories are there in a Big Mac. Where is the Taj Mahal. Who was the sixteenth President of the United States. Deliberately ordinary.
[S] Where did the questions come from? That's usually where the bodies are buried.
[G] Four sources, and the final mix is documented. One hundred twenty-seven from track participants and NIST staff, forty-nine from the NIST assessors themselves, and twenty-four from logs of the FAQ Finder system. That last group is the only one where a real person actually wanted the answer. NIST staff then filtered out list questions, obvious back-formations of a single document sentence, and anything a staff member found fuzzy or unclear.
[O] And even after all that filtering, two of the two hundred turned out to have no answer in the collection.
[G] Discovered during judging, which is why every official score in the paper is computed over one hundred ninety-eight questions, not two hundred.
[S] Now the scoring.
[G] Each question scores the reciprocal of the rank of the first correct answer string. One, one-half, one-third, one-quarter, one-fifth, or zero if none of the five was correct. A run's score is the mean of those, the mean reciprocal rank. Higher is better. And there are two separate conditions: answer strings capped at fifty bytes, or capped at two hundred fifty bytes.
[O] Two hundred fifty bytes being about a sentence.
[G] A sentence or two, in the paper's own words. And you must not blend the two conditions. They are treated as different tasks throughout, and reported in separate blocks of the results table.
[S] Now the judging. This is the part I actually care about.
[G] Every question was judged independently by three assessors, specifically so that disagreement could be measured rather than assumed away. They received about two hours of training on four practice questions. The core instruction is worth hearing almost verbatim: assume a user who trusts the answering system completely and therefore does not require justification, then ask whether that user, given this answer string alone, would get the correct answer to the question.
[O] That is a surprisingly modern framing of what an answer is even for.
[G] It is, and it comes with rules. Document context counts, so a present-tense question about a prime minister is judged against the date of the document. A string listing several entities of the right semantic category, without indicating which one is the answer, is incorrect. Units and punctuation matter, so five hundred does not substitute for five hundred dollars.
[S] How did they decide what to judge at all? You can't judge the whole corpus.
[G] Pooling. For each question, the pool is the distinct document-id and answer-string pairs returned across all forty-five submitted runs. The mean pool size was one hundred ninety-one point six pairs, drawn from a mean of fifty-five point three distinct documents.
[O] And when the three assessors disagreed on a pair?
[G] An adjudicator, and this is a genuinely nice piece of design. The adjudicator does not cast a fourth vote. They decide why the disagreement happened. If it is a real difference of opinion, the majority stands. If it is a misapplication of the guidelines, or it makes the judgments inconsistent across the pool, the adjudicator overrules the majority. That adjudicated set produces the official scores.
[S] Numbers.
[G] Twenty organizations submitted forty-five runs. Forty-one were scored. Four were in error. One precision note for anyone citing this: the results table's organization column lists nineteen distinct organizations, not twenty, which implies at least one participant had all of its runs among the four that were dropped. The paper does not say that directly, so treat it as an inference from the table.
[O] The leaderboard.
[G] In the fifty-byte condition, the top run was textract nine nine oh eight from Cymfony, at a mean reciprocal rank of point six six zero, with fifty-four of the one hundred ninety-eight questions where no correct answer was found anywhere in the top five. In the two hundred fifty-byte condition, the top run was from Southern Methodist University at point six four six, with forty-four not found.
[O] So the single best score in the whole track came from the harder condition.
[G] It did, and the paper flags that explicitly. But on average, length helped. For every organization that submitted runs at both limits, its two hundred fifty-byte run scored a higher mean reciprocal rank than its matched fifty-byte run. That is a clean sweep down the table, not a cherry-picked pair.
[S] What were the systems actually doing?
[G] The stronger ones converged on a common shape. Classify the question by the type of entity that would answer it. Who implies a person or an organization, when implies a time, how many implies a quantity. Then retrieve a few hundred to a thousand documents, shallow parse them, and if an entity of the entailed type sits close to the question's words, return it. If no entity of the right type turns up, fall back to best-matching-passage retrieval.
[O] And the paper's read is that two hundred fifty bytes is roomy enough for that fallback to work, while fifty bytes forces the linguistic step.
[G] That is precisely its argument.
[S] Fine. Now the part this paper is actually remembered for.
[G] Disagreement. On average, six percent of the judged answer strings were disagreed on by the three assessors. And the paper immediately says that number is misleading, because most strings in a pool are obviously wrong and everyone agrees on those.
[O] So they reach for a sharper measure.
[G] Overlap, borrowed from the document relevance literature. Take the set of strings each assessor called correct. Divide the size of the intersection of all three sets by the size of the union of all three. One means perfect agreement, zero means the sets are disjoint. The mean three-way overlap was point six four one, averaged over the one hundred ninety-three questions that had at least one correct string found at all.
[S] Three-way, not pairwise. That distinction matters, because a three-way intersection over union is a harsher statistic than an average of pairwise agreements.
[G] It is, and the paper is explicit about the definition. Point six four one is the three-judge number, over one hundred ninety-three questions.
[O] What drives it? Give me the flavor.
[G] Granularity, almost entirely. For when did French revolutionaries storm the Bastille, some assessors accepted July fourteenth, others accepted seventeen eighty-nine, and everyone accepted the full date. For where Harry Truman was born, some required Lamar, Missouri, and some accepted just Missouri. Nobody accepted just USA, though for other questions country-level answers were fine.
[S] Which means the rule isn't the assessor's. It's the question's.
[G] That is close to the paper's conclusion. And the best single example is the Taj Mahal. One of the three assessors accepted Atlantic City, New Jersey, the casino, even though the guidelines said replicas and imitations don't count for questions about a famous entity. For that assessor, the casino was famous enough to be an entity in its own right.
[O] I like that the paper does not treat that as an error to be trained away.
[G] It explicitly refuses to. The argument is that forcing agreement among assessors would defeat the purpose of the evaluation, because eventual end users will disagree in exactly these ways, and the technology has to accommodate that to be useful.
[S] All right. The judges disagree. Does the evaluation survive it?
[G] That is the experiment. Alongside the adjudicated judgment set you can construct single-assessor judgment sets, where every string for a question carries one assessor's opinion. There are enormously many of them, three choices per question across one hundred ninety-eight questions. They sampled one hundred thousand, re-scored all forty-one runs against each one, and looked at what moved.
[O] And what moved was the absolute scores.
[G] Yes. The mean reciprocal rank shifts when you change judgment sets. You can read the per-run mean, standard deviation, minimum and maximum directly in the results table. The largest standard deviation for any run was point zero one four.
[S] And that number gets misquoted constantly.
[G] It does, so let me state what it means. It is an equivalence threshold, not a bound on how far a score can shift. The paper's claim is that any two runs whose mean reciprocal ranks are within point zero one four of each other must be considered equivalently accurate. It is not saying scores only ever move by that much.
[O] Then the rankings.
[G] Kendall's tau between the system rankings produced by different judgment sets. With forty-one systems there are eight hundred twenty possible pairwise adjacent swaps, so tau converts neatly into a swap count. Among pairs of single-assessor rankings, the mean correlation was point nine six three two, about fifteen swaps. Against the official adjudicated ranking, the mean was point nine five six three, about eighteen swaps.
[S] And the extremes?
[G] Every value reported in the paper sits between point nine one four six and point nine nine seven six. The best case was a single swap out of eight hundred twenty. The worst was thirty-five.
[O] What about the aggregated judgment sets? Majority, union, intersection.
[G] Against the adjudicated ranking: majority at point nine six eight three, union at point nine seven eight zero, and the strict intersection, where a string counts only if all three assessors said yes, at point nine one four six.
[S] Which is the floor of the entire range.
[G] It ties the floor. That is the precise statement, and it is worth getting right. The minimum single-assessor-versus-adjudicated correlation was also point nine one four six. So the intersection judgment set produces the least similar ranking reported, but it does not fall outside the band that single-assessor sampling already spans.
[O] Then where did aggregation actually behave differently?
[G] In the raw scores, not the rank order. And the paper calls this out as a difference between question answering evaluation and document retrieval evaluation. For every run, the majority and adjudicated mean reciprocal ranks landed inside the minimum-to-maximum band of that run's one hundred thousand single-assessor scores. The union and intersection scores frequently fell outside that band.
[S] That is a genuinely interesting asymmetry, and it is the first thing people drop when they cite this paper as "judges disagree but the rankings are fine".
[G] I agree. Rank order is robust. Score level is not. And it is specifically the extreme aggregations, take everything anyone accepted or take only what everyone accepted, that leave the range single judges span.
[O] Let me make the optimist case. This is the paper that made benchmark-based evaluation defensible for a task where the ground truth is contested. Before it, you could argue that because humans disagree about correctness, you simply cannot build a meaningful leaderboard. After it, you have a measured answer: the disagreement is real, it moves the absolute numbers, and it barely moves the ordering. That unlocked twenty-five years of shared benchmarks.
[S] My deflationary case has three parts. The resampling isn't independent. Point six four one is not a comfortable agreement number. And ranking stability is not the same thing as measuring the right quantity.
[G] Take them in order. On independence, you are not only right, the paper says it before you do. Any two single-assessor judgment sets will contain exactly the same judgments for about a third of the questions on average, because there are only three assessors to draw from. The paper states that the correlations shown may therefore be slightly higher than they would be with fully independent judgment sets. That is an honest self-limitation, and it does mean the stability result is somewhat flattered.
[S] Thank you.
[G] On point six four one, I'd score that partly to you. It is moderate agreement on exactly the cases that matter, and the paper does not hide it. But your framing assumes overlap must be high for the evaluation to mean anything, and the paper's argument runs the other way: the disagreement is a property of the task and its users, not a defect in the assessors, and the right response is to check whether comparative conclusions survive it.
[O] Which they did.
[G] Which they did, within this experiment. And on your third point you are right that the paper does not establish construct validity. Nowhere does it claim that the mean reciprocal rank measures question answering ability in general. It claims this evaluation is stable under changes to the judgments used to produce the scores. That is a much narrower claim than it usually gets cited for.
[S] Can I add a fourth? Everything here is three NIST-trained assessors, one hundred ninety-eight questions, pooled over forty-five runs, on closed-class factoid questions with short entity answers. Not one of those conditions holds for a modern evaluation.
[G] Fair, and I'd score that to you fully. These numbers are properties of this setup. Read as universal constants, they mislead.
[O] Then let me take one back. The design is unusually rigorous for any era, not just for 2000. Three independent judges instead of one. An adjudication protocol that separates opinion from error. A hundred-thousand-sample resampling study. And, as we are about to get to, an out-of-sample test of their own proposed fix rather than stopping at the flattering number.
[G] That last one is the strongest thing in the paper, and I'd give you that point without argument.
[S] So what is the fix, and why doesn't it work?
[G] The goal was a reusable test collection. Score a brand-new run that nobody judged, using the same questions and the same documents. Document retrieval gets that for free, because documents have identifiers. Answer strings do not. Two runs almost never return the identical string, and deciding whether the difference matters is, as the paper argues, roughly as hard as the original question answering problem.
[O] And they had a natural experiment fall into their lap.
[G] They did. The University of Ottawa submitted two runs that were misnumbered, and the mistake was found only after judging was complete. They could not be officially scored, because their answer strings could not be mapped onto judged answer strings.
[S] What did NIST try?
[G] An answer key made of Perl string-matching patterns, written by a human from the strings the adjudicated judgment set had marked correct. Three hundred thirty-eight patterns across the one hundred ninety-eight questions, about one point seven per question. One hundred twenty-eight questions needed only a single pattern. One question needed thirteen: what does the Peugeot company manufacture, where the accepted answers ran from cars and diesel motors through a list of specific model numbers.
[O] And re-scoring the forty-one judged runs with those patterns?
[G] A Kendall's tau of point nine six against the adjudicated ranking, which is about the level of disagreement you get from swapping human assessors. And then the authors immediately undercut their own result, because the patterns were derived from the responses of the very runs being re-scored. Their phrase for it is essentially testing on the training data.
[S] In 2000. Written by the people who would have benefited from not writing it.
[G] Which is why the Ottawa runs matter so much. Those two runs contributed nothing to the patterns. So the official adjudicator judged them by hand, after the fact, under the same rules, and the patterns scored them as well.
[O] And?
[G] At fifty bytes, near-identical. A mean reciprocal rank of point two nine one from the human, point two nine two from the patterns, and both found no answer for exactly one hundred seventeen questions. At two hundred fifty bytes they separate. The human gives point four three two with eighty-seven not found. The patterns give point four six seven with seventy-eight not found.
[S] So the patterns are more generous, and more generous at the longer length.
[G] Which is mechanically what you would expect. A longer string has more chances to contain a matching substring in the wrong context. And the paper enumerates the failures rather than summarizing them. Accepting Giacomo Joyce when the answer was James Joyce, because the pattern is just Joyce. Accepting Plainfield, New Hampshire as the location of Dartmouth College, which is in Hanover, because the pattern accepts the state abbreviation. Accepting a quote from a spokesman at the India Embassy as the location of the Taj Mahal, because the pattern is India.
[O] Those are not random errors.
[G] That is the paper's point, and it is the sharpest thing in it. Human assessors disagree at the margins, and from a system's perspective that disagreement is close to random. Automatic matching misjudges entire classes of response, and the classes it misjudges are precisely the hard cases that separate a good system from a lucky one. The verdict is that patterns are better than nothing, especially inside a single lab where the limitations are well understood, but that the full benefits of this style of evaluation are not realized until something better exists.
[S] What do we do with all this in 2026?
[G] Three things, and I want to be careful not to put modern words in these authors' mouths. First, the disagreement result is the ancestor of every argument we have about judge reliability. It is not the same argument. They are talking about trained human assessors reading fifty-byte strings, not about model graders. But the structural insight transfers: measure whether your conclusions survive a change of judge, rather than assuming one judgment set is the truth.
[O] Second?
[G] Second, the split between rank stability and score stability. This paper separates them cleanly and gets different answers for each. Modern practice tends to report one number and one ordering and treat both as equally solid.
[S] And third?
[G] Third, the reusability problem was never really solved. It was redefined. The diagnosis here is that judging an answer string requires the same linguistic competence as producing one. Every later approach, exact match over short spans, span overlap, and eventually model-based grading, is a different bet on how to get around that, and each one inherits the failure mode the patterns showed: systematic leniency concentrated in the hard cases.
[O] And SQuAD and TriviaQA both cite this paper.
[G] They do, and that lineage is why it belongs in the atlas. This is the point where question answering became a benchmarked task with a shared corpus, a shared question set, and a documented judging protocol.
[S] Let's land it. One sentence each.
[G] Mine is the paper's own: assessors legitimately disagree about whether a string answers a question, comparative evaluation of systems survives that disagreement, and building a reusable question answering test collection is fundamentally harder than a document retrieval one because answer strings have no identifiers.
[O] Mine is that this is the paper that earned benchmarking the right to exist on contested ground. It did not assert that evaluation works. It ran the experiment that could have shown it doesn't.
[S] And mine is a warning about how it gets cited. Point zero one four is an equivalence threshold. Point six four one is a three-way overlap over one hundred ninety-three questions. And every one of these numbers belongs to three trained assessors and one hundred ninety-eight factoid questions in 1999. Take the method, not the constants.
[O] The full writeup, with the figure, the tables, and the citation graph, is on the litsearch site. Thanks, Rosalind.
