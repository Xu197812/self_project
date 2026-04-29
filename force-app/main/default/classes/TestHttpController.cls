public with sharing class TestHttpController {
    //请求salesforce token的接口。需要用户的client_id，和client_secret
	public static void test(){
		
		HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setEndpoint('https://test.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9qG3qyJ7I8u3Ow0gStJKPMRZNBWYTTpEBHo8dbBD9K1NWcBfcQHS1ZMGgUGNC_UZbvAQ3K4H3BSSCDeet&' 
        	+ 'client_secret=7C7D0EC8F01E4B263462C5B7E1499F1335297D6AF24A7F7BDBEBAAC6AC173B3E&username=jinguo.yang@cummins.com.ccgwo&password=!Cummins202206');
        // req.setBody(JSON.serialize(pBody));
        Http http = new Http();
        HttpResponse response = http.send(req);
        System.debug(LoggingLevel.INFO, '*** response: ' + response.getBody());
        Map<String, Object> objMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        System.debug(LoggingLevel.INFO, '*** access_token: ' + objMap.get('access_token'));
        String s = cbuTest(objMap);
	}
    //请求salesforce的接口。
    public static String cbuTest(Map<String, Object> objMap){
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setEndpoint('https://cummins-cn--ccgwo.sandbox.my.salesforce.com/services/apexrest/rest');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Content-Length', '0');
        req.setHeader('Authorization', 'OAuth ' + '00D8M0000008gJ0!AR4AQPeJOvRxdMMq6fMaKS0FtLlf_XRo.Y0t4OHrlavCrtml_cU7.BNndYMLkwkLzeJsSUfzCgEP29eXZrpLcRiWpIjLpbZa');
        Http http = new Http();
        HttpResponse response = http.send(req);
        System.debug(LoggingLevel.INFO, '*** response: ' + response.getBody());
        return '123';
    }

}