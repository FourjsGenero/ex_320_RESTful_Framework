################################################################################
# FOURJS_START_COPYRIGHT(U,2015)
# Property of Four Js*
# (c) Copyright Four Js 2015, 2019. All Rights Reserved.
# * Trademark of Four Js Development Tools Europe Ltd
#   in the United States and elsewhere
#
# Four Js and its suppliers do not warrant or guarantee that these samples
# are accurate and suitable for your purposes. Their inclusion is purely for
# information purposes only.
# FOURJS_END_COPYRIGHT
#
#+  Database Foundation Library
#+  - dbConnect()    : connects to database configured in the environment FGLDBNAME
#+  - dbDisconnect() : disconnects from the current database
#+
import fgl logger

################################################################################
#+ Connect to a database specified in the environment.
#+
#+ @code
#+ CALL dbConnect()
#+
#+ @param  NONE
#+
#+ @return NONE
#
public function dbConnect() returns()
    if (fgl_getenv("FGLDBNAME") is not null) then
        connect to fgl_getenv("FGLDBNAME")

        # Make sure to have committed read isolation level and wait for locks
        whenever error continue # Ignore SQL errors if instruction not supported
        set isolation to committed read
        set lock mode to wait
    else
        call logger.logEvent(
            logger.C_LOGMSG, ARG_VAL(0), sfmt("%1:%2", __FILE__, __LINE__), "Application database(FGLDBNAME) is not specified.")
        call programExit(1)
    end if

    whenever any error raise -- Let the application handle initialization failures
    return
end function

################################################################################
#+ Disconnect from the current database
#+
#+ @code
#+ CALL dbDisconnect()
#+
#+ @param  NONE
#+
#+ @return NONE
#+
public function dbDisconnect() returns()

    # Disconnect current DB
    disconnect current

end function
