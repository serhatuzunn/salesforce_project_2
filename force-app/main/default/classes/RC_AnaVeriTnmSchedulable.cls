global class RC_AnaVeriTnmSchedulable implements Schedulable {
    global void execute(SchedulableContext ctx) {    
        FutureMethod();
    }
    
    @future(callout=true)
    public static void FutureMethod()
    {
        String brandGlobalValue = RC_AnaVeriTnm.getGlobalValueSetUrlId('RC_Brand');
        String materialGroupGlobalValue = RC_AnaVeriTnm.getGlobalValueSetUrlId('RC_Material_Group_2');
        
        RC_AnaVeriIntegratorParser anaVeriTnmParser = RC_AnaVeriTnm.getTnm();
        RC_AnaVeriTnm.saveMarka(anaVeriTnmParser.ET_TNM_MARKA.item, brandGlobalValue);         
        RC_AnaVeriTnm.saveMaterialMalzGroup(anaVeriTnmParser.ET_TNM_MALZ_GRUBU.item, materialGroupGlobalValue);
        RC_AnaVeriTnm.saveDepoYeri(anaVeriTnmParser.ET_TNM_DEPO_YERI.item);
        RC_AnaVeriTnm.saveUretimYeri(anaVeriTnmParser.ET_TNM_URETIM_YERI.item);
        RC_AnaVeriTnm.saveFiyatGrubu(anaVeriTnmParser.ET_TNM_FIYAT_GRUBU.item);
    }
}