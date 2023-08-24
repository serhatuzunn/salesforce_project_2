@isTest
public class RC_SD_CargoIntegratorTest {
	@isTest
    public static void getBayiCekSenetTest(){  
             
        RC_SD_CargoIntegrator.Item item = new RC_SD_CargoIntegrator.Item();
        item.TES_NO = '840435320';
            
        RC_SD_CargoIntegrator.ITVBELN itvBeln = new RC_SD_CargoIntegrator.ITVBELN();
        itvBeln.item = new List<RC_SD_CargoIntegrator.Item>();
        itvBeln.item.add(item);
            
        RC_SD_CargoIntegrator.requestModel req = new RC_SD_CargoIntegrator.requestModel();
        req.IT_VBELN = itvBeln;
            
        Test.setMock(HttpCalloutMock.class, new RC_SD_CargoIntegratorMock());
            
        Test.startTest();
    
        RC_SD_CargoIntegrator.getSdEticCargo(req);
                
        Test.stopTest();        
    }

    @isTest
    public static string getTMCodeCargo(){  
             
        RC_SD_CargoIntegrator.Item item = new RC_SD_CargoIntegrator.Item();
        item.TES_NO = '318482833';
            
        RC_SD_CargoIntegrator.ITVBELN itvBeln = new RC_SD_CargoIntegrator.ITVBELN();
        itvBeln.item = new List<RC_SD_CargoIntegrator.Item>();
        itvBeln.item.add(item);
            
        RC_SD_CargoIntegrator.requestModel req = new RC_SD_CargoIntegrator.requestModel();
        req.IT_VBELN = itvBeln;
            
        Test.setMock(HttpCalloutMock.class, new RC_SD_CargoIntegratorMock());
            
        Test.startTest();
    
        string retval = RC_SD_CargoIntegrator.getTMCodeCargo(req);
        Test.stopTest();        
        return retval;

    }
     
    @isTest
    public static void getStatusTest(){  
        
        Map<String, String> zzCodeMap = new Map<String, String>();
        zzCodeMap.put('1', 'Siparişiniz Hazırlanıyor');
        zzCodeMap.put('4', 'Siparişiniz Araca Yükleniyor');
        zzCodeMap.put('7', 'Siparişiniz Yolda');
        zzCodeMap.put('8', 'Transfer Merkezinde');
        zzCodeMap.put('9', 'Transfer Merkezinde');
        zzCodeMap.put('14', 'Siparişiniz Teslim Edildi');
        zzCodeMap.put('15', 'Teslim Edilemedi');
        zzCodeMap.put('16', 'Siparişiniz Yolda');
        zzCodeMap.put('19', 'Siparişiniz Hazırlanıyor');
        zzCodeMap.put('20', 'Teslim Edilemedi');
        zzCodeMap.put('21', 'Kurye Dağıtımda');
        zzCodeMap.put(null, null);
             
        for (String statusId : zzCodeMap.keySet() ){
            String result = RC_SD_CargoIntegrator.getStatus(statusId);
        }
    }
    
    @isTest
    public static void getCompanyNoTest(){
        String companyText = 'Test1/Test2';
        String resultTest = RC_SD_CargoIntegrator.getCompanyNo(companyText);
        String resultTest2 = RC_SD_CargoIntegrator.getCompanyNo('test3');
        System.assertEquals('Test1',resultTest);
    }
}