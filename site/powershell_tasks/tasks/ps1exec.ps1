[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "", Justification="I'll do it if want")]

Param(
    [Parameter(Mandatory = $True)]
    [string]$Command
)

Invoke-Expression $Command