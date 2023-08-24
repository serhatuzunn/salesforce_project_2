public class RC_DeltaCustomerTnm {
    
    //saveMarka Model
    public class CustomValue
    {
        public String color { get; set; }
        
        public Boolean default1 { get; set; }
        
        public String description { get; set; }
        
        public Boolean isActive { get; set; }
        
        public String label { get; set; }
        
        public String urls { get; set; }
        
        public String valueName { get; set; }
    }
    
    public class Metadata
    {
        public List<CustomValue> customValue { get; set; }
        
        public object description { get; set; }
        
        public string masterLabel { get; set; }
        
        public Boolean sorted { get; set; }
        
        public object urls { get; set; }
    }
    
    public class Root
    {
        public Metadata Metadata { get; set; }
        
        public String FullName { get; set; }
    }
    
    //getGlobalValueSetUrlId Model
    public class GlobalValueSetUrlJson
    {
        public Integer size { get; set; }
        
        public Integer totalSize { get; set; }
        
        public Boolean done { get; set; }
        
        public object queryLocator { get; set; }
        
        public string entityTypeName { get; set; }
        
        public List<Record> records { get; set; }
    }
    
    public class Attributes
    {
        public string type { get; set; }
        
        public string url { get; set; }
    }
    
    public class Record
    {
        public Attributes attributes { get; set; }
        
        public string Id { get; set; }
        
        public string DeveloperName { get; set; }
    }
    
    public static String getGlobalValueSetUrlId(String developerName){
        system.debug('developerName : ' + developerName);
        try{
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(100000);
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v50.0/tooling/query?q=select+id,+developername+from+globalvalueset');
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('GET');
            system.debug('req :' + req.getBody());
            HttpResponse res = http.send(req);
            system.debug('res : ' + res.getBody());
            
            GlobalValueSetUrlJson globalValueSetUrlJson = (GlobalValueSetUrlJson)Json.deserialize(res.getBody(),GlobalValueSetUrlJson.class);
            
            Map<String, String> developerNameMap = new  Map<String, String>();
            for(Record record : globalValueSetUrlJson.records){
                if(record.DeveloperName == developerName){
                    system.debug('record.Id : ' + record.Id);
                    return record.Id;
                }
            }
            return null;
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
            return null;
        }
    }
    
    public static RC_DeltaCustomerIntegratorParser getTnm(String yaratTrh, String degisTrh){
        RC_DeltaCustomerIntegrator.RequestModel model = new RC_DeltaCustomerIntegrator.RequestModel();
        model.IV_YARAT_TRH = yaratTrh;
        model.IV_TANIM = 'X';
        model.IV_DEGIS_TRH = degisTrh;
        
        RC_DeltaCustomerIntegratorParser result = RC_DeltaCustomerIntegrator.getDeltaCustomer(model);
        system.debug('result : ' + result);
        
        return result;
    }
    
    public static void saveDgtmKanal(List<RC_DeltaCustomerIntegratorParser.Item> dgtmKanalList, String globalValueSetId, String fullName, String masterLabel){
        try{   
            system.debug('dgtmKanalList : ' + dgtmKanalList);
            
            List<CustomValue> customValueList = new List<CustomValue>();
            
            for(RC_DeltaCustomerIntegratorParser.Item item : dgtmKanalList){
                if(String.isNotBlank(item.VTWEG) && String.isNotBlank(item.VTEXT)){
                    CustomValue customValue = new CustomValue();
                    customValue.description = null;
                    customValue.urls = null;
                    customValue.color = null;
                    customValue.default1 = false;
                    customValue.isActive = true;
                    customValue.label = item.VTWEG + ' - ' + item.VTEXT;
                    customValue.valueName = item.VTWEG;
                    
                    customValueList.add(customValue);
                }
                
            }
            
            Root root = new Root();
            root.FullName = fullName;
            
            Metadata metadata = new Metadata();
            metadata.customValue = customValueList;
            metadata.description = null;
            metadata.urls = null;
            metadata.sorted = false;
            metadata.masterLabel = masterLabel;
            
            root.Metadata = metadata;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(100000);
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v50.0/tooling/sobjects/GlobalValueSet/' + globalValueSetId);
            req.setBody(JSON.serialize(root).replace('default1', 'default'));
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('PATCH');
            system.debug('req :' + req.getBody());
            HttpResponse res = http.send(req);
            system.debug('res : ' + res.getBody());        
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
    public static void saveFtrBlgTr(List<RC_DeltaCustomerIntegratorParser.Item_Z> frBlgTrList, String globalValueSetId, String fullName, String masterLabel){
        try{   
            system.debug('frBlgTrList : ' + frBlgTrList);
            
            List<CustomValue> customValueList = new List<CustomValue>();
            
            for(RC_DeltaCustomerIntegratorParser.Item_Z item : frBlgTrList){
                if(String.isNotBlank(item.FKART) && String.isNotBlank(item.VTEXT)){
                    CustomValue customValue = new CustomValue();
                    customValue.description = null;
                    customValue.urls = null;
                    customValue.color = null;
                    customValue.default1 = false;
                    customValue.isActive = true;
                    customValue.label = item.FKART + ' - ' + item.VTEXT;
                    customValue.valueName = item.FKART;
                    
                    customValueList.add(customValue);
                }
                
            }
            
            Root root = new Root();
            root.FullName = fullName;
            
            Metadata metadata = new Metadata();
            metadata.customValue = customValueList;
            metadata.description = null;
            metadata.urls = null;
            metadata.sorted = false;
            metadata.masterLabel = masterLabel;
            
            root.Metadata = metadata;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(100000);
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v50.0/tooling/sobjects/GlobalValueSet/' + globalValueSetId);
            req.setBody(JSON.serialize(root).replace('default1', 'default'));
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('PATCH');
            system.debug('req :' + req.getBody());
            HttpResponse res = http.send(req);
            system.debug('res : ' + res.getBody());        
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
    public static void saveKrediKntr(List<RC_DeltaCustomerIntegratorParser.Item_Y> krediKntrList, String globalValueSetId, String fullName, String masterLabel){
        try{   
            system.debug('krediKntrList : ' + krediKntrList);
            
            List<CustomValue> customValueList = new List<CustomValue>();
            
            for(RC_DeltaCustomerIntegratorParser.Item_Y item : krediKntrList){
                if(String.isNotBlank(item.KKBER) && String.isNotBlank(item.KKBTX)){
                    CustomValue customValue = new CustomValue();
                    customValue.description = null;
                    customValue.urls = null;
                    customValue.color = null;
                    customValue.default1 = false;
                    customValue.isActive = true;
                    customValue.label = item.KKBER + ' - ' + item.KKBTX;
                    customValue.valueName = item.KKBER;
                    
                    customValueList.add(customValue);
                }
                
            }
            
            Root root = new Root();
            root.FullName = fullName;
            
            Metadata metadata = new Metadata();
            metadata.customValue = customValueList;
            metadata.description = null;
            metadata.urls = null;
            metadata.sorted = false;
            metadata.masterLabel = masterLabel;
            
            root.Metadata = metadata;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(100000);
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v50.0/tooling/sobjects/GlobalValueSet/' + globalValueSetId);
            req.setBody(JSON.serialize(root).replace('default1', 'default'));
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('PATCH');
            system.debug('req :' + req.getBody());
            HttpResponse res = http.send(req);
            system.debug('res : ' + res.getBody());        
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
    public static void saveMustGrubu(List<RC_DeltaCustomerIntegratorParser.Item_X> mustGrubuList, String globalValueSetId, String fullName, String masterLabel){
        try{   
            system.debug('mustGrubuList : ' + mustGrubuList);
            
            List<CustomValue> customValueList = new List<CustomValue>();
            
            for(RC_DeltaCustomerIntegratorParser.Item_X item : mustGrubuList){
                if(String.isNotBlank(item.KDGRP) && String.isNotBlank(item.KTEXT)){
                    CustomValue customValue = new CustomValue();
                    customValue.description = null;
                    customValue.urls = null;
                    customValue.color = null;
                    customValue.default1 = false;
                    customValue.isActive = true;
                    customValue.label = item.KDGRP + ' - ' + item.KTEXT;
                    customValue.valueName = item.KDGRP;
                    
                    customValueList.add(customValue);
                }
                
            }
            
            Root root = new Root();
            root.FullName = fullName;
            
            Metadata metadata = new Metadata();
            metadata.customValue = customValueList;
            metadata.description = null;
            metadata.urls = null;
            metadata.sorted = false;
            metadata.masterLabel = masterLabel;
            
            root.Metadata = metadata;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(100000);
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v50.0/tooling/sobjects/GlobalValueSet/' + globalValueSetId);
            req.setBody(JSON.serialize(root).replace('default1', 'default'));
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('PATCH');
            system.debug('req :' + req.getBody());
            HttpResponse res = http.send(req);
            system.debug('res : ' + res.getBody());        
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
    public static void saveSatisBuro(List<RC_DeltaCustomerIntegratorParser.Item_W> satisBuroList, String globalValueSetId, String fullName, String masterLabel){
        try{   
            system.debug('satisBuroList : ' + satisBuroList);
            
            List<CustomValue> customValueList = new List<CustomValue>();
            
            for(RC_DeltaCustomerIntegratorParser.Item_W item : satisBuroList){
                if(String.isNotBlank(item.VKBUR) && String.isNotBlank(item.BEZEI)){
                    CustomValue customValue = new CustomValue();
                    customValue.description = null;
                    customValue.urls = null;
                    customValue.color = null;
                    customValue.default1 = false;
                    customValue.isActive = true;
                    customValue.label = item.VKBUR + ' - ' + item.BEZEI;
                    customValue.valueName = item.VKBUR;
                    
                    customValueList.add(customValue);
                }
                
            }
            
            Root root = new Root();
            root.FullName = fullName;
            
            Metadata metadata = new Metadata();
            metadata.customValue = customValueList;
            metadata.description = null;
            metadata.urls = null;
            metadata.sorted = false;
            metadata.masterLabel = masterLabel;
            
            root.Metadata = metadata;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(100000);
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v50.0/tooling/sobjects/GlobalValueSet/' + globalValueSetId);
            req.setBody(JSON.serialize(root).replace('default1', 'default'));
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('PATCH');
            system.debug('req :' + req.getBody());
            HttpResponse res = http.send(req);
            system.debug('res : ' + res.getBody());        
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
    public static void saveSatisMdr(List<RC_DeltaCustomerIntegratorParser.Item_V> satisMdrList, String globalValueSetId, String fullName, String masterLabel){
        try{   
            system.debug('satisMdrList : ' + satisMdrList);
            
            List<CustomValue> customValueList = new List<CustomValue>();
            
            for(RC_DeltaCustomerIntegratorParser.Item_V item : satisMdrList){
                if(String.isNotBlank(item.VKGRP) && String.isNotBlank(item.BEZEI)){
                    CustomValue customValue = new CustomValue();
                    customValue.description = null;
                    customValue.urls = null;
                    customValue.color = null;
                    customValue.default1 = false;
                    customValue.isActive = true;
                    customValue.label = item.VKGRP + ' - ' + item.BEZEI;
                    customValue.valueName = item.VKGRP;
                    
                    customValueList.add(customValue);
                }
                
            }
            
            Root root = new Root();
            root.FullName = fullName;
            
            Metadata metadata = new Metadata();
            metadata.customValue = customValueList;
            metadata.description = null;
            metadata.urls = null;
            metadata.sorted = false;
            metadata.masterLabel = masterLabel;
            
            root.Metadata = metadata;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(100000);
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v50.0/tooling/sobjects/GlobalValueSet/' + globalValueSetId);
            req.setBody(JSON.serialize(root).replace('default1', 'default'));
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('PATCH');
            system.debug('req :' + req.getBody());
            HttpResponse res = http.send(req);
            system.debug('res : ' + res.getBody());        
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
    public static void saveSatisOrg(List<RC_DeltaCustomerIntegratorParser.Item_U> satisOrgList, String globalValueSetId, String fullName, String masterLabel){
        try{   
            system.debug('satisOrgList : ' + satisOrgList);
            
            List<CustomValue> customValueList = new List<CustomValue>();
            
            for(RC_DeltaCustomerIntegratorParser.Item_U item : satisOrgList){
                if(String.isNotBlank(item.VKORG) && String.isNotBlank(item.VTEXT)){
                    CustomValue customValue = new CustomValue();
                    customValue.description = null;
                    customValue.urls = null;
                    customValue.color = null;
                    customValue.default1 = false;
                    customValue.isActive = true;
                    customValue.label = item.VKORG + ' - ' + item.VTEXT;
                    customValue.valueName = item.VKORG;
                    
                    customValueList.add(customValue);
                }
                
            }
            
            Root root = new Root();
            root.FullName = fullName;
            
            Metadata metadata = new Metadata();
            metadata.customValue = customValueList;
            metadata.description = null;
            metadata.urls = null;
            metadata.sorted = false;
            metadata.masterLabel = masterLabel;
            
            root.Metadata = metadata;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(100000);
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v50.0/tooling/sobjects/GlobalValueSet/' + globalValueSetId);
            req.setBody(JSON.serialize(root).replace('default1', 'default'));
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('PATCH');
            system.debug('req :' + req.getBody());
            HttpResponse res = http.send(req);
            system.debug('res : ' + res.getBody());        
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
    public static void saveTeslBlgTr(List<RC_DeltaCustomerIntegratorParser.Item_T> teslBlgTrList, String globalValueSetId, String fullName, String masterLabel){
        try{   
            system.debug('teslBlgTrList : ' + teslBlgTrList);
            
            List<CustomValue> customValueList = new List<CustomValue>();
            
            for(RC_DeltaCustomerIntegratorParser.Item_T item : teslBlgTrList){
                if(String.isNotBlank(item.LFART) && String.isNotBlank(item.VTEXT)){
                    CustomValue customValue = new CustomValue();
                    customValue.description = null;
                    customValue.urls = null;
                    customValue.color = null;
                    customValue.default1 = false;
                    customValue.isActive = true;
                    customValue.label = item.LFART + ' - ' + item.VTEXT;
                    customValue.valueName = item.LFART;
                    
                    customValueList.add(customValue);
                }                
                
            }
            
            Root root = new Root();
            root.FullName = fullName;
            
            Metadata metadata = new Metadata();
            metadata.customValue = customValueList;
            metadata.description = null;
            metadata.urls = null;
            metadata.sorted = false;
            metadata.masterLabel = masterLabel;
            
            root.Metadata = metadata;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(100000);
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v50.0/tooling/sobjects/GlobalValueSet/' + globalValueSetId);
            req.setBody(JSON.serialize(root).replace('default1', 'default'));
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('PATCH');
            system.debug('req :' + req.getBody());
            HttpResponse res = http.send(req);
            system.debug('res : ' + res.getBody());        
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
}