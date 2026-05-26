---
title: "Getting to the Dark Software Factory"
subtitle: "Lanes, qualifiers, and what happens to engineering when the cost of shipping collapses toward zero."
description: "How to build a dark software factory in practice — machine-derivable intent, lanes and qualifiers, the forager that cherry-picks work, and why attention becomes engineering's real constraint."
author: "Stephan Schmidt"
date: 2026-05-25
tags: ["dark-factory"]
---

<aside class="tldr">
  <span class="tldr-label">TL;DR</span>
  <p>A dark software factory ships work from intent to production with no developer touching it on the way. Darkness is per-unit — about which stages run unattended, not how much AI you use overall — and it needs three things from the infrastructure, not the agent: machine-derivable intent, machine-observable outcomes, and a machine-bounded blast radius. A qualifier routes each unit into a dark lane or leaves it to humans; lanes are defined by intent source and capability (maintenance, bug autofix, telemetry-driven, transformation, gardening), while concerns like passing tests and stable APIs are the floor every lane must clear. Run continuously, the qualifier becomes a forager that cherry-picks work, and that scoring function — not the agents — is the real product. As shipping costs collapse, the bottleneck moves from what you can build to positioning and attention, so the factory's real value is throughput plus restraint.</p>
</aside>

In manufacturing, a factory is called a dark factory because no one is on the floor. 

The term came up with a Fujitsu factory. FANUC, the Japanese robot maker, has been running 22 plants this way since the early 2000s. Robots making robots and the lights are off, the ventilation is off, sometimes for thirty days without a person setting foot inside the factory. The lights are off because the workers don't need them. Because there aren't any except robots.

Applied to software development, a dark factory is a system that creates software without any humans except on the edges and for maintaining the system. There are no workers except AI agents.

A ticket, a bug, a migration, a feature is implemented by agents without any human. Dark means the work enters the factory as intent and exits as shipped and observed code in production and no developer touched it on its way through the factory. Darkness is about which stages run **unattended** for each unit, not how much AI is used overall. If someone merges the PR, that's not a dark factory, regardless of how much AI you've added to your development process. 

For implementing a dark AI software factory it's not "what AI can we add" but: what's the smallest thing that we can make reliably travel the whole path untouched, and then: how do we widen the scope from what works. For this three things need to be in place:

1. **Intent has to be machine-derivable.** The AI needs a way to find out intent.

2. **Outcome has to be machine-observable.** Production tells the AI whether the change worked. If error rates moved or didn't move or if the Funnel is better or not.

3. **Blast radius has to be machine-bounded.** Canary releases, feature flags, and automated rollback need to be in place. As a last resort the system can undo the change on its own just as it shipped it.

None of these are properties of an AI agent. They're properties of the infrastructure around it. A perfect agent can't run dark on a change whose outcome is unreadable. A mediocre agent can run dark on a change with sharp tests, enough metrics and good rollback. 

**A qualifier decides: can a ticket be built in the dark factory or not?**

The dark factory doesn't replace the existing workflow but runs in parallel to it. The **lit lane** stays the default lane for anything a qualifier decides the factory can't take on. The **dark lane** takes whatever the qualifier accepts as processable. Routing work between humans and the dark factory is the core of the architecture.

You've encountered the "add more AI at each step" vs. "dark factory" structure before in software development: Do developers work on a feature end to end in slices (= lanes) on their own without outside interference or horizontally in layers (= AI in every step). Vertical vs. horizontal feature development - the discussion is not new, and just like developers gravitate towards layering instead of feature slicing, companies tend to add more AI instead of thinking in lanes.

Over time dark lanes will grow and eventually do all work. The lit lane shrinks to things agents can't do. Which is much less than the current human-development surface, and it gets smaller as test infrastructure, observability, and rollout/ rollback plumbing on one hand and AI capabilities on the other hand become better and better.

What defines such a lane?

* **Intent source** - where the unit of work comes from. An automatic scanner agent notices a dependency is out of date. An error lands in Sentry with a known fix template. A funnel metric drops. A ticket arrives in the ticket tracker. A detector spots a compliance gap in your tools (some people already do this MCPing into Vanta).

* **Capability** - what the agent-team/prompts can actually do well in that category right now. Capability moves with models, and tooling. 

Lanes are defined by the combination of these two. Capability moves independently of intent source, so lane boundaries shift over time even when the intent source is fixed. The Sentry-error lane today handles a narrow set of bug classes. The same lane in two years handles more, because capability rose for new classes and the qualifier became confident enough to claim them.

How does a qualifier select a lane? It selects and rejects based on confidence:

* **Confidence** is the qualifier's scored belief that *this specific unit* will ship cleanly given current capability *through that lane*. Confidence is unit-level; capability is category-level

What is possible today?

* **Maintenance**. Intent driven by plain rules. Dependency updates, deprecations, lint, flaky test cleanup. High capability, deterministic verification. Almost nobody runs it dark. Easiest way to start. Think dependabot++

* **Bug autofix**. Error-derived intent. Either from production data (Datadog, Sentry), from customers (Zendesk ticket aggregates) or tickets.

* **Telemetry-driven**. Metric-derived intent. The metric becomes the spec to drive action: Error rates, conversion drops, SEO failures. Verification is experimental: ship variant, measure, keep or roll back. Works for UX micro-improvements, copy, conversion-funnel changes, instrumentation gaps. (What Posthog does today with Code).

* **Transformation**. Structural intent. Framework version A to B, OpenAPI from code, Code from OpenAPI, Terraform from existing resources. A lot of work called "engineering" is actually transformation and translation.

* **Gardening.** Drift based intent. Holes in test coverage, docs getting stale, accessibility findings, security remediation, refactorings, balancing unbalanced architectures, two libs that are used and do the same thing, migrations to a new framework that got stuck half-way through, uneven application of coding best practices and guidelines.

Adoption can follow the path of lowest resistance and rising risks. 

1. Add a bugfix lane, where an agent looks into issue trackers and finds bugs it can fix.
2. Adding a maintenance dark lane is easy, let an agent run across repositories (autonomous like the Netflix chaos monkeys) and create maintenance tickets. 
3. Move up, add a ticket implementer lane for tickets that match the capabilities.
4. Add telemetry, transformation.

CTOs sometimes confuse dark factories lanes with **concerns**. A dark factory lane is a category of work defined by intent source and capability. A **concern** is something every agent team must handle within whatever lane it's running in: all work has to leave the docs consistent, the tests passing and covering the change, the instrumentation working, the code style as is, the public API stable or to spec. Automating those is not a dark factory. They're constraints for AI and developers alike.

Lanes set the ceiling and concerns set the floor. A factory with weak concern enforcement keeps its lanes narrow, because the only way to keep quality up is to restrict what runs through. A factory with strong concern enforcement can widen lanes aggressively. Many teams obsess over the ceiling but ignore the floor.

**The dark factory is continuous. Without humans it can run 24/7.**

When continuously running, the qualifier becomes active and acts as a **forager**. It walks the backlog continuously, scores every ticket, claims the ones the dark factory can work on and leaves the rest to humans. The factory pulls work from the common queue, and the developers get what the factory leaves behind. **This is an inversion of work where the dark factory is cherry picking.**

**With the dark factory development becomes elastic.** 

Like cloud made operations elastic.

We have been living by Goldratt's theory of constraints (ToC) for the last decades: find the bottleneck, subordinate everything to it, elevate it, find the next bottleneck. When development becomes elastic it stops being scarce and the bottleneck moves.

The result can already be seen. Low development costs - zero? - lead to a feature-explosion. Cloudflare expands aggressively its product portfolio as building costs approach zero. **For some weeks Cloudflare shipped a new product, not feature, every week.** Companies expand into everything adjacent because the marginal cost has collapsed. Everyone expands and products and companies will massively overlap. The overlap gets big enough that the feature list stops being a meaningful comparison. You can't pick a tool because it has feature X because everything has X.

So the bottleneck moves another level. From "what can we build" to "what should we be." Positioning becomes the actual constraint because it's the only thing that doesn't get cheaper as shipping does. You can't generate positioning from production data.

Closely tied to positioning is attention. In a world where everything has every feature, the question isn't "why us over them". The question one level up is "why look at all." Supply of new features approaches infinity while attention is biologically (you!) capped. So the price of attention rises indefinitely.

**The Goldratt move on the whole industry is to subordinate every other resource to attention.**

Which brings me back to the factory: What is the factory for? 

With unlimited power at your fingertips how are you going to use it?

The pitch for a dark-factory product isn't "ship faster" but "ship the right things with discipline." The qualifier needs to gate for **coherence with the product's attention strategy**. Off-strategy tickets need to get rejected before they enter the lane, even if they're possible to implement. Features that would spend attention without earning it back get flagged. The factory's value is the combination of throughput and restraint. Restraint doesn't demo well, which is why nobody is building this layer right now. It's also why teams that do build it will be the only ones with intelligible products in five years - products that pierce through the attention bubble.

In 1980 IBM built a lights-out keyboard plant in Texas. It failed and got shut down. The reason: the line couldn't adapt to product variations. Once they wanted to make a different keyboard, the system broke. The automation was real but the architecture was too rigid. Most "AI dev tools" being marketed right now don't have any of this. They're optimizing for one workflow shape. IBM made the same bet and got shut down. The companies that build the lane architecture, the qualifier infrastructure, the taste loops, the coherence layer — those are the FANUC analogue. The ones that bet on a single workflow are the IBM analogue.

## Further reading

* [What is a Dark Software Factory?](/dark-software-factory/) — the first piece in this series, with the origin of the term, the five levels framework, and where humans belong.
* [Beyond the Dark Factory](/beyond-dark-factory/) — Level 6 self-optimisation and Level 7 autonomous ideation, the two levels past the dark factory.
* [Yes, You Can Run a Dark Factory on Your Codebase](/run-a-dark-factory-on-your-codebase/) — what works today, what arrives next, and how to start this week.

*If this piece was useful, [install human](/docs/getting-started/installation/) or read the [features overview](/features/) to see which parts of the dark factory stack it covers today.*
