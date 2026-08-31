public without sharing class SyncAccountInfoToPhoneBatch implements Database.Batchable<sObject>,Database.Stateful, Schedulable{

    public List<Account> accountList = new List<Account>();

    public SyncAccountInfoToPhoneBatch() {}

    /**
     * @description 执行定时任务
     * @param sc
     */
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new SyncAccountInfoToPhoneBatch(), 100);
    }

    /**
     * @description 执行批处理准备数据
     * @return Database.Querylocator
     * @param bc
     */
    public Database.Querylocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Name, Phone FROM Account WHERE Phone != NULL';
        return Database.getQueryLocator(query);
    }

    /**
     * @description 执行批处理方法
     * @param bc
     * @param accList
     */
    public void execute(Database.BatchableContext bc, List<Account> accList) {
        System.debug('accList >>' + accList);

        List<Account> accountToUpdate = new List<Account>();
        for(Account acc : accList) {
            accountToUpdate.add(new Account(Id = acc.Id, Phone = acc.Phone, Name = acc.Name));
        }
        accountList.addAll(accountToUpdate);
        system.debug('execute accountList >>' + accountList);
    }

    /**
     * @description 执行完成方法
     * @param bc
     */
    public void finish(Database.BatchableContext bc) {
        System.debug('finish this.accountList >>' + this.accountList);
        System.debug('finish accountList >>' + accountList);
        System.debug('bc >>' + bc);
        sendEmail(accountList);
    }

    public static void sendEmail(List<Account> accList) {


        // String conflictRecipients  = System.Label.SyncHcpDataConflictRecipient;
        // String statusRecipients  = System.Label.SyncHcpDataStatusRecipient;
        // List<String> conflictRecipientList = conflictRecipients.split(';');
        // List<String> statusRecipientList = statusRecipients.split(';');

        List<String> recipientList = new List<String>{'1807719013@qq.com'};// 接收人

        List<String> templateNames = new List<String>{'SyncAccountInfoToPhoneAlert1'};
        Map<String, EmailTemplate> emailTemplateMap = new Map<String, EmailTemplate>();
        for (EmailTemplate template : [SELECT Id, Subject, HtmlValue, DeveloperName FROM EmailTemplate WHERE DeveloperName IN :templateNames]) {
            emailTemplateMap.put(template.DeveloperName, template);
        }
        if (emailTemplateMap.isEmpty()) {
            System.debug('No matching email template found, skipping email send.');
            return;
        }

        List<OrgWideEmailAddress> senders = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE DisplayName Like '%xufan%' limit 1];
        if (senders.isEmpty()) {
            System.debug('No OrgWideEmailAddress found, skipping email send.');
            return;
        }

        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template = emailTemplateMap.get('SyncAccountInfoToPhoneAlert1');
        String emailBody = template.HtmlValue;
        String tableHtml = generateEmailBody(accList);
        emailBody = emailBody.replace('#template', tableHtml);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId(senders[0].Id);
        mail.setToAddresses(recipientList);
        mail.setTargetObjectId(UserInfo.getUserId());  // 设置收件人
        mail.setSaveAsActivity(false);
        mail.setSubject(template.Subject);  // 邮件主题
        mail.setHtmlBody(emailBody);  // 邮件正文
        messages.add(mail);

        // Skip email sending in test context to keep unit tests deterministic.
        if (Test.isRunningTest()) {
            System.debug('Skipping email send in test context.');
            return;
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        system.debug('邮件发送结果: ' + results);
    }

    /**
     * @description: 生成邮件body
     * @return {*}
     */
    public static String generateEmailBody(List<Account> accList) {
        String info = '';
        String emailBody = '<table style="width:100%; border-collapse: collapse;">'
                         + '<thead>'
                         + '<tr>'
                         + '<th style="border: 1px solid #ddd; padding: 8px;">姓名</th>'
                         + '<th style="border: 1px solid #ddd; padding: 8px;">电话</th>'
                         + '<th style="border: 1px solid #ddd; padding: 8px;">sf id</th>'
                         + '</tr>'
                         + '</thead>'
                         + '<tbody>';

        for(Account data : accList){
            info += '<tr>'
                        +   '<td style="border: 1px solid #ddd; padding: 8px;">' + data.Name + '</td>'
                        +   '<td style="border: 1px solid #ddd; padding: 8px;">' + data.Phone + '</td>'
                        +   '<td style="border: 1px solid #ddd; padding: 8px;">' + data.Id + '</td>'
                        +   '</tr>';
        }
        emailBody = emailBody + info + '</tbody></table>';
        return emailBody;
    }
}