
        $2 == "slapd"    {flag=1}
flag && $1 == "Depends:" {$1="Depends: psmisc, odbc-postgresql, unixodbc,";
                          flag=0}
                         {print}

