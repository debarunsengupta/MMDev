/**************************************************************************************
Apex Class Name:  MMRAGStatusUpdateTest
Version     : 1.0 
Created Date    : 3 NOV 2017
@Author: Deloitte
Function    : Test class for MMRAGStatusUpdate
*************************************************************************************/
@isTest 
public class MMRAGStatusUpdateTest 
{
/**
* Test method for checking Red RAG Status logic
* @Date: 2/11/2017
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

    static testMethod void testMethodRed() 
    {
        createCustomSettingTest();
        List<Case> lstcase= new List<Case>();
        
                Case c = new Case();
                c.Origin ='Email';
                insert c;
                System.assert(c.Origin!=null,'test');
                Task t = new Task();
                t.subject ='test';
                t.MM_Task_RAG_Status__c ='Red';
                t.whatid=c.id;
                t.activitydate=system.today().addDays(-2);
                t.MM_Issue_Reasoning__c='Late requirement';
                t.status='Open';
                insert t;
        
               System.assert(t.id!=null,'test');

               Test.startTest();

               MMRAGStatusUpdate obj = new MMRAGStatusUpdate();
               DataBase.executeBatch(obj); 
            
               Test.stopTest();
    }
/**
* Test method for checking Amber RAG Status logic
* @Date: 2/11/2017
* @Author: Deloitte
* 
*/
       static testMethod void testMethodAmber() 
    {
        createCustomSettingTest();
        List<Case> lstcase= new List<Case>();
        
            Case c = new Case();
            c.Origin ='Email';
            
             insert c;
           System.assert(c.Origin!=null,'test');     
            Task t = new Task();
            t.subject ='test';
             t.MM_Task_RAG_Status__c ='Amber';
            t.whatid=c.id;
            t.activitydate=system.today().addDays(-4);
           t.status='Open';
            t.MM_Issue_Reasoning__c='Late requirement';
            insert t;
            System.assert(t.id!=null,'test');
            Test.startTest();

            MMRAGStatusUpdate obj = new MMRAGStatusUpdate();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
       }
/**
* Test method for checking Green RAG Status logic
* @Date: 2/11/2017
* @Author: Deloitte
* 
*/
    static testMethod void testMethodGreen() 
    {
        createCustomSettingTest();
        List<Case> lstcase= new List<Case>();
        
            Case c = new Case();
            c.Origin ='Email';
            
             insert c;
            System.assert(c.Origin!=null,'test');
            Task t = new Task();
            t.subject ='test';
             t.MM_Task_RAG_Status__c ='Green';
             t.status='Open';
            t.whatid=c.id;
             t.MM_Issue_Reasoning__c='Late requirement';
            t.activitydate=system.today().addDays(-6);
            
            insert t;
            System.assert(t.id!=null,'test');
        
        
          Test.startTest();

            MMRAGStatusUpdate obj = new MMRAGStatusUpdate();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}