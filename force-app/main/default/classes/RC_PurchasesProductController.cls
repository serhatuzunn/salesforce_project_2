public class RC_PurchasesProductController {

    //Constructor with no arguments
    public RC_PurchasesProductController() 
    {        
    }
    
    public class SelectOptionWrapper{
        @AuraEnabled
        public string label {get;set;}
        @AuraEnabled
        public string value {get;set;}
    }
    
    
    @AuraEnabled(cacheable=true)
    public static list<SelectOptionWrapper> fillHierarchy(){        
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> (); 
        Schema.DescribeFieldResult fieldResultForCompany = Product2.RC_Product_hiy_Level_1__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();        
        
        SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
        EmptyValue.label = 'Seçiniz';
        EmptyValue.value = '0';
        resultList.add(EmptyValue);
        
        for(Schema.PicklistEntry pickListVal : ple){            
            SelectOptionWrapper tempValues = new SelectOptionWrapper();
            
            tempValues.value = pickListVal.getValue();
            tempValues.label = pickListVal.getLabel();
            
            resultList.add(tempValues);
        }
        
        return resultList;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<SelectOptionWrapper> fillHierarchy2(String selectedHierarchy){
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> (); 
        Schema.DescribeFieldResult fieldResultForCompany = Product2.RC_Product_hiy_Level_2__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();        
        
        SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
        EmptyValue.label = 'Seçiniz';
        EmptyValue.value = '0';
        resultList.add(EmptyValue);
        system.debug('ple: '+ ple);
        system.debug('selectedHierarchy: '+ selectedHierarchy);
        for(Schema.PicklistEntry pickListVal : ple){            
            if(pickListVal.getValue().substring(0,2).Contains(selectedHierarchy)) {                
                SelectOptionWrapper tempValues = new SelectOptionWrapper();
                
                tempValues.value = pickListVal.getValue();
                tempValues.label = pickListVal.getLabel();
                
                resultList.add(tempValues);
            }
        }
        
        return resultList; 
    }
    
    @AuraEnabled(cacheable=true)
    public static list<SelectOptionWrapper> fillHierarchy3(String selectedHierarchy2){
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> (); 
        Schema.DescribeFieldResult fieldResultForCompany = Product2.RC_Product_hiy_Level_3__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultForCompany.getPicklistValues();        
        
        SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
        EmptyValue.label = 'Seçiniz';
        EmptyValue.value = '0';
        resultList.add(EmptyValue);
        system.debug('ple: '+ ple);
        system.debug('selectedHierarchy: '+ selectedHierarchy2);
        for(Schema.PicklistEntry pickListVal : ple){            
            if(pickListVal.getValue().substring(0,4).Contains(selectedHierarchy2)) {                
                SelectOptionWrapper tempValues = new SelectOptionWrapper();
                
                tempValues.value = pickListVal.getValue();
                tempValues.label = pickListVal.getLabel();
                
                resultList.add(tempValues);
            }
        }
        
        return resultList; 
    }
}