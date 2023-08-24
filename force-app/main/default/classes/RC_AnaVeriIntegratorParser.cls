public class RC_AnaVeriIntegratorParser {
    
    public ET_RETURN ET_RETURN;
    public ET_TNM_FIYAT_GRUBU ET_TNM_FIYAT_GRUBU;
    public ET_TNM_HESAP_TAYIN ET_TNM_HESAP_TAYIN;
    public ET_TNM_MALZ_GRUBU ET_TNM_MALZ_GRUBU;
    public ET_TNM_MALZ_TUR ET_TNM_MALZ_TUR;
    public ET_TNM_MAL_GRUBU ET_TNM_MAL_GRUBU;
    public ET_TNM_OLCULER ET_TNM_OLCULER;
    public ET_TNM_URUN_HIYERARSI ET_TNM_URUN_HIYERARSI;
    public ET_TNM_VERGI_SINIF ET_TNM_VERGI_SINIF;
    public ET_TNM_MARKA ET_TNM_MARKA;
    public ET_TNM_DEPO_YERI ET_TNM_DEPO_YERI;
    public ET_TNM_URETIM_YERI ET_TNM_URETIM_YERI;
    public Integer EV_TOTAL_IND;
    
    public class ET_TNM_MARKA{
        public List<Item_A> item;
    }
    
    public class ET_TNM_MALZ_GRUBU {
        public List<Item_X> item;
    }
    
    public class ET_TNM_HESAP_TAYIN {
        public List<Item_Y> item;
    }
    
    public class ET_TNM_DEPO_YERI{
         public List<Item_Depo_Yeri> item;
    }

    public class Item_Depo_Yeri{
        public String WERKS;
        public String LGORT;
        public String LGOBE;
    }    
    
    public class ET_TNM_URETIM_YERI{
         public List<Item_Uretim_Yeri> item;
    }
    
    public class Item_Uretim_Yeri{
        public String WERKS;
        public String NAME1;
    }
    
    public class Item_A{
        public String ZZMARKA;
        public String BEZEI;
    }
    
    public class Item_S {
        public String TAXKM;
        public String VTEXT;
    }
    
    public class ET_RETURN {
        public List<Item> item;
    }
    
    public class Item_W {
        public String MTART;
        public String MTBEZ;
    }
    
    public class Item_V {
        public String MATKL;
        public String WGBEZ;
    }
    
    public class Item_U {
        public String MSEHI;
        public String MSEHT;
    }
    
    public class Item_T {
        public String PRODH;
        public String STUFE;
        public String VTEXT;
    }
    
    public class Item_Z {
        public String KONDM;
        public String VTEXT;
    }
    
    public class Item_Y {
        public String KTGRM;
        public String VTEXT;
    }
    
    public class ET_TNM_MALZ_TUR {
        public List<Item_W> item;
    }
    
    public class Item_X {
        public String MVGR2;
        public String BEZEI;
    }
    
    public class Item {
        public String MATNR;
        public String MAKTX;
        public String MEINS;
        public String MATKL;
        public String MTART;
        public String BRGEW;
        public String NTGEW;
        public String GEWEI;
        public String VOLUM;
        public String VOLEH;
        public String GROES;
        public String EAN11;
        public String NUMTP;
        public String ZZEOL;
        public String ZZEOL_DATE;
        public String ZZMARKA;
        public String TAXTY;
        public String TAXM1;
        public String KONDM;
        public String KTGRM;
        public String MVGR2;
        public String VERPR;
        public String VMSTA;
        public String PRDHA;
        public String KADEME1;
        public String KADEME2;
        public String KADEME3;
        public String KADEME4;
        public String KADEME5;
        public String KADEME6;
        public String KADEME7;
        public String KADEME8;
        public String KADEME9;
    }
    
    public class ET_TNM_VERGI_SINIF {
        public List<Item_S> item;
    }
    
    public class ET_TNM_FIYAT_GRUBU {
        public List<Item_Z> item;
    }
    
    public class ET_TNM_MAL_GRUBU {
        public List<Item_V> item;
    }
    
    public class ET_TNM_OLCULER {
        public List<Item_U> item;
    }
    
    public class ET_TNM_URUN_HIYERARSI {
        public List<Item_T> item;
    }
    
    
    public static RC_AnaVeriIntegratorParser parse(String json) {
        return (RC_AnaVeriIntegratorParser) System.JSON.deserialize(json, RC_AnaVeriIntegratorParser.class);
    }
}