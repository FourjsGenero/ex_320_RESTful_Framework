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

#+  Generic Logging Library
#+  - Create Log file if doesn't exist
#+  - Adds simple practical info with type (Error, Message, ...)
#+

import com
import xml
import os

public constant C_LOGERROR = 1
public constant C_LOGDEBUG = 2
public constant C_LOGMSG = 3
public constant C_LOGACCESS = 4
public constant C_LOGSQLERROR = 5

private define mPid integer
private define mLevel string

# Logger function type definition
type loggerType function(logCategory integer, logClass string, logEvent string, logMessage string)
# Logger function reference
public define loggerFunction loggerType

# Register logger function
public function setLoggerFunction(functionName loggerType)
    let loggerFunction = functionName
end function

# BUG:FGL-4665 This is a temporary workaround for
public function logEvent(logCategory integer, logClass string, logEvent string, logMessage string)
    call loggerFunction(logCategory, logClass, logEvent, logMessage)
end function

################################################################################
#+ Checks path recursively
#+
#+ @code
#+ IF NOT checkPath(fullpath) THEN
#+
#+ @param path:STRING path to check
#+
#+ @returnType BOOLEAN
#+ @return os.Path.mkdir(path) If path exists or not and is valid
#+
private function checkPath(path string) returns integer
    define
        directoryName string,
        returnCode integer

    # Check if path exists
    let returnCode = os.Path.exists(path)

    # Check directory name
    if returnCode = false then
        let directoryName = os.Path.dirname(path)

        if directoryName == path then
            let returnCode = true # no dirname to extract anymore
        end if
    end if

    # Recursively check directory name
    if returnCode = false then
        if not checkPath(directoryName) then
            let returnCode = true
        end if
    end if

    # If path doesn't exist, create it
    if returnCode = false then
        let returnCode = os.Path.mkdir(path)
    end if

    return returnCode
end function

################################################################################
#+
#+ Start log file and set logging function reference
#+
#+ @code
#+ CALL logs.initializeLog("DEBUG",".","RESTServer.log")
#+
#+ @param thisLevel:STRING  debug level
#+ @param thisPath:STRING   valid path where log needs to be created (or if exist, logs need to be added to)
#+ @param thisFile:STRING   logfile name
#+
#+ @returnType
#+ @return NONE
#+
public function initializeLog(logLevel string, logPath string, logFile string) returns()
    define fullPath string

    let mPid = fgl_getpid()
    case logLevel
        when (C_LOGDEBUG)
            let mLevel = "DEBUG"
        when (C_LOGMSG)
            let mLevel = "MSG"
        when (C_LOGERROR)
            let mLevel = "ERROR"
    end case

    if logPath is not null then
        let fullPath = logPath || "/log"
        if not checkPath(fullPath) then
            display "ERROR: Unable to create log file in ", fullPath
            exit program (1)
        end if
        call startlog(fullPath || "/" || logFile)
    else
        call startlog(logFile)
    end if

    # Register default event logger
    call setLoggerFunction(function defaultLogger)
    call errorLog(sfmt("MSG  : %1 - [Logs] 'INIT' done", mPid))

    return
end function

################################################################################
#+
#+ Default event logger function used by function reference pointer
#+
#+ @code
#+ CALL setLoggerFunction(FUNCTION defaultLogger)
#+ CALL logger.logEvent(logger._LOGMSG,"Server","Main","Started")
#+
#+ @param logCategory:INTEGER  LOG category
#+                    By default : _LOGERROR and _LOGACCESS messages are logged
#+                       _LOGMSG : logs messages
#+                     _LOGDEBUG : logs everything
#+
#+ @param logClass:STRING   library/4gl module name
#+ @param logEvent:STRING   function name
#+ @param logMessage:STRING additional log message
#+
#+ @returnType
#+ @return NONE
#+
private function defaultLogger(logCategory integer, logClass string, logEvent string, logMessage string) returns()

    # Indicate the message was NULL
    if logMessage is null then
        let logMessage = "(null)"
    end if

    case logCategory

        when C_LOGERROR
            call errorLog(sfmt("ERROR  : %1 - [%2] '%3' %4", mPid, logClass, logEvent, logMessage))

        when C_LOGDEBUG
            if mLevel == "DEBUG" then
                call errorLog(sfmt("DEBUG  : %1 - [%2] '%3' %4", mPid, logClass, logEvent, logMessage))
            end if

        when C_LOGSQLERROR
            call errorLog(sfmt("SQLERR  : %1 - [%2] '%3' %4", mPid, logClass, logEvent, logMessage))

        when C_LOGMSG
            if mLevel == "MSG" or mLevel == "DEBUG" then
                call errorLog(sfmt("MSGLOG  : %1 - [%2] '%3' %4", mPid, logClass, logEvent, logMessage))
            end if

        when C_LOGACCESS
            call errorLog(sfmt("ACCESS  : %1 - [%2] '%3' %4", mPid, logClass, logEvent, logMessage))

        otherwise

    end case

    return
end function
