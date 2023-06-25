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
        1: '$gen' calls function 'generate-password' and '$gen' will not change unless function 'creaete-localAdmin' is called again.
        2: function 'create-localAdmin' will print if '$who' is not a user.
        3: function 'check-localAdmins' will print if '$who' is or is not a localadmin.

    .EXAMPLE

        $who is not a user, creating user now...
        $who is already a local administrator
        $who is not a local administrator

    .EXAMPLE

        PS> find-localAdmins

    .LINK
        
#>


function generate-Password{
    Add-Type -AssemblyName system.web
    [System.Web.Security.Membership]::GeneratePassword(12, 1)
}


function create-localAdmin {

    # If '$g' is still '$false' then the user is not created at all and will create the user with '$who and $pass', then toggles '$g' to '$True'
    Write-Host "$who is not a user, creating user now..."

    $gen = generate-Password

    & net user /add $who $gen
    & net localgroup administrators $who /add
    
    # When the localAdmin is created, it will place the generated password in Ninja Custom Fields.
    #Ninja-Property-Set Administrator-Password $gen
}


function check-localAdmins {
         
    # If '$who' is a localAdministrator, '$localAdministrators' will be greater than 0.
    $localAdministrators = Get-LocalGroupMember -Name "Administrators" | Where-Object {$_.Name -eq "$env:COMPUTERNAME\$who"} | Select-Object -ExpandProperty Name

    if ($localAdministrators -gt 0){
        Write-Host "$who is a local administrator"
    }else{
        Write-Host "$who is not a local administrator"
    }
}


function find-localAdmins {

    # Finds all local users and places into variable localUsers.
    Get-LocalUser | Where-Object {$_.Enabled -eq $true} | select-object -ExpandProperty Name -OutVariable localUsers | Out-Null

    # '$g' will toggle to '$True' if '$who' user is already in the system.
    $g = "$False"
    $who = "testuser"

    for ($i = 0; $i -le $localUsers.count; $i++){

        if ($localUsers[$i] -eq $who){
            $g = "$True"
        }
    }
    
    if ($pass.Length -gt 14){
        Write-Host "$pass is longer than 14 characters and will not work with dos"
        break
    }

    # If '$g' is '$False' it will call function 'create-localAdmin'.
    if ($g -eq "$false"){
        create-localAdmin
        $g = "$True"
    }

    # If '$g' is '$True' it will call function 'check-localAdmins'.
    if ($g -eq "$True"){
        check-localAdmins
    }
}


find-localAdmins

$output = Get-LocalGroupMember -Name "Administrators" | Select-Object -ExpandProperty Name
$output
write-host "$who generated password is $gen"

#Ninja-Property-Set Administrator $output
