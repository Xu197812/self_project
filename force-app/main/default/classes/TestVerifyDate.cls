@isTest
private class TestVerifyDate {
    @isTest static void testMethod1() {
        Integer days = 1;
        Date one = Date.today();
        Date two = one.addDays(days);
        Date temp = VerifyDate.CheckDates(one,two);
        System.assertEquals(two,temp);
    }
}