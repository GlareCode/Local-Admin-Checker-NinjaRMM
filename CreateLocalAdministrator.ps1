
if ($env:AUserName) { $AUserName = $env:AUserName }
if ($env:NinjaProperty) { $NinjaProperty = $env:NinjaProperty }

function Get-Password{
    $passRange = 33..122 | Get-Random -Count 12
    $avoid = @(34, 39, 40, 41, 43, 44, 45, 46, 47, 58, 59, 60, 62, 91, 93, 95, 96, 123, 124, 125, 126, 127)
    # Compare $passRange with $avoid; Remove any occurances and Replace
    foreach ($pass in $passRange){
        foreach ($avoi in $avoid){
            if ($pass -eq $avoi){
                $find = $passRange.IndexOf($avoi)
                $passRange[$find] = 65..90 | Get-Random -Count 1
            }
        }
    }
    # Check for Numbers.  Add number if there are none
    $count = 0
    foreach ($pass in $passRange){
        if ($pass -in 48..57){
            $count += 1
        }
    }
    # Check for Specials. Add Special if there are none
    $count1 = 0
    foreach ($pass in $passRange){
        if ($pass -in 35..38){
            $count1 += 1
        }
    }
    # Replace a character with a special
    if ($count1 -eq 0){
        $Spec = 0..9 | Get-Random -Count 1
        $Spec2 = 35..38 | Get-Random -Count 1
        $passRange[$spec] = $Spec2
    }
    # Replace a character with a number
    if ($count -eq 0){
        $Num = 0..9 | Get-Random -Count 1
        $Num2 = 48..57 | Get-Random -Count 1
        $passRange[$Num] = $Num2
    }
    # Append each character into a list and join them with no spaces
    $acc = @()
    foreach ($pass in $passRange){
        $acc += [char]$pass
    }

    $acc = $acc -join ''
    write-host "`n`nYour new password:  $acc`n`n"
    Ninja-Property-Set $NinjaProperty $acc
    return $acc

}

function Find-LocalAdmin {
    $UserFind = Get-LocalUser | Where-Object Name -like $AUserName

    if ($UserFind.Name -like $AUserName){
        Write-Host "`nThe user $AUserName already exists, updating password...`n"
        $GeneratedString = Get-Password
        & net user $AUserName $GeneratedString
    }Else{
        Write-Host "$AUserName does not exist"

        try {
            $ErrorActionPreference = "Stop"
            Write-Host "Creating $AUserName`n"
            Write-Host "Generating password...`n"
            $GeneratedString = Get-Password
            & net user $AUserName $GeneratedString
            Write-Host "Adding $AUserName to the local administrators Group`n"
            & net localgroup Administrators $AUserName /add
        }
        catch {
            write-host "An error occured in Find-LocalAdmin...Exiting - 00`n"
            Write-Host $_
            Exit 1
        }
    }
}


Find-LocalAdmin
