################################################################################
#
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
#+ This module implements officestore class information handling
#+
#+ This code uses the 'officestore' database tables.
#+ Officestore input, query and list handling functions are defined here.
#+
#+ Only functions determined to be exposed as a resource should be made PUBLIC.
#+
import com
import util

# Application utilities
import fgl appUtility

# Application logging
import fgl logger

# HTTP definitions
import fgl http

# Using officestore demo compiled schema for this web service example
schema officestore

type countryType record
    code like country.code,
    codedesc like country.codedesc
end record

type categoryType record
    catid like category.catid,
    catorder like category.catorder,
    catname like category.catname,
    catdesc like category.catdesc attributes(XMLNillable, json_null = "null"),
    catpic like category.catpic attributes(XMLNillable, json_null = "null")
end record

type supplierType record
    suppid like supplier.suppid,
    name like supplier.name,
    sustatus like supplier.sustatus,
    addr1 like supplier.addr1 attributes(XMLNillable, json_null = "null"),
    addr2 like supplier.addr2 attributes(XMLNillable, json_null = "null"),
    city like supplier.city attributes(XMLNillable, json_null = "null"),
    state like supplier.state attributes(XMLNillable, json_null = "null"),
    zip like supplier.zip attributes(XMLNillable, json_null = "null"),
    phone like supplier.phone attributes(XMLNillable, json_null = "null")
end record

# Modular domain variables
private define mCountries dynamic array of countryType
private define mCategories dynamic array of categoryType
private define mSuppliers dynamic array of supplierType

# Response definition
public type responseType record
    code integer, # HTTP response code
    status string, # success, fail, or error
    description string, # used for fail or error message
    data string # response body or error/fail cause or exception name
end record

#
# Standard domain SQL statement CONSTANTs
#
private constant CAT_SELECTSQL = "SELECT * FROM category"
#private constant CAT_UPDATESQL = "UPDATE category SET catname = ?, catdesc = ?, catpic = ?  WHERE catid = ?"
#private constant CAT_INSERTSQL = "INSERT INTO category VALUES (?, ?, ?, ?, ?)"
#private constant CAT_DELETESQL = "DELETE FROM category WHERE catid = ?"

private constant CTRY_SELECTSQL = "SELECT * FROM country"
private constant CTRY_UPDATESQL = "UPDATE country SET codedesc = ? WHERE code = ?"
private constant CTRY_INSERTSQL = "INSERT INTO country VALUES (?, ?)"
private constant CTRY_DELETESQL = "DELETE FROM country WHERE code = ?"

private constant SUP_SELECTSQL = "SELECT * FROM supplier"
#private constant SUP_UPDATESQL = "UPDATE supplier SET ##FIELDS/VALUES##"
#private constant SUP_INSERTSQL = "INSERT INTO supplier VALUES ##VALUES##"
#private constant SUP_DELETESQL = "DELETE FROM supplier WHERE ##KEYVALUE##"

#
# REST service information record
#
public define serviceInfo record attribute(WSInfo)
    title string,
    description string,
    termOfService string,
    contact record
        name string,
        url string,
        email string
    end record,
    version string
end record = (title: "Officestore RESTful Services.", version: "3.0", contact:(email: "helpdesk-us@4js.com"))
################################################################################
#+ Method: getCategoryRecords
#+
#+ Retrieves categories from data source
#+
#+ @code CALL getCategoryRecords(var1) RETURNING ARRAY OF categoryType
#+
#+ @param var1 : STRING : query value
#+
#+ @returnType ARRAY OF categoryType
#+
public function getCategoryRecords(
    resourceId varchar(10) attributes(WSQuery, WSOptional, WSName = "id"))
    attributes(WSGet,
        WSPath = "/v1/categories",
        WSDescription = 'Fetches the categories resource with the optional filter value(s) applied.',
        #WSScope = "officestore.user",
        WSThrows = "404:Not Found,500:Internal Server Error")
    returns(dynamic array attribute(WSName = "categories") of
        categoryType attributes(XMLName = "category", WSMedia = "application/json"))

    define
        i integer = 1,
        sqlStatement string,
        sqlWhere string = "WHERE 1=1"

    whenever any error call errorHandler

    # Clear the result set; just in case
    call initCategories()

    # Build query cursor with pass parameters
    if (resourceId is not null) then
        let sqlWhere = sfmt("%1 %2 '%3'", sqlWhere, " AND catid LIKE ", resourceId)
    end if

    let sqlStatement = sfmt("%1 %2", CAT_SELECTSQL, sqlWhere)

    try
        # Create fetch cursor
        prepare fetchCategories from sqlStatement
        declare categoriesCurs cursor for fetchCategories
        open categoriesCurs

        # Get the resource records
        foreach categoriesCurs into mCategories[i].*
            let i = i + 1
        end foreach

        # Remove the empty element implied by reference in FOREACH loop
        call mCategories.deleteElement(mCategories.getLength())

        # Check for empty set
        if (not mCategories.getLength()) then
            call com.WebServiceEngine.SetRestError(C_HTTP_NOTFOUND, null)
        end if
    catch
        call logger.logEvent(
            logger.C_LOGSQLERROR,
            sfmt("%1:%2", __FILE__, __LINE__),
            sfmt("SQL code: %1:%2:%3", SQLCA.sqlcode, SQLCA.sqlerrd[2], SQLCA.sqlerrm),
            sfmt("SQL statement: %1", sqlStatement))
        call com.WebServiceEngine.SetRestError(C_HTTP_INTERNALERROR, null)
    end try

    return mCategories
end function

################################################################################
#+ Method: getCategoryById
#+
#+ Implements a call to getCategoryRecords() using the given {resourceId} parameter
#+
#+ @code CALL getCategoryById(resourceId) RETURNING categoryType
#+
#+ @param resourceId : STRING : valid resource id (foo, 1, ABC, etc ...)
#+
#+ @returnType RECORD of categoryType
#+
public function getCategoryById(
    resourceId string attributes(WSParam))
    attributes(WSGet,
        WSPath = "/v1/categories/{resourceId}",
        WSDescription = "Fetches a specific element of the categories resource.",
        #WSScope = "officestore.user",
        WSThrows = "404:Not Found,500:Internal Server Error")
    returns(categoryType attributes(XMLName = "category", WSMedia = "application/json"))

    define theseRecords dynamic array of categoryType #Should only be one element...theoretically

    # It can be assumed that only one row is returned; even if empty
    if (resourceId is not null) then
        call getCategoryRecords(resourceId) returning theseRecords
    else
        call com.WebServiceEngine.SetRestError(C_HTTP_NOTFOUND, null)
    end if

    # Return the first record of the array: Should only be one element...theoretically
    return theseRecords[1].*
end function

################################################################################
#+ Method: initCategories()
#+
#+ Initializes the resource array
#+
#+ @code initCategories()
#+
#+ @param NONE
#+
#+ @returnType NONE
#+ @return NONE
private function initCategories() returns()
    call mCategories.clear()
end function

################################################################################
#+ Method: getCountryRecords
#+
#+ Retrieves countries from data source
#+
#+ @code CALL getCountryRecords(var1) RETURNING ARRAY OF countryType
#+ @param var1 : STRING : query value
#+
#+ @returnType ARRAY OF countryType
#+
public function getCountryRecords(
    resourceId varchar(10) attributes(WSQuery, WSOptional, WSName = "id"))
    attributes(WSGet,
        WSPath = "/v1/countries",
        WSDescription = 'Fetches the countries resource with the optional filter value(s) applied.',
        #WSScope = "officestore.user",
        WSRetCode = "200:Success",
        WSThrows = "404:Not Found,500:Internal Server Error")
    returns(dynamic array attribute(WSName = "countries") of
        countryType attributes(XMLName = "country", WSMedia = "application/json"))

    define
        i integer = 1,
        sqlStatement string,
        sqlWhere string = "WHERE 1=1"

    whenever any error call errorHandler # TODO: perhaps rename with resource name

    call initCountries()

    # Build query cursor with pass parameters
    if (resourceId is not null) then
        let sqlWhere = sfmt("%1 %2 '%3'", sqlWhere, " AND code LIKE ", resourceId)
    end if

    let sqlStatement = sfmt("%1 %2", CTRY_SELECTSQL, sqlWhere)

    try
        # Create fetch cursor
        prepare fetchCountry from sqlStatement
        declare countryCurs cursor for fetchCountry
        open countryCurs

        # Get the resource records
        foreach countryCurs into mCountries[i].*
            let i = i + 1
        end foreach

        # Remove the empty element implied by reference in FOREACH loop
        call mCountries.deleteElement(mCountries.getLength())

    catch
        call logger.logEvent(
            logger.C_LOGSQLERROR,
            sfmt("countries:%1", __LINE__),
            sfmt("SQL code: %1", SQLCA.sqlcode),
            sfmt("SQL statement: %1", sqlStatement))
        call com.WebServiceEngine.SetRestError(C_HTTP_INTERNALERROR, null)
    end try

    return mCountries
end function

################################################################################
#+ Method: getCountryRecordsV2
#+
#+ Retrieves countries from data source
#+
#+ @code CALL getCountryRecords(var1) RETURNING ARRAY OF countryType
#+ @param var1 : STRING : query value
#+
#+ @returnType ARRAY OF countryType
#+
public function getCountryRecordsV2(
    resourceId varchar(10) attributes(WSQuery, WSOptional, WSName = "id"))
    attributes(WSGet,
        WSPath = "/v2/countries",
        WSDescription = 'Fetches the countries resource with the optional filter value(s) applied.',
        #WSScope = "officestore.user",
        WSThrows = "404:Not Found,500:Internal Server Error")
    returns string

    define
        i integer = 1,
        sqlStatement string,
        sqlWhere string = "WHERE 1=1",
        wrappedResponse responseType

    whenever any error call errorHandler

    call initCountries()

    # Build query cursor with pass parameters
    if (resourceId is not null) then
        let sqlWhere = sfmt("%1 %2 '%3'", sqlWhere, " AND code LIKE ", resourceId)
    end if

    let sqlStatement = sfmt("%1 %2", CTRY_SELECTSQL, sqlWhere)

    try
        # Create fetch cursor
        prepare fetchCountryV2 from sqlStatement
        declare countryCursV2 cursor for fetchCountryV2
        open countryCursV2

        # Get the resource records
        # TODO: Perhaps limit to a few necessary fields and a resource URL
        foreach countryCursV2 into mCountries[i].*
            let i = i + 1
        end foreach

        # Remove the empty element implied by reference in FOREACH loop
        call mCountries.deleteElement(mCountries.getLength())

        # Check for empty set
        if (not mCountries.getLength()) then
            let wrappedResponse.code = C_HTTP_OK_NOCONTENT
            call com.WebServiceEngine.SetRestError(C_HTTP_OK_NOCONTENT, null)
        else
            let wrappedResponse.code = C_HTTP_OK
        end if

        let wrappedResponse.status = "SUCCESS"
        let wrappedResponse.data = util.JSON.stringify(mCountries)

    catch
        call logger.logEvent(
            logger.C_LOGSQLERROR,
            sfmt("countries:%1", __LINE__),
            sfmt("SQL code: %1", SQLCA.sqlcode),
            sfmt("SQL statement: %1", sqlStatement))
        call com.WebServiceEngine.SetRestError(C_HTTP_INTERNALERROR, null)
        let wrappedResponse.code = C_HTTP_INTERNALERROR
        let wrappedResponse.status = "FAILURE"
        let wrappedResponse.data = util.JSON.stringify(mCountries)
    end try

    close countryCursV2
    free countryCursV2

    return util.JSON.stringify(wrappedResponse)
end function

################################################################################
#+ Method: getCountryById
#+
#+ Implements a call to getCountryRecords() using the given {resourceId} parameter
#+
#+ @code CALL getCountryById(resourceId) RETURNING countryType
#+
#+ @param resourceId : STRING : valid resource id (foo, 1, ABC, etc ...)
#+
#+ @returnType RECORD of countryType
#+
public function getCountryById(
    resourceId string attributes(WSParam))
    attributes(WSGet,
        WSPath = "/v1/countries/{resourceId}",
        WSDescription = "Fetches a specific element of the countries resource.",
        #WSScope = "dev.readonly, user.readonly",
        WSThrows = "400:Bad Request,500:Internal Server Error")
    returns(countryType attributes(XMLName = "country", WSMedia = "application/json"))

    define theseRecords dynamic array of countryType #Should only be one element...theoretically

    # It can be assumed that only one row is returned; even if empty
    if (resourceId is not null) then
        call getCountryRecords(resourceId) returning theseRecords
    else
        call com.WebServiceEngine.SetRestError(C_HTTP_BADREQUEST, null)
    end if

    # Return the first record of the array: Should only be one element...theoretically
    return theseRecords[1].*
end function

################################################################################
#+ Method: insertCountry
#+
#+ Creates countries from data source
#+
#+ @code CALL insertCountry(newRecord)
#+
#+ @param newRecord : countryType : A record of values used to create a new resource
#+
#+ @countryType NONE
#+

public function insertCountry(
    newRecord countryType)
    attributes(WSPost,
        WSMedia = "application/json",
        WSPath = "/v1/countries",
        WSDescription = "Post test",
        WSRetCode = "201:Created",
        #WSScope = "dev.readonly, user.readonly",
        WSThrows = "400:Bad Request,500:Internal Server Error")
    returns(countryType attributes(XMLName = "country", WSMedia = "application/json"))

    whenever any error continue

    try
        prepare countryIns from CTRY_INSERTSQL
        execute countryIns using newRecord.*
        free countryIns
    catch
        call logger.logEvent(
            logger.C_LOGSQLERROR,
            sfmt("%1:%2", __FILE__, __LINE__),
            sfmt("SQL code: %1", SQLCA.sqlcode),
            sfmt("SQL statement: %1", CTRY_INSERTSQL))
        call com.WebServiceEngine.SetRestError(C_HTTP_NOTFOUND, null)
    end try

    whenever any error call errorHandler

    return newRecord.*
end function

################################################################################
#+ Method: updateCountryById
#+
#+ Updates countries for specific ID in data source
#+
#+ @code
#+ CALL updateCountryById(id, updateRecord)
#+
#+ @param resourceId : STRING : id of the categories being updated
#+ @param updateRecord : countryType : A record of values used to update a resource
#+
#+ @returnType NONE
#+
public function updateCountryById(
    resourceId string attributes(WSParam), updateRecord countryType attributes(WSMedia = "application/json"))
    attributes(WSPut,
        WSPath = "/v1/countries/{resourceId}",
        WSDescription = "Updates an element of the countries resource.",
        #WSScope = "officestore.supervisor",
        WSRetCode = "204:No Content",
        WSThrows = "404:Not Found,500:Internal Server Error")
    returns()

    try
        prepare countriesUpdt from CTRY_UPDATESQL
        execute countriesUpdt using updateRecord.codedesc, resourceId
        free countriesUpdt
    catch
        call logger.logEvent(
            logger.C_LOGSQLERROR,
            sfmt("%1:%2", __FILE__, __LINE__),
            sfmt("SQL code: %1", SQLCA.sqlcode),
            sfmt("SQL statement: %1", CTRY_UPDATESQL))
        call com.WebServiceEngine.SetRestError(C_HTTP_INTERNALERROR, null)
    end try

    return
end function

################################################################################
#+ Method: deleteCountryById
#+
#+ Deletes categories for specific ID from data source
#+
#+ @code CALL deleteCountryById(resourceId)
#+
#+ @param resourceId : STRING : valid resource id (smith, 1, ABC, ...)
#+
#+ @returnType NONE
#+
public function deleteCountryById(
    resourceId string attributes(WSParam))
    attributes(WSDelete,
        WSPath = "/v1/countries/{resourceId}",
        WSDescription = "Deletes an element from the countries resource.",
        #WSScope = "officestore.admin",
        WSRetCode = "204:No Content",
        WSThrows = "404:Not Found,500:Internal Server Error")
    returns()

    try
        prepare countryDel from CTRY_DELETESQL
        execute countryDel using resourceId
        free countryDel
    catch
        call logger.logEvent(
            logger.C_LOGSQLERROR,
            sfmt("countries:%1", __LINE__),
            sfmt("SQL code: %1", SQLCA.sqlcode),
            sfmt("SQL statement: %1", CTRY_DELETESQL))
        call com.WebServiceEngine.SetRestError(C_HTTP_INTERNALERROR, null)
    end try

    return
end function

################################################################################
#+ Method: initCountries()
#+
#+ Initializes the resource array
#+
#+ @code CALL initCountries()
#+
#+ @param NONE
#+
#+ @returnType NONE
#+ @return NONE
private function initCountries() returns()
    call mCountries.clear()
end function

################################################################################
#+ Method: getSupplierRecords
#+
#+ Retrieves suppliers from data source
#+
#+ @code CALL getSupplierRecords(var1) RETURNING ARRAY OF supplierType
#+
#+ @param var1 : STRING : query value
#+
#+ @returnType ARRAY OF supplierType
#+
public function getSupplierRecords(
    resourceId varchar(10) attributes(WSQuery, WSOptional, WSName = "id"))
    attributes(WSGet,
        WSPath = "/v1/suppliers",
        WSDescription = 'Fetches the suppliers resource with the optional filter value(s) applied.',
        #WSScope = "officestore.user",
        WSThrows = "404:Not Found,500:Internal Server Error")
    returns(dynamic array of supplierType attributes(WSMedia = "application/json"))

    define
        i integer = 1,
        sqlStatement string,
        sqlWhere string = "WHERE 1=1"

    whenever any error call errorHandler

    call initSuppliers()

    # Build query cursor with pass parameters
    if (resourceId is not null) then
        let sqlWhere = sfmt("%1 %2 '%3'", sqlWhere, " AND suppid LIKE ", resourceId)
    end if

    let sqlStatement = sfmt("%1 %2", SUP_SELECTSQL, sqlWhere)

    try
        # Create fetch cursor
        prepare fetchSuppliers from sqlStatement
        declare suppliersCurs cursor for fetchSuppliers
        open suppliersCurs

        # Get the resource records
        foreach suppliersCurs into mSuppliers[i].*
            let i = i + 1
        end foreach

        # Remove the empty element implied by reference in FOREACH loop
        call mSuppliers.deleteElement(mSuppliers.getLength())

        # Check for empty set
        if (not mSuppliers.getLength()) then
            call com.WebServiceEngine.SetRestError(C_HTTP_NOTFOUND, null)
        end if
    catch
        call logger.logEvent(
            logger.C_LOGSQLERROR,
            sfmt("suppliers:%1", __LINE__),
            sfmt("SQL code: %1", SQLCA.sqlcode),
            sfmt("SQL statement: %1", sqlStatement))
        call com.WebServiceEngine.SetRestError(C_HTTP_INTERNALERROR, null)
    end try

    return mSuppliers

end function

################################################################################
#+ Method: getSupplierById
#+
#+ Implements a call to getSupplierRecords() using the given {resourceId} parameter
#+
#+ @code CALL getSupplierById(resourceId) RETURNING supplierType
#+
#+ @param resourceId : STRING : valid resource id (foo, 1, ABC, etc ...)
#+
#+ @returnType RECORD of supplierType
#+
public function getSupplierById(
    resourceId string attributes(WSParam))
    attributes(WSGet,
        WSPath = "/v1/suppliers/{resourceId}",
        WSDescription = "Fetches a specific element of the suppliers resource.",
        #WSScope = "officestore.user",
        WSThrows = "404:Not Found,500:Internal Server Error")
    returns(supplierType attributes(WSMedia = "application/json"))

    define theseRecords dynamic array of supplierType # Should only be one element...theoretically

    # It can be assumed that only one row is returned; even if empty
    if (resourceId is not null) then
        call getSupplierRecords(resourceId) returning theseRecords
    else
        call com.WebServiceEngine.SetRestError(C_HTTP_NOTFOUND, null)
    end if

    # Return the first record of the array: Should only be one element...theoretically
    return theseRecords[1].*

end function

################################################################################
#+ Method: initSuppliers()
#+
#+ Initializes the resource array
#+
#+ @code CALL initSuppliers()
#+
#+ @param NONE
#+
#+ @returnType NONE
#+ @return NONE
private function initSuppliers() returns()
    call mSuppliers.clear()
end function

################################################################################
#+
#+ Method: errorHandler()
#+
#+ Standard error function to handle error handling
#+
private function errorHandler()
    define errorMessage string

    let errorMessage =
        "\nSTATUS                : ",
        STATUS using "<<<<&",
        "\nSQLERRMESSAGE         : ",
        sqlerrmessage,
        "\nSQLSTATE              : ",
        sqlstate using "<<<<&",
        "\nSQLERRM               : ",
        SQLCA.SQLERRM,
        "\nSQLCODE               : ",
        SQLCA.SQLCODE using "<<<<&",
        "\nSQLERRM               : ",
        SQLCA.SQLCODE using "<<<<&",
        "\nSQLERRD[2]            : ",
        SQLCA.SQLERRD[2] using "<<<<&",
        "\nSQLERRD[3]            : ",
        SQLCA.SQLERRD[3] using "<<<<&",
        "\nOFFSET TO ERROR IN SQL: ",
        SQLCA.SQLERRD[5] using "<<<<&",
        "\nROWID FOR LAST INSERT : ",
        SQLCA.SQLERRD[6] using "<<<<&"

    #Optional app debug logging
    &ifdef APP_LOGGING
        LET errorMessage = errorMessage || "\nAPPERROR              : ", applicationError
    &endif

    call com.WebServiceEngine.SetRestError(C_HTTP_INTERNALERROR, null)
    call logger.logEvent(logger.C_LOGERROR, ARG_VAL(0), sfmt("Line: %1", __LINE__), errorMessage)
    call programExit(1)

end function
