@isTest
global class RC_HRServices_GetNewEmployeeMock implements WebServiceMock {
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            
            
            HRKurumsalServis.GetNewEmployeeResponse_element respElement = new HRKurumsalServis.GetNewEmployeeResponse_element();
            
            HRKurumsalServis.EmployeeResponse res = new HRKurumsalServis.EmployeeResponse();
            List<HRKurumsalServis.EmployeeData> empDataList = new List<HRKurumsalServis.EmployeeData>();
            HRKurumsalServis.EmployeeData empData = new HRKurumsalServis.EmployeeData();
            
            empData.AdSoyad = 'name1 name2 name3';
            empData.ADLoginName = 'testusr';
            empData.Email = 'rtms@test.com';
            empData.SicilNo = '1234';
            empData.Soyad = 'testSoyad';
            empData.GirisTarihi = DateTime.newInstance(2001, 7, 19, 10, 7, 12);
            empData.CikisTarihi = DateTime.newInstance(2009, 7, 19, 10, 7, 12);
            empData.Pozisyon    = 'Pazarlama Uzmanı';
            empData.NormKadro   = 'VESTEL TİC.AŞ.İSTANBUL ŞB';
            empDataList.add(empData);
            
            HRKurumsalServis.EmployeeData empData2 = new HRKurumsalServis.EmployeeData();
            
            empData2.AdSoyad = 'name4 name5';
            empData2.ADLoginName = 'testusr2';
            empData2.Email = 'rtms2@test.com';
            empData2.SicilNo = '123445';
            empData2.GirisTarihi = DateTime.newInstance(2001, 7, 19, 10, 7, 12);
            empData2.CikisTarihi = DateTime.newInstance(2009, 7, 19, 10, 7, 12);
            empData2.Pozisyon    = 'Pazarlama Uzmanı';
            empData2.NormKadro   = 'VESTEL TİC.AŞ.İSTANBUL ŞB';
            empDataList.add(empData2);
            
            
            HRKurumsalServis.ArrayOfEmployeeData arrOfEmployeeData = new HRKurumsalServis.ArrayOfEmployeeData();
            arrOfEmployeeData.EmployeeData = empDataList;
            res.EmployeeList = arrOfEmployeeData;
            
            
            respElement.GetNewEmployeeResult = res;
            response.put('response_x', respElement); 
        }
}