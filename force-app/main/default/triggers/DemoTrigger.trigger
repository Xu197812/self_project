Trigger DemoTrigger on payDetail__c(after insert, after update, after delete, after undelete) {
    List<payDetail__c> mingxis= new List<payDetail__c>();
    for (payDetail__c i : trigger.new) {
        mingxis = [select payRecord__c,payCount__c from payDetail__c];
     
    }
    for (payDetail__c i : trigger.new) {
    Double count = 0;
        for (payDetail__c j : mingxis){
    
            if(j.payRecord__c==i.payRecord__c){
                count +=j.payCount__c;
            }
        }
        String id = i.payRecord__c;
     
        List<payRecord__c> temp = [select payCount__c from payRecord__c where Id = :id];
        temp[0].payCount__c = count;
     
        update temp;
    }
}