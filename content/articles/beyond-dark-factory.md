---
title: "Beyond the Dark Factory"
subtitle: "Two levels past Level 5, and where humans still hold the line."
description: "Level 6 is a self-optimizing factory that tunes its own harness. Level 7 is a factory that sources its own intent by talking to customers and reading telemetry. Each level pulls more meta-work inside the machine. Here is what each one unlocks, what it still cannot do, and where the product human goes from here."
author: "Stephan Schmidt"
date: 2026-04-11
tags: ["dark-factory"]
---

<aside class="tldr">
  <span class="tldr-label">TL;DR</span>
  <p>The first piece stopped at Level 5, the dark software factory. Two more levels are already visible from here. Level 6 is the self-optimizing factory: the harness measures itself, tunes itself, and compounds. Level 7 is the autonomous ideation factory: the factory reads customer signals and generates its own tickets. Each level pulls a loop that used to be human inside the machine. The meta-work is the new frontier, not code-writing. The scarce resource at Level 7 is taste, and taste does not move inside the factory. human is a Level 5 harness today; the next step for it is Level 6.</p>
</aside>

## Where we left off

[The previous piece](/dark-software-factory/) walked through Dan Shapiro's five-level framework for AI autonomy in coding and argued that Level 5, the dark factory, is where humans stop touching code and move to the ends of the pipeline: intent on the way in, policy around the work, review of outcomes on the way out.[^shapiro] It also argued, against the category's marketing, that two things remain irreducibly human even at Level 5. Someone has to decide what to build, in terms precise enough that a machine can act on them. And someone has to decide, after the fact, whether what came out matches the intention behind it. Those two ends did not yield to multi-agent pipelines, model diversity, or pre-committed invariants, at least not for novel features.

Level 5 is also where the existing literature stops. BCG Platinion, i-SCOOP, and the StrongDM writeup all treat Level 5 as the terminal state of the category.[^bcg][^iscoop][^willison] Shapiro's ladder only has five rungs. There is nothing official above the dark factory.

But the direction of travel is clear, and two more levels are already being experimented with in public. They are not further rungs on the same ladder. They are something different: the factory starts absorbing work that used to sit outside it. The meta-work, the work about how the work gets done, and eventually the work about what work to do. This piece maps those two levels, names what each one unlocks and what each one cannot deliver, and says where I think `human` sits in that extended world.

## Level 6 — The self-optimizing factory

**What it is.** At Level 5 the factory ships code and someone, usually the team that runs it, tunes the factory itself: prompts, agent orchestration, memory policy, evaluation harness, digital twins. Shapiro's framework and every writeup of the pattern treat this as human work. Level 6 is what happens when the factory starts doing that work on itself. It instruments its own runs, tracks its own regression rate against holdout scenarios, rewrites its own prompts when a rewrite wins on measurable outcomes, retunes its own agent selection, retires its own digital twins when they drift out of correspondence with the real services they model. The first-order loop of harness engineering moves inside the factory.

**What it unlocks.** The previous piece named two load-bearing skills for the dark factory: harness engineering and intent thinking. Harness engineering is the higher-leverage of the two, because it compounds. A factory that can tune itself gets better at shipping every feature it ships. Every completed ticket is not just a delivered outcome but a data point about what works in the harness, which prompts survive contact with real code, which agent splits produce the cleanest handoffs, which memory strategies keep the context from degrading at the tail of long runs. At Level 5 you have to pay a harness engineer to read that data. At Level 6 the factory reads it for you. This is the difference between a pipeline that is fast and a pipeline that is getting faster.

**What it requires.** A self-optimizing harness needs three things that are not optional.

- A reliable meta-evaluation loop. The factory needs to grade *itself* the way Level 5 grades the code it ships. Without a meta-oracle you are Goodharting on whatever internal signal you chose, and Goodhart is not a warning, it is a guarantee.
- A change-safety discipline for the factory's own configuration. Self-modifying systems with no rollback is a known bad pattern. The factory must version its own tuning, run the new config against a shadow harness before promoting it, and revert automatically when a measurable regression appears.
- A boundary between what the factory is allowed to tune and what remains under human control. Prompts, agent selection, and memory policy on one side of the fence. Credentials, outbound network rules, and kill switches on the other. If the fence is porous, the self-optimization surface becomes an attack surface.

**What it does not unlock.** A Level 6 factory is better at executing Level 5. It is not better at deciding what to execute. The Level 5 ceiling on novel-feature verification from the previous piece still applies, one layer up. If you did not know whether the feature you shipped actually matched the intent behind it at Level 5, a self-optimizing Level 6 harness cannot tell you either. It can only get more efficient at shipping whatever the evaluation harness says is good, and the evaluation harness was still authored by someone with a point of view.

For well-bounded optimizations this is fine. Token cost, latency, retry rate, cache hit rate on context windows, percentage of runs that complete without human intervention, wall-clock from ticket open to PR merged — all of these have honest objective functions that the factory can grade itself against without needing taste. Design Level 6 around that bounded set first. The harder question ("is the code getting better?") stays human for now, because the only tool we have for answering it is the same tool the previous piece said was irreducible: someone judging whether the output matches the intent.

## Level 7 — The autonomous ideation factory

**What it is.** Level 6 pulls harness engineering inside the factory. Level 7 pulls intent generation inside the factory. The factory reads support tickets, customer interview transcripts, product analytics, session replays, churn reasons, competitor launches, and the low-frequency long tail of user feedback that no human has time to triage. It notices patterns. It proposes features. It ranks them against some objective function. It picks winners, writes the specifications itself, feeds those specifications into the Level 5 pipeline, ships the result, measures the outcome, and feeds the outcome back into whatever model it uses for deciding what to build next. The "Intent In" upstream end of the dark factory pipeline, which the previous piece argued was irreducibly human, starts to be served from inside the machine.

**What it unlocks.** If Level 6 relaxes the harness-engineering bottleneck, Level 7 relaxes the bottleneck the previous piece called precise, testable intent. In a Level 5 world, the scarce resource is a senior person who can turn business needs into specifications tight enough for an agent to execute. At Level 7, that role compresses. The factory reads real signals and writes its own specifications. For product categories with high-volume user bases and rich telemetry — consumer apps, growth-loop products, self-serve SaaS — this is a legitimate competitive edge. It is also how the fastest companies in the category will pull away from the rest, because they will be iterating on customer signal at a cadence that unaided humans cannot match.

**What it requires.** An honest Level 7 factory needs, at minimum:

- A ground-truth source of user signal that is not self-generated. The factory has to read real customer conversations, real telemetry, real session data. If it reads its own past outputs and treats them as signal, it becomes a feedback loop grading its own hallucinations, which is the fastest known path from a working product to an optimized wrong one.
- A prioritization function with a meaningful objective. "Ships features faster" is not an objective, it is a treadmill. "Grows engaged retention among the customer cohort the business is trying to serve" is an objective, because it has a subject and a direction. The function has to be written by someone with a point of view about what the company is for.
- A human kill switch on the idea-to-ticket boundary. Not every auto-generated idea should become a ticket. Someone with taste decides which ones become work and which ones go in the bin.

**What it does not unlock.** A Level 7 factory can learn which features engage users. It cannot learn which features are *worth* having. Those are different questions with different answers. Engagement is a measurable signal; worth is a statement about what kind of company you are trying to become, and a statement about the world is not something a factory can derive from its own telemetry. A factory without a taste gate produces a perfectly optimized roadmap for a company you did not choose to build. That is not a bug in the factory. It is a category error about what the factory is for.

This is the honest limit of Level 7, and the honest reason it does not make the human role disappear. It just moves the human job upstream one more time.

## The pattern across Levels 6 and 7

Both new levels pull a previously-human loop inside the factory. Level 6 pulls process improvement. Level 7 pulls intent generation. The direction of travel is clear: the factory absorbs the meta-work, one layer at a time, from the outside in. Code writing was absorbed first, at Levels 2 through 4. Code review was absorbed at Level 5, by the holdout-scenario mechanism and the digital twins. Harness tuning is the third layer. Intent sourcing is the fourth. Whatever comes after that is somewhere past the current horizon, but the shape of the gradient is visible already, and the pattern is consistent.

What does *not* move inside the machine, at any level I can see, is the judgement call about what the company is trying to become. Every level that gets absorbed tightens the loop around what is already chosen. It does not make the choice itself. At Level 5 the human decides what the ticket means. At Level 6 the human still decides that, and also decides which meta-metrics the factory is allowed to optimize for. At Level 7 the human decides which of the factory's auto-generated ideas are allowed to become tickets, and therefore which direction the product is heading. The scarce resource shifts from "precise intent" at Level 5 to **taste** at Level 7 — and below taste, accountability. Someone has to stand behind what the factory decides to build, because when a feature harms a user, you cannot apologize to the user on behalf of the factory.

The trajectory is not one of humans being removed. It is one of humans being concentrated. You need fewer of them, and the ones you keep are doing higher-leverage work: setting the direction the factory is heading, defining the metrics it is allowed to grade itself by, and holding the line on policy and accountability for everything it ships. The previous piece made this argument for Level 5. Levels 6 and 7 extend it, and if anything, sharpen it.

## Where humans still belong

The three-part frame from the previous piece — intent in, policy around the line, review on outcomes — was written for Level 5. Here is what it becomes at Level 7:

**Intent at the company level, not the ticket level.** When the factory is generating its own tickets, the human job is no longer to write tickets. It is to decide what the factory is allowed to *want*. That is a strategy conversation, not an engineering conversation. It belongs to whoever is accountable for what the product is. At Level 5 this was the PM writing specs; at Level 7 it is the founder, the CPO, or whoever holds the statement of what the company is for.

**Policy at the judgement level, not the credential level.** Level 5 policy is about fences: which credentials the factory can touch, which services it can call, which files it can read. That stays. Level 7 adds a second layer of policy: which ideas are allowed to become tickets, which metrics are allowed to be optimization targets, which user cohorts the factory is allowed to prioritize. These are the rules that keep the factory pointed at the right company, and they are rules no factory can write on its own without circularity.

**Review on outcomes that matter, not outcomes that move.** A Level 7 factory will always find something that moves a metric. The human review job is to check that the metric it moved was the one that mattered, and that the move was in the direction that mattered, and that nothing else broke in the process of moving it. This is a product-judgement discipline more than an engineering discipline. It is also the part of the job that is hardest to hire for and hardest to delegate, and it does not get easier as the factory gets more capable. It gets harder, because the factory ships faster and the consequences of getting the direction wrong arrive sooner.

None of these three are engineering problems. They are organizational and judgmental problems, and the factory that absorbs more levels does not make them go away. It makes them the only problems left.

## Where human goes next

The previous piece described `human` as a Level 5 harness: connectors for intent in, a secure devcontainer for policy around the line, lifecycle skills for outcome review. That is the product today. The direction from here is Level 6.

A self-optimizing harness is a natural next step for `human` specifically because of the shape it already has. The skills pipeline — ideate, plan, execute, review — produces structured artifacts at every stage. Those artifacts are measurable end-to-end. A ticket goes in, a PR comes out, a review completes, a deployment happens, an outcome gets measured. Every one of those steps has a signal that could feed back into the harness, and the harness already sees all of them because the lifecycle is integrated. A Level 6 version of `human` starts by turning those already-collected signals into feedback: which intent-writing patterns produce cleaner plans, which plans produce fewer review rejections, which skills configurations close tickets faster without regressing quality, which memory strategies survive long-running work. None of that needs a new data source. It needs the existing data to be read back into the harness and used to tune itself.

The devcontainer matters for Level 6 in a different way. It provides the boundary the previous piece said was required for any self-modifying system: a clean separation between what the factory is allowed to tune (prompts, agent selection, skills configuration) and what stays fenced off (credentials, outbound network, audit trails). The fence `human` already has for security reasons is the same fence a Level 6 harness needs for self-optimization reasons. Reusing one structural choice to serve two problems is the kind of coincidence that suggests the underlying design is right.

Level 7 is further away, and honestly, further from what `human` is for. Intent generation needs customer data, product analytics, retention models, a view into who the users are and how they behave. That is a different kind of product from a harness, and I do not think `human` should become it. `human`'s job at Level 7 is the same job it has always had: keep the human in the loop on intent at the company level, policy at the judgement level, and review on outcomes that matter. The product does not need to become Level 7 to stay relevant in a Level 7 world. It needs to be the thing that sits *next to* a Level 7 factory and holds the line on the three things the factory cannot do for itself. That is what the name has always meant.

If I had to write the vision in one sentence: `human` is evolving toward a harness that tunes itself against the signals it already collects, while staying the part of the stack where the human still decides.

## What to watch for

If Levels 6 and 7 are going to arrive in a useful form and not a broken one, three things will decide how it goes:

- **Whether anyone solves meta-evaluation honestly.** A self-optimizing harness that grades itself against metrics it chose is not self-optimizing, it is self-congratulating. The teams that land Level 6 properly will be the ones who bring the same discipline the holdout-scenario mechanism brought to Level 5, one layer up. External benchmarks, cross-organization comparisons, meta-metrics that the factory cannot see while it is tuning itself. I do not know who will get there first, but I know it is a solvable engineering problem, not a research problem.
- **Whether the ideation layer has a taste gate or not.** The winners at Level 7 will be the teams who treat auto-generated ideas as proposals, not as work. The losers will be the teams who take the factory's engagement-metric optimization at face value and let it drive the roadmap. The difference between those two outcomes is not a model capability gap. It is a product-discipline choice, and it is going to be one of the defining skills of the next generation of product leaders.
- **Whether the role of "person who holds the line" is respected or cut.** At every level so far, the category's marketing has described what the factory removes from the human job. At every level, the reality has been that the human job moved upstream and became more concentrated, and the organizations that hired for that did well, while the organizations that read the marketing and downsized did not. Level 6 and Level 7 will do this again. The human who decides what the factory is allowed to want is the most important person in the building, and the cheapest mistake a company can make right now is to not notice that yet.

## Further reading

- [What is a Dark Software Factory?](/dark-software-factory/) — the first piece in this series. Covers the origin of the term, the five levels, StrongDM as the canonical proof-of-concept, and the "where humans belong" frame that this piece extends.
- [Getting to the Dark Software Factory](/getting-to-the-dark-software-factory/) — how the factory is built in practice: lanes, qualifiers, and the forager.
- [Yes, You Can Run a Dark Factory on Your Codebase](/run-a-dark-factory-on-your-codebase/) — what works today, what arrives next, and how to start this week.
- [The Dark Software Factory](https://www.bcgplatinion.com/insights/the-dark-software-factory) by BCG Platinion, the strategic take on Level 5.
- [Dark software factories and the future of autonomous software delivery](https://www.i-scoop.eu/dark-software-factories-and-the-future-of-autonomous-software-delivery/) by i-SCOOP, the operational take.
- [How StrongDM's AI team build serious software without even looking at the code](https://simonwillison.net/2026/Feb/7/software-factory/) by Simon Willison, the most-cited real-world Level 5 pipeline.
- [Dark Factories: The Five Levels of AI Automation](https://www.cow-shed.com/blog/dark-factories-five-levels-ai-automation-transform-audit-banking-legal) on Cow-Shed, Dan Shapiro's framework this piece extends.

*If this piece was useful, [install human](/docs/getting-started/installation/) or read the [features overview](/features/) to see which parts of the dark factory stack it covers today — and which parts are on the path toward Level 6.*

[^shapiro]: Dan Shapiro's five-level framework for AI autonomy in coding, summarized in [Dark Factories: The Five Levels of AI Automation and How They Will Transform Audit, Banking, and Legal Work](https://www.cow-shed.com/blog/dark-factories-five-levels-ai-automation-transform-audit-banking-legal) on Cow-Shed Startup. Level 5 is the terminal rung of the original framework; Levels 6 and 7 in this piece are a forward extrapolation, not part of Shapiro's original taxonomy.

[^bcg]: [The Dark Software Factory](https://www.bcgplatinion.com/insights/the-dark-software-factory), BCG Platinion. BCG frame the dark factory as the terminal state of their autonomy ladder and do not, at the time of writing, extend the framework beyond Level 5.

[^iscoop]: [Dark software factories and the future of autonomous software delivery](https://www.i-scoop.eu/dark-software-factories-and-the-future-of-autonomous-software-delivery/), i-SCOOP. Like BCG, i-SCOOP treat the dark factory as the endpoint of the category rather than as a stop on a longer trajectory.

[^willison]: [How StrongDM's AI team build serious software without even looking at the code](https://simonwillison.net/2026/Feb/7/software-factory/), Simon Willison, February 2026. StrongDM's pipeline is the closest public example of a Level 5 factory. It is also a good illustration of how much of the appeal of the category comes from integration-code problem domains, where external oracles for verification actually exist.
