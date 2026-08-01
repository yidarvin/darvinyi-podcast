---
slug: kuznetsova-2020-open-images-v4
title: "The Open Images Dataset V4: Unified image classification, object detection, and visual relationship detection at scale"
description: "Nine million Creative Commons photos carrying three different annotation types — and a comparison table where the column you cite decides whether Open Images beats COCO by seventeen times or loses to it by nearly five."
date: 2026-07-31
guest_name: "Emma"
guest_voice: "bf_emma"
---
[O] Here is a claim from this paper. Open Images offers seventeen times more object bounding boxes than COCO. That is the authors' own sentence, and the table right underneath it backs the number up.
[S] And here is the same table, one column to the left. On that column Open Images has fewer boxes than COCO. Not slightly fewer. Roughly four point eight times fewer.
[O] Same table. Same row. Adjacent columns.
[S] Which tells you that in this paper, a number without its column attached is not a fact. It is a coin flip.
[O] Welcome to Litsearch Audio. Today we are taking apart The Open Images Dataset V four, by Alina Kuznetsova, Hassan Rom, Neil Alldrin, Jasper Uijlings and colleagues at Google, published in the International Journal of Computer Vision in twenty twenty, after going up as a preprint in twenty eighteen.
[S] It is on the docket because it is heavily cited, north of sixteen hundred citations, and because its headline numbers are unusually easy to misquote. We will show you at least three ways to get them wrong, and one of them tripped up our own writeup.
[O] Emma, welcome. You have read this one closely. Before we touch a single statistic, what is the one piece of bookkeeping a listener needs?
[G] The bookkeeping is the whole paper, honestly. Open Images ships three different annotation types on the same photographs. Image level labels, bounding boxes, and visual relationships. Each one has its own vocabulary, its own count, and its own split behaviour. And cutting across all of that there is a second distinction, between annotations a human verified and annotations a machine generated. So any number from this paper needs three tags before it means anything. Which annotation type. Which split. And for labels, whether a human actually signed off on it.
[S] That is an unusually high bar for a dataset paper.
[G] It is the bar the paper sets for itself, and it mostly clears it. The trouble is that the numbers travel downstream without their tags.

[O] Let us start with the gap. It is twenty eighteen. What did the field actually lack?
[G] Three separate benchmarks that did not overlap. ImageNet for classification. COCO for detection and segmentation. PASCAL and I L S V R C detection as the older detection standards. Each built by a different pipeline, on a different image pool, with a different notion of what counts as annotated. If you wanted to study whether classification labels could bootstrap a detector, or whether detection boxes could bootstrap relationship understanding, you had no single set of images carrying both.
[O] So the contribution is partly just the overlap. Same photographs, three annotation layers.
[G] That is the honest framing, yes. Plus a second thing the authors care about, which is where the pictures come from. Prior datasets were often built by querying a search engine for a predefined list of class names. The authors argue that bakes your assumptions into the query list, and skews you toward images search engines already rank highly, which tend to be simple single subject shots. Open Images instead starts from every Creative Commons Attribution licensed Flickr upload, with no predefined class list, and then throws away any image that also appears elsewhere on the web.
[S] Throws it away deliberately?
[G] Deliberately. The theory being that an image that shows up all over the internet is more likely to be a clean stock style photo, and what they want is cluttered multi object scenes.
[S] I want to flag that as a design choice with a cost, and we will come back to it. Keep going.
[O] And the third gap is the metric.
[G] Right. Standard PASCAL and COCO style mean average precision assumes that every instance of every class in an image has been labelled. Open Images has nineteen thousand seven hundred ninety-four image level classes. You cannot exhaustively check nineteen thousand classes per photograph at nine million photographs. So the annotation is non exhaustive by construction, and the metric had to change to match.

[O] Take us through the method, annotation type by annotation type. Image level labels first.
[G] The vocabulary is nineteen thousand seven hundred ninety-four classes, drawn from J F T, which is Google's internal image collection. It spans coarse objects, fine grained breeds and models, scenes, events, materials. And the pipeline is computer assisted, which is the part that matters. A classifier proposes candidate labels for an image, and then a human verifies each candidate as either positive or negative.
[S] Positive or negative. So a negative label is a real annotation, not an absence.
[G] Correct, and that is genuinely unusual. A human has looked at that image and asserted that this class is not present. In the train split, human verified positive labels come to about thirteen point four million, and human verified negative labels to about fourteen point four million. I am rounding both. There are more verified negatives than verified positives.
[O] Which is a resource most people using this dataset probably ignore.
[G] Most people do ignore it, and the paper's own classification experiment shows it does real work. But keep the tag on it. Those are train split, human verified, image level labels. Not boxes.
[S] What about the split asymmetry? You said splits behave differently.
[G] Strikingly differently. In train, the average image carries two point four verified positive image level labels. In validation and test, it is eight point eight. Same annotation type, same metric, roughly a three and a half times gap.
[O] Why?
[G] Because candidate generation differs. For validation and test they generated candidates densely, essentially per class. For train they used a stratified sampling scheme across many classifier variants to get a spread of easy and hard positives and negatives. So the train split is deliberately sparser and deliberately harder.
[S] So somebody who benchmarks train label density against test label density and concludes the test set is richer has just measured a sampling policy.
[G] Precisely that.

[O] Boxes.
[G] Six hundred classes, chosen because they have clear spatial extent, and organised into a hierarchy. Football Helmet and Bicycle Helmet both sit under Helmet, and that hierarchy becomes load bearing in the metric later. Ninety percent of boxes came from extreme clicking, where the annotator clicks the topmost, bottommost, leftmost and rightmost physical points of the object instead of dragging an imaginary corner. The paper reports that this cut the box drawing time itself from twenty-five point five seconds to seven point four seconds.
[O] That is a four fold throughput gain on the single most expensive operation in the dataset.
[G] It is, and it is a large part of why this dataset exists at that scale. The other ten percent came from what they call box verification series. A detector proposes a box, a human accepts or rejects it against an I O U threshold of point seven, up to four attempts. And there is a nice detail there. Acceptance of the detector's top proposal rose from forty-eight percent with the initial detector to seventy percent with the final retrained one.
[S] So the machine got better as the humans fed it.
[G] It did. Which is encouraging and also, as we will get to, a little circular.
[O] And the third type. Relationships.
[G] This is the cleverest piece of engineering in the paper, and the most misreported. They do not ask annotators to free write region descriptions the way Visual Genome did. They leverage the boxes they already have. For a candidate triplet of the form class one, relationship, class two, they select every pair of boxes where the two boxes' classes match class one and class two of that triplet — generally two different classes — and where the two boxes still overlap after each box has been enlarged by twenty percent.
[S] Stop there. Enlarged by twenty percent.
[G] Enlarged. Twenty percent is an enlargement factor applied to the boxes before the overlap test. It is not an overlap threshold, and it is not about same class boxes. The paper's stated reason is that their relationships assume physical contact in three dimensional space, which should mean the two dimensional projections overlap, and the enlargement gives that a little tolerance.
[S] I have seen that stated as twenty percent overlap between same class boxes, which is wrong twice over.
[G] Wrong twice over, yes. Then a human verifies whether the relationship actually holds. They picked three hundred twenty-six candidate triplets, and two hundred eighty-seven of them ended up with at least one verified instance in the train split.
[O] And acceptance rates?
[G] Low, and the authors treat that as a feature. Fifty-eight point nine percent for the easiest relation, which is at. Twenty-seven point nine percent for the median one, holds. Two point three percent for the hardest, under. Twenty-eight point two percent overall. Their argument is that if these relationships were trivially inferable from two objects merely being near each other, acceptance would be near the ceiling. It is not.

[S] Now the metric, because I suspect this is where the most damage gets done.
[G] Agreed, and here is the headline: the number this paper reports is not COCO mean average precision. It is the authors' own protocol, which the community writes as M A P O I. Three deliberate departures from PASCAL twenty twelve. One, non exhaustive labelling. A detection of a class that carries neither a positive nor a negative image level label on that image is ignored — not counted right, not counted wrong. A detection on a class with a negative label is still a false positive.
[O] So being right about something nobody checked costs you nothing.
[G] And earns you nothing. Two, the class hierarchy. A non leaf class's average precision is computed over its own instances unioned with all its subclasses' instances, so a model has to emit detections for every ancestor class to get full credit. Three, group of boxes. A single box covering five or more heavily occluding instances counts as one true positive if any detection lands inside it, at weight one, which is the setting the final metric uses.
[S] Do they ablate that?
[G] They do, in a bar chart, and this is the second place I want to be careful about what is actually printed. Five bars. The y axis is labelled from point three to point six. There are no per bar value labels. So everything I am about to say is a measurement taken off a chart against a labelled axis, not a figure the paper printed.
[O] Understood. Go.
[G] Measuring: the full final metric comes in around point five four three. Drop the group of weighting to zero and you get about point five five five. Drop the hierarchy term instead and you get about point five seven seven, and that is the tallest bar of the five. Then the two bars that abandon the non exhaustive correction entirely fall to roughly point four one two and point three nine five.
[S] So the correction that matters most by a mile is the non exhaustive one.
[G] By a mile. Those first three bars sit up around point five four to point five eight, and the two without the correction drop to about point four. That gap is what the paper's prose is pointing at.
[O] But wait. You just said the paper's own full metric is the lowest of the three that keep the correction.
[G] It is. The bars are not sorted by height, and the configuration that scores highest is the one that throws away the class hierarchy. So the authors did not pick the flattering configuration. They picked the one they thought was most faithful, and it costs them a few points.
[S] I will give them credit for that. That is a choice a lot of dataset papers would not make.

[O] Scale. Give me the numbers with the tags attached.
[G] Nine million, one hundred seventy-eight thousand, two hundred seventy-five images in total. On top of those: about thirty point one million image level labels across nineteen thousand seven hundred ninety-four classes, and fifteen million, four hundred forty thousand, one hundred thirty-two bounding boxes across six hundred classes. But watch the subsets. Only about five point six five million of the nine million train images carry image level labels at all, and only about one point seven four million train images carry boxes. Boxes were drawn on a subset, not on the whole split.
[S] So "nine million images" and "fifteen million boxes" are not two facts about the same nine million images.
[G] They are not, and that is the single most common misreading of this dataset. The box density figures come from the box annotated subset only.
[O] And relationships?
[G] Three hundred seventy-four thousand, seven hundred sixty-eight triplet instances — and here is another tag people drop. That is the train split figure. The abstract quotes it as if it were the dataset total, but validation adds about four thousand and test about twelve thousand more, taking the true total across all three splits to three hundred ninety-one thousand and change.
[S] The abstract undercounts its own dataset?
[G] It quotes the train number as the headline. Three hundred twenty-nine distinct triplet types over fifty-seven object classes.

[O] Now the comparison that opened the show.
[G] Table six. Five columns: PASCAL, COCO, I L S V R C detection, and then two different Open Images columns. And which of those two you cite determines the answer. The column labelled Dense is the full six hundred class boxable set, with fifteen million, four hundred forty thousand, one hundred thirty-two boxes. COCO's own column, at eighty classes, has eight hundred eighty-six thousand, two hundred eighty-four boxes. Divide and you get seventeen point four. The paper writes it as, quote, seventeen times more object bounding boxes than COCO.
[S] And the neighbouring column.
[G] The column labelled All is Open Images restricted to the two hundred classes that match I L S V R C detection's vocabulary. That column has one hundred eighty-six thousand, four hundred sixty-three boxes. Against COCO's eight hundred eighty-six thousand, that is roughly four point eight times fewer.
[O] So the identical dataset either dominates COCO or loses badly, depending on which class vocabulary you hold it to.
[G] Correct. And I want to kill a specific piece of misinformation here, because the Litsearch writeup for this paper initially carried it and had to be corrected. There is no restriction to shared classes anywhere in that seventeen times comparison. It is the full six hundred class Open Images set against the full eighty class COCO set. The restricted column exists, but it is restricted to I L S V R C's two hundred classes, and it is the column that loses.
[S] Which is a genuinely dangerous invented qualifier, because it sounds more rigorous than the truth while reversing which comparison you are describing.
[G] It does. One more nuance while we are here. The abstract quotes fifteen times, not seventeen. That is a looser framing against, in their words, the next largest datasets. The seventeen figure is the specific COCO comparison in section three.
[O] What about density per image? Because scale is cheap if the images are empty.
[G] The Dense column runs about eight point one boxes per image against COCO's seven point two. So comparable density, an order of magnitude more of it. And at the tail, eleven Open Images classes individually have more instances than COCO's single largest class, which is person, at two hundred fifty-seven thousand, two hundred fifty-three instances.

[S] Quality. This is where I expect the paper to get soft.
[G] It does not get soft, but it does get narrow. A human expert examined one hundred images for each of the first one hundred fifty boxable classes, more than twenty-six thousand boxes. Box precision ninety-seven point seven percent, recall ninety-eight point two percent. The precision errors break down into geometrically imprecise boxes at one point one percent and wrong class labels at one point one percent.
[S] One hundred fifty of six hundred classes. How were they picked?
[G] Sorted by alphabetical order. The paper's own words: the first one hundred fifty boxable classes sorted by alphabetical order.
[S] So the audit covers roughly A through C.
[G] Roughly. And the paper does not flag that as a limitation. It is a quarter of the boxable vocabulary, chosen by the least informative possible criterion.
[O] Is there a reason to think alphabetical is biased?
[S] I do not need one. The burden runs the other way. If you want a precision estimate for six hundred classes, you sample six hundred classes, or you sample randomly. Alphabetical is neither, and it is free to fix.
[G] And the paper's own data shows the per class variance is enormous. Within those one hundred fifty classes the semantic error rate ranges from a couple of percent up to eighty-six percent for bidet, which annotators confused with toilets. Cello was fifty-five percent, confused with violins. Coffee table thirty-five percent, which the paper calls an inherently ambiguous class. With that spread, which quarter of the alphabet you sampled matters.
[O] Anything corroborating the geometry independently?
[G] Yes, and this part is good. They redrew fifty thousand randomly selected boxes and got average I O U agreement of point eight seven with the originals, against point eight eight reported for human agreement on PASCAL. The machine assisted box verification boxes came in lower, point seven seven. But then they trained identical detectors on each source and found the detection performance difference was smaller than point zero zero one on their metric.
[S] That is the right experiment. Measure the annotation difference where it actually lands, in the trained model. Credit given.

[O] Label recall. This is the number I keep seeing quoted out of context.
[G] Two experts inspected a sample of images for missing boxable class instances. Considering really all objects, the recall of image level labels is forty-three percent. Disregarding difficult objects — very small, severely occluded, severely truncated — it is fifty-nine percent. The paper compares that to an estimated eighty-three percent recall reported for COCO, and attributes the gap to Open Images covering seven point five times more classes.
[S] So somewhere between forty-one and fifty-seven percent of true instances carry no image level label at all. Not a positive one, not a negative one. And the metric's stated rule is to ignore unannotated classes.
[G] That is the tension, yes.
[S] Then a detector is being scored on roughly half the objects that are actually there, with the other half neither rewarded nor punished. That is a fundamentally different scoring regime from COCO, and it makes the raw numbers non transferable.
[O] Emma, does the paper engage with that at all, or does it just report the recall figure and move on?
[G] It engages, and I want to be fair about how. Right after the recall numbers the authors offer a mitigation. They say the lack of complete annotation is, quote, partially compensated by having explicit negative image labels, which enable proper training of discriminative models. And they stress that for each positive image level label, they annotated bounding boxes for every instance of that class in the image. Quote, along that dimension, the dataset is fully annotated.
[S] With the ninety-eight point two percent box recall as the evidence.
[G] With that figure, and note the table's caption qualifies it: conditioned on a given class label for an image.
[S] Then the mitigation is real but narrower than it sounds. Conditioned on a class already having a positive label, the boxing is essentially complete. That says nothing about the classes that never got a label of any polarity, which is exactly the population being ignored at scoring time.
[G] That is the accurate version of the critique, and it is the one I would defend. The honest complaint is not that the paper ignores the issue. It plainly does not. The complaint is that it never connects the recall figure to the metric. The recall number lives in the quality section, the ignore rule lives in the metrics section, and no sentence in the paper joins them.
[O] That is a much better criticism than the one I hear people make.
[S] It is, and I will take it over the lazy version.

[O] Let me make the optimist case, then. What does the unified annotation actually buy?
[G] Two demonstrations, and both are only possible because the three annotation types sit on the same photographs. First, fine grained detection. If an image carries an image level label more specific than a boxable class — Labrador under Dog — and only one instance of the parent class appears, transfer the specific label onto that box. A single detector trained that way reached about point two eight seven mean average precision over fifty-seven Car subclasses, point two three one over sixty-one Cat subclasses, and point five nine four over one hundred two Flower subclasses.
[S] Against what?
[G] Against uniform random, most common subclass, and prior based random baselines, all of which sit below point zero five in every row. So the effect is not subtle. Though I would note the ceiling is still low in absolute terms, and one baseline value rounds to three decimal places of zero, which means below half a thousandth, not exactly zero.
[O] And the second demonstration.
[G] Zero shot relationship detection. Forty-eight box classes with no relationship annotations of their own get paired with existing relationship types, giving one hundred ninety-four new triplet types and about six thousand zero shot test annotations. One model reached recall at fifty of forty point six one on the full test set, but only seven point six eight restricted to the zero shot triplets. For phrase detection, forty-three point six five against ten point nine eight.
[S] So it transfers, but it collapses by a factor of four to five.
[G] And the authors say so themselves. Their words: this can be tackled to a reasonable degree but the gap to the supervised results is still very large.
[O] I will take that as a fair self assessment.

[S] My deflationary case, then, and I want to put it in one sentence. The dataset's coverage is defined by a classifier, and the paper never audits the classifier.
[G] Unpack that.
[S] Every image level label in this dataset began as a machine proposal from a J F T trained classifier, filtered by confidence, before any human saw it. Human verification can kill a machine's false positives. It structurally cannot surface a true positive the classifier never proposed. So the coverage of the dataset is upper bounded by what that classifier already recognised, and no amount of human verification downstream fixes that.
[G] That is correct as a description of the pipeline, and the paper does not test it. It reports that classification performance on the six hundred boxable classes runs higher than on the full nineteen thousand class set, and attributes that to boxable classes being basic level categories. But it never separates the two hypotheses: is a class rare in the data because it is rare in the world, or because the proposer under proposed it?
[O] Is that testable?
[G] Cheaply, yes. Take a sample of classes, have humans annotate them exhaustively without the candidate filter, and compare against what the pipeline produced. The paper does not run it.
[S] And the same circularity shows up in the box verification series, where a detector trained on accepted boxes proposes the next boxes.
[G] Though there the paper does check the outcome, with the point zero zero one detector comparison. So that loop is at least measured at the output.
[S] Fine. Partial credit there.
[O] Emma, one thing I want to hear you on directly, because it is the strongest thing in the writeup. The population question.
[G] There is no geographic or demographic characterisation of the source images or the annotators anywhere in this paper. I want to be precise that this is a checked claim, not an impression — a normalised search across the full text for country, geography, demography, nationality, ethnicity and gender returns nothing.
[S] Which is remarkable, because the paper itself raises the issue and then drops it.
[G] It does, and that is the sharpest form of the criticism. The authors explicitly note cultural differences among annotators — their own example is that where a human hand ends, whether it includes the arm, varies by region — and they built training material to control for it. So they knew the axis existed. They just never characterise who the roughly nine million photographers are, or who the annotators are.
[O] And the image selection compounds it.
[G] It does. Creative Commons Attribution licensed, Flickr hosted, and explicitly excluding anything that appears elsewhere on the web. That is three stacked filters, each of which is a real slice of the world's photography, and the paper quantifies none of them.
[O] I will concede that one fully. That is the gap that has aged worst.

[S] Where does this leave us for evaluation practice?
[G] Two portable lessons, I think. The first is that a metric is part of a dataset, not a neutral instrument applied to it. The authors changed mean average precision because their annotation was non exhaustive, and they were transparent about it, which is more than most. But it means a number on Open Images and a number on COCO are not the same kind of object, and anyone putting them in one table owes the reader a re derivation.
[O] The second?
[G] Discipline about tags. Almost every misreading of this paper is a dropped qualifier. A train split number quoted as a dataset total. A box count read as a label count. A six hundred class comparison quoted as if it were class matched. A machine generated total presented as human verified. None of those are the paper lying. They are readers dropping a word.
[S] Which is a failure mode that scales badly, because the paper is cited thousands of times and each citation is a chance to drop one.
[O] Takeaways. Emma, the paper's.
[G] Three annotation types on one image pool, at a scale that let the authors demonstrate cross annotation transfer nobody could run before — and a metric honest enough about non exhaustive labelling that it costs the authors points rather than earning them.
[O] Mine. The unified pool is the durable contribution. The fine grained detection result, going from under point zero five to point two nine on Car subclasses purely by transferring labels the dataset already had, is the kind of thing you only discover when the annotations share a substrate.
[S] Mine. The scale is real and the quality audit is better than most. But the coverage of this dataset is a function of a classifier nobody audited, the quality audit sampled the alphabet, and a paper that noticed cultural variation in its own annotators never once asks where its nine million photographs came from. Cite the numbers. Cite the column too.
[O] The full writeup is on the Litsearch site, with the comparison table, the metric ablation chart, and the figures we could only describe here. Thanks for listening.
