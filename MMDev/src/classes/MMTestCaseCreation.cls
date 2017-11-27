@isTest 
private class MMTestCaseCreation{
    static testMethod void createCaseTest() {
        
    Profile pr = [SELECT Id FROM Profile WHERE Name='Standard User']; 
    User usr = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = pr.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standard@usertestorg.com'); 
    insert usr;
        
    Account ac1 = new Account();
    ac1.name='test';
        ac1.MM_Task_Path_Category__c='Standard';
        ac1.MM_Migration_Date__c=system.today();
        ac1.MM_End_to_End_Project_Manager__c = usr.id;
    insert ac1;
    List<Case> lstCase = new List<Case>();
    Case c1 = new Case();
    c1.MM_Name__c ='test';
    c1.AccountId = ac1.Id;
    c1.MM_Task_Path_Category__c = 'Standard';
    List<Id> aclist = new List<Id> ();
    c1.MM_SubGroup_Migration_Date__c = System.today();
        c1.Subject = 'test';
        insert c1;
        lstCase.add(c1);
    
    
    aclist.add(ac1.id);
    /*Task t1 = new Task(Subject='Test');
    Case c1 = new Case(Status='New',Origin='Web');
        insert c1;
        
    MM_Issue__c i1 = new MM_Issue__c();
        
        t1.WhatId = c1.Id;
        insert t1;
      */ 
    
         Test.startTest();
          MMCaseCreation.createCase(aclist);
        /*System.currentPageReference().getParameters().put('id', t1.id); 
        // call the constructor
        MMIssueCreation controller = new MMIssueCreation (new ApexPages.StandardController(t1));
        //call method
        controller.getselectedaccnamefields();
        controller.createIssue();
        i1.MM_Task_Number__c = t1.MM_Task_Number__c;
        i1.MM_Group_Name__c = 'abc';
        insert i1;
        PageReference pageRef = Page.MM_CreateIssueFromTask;
        Test.setCurrentPage(pageRef);
        // stop the test*/
        Test.stopTest();   
        
    }
    
}