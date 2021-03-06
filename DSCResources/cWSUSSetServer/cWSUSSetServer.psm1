function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[System.String]
		$Url
	)

    Try {
        $WUServer = Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name WUServer -ErrorAction SilentlyContinue
    }
    Catch {
        $WUServer = "Not Defined"
    }

    Write-Verbose "Get the Windows Server Update Service Url"
	$returnValue = @{
		url = $WUServer
	}
    
    $returnValue
}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[System.String]
		$Url,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)
     
    if ($Ensure -eq "Present") { 
        Write-Verbose "Set the Windows Server Update Service Url to: $Url"
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name WUServer -value $Url -type string -force 
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name WUStatusServer -value $Url -type string -force
    }
    else { 
        Write-Verbose "UnSet the Windows Server Update Service Url"
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name WUServer -force
        Remove-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name WUStatusServer -force
    }

    

}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[System.String]
		$Url,

		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure
	)
    
    Write-Verbose "Test the Windows Server Update Service Url"

	Try {
        $WUServer = Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name WUServer -ErrorAction SilentlyContinue
    }
    Catch {
        $WUServer = ""   
    }

    Switch ($Ensure) {
        'Present' {
            if ($WUServer -eq $Url) {
                $Return = $true
            }
            else {
                $Return = $false
            }
        }
        'Absent' {
            if ($WUServer -eq $Url) {
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

