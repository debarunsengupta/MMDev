global class MMSendEmail Implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        sendmail();
    }
    
    public void sendmail()
    {
        List<Id> UserId = new List<Id>();
        Id groupId = [SELECT Id from Group where Name = 'Functional Leadership'].id;
        If(groupId != null){
            for(GroupMember grpRecord : [Select UserOrGroupId from GroupMember where GroupId =: groupId]){
                UserId.add(grpRecord.UserOrGroupId);
            }   
        }
        List<string> s=new List<string>();
        for(User objUser : [select id , email from User where Id IN : UserId]){
            system.debug('Email - '+objUser.email);
            s.add(objUser.email);
        }
        Id templateId; 
        templateId = [select id, name from EmailTemplate where developername = : 'MM_Report_Template'].id;
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        //email.setSubject('Testing Apex Scheduler-Subject');
        //email.setPlainTextBody('Testing Apex Scheduler-Body');
        
        Id emailuserId = Userinfo.getUserId();
        email.setTargetObjectId(emailuserId);
        // email.setWhatId('01I2F0000000LJ5');
        email.saveAsActivity = false;
        
        email.setTemplateId(templateId);
        email.setToAddresses(s);
        Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
    }
}