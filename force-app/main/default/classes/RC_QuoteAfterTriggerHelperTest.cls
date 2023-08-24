@isTest
public class RC_QuoteAfterTriggerHelperTest {
   
      public class responseModel
      {
        public string bodyText{get;set;}
        public DateTime ExpirationDate{get;set;}
        public string WarrantyPeriod{get;set;}
        public decimal DeliveryTime2{get;set;}
        public string DeliveryTime{get;set;}  
        public string response{get;set;}  
        public string term {get;set;}
  
     }

    @isTest 
    public static void unitTest()
    { 
         responseModel resp = new responseModel();
         resp.bodyText = 'Zorlu Holding';
         resp.ExpirationDate = Date.valueOf('2022-01-01 00:00:00');
        
         Test.startTest();
     
        string body   =   RC_QuoteAfterTriggerHelper.GetBody(resp.bodyText);
        string teklif =   RC_QuoteAfterTriggerHelper.TeklifSartlari(resp.ExpirationDate, resp.WarrantyPeriod);
        string notlar =   RC_QuoteAfterTriggerHelper.Notlar(resp.WarrantyPeriod, resp.DeliveryTime, resp.DeliveryTime2, resp.term);
        string kamu   =   RC_QuoteAfterTriggerHelper.KamuSartlari(resp.WarrantyPeriod, resp.DeliveryTime, resp.DeliveryTime2, resp.term, resp.ExpirationDate);
        string notes  =   RC_QuoteAfterTriggerHelper.Notes(resp.WarrantyPeriod, resp.DeliveryTime, resp.DeliveryTime2, resp.term);
        string proposal = RC_QuoteAfterTriggerHelper.TermsOfOffer(resp.ExpirationDate, resp.WarrantyPeriod);
        
         Test.stopTest();
         system.debug('Body  : '+ body);
         system.debug('teklif  : '+ teklif);
         system.debug('notlar  : '+ notlar);
         system.debug('kamu  : '+ kamu);
        system.debug('notes  : '+ notes);
         system.debug('proposal  : '+ proposal);
     }

 }