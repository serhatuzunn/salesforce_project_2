@isTest(SeeAllData=true)
global with sharing class RC_CustomSlidersTest {
    global static testmethod void GetContentTest() {
        
        Id currentUserId = UserInfo.getUserId();    
        User usr = [select id,Name from User where id =: currentUserId];
        
        System.runAs(usr) {
            
            RC_CustomSliders.getBanners();
            List<RC_CustomSliders.ContentClass> contentData = RC_CustomSliders.getContentsByTopic('Kampanyalar');
            if(contentData!=null && contentData.size()>0)
            {
                string contentId = contentData[0].ContentId;
                RC_CustomSliders.getContentDetailById(contentId);
            }
            
            RC_CustomSliders.GetResourceURL('vestel_logo');
            RC_CustomSliders.GetCommunityPath();
            RC_BindTopicListForCommunity bSCPV = new RC_BindTopicListForCommunity();
            VisualEditor.DynamicPickListRows rows = bSCPV.getValues();
            VisualEditor.DataRow  defValueRows = bSCPV.getDefaultValue();
        }
    }
}