function Invoke-WmanShutdownTaskSet {
    <#
	.DESCRIPTION
		This function will perform shutdown tasks for a Workflow_Manager
    .PARAMETER RestServer
        A RestServer is Required.
    .PARAMETER TableName
        A properties path is Required.
    .PARAMETER ID
        An ID is Required.
	.EXAMPLE
        Invoke-WmanShutdownTaskSet -RestServer localhost -TableName tasks -ID 1
	.NOTES
        This will return a hashtable of data from the PPS database.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    [OutputType([Boolean])]
    param(
        [Parameter(Mandatory=$true)][string]$RestServer,
        [Parameter(Mandatory=$true)][string]$TableName,
        [Parameter(Mandatory=$true)][int]$ID
    )
    if (Test-Connection -Count 1 $RestServer -Quiet) {
        try
        {
            $TableName = $TableName.ToLower()
            Write-LogLevel -Message "Performing Shutdown Tasks for Wman: $ID Table: $TableName" -Logfile "$LOG_FILE" -RunLogLevel $RunLogLevel -MsgLevel DEBUG
            Invoke-CancelRunningTaskSet -RestServer $RestServer -TableName $TableName -ID $ID
            Invoke-Wait -Seconds 5
            Invoke-QueueAssignedTaskSet -RestServer $RestServer -TableName $TableName -ID $ID
            Invoke-Wait -Seconds 5
            Invoke-CancelStagedTaskSet -RestServer $RestServer -TableName $TableName -ID $ID
            Invoke-Wait -Seconds 5
            Invoke-UpdateWmanData -ComponentId $ID -RestServer $RestServer -Column STATUS_ID -Value 1
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName		
            Throw "Invoke-WmanShutdownTaskSet: $ErrorMessage $FailedItem"
        }
        $ReturnMessage
    } else {
        Throw "Invoke-WmanShutdownTaskSet: Unable to reach Rest server: $RestServer."
    }

}
    