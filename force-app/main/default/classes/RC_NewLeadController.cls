public class RC_NewLeadController {
    
    @AuraEnabled
    public static string getRecordTypeIdByDeveloperName(string recordTypeId)
    {
        RecordType leadrecordType = [SELECT Id,DeveloperName FROM RecordType Where Id =: recordTypeId];
        String customRecordTypeId ='';
        try{
            customRecordTypeId = Schema.SObjectType.MYS_Open_Request__c.getRecordTypeInfosByDeveloperName().get(leadrecordType.DeveloperName).getRecordTypeId();
        }
        catch(Exception ex)
        {
            customRecordTypeId = null;
            system.debug(ex);
        }
        return customRecordTypeId;
    }    
    @AuraEnabled
    public static string getRecordTypes()
    {
        List<String> leadRecordTypes = getLeadRecordTypes();
        system.debug(leadRecordTypes);
        List<RecordTypeDef> recordTypeList = new List<RecordTypeDef>();
        Set<string> addedMYS = new Set<string>();
        List<Map<string,string>> retVal = new List<Map<string,string>>();
        Schema.DescribeSObjectResult R = MYS_Open_Request__c.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        for(Schema.RecordTypeInfo rtItem : RT)
        {
            system.debug(rtItem);
            Map<string,string> option = new Map<string,string>();
            if(rtItem.developername != '')
            {
                RecordTypeDef def = new RecordTypeDef();
                def.label = rtItem.getName();
                def.value = rtItem.getRecordTypeId();
                def.sobjectName = 'MYS_Open_Request__c'; 
                def.developerName = rtItem.developername;
                if(!rtItem.isMaster() && rtItem.active)
                {
                    if(leadRecordTypes.contains(rtItem.developername) ) 
                    {    
                        recordTypeList.add(def); 
                        addedMYS.add(rtItem.developername);
                    }
                }
            }
        }
        Schema.DescribeSObjectResult RLead = Lead.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RTLead = RLead.getRecordTypeInfos();
        for(Schema.RecordTypeInfo rtItem : RTLead)
        {
            
            if(rtItem.developername != '')
            {
                if(!rtItem.isMaster() && rtItem.active && rtItem.available && !addedMYS.contains(rtItem.developername))
                {
                    RecordTypeDef def = new RecordTypeDef();
                    def.label = rtItem.getName();
                    def.value = rtItem.getRecordTypeId();
                    def.sobjectName = 'Lead';
                    def.developerName = rtItem.developername;
                    recordTypeList.add(def); 
                }
            }
        }
        return JSON.serialize(recordTypeList);        
    }
    @AuraEnabled
    public static List<string> getLeadRecordTypes()
    {
        List<string> retVal = new List<string>();
        Schema.DescribeSObjectResult R = Lead.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        for(Schema.RecordTypeInfo rtItem : RT)
        {
            system.debug(rtItem);
            if(rtItem.developername != '')
            {
                if(!rtItem.isMaster()) retVal.add(rtItem.developername);
            }
        }
        return retVal;
    }
    public class RecordTypeDef
    {
        public string label {get; set;}
        public string value {get; set;}
        public string sobjectName {get; set;}
        public string developerName {get; set;}
    }
}