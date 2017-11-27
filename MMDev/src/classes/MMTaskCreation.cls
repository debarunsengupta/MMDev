/**************************************************************************************
Apex Class Name:  MMTaskCreation
Version     : 1.0 
Created Date    : 4 Nov 2017
Function    :  Create the respective tasks under each Case, based on Task Path.

Modification Log :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Rajashree                 11/04/2017              Original Version
*************************************************************************************/

public class MMTaskCreation extends staticVariableClass{
    /**Method Name : createTasks
       Return type : void 
       Description : Method for Class MMTaskCreation to create respective tasks under the Case, based on Task Path.
                     This is invoked from MMTaskCreation class.
     **/
    public static void createTasks(String caseId, String subGroup,Datetime migrationDate, String accId){
    
        Database.SaveResult[] srList ;
        try{
        System.debug('@@@@@@@UserInfo.getUserId()'+UserInfo.getUserId());
        List<MM_Task_Path_Info__c> lstTaskPathInfo =[SELECT Name,MM_Duration__c,Task_Name__c,MM_Hard_Dependency__c, MM_Impact_to_RAG__c , MM_Task_Assignee_Queue__c,
                                                        MM_Task_Path_Category__c, MM_Soft_Dependency__c, MM_T_Minus__c,Business_Task__c, MM_Team_Name__c,
                                                        MM_SerialNo__c,MM_HardDependencyNums__c,MM_Milestone_Tasks__c
                                                        FROM MM_Task_Path_Info__c 
                                                        WHERE MM_Task_Path_Category__c =:  subGroup ];
                                                         
                                                      
        Case objCase = [SELECT id,MM_Name__c,MM_Account_Manager__c,OwnerId  FROM Case WHERE id =: caseId];
        Date d = system.today() ;
        String strToday = DateTime.newInstance(d.year(),d.month(),d.day()).format(staticVariableClass.Date_Format);
        List<Task> lstTasks = new List<Task>();
        if(lstTaskPathInfo != NULL && !lstTaskPathInfo.isEmpty()){
            for(MM_Task_Path_Info__c objTaskPathInfo :lstTaskPathInfo){  
                  Task objTask = new Task(); 
                  objTask.MM_SerialNo__c = objTaskPathInfo.MM_SerialNo__c;
                  // Testing Exception Scenario for Tracker object
                /* if( objTask.MM_SerialNo__c == '8'){
                      objTask.MM_Task_Name__c = 'Select custom product - make selections from the standard menu and use exception process for customization||Select custom admin services - make selections from the standard menu and use exception process for customizations||Rate and Quote product selections';
                  } */
                  objTask.MM_HardDependencyNums__c =objTaskPathInfo.MM_HardDependencyNums__c;
                //  objTask.MM_Task_Name__c = objTaskPathInfo.Task_Name__c; 
                  objTask.Subject = objTaskPathInfo.Task_Name__c;  
                   objTask.MM_Milestone_Tasks__c=objTaskPathInfo.MM_Milestone_Tasks__c;          
                  if(objTaskPathInfo.MM_Duration__c != NULL){
                      objTask.MM_Duration__c =  objTaskPathInfo.MM_Duration__c;  
                   }  
                  if(objCase.id != NULL){             
                    objTask.WhatId = objCase.id;
                  }
                  // If Team Name is Acc Manager or E2E PM, then we have to pick the owner from Case.
                  if(objTaskPathInfo.MM_Team_Name__c== staticVariableClass.String_Team_Name_Value_Account_Manager){
                      objTask.OwnerId = objCase.MM_Account_Manager__c ;
                  }
                  else if(objTaskPathInfo.MM_Team_Name__c== staticVariableClass.String_Team_Name_Value_E2E_PM){
                     objTask.OwnerId = objCase.OwnerId;
                  }
                  else{
                      if(objTaskPathInfo.MM_Task_Assignee_Queue__c != NULL){
                           objTask.OwnerId = objTaskPathInfo.MM_Task_Assignee_Queue__c;
                       }
                  }
                  objTask.MM_Custom_Task__c = false;
                  // Assigning the Business task the Business Task Layout having the hyperlink to report
                  if(objTaskPathInfo.Business_Task__c){
                      objTask.Business_Task__c = true;                  
                   }
                   
                 if(objTaskPathInfo.MM_Hard_Dependency__c != NULL){
                      objTask.MM_Dependent_Activities__c = objTaskPathInfo.MM_Hard_Dependency__c;   
                      objTask.Dependent__c = true;    
                  }
                  // For E2E PM category, T-Minus value and duration is NULL, hence the check below
                  if( objTaskPathInfo.MM_T_Minus__c != NULL && migrationDate!= NULL &&objTaskPathInfo.MM_Duration__c!= NULL ){
                    objTask.MM_Start_Date__c = Date.valueOf(migrationDate+ objTaskPathInfo.MM_T_Minus__c) ;
                    objTask.ActivityDate  = Date.valueOf(objTask.MM_Start_Date__c + objTaskPathInfo.MM_Duration__c); // Due Date Calculation Logic
                    objTask.IsReminderSet = true; 
                    objTask.ReminderDateTime = objTask.ActivityDate-staticVariableClass.Counter_Value_Three;
                   // Assigning layouts as per dependency criteria
                  if( objTask.MM_Dependent_Activities__c != NULL || String.valueOf(Date.valueOf(objTask.MM_Start_Date__c)) > strToday  ){
                        if(objTask.Business_Task__c == true){
                            objTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(staticVariableClass.Record_Type_Business_Task).getRecordTypeId(); 
                        }
                        else{                   
                        objTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(staticVariableClass.Record_Type_Task_Read_Only).getRecordTypeId();  
                        }
                     }                          
                 if( objTask.MM_Dependent_Activities__c == NULL && String.valueOf(Date.valueOf(objTask.MM_Start_Date__c)) <= strToday ){
                        if(objTask.Business_Task__c == true){
                            objTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(staticVariableClass.Record_Type_Business_Task_Editable).getRecordTypeId(); 
                             objTask.Status = staticVariableClass.Task_Status_Value_Active;
                        }
                        else{
                         objTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(staticVariableClass.Record_Type_Editable_Task).getRecordTypeId(); 
                         objTask.Status = staticVariableClass.Task_Status_Value_Active;
                        }
                    }
                  }
                 if(accId != NULL){
                  objTask.MM_SubGroup_Name__c = accId;
                 }
                  
                 if(objTaskPathInfo.MM_Impact_to_RAG__c != NULL){
                      objTask.MM_Task_RAG_Status__c = objTaskPathInfo.MM_Impact_to_RAG__c;
                  }
                 objTask.MM_Task_Category__c = objTaskPathInfo.MM_Task_Path_Category__c;
                  objTask.MM_Team_Name__c = objTaskPathInfo.MM_Team_Name__c;
                   objTask.MM_Functional_Group_Pick__c= objTaskPathInfo.MM_Team_Name__c;
                  lstTasks.add(objTask);    
            } 
        } 
        if(lstTasks != NULL && !lstTasks.isEmpty()){
        // srList = Database.INSERT(lstTasks);
      
            INSERT lstTasks;
            taskTracker(staticVariableClass.String_Success,caseId, accId,subGroup); 
        } 
      }
      catch(DMLException e)
      {            
       taskTracker(e.getMessage(),caseId, accId,subGroup);
      } 
    } 
   // public  static void taskTracker(Database.SaveResult[] srList,String CaseName,Id SubGroupName,String TaskPath){
     public  static void taskTracker(String strErrMessage,String CaseName,Id SubGroupName,String TaskPath){
        MM_Task_CreationTracking__c tasktracker = new MM_Task_CreationTracking__c();
        tasktracker.MM_Implementation_Account__c = SubGroupName;
        tasktracker.MM_Implementation_Case_Id__c = CaseName;
        tasktracker.Task_Path__c = TaskPath;
    /*  for (Database.SaveResult sr : srList) {
         if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
        System.debug('Successfully inserted account. Account ID: ' + sr.getId());
        tasktracker.Task_Creation_Status__c = staticVariableClass.String_Success;
        }
        else {
        // Operation failed, so get all errors    
        tasktracker.Task_Creation_Status__c = staticVariableClass.String_Failure;        
        for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                   
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Account fields that affected this error: ' + err.getFields());
         //   tasktracker.Task_Error_Fields__c = err.getFields() ;
            tasktracker.Task_Error_Message__c = err.getMessage();
        }       
      }
   } */
     if(strErrMessage != staticVariableClass.String_Success){
       tasktracker.Task_Error_Message__c = strErrMessage;
       tasktracker.Task_Creation_Status__c = staticVariableClass.String_Failure; 
     }
     else{
       tasktracker.Task_Creation_Status__c = staticVariableClass.String_Success;
    }
     INSERT tasktracker; 
 }
}