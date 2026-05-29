# ADR 0001: Secure Tool Execution Boundaries for Production Agents

**Status**: Proposed

**Date**: 2026-05-29

## Context

Production agents in this platform need to call real tools that have side effects (code execution, API calls to internal systems, data access, external services, etc.).

At the same time, we must prevent:
- Runaway or malicious tool use from causing large blast radius (data exfiltration, resource destruction, massive spend).
- Compromised or confused agents from abusing broad credentials.
- Accidental or experimental tool behavior from affecting production systems or customers.

Standard IAM roles for the agent execution environment are necessary but not sufficient. We need multiple layers of control that survive a compromised agent or a confused deputy situation.

## Decision

We will implement **defense-in-depth tool execution boundaries** with the following layers:

1. **Capability Classification**
   - Every tool is classified by risk (Read-only, Mutating, Destructive, High-Cost, External, etc.).
   - Classification is enforced in code and in the approval system.

2. **Execution Environment Isolation**
   - Different privilege tiers of agents run in separate execution environments (different IAM roles, different VPCs or security groups, different tool server accounts where possible).
   - High-risk tools are only callable from higher-trust (and more heavily monitored) environments.

3. **Approval Proxy Layer (Mandatory for Mutating/High-Risk Tools)**
   - Tool calls from agents go through an approval proxy (running in a separate, higher-trust account).
   - The proxy performs:
     - Capability check against the agent's allowed set.
     - Risk-based routing to human approval (or automated policy for low-risk cases).
     - Request sanitization and logging.
     - Short-lived, narrowly scoped credentials for the actual tool call (when possible).
   - The actual tool server never sees the agent's direct identity or broad credentials.

4. **Network Controls**
   - All tool calls from agent environments to tool servers happen over PrivateLink / VPC Lattice where feasible.
   - Tool servers have strict inbound security group / VPC Lattice auth policies.
   - No direct internet access from most agent execution environments.

5. **Observability & Audit**
   - Every tool call (approved or denied) is logged with full context (agent identity, session, trajectory, parameters, outcome).
   - High-risk tool usage triggers additional alerting and review.

## Consequences

**Positive**
- Dramatically reduced blast radius even if an agent (or its model) behaves unexpectedly or is compromised.
- Clear separation between "what the agent is allowed to intend" and "what is actually executed".
- Excellent audit trail for compliance and post-incident analysis.
- Supports the human-in-the-loop requirements without making every single action painfully slow.

**Negative / Trade-offs**
- Added latency for approved tool calls (acceptable for most production use cases; we can optimize hot paths later).
- More complex architecture (proxy, multiple accounts, PrivateLink).
- Some tools will require custom adapters to work through the proxy.

**Alternatives Considered**
- Pure IAM + SCPs: Rejected. Too coarse-grained for the dynamic, multi-turn nature of agent tool use. An agent that has permission to call a tool can call it in dangerous ways.
- Client-side sandboxing only (e.g., inside the agent process): Rejected. Insufficient when the tool itself has broad permissions.
- Full manual approval for everything: Rejected. Destroys the value of autonomous agents.

## Implementation Notes

- The approval proxy will be a first-class component in this repository (initially as a reusable module).
- Tool capability definitions will live alongside the tools themselves.
- We will start with a relatively strict default (most mutating tools require human approval) and relax only with data.

## Related Decisions

- Landing zone SCP strategy for cross-account tool calling (see aws-landing-zone-for-ai ADR 0001)
- Workload identity model for agents
- Human oversight workflow patterns

---

This will be revisited after we have operational data on approval latency impact and actual tool usage patterns from production agents.