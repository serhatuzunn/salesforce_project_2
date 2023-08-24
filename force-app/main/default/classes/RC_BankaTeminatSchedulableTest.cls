@isTest(SeeAllData=false)
private class RC_BankaTeminatSchedulableTest {
    static testmethod void testScheduledJob() {
        
        User thisUser = [ select Id from User where Id =: UserInfo.getUserId() ];
        
        UserRole userRole = new UserRole();
        userRole.PortalType = 'None';
        userRole.Name = 'Admin';
        insert userRole;
        
        System.runAs ( thisUser ) {
            //Create portal account owner
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile profile1 = [Select Id from Profile LIMIT 1];
            User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            Database.insert(portalAccountOwner1);
            
            //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id,
                RC_SAP_ID__c = '20400236'
                
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Vestel B2B User%' Limit 1];
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
            
            
        }  
        
        Test.setMock(HttpCalloutMock.class, new RC_BankaTeminatIntegratorMock());
        Test.startTest();
        
        RC_BankaTeminatSchedulable sch1 = new RC_BankaTeminatSchedulable('2002', '', '');
        sch1.execute(null);
        
        Test.stopTest();
    }
    static testmethod void testScheduledJob2() {
        
        User thisUser = [ select Id from User where Id =: UserInfo.getUserId() ];
        
        UserRole userRole = new UserRole();
        userRole.PortalType = 'None';
        userRole.Name = 'Admin';
        insert userRole;
        
        System.runAs ( thisUser ) {
            //Create portal account owner
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile profile1 = [Select Id from Profile LIMIT 1];
            User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            Database.insert(portalAccountOwner1);
            
            //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id,
                RC_SAP_ID__c = '20400236'
                
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Vestel B2B User%' Limit 1];
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);

        }  
        Test.setMock(HttpCalloutMock.class, new RC_BankaTeminatIntegratorMock());
        Test.startTest();
        
        RC_BankaTeminatSchedulable sch1 = new RC_BankaTeminatSchedulable(null, null, null);
        sch1.execute(null);
        
        Test.stopTest();
    }
}