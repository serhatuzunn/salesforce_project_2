public class RC_CreditRiskJsonParser {
    
    public class Item {
        @AuraEnabled
        public String KUNNR;
        @AuraEnabled
        public String GJAHR;
        @AuraEnabled
        public String KMHYR;
        @AuraEnabled
        public String KRSLZ;
        @AuraEnabled
        public String TMDIT;
    }
    
    public ET_RETURN ET_RETURN;
    
    public class ET_RETURN {
        @AuraEnabled
        public List<Item_Y> item;
    }
    
    public class YENILENECEK_KLM {
        @AuraEnabled
        public List<Item_Z> item;
    }
    
    public class IPOTEK_DETAY {
        @AuraEnabled
        public List<Item_A> item;
    }
    public class TEMINAT_DETAY {
        @AuraEnabled
        public List<Item_A> item;
    }
    public class DTSTEMCEK_DETAY {
        @AuraEnabled
        public List<Item_A> item;
    }
    
    public class Item_A{
        @AuraEnabled
        public String BUKRS;
        @AuraEnabled
        public String BELNR;
        @AuraEnabled
        public String GJAHR;
        @AuraEnabled
        public String BUDAT;
        @AuraEnabled
        public String DMBTR;
        @AuraEnabled
        public String NETDT;
        @AuraEnabled
        public String XBLNR;
    }
    
    public class Item_Z {
        @AuraEnabled
        public String BUKRS;
        @AuraEnabled
        public String BELNR;
        @AuraEnabled
        public String GJAHR;
        @AuraEnabled
        public String BUDAT;
        @AuraEnabled
        public String XBLNR;
        @AuraEnabled
        public String NETDT;
        @AuraEnabled
        public String DMBTR;
        @AuraEnabled
        public String BANKA;
    }
    
    public class Item_Y {
        @AuraEnabled
        public String ZDATUM;
        @AuraEnabled
        public String BUKRS;
        @AuraEnabled
        public String KUNNR;
        @AuraEnabled
        public String GJAHR;
        @AuraEnabled
        public String ACIK_BKY {get;set;}
        @AuraEnabled
        public String ACIK_VALOR {get;set;}
        @AuraEnabled
        public String ACIK_VADE_TARIH {get;set;}
        @AuraEnabled
        public String ACIK_KREDI {get;set;}
        @AuraEnabled
        public String ACIK_BAGSIZ {get;set;}
        @AuraEnabled
        public String ACIK_BAGSIZ_VALOR {get;set;}
        @AuraEnabled
        public String ACIK_BAGSIZ_TARIH {get;set;}
        @AuraEnabled
        public String ACIK_HESAP_VALORU {get;set;}
        @AuraEnabled
        public String IPOTEK {get;set;}
        @AuraEnabled
        public IPOTEK_DETAY IPOTEK_DETAY;
        @AuraEnabled
        public String TEMINATIPOTEK {get;set;}
        @AuraEnabled
        public TEMINATIPOTEK_DETAY TEMINATIPOTEK_DETAY {get;set;}
        @AuraEnabled
        public String TEMINAT {get;set;}
        @AuraEnabled
        public TEMINAT_DETAY TEMINAT_DETAY;
        @AuraEnabled
        public String AVAL_KREDI {get;set;}
        @AuraEnabled
        public String AVAL_BONOSU {get;set;}
        @AuraEnabled
        public String EKYONETIM_LMT2 {get;set;}
        @AuraEnabled
        public String EK_KLIMA_LMT {get;set;}
        @AuraEnabled
        public String KUL_KLIMA_LMT {get;set;}
        @AuraEnabled
        public String EK_CEPTEL_LMT {get;set;}
        @AuraEnabled
        public String KUL_CEPTEL_LMT {get;set;}
        @AuraEnabled
        public String EK_KEA_LMT {get;set;}
        @AuraEnabled
        public String KUL_KEA_LMT {get;set;}
        @AuraEnabled
        public String EK_ACM_LMT {get;set;}
        @AuraEnabled
        public String KUL_ACM_LMT {get;set;}
        @AuraEnabled
        public String RISK_CIRO {get;set;}
        @AuraEnabled
        public String KMH_LIMIT {get;set;}
        @AuraEnabled
        public String KMH {get;set;}
        @AuraEnabled
        public String DBSBORC {get;set;}
        @AuraEnabled
        public String DBS_LIMIT {get;set;}
        @AuraEnabled
        public String BAYI_OLUS_TARIHI {get;set;}
        @AuraEnabled
        public String KREDI_TARIHI {get;set;}
        @AuraEnabled
        public String EMANET {get;set;}
        @AuraEnabled
        public String DTSTEMCEK {get;set;}
        @AuraEnabled
        public DTSTEMCEK_DETAY DTSTEMCEK_DETAY;
        @AuraEnabled
        public String RISK_SINIFI;
        @AuraEnabled
        public RISK_SINIFI_T RISK_SINIFI_T;
        @AuraEnabled
        public String YENILENECEK_TMNT {get;set;}
        @AuraEnabled
        public YENILENECEK_KLM YENILENECEK_KLM;
        @AuraEnabled
        public String KARSILIKSIZ_CEKLER {get;set;}
        @AuraEnabled
        public String PROTESTOLU_SENETLER {get;set;}
        @AuraEnabled
        public String IADELI_CEKLER {get;set;}
        @AuraEnabled
        public String IADELI_SENETLER {get;set;}
        @AuraEnabled
        public String TOP_RISK {get;set;}
        @AuraEnabled
        public String TOP_KREDI {get;set;}
        @AuraEnabled
        public String FARK_ASIM {get;set;}
        @AuraEnabled
        public String KONSINYE {get;set;}
        @AuraEnabled
        public String ALACAK_SIGORTA {get;set;}
        @AuraEnabled
        public KARSILIKSIZ_CEKLER_DETAY KARSILIKSIZ_CEKLER_DETAY;
        @AuraEnabled
        public PROTESTOLU_SENETLER_DETAY PROTESTOLU_SENETLER_DETAY;
        @AuraEnabled
        public IADELI_CEKLER_DETAY IADELI_CEKLER_DETAY;
        @AuraEnabled
        public IADELI_SENETLER_DETAY IADELI_SENETLER_DETAY;
    }
    
    public class TEMINATIPOTEK_DETAY{
        @AuraEnabled
        public List<Item_A> item;
    }
    
    
    public class KARSILIKSIZ_CEKLER_DETAY{
        @AuraEnabled
        public List<Item_P> item;
    }
    
    public class PROTESTOLU_SENETLER_DETAY{
        @AuraEnabled
        public List<Item_P> item;
    }
    
    public class IADELI_CEKLER_DETAY{
        @AuraEnabled
        public List<Item_P> item;
    }
    
    public class IADELI_SENETLER_DETAY{
        @AuraEnabled
        public List<Item_P> item; 
    }
    
    public class Item_P{
        @AuraEnabled
        public String TUTAR; 
        @AuraEnabled
        public String BORALA;
        @AuraEnabled
        public String VADE;
        @AuraEnabled
        public String WAERS;
        @AuraEnabled
        public String PORTF;
        @AuraEnabled
        public String BOENO; 
    }
    
    public class RISK_SINIFI_T {
        @AuraEnabled
        public List<Item> item;
    }
    
    
    public static RC_CreditRiskJsonParser parse(String json) {
        return (RC_CreditRiskJsonParser) System.JSON.deserialize(json, RC_CreditRiskJsonParser.class);
    }
}