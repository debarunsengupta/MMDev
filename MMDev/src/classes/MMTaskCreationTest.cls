/**************************************************************************************
Apex Class Name:  MMTaskCreationTest
Version     : 1.0 
Created Date    : 10 NOV 2017
@Author: Deloitte
Function    : Test class for MMTaskCreation
*************************************************************************************/
@isTest 
public class MMTaskCreationTest 
{
    /**
* Test method for checking Account Manager Team Name
* @Date: 10/11/2017
* @Author: Deloitte
* 
*/
    
    static testMethod void createCustomSettingTest() 
    {
        MM_By_Pass_Triggers__c  objByPassTrigger = new MM_By_Pass_Triggers__c();
        objByPassTrigger.Name = 'Enable Triggers';
        objByPassTrigger.ByPassTrigger__c = False;
        insert objByPassTrigger;
    }
    
    static testMethod void testMethodAccountMgr() 
    {
        createCustomSettingTest();  
        Account acc=new Account();
        acc.Name='test';
        insert acc;
        string actid=acc.id;
        Case c = new Case();
        c.Origin ='Email';
        insert c;
        System.assert(C.Origin!=null,'test');
        
        string caseid=c.id;
        // Creating User
        Profile pro = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUserA = new User(
            Alias = 'standard', Email='standarduser@testorg.com',  
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pro.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testUserA@testorganise.com');
        insert testUserA;   
        
        MM_Task_Path_Info__c m=new MM_Task_Path_Info__c();
        m.Task_Name__c='test1';
        m.MM_Task_Assignee_Queue__c = testUserA.id;
        m.MM_Task_Path_Category__c='Standard';
        m.MM_Duration__c=12;
        m.MM_Impact_to_RAG__c='Red';
        m.MM_Hard_Dependency__c='test';
        m.MM_Team_Name__c='Account Manager';
        m.MM_T_Minus__c=11;
        m.Business_Task__c=true;
        m.MM_Milestone_Tasks__c = true;
        m.OwnerId = testUserA.id;
        insert m;
        system.debug('==m=='+m);
        System.assert(m.id!=null,'test');
        
        Test.startTest();
        MMTaskCreation.createTasks(caseid,'Standard',Datetime.now(),actid);
        
        Test.stopTest();
    }
    /**
* Test method for checking E2EPM Team Name
* @Date: 10/11/2017
* @Author: Deloitte
* 
*/
    
    static testMethod void testMethodE2EPM() 
    {
        createCustomSettingTest();      
        Account acc=new Account();
        acc.Name='test';
        insert acc;
        string actid=acc.id;
        
        Case c = new Case();
        c.Origin ='Email';
        insert c;
        string caseid=c.id;
        task t=new task();
        t.whatid=c.id;
        t.subject='other';
        t.MM_Dependent_Activities__c='test';
        t.MM_Task_RAG_Status__c='Red';
        t.activitydate=system.today();
        t.MM_Start_Date__c=system.today();
        t.MM_Milestone_Tasks__c = true;
        insert t;
        System.assert(t.id!=null,'test');
        
        // Creating User
        Profile pro = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUserA = new User(
            Alias = 'standard', Email='standarduser@testorg.com',  
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pro.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testUserA@testorganise.com');
        insert testUserA;  
        
        MM_Task_Path_Info__c m=new MM_Task_Path_Info__c();
        m.Task_Name__c='test1';
        m.MM_Task_Assignee_Queue__c = testUserA.id ;
        m.MM_Task_Path_Category__c='Standard';
        m.MM_Duration__c=12;
        m.MM_Impact_to_RAG__c='Red';
        m.MM_Hard_Dependency__c='test';
        m.MM_Team_Name__c='E2E PM';
        m.MM_T_Minus__c=13;
        m.Business_Task__c=true;
        m.MM_Milestone_Tasks__c = true;
        m.OwnerId = testUserA.id;
        insert m;
        System.assert(m.id!=null,'test');
        
        Test.startTest();
        MMTaskCreation.createTasks(caseid,'Standard',Datetime.now(),actid);
        
        
        Test.stopTest();
    }
    /*
* Test method for checking Other Team Name
* @Date: 10/11/2017
* @Author: Deloitte
* 
*/
    
    static testMethod void testMethodOther() 
    {
        createCustomSettingTest(); 
        // Creating User
        Profile pro = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUserA = new User(
            Alias = 'standard', Email='standarduser@testorg.com',  
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pro.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testUserA@testorganise.com'); 
        insert testUserA; 
        Account acc=new Account();
        acc.Name='test';
        insert acc;
        string actid=acc.id;
        
        
        Case c = new Case();
        c.Origin ='Email';
        insert c;
        System.assert(c.id!=null,'test');
        
        task t=new task();
        t.whatid=c.id;
        t.subject='other';
        t.MM_Dependent_Activities__c=null;
        t.MM_Task_RAG_Status__c='Red';
        t.activitydate=system.today();
        t.MM_Start_Date__c=system.today().addDays(-2);
        t.MM_Milestone_Tasks__c = true;
        insert t;
        System.assert(t.id!=null,'test');
        
        string caseid=c.id;
        MM_Task_Path_Info__c m=new MM_Task_Path_Info__c();
        m.Task_Name__c='test1';
        m.MM_Task_Path_Category__c='Standard';
        m.MM_Duration__c=12;
        m.MM_Task_Assignee_Queue__c = testUserA.id ;
        m.MM_Impact_to_RAG__c='Red';
        m.MM_Hard_Dependency__c='test';
        m.MM_Team_Name__c='other';
        m.Business_Task__c=false;
        m.MM_T_Minus__c=14;
        m.MM_Milestone_Tasks__c = true;
        m.OwnerId = testUserA.id;
        insert m;
        System.assert(m.id!=null,'test');
        Test.startTest();
        MMTaskCreation.createTasks(caseid,'Standard',Datetime.now(),actid);
        Test.stopTest();
    }
    
}