#+
#+ Generated from ws_restCliLib320
#+
IMPORT com
IMPORT xml
IMPORT util
IMPORT os

#+
#+ Global Endpoint user-defined type definition
#+
TYPE tGlobalEndpointType RECORD # Rest Endpoint
    Address RECORD # Address
        Uri STRING # URI
    END RECORD,
    Binding RECORD # Binding
        Version STRING, # HTTP Version (1.0 or 1.1)
        ConnectionTimeout INTEGER, # Connection timeout
        ReadWriteTimeout INTEGER, # Read write timeout
        CompressRequest STRING # Compression (gzip or deflate)
    END RECORD
END RECORD

PUBLIC DEFINE Endpoint
    tGlobalEndpointType
    = (Address:(Uri: "http://localhost:8090/ws/r/officestore"))

# Error codes
PUBLIC CONSTANT C_SUCCESS = 0
PUBLIC CONSTANT C_NOT_FOUND = 1001
PUBLIC CONSTANT C_INTERNAL_SERVER_ERROR = 1002
PUBLIC CONSTANT C_BAD_REQUEST = 1003

# generated getSupplierRecordsResponseBodyType
PUBLIC TYPE getSupplierRecordsResponseBodyType DYNAMIC ARRAY OF RECORD
    suppid INTEGER,
    name STRING,
    sustatus STRING,
    addr1 STRING,
    addr2 STRING,
    city STRING,
    state STRING,
    zip STRING,
    phone STRING
END RECORD

# generated getCountryRecordsResponseBodyType
PUBLIC TYPE getCountryRecordsResponseBodyType DYNAMIC ARRAY OF RECORD
    code STRING,
    codedesc STRING
END RECORD

# generated insertCountryRequestBodyType
PUBLIC TYPE insertCountryRequestBodyType RECORD
    code STRING,
    codedesc STRING
END RECORD

# generated insertCountryResponseBodyType
PUBLIC TYPE insertCountryResponseBodyType RECORD
    code STRING,
    codedesc STRING
END RECORD

# generated getCategoryRecordsResponseBodyType
PUBLIC TYPE getCategoryRecordsResponseBodyType DYNAMIC ARRAY OF RECORD
    catid STRING,
    catorder INTEGER,
    catname STRING,
    catdesc STRING,
    catpic STRING
END RECORD

# generated getCountryByIdResponseBodyType
PUBLIC TYPE getCountryByIdResponseBodyType RECORD
    code STRING,
    codedesc STRING
END RECORD

# generated updateCountryByIdRequestBodyType
PUBLIC TYPE updateCountryByIdRequestBodyType RECORD
    code STRING,
    codedesc STRING
END RECORD

# generated getCategoryByIdResponseBodyType
PUBLIC TYPE getCategoryByIdResponseBodyType RECORD
    catid STRING,
    catorder INTEGER,
    catname STRING,
    catdesc STRING,
    catpic STRING
END RECORD

# generated getSupplierByIdResponseBodyType
PUBLIC TYPE getSupplierByIdResponseBodyType RECORD
    suppid INTEGER,
    name STRING,
    sustatus STRING,
    addr1 STRING,
    addr2 STRING,
    city STRING,
    state STRING,
    zip STRING,
    phone STRING
END RECORD

################################################################################
# Operation /v1/suppliers
#
# VERB: GET
# DESCRIPTION :Fetches the suppliers resource with the optional filter value(s) applied.
#
PUBLIC FUNCTION getSupplierRecords(
    p_id STRING)
    RETURNS(INTEGER, getSupplierRecordsResponseBodyType)
    DEFINE fullpath base.StringBuffer
    DEFINE query base.StringBuffer
    DEFINE contentType STRING
    DEFINE req com.HTTPRequest
    DEFINE resp com.HTTPResponse
    DEFINE xml_resp_body
        DYNAMIC ARRAY ATTRIBUTE(XMLName = 'rv0') OF
        RECORD ATTRIBUTE(XMLName = 'element')
        suppid INTEGER,
        name STRING,
        sustatus STRING,
        addr1 STRING,
        addr2 STRING,
        city STRING,
        state STRING,
        zip STRING,
        phone STRING
    END RECORD
    DEFINE resp_body getSupplierRecordsResponseBodyType
    DEFINE xml_body xml.DomDocument
    DEFINE xml_node xml.DomNode
    DEFINE json_body STRING

    TRY

        # Prepare request path
        LET fullpath = base.StringBuffer.Create()
        LET query = base.StringBuffer.Create()
        CALL fullpath.append("/v1/suppliers")
        IF p_id IS NOT NULL THEN
            IF query.getLength() > 0 THEN
                CALL query.append(SFMT("&id=%1", p_id))
            ELSE
                CALL query.append(SFMT("id=%1", p_id))
            END IF
        END IF
        IF query.getLength() > 0 THEN
            CALL fullpath.append("?")
            CALL fullpath.append(query.toString())
        END IF

        # Create request and configure it
        LET req =
            com.HTTPRequest.Create(
                SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
        IF Endpoint.Binding.Version IS NOT NULL THEN
            CALL req.setVersion(Endpoint.Binding.Version)
        END IF
        IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
            CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
        END IF
        IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
            CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
        END IF
        IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
            CALL req.setHeader(
                "Content-Encoding", Endpoint.Binding.CompressRequest)
        END IF

        # Perform request
        CALL req.setMethod("GET")
        CALL req.setHeader("Accept", "application/json, application/xml")
        CALL req.DoRequest()

        # Retrieve response
        LET resp = req.getResponse()
        # Process response
        INITIALIZE resp_body TO NULL
        LET contentType = resp.getHeader("Content-Type")
        CASE resp.getStatusCode()

            WHEN 200 #Success
                IF contentType MATCHES "*application/json*" THEN
                    # Parse JSON response
                    LET json_body = resp.getTextResponse()
                    CALL util.JSON.parse(json_body, resp_body)
                    RETURN C_SUCCESS, resp_body
                END IF
                IF contentType MATCHES "*application/xml*" THEN
                    # Parse XML response
                    LET xml_body = resp.getXmlResponse()
                    LET xml_node = xml_body.getDocumentElement()
                    CALL xml.serializer.DomToVariable(xml_node, xml_resp_body)
                    LET resp_body = xml_resp_body
                    RETURN C_SUCCESS, resp_body
                END IF
                RETURN -1, resp_body

            WHEN 404 #Not Found
                RETURN C_NOT_FOUND, resp_body

            WHEN 500 #Internal Server Error
                RETURN C_INTERNAL_SERVER_ERROR, resp_body

            OTHERWISE
                RETURN resp.getStatusCode(), resp_body
        END CASE
    CATCH
        RETURN -1, resp_body
    END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /v1/countries
#
# VERB: GET
# DESCRIPTION :Fetches the countries resource with the optional filter value(s) applied.
#
PUBLIC FUNCTION getCountryRecords(
    p_id STRING)
    RETURNS(INTEGER, getCountryRecordsResponseBodyType)
    DEFINE fullpath base.StringBuffer
    DEFINE query base.StringBuffer
    DEFINE contentType STRING
    DEFINE req com.HTTPRequest
    DEFINE resp com.HTTPResponse
    DEFINE xml_resp_body
        DYNAMIC ARRAY ATTRIBUTE(XMLName = 'countries') OF
        RECORD ATTRIBUTE(XMLName = 'country')
        code STRING,
        codedesc STRING
    END RECORD
    DEFINE resp_body getCountryRecordsResponseBodyType
    DEFINE xml_body xml.DomDocument
    DEFINE xml_node xml.DomNode
    DEFINE json_body STRING

    TRY

        # Prepare request path
        LET fullpath = base.StringBuffer.Create()
        LET query = base.StringBuffer.Create()
        CALL fullpath.append("/v1/countries")
        IF p_id IS NOT NULL THEN
            IF query.getLength() > 0 THEN
                CALL query.append(SFMT("&id=%1", p_id))
            ELSE
                CALL query.append(SFMT("id=%1", p_id))
            END IF
        END IF
        IF query.getLength() > 0 THEN
            CALL fullpath.append("?")
            CALL fullpath.append(query.toString())
        END IF

        # Create request and configure it
        LET req =
            com.HTTPRequest.Create(
                SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
        IF Endpoint.Binding.Version IS NOT NULL THEN
            CALL req.setVersion(Endpoint.Binding.Version)
        END IF
        IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
            CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
        END IF
        IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
            CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
        END IF
        IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
            CALL req.setHeader(
                "Content-Encoding", Endpoint.Binding.CompressRequest)
        END IF

        # Perform request
        CALL req.setMethod("GET")
        CALL req.setHeader("Accept", "application/json, application/xml")
        CALL req.DoRequest()

        # Retrieve response
        LET resp = req.getResponse()
        # Process response
        INITIALIZE resp_body TO NULL
        LET contentType = resp.getHeader("Content-Type")
        CASE resp.getStatusCode()

            WHEN 200 #Success
                IF contentType MATCHES "*application/json*" THEN
                    # Parse JSON response
                    LET json_body = resp.getTextResponse()
                    CALL util.JSON.parse(json_body, resp_body)
                    RETURN C_SUCCESS, resp_body
                END IF
                IF contentType MATCHES "*application/xml*" THEN
                    # Parse XML response
                    LET xml_body = resp.getXmlResponse()
                    LET xml_node = xml_body.getDocumentElement()
                    CALL xml.serializer.DomToVariable(xml_node, xml_resp_body)
                    LET resp_body = xml_resp_body
                    RETURN C_SUCCESS, resp_body
                END IF
                RETURN -1, resp_body

            WHEN 404 #Not Found
                RETURN C_NOT_FOUND, resp_body

            WHEN 500 #Internal Server Error
                RETURN C_INTERNAL_SERVER_ERROR, resp_body

            OTHERWISE
                RETURN resp.getStatusCode(), resp_body
        END CASE
    CATCH
        RETURN -1, resp_body
    END TRY
END FUNCTION
#
# VERB: POST
# DESCRIPTION :Post test
#
PUBLIC FUNCTION insertCountry(
    p_body insertCountryRequestBodyType)
    RETURNS(INTEGER, insertCountryResponseBodyType)
    DEFINE fullpath base.StringBuffer
    DEFINE contentType STRING
    DEFINE req com.HTTPRequest
    DEFINE resp com.HTTPResponse
    DEFINE resp_body insertCountryResponseBodyType
    DEFINE json_body STRING

    TRY

        # Prepare request path
        LET fullpath = base.StringBuffer.Create()
        CALL fullpath.append("/v1/countries")

        # Create request and configure it
        LET req =
            com.HTTPRequest.Create(
                SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
        IF Endpoint.Binding.Version IS NOT NULL THEN
            CALL req.setVersion(Endpoint.Binding.Version)
        END IF
        IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
            CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
        END IF
        IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
            CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
        END IF
        IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
            CALL req.setHeader(
                "Content-Encoding", Endpoint.Binding.CompressRequest)
        END IF

        # Perform request
        CALL req.setMethod("POST")
        CALL req.setHeader("Accept", "application/json")
        # Perform JSON request
        CALL req.setHeader("Content-Type", "application/json")
        LET json_body = util.JSON.stringify(p_body)
        CALL req.DoTextRequest(json_body)

        # Retrieve response
        LET resp = req.getResponse()
        # Process response
        INITIALIZE resp_body TO NULL
        LET contentType = resp.getHeader("Content-Type")
        CASE resp.getStatusCode()

            WHEN 201 #Created
                IF contentType MATCHES "*application/json*" THEN
                    # Parse JSON response
                    LET json_body = resp.getTextResponse()
                    CALL util.JSON.parse(json_body, resp_body)
                    RETURN C_SUCCESS, resp_body.*
                END IF
                RETURN -1, resp_body.*

            WHEN 400 #Bad Request
                RETURN C_BAD_REQUEST, resp_body.*

            WHEN 500 #Internal Server Error
                RETURN C_INTERNAL_SERVER_ERROR, resp_body.*

            OTHERWISE
                RETURN resp.getStatusCode(), resp_body.*
        END CASE
    CATCH
        RETURN -1, resp_body.*
    END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /v2/countries
#
# VERB: GET
# DESCRIPTION :Fetches the countries resource with the optional filter value(s) applied.
#
PUBLIC FUNCTION getCountryRecordsV2(p_id STRING) RETURNS(INTEGER, STRING)
    DEFINE fullpath base.StringBuffer
    DEFINE query base.StringBuffer
    DEFINE contentType STRING
    DEFINE req com.HTTPRequest
    DEFINE resp com.HTTPResponse
    DEFINE resp_body STRING

    TRY

        # Prepare request path
        LET fullpath = base.StringBuffer.Create()
        LET query = base.StringBuffer.Create()
        CALL fullpath.append("/v2/countries")
        IF p_id IS NOT NULL THEN
            IF query.getLength() > 0 THEN
                CALL query.append(SFMT("&id=%1", p_id))
            ELSE
                CALL query.append(SFMT("id=%1", p_id))
            END IF
        END IF
        IF query.getLength() > 0 THEN
            CALL fullpath.append("?")
            CALL fullpath.append(query.toString())
        END IF

        # Create request and configure it
        LET req =
            com.HTTPRequest.Create(
                SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
        IF Endpoint.Binding.Version IS NOT NULL THEN
            CALL req.setVersion(Endpoint.Binding.Version)
        END IF
        IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
            CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
        END IF
        IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
            CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
        END IF
        IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
            CALL req.setHeader(
                "Content-Encoding", Endpoint.Binding.CompressRequest)
        END IF

        # Perform request
        CALL req.setMethod("GET")
        CALL req.setHeader("Accept", "text/plain")
        CALL req.DoRequest()

        # Retrieve response
        LET resp = req.getResponse()
        # Process response
        INITIALIZE resp_body TO NULL
        LET contentType = resp.getHeader("Content-Type")
        CASE resp.getStatusCode()

            WHEN 200 #Success
                IF contentType MATCHES "*text/plain*" THEN
                    # Parse TEXT response
                    LET resp_body = resp.getTextResponse()
                    RETURN C_SUCCESS, resp_body
                END IF
                RETURN -1, resp_body

            WHEN 404 #Not Found
                RETURN C_NOT_FOUND, resp_body

            WHEN 500 #Internal Server Error
                RETURN C_INTERNAL_SERVER_ERROR, resp_body

            OTHERWISE
                RETURN resp.getStatusCode(), resp_body
        END CASE
    CATCH
        RETURN -1, resp_body
    END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /v1/categories
#
# VERB: GET
# DESCRIPTION :Fetches the categories resource with the optional filter value(s) applied.
#
PUBLIC FUNCTION getCategoryRecords(
    p_id STRING)
    RETURNS(INTEGER, getCategoryRecordsResponseBodyType)
    DEFINE fullpath base.StringBuffer
    DEFINE query base.StringBuffer
    DEFINE contentType STRING
    DEFINE req com.HTTPRequest
    DEFINE resp com.HTTPResponse
    DEFINE xml_resp_body
        DYNAMIC ARRAY ATTRIBUTE(XMLName = 'categories') OF
        RECORD ATTRIBUTE(XMLName = 'category')
        catid STRING,
        catorder INTEGER,
        catname STRING,
        catdesc STRING,
        catpic STRING
    END RECORD
    DEFINE resp_body getCategoryRecordsResponseBodyType
    DEFINE xml_body xml.DomDocument
    DEFINE xml_node xml.DomNode
    DEFINE json_body STRING

    TRY

        # Prepare request path
        LET fullpath = base.StringBuffer.Create()
        LET query = base.StringBuffer.Create()
        CALL fullpath.append("/v1/categories")
        IF p_id IS NOT NULL THEN
            IF query.getLength() > 0 THEN
                CALL query.append(SFMT("&id=%1", p_id))
            ELSE
                CALL query.append(SFMT("id=%1", p_id))
            END IF
        END IF
        IF query.getLength() > 0 THEN
            CALL fullpath.append("?")
            CALL fullpath.append(query.toString())
        END IF

        # Create request and configure it
        LET req =
            com.HTTPRequest.Create(
                SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
        IF Endpoint.Binding.Version IS NOT NULL THEN
            CALL req.setVersion(Endpoint.Binding.Version)
        END IF
        IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
            CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
        END IF
        IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
            CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
        END IF
        IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
            CALL req.setHeader(
                "Content-Encoding", Endpoint.Binding.CompressRequest)
        END IF

        # Perform request
        CALL req.setMethod("GET")
        CALL req.setHeader("Accept", "application/json, application/xml")
        CALL req.DoRequest()

        # Retrieve response
        LET resp = req.getResponse()
        # Process response
        INITIALIZE resp_body TO NULL
        LET contentType = resp.getHeader("Content-Type")
        CASE resp.getStatusCode()

            WHEN 200 #Success
                IF contentType MATCHES "*application/json*" THEN
                    # Parse JSON response
                    LET json_body = resp.getTextResponse()
                    CALL util.JSON.parse(json_body, resp_body)
                    RETURN C_SUCCESS, resp_body
                END IF
                IF contentType MATCHES "*application/xml*" THEN
                    # Parse XML response
                    LET xml_body = resp.getXmlResponse()
                    LET xml_node = xml_body.getDocumentElement()
                    CALL xml.serializer.DomToVariable(xml_node, xml_resp_body)
                    LET resp_body = xml_resp_body
                    RETURN C_SUCCESS, resp_body
                END IF
                RETURN -1, resp_body

            WHEN 404 #Not Found
                RETURN C_NOT_FOUND, resp_body

            WHEN 500 #Internal Server Error
                RETURN C_INTERNAL_SERVER_ERROR, resp_body

            OTHERWISE
                RETURN resp.getStatusCode(), resp_body
        END CASE
    CATCH
        RETURN -1, resp_body
    END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /v1/countries/{resourceId}
#
# VERB: GET
# DESCRIPTION :Fetches a specific element of the countries resource.
#
PUBLIC FUNCTION getCountryById(
    p_resourceId STRING)
    RETURNS(INTEGER, getCountryByIdResponseBodyType)
    DEFINE fullpath base.StringBuffer
    DEFINE contentType STRING
    DEFINE req com.HTTPRequest
    DEFINE resp com.HTTPResponse
    DEFINE resp_body getCountryByIdResponseBodyType
    DEFINE json_body STRING

    TRY

        # Prepare request path
        LET fullpath = base.StringBuffer.Create()
        CALL fullpath.append("/v1/countries/{resourceId}")
        CALL fullpath.replace("{resourceId}", p_resourceId, 1)

        # Create request and configure it
        LET req =
            com.HTTPRequest.Create(
                SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
        IF Endpoint.Binding.Version IS NOT NULL THEN
            CALL req.setVersion(Endpoint.Binding.Version)
        END IF
        IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
            CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
        END IF
        IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
            CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
        END IF
        IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
            CALL req.setHeader(
                "Content-Encoding", Endpoint.Binding.CompressRequest)
        END IF

        # Perform request
        CALL req.setMethod("GET")
        CALL req.setHeader("Accept", "application/json")
        CALL req.DoRequest()

        # Retrieve response
        LET resp = req.getResponse()
        # Process response
        INITIALIZE resp_body TO NULL
        LET contentType = resp.getHeader("Content-Type")
        CASE resp.getStatusCode()

            WHEN 200 #Success
                IF contentType MATCHES "*application/json*" THEN
                    # Parse JSON response
                    LET json_body = resp.getTextResponse()
                    CALL util.JSON.parse(json_body, resp_body)
                    RETURN C_SUCCESS, resp_body.*
                END IF
                RETURN -1, resp_body.*

            WHEN 400 #Bad Request
                RETURN C_BAD_REQUEST, resp_body.*

            WHEN 500 #Internal Server Error
                RETURN C_INTERNAL_SERVER_ERROR, resp_body.*

            OTHERWISE
                RETURN resp.getStatusCode(), resp_body.*
        END CASE
    CATCH
        RETURN -1, resp_body.*
    END TRY
END FUNCTION
#
# VERB: PUT
# DESCRIPTION :Updates an element of the countries resource.
#
PUBLIC FUNCTION updateCountryById(
    p_resourceId STRING, p_body updateCountryByIdRequestBodyType)
    RETURNS(INTEGER)
    DEFINE fullpath base.StringBuffer
    DEFINE contentType STRING
    DEFINE req com.HTTPRequest
    DEFINE resp com.HTTPResponse
    DEFINE json_body STRING

    TRY

        # Prepare request path
        LET fullpath = base.StringBuffer.Create()
        CALL fullpath.append("/v1/countries/{resourceId}")
        CALL fullpath.replace("{resourceId}", p_resourceId, 1)

        # Create request and configure it
        LET req =
            com.HTTPRequest.Create(
                SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
        IF Endpoint.Binding.Version IS NOT NULL THEN
            CALL req.setVersion(Endpoint.Binding.Version)
        END IF
        IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
            CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
        END IF
        IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
            CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
        END IF
        IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
            CALL req.setHeader(
                "Content-Encoding", Endpoint.Binding.CompressRequest)
        END IF

        # Perform request
        CALL req.setMethod("PUT")
        # Perform JSON request
        CALL req.setHeader("Content-Type", "application/json")
        LET json_body = util.JSON.stringify(p_body)
        CALL req.DoTextRequest(json_body)

        # Retrieve response
        LET resp = req.getResponse()
        # Process response
        LET contentType = resp.getHeader("Content-Type")
        CASE resp.getStatusCode()

            WHEN 204 #No Content
                RETURN C_SUCCESS

            WHEN 404 #Not Found
                RETURN C_NOT_FOUND

            WHEN 500 #Internal Server Error
                RETURN C_INTERNAL_SERVER_ERROR

            OTHERWISE
                RETURN resp.getStatusCode()
        END CASE
    CATCH
        RETURN -1
    END TRY
END FUNCTION
#
# VERB: DELETE
# DESCRIPTION :Deletes an element from the countries resource.
#
PUBLIC FUNCTION deleteCountryById(p_resourceId STRING) RETURNS(INTEGER)
    DEFINE fullpath base.StringBuffer
    DEFINE contentType STRING
    DEFINE req com.HTTPRequest
    DEFINE resp com.HTTPResponse

    TRY

        # Prepare request path
        LET fullpath = base.StringBuffer.Create()
        CALL fullpath.append("/v1/countries/{resourceId}")
        CALL fullpath.replace("{resourceId}", p_resourceId, 1)

        # Create request and configure it
        LET req =
            com.HTTPRequest.Create(
                SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
        IF Endpoint.Binding.Version IS NOT NULL THEN
            CALL req.setVersion(Endpoint.Binding.Version)
        END IF
        IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
            CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
        END IF
        IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
            CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
        END IF
        IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
            CALL req.setHeader(
                "Content-Encoding", Endpoint.Binding.CompressRequest)
        END IF

        # Perform request
        CALL req.setMethod("DELETE")
        CALL req.DoRequest()

        # Retrieve response
        LET resp = req.getResponse()
        # Process response
        LET contentType = resp.getHeader("Content-Type")
        CASE resp.getStatusCode()

            WHEN 204 #No Content
                RETURN C_SUCCESS

            WHEN 404 #Not Found
                RETURN C_NOT_FOUND

            WHEN 500 #Internal Server Error
                RETURN C_INTERNAL_SERVER_ERROR

            OTHERWISE
                RETURN resp.getStatusCode()
        END CASE
    CATCH
        RETURN -1
    END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /v1/categories/{resourceId}
#
# VERB: GET
# DESCRIPTION :Fetches a specific element of the categories resource.
#
PUBLIC FUNCTION getCategoryById(
    p_resourceId STRING)
    RETURNS(INTEGER, getCategoryByIdResponseBodyType)
    DEFINE fullpath base.StringBuffer
    DEFINE contentType STRING
    DEFINE req com.HTTPRequest
    DEFINE resp com.HTTPResponse
    DEFINE resp_body getCategoryByIdResponseBodyType
    DEFINE json_body STRING

    TRY

        # Prepare request path
        LET fullpath = base.StringBuffer.Create()
        CALL fullpath.append("/v1/categories/{resourceId}")
        CALL fullpath.replace("{resourceId}", p_resourceId, 1)

        # Create request and configure it
        LET req =
            com.HTTPRequest.Create(
                SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
        IF Endpoint.Binding.Version IS NOT NULL THEN
            CALL req.setVersion(Endpoint.Binding.Version)
        END IF
        IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
            CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
        END IF
        IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
            CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
        END IF
        IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
            CALL req.setHeader(
                "Content-Encoding", Endpoint.Binding.CompressRequest)
        END IF

        # Perform request
        CALL req.setMethod("GET")
        CALL req.setHeader("Accept", "application/json")
        CALL req.DoRequest()

        # Retrieve response
        LET resp = req.getResponse()
        # Process response
        INITIALIZE resp_body TO NULL
        LET contentType = resp.getHeader("Content-Type")
        CASE resp.getStatusCode()

            WHEN 200 #Success
                IF contentType MATCHES "*application/json*" THEN
                    # Parse JSON response
                    LET json_body = resp.getTextResponse()
                    CALL util.JSON.parse(json_body, resp_body)
                    RETURN C_SUCCESS, resp_body.*
                END IF
                RETURN -1, resp_body.*

            WHEN 404 #Not Found
                RETURN C_NOT_FOUND, resp_body.*

            WHEN 500 #Internal Server Error
                RETURN C_INTERNAL_SERVER_ERROR, resp_body.*

            OTHERWISE
                RETURN resp.getStatusCode(), resp_body.*
        END CASE
    CATCH
        RETURN -1, resp_body.*
    END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /v1/suppliers/{resourceId}
#
# VERB: GET
# DESCRIPTION :Fetches a specific element of the suppliers resource.
#
PUBLIC FUNCTION getSupplierById(
    p_resourceId STRING)
    RETURNS(INTEGER, getSupplierByIdResponseBodyType)
    DEFINE fullpath base.StringBuffer
    DEFINE contentType STRING
    DEFINE req com.HTTPRequest
    DEFINE resp com.HTTPResponse
    DEFINE resp_body getSupplierByIdResponseBodyType
    DEFINE json_body STRING

    TRY

        # Prepare request path
        LET fullpath = base.StringBuffer.Create()
        CALL fullpath.append("/v1/suppliers/{resourceId}")
        CALL fullpath.replace("{resourceId}", p_resourceId, 1)

        # Create request and configure it
        LET req =
            com.HTTPRequest.Create(
                SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
        IF Endpoint.Binding.Version IS NOT NULL THEN
            CALL req.setVersion(Endpoint.Binding.Version)
        END IF
        IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
            CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
        END IF
        IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
            CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
        END IF
        IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
            CALL req.setHeader(
                "Content-Encoding", Endpoint.Binding.CompressRequest)
        END IF

        # Perform request
        CALL req.setMethod("GET")
        CALL req.setHeader("Accept", "application/json")
        CALL req.DoRequest()

        # Retrieve response
        LET resp = req.getResponse()
        # Process response
        INITIALIZE resp_body TO NULL
        LET contentType = resp.getHeader("Content-Type")
        CASE resp.getStatusCode()

            WHEN 200 #Success
                IF contentType MATCHES "*application/json*" THEN
                    # Parse JSON response
                    LET json_body = resp.getTextResponse()
                    CALL util.JSON.parse(json_body, resp_body)
                    RETURN C_SUCCESS, resp_body.*
                END IF
                RETURN -1, resp_body.*

            WHEN 404 #Not Found
                RETURN C_NOT_FOUND, resp_body.*

            WHEN 500 #Internal Server Error
                RETURN C_INTERNAL_SERVER_ERROR, resp_body.*

            OTHERWISE
                RETURN resp.getStatusCode(), resp_body.*
        END CASE
    CATCH
        RETURN -1, resp_body.*
    END TRY
END FUNCTION
################################################################################
