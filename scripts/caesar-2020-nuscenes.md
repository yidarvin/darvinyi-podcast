---
slug: caesar-2020-nuscenes
title: "nuScenes: A multimodal dataset for autonomous driving"
description: "The first driving dataset with the full sensor rig — 6 cameras, 5 radars, 1 lidar — and the metric redesign that outlived it. Also the cleanest case study in why 'bolded in the table' and 'best in the column' are different claims, and why every nuScenes number needs its unit attached."
date: 2026-08-01
guest_name: "Desmond"
guest_voice: "am_puck"
---
[O] The single most cited paper in this whole corpus is not a model. It is a dataset. Eight thousand six hundred and thirty five citations for a collection of twenty second driving clips.
[S] And the clause everyone quotes from it — the first dataset to carry the full autonomous vehicle sensor suite — is, as far as I can tell, true. Which is not something I get to say at the top of an episode very often.
[O] So we agree.
[S] On that clause. Not on the four or five other superlatives that citing papers have attached to this thing since. And I want to spend real time today on the difference between a number being bolded in a table and a number being the best in that column, because this paper is the cleanest example of that gap I have ever read.
[O] Welcome to Litsearch Audio. Today it is nuScenes, a multimodal dataset for autonomous driving. Holger Caesar, Varun Bankiti, Alex Lang, Sourabh Vora and colleagues. Ten authors, all at nuTonomy, an APTIV company.
[S] It went up on arXiv in March 2019 and appeared at C V P R in 2020. What we read is version five, the camera ready.
[O] And with us is Desmond, who has been through this one down to the supplementary tables. Welcome.
[G] Thank you. One piece of housekeeping before anything else, because it governs almost every argument people have about this paper. nuScenes counts things in at least five different units. Scenes. Samples, which the paper calls keyframes. Sweeps. Annotated frames. And boxes. Those are five distinct things and they get conflated constantly. If someone quotes you a nuScenes number without its unit attached, treat it as unusable until you find the unit.
[S] Noted, and I intend to hold you to it.
[O] Start with the gap. By 2019 there were already plenty of driving datasets.
[G] Plenty of image driving datasets. The paper's own list is CamVid, Cityscapes, Mapillary Vistas, BDD100K, ApolloScape and D2-City. Every one of those has zero lidar pointclouds and zero radar pointclouds in the paper's comparison table. And the opening argument is that this is a mismatch with deployment. Most autonomous vehicles, in the paper's words, carry a combination of cameras and range sensors such as lidar and radar.
[S] KITTI existed, and KITTI has lidar.
[G] It does, and the paper calls it the pioneering multimodal dataset. But look at the scale in that same table. KITTI: twenty two scenes, fifteen thousand annotated frames, two hundred thousand 3D boxes, eight classes, one city, Karlsruhe. No night, no rain, zero map layers. And the annotation is frontal view only.
[O] What about H3D, which landed the year before?
[G] H3D closes one leg of the gap. A hundred and sixty scenes, 1.1 million 3D boxes, and it annotates a full 360 degrees rather than just the frontal view. But it still has no radar, and zero map layers. Every prior dataset is missing at least one part of the rig.
[S] And radar is the part nobody had.
[G] The paper's claim is blunt: we are not aware of any autonomous driving datasets that provide radar data. And the argument for why radar matters is a failure mode argument, not an accuracy argument. Lidar range is typically limited to fifty to a hundred and fifty meters. Radar reaches two hundred to three hundred meters and measures object velocity directly through the Doppler effect, but its returns are sparser than lidar and less precise in localization. Three sensors, three different ways of being wrong. The paper cites work suggesting that multimodal configurations provide redundancy in the face of sabotage, failure, adverse conditions and blind spots — and I want to be precise, it is citing that claim, not demonstrating it.
[S] Second gap.
[G] Semantic maps. The paper says that with the notable exception of two datasets, most autonomous driving datasets ship no map priors at all. Those two are Lyft L5 and Argoverse — and notice how thin that exception is. Argoverse ships two map layers. Lyft L5 ships seven. H3D and ApolloScape ship zero. nuScenes ships eleven.
[O] And the third gap is the metric itself.
[G] Yes, and I think it is the one with the longest legacy. The standard detection metric matches a prediction to a ground truth box by intersection over union. The paper's objection is geometric: objects with small footprints, like pedestrians and bikes, if detected with a small translation error, give zero I O U. A nearly correct pedestrian box scores nothing at all. And the paper argues that makes it hard to compare vision only methods, which tend to have large localization errors, against lidar based ones.
[O] All right. Take us through the build.
[G] Eighty four logs. Fifteen hours of driving data. Two hundred and forty two kilometers travelled at an average of sixteen kilometers per hour, which immediately tells you this is urban stop and go, not highway. Two identical Renault Zoe electric cars, in Boston — Seaport and South Boston — and Singapore — One North, Holland Village and Queenstown. Two cities picked in part for right versus left hand traffic.
[S] And fifteen hours of driving becomes a five and a half hour dataset.
[G] Correct, and that is unit trap number one. From that raw body they manually select a thousand interesting scenes of twenty seconds duration each. A thousand times twenty seconds is five and a half hours. Fifteen hours is what they drove. Five and a half is what they released.
[O] The rig.
[G] Six cameras, five radars, one lidar, all with full 360 degree field of view, plus G P S, an I M U and an attitude and heading reference system. Cameras are 1600 by 900, capturing at twelve hertz. The lidar is a spinning thirty two beam unit at twenty hertz, up to seventy meters range, accurate to plus or minus two centimeters. The radars are seventy seven gigahertz frequency modulated continuous wave units at thirteen hertz, ranging up to two hundred and fifty meters.
[S] Five radars. I want that on the record, because I have seen it written as six.
[G] Five. Front, front left, front right, back left, back right. Six cameras, five radars, one lidar. That is the abstract's own phrasing.
[O] Two engineering details I liked. The exposure triggering and the localization.
[G] Camera exposure is triggered when the lidar sweep crosses the center of that camera's field of view, which is how they get cross modality alignment rather than trusting timestamps after the fact. And ego vehicle localization comes from a Monte Carlo scheme over lidar and odometry, matched against an offline map, achieving ten centimeters or better. They deliberately avoid G P S there, because it is unreliable in dense urban environments.
[S] Now the annotation units, because this is where I expect most misreadings live.
[G] Right. The sensors run at their native rates: twelve, thirteen and twenty hertz for camera, radar and lidar. Annotation does not run at those rates. Keyframes — which the paper also calls samples — are taken at two hertz. That yields forty thousand annotated keyframes across the thousand scenes. In each keyframe, every one of twenty three object classes is annotated with a semantic category, attributes covering visibility, activity and pose, and a cuboid parameterized as x, y, z, width, length, height and yaw. Objects are annotated continuously through a scene as long as at least one lidar or radar point covers them.
[O] And the headline totals people quote.
[G] Here is the full set, with units attached, and I am going to be tedious about it because three of these are the same number and they are not the same thing. 1.4 million camera images. Four hundred thousand lidar pointclouds. 1.3 million radar pointclouds. Forty thousand annotated keyframes. 1.4 million 3D boxes. And separately, in the sensor spec table, the lidar produces up to 1.4 million points per second.
[S] Three different 1.4 millions.
[G] Three. Images, boxes, and lidar points per second. If someone hands you a bare 1.4 million from this paper, you genuinely cannot tell which of the three they mean.
[O] Plus the map.
[G] A vector format semantic map with eleven layers — road dividers, lanes, pedestrian crossings, stop lines, traffic lights — covering the operating areas, plus baseline routes an idealized vehicle would follow.
[S] Now the second contribution, which I suspect is the more durable one.
[G] The metrics. Detection first. They use average precision, but a match is defined by thresholding the two dimensional center distance on the ground plane, not by I O U. That decouples detection from object size and orientation. They then average over four distance thresholds — half a meter, one, two and four meters — and over the class set, to get m A P. They also throw away operating points where recall or precision is below ten percent, to cut noise, and if no operating point survives in that region the class gets an average precision of zero.
[O] And then the five error metrics.
[G] Five true positive metrics, all computed at a fixed two meter match. Average translation error, in meters. Average scale error, defined as one minus 3D I O U after aligning translation and orientation. Average orientation error, the smallest yaw angle difference in radians — over a full 360 degree period, except for barriers, which use a 180 degree period. Average velocity error, in meters per second. And average attribute error, defined as one minus attribute classification accuracy.
[S] Directions. Explicitly, please.
[G] All five of those are errors. Lower is better. m A P and N D S are scores. Higher is better. That single distinction is the most common way I see nuScenes tables misread.
[O] And N D S composes them how, exactly?
[G] N D S is one tenth of the following quantity: five times m A P, plus the sum over the five mean true positive metrics of one minus the minimum of one and that metric. So half the score is detection performance — the five times m A P term, over ten — and the other half quantifies the quality of the detections, in terms of location, size, orientation, attributes and velocity, with each error term first capped at one and then flipped into a quality term.
[S] Five error metrics, five slots, one tenth each. That weighting is a stipulation.
[G] It is a stipulation, and the paper reports no sensitivity analysis on it. What it does report is the alternative it rejected. The ApolloScape 3D car instance challenge disentangles the error types by defining thresholds for each error type and each recall threshold, which produces a ten by three grid of thresholds. The paper calls that complex, arbitrary and unintuitive, and proposes a single scalar instead.
[O] Tracking metrics.
[G] They take Weng and Kitani's A M O T A and A M O T P, which average tracking accuracy and precision across all recall thresholds. Then they add a recall adjusted variant of M O T A, written s M O T A r, because nuScenes is hard enough that raw M O T A is often exactly zero. Averaging that over a forty point interpolation of recall in the range point one to one gives s A M O T A, the paper's main metric for the tracking task.
[S] And two brand new ones.
[G] Track initialization duration and longest gap duration. Time from the start of a track until the object is first detected, and the longest detection gap within a track. If an object is never tracked at all, both are assigned the entire track duration. The motivation is specific to driving: many short term track fragmentations may be more acceptable than missing an object for several seconds.
[O] One scope thing I want nailed down before results.
[G] Yes, and it is another unit trap. Twenty three classes are annotated. The detection task uses ten of them. The tracking task uses those ten minus the three the paper calls static — barrier, construction and traffic cone — so seven. When you see twenty three classes in the abstract, that is annotation scope, not benchmark scope.
[S] And the two tasks do not even see the same data.
[G] They do not. Detection may use sensor data in the window from t minus half a second to t. Tracking may use everything from zero to t. Different tasks, genuinely different information budgets, and the paper is explicit about it.
[O] Results. Start with the dataset comparison table, since that is what gets cited.
[G] It compares sixteen datasets, and the caption is explicit about its own rule: bold marks the best entries in every column, but only among the datasets with range data. The image only block at the top is excluded from the bolded comparison entirely.
[S] And here is where I want to be pedantic.
[G] Then be pedantic, because the table rewards it. nuScenes is the sole bolded entry in five columns. R G B images at 1.4 million. Lidar pointclouds at four hundred thousand. Radar pointclouds at 1.3 million. Map layers at eleven. Classes at twenty three. On the scenes column there is a genuine tie — nuScenes and Waymo Open are both bolded at one thousand.
[O] And the columns where it does not lead.
[G] Two of them. On total 3D boxes, the only bolded entry is Waymo Open at twelve million. nuScenes' own 1.4 million is not bold in that column. And the annotated frames column bolds four different rows — nuScenes at forty thousand, Lyft L5 at forty six thousand, Waymo Open at two hundred thousand, and A star 3D at thirty nine thousand.
[S] Four rows bolded, in a column whose own caption says bold indicates the best entry. That is not a winner's column. And nuScenes has the most annotations is a claim I have read in work citing this paper.
[G] The paper itself is straighter than its citers. It says that among the datasets released after it, only the Waymo Open dataset provides significantly more annotations, mostly due to the higher annotation frequency — ten hertz versus two.
[O] Is that a fair deflection or a real defense?
[G] It comes with a gesture at evidence, in a footnote. The authors say that in preliminary analysis they found annotations at two hertz are robust to interpolation to finer temporal resolution, like ten or twenty hertz, and they note H3D reached a similar conclusion, interpolating from two hertz to ten. So the argument is that part of the box count gap is a sampling rate artifact. But they report no numbers from that preliminary analysis.
[S] Score it half.
[G] Half is right.
[O] What about the abstract's own KITTI comparison? Seven times the annotations, a hundred times the images.
[G] The first is exact, the second is rounded generously. 3D boxes: 1.4 million over two hundred thousand is exactly seven. Images: 1.4 million over fifteen thousand is about ninety three, not a hundred.
[S] So of the two superlatives, the softer one is the one people repeat.
[O] Give me the statistics on the released data.
[G] Of the forty thousand keyframes: Boston fifty five percent, Singapore One North 21.5, Singapore Queenstown 13.5, Singapore Holland Village ten. Rain accounts for 19.4 percent, night for 11.6. Per keyframe there are seven pedestrians and twenty vehicles on average. And the class imbalance is severe — a ratio of one to ten thousand between the least and most common class annotations, where KITTI is one to thirty six.
[S] That is the number I would put on the poster, frankly. Two and a half orders of magnitude worse than KITTI on imbalance.
[G] The paper agrees it is severe and then hands it off. Its words are that this encourages the community to explore this long tail problem in more depth. That is an acknowledgment, not a solution, and we will see the consequence in the per class numbers.
[O] Detection results.
[G] Table four, on the test set. The authors' own baselines first. Their re-implementation of orthographic feature transform, image only, combining predictions from all six cameras with non maximum suppression: N D S 21.2 percent, m A P 12.6. An S S D plus 3D single stage image baseline: 26.8 and 16.4. And PointPillars, lidar only, accumulating multiple lidar sweeps with an added velocity regression head: N D S 45.3, m A P 30.5.
[S] And the two leaderboard entries.
[G] MonoDIS, the best image only submission — the table prints the abbreviation M D I S and the caption expands it — reaches N D S 38.4 and m A P 30.4. Megvii, a lidar based class balanced multi head network with sparse 3D convolutions, reaches N D S 63.3 and m A P 52.8.
[O] And Megvii's entire row is bolded.
[G] It is, and this is precisely the bolded versus best distinction. Megvii is best in six of that table's seven columns. On the seventh, average attribute error, MonoDIS's 0.13 beats Megvii's bolded 0.14 — and remember attribute error is an error, so lower wins there. The whole row is bolded. Six of seven are actually best.
[S] Good. Now the comparison I think is the most interesting result in the paper.
[G] PointPillars versus MonoDIS. Their m A P is essentially tied: 30.5 against 30.4. Their N D S differs by 6.9 points: 45.3 against 38.4. The entire gap sits in the error half of the composite. Translation error 0.52 meters versus 0.74. Velocity error 0.32 meters per second versus 1.55.
[O] So the lidar method is not finding more objects. It is placing them better and estimating their motion better.
[G] Exactly that. And the paper reads the tie itself as the headline — it calls the near equal m A P notable, as evidence of how far monocular 3D estimation had come by 2019, given that MonoDIS also significantly outperformed the authors' own image baseline and even some lidar based methods.
[S] This is simultaneously the strongest argument for the composite and against it. N D S surfaced a distinction m A P was hiding. But if you only read N D S you learn PointPillars is 6.9 better and not one word about why.
[G] That is fair, and note that the paper does that decomposition by hand, in prose, precisely because the scalar will not do it for you.
[O] Per class.
[G] Supplementary table seven, same test set, and its mean rows reconcile exactly with table four — 30.5 and 30.4. PointPillars wins the two most common classes: car, 68.4 average precision against 47.8; pedestrian, 59.7 against 37.0. MonoDIS wins the thin and small ones: bicycle, 24.5 against 1.1; traffic cone, 48.7 against 30.8.
[S] Bicycle average precision of 1.1 for the lidar baseline. Under the paper's own fairer matching function.
[G] Under two meter center distance matching, yes. And the paper notes that the top submissions all performed importance sampling during training, which it reads as evidence of how much the imbalance matters in practice.
[O] The sweep ablation.
[G] Val set, PointPillars, and the multi sweep accumulation is the paper's own novel contribution on the modeling side. One lidar sweep: N D S 31.8, m A P 21.9, velocity error 1.21 meters per second. Five sweeps: 42.9, 27.7, and 0.34. Ten sweeps with KITTI pretraining: 44.8, 28.8, and 0.30. Most of the velocity gain arrives in that first jump to five sweeps, which makes sense — you cannot estimate velocity from a single instant.
[S] And pretraining.
[G] At ten sweeps it barely matters. KITTI pretraining gives 44.8 N D S, ImageNet 44.9, no pretraining at all 44.2. The paper's own summary is that final performance only marginally varied between different pretrainings.
[O] The data scaling experiment is the one I found most quietly damaging to the field.
[G] They train PointPillars, orthographic feature transform, and the S S D baseline on varying fractions of the training data, and the method ordering changes with the amount of data. PointPillars performs similarly to the S S D baseline at data volumes commensurate with KITTI, and only pulls clearly ahead past that point. Their conclusion is that the full potential of complex algorithms can only be verified with a bigger and more diverse training set.
[S] Which means every ranking ever published at KITTI scale is provisional.
[G] The paper goes a step further and cites prior work suggesting the KITTI leaderboard reflects the data augmentation method rather than the actual algorithms. Flag that as a citation, not their own finding.
[O] And the matching function ablation.
[G] Under KITTI style I O U matching, small objects like pedestrians and bicycles fail to achieve above zero average precision at all — making ordering impossible, in the paper's own words. Under two meter center distance matching the ordering resolves, and center distance matching declares MonoDIS a clear winner on those classes. For cars the impact is smaller.
[S] So the metric change does not merely move numbers. It determines whether a comparison exists at all.
[G] That is the cleanest way to put it, and I think it is this paper's most transferable contribution.
[O] Weather and location robustness.
[G] Supplementary table six, on the val set, and every cell there is a relative drop in m A P against the full val set, not an absolute score. Singapore costs orthographic feature transform six percent, MonoDIS eight, PointPillars one. Night is where it separates: fifty five percent for orthographic feature transform, fifty eight for MonoDIS, thirty six for PointPillars. The lidar method degrades far less in the dark, which is expected, but good to see measured.
[S] And rain?
[G] Rain barely registers, and the paper explains why in a sentence I want quoted. Orthographic feature transform drops ten percent, PointPillars six, and MonoDIS actually improves by three percent — a negative drop. The explanation is that nuScenes annotates any scene with raindrops on the windshield as rainy, regardless of whether there is ongoing rainfall.
[O] So the rain label is a windshield label, not a weather label.
[G] That is the paper saying it, not me. And there is a second caveat on the night column: night scenes have very few objects, and it is harder to annotate objects with bad visibility. So some fraction of that thirty six to fifty eight percent range is annotation difficulty, not purely perception difficulty.
[S] There is a third caveat on that table, if I read the caption right.
[G] There is. The caption states that the MonoDIS row there uses a ResNet34 backbone and a different training protocol, and is not directly comparable to other sections of this work. So you may compare down that table's columns. You may not carry a MonoDIS number out of it into table four.
[O] Tracking results.
[G] And here is the trap that I think most readers fall into, so let me be explicit about which split every number comes from. In the main body, section 4.2, the numbers are val set. Megvii, PointPillars and MonoDIS achieve s A M O T A of 17.9, 3.5 and 4.5 percent, and tracking precision errors of 1.50, 1.69 and 1.79 meters.
[S] And table eight.
[G] Table eight is the test set, and it is a different run. There, those same three methods read 15.1, 2.9 and 1.8 percent. The top tracking challenge submission, StanfordIPRL-TRI, reaches 55.0 percent using Mahalanobis distance for matching — which the paper describes as significantly outperforming the strongest baseline, by forty points of s A M O T A.
[O] Hold on. Look at PointPillars and MonoDIS across those two sets.
[G] Good catch, and it is the reason to be disciplined about this. On the val set, MonoDIS is ahead at 4.5 against PointPillars' 3.5. On the test set, PointPillars is ahead at 2.9 against MonoDIS's 1.8. The ordering flips between splits. So anyone quoting a body text tracking number alongside a table eight number is comparing two different runs and may well be reversing the result.
[S] That is the best concrete argument for the units discipline you opened with.
[O] All right, let me make the optimist case cleanly. This paper is first with a genuinely complete rig, and the radar pointcloud column in its own comparison table has exactly one non zero entry across sixteen datasets — its own. It shipped eleven map layers when the field's best was seven. And it did not merely build a dataset, it rebuilt the metric, and then demonstrated that the old metric made certain comparisons literally impossible. Eight thousand six hundred citations is not a mystery.
[S] My case. Start with the leaderboard problem. The two headline numbers in table four — Megvii at 63.3 and MonoDIS at 38.4 — are external submissions to a challenge, evaluated on the held out test set. The paper reports them as results. Nowhere does it describe a submission frequency cap, a private versus public test split, or any protection at all against repeated tuning against those labels. The number this paper is most quoted for is the number furthest from the authors' own controlled experiments.
[O] Desmond, is that fair?
[G] It is factually correct, and I checked. The words leaderboard, submission and test set appear only in results framing, never in a methodology or safeguards discussion. Whether nuScenes actually enforced submission limits in 2019 is a separate question. The question here is whether this paper documents them, and it does not. Point to the skeptic.
[S] Second. The privacy pipeline. They blur faces and license plates automatically across 1.4 million images — Faster R C N N with a ResNet 101 backbone trained on Cityscapes for plates, an M T C N N implementation for faces — and they say they set the classification threshold to achieve an extremely high recall, then filter to increase precision. No recall figure. No precision figure. For a public release of 1.4 million street level images across two countries.
[G] Also correct, and I would call it the paper's clearest unforced omission. They ran a detector. They could have reported its operating point in one line. Point to the skeptic.
[O] Where do I score?
[G] Two places, and I think both are solid. First, the metric work is demonstrated rather than asserted. The matching function figure shows that under I O U matching, several methods cannot be ordered at all on pedestrians and bicycles. That is a real empirical result, and it transferred well beyond this dataset. Point to the optimist.
[O] And the second?
[G] The scaling ablation actively works against the authors' own convenience. They could simply have claimed that bigger is better and moved on. Instead they showed that method rankings change with data volume, which implies their own baseline ordering is contingent on the dataset size they happened to release. Papers do not usually publish the experiment that relativizes their own leaderboard. Point to the optimist.
[S] And the superlatives?
[G] Split, and closer to the skeptic. The paper's own prose is accurate — it concedes Waymo Open has significantly more annotations and explains why. The failure is largely downstream, in the citing literature. But the presentation invites it: nuScenes bolds its own row heavily in a table where one column shares bold across four rows, and a skimming reader takes the pattern, not the caption.
[O] One more for me. Is N D S actually a good idea?
[G] A good idea under stipulated weights. The motivation is sound — the paper is explicit that m A P alone cannot capture aspects like velocity and attribute estimation, and that it couples location, size and orientation together. And the alternative it rejected, that ten by three threshold grid, really is unwieldy. But the five times m A P weighting, and the equal one tenth weight on each of the five error terms, are stipulated rather than derived, with no sensitivity analysis. The PointPillars versus MonoDIS case shows both sides of that at once. N D S caught a difference m A P missed, and N D S alone would never have told you the difference was velocity.
[S] What generalizes out of this for people who do not care about driving?
[G] Two things. The matching function insight is the big one. Any evaluation that scores a near miss as a total miss by construction — an overlap threshold, an exact string match, a binary pass or fail — is capable of making comparisons impossible rather than merely noisy. The fix here was to make the match criterion a distance instead of an overlap, and to average over four distances rather than pick one.
[O] And the second?
[G] Composite scores. N D S is an early, widely adopted example of bundling one capability metric with a set of quality metrics into a single number. It bought adoption and it cost interpretability, in exactly the way every composite does. If you build one, publish the decomposition next to it, and expect people to quote only the scalar anyway.
[S] And the eval literacy point, which I will make myself since it is my hobbyhorse. Bolded is not best. Megvii's row is bolded across all seven columns and is genuinely best in six. The annotated frames column bolds four separate datasets. If you are turning a table into a sentence, check the caption's own stated rule against the actual cells.
[G] My takeaway from the paper. The durable contribution here is two part, and the second part is underrated. The full sensor rig was first, and radar genuinely had no prior dataset. But the center distance metric family is what outlived the specific dataset.
[O] Mine. This is what a benchmark paper looks like when the authors run the experiment that could embarrass them. The scaling ablation and the matching function ablation both complicate their own story, and they published both anyway.
[S] Mine. The paper is more careful than its reputation, and it is the reputation that gets cited. Read the table captions. Keep the units attached. And never quote a body text tracking number next to a table eight one.
[O] The full writeup, with the figures, the tables and the references, is on the litsearch site. See you next time.
