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
