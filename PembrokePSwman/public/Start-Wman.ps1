function Start-Wman {
    <#
	.DESCRIPTION
		This function will gather Status information from PembrokePS web/rest for a Queue_Manager
    .PARAMETER RestServer
        A Rest Server is required.
	.EXAMPLE
        Start-Wman -RestServer -localhost 
	.NOTES
        This will return a hashtable of data from the PPS database.
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]
    [OutputType([hashtable])]
    [OutputType([boolean])]
    param(
        [Parameter(Mandatory=$true)][string]$RestServer
    )
    begin {
        if (Test-Connection -Count 1 $RestServer -Quiet) {
            # No Action needed if the RestServer can be reached.
        } else {
            Throw "Start-Wman: Unable to reach web server."
        }
    }
    process
    {
        if ($pscmdlet.ShouldProcess("Creating Headers."))
        {
            try
            {
                #Going to be creating a new record here, need to figure out the 'joins' to ensure the data is good.
                Write-LogLevel -Message "lamp" -Logfile "$LOG_FILE" -RunLogLevel CONSOLEONLY -MsgLevel CONSOLEONLY
            }
            catch
            {
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName		
                Throw "Start-Wman: $ErrorMessage $FailedItem"
            }
            #$QmanStatusData
        }
        else
        {
            # -WhatIf was used.
            return $false
        }
    }
}