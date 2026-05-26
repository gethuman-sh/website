---
title: "Yes, You Can Run a Dark Factory on Your Codebase"
subtitle: "What works today, what arrives next, and how to start this week."
description: "You can run a dark software factory on your codebase today. Six categories of work already ship autonomously — what works now, what's next, and how to start this week."
author: "Stephan Schmidt"
date: 2026-05-23
tags: ["dark-factory"]
---

<aside class="tldr">
  <span class="tldr-label">TL;DR</span>
  <p>Yes, you can run a dark software factory on your own codebase today, and the recipe is lighter than the writeups make it look. Six categories already ship good results against the test infrastructure most teams already have — integrations and SDKs, migrations and refactors, CRUD on well-typed schemas, codegen from formal specs, infrastructure-as-code, and bug fixes with a reproducing test — together roughly 40–60% of what a typical SaaS team ships. The near edge (feature-flagged work, benchmark-driven performance) arrives within a year; the rings beyond it need Level 6 self-optimisation and more mature telemetry. Start by running one ticket end to end and shipping it, because the harness tuning and intent-writing compound with every ticket. human is the harness for that today-list.</p>
</aside>

I keep meeting CTOs and engineering leads who have read about the dark software factory, and who have looked at one or two writeups, and who have come away with the impression that this is something other companies do. Not their company, and not their codebase and not their team - it is impossible. I think they are wrong, and the reason I am writing this so I can point at it.

The short version: you can run dark factories on your codebase. The implementation is simpler than the existing writeups make it look, and the categories of work where it already produces good results cover something I estimate to be half of what most engineering teams develop. The way forward across the next five years extends the possibilities every year, **and the teams that start now compound on it.**

I should also say upfront that we build a dark-factory harness for a living, which means I have a commercial interest in you adopting the pattern. I am still going to tell you when it does not work :-) (yet)

A dark software factory is a setup where AI agents read intent (e.g. a ticket), write the code and run the tests, and push to production and where humans do not review the code line by line. The name borrows from lights-out manufacturing, where robots run the production floor and the lights can stay off because nobody is on it. In the software version the humans move to the beginning and end of the pipeline. *They decide what to build, they set the policy the factory has to obey, and they look at the outcomes and decide whether what shipped is good enough.* The writing of the code is the machine's job. I have written some longer pieces on dark factories, and they are linked at the bottom of this one if you want the background.

Let's spend some time on what works today. I think this is where CTOs underestimate their environment. Dark factories can produce working results for the following kinds of work, against the harness infrastructure most teams already have. These are bread and butter (often inward looking) of engineering work.

1. **Integrations, API clients, and SDKs.** The spec is the upstream, the API documentation is the contract, and your existing integration tests against that service are the grader. Most teams already have these tests, and you have most of the parts already.
2. **Migrations and refactorings.** A migration is a particularly clean case because the old behaviour is the specification for the new behaviour, and the outputs of the previous system decide whether the new system is doing the right thing. Database migrations, framework upgrades, language version bumps, and the long backlog of "rewrite this in the new style" tickets all live here. Migrations are often boring, often urgent, and often the place where senior engineers spend time they should be spending time on something else.
3. **Internal APIs and CRUD on well-typed schemas.** When you have a schema, the schema is the contract and the contract is the grader.
4. **Codegen from formal specifications.** OpenAPI, GraphQL, protobuf, JSON Schema. The specification is machine-readable, and the gap between specification and implementation is exactly the gap the factory was built to close. If you are already using these formats, you are most of the way there. 
5. **Infrastructure as code and policy.** Cloud APIs are well-documented, and your security policy is itself a kind of specification. Terraform/OpenTofu, Pulumi, Kubernetes manifests, Ansible, IAM policy, and the operational glue around them all work well, and the audit trail the factory leaves (e.g. as tickets) is often cleaner than what humans produce under deadline pressure.
6. **Bug fixes with a reproducing test.** When you have a failing test that reproduces a bug, the test determines success by definition, and the factory's job is to make it pass without breaking the rest of the suite. The backlog of bugs-with-reproductions is long in almost every codebase I have seen, from QA or customer support, and the factory can chew through it in the background while the humans work on harder things.

The dark factory pattern is not aiming at a narrow industry niche *first*. It is aiming at the unglamorous middle of the codebase where most of the work actually lives, and that middle is where it works today.

Beyond the today-list is a near edge of work that sits right at the threshold of being dark-factory-ready, and where the harness tooling has grown enough in the last six months that I expect adoption within the next year:

1. Deep feature work behind feature flags becomes feasible because the flag collapses the cost of shipping the wrong thing, and the verification calculus changes once the rollback is one click. 
2. Performance work against benchmarks becomes doable because the benchmark is the spec, and the practice that has worked in compiler engineering for a long time is moving into application code as your harnesses get better at running benchmarks without flakiness. 

And then? **What's next?** We will see the next ladder of the dark factory. The next ring includes the kinds of work where Level 6 self-optimisation in the harness starts to matter, and where the surrounding telemetry needs to be *more mature than most teams have today*.

New product features with strong telemetry, where the A/B test in production decides if a feature works or not. Consumer apps get this first because their telemetry is shaped for it, and B2B SaaS follows shortly after. Self-serve onboarding flows, dynamic onboarding flows and growth surfaces, where engagement and conversion are measurable and **the factory iterates against them.**

I am less confident about specifics further out, but the direction is clear. Whole systems specified end to end and shipped autonomously, **with the factory making architectural choices** inside a policy system set by humans. Level 7 ideation is when the factory reads customer signals and proposes its own work - and what not to do!

Cross-company harness learning, where the patterns that work in one factory propagate to others without revealing private code. Continuous architectural evolution, where the shape of the codebase is itself something the factory tunes against measured outcomes rather than something a senior engineer redraws every two years.

Now to you: The fastest way to find out whether the pattern works for you is to try it out.

Run one ticket end to end without human interaction and ship the result (with what ever prompt framework you want stitched together with a meta-skill if needed). Note what worked and what did not, and then pick the next ticket. The sum of your learnings grows quickly because the harness tuning you do for the first tickets makes the next cheaper, **and the team's intent-writing skill sharpens with every ticket that ships.**

Then level up the harness. You need a fenced environment so the agent runs in a devcontainer it cannot escape, you need the agent to see your tickets and your documentation and your design notes, you need a policy layer that controls credentials and outbound network calls, and you need a workflow for outcome review by humans. 

Some of your competitors are doing this already. The gap they open while you doubt, discuss and postpone decisions is a gap **you will need to close with bigger effort later.** The advantage of dark factories is not the model, and it is not the harness, and it is not even the pattern taken alone. It is having been doing all of it for long enough that the institutional knowledge is sharp, and that knowledge and practice cannot be bought.

We create `human`, a dark factory and enterprise AI solution. `human` is the harness for the today-list. The devcontainer, the context pipes, the policy layer, and the lifecycle skills are all in place, and you can point it at one subsystem this week. It is the tool I wished I had as a fractional CTO when I started running Claude Code against real codebases, and it is the tool I would pick today if I were starting fresh on the six categories above.

The architecture is also pointed at Level 6 of dark factories, because the lifecycle is integrated end to end and the signals that a self-optimising harness needs are already being collected at every stage. The today-list gets you shipping, and the path from there to the next ring and the ring after that is what the product is being built for.

*If you have read the writeups about dark factories and concluded that this is for other companies, I think you are wrong. Getting started is easier than you think. The test infrastructure you already have is most of what you need. The harness around it is a known form and other people have already built it. Install `human`, point it at a ticket you picked, and ship the first ticket. The rest follows from there.*

## Further reading

* [What is a Dark Software Factory?](/dark-software-factory/) — the first piece in this series, with the origin of the term, the five levels framework, and the verification ceiling argument.
* [Beyond the Dark Factory](/beyond-dark-factory/) — the second piece, on Level 6 self-optimisation and Level 7 autonomous ideation.
* [Getting to the Dark Software Factory](/getting-to-the-dark-software-factory/) — how the factory gets built in practice: lanes, qualifiers, the forager, and why attention becomes the constraint.
