trigger QuoteAfterTrigger on Quote (after insert , after update) {
    
    
    List<Quote> quoteList = new List<Quote>();
    for(Quote q : Trigger.new){
        Quote clone = new Quote(id = q.id);
        if(Trigger.IsUpdate){
            if(q.RC_Term__c != Trigger.oldMap.get(q.id).RC_Term__c || q.RC_Delivery_time__c != Trigger.oldMap.get(q.id).RC_Delivery_time__c || q.ExpirationDate != Trigger.oldMap.get(q.id).ExpirationDate || q.Delivery_time__c != Trigger.oldMap.get(q.id).Delivery_time__c || q.RC_Warranty_Period__c != Trigger.oldMap.get(q.id).RC_Warranty_Period__c){
                
                //Teklif Şartları
                string teklifSartlari = RC_QuoteAfterTriggerHelper.TeklifSartlari(q.ExpirationDate,q.RC_Warranty_Period__c);
                clone.RC_Terms_of_Offer__c = teklifSartlari;
                clone.RC_Nonvestel_Zincir_Terms_of_Offer__c = teklifSartlari;
                
                //Notlar
                string notlar = RC_QuoteAfterTriggerHelper.Notlar(q.RC_Warranty_Period__c,q.Delivery_time__c,q.RC_Delivery_time__c,q.RC_Term__c);
                clone.RC_Notes__c  =notlar;
                clone.RC_Nonvestel_Zincir_Notes__c = notlar;
                
                //Kamu Teklif Şartları
                string kamuSartlari = RC_QuoteAfterTriggerHelper.KamuSartlari(q.RC_Warranty_Period__c,q.Delivery_time__c,q.RC_Delivery_time__c,q.RC_Term__c,q.ExpirationDate); 
                clone.RC_Public_General_Terms__c = kamuSartlari;
                quoteList.add(clone); 
                
                //Ingilizce
                string engTermsOfOffer = RC_QuoteAfterTriggerHelper.TermsOfOffer(q.ExpirationDate,q.RC_Warranty_Period__c);
                string engNotes = RC_QuoteAfterTriggerHelper.Notes(q.RC_Warranty_Period__c,q.Delivery_time__c,q.RC_Delivery_time__c,q.RC_Term__c);
                clone.RC_Terms_of_Offer_ENG__c = engTermsOfOffer;
                clone.RC_Notes_ENG__c = engNotes;
            }
        } 
        else if(Trigger.IsInsert)
        {    
                //Teklif Şartları
                string teklifSartlari = RC_QuoteAfterTriggerHelper.TeklifSartlari(q.ExpirationDate,q.RC_Warranty_Period__c);
                clone.RC_Terms_of_Offer__c = teklifSartlari;
                clone.RC_Nonvestel_Zincir_Terms_of_Offer__c = teklifSartlari;
                
                //Notlar
                string notlar = RC_QuoteAfterTriggerHelper.Notlar(q.RC_Warranty_Period__c,q.Delivery_time__c,q.RC_Delivery_time__c,q.RC_Term__c);
                clone.RC_Notes__c  =notlar;
                clone.RC_Nonvestel_Zincir_Notes__c = notlar;
                
                //Kamu Teklif Şartları
                string kamuSartlari = RC_QuoteAfterTriggerHelper.KamuSartlari(q.RC_Warranty_Period__c,q.Delivery_time__c,q.RC_Delivery_time__c,q.RC_Term__c,q.ExpirationDate); 
                clone.RC_Public_General_Terms__c = kamuSartlari;
                quoteList.add(clone); 
            
            	//Ingilizce
                string engTermsOfOffer = RC_QuoteAfterTriggerHelper.TermsOfOffer(q.ExpirationDate,q.RC_Warranty_Period__c);
                string engNotes = RC_QuoteAfterTriggerHelper.Notes(q.RC_Warranty_Period__c,q.Delivery_time__c,q.RC_Delivery_time__c,q.RC_Term__c);
                clone.RC_Terms_of_Offer_ENG__c = engTermsOfOffer;
                clone.RC_Notes_ENG__c = engNotes;
         }
       
        }

    if(quoteList.size() > 0){
        List<Database.SaveResult> srList = new List<Database.SaveResult>();
        try{
            srList = Database.update(quoteList,false);
            system.debug('Quote SrList : ' + srList);
        }catch(Exception ex){
            system.debug('Quote After Trigger Exception : ' + ex.getMessage());
        }
    }
    
    
    
}