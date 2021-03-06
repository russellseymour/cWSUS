function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("True","False")]
		[System.String]
        $Enable
	)

	Write-Verbose "Get the value of Windows Server Update Service No automatic reboot with logged on users"

    Try {
        if ((Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU' -Name NoAutoRebootWithLoggedOnUsers -ErrorAction SilentlyContinue) -eq "1") {
            $NoAutoRebootWithLoggedOnUsers = "True"
        }
        else {
            $NoAutoRebootWithLoggedOnUsers = "False"
        }
    }
    Catch {
        $NoAutoRebootWithLoggedOnUsers = "False"
    }

	$returnValue = @{
		Enable = $NoAutoRebootWithLoggedOnUsers
	}

	$returnValue
}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("True","False")]
		[System.String]
        $Enable
	)
    
    Write-Verbose "Set the value of Windows Server Update Service No automatic reboot with logged on users to $Enable"
	if ($Enable -eq "False") {
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name NoAutoRebootWithLoggedOnUsers -Value 1 -type dword -Force
    }
    Else {
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name NoAutoRebootWithLoggedOnUsers -Value 0 -type dword -Force
    }
}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("True","False")]
		[System.String]
        $Enable
	)

	Write-Verbose "Test if the value of Windows Server Update Service - No automatic reboot with logged on users is: $Enable "
	
    Try {
        $State = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU' -Name NoAutoRebootWithLoggedOnUsers -ErrorAction SilentlyContinue
    }
    Catch {
        $State = "0"
    }

    Switch ($Enable) {
        'True' { 
            if ($State -eq "0") {
                $Return = $true
            }
            elseif ($state -eq "1") {
                $Return = $false
            }
        }
        'False' {
            if ($State -eq "0") {
                $Return = $false
            }
            elseif ($state -eq "1") {
                $Return = $true
            }
        }
    }
    $Return
}


Export-ModuleMember -Function *-TargetResource

