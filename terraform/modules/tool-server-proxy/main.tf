# Tool Server Proxy Module
# This is the critical security boundary for agent tool execution.

variable "tool_name" {
  description = "Name of the tool this proxy protects"
  type        = string
}

variable "risk_level" {
  description = "Risk classification (low, medium, high, destructive)"
  type        = string
  validation {
    condition     = contains(["low", "medium", "high", "destructive"], var.risk_level)
    error_message = "risk_level must be low, medium, high, or destructive"
  }
}

variable "requires_human_approval" {
  description = "Whether this tool always requires human approval"
  type        = bool
  default     = true
}

variable "allowed_caller_accounts" {
  description = "List of account IDs allowed to call this tool through the proxy"
  type        = list(string)
}

# Example: API Gateway + Lambda authorizer that talks to the approval system
# This is intentionally simplified — real version would integrate with Step Functions + human workflow

resource "aws_api_gateway_rest_api" "tool_proxy" {
  name        = "tool-proxy-${var.tool_name}"
  description = "Approval-aware proxy for tool: ${var.tool_name}"
}

# In a real implementation you would also have:
# - Lambda authorizer that checks capability + risk level
# - Integration with your human approval system
# - Short-lived credential vending to the actual backend tool
# - Full request/response logging with agent context

output "proxy_api_id" {
  value = aws_api_gateway_rest_api.tool_proxy.id
}

output "requires_human_approval" {
  value = var.requires_human_approval
}
