@isTest
public class RC_Asseco_IntegratorTest {
    @isTest
    public static void UnitTest(){
        
        String channel ='';
        String dealerCode = ''; 
        String random =''; 
        String secretKey ='';
            
        Test.startTest();
        
        RC_Asseco_Integrator.GenerateRandomKey(64);
        RC_Asseco_Integrator.GenerateHashCode(channel,dealerCode,random,secretKey);
        
        Test.stopTest();
    }
}