@isTest
public class HRKurumsalServisTest {
    
    static testMethod void unitTest(){
        
        
        HRKurumsalServis.BasicHttpBinding_IService hr=  new HRKurumsalServis.BasicHttpBinding_IService();
        HRKurumsalServis.GetPersonelBySirketRequest req = new HRKurumsalServis.GetPersonelBySirketRequest();
        HRKurumsalServis.GetUpdatedEmployeeRequest req2 = new HRKurumsalServis.GetUpdatedEmployeeRequest();
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new RC_HRServices_GetPersonelBySirketMock());
        
        hr.GetPersonelBySirket(req);
        
        Test.stopTest();
        
    }
    
    static testMethod void unitTest2(){
        
        
        HRKurumsalServis.BasicHttpBinding_IService hr=  new HRKurumsalServis.BasicHttpBinding_IService();
        
        HRKurumsalServis.GetPersonelByUpdateDateRequest req2 = new HRKurumsalServis.GetPersonelByUpdateDateRequest();
        
        
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new RC_HRServices_GetUpdatedEmployeeMock());
        hr.GetPersonelByUpdateDate(req2);
        Test.stopTest();
    }
    
    static testMethod void unitTest3(){
        
        
        HRKurumsalServis.BasicHttpBinding_IService hr=  new HRKurumsalServis.BasicHttpBinding_IService();
        
        HRKurumsalServis.GetNewEmployeeRequest req2 = new HRKurumsalServis.GetNewEmployeeRequest();
        
        
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new RC_HRServices_GetNewEmployeeMock());
        hr.GetNewEmployee(req2);
        Test.stopTest();
    }
    
}