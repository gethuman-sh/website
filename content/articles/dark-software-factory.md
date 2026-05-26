---
title: "What is a Dark Software Factory?"
subtitle: "The last place where humans still belong in software, and why I called my product after it."
description: "The dark software factory is the category for fully autonomous AI software delivery: agents write, test, and ship code while humans stay on intent, policy, and outcome review. Origin, five levels, StrongDM example, critiques, and where humans belong in the stack."
author: "Stephan Schmidt"
date: 2026-04-08
tags: ["dark-factory"]
definedterm: "Dark software factory"
---

<aside class="tldr">
  <span class="tldr-label">TL;DR</span>
  <p>A dark software factory is an autonomous software delivery pipeline where AI agents write, test, and ship code from specifications, and no human reviews the diffs. The name comes from lights-out manufacturing, where robots make things in factories with the lights off because no one is on the floor. The term was applied to software in early 2026 by Dan Shapiro. BCG Platinion and i-SCOOP picked it up as the category label for Level 5 AI-assisted coding, and StrongDM is the most-cited proof-of-concept. Humans are not removed from this model. They move upstream and downstream: intent, policy, outcome review. The middle, the actual writing and reviewing of code, is machine-driven.</p>
</aside>

## Where the name comes from

In manufacturing, a dark factory (also called lights-out manufacturing) is a production plant where robots run the line and humans are not on the floor. Because no one is there, the lights can stay off. FANUC, the Japanese robotics company, built one of the first serious ones in the 1980s, a factory where robots built other robots, 24 hours a day.

The metaphor moved to software in early 2026. Dan Shapiro proposed a five-level framework of AI autonomy in coding, modeled on the six levels of self-driving car autonomy. At the top of the ladder, Level 5, sat what he called **the dark factory**:

> The dark factory. AI is evaluated against scenarios it has never seen — stored separately so it cannot optimise for passing them during development. The evaluation is genuinely independent. No human writes or reviews code.[^shapiro]

The five levels, roughly:

0. AI suggests the next line as you type. Developer is still writing the software.[^shapiro]
1. Developer gives AI a discrete task and reviews what comes back.[^shapiro]
2. AI handles changes across multiple files. Developer still reads all the output.[^shapiro]
3. Developer no longer writes code. They direct AI and review at the feature level.[^shapiro]
4. Developer writes a specification and steps away. AI builds and tests. Developer reviews outcomes, not code.[^shapiro]
5. The dark factory. Evaluation is independent. No human writes or reviews code.[^shapiro]

Most developers are somewhere between Level 2 and Level 3 today. The interesting question is what happens at Level 5, and whether the jump from Level 4 to Level 5 is a research problem or an engineering problem. I will argue it is an engineering problem, and that the engineering is mostly about the stuff around the model, not the model itself.

## The canonical definition

BCG Platinion has done the most to push the term into enterprise vocabulary. Their definition:

> In a Dark Software Factory, Autonomous AI agents build, test, and ship software solutions around the clock, while humans define business intent and review outcomes...[^bcg]

i-SCOOP frames it almost identically and adds the crucial detail about the human role:

> A dark software factory is an autonomous software delivery environment where AI agents build and refine software from specifications and scenarios instead of relying on manual coding and line by line human review.[^iscoop]
>
> [Humans] define business intent, approve stage gates, curate knowledge, set policies and review outcomes rather than touching every implementation detail.[^iscoop]

The shift is not "no humans". It is: humans move upstream (intent, specs, policy) and downstream (outcome review), and the middle, the actual writing and reviewing of code, is machine-driven. The scarce resource in a dark factory is not the model. It is precise, testable intent.

## How it differs from AI-assisted coding

This is the distinction that matters most, because every developer using Copilot or Cursor today thinks they are already doing some version of this. They are not. HackerNoon puts it bluntly:

> The bottleneck didn't disappear. It packed up and moved down the hall.[^hackernoon]

In AI-assisted coding, the human is still the reviewer, and the reviewer is the bottleneck. Throughput is gated by how fast you can read and approve diffs. A 10x speedup in writing code does not give you a 10x speedup in shipping, because you still have to read the code.

The dark factory pattern breaks this by removing the human from the review step entirely, and replacing manual review with a different mechanism: **holdout scenarios**. The system is evaluated against test scenarios that the coding agent has never seen during development. It is the same train/test split that makes supervised machine learning honest. HackerNoon again, on the holdout principle:

> the coding agent never sees these scenarios. Ever.[^hackernoon]

This is the architectural insight that turns "AI that writes code fast" into "AI that ships code reliably". Not a smarter model. A cleaner separation between who writes and who grades.

## The canonical example: StrongDM

Simon Willison's writeup of StrongDM is the most-cited proof point for the pattern.[^willison] A small team runs a software factory under two rules:

> Code must not be written by humans.[^willison]
>
> Code must not be reviewed by humans.[^willison]

Markdown specifications go in. Working software comes out. The humans approve outcomes. They do not touch the code in the middle.

How do they get away with no code review? Three mechanisms, all load-bearing:

**1. Scenario tests stored outside the codebase.** The scenarios that decide whether the code is good are kept separately, and the coding agents never see them during development. When the software is complete, the scenarios test it from the outside, the same way a holdout set tests whether an ML model has learned or memorised.

**2. A Digital Twin Universe.** StrongDM built behavioural clones of the third-party services their software depends on: Okta, Jira, Slack, Google Docs, Google Drive, Google Sheets.[^willison] The twins replicate API surfaces, edge cases, and observable behaviours. This lets the factory test at volume without hitting rate limits, without risking production, and without waiting on flaky external services.

**3. Satisfaction metrics.** Instead of a binary pass/fail, they measure the fraction of observed trajectories that likely satisfy a user. Probabilistic validation, not deterministic assertions. This is how you decide "ship" in a system that produces slightly different code on every run.

There is also a cost principle worth flagging. StrongDM hold themselves to this standard:

> If you haven't spent at least $1,000 on tokens today per human engineer, your software factory has room for improvement.[^willison]

Read that carefully. It is not a cost estimate, it is a **floor**. A cultural assertion that if your token burn is below $1k per engineer per day, you are not using the factory hard enough. Today this makes dark factory adoption practical only for well-funded teams. If token costs follow their trajectory, the floor stops being a barrier within a couple of years.

## What this means for the enterprise (per BCG)

BCG Platinion argues the dark factory changes four things about how enterprises should think about software:[^bcg]

1. **It unlocks stranded capital.** Most enterprise IT budgets are consumed by maintenance and by legacy modernisation programs that were shelved because they were too expensive. When development capacity multiplies, those programs become viable again. Code that was "too expensive to touch" is no longer.

2. **It rewrites build vs buy.** When custom development compresses from months to weeks, custom solutions become competitive with SaaS for more categories. The question is no longer "can we buy this" but "is there any reason not to build this, tailored to us?"

3. **It shifts the source of competitive advantage.** Coding speed used to be a moat. In a world where every team has a dark factory, coding speed is table stakes. The new moat is proprietary data, domain knowledge, and *intent quality*: how well you can describe what you want.

4. **It compresses competitive cycles.** Industries where one participant adopts dark-factory delivery force everyone else to match the pace or lose.

BCG reports productivity gains of 3 to 5x on average for organisations operating at this level.[^bcg]

## The sceptical counter-view

Not everyone thinks this works. The critique is worth taking seriously, because the dark-factory discourse has some of the flavour of hype cycles past, and the enthusiasts have tended to skip over the hard parts. Here is the sharpest version of the case against, and my own read, which goes further than I have seen anyone else go publicly.

**The METR study.** In 2025, METR ran a randomised control trial on experienced open-source developers working on their own repositories.[^metr] The developers were 19% slower with AI tools than without. But before the trial, they forecast they would be 24% faster with AI, and even after the trial, looking back, they still estimated they had been roughly 20% faster.[^metr] Wrong in direction, wrong in magnitude, and wrong even in hindsight. If the baseline case for the dark factory is "AI makes developers more productive on real code", the evidence is thinner than the marketing suggests, at least for experienced developers working on code they know.

**"Prompt engineering with extra steps."** A pointed Medium essay by "polyglot_factotum" makes the strongest public critique I have seen of the StrongDM approach. Three of the essay's own phrases:

> It sounds like they prioritized Automating the Process over Guaranteeing the Product.[^medium]

On the specification-by-prose approach:

> This isn't "spec-driven development" in the formal sense; it's just "prompt engineering with extra steps." It lacks the rigor that actually guarantees safety.[^medium]

And on the likely outcome:

> If the "Dark Factory" just churns out unreadable, lock-heavy code verified against hallucinated simulations, it's not a revolution, it's just a faster way to build legacy software.[^medium]

The serious version of this critique is that a markdown specification is not a formal specification, and the digital twins StrongDM validates against are themselves built by interpretation rather than proof. A factory that ships polished code that is subtly wrong in a way that only surfaces in production is not a revolution, it is a new flavour of technical debt at unprecedented scale.

### The limit nobody in the category wants to name

I want to go further than the Medium critique, because I think the Medium critique, while correct, stops one step short of the actual problem.

The whole appeal of the dark factory pattern rests on a promise of **independent verification**. The coder writes code, something else checks the code, and because the checker is separate from the writer, you can trust the verdict without reading the diff yourself. The holdout scenarios HackerNoon celebrates, the Digital Twin Universe Willison describes, the multi-agent pipelines on every AI engineering blog this year: they are all mechanisms for achieving that separation.

But if you actually try to build a pipeline with genuinely independent verification for a novel feature, you discover something uncomfortable: **there is no architectural trick that delivers it.** There are only three plausible sources of independence, and for novel features each one either doesn't apply or doesn't hold up:

**1. Independence by external oracle.** Test the code against an authority that exists outside your pipeline: the API contract of an upstream service, a regulatory invariant, a golden output from a previous production system, a property-based invariant from a type system. This is genuinely independent because nobody in your factory authored the check. It is also the purest form of what StrongDM actually does. Their digital twins of Okta, Jira, Slack, and Google services are external oracles: the upstream services are authoritative about their own behaviour. When StrongDM tests against a twin, they are testing against a faithful model of something outside the factory.

But notice what StrongDM is building: integration code. Their product category is "software that talks to other software". Their problem domain is unusually well-suited to external oracles because external oracles are precisely what you work with when you build integrations. Generalise from this to "a rate limiter for your own API" or "a new dashboard view" and the oracle disappears. There is no external authority about what *your* new feature should do. The thing you are building is new. The whole point of building it is that nobody has defined it before. You cannot test against an authority that does not exist.

This is not a temporary engineering gap that better tooling will close. It is a structural feature of novel work.

**2. Independence by model diversity.** Use Claude for the coder and GPT for the evaluator, and hope that two different model families, trained on different data with different biases, will hallucinate in different enough directions that running them both catches more bugs than running either alone. This is the folk-wisdom justification behind most multi-agent architectures marketed as dark-factory setups.

I am increasingly sceptical this actually works the way the marketing implies. Frontier LLMs are all trained on substantially overlapping corpora (the public internet plus similar curated datasets), and they converge on similar interpretations of ambiguous text more than you would hope. When you give Claude and GPT the same sentence from a ticket, they are more likely to reach the same interpretation than two humans with genuinely different backgrounds would be. They share priors.

And the deeper problem is worse: **Claude's intra-run variance is probably comparable to Claude-vs-GPT variance for most interpretation tasks.** If running Claude twice gives you approximately as much diversity as running Claude and GPT once each, then "multi-model" is not achieving oracle independence. It is achieving noise reduction. Useful, but much weaker than the word "independent" implies.

For model diversity to deliver genuine independence you would need **deterministic, structurally different hallucination patterns** between models. Claude reliably wrong about X, GPT reliably wrong about Y, with X and Y disjoint for most real tickets. I have not seen anyone measure this rigorously, and my experience running the same work through multiple models is that they mostly fail on the same ambiguities, not on different ones.

**3. Independence by pre-committed invariants.** Property-based testing, fuzzing, and pre-written safety properties ("must not crash on malformed input", "must not leak credentials", "must handle empty arrays"). These give you genuine independence because they were written without knowledge of the specific feature. They fire against any code that violates them, regardless of what the ticket said.

But pre-committed invariants have a fundamental ceiling, and it is the same ceiling that has limited formal verification for fifty years: **they catch safety properties (bad things don't happen) but they cannot catch liveness properties (the right good things happen).** Fuzzing can tell you "under no input does this rate limiter crash". It cannot tell you "this rate limiter actually rate-limits". For the second question, you need a specification of what rate-limiting means, and now you are back to the interpretive root problem: someone has to author the "did the feature do the thing" check, and that someone becomes the oracle.

You cannot fuzz your way to "the feature matches the intention in the product manager's head". The intention exists only in the head. No pre-committed invariant reaches it.

### What this means, stripped down

Put the three mechanisms together and a hard conclusion falls out:

**For novel features, the dark factory cannot deliver independent verification.** The mechanisms that give genuine independence (external oracles) only apply to a small niche of problems. The mechanisms that pretend to give independence (multi-agent pipelines, model diversity) achieve process isolation and noise reduction but not oracle independence. The mechanisms that formally prove independence (pre-committed invariants) only catch safety properties, not liveness properties, so they cannot answer whether the feature matches the intention behind it.

The dark factory automates the middle of the pipeline. The ends are irreducibly human. Someone has to decide what the feature is (intent), and someone has to decide whether the output actually matches that intent (verification against unwritten judgement). Container boundaries and multi-agent orchestration cannot touch those two ends for novel work. They only clean up what happens between them.

This is not a fatal flaw. A pattern that dramatically reduces the cost of shipping code while leaving the ends in human hands is still enormously valuable. But it is not the pattern the category is selling. The category is selling "AI agents build, test, and ship software solutions around the clock, while humans define business intent and review outcomes", with the implicit promise that "review outcomes" is cheap because the verification is independent and automatic. For the integration-code corner of the industry, that promise holds. For the rest of us building novel features, "review outcomes" is doing a lot of load-bearing work that the marketing glosses over, and anyone planning a dark-factory adoption should know this going in.

### The honest version of the pattern

Strip the category's overclaim away and here is what remains, which I think is still a real and valuable thing:

- **Process isolation between agents catches coder-side scope drift.** A coder with only the ticket in its context cannot optimise against tests it can see, because it cannot see them. This is a genuine improvement over single-agent pipelines even if it does not give you true oracle independence.
- **Pre-committed safety invariants catch the class of bug that property-based testing was invented to catch.** Missing nil checks, injection vulnerabilities, resource leaks, unchecked error paths. These are worth having even if they do not validate intent.
- **External oracles should be used wherever they exist.** If your feature has a contract, a regulatory rule, or a golden output to test against, the factory becomes genuinely closer to dark-factory status in exactly those places. Use them where they exist, and do not pretend they exist where they do not.
- **Humans stay on intent and on verification of liveness properties.** This is not a failure of the pattern, it is the correct allocation of the work. The humans who used to review diffs now decide whether the feature does the thing. The review discipline changes, but the judgement call does not disappear and should not be automated away even if it could be.

The winners in this space will be the teams who treat the dark factory as a cost-reduction pattern with a genuine epistemological ceiling, and who design their engineering process around the ceiling instead of pretending it is not there. The losers will be the teams who buy the marketing, adopt the pattern, and ship fast, confident, subtly broken code until a production incident makes the ceiling visible the expensive way.

## The two things that actually matter

Both the BCG piece and the i-SCOOP piece collapse the whole discipline into two skills. I think they are right.

**Harness engineering.** Designing and continuously tuning the factory itself: the agent orchestration, the memory layer, the evaluation harness, the digital twins, the policy gates, the deployment pipeline. The factory must be engineered, not improvised.[^iscoop] A team that treats their AI coding setup as "whatever the model happens to do" will not get dark-factory results, regardless of which model they use. The model is the engine. The harness is what turns the engine into a factory.

**Intent thinking.** Translating business needs into precise, testable, operationally useful specifications. This is the part that is genuinely hard and genuinely new. Ticket writing and PRD writing are adjacent skills, but they are not the same. A ticket that is fine for a human developer, who will ask clarifying questions in standup and use judgement to fill gaps, is a disaster for an autonomous agent, which will fill the gaps with plausible-looking wrong answers. In a dark factory, ambiguity is amplified, not absorbed. Ambiguity in the spec becomes ambiguity in the code, which becomes bugs in production.

The core skill is not prompting. It is intent.

## Where humans actually belong

I keep seeing the dark factory described as "removing humans from software". It is not. It removes humans from one specific part of software, the part that was an artefact of the limitations of the last generation of tools: writing and reviewing code line by line. Humans still belong in the loop. They belong in different places.

Three of them, specifically:

**Intent in.** Somebody has to decide what to build and say so in terms that a machine can act on. Tickets, docs, designs, analytics, the real context the agent needs to build the right thing instead of any thing. This is upstream work, and it is the hardest work in the stack, because it is where taste and judgement and domain knowledge live.

**Policy around the line.** Somebody has to decide what the factory is allowed to do. Which credentials it can touch. Which domains it can call. Which files it can read. Which external services it can reach. In a lights-out factory, there are still fences. The question is who draws them.

**Review on outcomes, not diffs.** Somebody has to decide when the output is good enough to ship. Not by reading the code, but by checking the outcomes: did the scenarios pass? Did the user story get satisfied? Did the metric move? This is a different review discipline than "did the PR pass CI and lint", and most engineering teams are not yet trained in it.

If you do all three of these well, you get a dark factory that works. If you skip any of them, you get a fast way to ship bugs.

## How this changes the engineer's job

I have been an engineering manager for 25 years, a CTO for roughly 10 of those, and a CTO coach for the last 8. I have spent the last two years watching what AI actually changes on the ground inside real engineering teams, not in demos. Here is my read on what the engineer's job becomes in this world.

**What disappears.** Hand-writing CRUD endpoints. Boilerplate authentication. Writing unit tests that check what the function you just wrote does. Reading a 400-line PR to find the three lines that matter. Mechanical refactors. Most of "programming" in the 2010s sense.

**What grows.** System design. Writing specifications that a machine can execute against. Building evaluation harnesses. Curating context for agents. Setting and enforcing policy. Reviewing outcomes. Making judgement calls about taste, scope, and tradeoffs that only a human who understands the business can make.

**What remains genuinely valuable.** Deep understanding of the problem domain. The ability to say no to bad ideas. Architectural judgement. Security intuition. User experience intuition. These do not go away. They become more concentrated, and more valuable per person.

The shape of an engineering team changes. You need fewer people, but the people you need are more senior. Junior engineers do not become obsolete, but the entry-level job changes: from "write code under supervision" to "help define intent and review outcomes under supervision". That is a harder job to learn on the first day, and the industry has not figured out how to onboard people into it yet.

## What a dark factory actually needs to work

Enough with the theory. If you were going to build a dark-factory setup tomorrow, here is the minimum viable list of components:

1. **A capable coding model.** Claude Opus 4.5/4.6 or GPT 5.2 as of early 2026. This is the cheap part.
2. **A harness.** Agent orchestration, memory, tool access. Not a chat interface.
3. **Context pipes.** Connections to your issue tracker, your docs, your design system, your analytics, your error tracking. The agent has to see the same context a human engineer would see.
4. **A policy layer.** Credential isolation (secrets never touch the agent), outbound network controls, audit logging. The factory runs in a fence.
5. **An evaluation harness.** Scenario tests stored outside the codebase, ideally with digital twins of any third-party services you depend on. This is the make-or-break piece. Skip it and you have built a very fast way to ship bugs.
6. **An outcome review discipline.** Humans who know how to approve based on scenario results, not diffs.
7. **Intent-writing skill.** Senior people who can write specifications precise enough for an agent to execute.

The first two are commodity. The next three are where most teams fail because they underinvest. The last two are cultural, and they take the longest to build.

## Where human fits

This site is called human because in a dark factory, the only thing left for humans to do is the part that actually matters: intent, policy, outcome review. That is what the product is for.

human is the part of the dark factory stack where the humans belong. It is the tool that lets you:

- Feed Claude Code real context from your trackers, docs, designs, and analytics. **Intent in.**
- Run Claude Code in a secure devcontainer with credential isolation, outbound allowlists, and audit trails. **Policy around the line.**
- Ideate, plan, execute, and review work through structured skills that map onto the lifecycle. **Review on outcomes, not diffs.**

I did not set out to build a dark-factory tool. I set out to build the tool I wished I had as a CTO trying to use Claude Code on real work. The dark-factory framing arrived later, and when it did, it was an exact fit for what human was already doing. The category gave the product a name for the problem it was already solving.

If you want to run a dark factory, you need all seven components from the list above. human gives you three of them (context, policy, review workflows) and stays out of your way on the other four. No grand ambition to be the whole stack. Just the part where the humans belong.

## Further reading

- [Getting to the Dark Software Factory](/getting-to-the-dark-software-factory/) — the follow-up on building one in practice: lanes, qualifiers, and the forager that cherry-picks work.
- [Yes, You Can Run a Dark Factory on Your Codebase](/run-a-dark-factory-on-your-codebase/) — what works today, and how to ship your first dark-lane ticket this week.
- [The Dark Software Factory](https://www.bcgplatinion.com/insights/the-dark-software-factory) by BCG Platinion, the strategic take.
- [Dark software factories and the future of autonomous software delivery](https://www.i-scoop.eu/dark-software-factories-and-the-future-of-autonomous-software-delivery/) by i-SCOOP, the operational take.
- [How StrongDM's AI team build serious software without even looking at the code](https://simonwillison.net/2026/Feb/7/software-factory/) by Simon Willison, the canonical example.
- [The Dark Factory Pattern: Moving From AI-Assisted to Fully Autonomous Coding](https://hackernoon.com/the-dark-factory-pattern-moving-from-ai-assisted-to-fully-autonomous-coding) on HackerNoon, the architectural distinction.
- [Dark Factories: The Five Levels of AI Automation](https://www.cow-shed.com/blog/dark-factories-five-levels-ai-automation-transform-audit-banking-legal) on Cow-Shed, Dan Shapiro's framework.
- [Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/) by METR, the productivity RCT.
- [Dark Factory AI Review: Innovation or Slop?](https://medium.com/@polyglot_factotum/slop-review-with-ai-the-dark-factory-ffca22406822) on Medium, the formal-methods critique.

*If this piece was useful, read the follow-up: [Beyond the Dark Factory](/beyond-dark-factory/), on the two levels past Level 5 and where humans still hold the line. Or [install human](/docs/getting-started/installation/) and see the [features overview](/features/) to see which parts of the dark factory stack it covers.*

[^shapiro]: Dan Shapiro's five-level framework for AI autonomy in coding, as summarized in [Dark Factories: The Five Levels of AI Automation and How They Will Transform Audit, Banking, and Legal Work](https://www.cow-shed.com/blog/dark-factories-five-levels-ai-automation-transform-audit-banking-legal) on Cow-Shed Startup.

[^bcg]: [The Dark Software Factory](https://www.bcgplatinion.com/insights/the-dark-software-factory), BCG Platinion. The definition is quoted from the "What Is the Dark Software Factory?" section. The productivity figure of 3 to 5x also appears in the same source.

[^iscoop]: [Dark software factories and the future of autonomous software delivery](https://www.i-scoop.eu/dark-software-factories-and-the-future-of-autonomous-software-delivery/), i-SCOOP. The i-SCOOP quote about humans begins with "They" in the original and is bracketed above for clarity. The phrase "The factory must be engineered, not improvised" also appears in this article.

[^hackernoon]: [The Dark Factory Pattern: Moving From AI-Assisted to Fully Autonomous Coding](https://hackernoon.com/the-dark-factory-pattern-moving-from-ai-assisted-to-fully-autonomous-coding), HackerNoon.

[^willison]: [How StrongDM's AI team build serious software without even looking at the code](https://simonwillison.net/2026/Feb/7/software-factory/), Simon Willison, February 2026. The two rules are presented in the original as separate emphasized statements. The $1,000 per day figure is StrongDM's own cultural principle, not a cost estimate: Willison reports it as a minimum threshold the team holds themselves to, not the average cost of the pattern. The list of digital-twin services (Okta, Jira, Slack, Google Docs, Drive, Sheets) is drawn from the same piece.

[^metr]: [Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/), METR, July 2025. Randomised control trial of 16 experienced open-source developers across 246 tasks. Developers were 19% slower with AI tools. Pre-study forecast was 24% faster; post-study hindsight estimate was approximately 20% faster. The full paper is on [arXiv](https://arxiv.org/abs/2507.09089).

[^medium]: [Dark Factory AI Review: Innovation or Slop?](https://medium.com/@polyglot_factotum/slop-review-with-ai-the-dark-factory-ffca22406822) by "polyglot_factotum" on Medium. The three quoted passages appear in different sections of the essay and are presented here as three separate quotes rather than a single block, to preserve their original context.
