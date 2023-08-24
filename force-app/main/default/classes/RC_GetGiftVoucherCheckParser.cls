public class RC_GetGiftVoucherCheckParser {

     public class ES_CEK_S {
        @AuraEnabled
        public string MANDT;
         @AuraEnabled
        public string CEKNO;
         @AuraEnabled
        public string CEKTIPI;
         @AuraEnabled
        public string MUSTNO;
         @AuraEnabled
        public string TCKNO;
         @AuraEnabled
        public string ADSOYAD;
         @AuraEnabled
        public string WAERS;
         @AuraEnabled
        public string TUTAR;
         @AuraEnabled
        public string SERVISNO;
         @AuraEnabled
        public string CDATE;
         @AuraEnabled
        public string CTIME;
         @AuraEnabled
        public string CUSER;
         @AuraEnabled
        public string CHDATE;
         @AuraEnabled
        public string CHTIME;
         @AuraEnabled
        public string CHUSER;
         @AuraEnabled
        public string DURUM;
         @AuraEnabled
        public string BAYI;
         @AuraEnabled
        public string MATBUNO;
       
    
    }
    
     @AuraEnabled
    public ES_CEK_S ES_CEK_S;
    
     @AuraEnabled
    public string EV_MESSAGE;
        
           @AuraEnabled
    public string EV_SUCCESS;
    
          @AuraEnabled
    public string EV_CEKNO;
    
    
      public static RC_GetGiftVoucherCheckParser parse(String json) {
        return (RC_GetGiftVoucherCheckParser) System.JSON.deserialize(json, RC_GetGiftVoucherCheckParser.class);
    }
    

}