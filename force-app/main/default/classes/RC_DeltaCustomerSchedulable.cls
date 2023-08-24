global class RC_DeltaCustomerSchedulable implements Schedulable {
    global void execute(SchedulableContext ctx) {    
        
        FutureMethod();
    }
    @future(callout=true)
    public static void FutureMethod()
    {
        String dgtmKanalGlobalValue = RC_DeltaCustomerTnm.getGlobalValueSetUrlId('RC_Distribution_Channel');
        String ftrBlgTrGlobalValue = RC_DeltaCustomerTnm.getGlobalValueSetUrlId('RC_Billing_Document_Type');
        String krediKntrGlobalValue = RC_DeltaCustomerTnm.getGlobalValueSetUrlId('RC_Credit_Control_Field');
        String mustGrubuGlobalValue = RC_DeltaCustomerTnm.getGlobalValueSetUrlId('RC_Customer_Group');
        String satisBuroGlobalValue = RC_DeltaCustomerTnm.getGlobalValueSetUrlId('RC_Regional_Directorate');
        String satisMdrGlobalValue = RC_DeltaCustomerTnm.getGlobalValueSetUrlId('RC_Sales_Directorate');
        String satisOrgGlobalValue = RC_DeltaCustomerTnm.getGlobalValueSetUrlId('RC_Sales_Organization');
        String teslBlgTrGlobalValue = RC_DeltaCustomerTnm.getGlobalValueSetUrlId('Order_Delivery_Type');
        
        String yaratTrh = '20210322';
        String degisTrh = '20210322';
        RC_DeltaCustomerIntegratorParser deltaCustomerTnmParser = RC_DeltaCustomerTnm.getTnm(yaratTrh, degisTrh);
        
        RC_DeltaCustomerTnm.saveDgtmKanal(deltaCustomerTnmParser.ET_TNM_DGTM_KANAL.item, dgtmKanalGlobalValue, 'RC_Distribution_Channel', 'Distribution Channel'); 
        RC_DeltaCustomerTnm.saveFtrBlgTr(deltaCustomerTnmParser.ET_TNM_FTR_BLG_TR.item, ftrBlgTrGlobalValue, 'RC_Billing_Document_Type', 'Billing Document Type'); 
        RC_DeltaCustomerTnm.saveKrediKntr(deltaCustomerTnmParser.ET_TNM_KREDI_KNTR.item, krediKntrGlobalValue, 'RC_Credit_Control_Field', 'Credit Control Field'); 
        RC_DeltaCustomerTnm.saveMustGrubu(deltaCustomerTnmParser.ET_TNM_MUST_GRUBU.item, mustGrubuGlobalValue, 'RC_Customer_Group', 'Customer Group'); 
        RC_DeltaCustomerTnm.saveSatisBuro(deltaCustomerTnmParser.ET_TNM_SATIS_BURO.item, satisBuroGlobalValue, 'RC_Regional_Directorate', 'Regional Directorate'); 
        RC_DeltaCustomerTnm.saveSatisMdr(deltaCustomerTnmParser.ET_TNM_SATIS_MDR.item, satisMdrGlobalValue, 'RC_Sales_Directorate', 'Sales Directorate'); 
        RC_DeltaCustomerTnm.saveSatisOrg(deltaCustomerTnmParser.ET_TNM_SATIS_ORG.item, satisOrgGlobalValue, 'RC_Sales_Organization', 'Sales Organization'); 
        RC_DeltaCustomerTnm.saveTeslBlgTr(deltaCustomerTnmParser.ET_TNM_TESL_BLG_TR.item, teslBlgTrGlobalValue, 'Order_Delivery_Type', 'Order Delivery Type'); 
    }
    
}