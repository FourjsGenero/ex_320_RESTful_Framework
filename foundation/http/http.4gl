################################################################################
# FOURJS_START_COPYRIGHT(U,2019)
# Property of Four Js*
# (c) Copyright Four Js 2019. All Rights Reserved.
# * Trademark of Four Js Development Tools Europe Ltd
#   in the United States and elsewhere
#
# Four Js and its suppliers do not warrant or guarantee that these samples
# are accurate and suitable for your purposes. Their inclusion is purely for
# information purposes only.
# FOURJS_END_COPYRIGHT
#
################################################################################

import com

################################################################################
#+ HTTP methods
#+ Commented methods are not supported in Genero with Web Services(FGLWS)
#+
public constant C_HTTP_GET = "GET"
public constant C_HTTP_POST = "POST"
#public constant C_HTTP_HEAD = "HEAD"
public constant C_HTTP_PUT = "PUT"
public constant C_HTTP_DELETE = "DELETE"
#public constant C_HTTP_TRACE = "TRACE"
#public constant C_HTTP_OPTIONS = "OPTIONS"
#public constant C_HTTP_CONNECT = "CONNECT"
#public constant C_HTTP_PATCH = "PATCH"
#
public constant DEF_METHOD = "GET"

#+ HTTP response list
public constant C_HTTP_OK smallint = 200
public constant C_HTTP_OK_CREATED smallint = 201
public constant C_HTTP_OK_ACCEPTED smallint = 202
public constant C_HTTP_OK_NOCONTENT smallint = 204
#
public constant C_HTTP_REDIR_MOVED smallint = 301
public constant C_HTTP_REDIR_FOUND smallint = 302
public constant C_HTTP_REDIR_SEEOTHER smallint = 303
public constant C_HTTP_REDIR_NOTMODIFIED smallint = 304
public constant C_HTTP_REDIR_TEMPMOVED smallint = 307
#
public constant C_HTTP_BADREQUEST smallint = 400
public constant C_HTTP_NOTAUTH smallint = 401
public constant C_HTTP_PAYMENTREQD smallint = 402
public constant C_HTTP_FORBIDDEN smallint = 403
public constant C_HTTP_NOTFOUND smallint = 404
public constant C_HTTP_NOTALLOWED smallint = 405
public constant C_HTTP_TIMEOUT smallint = 408
public constant C_HTTP_GONE smallint = 410
#
public constant C_HTTP_INTERNALERROR smallint = 500
public constant C_HTTP_NOTIMPLEMENTED smallint = 501
public constant C_HTTP_SERVICEUNAVAILABLE smallint = 503

#+ Standard header keys and values
public constant C_HDR_CONTENTTYPE = "Content-Type"
public constant C_HDR_ACCEPT = "Accept"
#+ IP address lookup
public constant C_HDR_REMOTE_ADDR = "REMOTE_ADDR"
public constant C_HDR_CLIENTIP = "HTTP_CLIENT_IP"
public constant C_HDR_X_FORWARDED_FOR = "HTTP_X_FORWARDED_FOR"
#+ Local headers
public constant C_HDR_AUTHKEY = "Authorization"

###
#+ Public variables
public define D_HTTPMETHOD dictionary of string
public define D_WEBPROTOCOL dictionary of string
public define D_HTTPSTATUS dictionary of string
public define D_HTTPSTATUSDESC dictionary of string

################################################################################
#+ Initializes static values for HTTP method.
#+ Commented methods are not supported in Genero with Web Services(FGLWS)
#+
public function initHttpMethods()
    # parameters
    --DEFINE arr DYNAMIC ARRAY OF t_Enum

    #+ HTTP methods
    let D_HTTPMETHOD["C_HTTP_GET"] = "GET"
    let D_HTTPMETHOD["C_HTTP_POST"] = "POST"
    #let D_HTTPMETHOD["C_HTTP_HEAD"] = "HEAD"
    let D_HTTPMETHOD["C_HTTP_PUT"] = "PUT"
    let D_HTTPMETHOD["C_HTTP_DELETE"] = "DELETE"
    #let D_HTTPMETHOD["C_HTTP_TRACE"] = "TRACE"
    #let D_HTTPMETHOD["C_HTTP_OPTIONS"] = "OPTIONS"
    #let D_HTTPMETHOD["C_HTTP_CONNECT"] = "CONNECT"
    #let D_HTTPMETHOD["C_HTTP_PATCH"] = "PATCH"

    return
end function

################################################################################
#+ Initializes static values for log levels.
#+
public function initHttpStatuses()
    # parameters

#+ HTTP response list descriptions
    let D_HTTPSTATUSDESC[C_HTTP_OK] = "OK"
    let D_HTTPSTATUSDESC[C_HTTP_OK_CREATED] = "Created"
    let D_HTTPSTATUSDESC[C_HTTP_OK_ACCEPTED] = "Accepted"
    let D_HTTPSTATUSDESC[C_HTTP_OK_NOCONTENT] = "No Content"
#
    let D_HTTPSTATUSDESC[C_HTTP_REDIR_MOVED] = "Moved"
    let D_HTTPSTATUSDESC[C_HTTP_REDIR_FOUND] = "Found"
    let D_HTTPSTATUSDESC[C_HTTP_REDIR_SEEOTHER] = "See Other"
    let D_HTTPSTATUSDESC[C_HTTP_REDIR_NOTMODIFIED] = "Not Modified"
    let D_HTTPSTATUSDESC[C_HTTP_REDIR_TEMPMOVED] = "Temporarily Moved"
#
    let D_HTTPSTATUSDESC[C_HTTP_BADREQUEST] = "Bad Request"
    let D_HTTPSTATUSDESC[C_HTTP_NOTAUTH] = "Unauthorized"
    let D_HTTPSTATUSDESC[C_HTTP_PAYMENTREQD] = "Payment Required"
    let D_HTTPSTATUSDESC[C_HTTP_FORBIDDEN] = "Forbidden"
    let D_HTTPSTATUSDESC[C_HTTP_NOTFOUND] = "Not Found"
    let D_HTTPSTATUSDESC[C_HTTP_NOTALLOWED] = "Method Not Allowed"
    let D_HTTPSTATUSDESC[C_HTTP_TIMEOUT] = "Request Timeout"
    let D_HTTPSTATUSDESC[C_HTTP_GONE] = "Gone"
#
    let D_HTTPSTATUSDESC[C_HTTP_INTERNALERROR] = "Internal Server Error"
    let D_HTTPSTATUSDESC[C_HTTP_NOTIMPLEMENTED] = "Not Implemented"
    let D_HTTPSTATUSDESC[C_HTTP_SERVICEUNAVAILABLE] = "Service Unavailable"

end function

################################################################################
#+ If true, a payload (request body) is valid given the method of the call; only certain
#+ methods allow for or define behavior for a request body.
#+
#+ @params method:STRING - HTTP method to test
#+
public function isHttpPayloadValid(method string) returns string
    return not (method
        = C_HTTP_GET #or method = C_HTTP_HEAD
        #or method = C_HTTP_OPTIONS
        #or method = C_HTTP_CONNECT
        #or method = C_HTTP_TRACE
        )
end function
