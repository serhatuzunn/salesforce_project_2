public class RC_SD_GetStockParser {
    
    public class Item {
        @AuraEnabled
        public String WERKS;
        @AuraEnabled
        public String MAL_TANIM;
          @AuraEnabled
        public String MAL_GRUBU;
        @AuraEnabled
        public String LGORT;
        @AuraEnabled
        public String LGOBE;
        @AuraEnabled
        public String MATNR;
        @AuraEnabled
        public String MALZEME_TANIM;
        @AuraEnabled
        public String MARKA;
        @AuraEnabled
        public String SAT_STOK;
        @AuraEnabled
        public String VESTEL_STOK;
        @AuraEnabled
        public String URETICI_STOK;
        @AuraEnabled
        public String TES_MIK;
        @AuraEnabled
        public String TAHDITSIZ;
         @AuraEnabled
        public String KAYAR_ORT_FIYAT;
        @AuraEnabled
        public String BLOKE_STOK_TOPLAM;
        @AuraEnabled
        public DAGILIM_BILGILERI DAGILIM_BILGILERI;
        @AuraEnabled
        public BLOKE_STOK_DETAY BLOKE_STOK_DETAY;
           @AuraEnabled
        public TESLIMAT_DETAY TESLIMAT_DETAY;
    }
    
    public class ET_OUTPUT {
        @AuraEnabled
        public List<Item> item;
    }
    
    public class DAGILIM_BILGILERI {
        @AuraEnabled
        public List<ItemDagitim> item;
    }
    
    public class BLOKE_STOK_DETAY {
        @AuraEnabled
        public List<ItemBlokeStokDetay> item;
    }
    
     public class TESLIMAT_DETAY {
        @AuraEnabled
        public List<ItemTeslimat> item;
    }
    
    public class ItemDagitim {
        @AuraEnabled
        public String BOLGE;
        @AuraEnabled
        public String BOLGE_TANIM;
        @AuraEnabled
        public String ORAN;
        @AuraEnabled
        public String GRUP;
        @AuraEnabled
        public String GRUP_TANIM;
        @AuraEnabled
        public String BOLGE_DAGILIM_STOK;
        @AuraEnabled
        public String BOLGE_KULL_STOK;
    }
    
    public class ItemBlokeStokDetay {
        @AuraEnabled
        public String MUSTERI_NO;
        @AuraEnabled
        public String MUSTERI_AD;
        @AuraEnabled
        public String BLOKAJ_EK_TARIH;
        @AuraEnabled
        public String BLOKE_STOK;
    }
    public class ItemTeslimat {
        @AuraEnabled
        public String MUSTERI_NO;
        @AuraEnabled
        public String MUSTERI_AD;
        @AuraEnabled
        public String SIPARIS_NO;
        @AuraEnabled
        public String SIPARIS_KALEM;
        @AuraEnabled
       public String MATNR;
        @AuraEnabled
        public String LGORT;
        @AuraEnabled
        public String WERKS;
        @AuraEnabled
        public String ACIK_MIKTAR;
    }
    
    @AuraEnabled
    public ET_OUTPUT ET_OUTPUT;
    @AuraEnabled
    public String EV_MESSAGE;
    
    
    public static RC_SD_GetStockParser parse(String json) {
        return (RC_SD_GetStockParser) System.JSON.deserialize(json, RC_SD_GetStockParser.class);
    }
}