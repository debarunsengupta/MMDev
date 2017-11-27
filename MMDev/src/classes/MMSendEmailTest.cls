@isTest 
private class MMSendEmailTest  {
   
    static testMethod void sendmailTest() {
        
        
        MMSendEmail controller = new MMSendEmail ();
        String sch = '0 00 1 3 * ?';
        System.assert(sch!='','test');
        System.schedule('Test',sch,controller);
        controller.sendmail();
          
        }
}