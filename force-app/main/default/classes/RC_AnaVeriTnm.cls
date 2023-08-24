public class RC_AnaVeriTnm {
    
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
    
    //getUrunHierarchy Model
    public class ProductHierarchyModel
    {
        public string PRODH { get; set; }
        public string STUFE { get; set; }
        public string VTEXT { get; set; }
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
    
    public static Map<String, List<ProductHierarchyModel>> getUrunHierarchy(){
        RC_AnaVeriIntegrator.RequestModel model = new RC_AnaVeriIntegrator.RequestModel();
        model.IV_TANIM = 'X';
        model.IV_VKORG = '2201';
        model.IV_VTWEG = '01';
        model.IV_PACKAGE = '';
        model.IV_INDEX = '1';
        
        RC_AnaVeriIntegratorParser result = RC_AnaVeriIntegrator.getAnaVeri(model);


        
        
        List<ProductHierarchyModel> hierarchyLevel1 = new List<ProductHierarchyModel>();
        List<ProductHierarchyModel> hierarchyLevel2 = new List<ProductHierarchyModel>();
        List<ProductHierarchyModel> hierarchyLevel3 = new List<ProductHierarchyModel>();
        List<ProductHierarchyModel> hierarchyLevel4 = new List<ProductHierarchyModel>();
        List<ProductHierarchyModel> hierarchyLevel5 = new List<ProductHierarchyModel>();
        List<ProductHierarchyModel> hierarchyLevel6 = new List<ProductHierarchyModel>();
        List<ProductHierarchyModel> hierarchyLevel7 = new List<ProductHierarchyModel>();
        List<ProductHierarchyModel> hierarchyLevel8 = new List<ProductHierarchyModel>();
        List<ProductHierarchyModel> hierarchyLevel9 = new List<ProductHierarchyModel>();
        
        for(RC_AnaVeriIntegratorParser.Item_T hierarchyItem : result.ET_TNM_URUN_HIYERARSI.item){
            if(hierarchyItem.STUFE == '1'){
                ProductHierarchyModel productHierarchyModel = new ProductHierarchyModel();
                productHierarchyModel.PRODH = hierarchyItem.PRODH;
                productHierarchyModel.STUFE = hierarchyItem.STUFE;
                productHierarchyModel.VTEXT = hierarchyItem.VTEXT;
                
                hierarchyLevel1.add(productHierarchyModel);
            }
            else if(hierarchyItem.STUFE == '2'){
                ProductHierarchyModel productHierarchyModel = new ProductHierarchyModel();
                productHierarchyModel.PRODH = hierarchyItem.PRODH;
                productHierarchyModel.STUFE = hierarchyItem.STUFE;
                productHierarchyModel.VTEXT = hierarchyItem.VTEXT;
                
                hierarchyLevel2.add(productHierarchyModel);
            }
            else if(hierarchyItem.STUFE == '3'){
                ProductHierarchyModel productHierarchyModel = new ProductHierarchyModel();
                productHierarchyModel.PRODH = hierarchyItem.PRODH;
                productHierarchyModel.STUFE = hierarchyItem.STUFE;
                productHierarchyModel.VTEXT = hierarchyItem.VTEXT;
                
                hierarchyLevel3.add(productHierarchyModel);
            }
            else if(hierarchyItem.STUFE == '4'){
                ProductHierarchyModel productHierarchyModel = new ProductHierarchyModel();
                productHierarchyModel.PRODH = hierarchyItem.PRODH;
                productHierarchyModel.STUFE = hierarchyItem.STUFE;
                productHierarchyModel.VTEXT = hierarchyItem.VTEXT;
                
                hierarchyLevel4.add(productHierarchyModel);
            }
            else if(hierarchyItem.STUFE == '5'){
                ProductHierarchyModel productHierarchyModel = new ProductHierarchyModel();
                productHierarchyModel.PRODH = hierarchyItem.PRODH;
                productHierarchyModel.STUFE = hierarchyItem.STUFE;
                productHierarchyModel.VTEXT = hierarchyItem.VTEXT;
                
                hierarchyLevel5.add(productHierarchyModel);
            }
            else if(hierarchyItem.STUFE == '6'){
                ProductHierarchyModel productHierarchyModel = new ProductHierarchyModel();
                productHierarchyModel.PRODH = hierarchyItem.PRODH;
                productHierarchyModel.STUFE = hierarchyItem.STUFE;
                productHierarchyModel.VTEXT = hierarchyItem.VTEXT;
                
                hierarchyLevel6.add(productHierarchyModel);
            }
            else if(hierarchyItem.STUFE == '7'){
                ProductHierarchyModel productHierarchyModel = new ProductHierarchyModel();
                productHierarchyModel.PRODH = hierarchyItem.PRODH;
                productHierarchyModel.STUFE = hierarchyItem.STUFE;
                productHierarchyModel.VTEXT = hierarchyItem.VTEXT;
                
                hierarchyLevel7.add(productHierarchyModel);
            }
            else if(hierarchyItem.STUFE == '8'){
                ProductHierarchyModel productHierarchyModel = new ProductHierarchyModel();
                productHierarchyModel.PRODH = hierarchyItem.PRODH;
                productHierarchyModel.STUFE = hierarchyItem.STUFE;
                productHierarchyModel.VTEXT = hierarchyItem.VTEXT;
                
                hierarchyLevel8.add(productHierarchyModel);
            } 
            else if(hierarchyItem.STUFE == '9'){
                ProductHierarchyModel productHierarchyModel = new ProductHierarchyModel();
                productHierarchyModel.PRODH = hierarchyItem.PRODH;
                productHierarchyModel.STUFE = hierarchyItem.STUFE;
                productHierarchyModel.VTEXT = hierarchyItem.VTEXT;
                
                hierarchyLevel9.add(productHierarchyModel);
            } 
        }
        
        Map<String, List<ProductHierarchyModel>> hierarchyMap = new Map<String, List<ProductHierarchyModel>>();
        hierarchyMap.put('1', hierarchyLevel1);
        hierarchyMap.put('2', hierarchyLevel2);
        hierarchyMap.put('3', hierarchyLevel3);
        hierarchyMap.put('4', hierarchyLevel4);
        hierarchyMap.put('5', hierarchyLevel5);
        hierarchyMap.put('6', hierarchyLevel6);
        hierarchyMap.put('7', hierarchyLevel7);
        hierarchyMap.put('8', hierarchyLevel8);
        hierarchyMap.put('9', hierarchyLevel9);
        
        system.debug('hierarchyMap' + hierarchyMap);
        return hierarchyMap;
    }
    
    public static void saveUrunHierarchy(Map<String, List<ProductHierarchyModel>> hierarchyMap){
        try{
            system.debug('hierarchyMap : ' + hierarchyMap);
            
            for (String selectedMapKey : hierarchyMap.keySet()){
                List<ProductHierarchyModel> selectedhierarchyList =  hierarchyMap.get(selectedMapKey);
                system.debug('selectedhierarchyList : ' + selectedhierarchyList);
                system.debug('selectedhierarchyList count : ' + selectedhierarchyList.size());
                
                List<RC_Definition__c> definitionList = new List<RC_Definition__c>();
                for(ProductHierarchyModel x : selectedhierarchyList){
                    RC_Definition__c definition = new RC_Definition__c();
                    definition.Name = x.PRODH + '-' + x.VTEXT;
                    definition.RC_Value__c = x.PRODH;
                    definition.RC_Hierarchy_Level__c = Decimal.valueOf(selectedMapKey);
                    definition.RC_Upper_Hierarchy__c = x.PRODH.Substring(0, x.PRODH.length() - 2);
                    definition.Type__c = 'Product Hierarchy';
                    definition.RC_External_ID__c = 'Hierarchy-' + x.PRODH;
                    definitionList.add(definition);
                }
                
                system.debug('upsert list : ' + definitionList.size());
                
                List<Database.UpsertResult> resultList = Database.upsert(definitionList, RC_Definition__c.RC_External_ID__c, false);
                
                for (Database.UpsertResult rl : resultList) {
                    if (rl.isSuccess()) {
                        System.debug('Successfully id : ' + rl.getId());
                    }
                    else {              
                        for(Database.Error err : rl.getErrors()) {               
                            System.debug('Error : ' + err.getStatusCode() + ': ' + err.getMessage() + ' : ' + err.getFields());
                        }
                    }
                }     
            }
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
    
    public static RC_AnaVeriIntegratorParser getTnm(){
        RC_AnaVeriIntegrator.RequestModel model = new RC_AnaVeriIntegrator.RequestModel();
        model.IV_TANIM = 'X';
        model.IV_VKORG = '2201';
        model.IV_VTWEG = '01';
        model.IV_PACKAGE = '';
        model.IV_INDEX = '1';
        
        RC_AnaVeriIntegratorParser result = RC_AnaVeriIntegrator.getAnaVeri(model);
        system.debug('result : ' + result);
        
        
        return result;
    }
    
    public static void saveMarka(List<RC_AnaVeriIntegratorParser.Item_A> markaList, String globalValueSetId){
        try{   
            system.debug('markaList : ' + markaList);
            
            List<CustomValue> customValueList = new List<CustomValue>();
            
            for(RC_AnaVeriIntegratorParser.Item_A item : markaList){
                
                CustomValue customValue = new CustomValue();
                customValue.description = null;
                customValue.urls = null;
                customValue.color = null;
                customValue.default1 = false;
                customValue.isActive = true;
                customValue.label = item.BEZEI;
                customValue.valueName = item.ZZMARKA;
                
                customValueList.add(customValue);
            }
            
            Root root = new Root();
            root.FullName = 'RC_Brand';
            
            Metadata metadata = new Metadata();
            metadata.customValue = customValueList;
            metadata.description = null;
            metadata.urls = null;
            metadata.sorted = false;
            metadata.masterLabel = 'Brand';
            
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
    
    public static void saveMaterialMalzGroup(List<RC_AnaVeriIntegratorParser.Item_X> materialMalzGroupList, String globalValueSetId){
        try{               
            system.debug('materialMalzGroupList : ' + materialMalzGroupList);
            
            List<CustomValue> customValueList = new List<CustomValue>();
            
            for(RC_AnaVeriIntegratorParser.Item_X item : materialMalzGroupList){
                
                CustomValue customValue = new CustomValue();
                customValue.description = null;
                customValue.urls = null;
                customValue.color = null;
                customValue.default1 = false;
                customValue.isActive = true;
                customValue.label = item.BEZEI;
                customValue.valueName = item.MVGR2;
                
                customValueList.add(customValue);
            }
            
            Root root = new Root();
            root.FullName = 'RC_Material_Group_2';
            
            Metadata metadata = new Metadata();
            metadata.customValue = customValueList;
            metadata.description = null;
            metadata.urls = null;
            metadata.sorted = false;
            metadata.masterLabel = 'RC_Material_Group_2';
            
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
    
    public static void saveDepoYeri(List<RC_AnaVeriIntegratorParser.Item_Depo_Yeri> depoYeriList){
        try{
            system.debug('depoYeriList : ' + depoYeriList);
            
            List<RC_Definition__c> definitionList = new List<RC_Definition__c>();
            for(RC_AnaVeriIntegratorParser.Item_Depo_Yeri depoYeri : depoYeriList){
                RC_Definition__c definition = new RC_Definition__c();
                definition.Name = depoYeri.LGORT + ' - '+ depoYeri.LGOBE;
                definition.RC_Value__c = depoYeri.LGORT;
                definition.Type__c = 'Warehouse Place';
                definition.Production_Place_Txt__c = depoYeri.WERKS;
                definition.RC_External_ID__c = 'DepoYeri-' + depoYeri.WERKS +'-' + depoYeri.LGORT + '-' + depoYeri.LGOBE;
                definitionList.add(definition);
            }
            
            system.debug('upsert list : ' + definitionList);
            
            List<Database.UpsertResult> resultList = Database.upsert(definitionList, RC_Definition__c.RC_External_ID__c, true);
            
            for (Database.UpsertResult rl : resultList) {
                if (rl.isSuccess()) {
                    //System.debug('Successfully id : ' + rl.getId());
                }
                else {              
                    for(Database.Error err : rl.getErrors()) {               
                        System.debug('Error : ' + err.getStatusCode() + ': ' + err.getMessage() + ' : ' + err.getFields());
                    }
                }
            }     
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
    
    public static void saveUretimYeri(List<RC_AnaVeriIntegratorParser.Item_Uretim_Yeri> uretimYeriList){
        try{
            system.debug('uretimYeriList : ' + uretimYeriList);
            
            List<RC_Definition__c> definitionList = new List<RC_Definition__c>();
            for(RC_AnaVeriIntegratorParser.Item_Uretim_Yeri uretimYeri : uretimYeriList){
                RC_Definition__c definition = new RC_Definition__c();
                definition.Name = uretimYeri.WERKS + ' - '+ uretimYeri.NAME1;
                definition.RC_Value__c = uretimYeri.WERKS;
                definition.Type__c = 'Production Place';
                definition.RC_External_ID__c = 'UretimYeri-' + uretimYeri.WERKS + '-' + uretimYeri.NAME1;
                definitionList.add(definition);
            }
            
            system.debug('upsert list : ' + definitionList);
            
            List<Database.UpsertResult> resultList = Database.upsert(definitionList, RC_Definition__c.RC_External_ID__c, true);
            
            for (Database.UpsertResult rl : resultList) {
                if (rl.isSuccess()) {
                    //System.debug('Successfully id : ' + rl.getId());
                }
                else {              
                    for(Database.Error err : rl.getErrors()) {               
                        System.debug('Error : ' + err.getStatusCode() + ': ' + err.getMessage() + ' : ' + err.getFields());
                    }
                }
            }     
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
    
    public static void saveFiyatGrubu(List<RC_AnaVeriIntegratorParser.Item_Z> fiyatGrubuList){
        try{
            system.debug('fiyatGrubuList : ' + fiyatGrubuList);
            
            List<RC_Definition__c> definitionList = new List<RC_Definition__c>();
            for(RC_AnaVeriIntegratorParser.Item_Z fiyatGrubu : fiyatGrubuList){
                RC_Definition__c definition = new RC_Definition__c();
                definition.Name = fiyatGrubu.KONDM + ' - '+ fiyatGrubu.VTEXT;
                definition.RC_Value__c = fiyatGrubu.KONDM;
                definition.Type__c = 'Material Group';
                definition.RC_External_ID__c = 'FiyatGrubu-' + fiyatGrubu.KONDM + '-' + fiyatGrubu.VTEXT;
                definitionList.add(definition);
            }
            
            system.debug('upsert list : ' + definitionList);
            
            List<Database.UpsertResult> resultList = Database.upsert(definitionList, RC_Definition__c.RC_External_ID__c, true);
            
            for (Database.UpsertResult rl : resultList) {
                if (rl.isSuccess()) {
                    //System.debug('Successfully id : ' + rl.getId());
                }
                else {              
                    for(Database.Error err : rl.getErrors()) {               
                        System.debug('Error : ' + err.getStatusCode() + ': ' + err.getMessage() + ' : ' + err.getFields());
                    }
                }
            }     
        }
        catch (Exception ex) {
            system.debug('HATA : ' + ex.getMessage());
        }
    }
}