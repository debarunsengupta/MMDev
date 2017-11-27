/**************************************************************************************
Trigger Name:  MMAutoPopulateSubGroup
Version     : 1.0 
Created Date    : 13 NOV 2017
@Author: Deloitte
Function    : To Populate subgroup id in task level
*************************************************************************************/
trigger MMAutoPopulateSubGroup on Task (before insert) {
MM_By_Pass_Triggers__c objByPassTrigger = MM_By_Pass_Triggers__c.getInstance('Enable Triggers');
Boolean boolByPassValue = objByPassTrigger.ByPassTrigger__c;
    if(boolByPassValue == False){
        MMAutoPopulateSubGroupHandler.autopopulatetaskGroupName(trigger.new);
    }    
}