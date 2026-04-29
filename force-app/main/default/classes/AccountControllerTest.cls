@isTest
public class AccountControllerTest{

    static testMethod void testAccount(){
        Test.startTest();
        AccountController temp = new AccountController();
        Account a = new Account(Name = '测试',Phone = '19930523190');
        insert a;
        List<Account> result = AccountController.SearchAccountByName('测试','10','1');
        result = AccountController.SearchAccountByName(null,'10','1');

        System.debug(result);
        Integer total = AccountController.SearchTotal();
        List<Account> Dels = new List<Account>();
        Dels = AccountController.getAccountList();
        Dels = AccountController.SearchAccountList();
        Dels.add(a);
        AccountController.DelAccList(Dels);
        Test.stopTest();


        
    }


}