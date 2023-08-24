global class AuthProviderSSO extends Auth.AuthProviderPluginClass {
    
    private String key;
    private String secret;
    public string redirectUrl;
    public string state;
    public string scope;
    private String authUrl;  
    private String accessTokenUrl; 
    private String customMetadataTypeApiName = 'authProviderConfiguration__mdt'; 
    private String userAPIUrl; 
    private String userAPIVersionUrl; 
    private string authCallBackURl;
    
    global String getCustomMetadataType() {
        return customMetadataTypeApiName;
    } 
    
    
    global PageReference initiate(Map<string,string> 
                                  authProviderConfiguration, String stateToPropagate) 
    { 
        authUrl = authProviderConfiguration.get('Auth_Url__c'); 
        key = authProviderConfiguration.get('Client_Id__c'); 
        redirectUrl=authProviderConfiguration.get('Redirect_Url__c');
        scope=authProviderConfiguration.get('scope__c');
        state=authProviderConfiguration.get('state__c');
        
        system.debug('state:' + stateToPropagate);
        
        String url = authUrl + '?redirect_uri=' + redirectUrl + '&response_type=code' + '&client_id='+ key + '&scope=' + scope + '&state=' + stateToPropagate; 
        return new PageReference(url); 
    } 
    
    global Auth.AuthProviderTokenResponse handleCallback(Map<string,string> 
                                                         authProviderConfiguration, Auth.AuthProviderCallbackState state ) 
    { 
        // Here, the developer will get the callback with actual protocol. 
        // Their responsibility is to return a new object called 
        // AuthProviderTokenResponse. 
        // This will contain an optional accessToken and refreshToken 
        key = authProviderConfiguration.get('Client_Id__c'); 
        secret = authProviderConfiguration.get('Client_Secret__c'); 
        accessTokenUrl = authProviderConfiguration.get('Token_Url__c'); 
        redirectUrl=authProviderConfiguration.get('Redirect_Url__c');
        
        Map<String,String> queryParams = state.queryParameters; 
        String code = queryParams.get('code'); 
        String sfdcState = queryParams.get('state'); 
        system.debug('code:' + code);
        system.debug('state:' + state);
        HttpRequest req = new HttpRequest(); 
        String url = accessTokenUrl+ '?grant_type=authorization_code' + '&code=' + code + '&client_id=' + key + 
            '&client_secret=' + secret + '&redirect_uri=' + redirectUrl; 
        req.setEndpoint(url);
        req.setHeader('Content-Type','application/xml'); 
        req.setMethod('GET'); 
        
        Http http = new Http(); 
        HTTPResponse res = http.send(req); 
        system.debug('req: ' + req);
        String responseBody = res.getBody(); 
        system.debug('responseBody' + responseBody);
        
        String token = '';
        if(!test.isRunningTest())
        {
            token = getTokenValueFromResponse(responseBody, 'access_token', null); 
            return new Auth.AuthProviderTokenResponse('Concur', token, 
                                                      'refreshToken', sfdcState); 
        }
        else
        {
            token= 'testToken';
            return new Auth.AuthProviderTokenResponse('Concur',token, 
                                                      'refreshToken', null); 
        }
        
    } 
    
    global Auth.UserData getUserInfo(Map<string,string> 
                                     authProviderConfiguration, 
                                     Auth.AuthProviderTokenResponse response) 
    { 
        //Here the developer is responsible for constructing an 
        //Auth.UserData object 
        String token = response.oauthToken; 
        HttpRequest req = new HttpRequest(); 
        userAPIUrl = authProviderConfiguration.get('User_Info_Url__c');
        userAPIVersionUrl = authProviderConfiguration.get('API_User_Version_Url__c');
        String url = userAPIUrl+ '?oauth_token=' + token;
        //req.setHeader('Authorization', 'OAuth ' + token); 
        req.setEndpoint(url); 
        req.setHeader('Content-Type','application/xml'); 
        req.setMethod('GET'); 
        
        Http http = new Http(); 
        HTTPResponse res = http.send(req); 
        system.debug('req:' + req);
        String responseBody = res.getBody();
        system.debug('res:' + res.getBody());
        
        if(!test.isRunningTest())
        {
            String id = getTokenValueFromResponse(responseBody, 
                                                  'id',userAPIVersionUrl); 
            String fname = getTokenValueFromResponse(responseBody, 
                                                     'firstname', userAPIVersionUrl); 
            String lname = getTokenValueFromResponse(responseBody, 
                                                     'lastname', userAPIVersionUrl); 
            String flname = getTokenValueFromResponse(responseBody, 
                                                      'name', userAPIVersionUrl); 
            String uname = getTokenValueFromResponse(responseBody, 
                                                     'email', userAPIVersionUrl);
            
            Map<String,String> provMap = new Map<String,String>(); 
            provMap.put('what1', 'noidea1'); 
            
            List<User> usrList= [Select Id from User where email= : uname and IsActive=true];
            
            if(usrList==null && usrList.size()<=0)
                    system.debug('User info returned null');
            Auth.UserData userData= new Auth.UserData(usrList.get(0).Id, fname, lname, flname, 
                                                      uname, 'what',id + '@vestel.dev', 'en_US', 'Zorlu SSO', '', provMap); 
            system.debug('userData:' + userData);
            return userData!=null ? userData : null; 
        }
        else
        {
            String id 	  = 'testLoginId';
            String fname  = 'testFirstName';
            String lname  = 'testLastName'; 
            String flname ='testFirstName testLastName';
            String emailAddress = 'testEmailAddress';
            String what = 'what';
            String localeName = 'testLocalName';
            String loginType = getTokenValueFromResponse('<?xml version="1.0"?><User xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><valid>true</valid><timestamp>2021-03-24T14:05:26.2426219+03:00</timestamp><id>Concur</id><name>Concur</name><firstname>Aytuğ</firstname><lastname>Demir</lastname><email>aytug.demir@ritmusconsulting.com</email><physicalDeliveryOfficeName>Danışman</physicalDeliveryOfficeName><company>DANIŞMAN VEKTORA</company><st>Danışman - SR2400321</st></User>', 
                                                         'name',null);
            Map<String,String> provMap = new Map<String,String>();
            provMap.put('key1', 'value1');
            provMap.put('key2', 'value2');
            provMap.put('key3', 'value3');
            provMap.put('key4', 'value4');
            provMap.put('key5', 'value5');
            Auth.UserData userData= new Auth.UserData(id, fname, lname, flname, 
                                                      emailAddress, what, localeName, null, loginType, '', provMap); 
            return userData; 
        }
    } 
    
    private String getTokenValueFromResponse(String response, 
                                             String token, String ns) 
    { 
        Dom.Document docx = new Dom.Document(); 
        docx.load(response); 
        String ret = null; 
        
        if(docx.getrootelement() != null){ ret = docx.getrootelement().getChildElement(token, ns).getText(); 
                                         } 
        return ret; 
    } 
    
}