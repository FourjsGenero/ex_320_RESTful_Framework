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
#+  Application Foundation Library
#+  - initialize()  : boiler plate application initialization
#+  - programExit() : standardized program exit point
#+
import fgl logger
import fgl dbUtility

################################################################################
#+ Initializes applictaion at startup by conecting to the database
#+
#+ @code
#+ CALL application.initialize()
#+
#+ @param  NONE
#+
#+ @return NONE
#+
function initialize() returns()
    define debugLevel integer

    whenever any error raise -- Let the application handle initialization failures

    # Initialize the logging file and connect to the database
    # Check APPDEBUG for logging : _LOGMSG:3 is default; otherwise _LOGERROR:1, _LOGDEBUG:2, _LOGACCESS:4, _LOGSQLERROR:5
    let debugLevel = iif(fgl_getenv("APPDEBUG"), fgl_getenv("APPDEBUG"), logger.C_LOGMSG)
    call logger.initializeLog(debugLevel, ".", "RESTServer.log")

    # Connect to the database
    call dbConnect()
    return

end function

################################################################################
#+ Disconnect from database and gracefully exits application
#+
#+ @code
#+ CALL programExit(exitCode)
#+
#+ @param  exitCode : INTEGER value 0=normal;1=fault
#+
#+ @return NONE
#+
function programExit(stat integer) returns()
    whenever any error continue
    call dbDisconnect()
    exit program stat
end function
