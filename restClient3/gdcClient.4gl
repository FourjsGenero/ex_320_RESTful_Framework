import fgl ws_restCliLib320

function main()
    define testId string = "FJS"
    define countries ws_restCliLib320.getCountryRecordsResponseBodyType
    define insertRequest ws_restCliLib320.insertCountryRequestBodyType = (code: "FJS", codedesc: "FourJs Development Tools")
    define insertResponse ws_restCliLib320.insertCountryResponseBodyType
    define getByIdResponse ws_restCliLib320.getCountryByIdResponseBodyType
    define updateRequest ws_restCliLib320.updateCountryByIdRequestBodyType = (code: "FJS", codedesc: "### Delete Me ###")

    define i, restStatus integer
    define this string

    # Resource list
    call ws_restCliLib320.getCountryRecords(null) returning restStatus, countries
    case restStatus
        when ws_restCliLib320.C_SUCCESS
            display "Countries resource: "
            for i = 1 to countries.getLength()
                let this = countries[i].*
                display sfmt("\tCountry[%1]: %2", i, this)
            end for
        when ws_restCliLib320.C_INTERNAL_SERVER_ERROR
            display "Result ", "HTTP:500 Internal error"
        when ws_restCliLib320.C_NOT_FOUND
            display "Result ", "HTTP:400 Not found"
        otherwise
            display sfmt("Unexpected error: %1", restStatus)
    end case
    display "\n"

    # Create
    call ws_restCliLib320.insertCountry(insertRequest.*) returning restStatus, insertResponse.*
    display sfmt("Insert status: %1", restStatus)
    call ws_restCliLib320.getCountryById(testId) returning restStatus, getByIdResponse.*
    display sfmt("Get new resource status: %1, %2-%3\n", restStatus, getByIdResponse.code, getByIdResponse.codedesc)

    # Update
    call ws_restCliLib320.updateCountryById(testId, updateRequest.*) returning restStatus
    display sfmt("Update status: %1", restStatus)
    call ws_restCliLib320.getCountryById(testId) returning restStatus, getByIdResponse.*
    display sfmt("Get updated resource status: %1, %2-%3\n", restStatus, getByIdResponse.code, getByIdResponse.codedesc)

    # Delete
    call ws_restCliLib320.deleteCountryById(testId) returning restStatus
    display sfmt("Delete status: %1", restStatus)
    call ws_restCliLib320.getCountryById(testId) returning restStatus, getByIdResponse.*
    display sfmt("Get deleted resource status: %1, %2-%3\n", restStatus, nvl(getByIdResponse.code, "NULL"), nvl(getByIdResponse.codedesc, "EMPTY"))

end function
