/**************************************************************************************
Apex Class Name: MMToggleTaskDependentFieldTest
Version     : 1.0 
Created Date    : 17 NOV 2017
@Author: Deloitte
Function    : Test class for MMToggleTaskDependentField
*************************************************************************************/

@isTest 
public class MMToggleTaskDependentFieldTest
{
    /**
* Test method for checking dependencies
* @Date: 11/17/2017
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
    
    static testMethod void testMethodDepn() 
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
       // staticVariableClass.String_Status = 'Completed';
        //staticVariableClass.String_Semicolon =';';
        List<Id> lstTaskId = new List<Id>();
        Task tsk= new Task();
        tsk.WhatId = c.id;
        tsk.MM_Dependent_Activities__c = '';
        tsk.MM_SubGroup_Name__c = acc.id;
        tsk.MM_SerialNo__c ='1';
        tsk.Status= 'Completed';
        tsk.Dependent__c = false;
        tsk.MM_Custom_Task__c = false;
        insert tsk;
        lstTaskId.add(tsk.id);
        
        
        Task tsk2= new Task();
        tsk2.WhatId = c.id;
        tsk2.MM_Dependent_Activities__c = 'task';
        tsk2.MM_SubGroup_Name__c = acc.id;
        tsk2.MM_SerialNo__c = '2';
        tsk2.MM_HardDependencyNums__c='1';
        tsk2.Status='Inactive';
        tsk2.MM_Custom_Task__c = false;
        tsk2.Dependent__c = true;
        insert tsk2;
        
        
        
        Task tsk3= new Task();
        tsk3.WhatId = c.id;
        tsk3.MM_Dependent_Activities__c = '';
        tsk3.MM_SubGroup_Name__c = acc.id;
        tsk3.MM_SerialNo__c = '3';
        tsk3.Status='Completed';
        tsk3.MM_Custom_Task__c = false;
        tsk3.Dependent__c = false;
        insert tsk3;
        lstTaskId.add(tsk3.id);
        
        Task tsk4= new Task();
        tsk4.WhatId = c.id;
        tsk4.MM_Dependent_Activities__c = '';
        tsk4.MM_SubGroup_Name__c = acc.id;
        tsk4.MM_SerialNo__c = '4';
        tsk4.MM_HardDependencyNums__c='1;3';
        tsk4.Status='Inactive';
        tsk4.MM_Custom_Task__c = false;
        tsk4.Dependent__c = true;
        insert tsk4;
        
        Test.startTest();
        MMToggleTaskDependentField.toggleDependent(lstTaskId);
        
        Test.stopTest();
    }
}