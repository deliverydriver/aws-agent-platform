# Agent Platform — Core Architecture

## High-Level Components

```mermaid
graph TB
    subgraph AgentEnv["Agent Execution Environment (ECS/EKS)"]
        Agent[Long-running Agent Process]
    end

    subgraph Orchestration["Orchestration Layer"]
        EB[EventBridge]
        SFN[Step Functions]
    end

    subgraph Proxy["Tool Execution Proxy (Critical Security Boundary)"]
        Authz[Capability + Risk Check]
        Approval[Human Approval Workflow]
        CredVending[Short-lived Credential Vending]
    end

    subgraph ToolServers["Tool Servers (Various Accounts)"]
        Internal[Internal APIs]
        External[Audited External Tools]
    end

    subgraph AI["AI Services"]
        Bedrock[Amazon Bedrock]
        SageMaker[SageMaker Endpoints]
    end

    Agent --> EB
    EB --> SFN
    Agent -->|Tool Call| Proxy
    Proxy --> Authz
    Authz -->|High Risk| Approval
    Approval -->|Approved| CredVending
    CredVending --> ToolServers

    Agent --> Bedrock
    Agent --> SageMaker
```

## Key Design Points

- **Tool calls never go direct** from the agent runtime to the actual tool backend for anything above "low" risk.
- The **Tool Execution Proxy** is the single most important security component.
- Long-running state and human approval workflows are modeled in Step Functions.
- All AI model calls are routed through PrivateLink where possible.

## Observability

Every agent turn should produce:
- Full X-Ray trace (including model and tool subsegments)
- Structured logs with session ID, agent ID, and cost metadata
- Trajectory events published to EventBridge for evaluation pipelines

This architecture is intentionally more complex than "just call Bedrock from Lambda" because the requirements around security, audit, cost control, and human oversight are significantly higher.
