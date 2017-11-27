/**************************************************************************************
Apex Class Name:  MMAutoPopulateSubGroupHandler
Version     : 1.0 
Created Date    : 14 NOV 2017
@Author: Deloitte
Function    : MMAutoPopulateSubGroupHandler to autopopulate subgroup
*************************************************************************************/
public class MMAutoPopulateSubGroupHandler
{
/**
* autopopulatetaskGroupName in task level
* @Date: 14/11/2017
* @Author: Deloitte
* 
*/
public static void autopopulatetaskGroupName(List<Task> tasklist)
{
 Set<Id> idcase=new set<Id>();
 Map<Id,Id> casetoaccid=new Map<Id,Id>();
 for(Task t:tasklist)
 {
 if(t.whatid!=null)
 {
 idcase.add(t.whatid);
 }
 }
 List<Case> c=[select id,Accountid from case where id in :idcase];
 
 for(Case eachcase:c)
 {
 casetoaccid.put(eachcase.id,eachcase.Accountid);
 
 }
 for(Task eachtask:tasklist)
 {
 Id acc=casetoaccid.get(eachtask.whatid);
 eachtask.MM_SubGroup_Name__c=casetoaccid.get(eachtask.whatid);
 }
}
}