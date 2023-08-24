@isTest(SeeAllData=false)
public class RC_UpdateOrderStatusSchedulableTest {
    
    @istest
    public static void unitTest()
    {
        
        RC_Migration_Values__c cs1 = new RC_Migration_Values__c();
        cs1.Name='Order Status Migration Values';
        cs1.RC_Begin_Time__c = DateTime.newInstance(2021, 3, 1, 0, 0 , 00);
        cs1.RC_End_Time__c = date.today();
        cs1.RC_Is_Runnable__c = true;
        insert cs1;
        
                
        RC_Delivery_and_Billing__c deliveryAndBilling = new RC_Delivery_and_Billing__c();
        deliveryAndBilling.RC_Delivery_Status__c = 'Kurye Dağıtımda';
        deliveryAndBilling.RC_Invoice_Date__c = Date.today().addDays(-1);
        deliveryAndBilling.Name = '0318482833234';
        deliveryAndBilling.RC_TM_Delivery__c = true;
        deliveryAndBilling.RC_Delivery_Date__c = date.newInstance(2021,03,01);
        insert deliveryAndBilling;
        
        RC_UpdateOrdersStatusSchedulable sch1 = new RC_UpdateOrdersStatusSchedulable();
        sch1.execute(null);
        
        for(integer i=0; i<=7 ; i++)
        {
            RC_UpdateOrderStatus.GetStatusDescription(i);
        }
        
        RC_UpdateOrderStatus.GetStatusValue('YS');
        RC_UpdateOrderStatus.GetStatusValue('Hazırlanıyor');
        RC_UpdateOrderStatus.GetStatusValue('Yola Çıkmak Üzere');
        RC_UpdateOrderStatus.GetStatusValue('Yolda');
        RC_UpdateOrderStatus.GetStatusValue('Transfer Merkezinde');
        RC_UpdateOrderStatus.GetStatusValue('Dağıtımı Hazırlanıyor');
        RC_UpdateOrderStatus.GetStatusValue('Kurye Dağıtımda');
        RC_UpdateOrderStatus.GetStatusValue('Teslim Edildi');
        RC_UpdateOrderStatus.GetStatusValue('Teslim Edilemedi');
        
        RC_UpdateOrderStatus.GetStatusDescription(1);
        RC_UpdateOrderStatus.GetStatusDescription(2);
        RC_UpdateOrderStatus.GetStatusDescription(3);
        RC_UpdateOrderStatus.GetStatusDescription(4);
        RC_UpdateOrderStatus.GetStatusDescription(5);
        RC_UpdateOrderStatus.GetStatusDescription(6);
        RC_UpdateOrderStatus.GetStatusDescription(7);
        RC_UpdateOrderStatus.GetStatusDescription(8);
    }
}