public class RC_DocFlowParser {
    
    public ETRETURN ET_RETURN { get; set; }
    
    public class Item
    {
        public string VBELN_VL { get; set; }
        public string POSNR_VA { get; set; }
        public string VBELN_VF { get; set; }
        public string VBELN_CKS { get; set; }
    }
    
    public class ETRETURN
    {
        public List<Item> item { get; set; }
    }
}