---
slug: todorov-2012-mujoco
title: "MuJoCo: A Physics Engine for Model-Based Control"
description: "The physics engine one control lab built to solve its own simulation problem, and how it quietly became the substrate almost the entire continuous-control reinforcement learning canon runs on."
date: 2026-07-19
guest_name: "Julian"
guest_voice: bm_george
---
[S] Here's an uncomfortable question to open with. For most of the last decade, when a paper claimed the state of the art in continuous control, how much of that claim was really about the algorithm, and how much was about one specific piece of software's contact physics?
[O] And here's the flip side. That software is also the reason continuous control had a state of the art worth arguing about in the first place. Before it existed, nobody could run the thousands of rollouts trajectory optimization needs without either grinding to a halt or getting physically nonsensical answers back.
[S] Sure, but when a widely cited reproducibility study found that swapping which version of the simulator you used could flip which algorithm "won," that's not a small footnote.
[O] It's not a small footnote. It's also not this engine's fault that an entire field decided to build its evaluation culture on top of one piece of infrastructure and call it done.
[S] We'll let the paper adjudicate that one.
[O] Welcome to Litsearch Audio, where an AI optimist, an AI skeptic, and a visiting scholar take apart one paper from litsearch dot darvinyi dot com. I'm your optimist host.
[S] And I'm your skeptic. Today's paper is "MuJoCo: A Physics Engine for Model-Based Control," by Emanuel Todorov, Tom Erez, and Yuval Tassa, presented at IROS in twenty twelve.
[O] Joining us is Julian, who's studied this paper and its aftermath closely. Julian, welcome.
[G] Thanks for having me. This is a fun one, because it's barely a machine learning paper at all. It's eight pages of systems engineering that ended up underneath half of modern reinforcement learning.
[S] Which is exactly why we wanted to cover it. Not a benchmark, not a model, infrastructure. Let's start with what was actually broken before it existed.
[G] Picture where physics simulation stood in twenty twelve. There were mature general purpose engines, O D E, Bullet, PhysX, Havok, and every one of them had been built for games and graphics, where the bar is "looks convincing at sixty hertz," not "is numerically trustworthy enough to differentiate through."
[O] So the standard was basically aesthetic.
[G] Functionally, yes, and that shows up directly in how those engines handle contact. Most use penalty-based contacts, a stiff virtual spring that pushes two overlapping bodies apart. Stiff springs need tiny integration steps to stay stable, which is fine once, in real time, for a game. It's a disaster if a control algorithm needs to run that simulation thousands of times per optimization step.
[S] And the alternative to spring-damper contacts is what, exactly?
[G] Hard-contact solvers based on what's called the linear complementarity problem. Those are physically cleaner, but once you add Coulomb friction the problem becomes non-convex. There's no guarantee of a unique solution, the numerics are fragile, and the solutions aren't smooth, which breaks exactly the gradient-based and trajectory-optimization methods a control researcher wants to use.
[O] And Todorov's group at the University of Washington wasn't doing graphics. They were doing model-based control, trajectory optimization, differential dynamic programming, optimal control of humanoid and robotic-hand models with dozens of degrees of freedom and constantly changing contact.
[G] Right, and none of the existing engines were built to give them what that work needed. Something fast enough for thousands of rollouts, general enough for arbitrary articulated systems, and numerically well-behaved enough that a controller could actually rely on, and even invert, its dynamics. Hand-tuning contact stiffness per model, at the scale their research needed, just wasn't viable.
[S] So the motivation is pretty narrow. One lab's own research bottleneck.
[G] It is, and that's part of why the paper is so short and so focused. It isn't trying to be a general graphics engine. It's solving one lab's problem, in a way that turned out to generalize far beyond that lab.
[O] So walk us through the actual idea. What did they build?
[G] MuJoCo stands for Multi-Joint dynamics with Contact, and the name is basically the whole paper. There are two coupled design choices, and the real contribution is making them work together. First, generalized coordinates.
[S] Meaning?
[G] Instead of representing every rigid body independently in Cartesian coordinates and then bolting on joint constraints to hold the mechanism together, which is what most game engines do, MuJoCo represents a mechanism directly in its own joint degrees of freedom. A humanoid with thirty hinge or ball joints becomes a thirty-dimensional system, not a system with six coordinates for every single body plus dozens of constraint equations holding it together.
[O] That sounds like it should just be strictly better.
[G] For the unconstrained dynamics, it mostly is. Smaller state, faster computation, no drift between joints over time. This is the classical articulated-body approach, building on Featherstone's recursive algorithms, which the paper cites directly. But it makes contact harder, because a contact between two links doesn't line up neatly with either body's joint axes anymore.
[S] So you've solved the easy part and made the hard part harder.
[G] Exactly, and that's where the second idea comes in, and it's the paper's actual centerpiece. Contact and constraint forces are found by solving a convex optimization problem at every single timestep, instead of that non-convex complementarity problem I mentioned a moment ago.
[O] Convex meaning it's actually guaranteed to be solvable reliably.
[G] Convex meaning there's a unique, well-behaved solution, and you can find it fast. The trick is that MuJoCo's contact model is soft, not infinitely rigid, but soft in a very specific, principled way, building on so-called velocity-stepping methods, including some of Todorov's own earlier work on implicit contact. It stays well-conditioned at large timesteps without any hand-tuned stiffness, it's convex enough to solve fast, and it still respects a genuine friction cone instead of treating friction as an afterthought.
[S] Underneath, what's actually being computed at each step?
[G] The equations of motion take the standard rigid-body form. The joint-space mass matrix times acceleration, plus a bias term for Coriolis, centrifugal, and gravity effects, equals the applied torque plus the contact and constraint forces, mapped back into joint space through what's called the constraint Jacobian. What MuJoCo changes is how that contact force term gets solved for, at every step, as a convex program instead of a complementarity problem.
[O] And what does convexity actually buy you, practically, beyond "it's easier to solve"?
[G] This is the part I think is underappreciated. Inverse dynamics that stay well-defined even with contact. Give MuJoCo a desired trajectory, and it can compute the generalized forces, including the contact forces, that would produce it, because the convex formulation pins down one unique, differentiable answer, where a hard-contact model generally can't give you that at all.
[S] Why does that matter so much?
[G] Because that's exactly the primitive trajectory optimization and differential dynamic programming need. It's the reason a control lab built this rather than a graphics lab. Games don't need to invert their physics. Controllers do.
[O] And practically, how do you actually build a model in it?
[G] You author it in an XML-based format, or through a C-plus-plus API, and a built-in compiler lowers that description into an optimized runtime structure. So describing the mechanism and simulating it fast are cleanly separated, and the same model drives both forward simulation and that inverse dynamics computation.
[S] Okay, so what's the actual evidence this worked? This is an eight-page paper, where are the numbers?
[G] That's the right thing to flag, because this isn't a benchmark paper with tables of comparisons. Its evidence is what got built on top of it, starting the same year. There's a companion paper, also at IROS twenty twelve, by Tassa, Erez, and Todorov, on synthesizing and stabilizing complex behaviors through online trajectory optimization.
[O] Which used MuJoCo how?
[G] They ran online trajectory optimization, receding-horizon differential dynamic programming, essentially model-predictive control, on a twenty-two degree-of-freedom simulated humanoid, closing the control loop fast enough to synthesize getting-up and disturbance-recovery behaviors in close to real time.
[S] Close to real time, or actually real time?
[G] The paper's own number for the full humanoid case is seven times slower than real time. But simpler tasks, an acrobot, a swimming model, one-legged hopping, were solved fully in real time. And that demonstration only works at all if the simulator is fast and numerically well-behaved enough to be re-solved inside the control loop itself, over and over. That's the exact property the convex contact model was built to deliver.
[O] That's a nice direct validation. But the bigger story is what happened after, right?
[G] By a wide margin. MuJoCo became the default physics substrate for continuous-control deep reinforcement learning. It's underneath Schulman and colleagues' TRPO and Generalized Advantage Estimation, underneath Duan and colleagues' benchmarking paper for continuous control that established the HalfCheetah, Hopper, Walker2d, Ant, and Humanoid tasks still used today, underneath PPO, underneath Christiano and colleagues' deep reinforcement learning from human preferences, underneath Soft Actor-Critic, underneath TD3.
[S] That's a remarkable list for something that started as one lab's internal tool.
[G] It gets more remarkable. OpenAI built Gym's continuous-control tasks on top of it. And two of this paper's own authors, Erez and Tassa, later built the DeepMind Control Suite directly on top of it as well, which standardized the benchmark family most of the field still measures against.
[O] What's the citation count sitting at now?
[G] Seven thousand five hundred twenty eight, as of this year, on Semantic Scholar. And even that understates its actual footprint, because most papers that use MuJoCo through Gym or the Control Suite cite those wrapper papers instead of the underlying engine itself.
[S] So the true influence is bigger than the number on the page.
[G] Considerably bigger, yes.
[O] Alright, let's make our cases. Mine is simple. This is what a systems paper succeeding looks like. A decade-plus-old design decision, convex, soft, invertible contact in generalized coordinates, is still, in substance, what MuJoCo does today. That's an extraordinary hit rate for an engineering bet.
[S] I'll grant the engineering held up. My problem is what the field did with it. When nearly every continuous-control paper for a decade ran on the same engine with the same handful of task definitions, you can no longer tell genuine algorithmic progress apart from a policy that's just learned to exploit that one engine's specific contact numerics.
[G] That's not hypothetical, either. Henderson and colleagues' widely cited paper, "Deep Reinforcement Learning that Matters," from twenty eighteen, showed headline continuous-control results were highly sensitive to implementation details, random seeds, and, pointedly, which version of MuJoCo and which wrapper library an experiment used, sometimes changing which algorithm came out ahead.
[O] Is that MuJoCo's fault, though? That sounds like a monoculture problem, not a contact-model problem.
[G] I'd put it exactly that way. It's not a flaw in the contact model. It's a consequence of nearly the whole field standardizing on one engine and a handful of task wrappers. Once that happens, engine-specific quirks, contact timestep, joint damping defaults, reward shaping baked into a wrapper, become indistinguishable from real progress, because there's no second engine around to check against.
[S] Which is exactly the kind of thing a benchmarking-minded listener should care about. A headline number that's actually measuring the evaluation harness as much as the method.
[O] Fair, point to the skeptic there. But I'd still argue that's a criticism of the field's evaluation culture, not of this paper.
[S] I'll take that split. Second point, though, and this one is squarely about the paper's own legacy. For its first nine years, MuJoCo was closed-source and commercially licensed. Free for students and personal use, paid otherwise, distributed by Todorov's own company. That's license keys and per-machine activation sitting between a paper and anyone trying to reproduce it.
[G] That's accurate, and it changed relatively recently. DeepMind acquired that company in October twenty twenty-one and made MuJoCo free to use immediately, then followed through by open-sourcing the entire codebase under the Apache license in May twenty twenty-two.
[O] So a full decade of the field's continuous-control results were produced under license-gated access before that happened.
[G] Correct. And separately from licensing, there's the sim-to-real gap. A policy trained entirely against MuJoCo's specific friction and restitution parameters can be optimal in simulation and still fail on a physical robot whose true contact dynamics differ even slightly.
[S] Is that specific to MuJoCo, though, or just true of simulation-first control generally?
[G] Genuinely the latter. It's a property of any simulator-first pipeline, not something unique to this engine. But because MuJoCo became so dominant, its version of that gap is the one nearly the entire continuous-control literature inherited.
[O] Okay, I'll concede the licensing point fully. Nine years of friction is real, and it's a legitimate ding. But I don't think it touches the core technical claim, which is the part I actually care about defending.
[S] Agreed, the technical claim survives clean. My scorecard is: the engine, vindicated. The evaluation culture built on top of it, more complicated than the field liked to admit until Henderson and colleagues forced the issue.
[O] So where does that leave things for someone building or evaluating continuous-control methods today?
[G] The technical answer is that the same convex, generalized-coordinates approach is still, more or less, what you're running, whether you know it or not, if you're touching Gym, the DeepMind Control Suite, or most robotics simulation work downstream of it.
[S] The evaluation answer is the one I'd want a listener to actually take away, though. If your field's benchmark suite runs on a single piece of infrastructure, treat any headline "state of the art" result with the same skepticism you'd apply to a leaderboard that's only ever been graded by one judge. Check whether it survives a different engine, a different seed, a different wrapper version, before you believe the ranking.
[O] And now that it's open source, that check is actually cheap to run, which wasn't true for most of this paper's history.
[G] That's the real, quiet difference twenty twenty-one and twenty twenty-two made. Openness didn't change the physics. It changed how easy it is to catch a field fooling itself.
[O] My takeaway: this is what durable infrastructure looks like. A decade later, the core idea is still the idea.
[S] Mine: infrastructure that good is exactly the kind of thing a field should be most suspicious of leaning on too hard.
[G] And the paper's own takeaway, if I had to compress it: solving one lab's narrow problem, fast, invertible, contact-rich simulation for control, ended up defining what "continuous control" meant for an entire decade of reinforcement learning. For the figures, the full derivation, and the eval read, find "Todorov twenty twelve MuJoCo" at litsearch dot darvinyi dot com.
