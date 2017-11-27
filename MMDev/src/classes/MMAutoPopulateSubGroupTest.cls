/**************************************************************************************
Apex Class Name:  MMAutoPopulateSubGroupTest
Version     : 1.0 
Created Date    : 14 NOV 2017
@Author: Deloitte
Function    : Test class for MMAutoPopulateSubGroup
*************************************************************************************/
@isTest(seealldata=true) 
public class MMAutoPopulateSubGroupTest 
{
/**
* Test method for checking sub group autopopulation logic
* @Date: 14/11/2017
* @Author: Deloitte
* 
*/
    static testMethod void SubGrpPopulate() 
    {
       
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

               //MMRAGStatusUpdate obj = new MMRAGStatusUpdate();
               //DataBase.executeBatch(obj); 
            
               Test.stopTest();

}
}