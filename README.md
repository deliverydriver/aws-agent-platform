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