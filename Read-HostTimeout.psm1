<#
 .Synopsis
  Emulate Read-Host with a timeout and default value

 .Description
  This function emulates the Read-Host cmdlet with a timeout and default value.
  The function will display a prompt to the user and wait for input. If no input
  is provided within the specified timeout, the function will return the default
  value. The user can press Enter to submit the input or Escape to return the
  default value.

 .Parameter Prompt
  The prompt to display to the user

 .Parameter Default
  The default value to return if no user input is provided

 .Parameter Timeout
  The number of seconds to wait for user input before returning
  the default value

 .Example
   # Prompt user for input with a timeout of 10 seconds
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

    # Flush input buffer
    $Host.UI.RawUI.FlushInputBuffer()

    # Display prompt and timeout message
    Write-Host "`nProceeding in ${Timeout}s. Press Enter to continue" -NoNewline -ForegroundColor DarkGreen
    Write-Host "`n${Prompt}: " -NoNewline -ForegroundColor DarkMagenta

    $startTime = Get-Date
    $inputBuffer = New-Object System.Collections.ArrayList
    
    while ($true) {
        # Check if timeout has been reached
        if (((Get-Date) - $startTime).TotalSeconds -ge $Timeout) {
            # Return default value or input buffer if timeout is reached
            $result = ($inputBuffer.Count -gt 0) ? ($inputBuffer -join '') : $Default
            Write-Host "`nTimeout - returning value of $result" -ForegroundColor DarkRed
            return $result
        }

        if ($Host.UI.RawUI.KeyAvailable) {
            # Read key from console
            $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyUp')

            switch ($key.VirtualKeyCode) {
                13 {
                    # Enter key
                    # Return the input buffer if Enter key is pressed
                    $result = ($inputBuffer.Count -gt 0) ? ($inputBuffer -join '') : $Default
                    Write-Host "`n"
                    return $result

                }
                8 {
                    # Backspace key
                    # Remove last character from buffer and write backspace to console
                    if ($inputBuffer.Count -gt 0) {
                        $inputBuffer.RemoveAt($inputBuffer.Count - 1)
                        Write-Host "`b `b" -NoNewline
                    }
                }
                27 {
                    # Escape key
                    # Return default value if escape key is pressed
                    Write-Host "`nInput escaped by user - returning default value of $Default" -ForegroundColor DarkRed
                    return $Default
                }
                default {
                    # Add key to buffer and write to console
                    # Ignore non-printable characters
                    $inputBuffer.Add($key.Character) | Out-Null
                    Write-Host -NoNewline $key.Character -ForegroundColor White
                }
            }
        }
        Start-Sleep -Milliseconds 50
    }
}
Export-ModuleMember -Function Read-HostTimeout