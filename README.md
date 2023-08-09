<#
    
    .SYNOPSIS

        finds a user in NinjaRMM parameter
        if not a user; creates user.
        if user exists; checks if localadmin.
        if or if not localadmin, resets password with generated.
        if not localadmin; turns into localadmin.
        Place user name and generated password in NinjaRMM Custom Attributes ( Administrators ) ( GeneratePassword )
        
    .NOTES

        You must create the custom attributes ( Administrators ) ( GeneratePassword ) in NinjaRMM first.
        ************************************************************************************************
        Administration > Devices > Global Custom Fields > Add > Name = Administrators > Select Field Type ( Text ) > Create
        Administration > Devices > Global Custom Fields > Add > Name = GeneratePassword > Select Field Type ( Text ) > Create
        
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
