@isTest
public class RC_LoggerTest {
    @isTest
    public static void UnitTest(){
        RC_Logger__c logItem = new RC_Logger__c();
        logItem.RC_Message__c='MESSAGE';
        logItem.RC_Message_Detail__c= 'MESSAGEDETAIL';
        logItem.RC_StackTrace__c='STACKTRACE';
        logItem.CreateDate__c = DateTime.now();
        logItem.RC_LogLevel__c = 'INFO';
        logItem.RC_ClassName__c='CLASS';
        logItem.RC_FunctionName__c='FUNCTION';
        logItem.RC_ComponentName__c='COMPONENT';
        insert logItem;        
        RC_Logger.LOG(logItem);
        
        RC_Logger.LOG_INFO('MESSAGE','MESSAGEDETAIL','CLASS','FUNCTION','COMPONENT');
        
        RC_Logger.LOG_EXCEPTION('MESSAGE','MESSAGEDETAIL','STACKTRACE', 'CLASS','FUNCTION','COMPONENT');  
        
        RC_Logger.LOG_INFOFORPROCESSES('MESSAGE','MESSAGEDETAIL','CLASS','FUNCTION','COMPONENT', 'Account');
        
        try{
            RC_Logger__c logItem2 = new RC_Logger__c();
            logItem2.RC_Message__c='MESSAGE';
            logItem2.RC_Message_Detail__c= 'MESSAGEDETAIL';
            logItem2.RC_StackTrace__c='STACKTRACE';
            logItem2.CreateDate__c = DateTime.now();
            logItem2.RC_LogLevel__c = 'EXCEPTION';
            logItem2.RC_ClassName__c='CLASS';
            logItem2.RC_FunctionName__c='FUNCTION';
            logItem2.RC_ComponentName__c='COMPONENT';
            insert logItem; 
        }
        catch(DMLException ex){
            RC_Logger.LOG_DMLEXCEPTION(ex, '','CLASS','FUNCTION','COMPONENT');
        }    
    }
}