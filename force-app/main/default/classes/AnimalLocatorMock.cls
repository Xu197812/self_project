@isTest
global class AnimalLocatorMock implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest request){
        HTTPResponse res = new HTTPResponse();
        res.setBody('{"name":"cat","code":200}');
        res.setStatusCode(200);
        return res;
    }
}