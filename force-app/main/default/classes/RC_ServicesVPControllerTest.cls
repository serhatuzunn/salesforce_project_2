@isTest
public class RC_ServicesVPControllerTest {
    @isTest
    public static void unitTest(){
        String cityCode ='053';
        String regionCode='000000053109';
        String districtCode ='53109049';        
        String authorityCode ='07';
        
        RC_Definition__c def = new RC_Definition__c ();
        def.RC_Value__c =authorityCode;
        def.Name='Angel';
        def.Type__c='Authority';
        def.RC_Active__c= true;
        insert def;
        
        RC_City_Region__c c = new RC_City_Region__c ();
        c= new RC_City_Region__c ();
        c.RC_Code__c =cityCode;
        c.Name ='RİZE';
        c.RC_Type__c='City';
        insert c;
        
        RC_City_Region__c c1= new RC_City_Region__c ();
        c1.RC_Code__c = regionCode;
        c1.Name ='KALKANDERE';
        c1.RC_Type__c  ='Region';
        c1.RC_City__c= c.Id;
        insert c1;
        
        RC_City_Region__c c2= new RC_City_Region__c ();
        c2.RC_Code__c =districtCode;
        c2.Name ='ÇAYIRLI KÖYÜ';
        c2.RC_Type__c  ='District';
        /*c2.RC_Region__c = c1.Id;*/
        insert c2;

        
        Test.setMock(HttpCalloutMock.class, new RC_ServicesVPIntegratorMock());
        
        Test.startTest();
        
        RC_ServicesVPController.fillAuthority();
        RC_ServicesVPController.fillCities();
        RC_ServicesVPController.fillRegions(cityCode);
        RC_ServicesVPController.fillDistricts(regionCode);
        RC_ServicesVPController.getServicesVP(cityCode, regionCode, districtCode, authorityCode);
        
         Test.stopTest();
    }
    
}