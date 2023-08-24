trigger ContentVersionTrigger on ContentVersion (after insert, after update) {
    
    if(Trigger.IsAfter){
        if(Trigger.isUpdate){
            for(ContentVersion cv : Trigger.new){
                ContentVersion oldCV = Trigger.oldMap.get(cv.Id);
                
                List<ContentDocumentLink> cdlList = [SELECT LinkedEntityId, Visibility FROM ContentDocumentLink WHERE ContentDocumentId =: cv.contentDocumentId];
                
                        System.debug('cdlList : ' + cdlList);
                if(cdlList != null && cdlList.size() > 0){
                    String entityId = '';
                    for(ContentDocumentLink cdl : cdlList){
                        System.debug('cdl.Visibility : ' + cdl.Visibility);
                        if(cdl.Visibility == 'InternalUsers'){
                            entityId = cdl.LinkedEntityId;
                        }
                    }
                    
                    if(String.isNotBlank(entityId)){
                        Map<String, String> params = new Map<String, String>();        
                        params.put('NoteId', cv.ContentDocumentId);
                        params.put('TaskId', entityId);
                        
                        Flow.Interview.Send_Notification_to_Note_Owners noteAlertFlow = new Flow.Interview.Send_Notification_to_Note_Owners(params);
                        if(!Test.isRunningTest()){
                            noteAlertFlow.start();
                        }
                    }
                } 
            }
        }
    }
}