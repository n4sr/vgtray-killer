param(
    [Float]
    $WaitFor = 3.0
)

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

Write-Output "Searching for vgtray..."
Start-Sleep -Seconds $WaitFor

try {
    $process = (Get-Process -Name "vgtray" -ErrorAction Stop)
    }
catch {
    Exit-Message "Process not found. Exiting..."
}

$WindowTitle = "Kill vgtray process?"
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
