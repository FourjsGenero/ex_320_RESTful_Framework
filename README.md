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
    
    curl -X POST -H 'Content-Type: application/json' -i http://localhost:8090/ws/r/officestore/v1/countries --data '{"code":"FJS","codedesc":"FourJs Development Tools"}'
    
  Read:
    
    curl -X GET -i http://localhost:8090/ws/r/officestore/v1/countries/FJS
    curl -X GET -i http://localhost:8090/ws/r/officestore/v1/countries?id=FJS
    
  Update:
    
    curl -X PUT -H 'Content-Type: application/json' -i http://localhost:8090/ws/r/officestore/v1/countries/FJS --data '{"code":"FJS","codedesc":"####Delete Me####"}'
    
  Delete:
    
    curl -X DELETE -H 'Content-Type;' -i http://localhost:8090/ws/r/officestore/v1/countries/FJS

Example curl with GAS Deployment
    
    http://dogbert/genero/ws/r/restServer3/officestore/v1/countries/FJS
    
    
Additionally, you can:

    1) Retrieve the REST OpenAPI documentation can be retrieved using:
        
    curl -X GET -i http://localhost:8090/ws/r/officestore?openapi.json
    
    2) Generate client API interface code from the saved OpenAPI using:
    
    fglrestful -o ws_client officestore.json
    
A demo client application, restClient3, is provided to illustrate how to use the generated client API code.  Simple start the server in standalone mode(w/o GAS); then, execute the restClient3 application.

