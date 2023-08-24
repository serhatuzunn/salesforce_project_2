@isTest
public class RC_DealerBonusCalculatorControllerTest {
    @isTest
    public static void unitTest(){
        
        Account acc = new Account();
        acc.Name='ADALILAR DAYANIKLI TÜKETİM MAL SANAYİ VE TİCARET LİMİTED ŞİRK';
        acc.RC_Account_Type__c = 'Test';
        acc.RC_SAP_ID__c='20300066';
        acc.RC_Mobile__c='5530515353';
        acc.Phone='05530515353';
        acc.RC_email__c='umity@coredet.com';
        acc.RC_Tax_Number__c ='00000000053';
        insert acc;
        
        RC_SD_Organization__c SD = new RC_SD_Organization__c();
        SD.RC_Account__c = acc.id;
        SD.RC_Sales_Organization__c = '2201';
        SD.Distribution_Channel__c = '01';
        insert SD;      
        
        String startDate ='2021-01-01';
        String endDate ='2021-11-01';
        String shipmentBonus ='shipmentBonus';        
        String authorityCode ='07';
        
        RC_DealerBonusCalculatorController.initWrapper init = new RC_DealerBonusCalculatorController.initWrapper();
        
        List<RC_DealerBonusCalculatorController.DealerShipmentBonusDT> draftValuesShipment = new List<RC_DealerBonusCalculatorController.DealerShipmentBonusDT> ();
        RC_DealerBonusCalculatorController.DealerShipmentBonusDT draftValue = new RC_DealerBonusCalculatorController.DealerShipmentBonusDT();
        draftValue.DESCRIPTION='';
        draftValue.EDITABLE=true;
        draftValue.KDV = 1006.3386;
        draftValue.PERIOD='Ocak - 2021';
        draftValue.TOTALBONUS=6597.1086;
        draftValue.TOTALBONUSWITHOUTTAX=5590.77;
        draftValue.TOTALORDERCOUNT=62;
        draftValuesShipment.Add(draftValue);
        
        draftValue = new RC_DealerBonusCalculatorController.DealerShipmentBonusDT();
        draftValue.DESCRIPTION='';
        draftValue.EDITABLE=true;
        draftValue.KDV = 1708.4394;
        draftValue.PERIOD='Şubat - 2021';
        draftValue.TOTALBONUS=11199.7694;
        draftValue.TOTALBONUSWITHOUTTAX=9491.33;
        draftValue.TOTALORDERCOUNT=61;
        draftValuesShipment.Add(draftValue);
        		    
        List<RC_DealerBonusCalculatorController.DealerShipmentBonusDT> headerDataListShipment = new List<RC_DealerBonusCalculatorController.DealerShipmentBonusDT> ();
        RC_DealerBonusCalculatorController.DealerShipmentBonusDT headerData = new RC_DealerBonusCalculatorController.DealerShipmentBonusDT();        
        headerData.PERIOD='Ocak - 2021';
        headerData.INVOICENO='BAYIDENSEVK202101';
        headerData.DESCRIPTION='BAYIDENSEVK202101';
        headerDataListShipment.Add(headerData);
        
        headerData.PERIOD='Şubat - 2021';
        headerData.INVOICENO='BAYIDENSEVK202102';
        headerData.DESCRIPTION='BAYIDENSEVK202102';
        headerDataListShipment.Add(headerData);

        
       
         List<RC_DealerBonusCalculatorController.DealerShipmentBonusDT> draftValues = new List<RC_DealerBonusCalculatorController.DealerShipmentBonusDT> ();
        List<RC_DealerBonusCalculatorController.DealerShipmentBonusDT> headerDataList = new List<RC_DealerBonusCalculatorController.DealerShipmentBonusDT> ();
        headerData.PERIOD='Ocak - 2021';
        headerData.INVOICENO='BAYICIRO01';
        headerData.DESCRIPTION='BAYICIRO01';
        headerDataList.Add(headerData);
        
        draftValue = new RC_DealerBonusCalculatorController.DealerShipmentBonusDT();
        draftValue.EDITABLE=true;
        draftValue.KDV = 89.427;
        draftValue.PERIOD='2020 - 2. Dönem';
        draftValue.TOTALBONUS=586.248;
        draftValue.TOTALBONUSWITHOUTTAX=496.821;
        draftValues.Add(draftValue);
        
        
         Test.startTest();
        RC_DealerBonusCalculatorController.getDealerBonusShipment(startDate, endDate);
        //RC_DealerBonusCalculatorController.updateDealerBonusShipment(draftValuesShipment,shipmentBonus,headerDataListShipment);
        RC_DealerBonusCalculatorController.getDealerBonus(startDate, endDate,'2','G','X');
        RC_DealerBonusCalculatorController.updateDealerBonus(draftValues,'G',headerDataList);
         Test.stopTest();
       
        
       
        
    }
}