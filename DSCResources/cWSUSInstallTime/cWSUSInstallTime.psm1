function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Time
	)

    Write-Verbose "Get the Windows Server Update Service Installation time"

    Try {
        $InstallTime = Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name ScheduledInstallTime -ErrorAction SilentlyContinue
    }
    Catch {
        $InstallTime = 0
    }

    $returnValue = @{
        Time = $InstallTime
    }

    $returnValue
}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Time,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)
    
    if ($Ensure -eq "Present") {
        Write-Verbose "Set the Windows Server Update Service Installation time to: $time"
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name ScheduledInstallTime -Value $Time -type dword -Force
    }
    else {
        Write-Verbose "Remove the Windows Server Update Service Installation time"
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name ScheduledInstallTime -Value "" -type dword -Force
    }

}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Time,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)

    Try {
        $InstallTime = Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name ScheduledInstallTime -ErrorAction SilentlyContinue
    }
    Catch {
        $InstallTime = 0
    }

    Switch ($Ensure) {
        'Present' {
            if ($Time -eq $InstallTime) {
                $Return = $true
            }
            else {
                $Return = $false
            }
        }
        'Absent' {
            if ($Time -eq $InstallTime) {
                $Return = $false
            }
            else {
                $Return = $true
            }
        }
    }

    $Return
}


Export-ModuleMember -Function *-TargetResource

