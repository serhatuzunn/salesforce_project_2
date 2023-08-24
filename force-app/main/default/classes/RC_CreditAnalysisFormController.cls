public class RC_CreditAnalysisFormController {
    
    public class initWrapper{
        @AuraEnabled
        public Boolean isSuccess {get;set;}
    }
    
    @AuraEnabled
    public static initWrapper initialize(string recordId){
        system.debug('recordId:' + recordId);
        
        
        List<RC_Credit_Analysis_Form__c> creditAnalysisFormList = [SELECT Id, RC_Account__r.RC_SAP_ID__c, Name 
                                                                   FROM RC_Credit_Analysis_Form__c
                                                                   LIMIT 1];
        
        system.debug('creditAnalysisFormList : ' + creditAnalysisFormList);
        
        initWrapper initWrp = new initWrapper();
        
        
        if(creditAnalysisFormList != null && creditAnalysisFormList.size() > 0){            
            
            initWrp.isSuccess = GetApi(recordId, creditAnalysisFormList.get(0).RC_Account__r.RC_SAP_ID__c);
            
        }
        
        system.debug('initWrp : ' + initWrp);
        
        return initWrp;
    }
    
    
    private static Boolean GetApi(String creditAnalysisId, String accountSapId) {   
        
        system.debug('creditAnalysisId : ' + creditAnalysisId);
        system.debug('accountSapId : ' + accountSapId);
        
        RC_CreditRiskIntegrator.requestModel req = new RC_CreditRiskIntegrator.requestModel();
        
        if(string.isNotBlank(accountSapId)){
            req.IV_BUKRS = '2002';
            req.IV_KKBER = '';
            req.IV_KUNNR = accountSapId;
            system.debug('request : ' + req);
            
            
            //CreditRisk - API:bayi_risk
            RC_CreditRiskIntegrator.responseModel creditRiskResponse = RC_CreditRiskIntegrator.getCreditRiskReport(req);
            system.debug('creditRiskResponse : ' + creditRiskResponse);
            system.debug('creditRiskResponse json : ' + Json.serialize(creditRiskResponse));
            
            //BayiCekSenet - API:bayi_cek_senet
            RC_BayiCekSenetIntegrator.responseModel cekSenetResponse= RC_BayiCekSenetIntegrator.getBayiCekSenet(req);
            system.debug('cekSenetResponse : ' + cekSenetResponse);
            system.debug('cekSenetResponse json : ' + Json.serialize(cekSenetResponse));
            
            
            
            List<RC_Credit_Analysis_Form__c> creditAnalysisFormList = [SELECT Id, RC_Bayi_Olus_Tarihi__c 
                                                                       FROM RC_Credit_Analysis_Form__c 
                                                                       WHERE Id =: creditAnalysisId 
                                                                       LIMIT 1];
            
            if(creditAnalysisFormList != null && creditAnalysisFormList.size() > 0){
                RC_Credit_Analysis_Form__c creditAnalysisFormItem = creditAnalysisFormList.get(0);
                
                system.debug('before creditAnalysisFormItem : ' + creditAnalysisFormItem);
                
                if(String.isNotBlank(creditRiskResponse.itemZ.BAYI_OLUS_TARIHI)){
                    creditAnalysisFormItem.RC_Bayi_Olus_Tarihi__c = Date.parse(creditRiskResponse.itemZ.BAYI_OLUS_TARIHI);
                    
                }
                creditAnalysisFormItem.RC_Risk_Performansi__c = creditRiskResponse.itemZ.RISK_SINIFI;
                if(String.isNotBlank(creditRiskResponse.itemZ.ACIK_KREDI)){
                    creditAnalysisFormItem.RC_Acik_Kredi_Limit__c = Decimal.valueOf(creditRiskResponse.itemZ.ACIK_KREDI);
                }
                if(String.isNotBlank(creditRiskResponse.itemZ.TEMINAT)){
                    creditAnalysisFormItem.RC_Banka_Teminat_Mektubu_Limit__c = Decimal.valueOf(creditRiskResponse.itemZ.TEMINAT);
                }
                if(String.isNotBlank(cekSenetResponse.etReturn.item[0].CEK_MUSTERI_TOP) && String.isNotBlank(cekSenetResponse.etReturn.item[0].SENET_MUSTERI_TOP)){
                    creditAnalysisFormItem.RC_Musteri_Cek_Senet_Limit__c = Decimal.valueOf(cekSenetResponse.etReturn.item[0].CEK_MUSTERI_TOP) +  Decimal.valueOf(cekSenetResponse.etReturn.item[0].SENET_MUSTERI_TOP);
                }
                
                system.debug('after creditAnalysisFormItem : ' + creditAnalysisFormItem);
                
                update creditAnalysisFormItem;
                
                return true;
            }
            else{
                return false;
            }
            
            
        }
        else{
            return false;
        }
        
    }
}