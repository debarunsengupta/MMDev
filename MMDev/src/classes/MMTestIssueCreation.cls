@isTest 
private class MMTestIssueCreation{
    static testMethod void createCustomSettingTest() 
    {
        MM_By_Pass_Triggers__c  objByPassTrigger = new MM_By_Pass_Triggers__c();
        objByPassTrigger.Name = 'Enable Triggers';
        objByPassTrigger.ByPassTrigger__c = False;
        insert objByPassTrigger;
    }
    
    static testMethod void createIssueTest() {
        createCustomSettingTest();
        Account acc = new Account();
        acc.name = 'TestAccount';
        insert acc; 
        
        Case cs = new Case();
        cs.Status='New';
        cs.Origin='Web';
        cs.Account = acc;
        insert cs;
        
        Task tsk = new Task();
        tsk.Subject='Test';
        tsk.WhatId = cs.Id;
        insert tsk;
        
        System.currentPageReference().getParameters().put('id', tsk.id); 
        // call the constructor
        MMIssueCreation controller = new MMIssueCreation (new ApexPages.StandardController(tsk));
        controller.severityLevel = 'Low';
        controller.description = 'testing';
        controller.issueName='hello';
        controller.getselectedaccnamefields();
        controller.createIssue();
    }
    
    static testMethod void createIssueTest_FailureScenario() {
        createCustomSettingTest();
        Account acc = new Account();
        acc.name = 'TestAccount';
        insert acc; 
        
        Case cs = new Case();
        cs.Status='New';
        cs.Origin='Web';
        cs.Account = acc;
        insert cs;
        
        Task tsk = new Task();
        tsk.Subject='Test';
        tsk.WhatId = cs.Id;
        insert tsk;
        
        System.currentPageReference().getParameters().put('id', tsk.id); 
        // call the constructor
        MMIssueCreation controller = new MMIssueCreation (new ApexPages.StandardController(tsk));
        controller.severityLevel = 'Low';
        controller.description = null;
        controller.issueName= 'Test';
        controller.getselectedaccnamefields();
        controller.createIssue();
    }
    
    static testMethod void createIssue_FailureScenario() {
        createCustomSettingTest();
        Account acc = new Account();
        acc.name = 'TestAccount';
        insert acc; 
        
        Case cs = new Case();
        cs.Status='New';
        cs.Origin='Web';
        cs.Account = acc;
        insert cs;
        
        Task tsk = new Task();
        tsk.Subject='Test';
        tsk.WhatId = cs.Id;
        insert tsk;
        
        // Set page Parameter
        System.currentPageReference().getParameters().put('id', tsk.id); 
        // Controller Invokation
        MMIssueCreation controller = new MMIssueCreation (new ApexPages.StandardController(tsk));
        controller.severityLevel = 'Low';
        controller.description = 'Test';
        controller.issueName= null;
        // Picklist Method Invokation
        controller.getselectedaccnamefields();
        // Controller Method Invokation
        controller.createIssue();
    }
}