function Add-JiraIssueWorklog
{
    [CmdletBinding()]
    param(
        # Comment
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [String] $Comment,
        
        # Spent time
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [String] $SpentTime,

        # Issue
        [Parameter(Mandatory = $true,
                   Position = 1,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [Alias('Key')]
        [Object] $Issue,

        # Visibility of the work log - should it be publicly visible, viewable to only developers, or only administrators?
        [ValidateSet('All Users','Developers','Administrators')]
        [String] $VisibleRole = 'Developers',

        # Credentials to use to connect to Jira. If not specified, this function will use
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential] $Credential  
    )

    begin
    {
        Write-Debug "[Add-JiraIssueWorklog] Begin"
        # We can't validate pipeline input here, since pipeline input doesn't exist in the Begin block.
    }

    process
    {
        Write-Debug "[Add-JiraIssueWorklog] Obtaining a reference to Jira issue [$Issue]"
        $issueObj = Get-JiraIssue -InputObject $Issue -Credential $Credential

        $url = "$($issueObj.RestURL)/worklog"

        Write-Debug "[Add-JiraIssueWorklog] Creating request body from comment"
        $props = @{
            'comment' = $Comment;
            'timeSpent' = $SpentTime
        }

        # If the visible role should be all users, the visibility block shouldn't be passed at
        # all. JIRA returns a 500 Internal Server Error if you try to pass this block with a
        # value of "All Users".
        if ($VisibleRole -ne 'All Users')
        {
            $props.visibility = @{
                'type' = 'role';
                'value' = $VisibleRole;
            }
        }

        Write-Debug "[Add-JiraIssueWorklog] Converting to JSON"
        $json = ConvertTo-Json -InputObject $props

        Write-Debug "[Add-JiraIssueWorklog] Preparing for blastoff!"
        $rawResult = Invoke-JiraMethod -Method Post -URI $url -Body $json -Credential $Credential

        Write-Debug "[Add-JiraIssueWorklog] Converting to custom object"
        $result = ConvertTo-JiraComment -InputObject $rawResult

        Write-Debug "[Add-JiraIssueWorklog] Outputting result"
        Write-Output $result
    }

    end
    {
        Write-Debug "[Add-JiraIssueWorklog] Complete"
    }
}


