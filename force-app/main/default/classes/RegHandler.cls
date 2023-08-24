global class RegHandler implements Auth.RegistrationHandler {
    
    class RegHandlerException extends Exception {}
    
    global User createUser(Id portalId, Auth.UserData data)
    {
        
        List<User> usrList = [SELECT Id,Name,userName,alias,firstName,lastName,email FROM User WHERE email=:data.email and IsActive=true];
        
        if(usrList==null && usrList.size()<=0)
            throw new Auth.AuthProviderPluginException('01'); 
        else
        {
            system.debug('Success Login');  
            return usrList.get(0);
        }
        
        
    } 
    
    global void updateUser(Id userId, Id portalId, Auth.UserData data)
    {
        
        system.debug('Update User');
        
        List<User> usrList = [SELECT Id,Name FROM User WHERE email=:data.email and IsActive=true];
        
        if(usrList==null && usrList.size()<=0)
            throw new Auth.AuthProviderPluginException('01'); 
        
        system.debug('Success Login');
        
    }
}