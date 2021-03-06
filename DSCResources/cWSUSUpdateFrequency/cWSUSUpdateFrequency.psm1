function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Frequency,
        [ValidateSet("True","False")]      
		[System.String]
		$Enable
	)

    Write-Verbose "Get the Windows Server Update Service Installation frequency"	

    Try {
        if ((Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequencyEnabled -ErrorAction SilentlyContinue) -eq "1") {
            $state = "True"
        }
        else { 
            $state = "False" 
        }
        [Int]$FrequencyReg = Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequency -ErrorAction SilentlyContinue
    }
    Catch {
        $State = "False"
        $FrequencyReg = "0"
    }

    $returnValue = @{
        Enable = $state
        Frequency = $FrequencyReg
	}

	$returnValue

}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Frequency,
        [ValidateSet("True","False")]      
		[System.String]
		$Enable
	)

    if ($Enable -eq "True") {
        Write-Verbose "Set & Enable the installation frequency to $frequency in the Windows Server Update Service."
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequencyEnabled -value 1 -type dword -Force
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequency -Value $Frequency -type dword -Force

    }
    else {
        Write-Verbose "Remove the installation frequency in the Windows Server Update Service."
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequencyEnabled -value 0 -type dword -Force
    }

}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[System.Int32]
		$Frequency,
        [ValidateSet("True","False")]      
		[System.String]
		$Enable
	)

    Write-Verbose "Test if the installation frequency in the Windows Server Update Service is set to $frequency."

    Try {
        Switch (Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequencyEnabled -ErrorAction SilentlyContinue) {
            '1' { $state = "True" }
            '0' { $state = "False" }
        }

        $FrequencyReg = Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name DetectionFrequency -ErrorAction SilentlyContinue
    }
    Catch {
        $State = "False"
        $FrequencyReg = 0
    }
     
    switch ($Enable) {
        "true"  { 
            if ($state -eq $Enable) {
                if ($Frequency -eq $FrequencyReg) {
                    $Return = $true
                }
                else {
                    $Return = $false
                }   
            }
            else {
                $Return = $false
            }
        }
        "false" { 
            if ($state -eq $Enable) {
                if ($Frequency -eq $FrequencyReg) {
                    $Return = $false
                }
                else {
                    $Return = $true
                }   
            }
            else {
                $Return = $true
            }
        }
    }

    $Return
}


Export-ModuleMember -Function *-TargetResource

