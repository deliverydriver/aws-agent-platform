# Production Platform for Voice-Controlled and Autonomous Agents

A runtime environment for running stateful, tool-using AI agents at production scale on AWS, with particular attention to voice interfaces, human oversight boundaries, and the operational realities of non-deterministic workloads.

## Scope

This is not another "build an agent with Bedrock" template. The focus is the surrounding platform required once you have agents that need to:

- Maintain long-running state and memory across sessions and failures
- Execute tools with real side effects while remaining within acceptable risk boundaries
- Handle voice and telephony workloads with the latency and reliability expectations of production voice systems
- Be observable when their behavior is inherently non-deterministic
- Have their inference and tool costs attributed and controlled

The platform provides orchestration, secure execution environments, approval gates, state management, observability, and cost controls shaped by those requirements.

## Core Concerns

**Secure tool use at scale**  
Agents that can call real tools (code execution, API calls, file operations, external services) require different boundaries than typical application service accounts. The design treats dangerous capabilities as privileged operations that can be gated, audited, and in many cases routed through human approval workflows.

**Human-in-the-loop as architecture**  
For any capability with material side effects, the system is designed so that human approval is a first-class, low-latency part of the execution path rather than an after-the-fact review.

**Cost and capacity for non-deterministic workloads**  
Inference spend is volatile. Agent loops can generate large numbers of tool calls and model invocations. The platform includes attribution, budgeting, and throttling mechanisms that operate at the level of individual agents or customers rather than just accounts.

**Observability for agent behavior**  
Traditional request/response tracing is insufficient. The system captures agent trajectories, decision points, tool invocations, and state transitions in a way that supports debugging, evaluation, and audit.

**Voice and real-time interfaces**  
Support for low-latency voice agents (including telephony) introduces additional constraints around session management, media handling, and graceful degradation.

## Current Direction

The repository captures the evolving architecture for the runtime. Early emphasis is on:

- Orchestration backbone (EventBridge, Step Functions, SQS) suitable for long-running agent sessions
- Execution environments for agents with different privilege levels
- Integration patterns with the landing zone for cross-account tool execution
- Initial cost attribution and guardrail mechanisms

Later work will address production voice integration, advanced state and memory stores, evaluation harnesses, and tighter coupling with Bedrock Agents and custom tool servers.

## Relationship to Other Work

This platform is intended to run inside the governance boundaries defined in aws-landing-zone-for-ai and incorporates patterns from aws-sovereign-infrastructure when higher restrictions are required. Detailed reviews of specific architectural slices live in aws-well-architected-ai.

## Context

I already operate sophisticated local agentic systems with persistent identity, memory, and voice interfaces. This repository documents the production AWS realization of those systems — the runtime, security model, and operational practices required to run them reliably for real workloads.

---

The designs are driven by actual usage rather than exam scenarios or generic best practices. Specifics around tool boundaries, approval latency, cost attribution, and failure modes for long-running agents are the interesting parts.

## Services and Patterns for Demonstrating Depth

To show extensive, real-world experience with complex modern workloads, this project will incorporate sophisticated usage of the following AWS capabilities, integrated around the specific challenges of stateful agents, voice, secure tool use, and cost volatility:

**Orchestration & Compute (Advanced)**
- AWS Step Functions (both Standard for long-running sessions with human approval via Task Tokens, and Express for high-throughput short tasks).
- Amazon EventBridge (custom buses, rules, pipes, and schema registry) as the core event fabric for agent lifecycle, tool results, and human decisions.
- ECS Fargate and/or EKS with advanced service connectivity (VPC Lattice or App Mesh), task IAM roles, and secrets integration.
- Lambda with Powertools for TypeScript/Python, Destinations, and SnapStart where it improves agent tool handler performance.
- AWS Batch for heavy background agent computation when needed.

**AI Services at Production Depth**
- Amazon Bedrock: Agents, Knowledge Bases, Guardrails (with custom policies), provisioned throughput, model invocation logging, and custom model import patterns.
- SageMaker: Real-time and Serverless endpoints, Inference Recommender, Model Monitor, Clarify for agent decision explainability, and fine-grained IAM for model access.
- Secure, auditable tool server architectures using API Gateway + Lambda/ECS fronted by approval proxies, exposed via PrivateLink, with request validation and capability-based authorization.

**Voice, Telephony & Real-Time**
- Deep integration patterns with LiveKit (self-hosted on ECS/EKS) including signaling, media handling, and session lifecycle tied to agent state.
- Use of Amazon Transcribe, Polly, and Chime SDK components where they add value alongside or instead of external voice infrastructure.
- WebSocket and real-time patterns (API Gateway WebSocket, AppSync, or direct with ALB) for low-latency agent interaction.

**Human Oversight & Workflow**
- Step Functions + SNS/SQS + API Gateway/AppSync approval workflows that are first-class in the architecture.
- Audit trails of approval decisions linked to agent sessions and tool invocations.
- Risk-based routing of tool capabilities to different approval paths or automated policies.

**Cost Management & FinOps (Agent Reality)**
- Fine-grained spend attribution using CUR + custom attribution logic down to agent sessions or customers.
- Budgets + Cost Anomaly Detection with automated responses (throttling, alerts, or session termination) tuned for LLM spend.
- Strategic use of provisioned capacity (Bedrock provisioned throughput, SageMaker provisioned concurrency) vs on-demand, plus Graviton and Spot strategies for execution environments.

**Observability & Evaluation**
- Advanced distributed tracing with X-Ray (custom subsegments for model calls and tool executions) combined with OpenTelemetry.
- Custom CloudWatch metrics, logs, and Evidently-style evaluation for agent trajectories, success rates, and cost-per-outcome.
- Integration with Bedrock evaluation capabilities and custom harnesses for regression testing agent behavior.

**Security & Identity**
- Workload identity patterns (IAM Roles Anywhere, OIDC federation, or custom short-lived credential vending for agents).
- Secrets management with rotation for tool credentials.
- Defense-in-depth network controls (all model and tool traffic over PrivateLink where feasible).
- Data protection using KMS envelope encryption for agent memory combined with Macie scanning of outputs.

**IaC & Platform Engineering**
- Reusable, well-tested Terraform modules or CDK constructs for "agent runtime environment", "approved tool server", "voice session handler", etc.
- Strong CI/CD with policy-as-code, security scanning, and safe deployment practices for agent and platform updates.
- Cross-account execution patterns that keep the blast radius of agent actions tightly controlled.

These will be backed by detailed ADRs, architecture diagrams showing data flows and trust boundaries, cost models with real (anonymized) data, operational runbooks, and security baselines — the kind of artifacts that only come from building and running these systems.

Further reading in the sibling repositories covers the landing zone governance, reference architectures under review, and patterns for more restricted environments.