@isTest
public with sharing class RC_SD_DeltaCustomerReaderSchedulableTest {
    
    @testSetup static void prepareData(){
        DeltaCustomerGroup__c testCustomerGroup = new DeltaCustomerGroup__c(
        	Name = '2201',
            DealerType__c = 'BAYI',
            SubType__c = 'Vestel Bayi'
        );
        
        DeltaCustomerGroup__c testCustomerGroup2 = new DeltaCustomerGroup__c(
        	Name = '5000',
            DealerType__c = 'KURUMSAL',
            SubType__c = 'KURUMSAL'
        );
        
        DeltaCustomerGroup__c testCustomerGroup3 = new DeltaCustomerGroup__c(
        	Name = '2222',
            DealerType__c = 'KURUMSAL',
            SubType__c = 'KURUMSAL'
        );    
        
        DeltaCustomerGroup__c testCustomerGroup4 = new DeltaCustomerGroup__c(
        	Name = '2202',
            DealerType__c = 'BAYI',
            SubType__c = 'Vestel Bayi'
        );
        
        DeltaCustomerGroup__c testCustomerGroup5 = new DeltaCustomerGroup__c(
        	Name = '2205',
            DealerType__c = 'BAYI',
            SubType__c = 'Vestel Bayi'
        );
        
        DeltaCustomerGroup__c testCustomerGroup6 = new DeltaCustomerGroup__c(
        	Name = 'ZLED',
            DealerType__c = 'KURUMSAL',
            SubType__c = 'KURUMSAL'
        );
        
        DeltaCustomerGroup__c testCustomerGroup7 = new DeltaCustomerGroup__c(
        	Name = '2805',
            DealerType__c = 'BAYI',
            SubType__c = 'Regal Bayi'
        );
        
        DeltaCustomerGroup__c testCustomerGroup8 = new DeltaCustomerGroup__c(
        	Name = '2802',
            DealerType__c = 'BAYI',
            SubType__c = 'Regal Bayi'
        );
        
        DeltaCustomerGroup__c testCustomerGroup9 = new DeltaCustomerGroup__c(
        	Name = 'ZBDE',
            DealerType__c = 'SUBE/DEPO',
            SubType__c = ''
        );
        
        DeltaCustomerGroup__c testCustomerGroup10 = new DeltaCustomerGroup__c(
        	Name = '2801',
            DealerType__c = 'BAYI',
            SubType__c = 'Regal Bayi'
        );
        
        List<DeltaCustomerGroup__c> insertGroupSetting = new List<DeltaCustomerGroup__c>{testCustomerGroup10, testCustomerGroup9, testCustomerGroup8, testCustomerGroup7, testCustomerGroup6, testCustomerGroup, testCustomerGroup2, testCustomerGroup3, testCustomerGroup4, testCustomerGroup5};
        
        insert insertGroupSetting;
        
        Account newAccount = new Account(
        	RC_SAP_ID__c = '20100994',
            Name = 'Test Account'
        );
        
        insert newAccount;
        
        RC_Account_Role__c newAccountRole = new RC_Account_Role__c(
        	RC_Parent_Account__c = newAccount.Id
        );
        
        RC_Account_Role__c newAccountRole2 = new RC_Account_Role__c(
        	RC_Parent_Account__c = newAccount.Id,
            RC_Role__c = 'WE'
        );
        
        List<RC_Account_Role__c> insertAccountRole = new List<RC_Account_Role__c>{newAccountRole, newAccountRole2};
            
        insert insertAccountRole;
    }
    
    static testMethod void unitTest(){
        Test.setMock(HttpCalloutMock.class, new RC_SD_DeltaCustomerIntegratorMock());
        Test.startTest();
        
        RC_SchedulableSettings__c newSetting = new RC_SchedulableSettings__c(
            Name = 'Delta_Customer_Settings',
            RC_isRunnable__c = false,
            RC_Job_Run_Date__c = Date.today()
        );

        insert newSetting;

        RC_SD_DeltaCustomerReaderSchedulable sch = new RC_SD_DeltaCustomerReaderSchedulable();
        sch.execute(null);

        Test.stopTest();
    }

    static testMethod void unitTestWithSetting(){
        Test.setMock(HttpCalloutMock.class, new RC_SD_DeltaCustomerIntegratorMock());

        RC_SchedulableSettings__c newSetting = new RC_SchedulableSettings__c(
            Name = 'Delta_Customer_Settings',
            RC_isRunnable__c = true,
            RC_Job_Run_Date__c = Date.today()
        );

        insert newSetting;

        Test.startTest();

        RC_SD_DeltaCustomerReaderSchedulable sch = new RC_SD_DeltaCustomerReaderSchedulable();
        sch.execute(null);

        Test.stopTest();
    }
}