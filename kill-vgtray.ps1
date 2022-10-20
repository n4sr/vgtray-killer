param(
    [Float]
    $WaitFor = 5.0
)

$processname = 'vgtray'

function Exit-Message {
    param (
        [Parameter(Mandatory)]
        [String[]]
        $String,
        [Parameter()]
        [Int]
        $MessageTimeMS = 500,
        [Parameter()]
        [Int]
        $ExitCode = 0
    )
    Write-Output $string
    Start-Sleep -Milliseconds $MessageTimeMS
    exit $exit_code
}

Write-Output "Searching for $processname..."

# Scan every 100ms until either the process is found, or until $retries exceeds $WaitFor.
$retries = 0
while ($true) {
    try {
        $process = (Get-Process -Name $processname -ErrorAction Stop)
        break
    }
    catch {
        if ($retries -ge $WaitFor) {
            Exit-Message "$processname not found. exiting."
        }
        Start-Sleep -Milliseconds 100
        $retries += 0.1
        continue
    }
}

# Window information regarding vgtray
$WindowTitle = -join @("Kill ", $process.Name, " process?")
$WindowDescription = -join @(
                    "The process vgtray is RiotGame's anti-cheat system that must be ",
                    "started when the system starts. ",
                    "The process is currently running. ",
                    "If you kill the process you must restart your computer to ",
                    "play VALORANT. "
                    "`n`n",
                    "Would you like to kill the process?"
                    )


$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Kill the process."
$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not kill the process."
$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
$answer = $host.UI.PromptForChoice($WindowTitle, $WindowDescription, $Options, 1)

switch ($answer) {
    0 {
        Stop-Process $process
        Exit-Message "Process killed, Exiting..."
    }
    1 {
        Exit-Message "Aborting..."
    }
}
