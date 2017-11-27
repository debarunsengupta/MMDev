public class MMIssueCreation extends staticVariableClass{
    
    public Id currentRecord { get; set; }
    public String severityLevel { get; set; }
    public String issueName { get; set; }
    public String taskName { get; set; }
    public String taskID { get; set; }
    public String nameOfTask { get; set; }
    public String status { get; set; }
    public String description { get; set; }
    @TestVisible private list<Case> objCase { get;set; }
    
    Public List<Selectoption> getselectedaccnamefields(){
        List<Selectoption> lstnamesel = new List<selectoption>();
        lstnamesel.add(new selectoption(Issue_Status_Value_Low,Issue_Status_Value_Low));
        lstnamesel.add(new selectoption(Issue_Status_Value_Medium,Issue_Status_Value_Medium));
        lstnamesel.add(new selectoption(Issue_Status_Value_High,Issue_Status_Value_High));
        return lstnamesel; 
    }
    
    public MMIssueCreation(ApexPages.StandardController controller){
        currentRecord = ApexPages.CurrentPage().getparameters().get(String_Value_Id);
        list<Task> objTask = [select MM_Task_Name__c,MM_Task_Number__c,WhatId from task where id =:currentRecord ];
        if(objTask.size() > Counter_Value_Zero){
            objCase = [Select id ,Account.Name,CaseNumber from Case where id =: objTask[Counter_Value_Zero].WhatId];
            taskName = objTask[Counter_Value_Zero].MM_Task_Number__c; 
            taskID = objTask[Counter_Value_Zero].id;
            nameOfTask = objTask[Counter_Value_Zero].MM_Task_Name__c;
            
        }   
        status = Task_Status_Value_Open;
    }
    
    public PageReference createIssue(){
        MM_Issue__c objIssue = new MM_Issue__c();
        if (issueName == null || issueName == '')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,String_Value_Enter_Issue_Name));
            return null;
        } 
            objIssue.MM_Issue_Name__c = issueName;
            objIssue.MM_Priority__c = severityLevel;
            objIssue.MM_Task_Name__c= nameOfTask;
        if(taskName != NULL && taskName != ''){
            objIssue.MM_Task_Number__c = taskName;
            objIssue.MM_Task_ID__c= taskID ;
        }   
        objIssue.MM_Open_Date__c=System.today();
        objIssue.MM_Status__c = status;
        if (description == null || description == '')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,String_Value_Enter_Description));
            return null;
        } 
        objIssue.MM_Description__c = description;
        PageReference pgref;
        
        if(objCase.size() > Counter_Value_Zero && !objCase.isempty()){
            objIssue.MM_Group_Name__c= objCase[Counter_Value_Zero].Account.id;
            objIssue.MM_Case_Number__c = objCase[Counter_Value_Zero].CaseNumber;
        }
        insert objIssue;
                
        pgref = new PageReference(String_Value_Slash+objIssue.Id);
        pgref.setRedirect(true);
        return pgref;
    }
}