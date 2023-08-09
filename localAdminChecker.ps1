<#
    .SYNOPSIS

        finds a user in NinjaRMM parameter
        if not a user; creates user.
        if user exists; checks if localadmin.
        if or if not localadmin, resets password with generated.
        if not localadmin; turns into localadmin.

    .INPUTS

        Requires NinjaRMM parameter ( Type in a username in param before running script )

    .OUTPUTS

        "Setting NinjaRMM Custom Attribute (Administrators)"
        "Setting NinjaRMM Custom Attribute (GeneratePassword)"
        "$User Exists"
        "$User does not exist"
        "Trying to make $User Admin..."
        "An error occured in Find-LocalAdmin...Exiting - 00"
        "Something unexpected happend in Find-LocalAdmin...Exiting - 00"
        "Something unexpected happend in Find-LocalAdmin...Exiting - 01"
        "An error occured in Find-LocalAdmin...Exiting - 01"

    .EXAMPLE
        PS> Find-LocalAdmin

#>


param(
  [String]$variable1='')

if ($variable1 -eq $null){
    return "Need NinjaRMM parameter set...Exiting"
}Else{
    Write-Host "NinjaRMM parameter set to $variable1...Continuing"
}

$gotchya = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

if ($gotchya -eq $False){
    Write-Host "**************Please reopen PowerShell as Administrator***************"
    Write-Host "**************Please reopen PowerShell as Administrator***************"
    Write-Host "**************Please reopen PowerShell as Administrator***************"
    stop-process -id $PID
}

function Find-LocalAdmin {
    #$User = "test"
    $UserFind = Get-LocalUser | Where-Object Name -like "$variable1"
    $UserFind

    if ($UserFind.Name -like "$variable1"){
        Write-Host "$variable1 Exists"

        if ($UserFind.Enabled -eq "True"){
            Write-Host "$variable1 is Admin"
            
            try {
                # Generate and assign password
                Add-Type -AssemblyName system.web
                $pass = [System.Web.Security.Membership]::GeneratePassword(12, 1)
                Write-Host "Setting password for $variable1"
                & net user $variable1 $pass
                Write-Host "The password is $pass"
            }
            catch {
                return "An error occured in Find-LocalAdmin...Exiting - 03"
            }

            try {
                # Set Ninja Custom Attributes
                Write-Host "Setting NinjaRMM Custom Attribute (GeneratePassword)"
                Ninja-Property-Set generatepassword $pass
                Write-Host "Setting NinjaRMM Custom Attribute (Administrators)"
                Ninja-Property-Set administrators $variable1
            }
            catch {
                return "An error occured in Find-LocalAdmin...Exiting - 02"
            }

            return "`nJobs done`n"

        }Else{
            Write-Host "$variable1 is not Admin"
            
            try {
                $ErrorActionPreference = "Stop"
                Write-Host "Trying to make $variable1 Admin..."
                & net localgroup Administrators $variable1 /add
            }
            catch {
                return "An error occured in Find-LocalAdmin...Exiting - 01"
            }
            return "Something unexpected happend in Find-LocalAdmin...Exiting - 01"
        }
    }Else{
        Write-Host "$variable1 does not exist"
        
        try {
            $ErrorActionPreference = "Stop"

            Write-Host "Creating $variable1"
            & net user $variable1 teMp*3dG4gd*2k /add

            Write-Host "Adding $variable1 to Admin Group"
            & net localgroup Administrators $variable1 /add

        }
        catch {
            return "An error occured in Find-LocalAdmin...Exiting - 00"
        }
        return Find-LocalAdmin
    }
    return "Something unexpected happend in Find-LocalAdmin...Exiting - 00"

}

Find-LocalAdmin

