public class RC_LeftMenuController {
    
    @AuraEnabled
    public static string initialize(string recordId)
    {
        return UserInfo.getName();
    }
}