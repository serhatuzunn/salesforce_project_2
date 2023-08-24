public class customLookUpController {
    @AuraEnabled
    public static List<sObject> fetchLookUpValues(String searchKeyWord, String ObjectName,String filter) {
        String searchKey = searchKeyWord + '%';
        
        List<sObject> returnList = new List<sObject>();
         
        String sQuery ;
        system.debug(filter);
        if(filter == null){
            sQuery = 'select id, Name ,RC_Email__c from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
            system.debug(sQuery);
        }
        else{
           sQuery = 'select id, Name ,RC_Email__c from ' +ObjectName + ' where Name LIKE: searchKey and  ' + filter + ' order by createdDate DESC limit 5'; 
            system.debug(sQuery);
        }
        
        List<sObject> lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}