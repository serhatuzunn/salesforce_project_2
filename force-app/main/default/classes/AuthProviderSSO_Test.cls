@IsTest
public class AuthProviderSSO_Test {
 
    private static final String OAUTH_TOKEN = 'testToken';
    private static final String STATE = 'mocktestState';
    private static final String REFRESH_TOKEN = 'refreshToken';
    private static final String LOGIN_ID = 'testLoginId';
    private static final String USERNAME = 'testUsername';
    private static final String FIRST_NAME = 'testFirstName';
    private static final String LAST_NAME = 'testLastName';
    private static final String EMAIL_ADDRESS = 'testEmailAddress';
    private static final String LOCALE_NAME = 'testLocalName';
    private static final String FULL_NAME = FIRST_NAME + ' ' + LAST_NAME;
    private static final String PROVIDER = 'Concur';
    private static final String REDIRECT_URL = 'http://localhost/services/authcallback/orgId/Concur';
    private static final String KEY = 'testKey';
    private static final String SECRET = 'testSecret';
    private static final String STATE_TO_PROPOGATE  = 'testState';
    private static final String ACCESS_TOKEN_URL = 'http://www.dummyhost.com/accessTokenUri';
    private static final String API_USER_VERSION_URL = 'http://www.dummyhost.com/user/20/1';
    private static final String AUTH_URL = 'http://www.dummy.com/authurl';
    private static final String API_USER_URL = 'www.concursolutions.com/user/api';
 
    // in the real world scenario , the key and value would be read from the (custom fields in) custom metadata type record
    private static Map<String,String> setupAuthProviderConfig () {
            Map<String,String> authProviderConfiguration = new Map<String,String>();
           authProviderConfiguration.put('Key__c', KEY);
           authProviderConfiguration.put('Auth_Url__c', AUTH_URL);
           authProviderConfiguration.put('Secret__c', SECRET);
           authProviderConfiguration.put('Access_Token_Url__c', ACCESS_TOKEN_URL);
           authProviderConfiguration.put('API_User_Url__c',API_USER_URL);
           authProviderConfiguration.put('API_User_Version_Url__c',API_USER_VERSION_URL);
           authProviderConfiguration.put('Redirect_Url__c',REDIRECT_URL);
           return authProviderConfiguration;
          
    }
 
    static testMethod void testInitiateMethod() {
           String stateToPropogate = 'mocktestState';
           Map<String,String> authProviderConfiguration = setupAuthProviderConfig();
           AuthProviderSSO concurCls = new AuthProviderSSO();
           concurCls.redirectUrl = authProviderConfiguration.get('Redirect_Url__c');
           
           PageReference expectedUrl =  new PageReference(authProviderConfiguration.get('Auth_Url__c') + '?client_id='+ 
                                               authProviderConfiguration.get('Key__c') +'&scope=USER,EXPRPT,LIST&redirect_uri='+ 
                                               authProviderConfiguration.get('Redirect_Url__c') + '&state=' + 
                                               STATE_TO_PROPOGATE);
           PageReference actualUrl = concurCls.initiate(authProviderConfiguration, STATE_TO_PROPOGATE);
           //System.assertEquals(expectedUrl.getUrl(), actualUrl.getUrl());
       }
    
    static testMethod void testHandleCallback() {
           Map<String,String> authProviderConfiguration = setupAuthProviderConfig();
           AuthProviderSSO concurCls = new AuthProviderSSO();
           concurCls.redirectUrl = authProviderConfiguration.get('Redirect_Url_c');
 
           Test.setMock(HttpCalloutMock.class, new ConcurMockHttpResponseGenerator());
 
           Map<String,String> queryParams = new Map<String,String>();
           queryParams.put('code','code');
           queryParams.put('state',authProviderConfiguration.get('State_c'));
           Auth.AuthProviderCallbackState cbState = new Auth.AuthProviderCallbackState(null,null,queryParams);
           Auth.AuthProviderTokenResponse actualAuthProvResponse = concurCls.handleCallback(authProviderConfiguration, cbState);
           Auth.AuthProviderTokenResponse expectedAuthProvResponse = new Auth.AuthProviderTokenResponse('Concur', OAUTH_TOKEN, REFRESH_TOKEN, null);
           
           System.assertEquals(expectedAuthProvResponse.provider, actualAuthProvResponse.provider);
           System.assertEquals(expectedAuthProvResponse.oauthToken, actualAuthProvResponse.oauthToken);
           System.assertEquals(expectedAuthProvResponse.oauthSecretOrRefreshToken, actualAuthProvResponse.oauthSecretOrRefreshToken);
           System.assertEquals(expectedAuthProvResponse.state, actualAuthProvResponse.state);
           
 
    }
    
    
    static testMethod void testGetUserInfo() {
           Map<String,String> authProviderConfiguration = setupAuthProviderConfig();
           AuthProviderSSO concurCls = new AuthProviderSSO();
                      
           Test.setMock(HttpCalloutMock.class, new ConcurMockHttpResponseGenerator());
 
           Auth.AuthProviderTokenResponse response = new Auth.AuthProviderTokenResponse(PROVIDER, OAUTH_TOKEN ,'sampleOauthSecret', STATE);
           Auth.UserData actualUserData = concurCls.getUserInfo(authProviderConfiguration, response) ;
           
           Map<String,String> provMap = new Map<String,String>();
           provMap.put('key1', 'value1');
           provMap.put('key2', 'value2');
                     
           Auth.UserData expectedUserData = new Auth.UserData(LOGIN_ID, FIRST_NAME, LAST_NAME, FULL_NAME, EMAIL_ADDRESS,
                          null, LOCALE_NAME, null, PROVIDER, null, provMap);
          
           System.assertNotEquals(expectedUserData,null);
           System.assertEquals(expectedUserData.firstName, actualUserData.firstName);
           System.assertEquals(expectedUserData.lastName, actualUserData.lastName);
           System.assertEquals(expectedUserData.fullName, actualUserData.fullName);
           System.assertEquals(expectedUserData.email, actualUserData.email);
           System.assertEquals(expectedUserData.username, actualUserData.username);
           System.assertEquals(expectedUserData.locale, actualUserData.locale);
           System.assertEquals(expectedUserData.provider, actualUserData.provider);
           //System.assertEquals(expectedUserData.siteLoginUrl, actualUserData.siteLoginUrl);
    }
    
    
   // implementing a mock http response generator for concur 
   public  class ConcurMockHttpResponseGenerator implements HttpCalloutMock {
     public HTTPResponse respond(HTTPRequest req) {
        String namespace = API_USER_VERSION_URL;
        String prefix = 'mockPrefix';
 
        Dom.Document doc = new Dom.Document();
        Dom.XmlNode xmlNode =  doc.createRootElement('mockRootNodeName', namespace, prefix);
        xmlNode.addChildElement('LoginId', namespace, prefix).addTextNode(LOGIN_ID);
        xmlNode.addChildElement('FirstName', namespace, prefix).addTextNode(FIRST_NAME);
        xmlNode.addChildElement('LastName', namespace, prefix).addTextNode(LAST_NAME);
        xmlNode.addChildElement('EmailAddress', namespace, prefix).addTextNode(EMAIL_ADDRESS);
        xmlNode.addChildElement('LocaleName', namespace, prefix).addTextNode(LOCALE_NAME);            
        xmlNode.addChildElement('Token', null, null).addTextNode(OAUTH_TOKEN);
        System.debug(doc.toXmlString());
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody(doc.toXmlString());
        res.setStatusCode(200);
        return res;
    }
   
  }
}