public with sharing class SearchController {
    @AuraEnabled
    public static List<sObject> search(String objectName, List<String> fields, String searchTerm, String whereClause){
        String searchKeyword = searchTerm + '*';
        String returningQuery = '';
        
        returningQuery = objectName+' ( Id, '+String.join(fields,',')+')';

        if(String.isNotBlank(whereClause)){
            returningQuery = returningQuery.removeEnd(')') + ' ' + whereClause + ')';
        }

        System.debug(' searchKeyword ::'+searchKeyword);
        String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery+' LIMIT 5';
        System.debug(' query :: '+query);
        List<List<sObject>> searchRecords = Search.Query(Query);
        System.debug(' searchRecords ::'+searchRecords);
        return searchRecords.get(0);
    }
}