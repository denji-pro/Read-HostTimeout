function Read-HostTimeout {

    Param (
        [Parameter(Mandatory = $false)]
        [string]$Prompt = 'Please enter a value',
        [Parameter(Mandatory)]
        [string]$Default,
        [Parameter(Mandatory)]
        [ValidateRange(1, 60)]
        [int]$Timeout = 10
    )

    $Host.UI.RawUI.FlushInputBuffer()

    Write-Host "`nProceeding in ${Timeout}s. Press Enter to continue" -NoNewline -ForegroundColor DarkGreen
    Write-Host "`n${Prompt}: " -NoNewline -ForegroundColor DarkMagenta

    $startTime = Get-Date
    $buffer = New-Object System.Collections.ArrayList
    
    while ($true) {

        #   timer
        if (((Get-Date) - $startTime).TotalSeconds -ge $Timeout) {
            $result = ($buffer.Count -gt 0) ? ($buffer | Join-String) : $Default
            Write-Host "`nTimeout - returning value of $result" -ForegroundColor DarkRed
            return $result
        }
        if ($Host.UI.RawUI.KeyAvailable) {
            $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyUp')

            switch ($key.VirtualKeyCode) {
                13 {
                    # Enter key
                    $result = ($buffer.Count -gt 0) ? ($buffer | Join-String) : $Default
                    Write-Host "`n"
                    return $result

                }
                8 {
                    # Backspace key
                    if ($buffer.Count -gt 0) {
                        $buffer.RemoveAt($buffer.Count - 1)
                        Write-Host "`b `b" -NoNewline # Erase the last character from the console
                    }
                }
                27 {
                    # Escape key
                    Write-Host "`nInput escaped by user - returning default value of $Default" -ForegroundColor DarkRed
                    return $Default
                }
                default {
                    $buffer.Add($key.Character) | Out-Null
                    Write-Host -NoNewline $key.Character -ForegroundColor White
                }
            }
        }
        Start-Sleep -Milliseconds 50
    }
}

Export-ModuleMember -Function Read-HostTimeout