# Get all RDP logon events from the Security Event Log
$rdpLogons = Get-WinEvent -LogName Security | Where-Object {
    $_.Id -eq 4624 -and $_.Properties[8].Value -eq 10
}

# Extract user and IP information
$rdpSessions = $rdpLogons | ForEach-Object {
    [PSCustomObject]@{
        TimeStamp = $_.TimeCreated
        User      = $_.Properties[5].Value
        IP        = $_.Properties[18].Value
    }
}

# Display unique connections
$rdpSessions | Sort-Object IP, User -Unique | Format-Table -AutoSize
