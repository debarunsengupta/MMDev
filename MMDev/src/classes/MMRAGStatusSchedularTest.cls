/**************************************************************************************
Apex Class Name:  MMRAGStatusSchedularTest
Version     : 1.0 
Created Date    : 2 NOV 2017
* @Author: Deloitte
Function    : Test class for MMRAGStatusSchedular
*************************************************************************************/
@isTest 
public class MMRAGStatusSchedularTest
{
 /**
* Methods for testing the schedulable class
* 
* @Date: 3/11/2017
* @Author: Deloitte
* 
*/
    static testMethod void testMethodSchedular() 
    {
        
        Test.startTest();

            //MMRAGStatusSchedular m=new MMRAGStatusSchedular();
            //MMRAGStatusSchedular.execute();
            MMRAGStatusSchedular sh1 = new MMRAGStatusSchedular();      
           String sch = '0  00 1 3 * ?';
           System.assert(sch!='','test');

           system.schedule('Test',sch,sh1);
            
        Test.stopTest();
    }
    }