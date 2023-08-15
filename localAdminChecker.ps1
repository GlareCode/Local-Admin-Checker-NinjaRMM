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

    .References
        https://www.reddit.com/r/PowerShell/comments/2uwawx/is_there_any_way_i_get_the_int_value_of_a/
        https://www.asciitable.com/
        https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-random?view=powershell-7.3
        
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

    function Get-Password{

        $test = 33..122 | Get-Random -Count 9
        $avoid = @(34, 39, 40, 41, 43, 44, 45, 46, 47, 58, 59, 60, 62, 91, 93, 95, 96, 123, 124, 125, 126, 127)
        
        foreach ($tes in $test){         # Compare $test with $avoid; Remove any occurances and Replace
            foreach ($avoi in $avoid){
                if ($tes -eq $avoi){
                    $find = $test.IndexOf($avoi)
                    $test[$find] = 65..90 | Get-Random -Count 1
                }
            }
        }
    
        $count = 0                       # Check for Numbers; Add number if there are none
        foreach ($tes in $test){
            if ($tes -in 48..57){
                $count += 1
            }
        }
    
        $count1 = 0                      # Check for Specials; Add Special if there are none
        foreach ($tes in $test){
            if ($tes -in 35..38){
                $count1 += 1
            }
        }
    
        if ($count1 -eq 0){              # Replace a character with a special
            $Spec = 0..9 | Get-Random -Count 1
            $Spec2 = 35..38 | Get-Random -Count 1
            $test[$spec] = $Spec2
        }
    
        if ($count -eq 0){               # Replace a character with a number
            $Num = 0..9 | Get-Random -Count 1
            $Num2 = 48..57 | Get-Random -Count 1
            $test[$Num] = $Num2
        }
    
        $acc = @()                       # Append each character into a list and join them with no spaces
        foreach ($tes in $test){
            $acc += [char]$tes
        }
    
        $acc = $acc -join ''
        return $acc
    
    }


    $UserFind = Get-LocalUser | Where-Object Name -like "$variable1"
    $UserFind

    if ($UserFind.Name -like "$variable1"){
        Write-Host "$variable1 Exists"

        if ($UserFind.Enabled -eq "True"){
            Write-Host "$variable1 is Admin"
            
            try {
                $test = 33..122 | Get-Random -Count 9
                $avoid = @(34, 39, 40, 41, 43, 44, 45, 46, 47, 58, 59, 60, 62, 91, 93, 95, 96, 123, 124, 125, 126, 127)
                
                foreach ($tes in $test){         # Compare $test with $avoid; Remove any occurances and Replace
                    foreach ($avoi in $avoid){
                        if ($tes -eq $avoi){
                            $find = $test.IndexOf($avoi)
                            $test[$find] = 65..90 | Get-Random -Count 1
                        }
                    }
                }
            
                $count = 0                       # Check for Numbers; Add number if there are none
                foreach ($tes in $test){
                    if ($tes -in 48..57){
                        $count += 1
                    }
                }
            
                $count1 = 0                      # Check for Specials; Add Special if there are none
                foreach ($tes in $test){
                    if ($tes -in 35..38){
                        $count1 += 1
                    }
                }
            
                if ($count1 -eq 0){              # Replace a character with a special
                    $Spec = 0..9 | Get-Random -Count 1
                    $Spec2 = 35..38 | Get-Random -Count 1
                    $test[$spec] = $Spec2
                }
            
                if ($count -eq 0){               # Replace a character with a number
                    $Num = 0..9 | Get-Random -Count 1
                    $Num2 = 48..57 | Get-Random -Count 1
                    $test[$Num] = $Num2
                }
            
                $acc = @()                       # Append each character into a list and join them with no spaces
                foreach ($tes in $test){
                    $acc += [char]$tes
                }
            
                $acc = $acc -join ''

                Write-Host "Setting password for $variable1"
                & net user $variable1 $acc
                Write-Host "The password is $acc"
            }
            catch {
                return "An error occured in Find-LocalAdmin...Exiting - 03"
            }

            try {
                # Set Ninja Custom Attributes
                Write-Host "Setting NinjaRMM Custom Attribute (GeneratePassword)"
                Ninja-Property-Set generatepassword $acc
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

