@isTest
private class RegHandler_Test {
    static testMethod void testCreateAndUpdateUser() {
        
        RegHandler handler = new RegHandler();

        
        Profile profile1 = [Select Id from Profile LIMIT 1];
        User us = new User();
        us.FirstName = 'testFirst';
        us.LastName  = 'testLast';
        us.Email     = 'testuser@example.org';
        us.LocaleSidKey					= 'en_US';
        us.TimeZoneSidKey 					= 'GMT';
        us.LanguageLocaleKey 				= 'en_US';
        us.EmailEncodingKey 				= 'UTF-8';
        us.Alias = 'testnewu';
        us.userName = 'testusername@example.org';
        us.ProfileId = profile1.Id;
        insert us;
        
        
         Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
                                                     'testFirst testLast', 'testuser@example.org', null, 'testusername@example.org', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US'});

        User u = handler.createUser(null, sampleData);
        System.assertEquals('testusername@example.org', u.userName);
        System.assertEquals('testuser@example.org', u.email);
        System.assertEquals('testLast', u.lastName);
        System.assertEquals('testFirst', u.firstName);
        System.assertEquals('testnewu', u.alias);
        String uid = u.id;
        
        sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
                                       'testNewFirst testNewLast', 'testnewuser@example.org', null, 'testnewuserlong', 'en_US', 'facebook',
                                       null, new Map<String, String>{});
        handler.updateUser(uid, null, sampleData);
        
        User updatedUser = [SELECT userName, email, firstName, lastName, alias FROM user WHERE id=:uid];
        System.assertEquals('testusername@example.org', updatedUser.userName);
        System.assertEquals('testuser@example.org', updatedUser.email);
        System.assertEquals('testLast', updatedUser.lastName);
        System.assertEquals('testFirst', updatedUser.firstName);
        System.assertEquals('testnewu', updatedUser.alias);
    }
}