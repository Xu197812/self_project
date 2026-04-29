trigger payName on payRecord__c(before insert) {
    for(payRecord__c temp : trigger.new){
    	temp.Name = temp.userName__c + temp.year__c + temp.month__c + temp.payCount__c;
    }
}