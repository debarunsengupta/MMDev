/**************************************************************************************
Apex Class Name:  MMRAGStatusSchedular
Version     : 1.0 
Created Date    : 2 NOV 2017
* @Author: Deloitte
Function    : class to call Batch Apex 
*************************************************************************************/
global class MMRAGStatusSchedular implements schedulable
{
  /**
* Methods that calls the batch apex
* 
* @Date: 2/11/2017
* @Author: Debarun Sengupta
* 
*/
global void execute(SchedulableContext sc)
    {
    MMRAGStatusUpdate b = new MMRAGStatusUpdate(); 
      database.executebatch(b);
    }
}