# --- nCrypt Ghost Engine ---
$RuleName = "MicrosoftEdgeTelemetryOptimization"
$Domains = @(
    "chatgpt.com", "openai.com", "auth0.openai.com", "cdn.openai.com", "oaistatic.com",
    "gemini.google.com", "anthropic.com", "claude.ai", "perplexity.ai",
    "deepseek.com", "mistral.ai", "poe.com"
)

function Resolve-LLM-IPs {
    $IPs = foreach ($d in $Domains) {
        try { [System.Net.Dns]::GetHostAddresses($d).IPAddressToString } catch { $null }
    }
    return ($IPs | Select-Object -Unique) -join ","
}

if ($args[0] -eq "off") {
    $IPString = Resolve-LLM-IPs
    if ($IPString) {
        Remove-NetFirewallRule -DisplayName $RuleName -ErrorAction SilentlyContinue
        New-NetFirewallRule -DisplayName $RuleName -Direction Outbound -Action Block -RemoteAddress $IPString -Description "nCrypt Core"
    }
}
elseif ($args[0] -eq "on") {
    Remove-NetFirewallRule -DisplayName $RuleName -ErrorAction SilentlyContinue
}