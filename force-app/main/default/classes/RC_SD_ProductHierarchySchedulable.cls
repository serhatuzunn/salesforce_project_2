global class RC_SD_ProductHierarchySchedulable implements Schedulable {
    global void execute(SchedulableContext ctx) {    
        FutureMethod(); 
    }
    
    @future(callout=true)
    public static void FutureMethod()
    {
        Map<String, List<RC_AnaVeriTnm.ProductHierarchyModel>> hierarchyMap = RC_AnaVeriTnm.getUrunHierarchy();
        RC_AnaVeriTnm.saveUrunHierarchy(hierarchyMap); 
    }
    
}