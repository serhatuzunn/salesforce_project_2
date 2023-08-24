@isTest(SeeAllData=false)
private class RC_RnbxSchedulableTest {
    static testmethod void testScheduledJob() {
        
        Product2 product = new Product2();
        product.Name = 'Test';
        product.ProductCode = '123';
        product.IsActive = true;
        insert product;
        
        Test.setMock(HttpCalloutMock.class, new RC_RnbxMock());
        
        Test.startTest();
        
        RC_RnbxSchedulable sch1 = new RC_RnbxSchedulable();
        sch1.execute(null);
        
        Test.stopTest();
    }
}