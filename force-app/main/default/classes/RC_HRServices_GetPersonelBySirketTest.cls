@isTest(SeeAllData=true)
private class RC_HRServices_GetPersonelBySirketTest {
    
    @isTest static void testNameSplitter_nameAndLastName() {
        String firstName = 'firstName';
        String lastName = 'lastName';
        String fullName = firstName + ' ' + lastName;
        RC_HRServices_GetPersonelBySirket.PreparedName preparedName = RC_HRServices_GetPersonelBySirket.NameSplitter(fullName);

    }
    
    @isTest static void testNameSplitter_nameAndSecondNameAndLastName() {
        String firstName = 'firstName secondName';
        String lastName = 'lastName';
        String fullName = firstName + ' ' + lastName;
        
        RC_HRServices_GetPersonelBySirket.PreparedName preparedName = RC_HRServices_GetPersonelBySirket.NameSplitter(fullName);
    }
    
    @isTest static void testNameSplitter_nameAndSecondNameAndThirdNameAndLastName() {
        String firstName = 'firstName secondName thirdName';
        String lastName = 'thirdName lastName';
        String fullName = firstName + ' ' + lastName;
        
        RC_HRServices_GetPersonelBySirket.PreparedName preparedName = RC_HRServices_GetPersonelBySirket.NameSplitter(fullName);

    }
    
    @isTest static void testGetPersonelBySirket() {              
        Test.setMock(WebServiceMock.class, new RC_HRServices_GetPersonelBySirketMock());
        
        Test.startTest();

        Profile profile1 = [Select Id from Profile LIMIT 1];
        User us = new User();
        us.FirstName = 'testFirst';
        us.LastName  = 'testLast';
        us.Email     = 'rtms_invalid@test.com';
        us.LocaleSidKey					= 'en_US';
        us.TimeZoneSidKey 					= 'GMT';
        us.LanguageLocaleKey 				= 'en_US';
        us.EmailEncodingKey 				= 'UTF-8';
        us.Alias = 'testnewu';
        us.userName = 'testusername@example.org';
        us.ProfileId = profile1.Id;
        insert us;
         
        RC_HRServices_GetPersonelBySirket.GetSirketList();
        
        Test.stopTest();
    }
    
}