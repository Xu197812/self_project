public class CampingController {
    public CampingController() {
        
    }
    @AuraEnabled
    public static List<Camping_Item__c> getItems() {

        List<Camping_Item__c> temp = [SELECT Id,Name,Packed__c,Price__c,Quantity__c FROM Camping_Item__c];
        System.debug(temp);

        return temp;
    }

    @AuraEnabled
    public static Camping_Item__c saveItem(Camping_Item__c item) {
        // System.debug('item');
        upsert item;
        // System.debug('item');
        return item;
    }

}