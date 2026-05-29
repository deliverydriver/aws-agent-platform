# AWS Production Platform for Voice-Controlled & Autonomous AI Agents

**A secure, observable, cost-aware, human-in-the-loop platform for running real AI agents (including voice agents with phone numbers) in production on AWS.**

This is the cloud-native, production-grade evolution of local agentic systems (such as the Grok Build environment + voice control work). It is designed to be a **living, continuously improved project** while studying for the AWS Solutions Architect Professional exam.

## Why This Is Extremely Powerful for Applications

Most candidates can draw boxes for "Lambda + API Gateway + DynamoDB".

Very few can credibly talk about:

- Running **long-lived autonomous agents** with tool use, memory, and human oversight at scale
- Securely giving AI agents the ability to act (while keeping a human in the loop for dangerous operations)
- Cost management for unpredictable LLM spend
- Observability for non-deterministic agent behavior
- Voice + telephony integration at production quality (LiveKit + SIP)

This project gives you concrete stories in all of those areas.

### Exam Alignment (Solutions Architect – Professional)

| Domain                              | Strength Demonstrated |
|-------------------------------------|-----------------------|
| Design for new solutions            | Building a new class of workload (agentic systems) on AWS |
| Design for security                 | Secure tool calling, least-privilege for agents, human approval gates, PrivateLink for AI services |
| Design for reliability              | Handling long-running stateful agents, failure modes of non-deterministic systems, DR for agent memory |
| Design for performance & scalability| Handling bursty voice traffic + background agent work |
| Design for cost optimization        | Real strategies for controlling LLM spend at scale |
| Design for operational excellence   | Observability of agent runs, debugging non-deterministic systems, deployment patterns for agents |

## Core Capabilities (Roadmap)

### Phase 1 – Foundation (Current Focus)
- Secure "agent runtime" accounts isolated from the landing zone
- Event-driven orchestration backbone (EventBridge + Step Functions + SQS)
- Human-in-the-loop approval system (ties into voice control work)
- Secure outbound tool execution (the agent can call tools, but dangerous actions require approval)
- Basic cost allocation and budgets per agent / per customer

### Phase 2 – Voice & Telephony
- Production hosting patterns for LiveKit + xAI Grok Voice agents with phone numbers
- Private connectivity where possible
- Real-time observability of voice sessions
- Failover and scaling strategies for voice workloads

### Phase 3 – Advanced Agent Patterns
- Long-running agent state management (DynamoDB + S3 + possibly EFS or custom)
- Multi-agent orchestration and delegation
- Integration with Amazon Bedrock Agents + custom tool servers
- Evaluation harnesses and regression testing for agent behavior

### Phase 4 – Production Hardening
- Full CI/CD for agent code + infrastructure
- Advanced security (VPC Lattice, Verified Access, fine-grained tool permissions)
- Sophisticated cost controls and anomaly detection on LLM usage
- Multi-region and DR strategies for stateful agents

## Architecture Principles

1. **Agents are untrusted workloads** — even more than typical serverless functions. They get narrow, auditable tool access.
2. **Human oversight is a first-class architectural component** for anything with side effects.
3. **Observability must handle non-determinism** (you can't just look at logs the same way).
4. **Cost is a reliability and security concern** when dealing with LLMs.
5. **The platform should make the right thing the easy thing** for both AI engineers and platform teams.

## Relationship to Other Projects

- Built on top of [aws-landing-zone-for-ai](../aws-landing-zone-for-ai)
- Will be one of the primary workloads reviewed in [aws-well-architected-ai](../aws-well-architected-ai)
- Can incorporate sovereign / highly restricted patterns from the fourth project when needed for clients

## Current Status

This repo is in early scaffold phase. The local version of parts of this system (the voice-to-grok-build bridge) is being built in a companion project. This AWS version is the production target.

## Technology Direction (Subject to Change)

- **Orchestration**: Step Functions (Express + Standard), EventBridge, SQS, SNS
- **Compute for Agents**: ECS Fargate (primary), EKS where needed, Lambda for short tasks
- **Voice / Realtime**: LiveKit (self-hosted or Cloud) + AWS services for signaling/media where it makes sense
- **AI Services**: Heavy use of Amazon Bedrock (Agents, Knowledge Bases, Guardrails) + custom tool servers
- **State & Memory**: DynamoDB, S3, possibly Aurora or custom vector stores
- **Human-in-the-Loop**: API Gateway / AppSync + the web control plane (evolved from local voice control work)
- **Observability**: X-Ray + CloudWatch + custom agent run tracing
- **IaC**: Terraform (primary) with possible CDK for complex AI constructs

## Getting Involved / Following Along

This is a public living project. As I study and build real systems, this repository will be updated with:
- Architecture Decision Records
- Cost models and real spend data (anonymized)
- Security reviews
- Production incident learnings (when they happen)
- Well-Architected reviews

---

**Objective**: When I walk into an interview or client conversation and they ask about running AI agents in production on AWS, I can point to this repo and say "Here's the actual platform I'm building and operating."

Built while preparing for the AWS Certified Solutions Architect – Professional exam.
