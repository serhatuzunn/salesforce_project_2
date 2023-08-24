public class RC_ServicesVPController {
    
    public class SelectOptionWrapper{
        @AuraEnabled
        public string label {get;set;}
        @AuraEnabled
        public string value {get;set;}
    }
    
    public class initWrapper{         
        @AuraEnabled
        public RC_ServicesVPJsonParser.ET_INFO ET_INFO{get;set;}       
    }
    
    @AuraEnabled(cacheable=true)
    public static list<SelectOptionWrapper> fillAuthority(){
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> ();        
        string sqlClause='SELECT RC_Value__c, Name FROM RC_Definition__c where RC_Active__c =true and Type__c =\'Authority\' order by  Name';
        System.debug('sql fillAuthority : '+sqlClause);
        list<RC_Definition__c> authorityList = database.query(sqlClause);
        
        if(authorityList.size()>0){
            SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
            EmptyValue.label = 'Seçiniz';
            EmptyValue.value = '0';
            resultList.add(EmptyValue);
            
            for(RC_Definition__c authority : authorityList){
                
                SelectOptionWrapper tempValues = new SelectOptionWrapper();
                
                tempValues.value = authority.RC_Value__c;
                tempValues.label = authority.Name;
                
                resultList.add(tempValues);
            }
        }
        return resultList;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<SelectOptionWrapper> fillCities(){
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> ();
        string sqlClause = 'SELECT RC_Code__C, Name FROM RC_City_Region__c where RC_Type__c =\'city\' and RC_Code__C != \'\' and RC_Code__C != \'999\' order by Name';
        
        System.debug('sql fillCities : '+sqlClause);
        list<RC_City_Region__c> cityList = database.query(sqlClause);
        
        if(cityList.size()>0){
            SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
            EmptyValue.label = 'Seçiniz';
            EmptyValue.value = '0';
            resultList.add(EmptyValue);
            
            for(RC_City_Region__c city : cityList){
                
                SelectOptionWrapper tempValues = new SelectOptionWrapper();
                
                tempValues.value = city.RC_Code__C;
                tempValues.label = city.Name;
                
                resultList.add(tempValues);
            }
        }
        return resultList;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<SelectOptionWrapper> fillRegions(string code){
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> ();
        string sqlClause = 'SELECT RC_Code__C, Name FROM RC_City_Region__c where RC_Type__c =\'region\' and RC_City__r.RC_Code__c = \''+code+'\' order by Name';
        
        System.debug('sql fillRegions : '+sqlClause);
        list<RC_City_Region__c> regionList = database.query(sqlClause);
        
        if(regionList.size()>0){
            SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
            EmptyValue.label = 'Seçiniz';
            EmptyValue.value = '0';
            resultList.add(EmptyValue);
            
            for(RC_City_Region__c region : regionList){
                
                SelectOptionWrapper tempValues = new SelectOptionWrapper();
                
                tempValues.value = region.RC_Code__C;
                tempValues.label = region.Name;
                
                resultList.add(tempValues);
            }
        }
        return resultList;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<SelectOptionWrapper> fillDistricts(string code){
        List<SelectOptionWrapper> resultList = new 	List<SelectOptionWrapper> ();
        string sqlClause = 'SELECT RC_Code__C, Name FROM RC_City_Region__c where RC_Type__c =\'district\' and RC_Region__r.RC_Code__c = \''+code+'\' order by Name';
        
        System.debug('sql fillDistricts : '+sqlClause);
        list<RC_City_Region__c> distictList = database.query(sqlClause);
        
        if(distictList.size()>0){
            SelectOptionWrapper EmptyValue = new SelectOptionWrapper();
            EmptyValue.label = 'Seçiniz';
            EmptyValue.value = '0';
            resultList.add(EmptyValue);
            
            for(RC_City_Region__c district : distictList){
                
                SelectOptionWrapper tempValues = new SelectOptionWrapper();
                
                tempValues.value = district.RC_Code__C;
                tempValues.label = district.Name;
                
                resultList.add(tempValues);
            }
        }
        return resultList;
    }
    
    @AuraEnabled(cacheable=true)
    public static string getServicesVP(string city, string region, string district, string authority){
        initWrapper result = new initWrapper();
        result.ET_INFO = new RC_ServicesVPJsonParser.ET_INFO ();
        result.ET_INFO.item = new List<RC_ServicesVPJsonParser.item> ();
        
        RC_ServicesVPIntegrator.requestModel req  = new RC_ServicesVPIntegrator.requestModel();
        RC_ServicesVPIntegrator.responseModel resp = new RC_ServicesVPIntegrator.responseModel();
        
        
        req.IV_IL_KODU = city;
        req.IV_ILCE_KODU = region;
        req.IV_SEMT_KODU = district == '0' || String.isEmpty(district) ||String.isEmpty(district)  ? '' : district;
        req.IV_YETKI_KODU = authority == '0' || String.isEmpty(authority) ||String.isEmpty(authority)  ? ''
            : authority.length() == 1 ? '0'+authority 
                : authority;
        
        System.debug('IV_IL_KODU : '+city);
        System.debug('IV_ILCE_KODU: '+region);
        System.debug('IV_SEMT_KODU : '+district);
        System.debug('authority : '+authority);
        
        resp = RC_ServicesVPIntegrator.getServicesVP(req);
        System.debug('resp: '+ JSON.serialize(resp));
        if(resp != null && resp.ET_INFO != null){
            result.ET_INFO = resp.ET_INFO;
            result.ET_INFO.item = resp.ET_INFO.item;
            
            initWrapper resultNew = setAuthorityData(result);
            
            System.debug('resultNew : '+JSON.serialize(result));
            return JSON.serialize(result);
        }
        System.debug('result : '+JSON.serialize(result));
        return JSON.serialize(result);
    }
    
    
    public static initWrapper setAuthorityData(initWrapper data){
        String result = '';
        list<SelectOptionWrapper> authList = fillAuthority();
        
        for(RC_ServicesVPJsonParser.item item : data.ET_INFO.item){
            String strAuthority ='';
            strAuthority = getAuthString(item.YETKINLIK.item);
            item.YETKINLIK2 = strAuthority;
        }
        
        return data;
    }
    
    public static String getAuthString(list<RC_ServicesVPJsonParser.Item_Z> serviceAuthList){
        String result='';
        
        for(RC_ServicesVPJsonParser.Item_Z serviceAuth : serviceAuthList){
            result = result + serviceAuth.DESCRIPTION+', ';            
        }
        
        result = result.length()>3 ?  result.substring(0,result.length()-2) : result;
        
        return result;
    }    
}