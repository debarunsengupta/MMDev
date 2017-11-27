/**************************************************************************************
Apex Class Name:  MMToggleTaskDependentField
Version     : 1.0 
Created Date    : 14 Nov 2017
Function    :  Check for dependent activities and if all dependent activities are completed , 
mark that task as independent.

Modification Log :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Rajashree                 11/14/2017              Original Version
*************************************************************************************/

public class MMToggleTaskDependentField{
    @InvocableMethod
    /**Method Name : toggleDependent
Return type : void 
Description : Method for Class MMToggleTaskDependentField to toggle the Dependent checkbox on Task.
This is invoked from DependentFieldToggling Process Builder.
**/
    public static void toggleDependent(List<Id> tskId){
        System.debug('@@@@@@tskId1'+  tskId);  
        if(tskId != NULL){  
            
            List<Task> lstTskTriggered = [SELECT id,Status,WhatId,MM_HardDependencyNums__c,MM_SerialNo__c FROM Task WHERE id IN: tskId]; 
            Set<Id> setWhatId = new Set<Id>();
            List<String> lstSNo = new List<String>();
            List<Task> lstTaskUpdate = new List<Task>();
            Map<Task,List<Task> > mapTAskIdTaskList = new Map<Task,List<Task>>(); 
            Map<Id,Integer> mapTaskSize = new Map<Id,Integer>();
            
            // Keeping the WhatId and SerialNos to be used in the query
            for(Task t: lstTskTriggered){
                setWhatId.add(t.WhatId);
                lstSNo.add(t.MM_SerialNo__c);        
            }      
            
            //Picking up all the tasks under that case .                               
            List<Task> lstTskParent = [SELECT id,WhatId,MM_HardDependencyNums__c,MM_Start_Date__c,Business_Task__c,RecordTypeId,
                                       Status,Dependent__c,MM_SerialNo__c
                                       FROM Task WHERE WhatId IN: setWhatId
                                       AND MM_Custom_Task__c = false]; 
            
            System.debug('@@@@@@lstTskParent' + lstTskParent); 
            Map<String,Task> mapSnoTask = new Map<String,Task>();
            
            //Creating a map of task Sno and the corresponding task
            if(lstTskParent!= NULL && !lstTskParent.isEmpty()){ 
                for(Task t: lstTskParent){ 
                    mapSnoTask.put(t.MM_SerialNo__c,t);                 
                }
            }
            System.debug('@@@@ mapSnoTask'+mapSnoTask);
            if(lstTskParent!= NULL && !lstTskParent.isEmpty()){ 
                for(Task t: lstTskParent){ 
                    List<Task> lstTasksDep = new List<Task>();
                    String[] lstStrSno = new String[]{};
                        System.debug('@@@@@t.MM_HardDependencyNums__c'+t.MM_HardDependencyNums__c);
                    if(t.MM_HardDependencyNums__c != NULL){
                        // Multiple Depedencies
                        if(t.MM_HardDependencyNums__c.contains(staticVariableClass.String_Semicolon)){
                            lstStrSno = t.MM_HardDependencyNums__c.split(staticVariableClass.String_Semicolon);
                            System.debug('@@@@lstStrSno'+lstStrSno );
                            for(String s:lstStrSno){
                                lstTasksDep.add(mapSnoTask.get(s));
                            }
                            if(!lstTasksDep.isEmpty()){
                                mapTAskIdTaskList.put(t,lstTasksDep);
                            }
                            System.debug('@@@@mapTAskIdTaskList'+mapTAskIdTaskList);
                            mapTaskSize.put(t.id,lstStrSno.size()); 
                            System.debug('@@@@mapTaskSize'+mapTaskSize);
                        } 
                        //Single Dependency
                        else{
                            for(Task tskTriggered: lstTskTriggered){  
                                System.debug('@@@t.MM_HardDependencyNums__c'+t.MM_HardDependencyNums__c);
                                System.debug('@@@String.valueOf(tskTriggered.MM_SerialNo__c)'+String.valueOf(tskTriggered.MM_SerialNo__c));
                                
                                if(t.MM_HardDependencyNums__c == String.valueOf(tskTriggered.MM_SerialNo__c)){
                                    t.Dependent__c = false;
                                    System.debug('@@@@t'+t);   
                                    lstTaskUpdate.add(t);
                                }
                            }
                        }
                    }
                }
                
                if(mapTAskIdTaskList.keySet() != NULL){
                    System.debug('@@@@mapTAskIdTaskList.keySet()'+mapTAskIdTaskList.keySet()); 
                    for(Task t: mapTAskIdTaskList.keySet()){
                        if( t.Dependent__c ){
                            Integer count =0;
                            System.debug('@@@@mapTAskIdTaskList.get(t)'+mapTAskIdTaskList.get(t));
                            for(Task tt: mapTAskIdTaskList.get(t)){
                            if(tt.Status == staticVariableClass.String_Status ){ 
                                        count++;
                              }
                                System.debug('@@@@count'+count);   
                                System.debug('@@@@mapTaskSize.get(t.id)'+mapTaskSize.get(t.id));   
                                if(mapTaskSize.get(t.id) == count){        
                                    t.Dependent__c = false;                    
                                    lstTaskUpdate.add(t);
                                    
                                }
                            }
                        } 
                    }
                }
            }
            if(!lstTaskUpdate.isEmpty()){
                System.debug('@@@@lstTaskUpdate'+lstTaskUpdate);
                UPDATE lstTaskUpdate;
            } 
        } 
    }
}