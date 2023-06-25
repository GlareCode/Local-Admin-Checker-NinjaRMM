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
        1: '$gen' calls function 'generate-password' and '$gen' will not change unless function 'create-localAdmin' is called again.
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

This script also features NinjaRMM Custom Fields options on lines 52 and 109.
