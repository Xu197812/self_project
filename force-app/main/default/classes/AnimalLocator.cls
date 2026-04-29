public class AnimalLocator {
    public static String getAnimalNameById(Integer ID) {
    	HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + ID);
		HttpResponse response = new Http().send(request);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String aname = (String) results.get('name');
        
       	return aname;
    }
}