# ADR 0002: Workload Identity Model for Production Agents

**Status**: Proposed

## Context

Agents need to authenticate to tools, internal APIs, and sometimes other AWS accounts. Giving them long-lived IAM credentials (or even broad IAM roles) is unacceptable from a security perspective.

We need a robust workload identity story that works for both short-lived tool calls and longer-running agent sessions.

## Decision

We will use a **federated workload identity** model with the following characteristics:

- Primary mechanism: **IAM Roles Anywhere** (for agents running on ECS/EKS/Outposts) or OIDC federation (for agents running in environments that support it).
- Agents receive short-lived credentials (15-60 minutes) via the Tool Execution Proxy after approval.
- The proxy acts as the Policy Decision Point and also handles credential vending.
- For very long-running agents, we use a refresh mechanism coordinated with Step Functions so credentials are rotated without the agent process needing broad `sts:AssumeRole` permissions.

## Key Benefits
- No static credentials in agent environments.
- Fine-grained, just-in-time access tied to approved tool calls.
- Excellent audit trail (every credential issuance is linked to a specific approved action).

## Open Questions
- Performance impact of frequent credential vending for high-throughput agents.
- Fallback strategy when Roles Anywhere is not available (e.g., on certain Outposts configurations).

This model is tightly coupled with the approval proxy architecture described in ADR 0001.
