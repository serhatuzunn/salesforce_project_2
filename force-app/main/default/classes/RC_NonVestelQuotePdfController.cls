public class RC_NonVestelQuotePdfController {

    ApexPages.StandardController controller;
    public Quote quote {get;set;}
    public List<QuoteLineItem> lineItems {get;set;}
    public Account acc  {get;set;}
    public List<Contact> contactList  {get;set;}
    public Contact contact {get;set;}
    public Organization org {get;set;}
    public User usr {get;set;}
    public integer versionNumber {get;set;}
     
    public RC_NonVestelQuotePdfController(ApexPages.StandardController c) {
        controller = c;
        quote          = (Quote) c.getRecord(); 
        if(quote.Id == null){
            return;
        }
        
        quote = [SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode,OpportunityId, Pricebook2Id, ContactId,Contact.Name ,QuoteNumber, IsSyncing, ShippingHandling,
             Tax, Status, ExpirationDate, Description, Subtotal, TotalPrice, LineItemCount,
             BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude, BillingGeocodeAccuracy, BillingAddress, ShippingStreet,
             ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingLatitude, ShippingLongitude, ShippingGeocodeAccuracy, ShippingAddress, QuoteToStreet, QuoteToCity,
             QuoteToState, QuoteToPostalCode, QuoteToCountry, QuoteToLatitude, QuoteToLongitude, QuoteToGeocodeAccuracy, QuoteToAddress, AdditionalStreet, AdditionalCity, AdditionalState,
             AdditionalPostalCode, AdditionalCountry, AdditionalAddress, BillingName, ShippingName, QuoteToName,
             AdditionalName, Email, Phone, Fax, ContractId, AccountId, Discount, GrandTotal, CanCreateQuoteLineItems, RC_Quote_Sales_Org__c, RC_Quote_Distribution_Channel__c,
              RC_Indoor_Units__c, RC_Outdoor_Units__c, RC_Installation_Total__c, RC_Notes__c, RC_Terms_of_Offer__c, RC_Warranty_Period__c
             , RC_Delivery_time__c, Delivery_time__c,RC_VPO__c,RC_Quote_Account__c,RC_Public_General_Terms__c,RC_Project_Firm__c, RC_Nonvestel_Zincir_Terms_of_Offer__c, RC_Nonvestel_Zincir_Notes__c FROM Quote WHERE id =: quote.id];
        
        
        org = [SELECT Id, Name, Division, Street, City, State, PostalCode, Country, Latitude, Longitude, GeocodeAccuracy, Address, Phone, Fax, PrimaryContact, DefaultLocaleSidKey,
               TimeZoneSidKey, LanguageLocaleKey, ReceivesInfoEmails, ReceivesAdminInfoEmails, PreferencesRequireOpportunityProducts, PreferencesConsentManagementEnabled,
               PreferencesAutoSelectIndividualOnMerge, PreferencesLightningLoginEnabled, PreferencesOnlyLLPermUserAllowed, FiscalYearStartMonth, UsesStartDateAsFiscalYearName,
               DefaultAccountAccess, DefaultContactAccess, DefaultOpportunityAccess, DefaultLeadAccess, DefaultCaseAccess, DefaultCalendarAccess, DefaultPricebookAccess,
               DefaultCampaignAccess, SystemModstamp, ComplianceBccEmail, UiSkin, SignupCountryIsoCode, TrialExpirationDate, NumKnowledgeService, OrganizationType, NamespacePrefix,
               InstanceName, IsSandbox, WebToCaseDefaultOrigin, MonthlyPageViewsUsed, MonthlyPageViewsEntitlement, IsReadOnly, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById
               FROM Organization limit 1];
        
       
         usr = [SELECT Name, MobilePhone, SenderEmail FROM User WHERE id =: quote.OwnerId limit 1];
        
        acc = [SELECT Name, Fax FROM Account WHERE Id =: quote.AccountId limit 1];
        
        
        contactList = [SELECT Name FROM Contact WHERE AccountId =: quote.AccountId];
        if(contactList.size() > 0){
            contact = contactList.get(0);
        }
        
        lineItems = [SELECT Id, IsDeleted, LineNumber, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate,
                     QuoteId, PricebookEntryId, OpportunityLineItemId, Quantity, UnitPrice, Discount, Description, ServiceDate, Product2Id, SortOrder, ListPrice, Subtotal, TotalPrice,
                     Product2.Name,Product2.ProductCode,Product2.RC_kW__c,Product2.RC_HP__c,RC_Additional_Product_Description__c,Product2.RC_VP_Brand__c
                     FROM QuoteLineItem WHERE QuoteId =: quote.id];
           
        List<QuoteDocument> qdList= [SELECT Id, Name FROM QuoteDocument where QuoteId =: quote.id order by LastModifiedDate  DESC];
        if(qdList.size() > 0 ){
            QuoteDocument qd = qdList.get(0);
            system.debug('qd.Name' + qd.Name);
            List<string> splittedList = qd.Name.split('\\.');
           	string splittedName =  splittedList.get(0);
 			string versionText = splittedName.right(1);
            system.debug('versionText' + versionText);
            versionNumber = integer.valueOf(versionText) + 1;
        }
        
    }
    
    public PageReference savePdf(){
        PageReference thePDF = Page.RC_NonVestelQuotePdfView;
        string qId = ApexPages.currentPage().getParameters().get('id');
        if(Test.isRunningTest()){
            qId=quote.Id;
        }
        thePDF.getParameters().put('id',qId);
        thePDF.setRedirect(true);
        
        Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : thePDF.getContentAsPDF(); 
        QuoteDocument qd = new QuoteDocument(quoteId = quote.Id, Document = content);
        
        insert qd;
        
        return controller.view();
    }
    
}