public class RC_CustomSliders {
    
    
    public class ContentClass
    {
        @AuraEnabled
        public  string ContentName{get;set;}
        @AuraEnabled
        public  string ContentId{get;set;}
        @AuraEnabled
        public  string ContentImage{get;set;}
        @AuraEnabled
        public  string ContentListImage{get;set;}
        @AuraEnabled
        public  string ContentTitle{get;set;}
        @AuraEnabled
        public  boolean ContentIsShow{get;set;}
        @AuraEnabled
        public  string ContentDetail{get;set;}
        @AuraEnabled
        public  List<ContentClass> ContentDocumentLinks{get;set;}
        @AuraEnabled
        public  string ContentDetailLink{get;set;}
        @AuraEnabled
        public string ShortText{get;set;}
        @AuraEnabled
        public string DetailURL{get;set;}
    }
    
    @AuraEnabled
    public static List<ContentClass> getBanners(){
        string networkId = '';
        Network n = new Network();
        if(!test.isRunningTest())
        {
            networkId = network.getNetworkId();
            n = [SELECT Id, name, UrlPathPrefix FROM Network WHERE Id =: networkId];
        }
        
        else
        {
            n = [SELECT Id, name, UrlPathPrefix FROM Network WHERE Name = 'Vestel B2b'];
            networkId = n.Id;
        }
        
        List<String> contentTopics = new List<String>{'Banner'};
            Integer pageParam = 0;
        Integer pageSize = 100; 
        String myLanguage = 'en_US';
        String myContentType = 'VestelBanner';
        ConnectApi.ManagedContentVersionCollection contentData = ConnectApi.ManagedContent.getManagedContentByTopics(networkId, contentTopics,  pageParam, pageSize, myLanguage,myContentType);
        
        List<ContentClass> contentList = new List<ContentClass>();
        
        for(ConnectApi.ManagedContentVersion contentItem : contentData.items)
        {
            ContentClass cc = new ContentClass();
            cc.ContentName = contentItem.title;
            cc.ContentId = contentItem.contentKey;
            
            Map<String, ConnectApi.ManagedContentNodeValue> contentNodes = contentItem.contentNodes;
            
            for(string item : contentNodes.keySet())
            {
                system.debug('item:' + item);
                string cItem= JSON.serialize(contentNodes.get(item));
                Map<String, Object> m =(Map<String, Object>) JSON.deserializeUntyped(cItem);
                
                
                if(item=='BigImage')
                    cc.ContentImage   = '/' + n.UrlPathPrefix + (String)m.get('url');
                if(item=='DetailURL')
                {
                    system.debug('value:' + (String)m.get('value'));
                    cc.DetailURL   = '/' + n.UrlPathPrefix +  + '/s' + string.valueOf((String)m.get('value')).replace('amp;','');
                }
                else if(item=='Title')
                    cc.ContentTitle   =  ((String)m.get('value')).unescapeHtml4();
                else if(item=='ContentDetail')
                    cc.ContentDetail  =  ((String)m.get('value')).unescapeHtml4();
                else if(item=='EndDate')
                {
                    string endDate = (String)m.get('dateTimeValue');
                    endDate = endDate.replace('T',' ').replace('Z','');
                    cc.ContentIsShow =  dateTime.valueOf(endDate) > DateTime.now() ? true : false; 
                }
                else if(item=='ContentSlug')
                {
                    system.debug('slug');
                }
                
            }
            contentList.add(cc);
        }
        system.debug('res:' + JSON.serialize(contentList));
        return contentList;
    }  
    
    @AuraEnabled
    public static List<ContentClass> getContentsByTopic(string topicName){
        
        string networkId = '';
        Network n = new Network();
        if(!test.isRunningTest())
        {
            networkId = network.getNetworkId();
            n = [SELECT Id, name, UrlPathPrefix FROM Network WHERE Id =: networkId];
        }
        
        else
        {
            n = [SELECT Id, name, UrlPathPrefix FROM Network WHERE Name = 'Vestel B2b'];
            networkId = n.Id;
        }
        
        List<String> contentTopics = new List<String>{ topicName };
            Integer pageParam = 0;
        Integer pageSize = 100; 
        String myLanguage = 'en_US';
        String myContentType = 'VestelGenaralContent';
        ConnectApi.ManagedContentVersionCollection contentData = ConnectApi.ManagedContent.getManagedContentByTopics(networkId, contentTopics,  pageParam, pageSize, myLanguage,myContentType);
        
        List<ContentClass> contentList = new List<ContentClass>();
        if(contentData!=null && contentData.items.size()>0)
        {
            for(ConnectApi.ManagedContentVersion contentItem : contentData.items)
            {
                system.debug('c' + contentItem);
                ContentClass cc = new ContentClass();
                cc.ContentName = contentItem.title;
                cc.ContentId = contentItem.contentKey;
                cc.ContentDetailLink = '/' + n.UrlPathPrefix + '/s/contentdetail?contentId=' + contentItem.contentKey + '&topicName=' + topicName;
                Map<String, ConnectApi.ManagedContentNodeValue> contentNodes = contentItem.contentNodes;
                
                for(string item : contentNodes.keySet())
                {
                    system.debug('item:' + item);
                    string cItem= JSON.serialize(contentNodes.get(item));
                    Map<String, Object> m =(Map<String, Object>) JSON.deserializeUntyped(cItem);
                    
                    system.debug('m:' + m);
                    if(item=='BigImage')
                        cc.ContentImage   = '/' + n.UrlPathPrefix +  + (String)m.get('url');
                    else if(item=='ThumbImage')
                        cc.ContentListImage   = '/' + n.UrlPathPrefix +  + (String)m.get('url');
                    else if(item=='Title')
                        cc.ContentTitle   =  ((String)m.get('value')).unescapeHtml4();
                    else if(item=='ShortText')
                        cc.ShortText   =  ((String)m.get('value')).unescapeHtml4();
                    else if(item=='ContentDetail'){                    
                        String detail = string.valueOf((String)m.get('value')).length() > 200 ? string.valueOf((String)m.get('value')).substring(0,200) :(String)m.get('value') ;
                        cc.ContentDetail  =  detail.unescapeHtml4(); 
                    }
                    else if(item=='EndDate')
                    {
                        string endDate = (String)m.get('dateTimeValue');
                        endDate = endDate.replace('T',' ').replace('Z','');
                        cc.ContentIsShow =  dateTime.valueOf(endDate) > DateTime.now() ? true : false; 
                    }
                    
                }
                contentList.add(cc);
            }
            system.debug('res:' + JSON.serialize(contentList));
        }
        
        return contentList;
    }
    
    @AuraEnabled
    public static ContentClass getContentDetailById(string contentId){
        
        string networkId = '';
        Network n = new Network();
        if(!test.isRunningTest())
        {
            networkId = network.getNetworkId();
            n = [SELECT Id, name, UrlPathPrefix FROM Network WHERE Id =: networkId];
        }
        
        else
        {
            n = [SELECT Id, name, UrlPathPrefix FROM Network WHERE Name = 'Vestel B2b'];
            networkId = n.Id;
        }
        
        List<String> contentIds = new List<String>{ contentId };
            Integer pageParam = 0;
        Integer pageSize = 100; 
        String myLanguage = 'en_US';
        String myContentType = 'VestelGenaralContent';
        ConnectApi.ManagedContentVersionCollection contentData = ConnectApi.ManagedContent.getManagedContentByContentKeys(networkId, contentIds,  pageParam, pageSize, myLanguage,myContentType,true);
        system.debug('contentData:' + contentData);
        List<ContentClass> contentList = new List<ContentClass>();
        
        for(ConnectApi.ManagedContentVersion contentItem : contentData.items)
        {
            
            ContentClass cc = new ContentClass();
            cc.ContentName = contentItem.title;
            cc.ContentId = contentItem.contentKey;
            
            Map<String, ConnectApi.ManagedContentNodeValue> contentNodes = contentItem.contentNodes;
            
            for(string item : contentNodes.keySet())
            {
                system.debug('item:' + item);
                string cItem= JSON.serialize(contentNodes.get(item));
                Map<String, Object> m =(Map<String, Object>) JSON.deserializeUntyped(cItem);
                
                system.debug('m:' + m);
                if(item=='BigImage')
                    cc.ContentImage   = (String)m.get('url');
                else if(item=='ThumbImage')
                    cc.ContentListImage   = '/' + n.UrlPathPrefix  + (String)m.get('url');
                else if(item=='Title')
                    cc.ContentTitle   =  ((String)m.get('value')).unescapeHtml4();
                else if(item=='ContentDetail')
                    cc.ContentDetail  =  ((String)m.get('value')).unescapeHtml4();
                else if(item=='DocumentContentKey')
                {
                    List<string> documentIds = string.valueOf((String)m.get('value')).split(',');
                    if(documentIds.size()>0)
                    {
                        system.debug('documentIds:' + documentIds);
                        ConnectApi.ManagedContentVersionCollection documentData = ConnectApi.ManagedContent.getManagedContentByContentKeys(networkId, documentIds,  pageParam, pageSize, myLanguage,'cms_document',true);
                        List<ContentClass> documentList = new List<ContentClass>();
                        system.debug('docData:' + documentData);
                        for(ConnectApi.ManagedContentVersion documentItem : documentData.items)
                        {
                            system.debug('docItem:' + documentItem);
                            ContentClass dc = new ContentClass();
                            dc.ContentName = documentItem.title;
                            dc.ContentId =  '/' + n.UrlPathPrefix +'/cms/delivery/media/' + documentItem.contentKey;
                            documentList.add(dc);
                        }
                        cc.ContentDocumentLinks = documentList;
                        system.debug('cc:' + cc.ContentDocumentLinks);
                    }
                }
                
                else if(item=='EndDate')
                {
                    string endDate = (String)m.get('dateTimeValue');
                    endDate = endDate.replace('T',' ').replace('Z','');
                    cc.ContentIsShow =  dateTime.valueOf(endDate) > DateTime.now() ? true : false; 
                }
                
            }
            contentList.add(cc);
        }
        system.debug('res:' + JSON.serialize(contentList));
        return contentList.get(0);
    }
    @AuraEnabled
    public static string GetCommunityPath()
    {
        string networkId = '';
        Network n = new Network();
        if(!test.isRunningTest())
        {
            networkId = network.getNetworkId();
            n = [SELECT Id, name, UrlPathPrefix FROM Network WHERE Id =: networkId];
        }
        
        else
        {
            n = [SELECT Id, name, UrlPathPrefix FROM Network WHERE Name = 'Vestel B2b'];
            networkId = n.Id;
        }
        return n.UrlPathPrefix;
    }
    
    @AuraEnabled
    public static String GetResourceURL(String resourceName){
        
        string networkId = '';
        Network n = new Network();
        if(!test.isRunningTest())
        {
            networkId = network.getNetworkId();
            n = [SELECT Id, name, UrlPathPrefix FROM Network WHERE Id =: networkId];
        }
        
        else
        {
            n = [SELECT Id, name, UrlPathPrefix FROM Network WHERE Name = 'Vestel B2b'];
            networkId = n.Id;
        }
        
        List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];
        
        if(resourceList.size() == 1){
            
            String namespace = resourceList[0].NamespacePrefix;
            return '/' + n.UrlPathPrefix + '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
        }
        else return '';
    }
    
    
    
}