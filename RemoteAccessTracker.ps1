# Define the filter for event log retrieval
$eventFilter = @{
    LogName   = 'Security'
    ID        = 4624
    StartTime = (Get-Date).AddDays(-1)  # Get events from the last 24 hours
}

# Get only the filtered RDP logon events
$rdpLogons = Get-WinEvent -FilterHashtable $eventFilter -ErrorAction SilentlyContinue

# Process and extract user/IP details
$rdpSessions = $rdpLogons | ForEach-Object {
    $eventData = $_.Properties
    if ($eventData.Count -gt 18) {  # Ensure properties exist
        [PSCustomObject]@{
            TimeStamp = $_.TimeCreated
            User      = $eventData[5].Value
            IP        = $eventData[18].Value
        }
    }
}

# Remove duplicate entries and format output
$rdpSessions | Sort-Object IP, User -Unique | Format-Table -AutoSize
