@isTest
global class AnimalLocatorTest{

    global class CalloutServiceMock implements HttpCalloutMock{
        global HttpResponse respond(HttpRequest request){
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"name":"cat","code":200}');
            res.setStatusCode(200);
            return res;
        }
    }
    global class CalloutServiceMock2 implements HttpCalloutMock{
        global HttpResponse respond(HttpRequest request){
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"name":"cat","code":200}');
            res.setStatusCode(100);
            return res;
        }
    }

    @IsTest
    static void testBehavior() {
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
            String temp = AnimalLocator.getAnimalNameById(1);

            Test.setMock(HttpCalloutMock.class, new CalloutServiceMock2());
            String temp2 = AnimalLocator.getAnimalNameById(2);
        Test.stopTest();
    }
}