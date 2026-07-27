public with sharing class AccountController {
    public AccountController() {

    }

    @AuraEnabled
    public static List<Account> SearchAccountByName(String accName, String yedaxiao, String dijiye) {
        Integer pageSize = Integer.valueOf(yedaxiao);
        Integer pageNo = Integer.valueOf(dijiye);
        String sql = 'select Name,Id,Phone,Industry,Type from Account';
        String wheresql = ' where Name like ';
        String likevalue = '\'%'+accName+'%\'';
        if(accName!=null){
            sql = sql+wheresql+likevalue;
        }else{
            sql = sql;
        }
        List<Account> temp = Database.query(sql);
        Integer first = (pageNo * pageSize)-pageSize;
        Integer daxiao = pageSize;
        if((pageNo-1)*pageSize+pageSize>temp.size()){
            daxiao = temp.size()-(pageNo-1)*pageSize;
        }
        List<Account> result = new List<Account>();
        for(Integer i = first;i<first+daxiao;i++ ){
            result.add(temp[i]);
        }
        return result;
    }


    @AuraEnabled
    public static Integer SearchTotal(){
        return Integer.valueOf([select count(Id) from Account][0].get('expr0'));
    }


    @AuraEnabled
    public static void DelAccList(List<Account> delList){
        List<String> Ids = new List<String>();
        for(Account i : delList){
            Ids.add(i.Id);
        }
        // List<Account> result = Database.query(Delete from Account where Id in :Ids);
        // System.debug(Ids);
        Database.delete(Ids);
        // return Database.delete();
    }

    @AuraEnabled
    public static List<Account> SearchAccountList(){
        return [select Name,Id,Phone,Industry,Type from Account];
    }



    @AuraEnabled
    public static List<Account> getAccountList(){
        return [select Name,Id,Phone,Industry,Type from Account];
    }

    public static List<Account> getAllActiveAccounts() {
        return [SELECT Id, Name, Active__c From Account WHERE Active__c = 'Yes' WITH SECURITY_ENFORCED];
    }
}