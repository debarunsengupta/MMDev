/**************************************************************************************
Apex Class Name:  MMCaseCreation
Version     : 1.0 
Created Date    : 4 Nov 2017
Function    :  create a case under each SubGroup and create the respective tasks under the Case, based on Task Path

Modification Log :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Rajashree                 11/04/2017              Original Version
*************************************************************************************/

public class MMCaseCreation extends staticVariableClass{
    /**Method Name : createCase
       Return type : void 
       Description : Method for Class MMCaseCreation to create a case under each SubGroup
        and create the respective tasks under the Case, based on Task Path.This is invoked from CaseAndTaskCreation Process Builder.
     **/
@InvocableMethod
public static void createCase(List<Id> lstAccId){
    List<Account> lstObjAcc = [SELECT id,Name,MM_Task_Path_Category__c,MM_Migration_Date__c,OwnerId,MM_End_to_End_Project_Manager__c
                                 FROM Account WHERE id IN: lstAccId];
    List<Case> lstCase = new List<Case>();
    for(Account acc : lstObjAcc){
        Case objCase = new Case();
        String s = String.valueOf(acc.MM_Migration_Date__c);
        objCase.MM_Name__c = acc.Name+ staticVariableClass.String_Value_Underscore + s.subString(staticVariableClass.Counter_Value_Zero,staticVariableClass.Counter_Value_Ten);
        objCase.AccountId = acc.Id;
        objCase.MM_Task_Path_Category__c = acc.MM_Task_Path_Category__c;
        if(acc.MM_Migration_Date__c!= null){
            objCase.MM_SubGroup_Migration_Date__c = acc.MM_Migration_Date__c;
        }       
        objCase.MM_Account_Manager__c = acc.OwnerId;
        if(acc.MM_End_to_End_Project_Manager__c!= null){
            objCase.OwnerId = acc.MM_End_to_End_Project_Manager__c;
            }
      //  objCase.MM_End_to_End_Project_Manager__c = acc.MM_End_to_End_Project_Manager__c;
        lstCase.add(objCase);
    }
    if(lstCase != NULL && !lstCase.isEmpty()){
        INSERT lstCase;
        
        list<case> insertedCase = new list<case>();
        insertedCase = [select id , CaseNumber , Account.Name from case where id IN : lstCase];
        
        list<case> updateCaseRecord = new list<case>();
        for(Case cs : insertedCase){
            cs.Subject = cs.CaseNumber+ staticVariableClass.String_Value_Underscore + cs.Account.Name;
            updateCaseRecord.add(cs);
        }   
        update updateCaseRecord;
    }
    for(Case objCase : lstCase){
       MMTaskCreation.createTasks(objCase.id, objCase.MM_Task_Path_Category__c,objCase.MM_SubGroup_Migration_Date__c,objCase.AccountId);
    }
  }
}