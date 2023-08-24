@IsTest
public class ContentVersionTriggerTest {
	
    @IsTest static void unitTest(){
        Task newTask = new Task();
        
        insert newTask;
        
        ContentVersion cv = new ContentVersion(
        	Title = 'Test Title',
            PathOnClient = 'Test',
            VersionData = EncodingUtil.base64Decode('Unit Test Body')	
        );	
    	
        insert cv;
        
        ContentDocumentLink cl = new ContentDocumentLink();
        cl.LinkedEntityId = newTask.Id;
        cl.ContentDocumentId=[SELECT ContentDocumentId From ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cl.ShareType = 'I';
        cl.Visibility = 'InternalUsers'; 
        
        insert cl;
        
        cv.Title = 'Update For Test Scenario';
        
        update cv;
    }
}