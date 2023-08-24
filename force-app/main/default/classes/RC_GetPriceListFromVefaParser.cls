public class RC_GetPriceListFromVefaParser {    
    public class VefaListHeader {
        public String NAME;
        public String CURRENCYVEFA;
        public String LISTID;
        public String PRICETYPE;
        public String UNIQUEID;
        public String SOCODE;
        public String DCCODE;
        public String RDCODE;
        public String SGCODE;
    }
    public class VefaListDetail {
        public String PRODUCTCODE;
        public String PRODUCTNAME;
        public String CURRENCYVEFA;
        public Double UNITPRICE;		
        public String EXTERNALID;
        public String EXTERNALHEADERID;
        public Double MINPRICE;
    }    
    
    public List<VefaListHeader> HeaderLists;
    public List<VefaListDetail> DetailLists;
    public String Message;   
    public Integer PageCount;
    
    public static RC_GetPriceListFromVefaParser parse(String json) {
        return (RC_GetPriceListFromVefaParser) System.JSON.deserialize(json, RC_GetPriceListFromVefaParser.class);
    }
}