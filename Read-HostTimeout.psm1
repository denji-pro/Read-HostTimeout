<#
 .Synopsis
  Displays a visual representation of a calendar.

 .Description
  Modification of Read-Host that provides a timeout and default
  value options for user input. Returns default value if no user
  input within timeout period. Esc key returns default value,
  also allows for backspace

 .Parameter Prompt
  Message that requests user input

 .Parameter Default
  Default value to pass if there is no input

 .Parameter Timeout
  The length of the time to wait for user input in seconds

 .Example
   # Ask user 
   Read-HostTimeout -Prompt "Please input number 1 through 10" -Default "8" -Timeout 10
#>

function Read-HostTimeout {

    Param (
        [Parameter(Mandatory = $false)]
        [string]$Prompt = 'Please enter a value',
        [Parameter(Mandatory = $false)]
        [string]$Default,
        [Parameter(Mandatory)]
        [ValidateRange(1, 60)]
        [int]$Timeout = 10
    )

    ## Flush input buffer
    $Host.UI.RawUI.FlushInputBuffer()

    ## Let user know the time they have for input
    ## Write message to screen asking for input
    Write-Host "`nProceeding in ${Timeout}s. Press Enter to continue" -NoNewline -ForegroundColor DarkGreen
    Write-Host "`n${Prompt}: " -NoNewline -ForegroundColor DarkMagenta

    ## Set the timer start time and a buffer to
    ## capture keystrokes
    $startTime = Get-Date
    $buffer = New-Object System.Collections.ArrayList
    
    while ($true) {

        ## When the current time minus start time
        ## is greater than the timeout time return
        ## any keystrokes in the buffer or the 
        ## default value
        if (((Get-Date) - $startTime).TotalSeconds -ge $Timeout) {
            $result = ($buffer.Count -gt 0) ? ($buffer | Join-String) : $Default
            Write-Host "`nTimeout - returning value of $result" -ForegroundColor DarkRed
            return $result
        }

        ## Wait for keystrokes
        if ($Host.UI.RawUI.KeyAvailable) {

            ## Save keystrokes but save output for it's own
            $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyUp')

            ## Use ascii key decimal keycodes
            switch ($key.VirtualKeyCode) {
                13 {
                    ## Enter key
                    ## return anything in the buffer over 0 or the default value
                    $result = ($buffer.Count -gt 0) ? ($buffer | Join-String) : $Default
                    Write-Host "`n"
                    return $result

                }
                8 {
                    ## Backspace key
                    ## Allow for backspace interaction between internal buffer
                    ## and what is seen in console
                    if ($buffer.Count -gt 0) {
                        $buffer.RemoveAt($buffer.Count - 1)
                        Write-Host "`b `b" -NoNewline
                    }
                }
                27 {
                    ## Escape key
                    ## Return the default value if press by user
                    Write-Host "`nInput escaped by user - returning default value of $Default" -ForegroundColor DarkRed
                    return $Default
                }
                default {
                    ## Capture keystrokes and write to internal buffer
                    ## and write to the console on same line as the prompt
                    $buffer.Add($key.Character) | Out-Null
                    Write-Host -NoNewline $key.Character -ForegroundColor White
                }
            }
        }
        ## Avoid overloading the loop
        Start-Sleep -Milliseconds 50
    }
}

Export-ModuleMember -Function Read-HostTimeout