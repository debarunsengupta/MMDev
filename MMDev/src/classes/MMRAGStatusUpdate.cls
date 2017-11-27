/**************************************************************************************
Apex Class Name:  MMRAGStatusUpdate 
Version     : 1.0 
Created Date    : 2 NOV 2017
@Author: Deloitte
Function    : class which contains the logic to update RAG status field in case depending upon business logic
*************************************************************************************/
global class MMRAGStatusUpdate extends staticVariableClass implements Database.Batchable<sObject> {
    
 /**
* start method is used to generate the scope of objects used in the batch job
* @Date: 2/11/2017
* @Author: Deloitte
* 
*/
global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID,MM_RAG_Status__c, (SELECT ID,activitydate,MM_OverDue__c,MM_Task_RAG_Status__c FROM openactivities where MM_OverDue__c=true) FROM case' 
        );
    }

/**
* execute method is used to update the RAG status depending upon business logic
* @Date: 2/11/2017
* @Author: Deloitte
* 
*/
    global void execute(Database.BatchableContext bc, List<case> scope){
        // process each batch of records
        
        Map<Id,List<openactivity>> casetotask= new Map<Id,List<openactivity>>();
        
        
        Map<String,String> redTaskMap = new Map<String,String>();
        Map<String,String> amberTaskMap = new Map<String,String>();
        Map<String,String> greenTaskMap = new Map<String,String>();
      
        
        
        list<Id> caseIdCheck = new list<Id>();
        for(case eachcase: scope)
        {
            caseIdCheck.add(eachcase.id);
            casetotask.put(eachcase.id,eachcase.openactivities);
        }

        list<Case> listCaseUpdate = [select id,MM_RAG_Status__c from case where id IN: caseIdCheck];
        list<case> caseStatusUpdate1 = new list<case>();
        for(Case csCheck : listCaseUpdate){
            csCheck.MM_RAG_Status__c= '';
            caseStatusUpdate1.add(csCheck);
        }
        
        update caseStatusUpdate1;
        
        Id caseID;
       for(Id mapkey:casetotask.keyset())
       {
           caseID = mapkey;
           List<openactivity> opact=casetotask.get(mapkey);
           for(openactivity eachtask: opact)
           {
               if(eachtask.MM_Task_RAG_Status__c== Task_RAG_Status_Value_Red) 
               {  
                   redTaskMap.put(mapkey+String_Value_Hyphen+eachtask,Task_RAG_Status_Value_Red);
               }
               
               else if(eachtask.MM_Task_RAG_Status__c== Task_Status_Value_Amber) 
               {
                    amberTaskMap.put(mapkey+String_Value_Hyphen+eachtask,Task_Status_Value_Amber);
               }
         
                else if(eachtask.MM_Task_RAG_Status__c== Task_RAG_Status_Value_Green) 
               {
                    greenTaskMap.put(mapkey+String_Value_Hyphen+eachtask, Task_RAG_Status_Value_Green);                   
               }
           }
       }    
       
        // Loop through Map for Red Tasks
        set<Id> caseIdSet = new set<Id>();
        for(String objRed : redTaskMap.keyset()){
            
            String red = objRed.split(String_Value_Hyphen)[Counter_Value_Zero];
            caseIdSet.add(red);
        }   
        
        list<Case> lstCaseObj = [select id , MM_RAG_Status__c from Case where id IN: caseIdSet];
        
        list<Case> updateCaseList = new list<Case>(); 
        for(Case csObj : lstCaseObj){
            csObj.MM_RAG_Status__c = Task_RAG_Status_Value_Red;
            updateCaseList.add(csObj);
        }   
        update updateCaseList;
        
        updateCaseList.clear();
        caseIdSet.clear();
        
        // Loop through Map for Amber Tasks
        for(String objAmb : amberTaskMap.keyset()){
            
            String amber = objAmb.split(String_Value_Hyphen)[Counter_Value_Zero];
            caseIdSet.add(amber);
        }   
        
        list<Case> lstCaseObj1 = [select id , MM_RAG_Status__c from Case where id IN: caseIdSet and MM_RAG_Status__c != 'Red'];
        
        //list<Case> updateCaseList = new list<Case>();
        for(Case csObj : lstCaseObj1){
            csObj.MM_RAG_Status__c = Task_Status_Value_Amber;
            updateCaseList.add(csObj);
        }   
        update updateCaseList;
        
        updateCaseList.clear();
        caseIdSet.clear();
        
        // Loop through Map for Green Tasks
        
        for(String objGreen : greenTaskMap.keyset()){
            
            String green = objGreen.split(String_Value_Hyphen)[Counter_Value_Zero];
            caseIdSet.add(green);
        }   
        
        list<Case> lstCaseObj2 = [select id , MM_RAG_Status__c from Case where id IN: caseIdSet and MM_RAG_Status__c != 'Red'and MM_RAG_Status__c != 'Amber'];
        
        for(Case csObj : lstCaseObj2){
            csObj.MM_RAG_Status__c = Task_RAG_Status_Value_Green;
            updateCaseList.add(csObj);
        }   
        update updateCaseList;
    }   
    
    
/**
* execute method is used for handling post processing logic
* @Date: 2/11/2017
* @Author: Deloitte
* 
*/

    global void finish(Database.BatchableContext bc){
    }    
}