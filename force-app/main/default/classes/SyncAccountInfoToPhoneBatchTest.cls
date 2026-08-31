@isTest
private class SyncAccountInfoToPhoneBatchTest {
    @TestSetup
    static void setupData() {
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accList.add(new Account(
                Name = 'Test Account ' + i,
                Phone = '138000000' + i
            ));
        }
        insert accList;
    }

    @isTest
    static void testBatchExecution() {
        List<Account> accountsBefore = [
            SELECT Id, Name, Phone
            FROM Account
            WHERE Phone != NULL
        ];
        System.assertEquals(5, accountsBefore.size(), 'Should have 5 accounts with phone numbers');

        SyncAccountInfoToPhoneBatch batch = new SyncAccountInfoToPhoneBatch();

        Test.startTest();
        Id batchJobId = Database.executeBatch(batch, 200);
        Test.stopTest();

        System.assertNotEquals(null, batchJobId, 'Batch job should be submitted');

        List<Account> accountsAfter = [
            SELECT Id, Name, Phone
            FROM Account
            WHERE Phone != NULL
        ];
        System.assertEquals(5, accountsAfter.size(), 'Account records should remain intact after batch execution');

        String html = SyncAccountInfoToPhoneBatch.generateEmailBody(accountsAfter);
        System.assert(html.contains('<table'), 'HTML table should be generated');
        System.assert(html.contains('姓名'), 'Email table should contain Name column');
        System.assert(html.contains('电话'), 'Email table should contain Phone column');
        System.assert(html.contains(accountsAfter[0].Name), 'Email body should contain the account name');
    }
}
