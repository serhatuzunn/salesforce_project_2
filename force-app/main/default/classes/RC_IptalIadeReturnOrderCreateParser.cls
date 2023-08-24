public  class RC_IptalIadeReturnOrderCreateParser {
    
    public class Item
    {
        public string TYPE { get; set; }
        public string ID { get; set; }        
        public string MESSAGE { get; set; }
        public string LOG_NO { get; set; }
        public string LOG_MSG_NO { get; set; }
        public string MESSAGE_V1 { get; set; }
        public string MESSAGE_V2 { get; set; }
        public string MESSAGE_V3 { get; set; }
        public string MESSAGE_V4 { get; set; }
        public string PARAMETER { get; set; }
        public Integer ROW { get; set; }
        public string FIELD { get; set; }        
        public string PARTN_ROLE { get; set; }
        public string PARTN_NUMB { get; set; }
        public string ITM_NUMBER { get; set; }
        public string TITLE { get; set; }
        public string NAME { get; set; }
        public string NAME_2 { get; set; }
        public string NAME_3 { get; set; }
        public string NAME_4 { get; set; }
        public string STREET { get; set; }
        public string COUNTRY { get; set; }
        public string COUNTR_ISO { get; set; }
        public string POSTL_CODE { get; set; }
        public string POBX_PCD { get; set; }
        public string POBX_CTY { get; set; }
        public string CITY { get; set; }
        public string DISTRICT { get; set; }
        public string REGION { get; set; }
        public string PO_BOX { get; set; }
        public string TELEPHONE { get; set; }
        public string TELEPHONE2 { get; set; }
        public string TELEBOX { get; set; }
        public string FAX_NUMBER { get; set; }
        public string TELETEX_NO { get; set; }
        public string TELEX_NO { get; set; }
        public string LANGU { get; set; }
        public string LANGU_ISO { get; set; }
        public string UNLOAD_PT { get; set; }
        public string TRANSPZONE { get; set; }
        public string TAXJURCODE { get; set; }
        public string ADDRESS { get; set; }
        public string PRIV_ADDR { get; set; }
        public string ADDR_TYPE { get; set; }
        public string ADDR_ORIG { get; set; }
        public string ADDR_LINK { get; set; }
        public string REFOBJTYPE { get; set; }
        public string REFOBJKEY { get; set; }
        public string REFLOGSYS { get; set; }
    }

    public class ET_MESSAGE
    {
        public List<Item> item { get; set; }
    }

    public class ET_SALES_PARTNERS
    {
        public List<Item> item { get; set; }
    }     
    
    public ET_MESSAGE ET_MESSAGE { get; set; }
    public string EV_DELIVERYDOCUMENT { get; set; }
    public string EV_SALESDOCUMENT { get; set; }
    public string EV_SUCCESS { get; set; }
    public ET_SALES_PARTNERS ET_SALES_PARTNERS { get; set; }  


    public static RC_IptalIadeReturnOrderCreateParser parse(String json) {
		return (RC_IptalIadeReturnOrderCreateParser) System.JSON.deserialize(json, RC_IptalIadeReturnOrderCreateParser.class);
	}
     
}