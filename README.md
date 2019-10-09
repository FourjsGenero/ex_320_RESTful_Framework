# ex_320_RESTful_framework
Example of REST web services created with the Genero v3.20.xx RESTful Framework.

This demo implements a REST web service that provides an example of services created with the Genero v3.20.xx RESTful Framework.

Using the Genero sample officestore database, the demo implements the the RESTful Framework WS* attributes on domain functions to provide C.R.U.D. functioinality.  It also demonstrates an example of service versioning using the resource URI("v1", "v2").

Requires: Genero BDL with Web Services(FGLWS) v3.20.06 or greater to compile and execute.

The service can be tested with a variety of testing clients(Postman, Browser RESTlet plugin, curl)

Example curl commands

    curl -X GET -i http://localhost:8090/ws/r/officestore/v1/countries
    curl -X GET -i http://localhost:8090/ws/r/officestore/v1/categories
    curl -X GET -i http://localhost:8090/ws/r/officestore/v1/suppliers
    curl -X GET -i http://localhost:8090/ws/r/officestore/v2/countries


C.R.U.D. Testing sequence

  Create:
    
    curl -X POST -i http://localhost:8090/ws/r/rest/countries --data '[{"code":"FJS","codedesc":"FourJs WWDC19"}]'
    
  Read:
    
    curl -X GET -i http://localhost:8090/ws/r/rest/countries/FJS
    curl -X GET -i 'http://localhost:8090/ws/r/rest/countries?id=FJS'
    
  Update:
    
    curl -X PUT -i http://localhost:8090/ws/r/rest/countries --data '[{"code":"FJS","codedesc":"xxx Delete Me xxx"}]'
    
  Delete:
    
    curl -X DELETE -i 'http://localhost:8090/ws/r/rest/countries?id=FJS'

Example curl with GAS Deployment
    
    curl -X GET -i http://<myserver>/<gas>/ws/r/restServer2/countries
