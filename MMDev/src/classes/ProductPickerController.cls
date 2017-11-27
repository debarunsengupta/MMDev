public class ProductPickerController {

    // Public Variables
    public Id accountRecordId { get; set; }
    public String groupValue { get; set; }
    public map<string,list<productWrapperController>> mapServiceProduct { get; set; }
    public list<productWrapperController> lstproductWrapperController { get; set; }
    // Private Variables
    // List to Insert Junction Object Records
    private list<MM_Account_Product_Relationship__c> insertRelationshipRecords = new list<MM_Account_Product_Relationship__c>();
    
    public ProductPickerController(){
        groupValue = '';
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        accountRecordId = currentRecordId;
        lstproductWrapperController = new list<productWrapperController>();
        mapServiceProduct = new map<string,list<productWrapperController>>();
        
        if(currentRecordId != NULL)
            fetchProductRecord(currentRecordId);
    }
    
    private void fetchProductRecord(Id recordId){
        // Current Record Details
        list<Account> lstAccount = [select id , name , Group_Size__c, ParentId from Account where id = : recordId];
        if(lstAccount.size() > 0) {
            for(Account lstAcc : lstAccount){
                if(lstAcc.Group_Size__c >= 250 &&  lstAcc.Group_Size__c <= 1000 ) {
                    groupValue = 'Select and VIP';  
                } else if(lstAcc.Group_Size__c > 1000 &&  lstAcc.Group_Size__c <= 5000 ) {
                    groupValue = 'VIP'; 
                }else {
                    groupValue = 'Standard';
                }   
            }   
        }   
        
        list<PP_Product__c> lstProductRecords = [select id , name ,Service__c, Service__r.Name , Type__c  from PP_Product__c];
        if(lstProductRecords.size() > 0){
            for(PP_Product__c objprod : lstProductRecords) {
                if (mapServiceProduct.containsKey(objprod.Service__r.Name)){
                    list<productWrapperController> listProductRecord = mapServiceProduct.get(objprod.Service__r.Name);
                    productWrapperController objproductWrapperController = new productWrapperController();
                    objproductWrapperController.selectedValue = false;
                    objproductWrapperController.strServiceRecord = objprod.Service__r.Name;
                    objproductWrapperController.strProductName = objprod.Name;
                    objproductWrapperController.strServiceId = objprod.Service__c;
                    objproductWrapperController.strProductId = objprod.Id;
                    objproductWrapperController.strProductType = objprod.Type__c;
                    listProductRecord.add(objproductWrapperController); 
                }else{
                    list<productWrapperController> listProductRecord = new list<productWrapperController>();
                    productWrapperController objproductWrapperController = new productWrapperController();
                    objproductWrapperController.selectedValue = false;
                    objproductWrapperController.strServiceRecord = objprod.Service__r.Name;
                    objproductWrapperController.strProductName = objprod.Name;
                    objproductWrapperController.strServiceId = objprod.Service__c;
                    objproductWrapperController.strProductId = objprod.Id;
                    objproductWrapperController.strProductType = objprod.Type__c;
                    listProductRecord.add(objproductWrapperController);
                    mapServiceProduct.put(objprod.Service__r.Name,listProductRecord); 
                }   
            }              
        }
        system.debug('==mapServiceProduct=='+mapServiceProduct);
    }
    
    // Insert Junction Object Records
    public pageReference SaveProductRecords(){  
        for(string mapData : mapServiceProduct.keySet()) {
            for(productWrapperController wrpData : mapServiceProduct.get(mapData)){
                if(wrpData.selectedValue){
                    insertAccountProductRecords(true,wrpData.strServiceId,wrpData.strProductId,accountRecordId);
                }   
            }
        }
        //insert insertRelationshipRecords;
        PageReference pageRef = new PageReference('/'+accountRecordId);
        pageRef.setRedirect(true);
        return pageRef;
    }   
    
    // Wrapper Class
    public class productWrapperController{
        public string strServiceRecord { get; set; }
        public boolean selectedValue { get; set; }
        public string strProductName { get; set; }
        public string strServiceId { get; set; }
        public string strProductId { get; set; }
        public string strProductType { get; set; }
        
        public productWrapperController(){
            strServiceId = '';
            strProductId = '';
            strServiceRecord = '';
            strProductName = '';
            strProductType = '';
            selectedValue = false;  
        }
    }
    
    // Method to insert data to Map
    private void insertAccountProductRecords(Boolean flagValue, String serviceId , String productId , String accountId){
        MM_Account_Product_Relationship__c objAccountProduct = new MM_Account_Product_Relationship__c();
        objAccountProduct.Selected_Record__c = flagValue;
        objAccountProduct.PP_Service__c = serviceId;
        objAccountProduct.PP_Product__c = productId;
        objAccountProduct.MM_Group_Name__c = accountId;
        insertRelationshipRecords.add(objAccountProduct);   
    }   
}