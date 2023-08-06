<#
    .SYNOPSIS

        finds a user.
        if not a user; creates user.
        if user exist; checks if localadmin.
        if not localadmin; turns into localadmin.

    .INPUTS

        None. but alter the '$who' variable in function 'find-localAdmins' to reflect the user you're interested in.

    .OUTPUTS

        Has four outputs.
        1: '$gen' calls function 'Initialize-Password' and '$gen' will not change unless function 'creaete-localAdmin' is called again.
        2: function 'create-localAdmin' will print if '$who' is not a user.
        3: function 'check-localAdmins' will print if '$who' is or is not a localadmin.

    .EXAMPLE

        $who is not a user, creating user now...
        $who is already a local administrator
        $who is not a local administrator

    .EXAMPLE

        PS> find-localAdmins

#>

$gotchya = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

if ($gotchya -eq $False){

    Write-Host "`n**************Please reopen PowerShell as Administrator***************"
    Write-Host "**************Please reopen PowerShell as Administrator***************"
    Write-Host "**************Please reopen PowerShell as Administrator***************`n"
    
    $exit = Read-Host "Press 0 to Exit"

    if ($exit -ne 0){
        stop-process -id $PID
    }Else{
        stop-process -id $PID
    }

}

function Initialize-Restart {

    $restart = Read-Host "Start over? `nPress 1 for Yes and 2 for No`n"

    if ($restart -eq "1"){
        Measure-LocalAdmins
    }ElseIf ($restart -eq "2"){
        stop-process -id $PID
    }Else{
        Initialize-Restart
    }

}


function Initialize-Password {                             # Generate random password

    Add-Type -AssemblyName system.web
    [System.Web.Security.Membership]::GeneratePassword(12, 1)

    $output = Get-LocalGroupMember -Name "Administrators" | Select-Object -ExpandProperty Name
    $output
    write-host "$who generated password is $gen"
    
    Initialize-Restart

}


function Grant-LocalAdmin {

    # If '$g' is still '$false' then the user does not exist-
    # will create the user with '$who and $pass'-
    # then toggles '$g' to '$True'

    Write-Host "$who is not a user, creating user now..."
    Start-Sleep -Seconds 4

    $gen = Initialize-Password

    & net user /add $who $gen
    & net localgroup administrators $who /add
    
    # When the localAdmin is created, it will place the generated password in Ninja Custom Fields.
    # Ninja-Property-Set Administrator-Password $gen

}


function Find-LocalAdmins {                                # If '$who' is a localAdministrator, '$localAdministrators' will be greater than 0.
    
    $localAdministrators = Get-LocalGroupMember -Name "Administrators" | Where-Object {$_.Name -eq "$env:COMPUTERNAME\$who"} | Select-Object -ExpandProperty Name

    if ($localAdministrators -gt 0){
        Write-Host "$who is a local administrator"
    }else{
        Write-Host "$who is not a local administrator"
        Grant-LocalAdmin
    }

}


function Measure-LocalAdmins {                             # Finds all local users and places into variable localUsers.
    
    Get-LocalUser | Where-Object {$_.Enabled -eq $true} | select-object -ExpandProperty Name -OutVariable localUsers | Out-Null
    
    $g = "$False"                                          # '$g' will toggle to '$True' if '$who' user is already in the system.
    $who = Read-Host "`nWhich user are you searching for?`n"

    for ($i = 0; $i -le $localUsers.count; $i++) {
        if ($localUsers[$i] -eq $who){
            $g = "$True"
        }
    }

    if ($pass.Length -gt 14) {
        Write-Host "$pass is longer than 14 characters and will not work with dos"
        Start-Sleep -Seconds 3
        Measure-LocalAdmins
    }

    if ($g -eq "$false") {                                  # If '$g' is '$False' it will call function 'Find-LocalAdmins'.
        Find-LocalAdmins
        $g = "$True"
    }Elseif ($g -eq "$True") {                              # If '$g' is '$True' it will call function 'Find-LocalAdmins'.
        Find-LocalAdmins
    }

}


Measure-LocalAdmins

# Ninja-Property-Set Administrator $output
