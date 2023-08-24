public class RC_HRServices_GetNewEmployee {
    
    public class PreparedName
    {
        public string FirstName {get;set;}
        public string LastName  {get;set;}
    }
    
    @future (callout = true)
    public static void FindNewEmployees()
    {
        HRKurumsalServis.BasicHttpBinding_IService hr=  new HRKurumsalServis.BasicHttpBinding_IService();
        
        HRKurumsalServis.GetNewEmployeeRequest req = new HRKurumsalServis.GetNewEmployeeRequest();
        HRKurumsalServis.EmployeeResponse      res = new HRKurumsalServis.EmployeeResponse();
        
        req.AppId      = System.Label.RC_HRServices_AppId;
        req.AppKeyHash = System.Label.RC_HRServices_AppKey;   
        req.SirketKodu = System.Label.RC_HRServices_SirketKodu;
        res            = hr.GetNewEmployee(req);
            
        if(res.EmployeeList!=null && res.EmployeeList.EmployeeData.size()>0){

            ProfileAndRoles profileAndRoleMaps = GetProfileAndRoleList();
            
            List<User> userList = new List<User>();
            
            List<String> positionList = new List<String>();
            
            Schema.DescribeFieldResult positionPickList = RC_Definition__c.RC_Employee_Positions__c.getDescribe();
            List<Schema.PicklistEntry> positionPickListValues = positionPickList.getPicklistValues();
            for( Schema.PicklistEntry positionVal : positionPickListValues)
            {
                positionList.add(positionVal.getValue());
            }
            
            
            if(positionList != null && positionList.size()>0){
                
                Map<String,String> managerMap = new Map<String,String>();
                Map<String,String> manager2Map = new Map<String,String>();
                
                Map<String,User> allUserMap = new Map<string,User>();
				List<User> allUser = [Select Id,Name,email from USER];
                for(User allUsrItem : allUser)
                {
                    allUserMap.put(allUsrItem.email,allUsrItem);
                }
                
                for(HRKurumsalServis.EmployeeData employee : res.EmployeeList.EmployeeData){

                    if(positionList.contains(employee.Pozisyon) && employee.NormKadro!='MÜŞTERİ HİZMETLERİ' && !string.isBlank(employee.ADLoginName)){
                        
                        managerMap.put(employee.SicilNo,employee.Yonetici);  
                        manager2Map.put(employee.SicilNo,employee.IkinciYonetici);  
                        
                   
                        User usr=new User();
                        PreparedName splittedName = NameSplitter(employee.AdSoyad);
                        usr.LocaleSidKey					= 'en_US';
                        usr.TimeZoneSidKey 					= 'GMT';
                        usr.LanguageLocaleKey 				= 'en_US';
                        usr.EmailEncodingKey 				= 'UTF-8';
                        usr.ProfileID 						= profileAndRoleMaps.profiles.get(employee.Pozisyon);
                        usr.UserRoleId    					= profileAndRoleMaps.roles.get(employee.DepartmanKodu + '-' + employee.Pozisyon);
                        usr.FirstName    					= splittedName.FirstName;
                        usr.Username 						= employee.ADLoginName + '@vestel.dev';
                        usr.Alias							= employee.ADLoginName.length() > 7 ? employee.ADLoginName.substring(0,6) : employee.ADLoginName;
                        usr.RC_Registiration_No__c          = employee.SicilNo;
                        usr.EmployeeNumber 					= employee.SicilNo;
                        usr.RC_Gender__c				    = employee.Cinsiyet=='Kadın' ? 'F'  : 'M';  
                        usr.RC_Blue_Collar_White_Collar__c  = String.isNotBlank(employee.BeyazMavi) ? employee.BeyazMavi  : '';   
                        usr.RC_Btrtl_Definition__c 		    = String.isNotBlank(employee.BtrtlKodu) ? employee.BtrtlKodu  : '';       
                        usr.MobilePhone 				    = String.isNotBlank(employee.CepTelefonu) ? employee.CepTelefonu  : '';     
                        usr.Department 					    = String.isNotBlank(employee.Departman) ? employee.Departman  : '';   
                        usr.RC_Departmant__c 			    = String.isNotBlank(employee.DepartmanKodu) ? employee.DepartmanKodu  : '';   
                        usr.Email 						    = String.isNotBlank(employee.Email) ? employee.Email.replace('@','_invalid@')  : '';
                        usr.RC_Location__c 					= String.isNotBlank(employee.Lokasyon) ? employee.Lokasyon  : '';             
                        usr.RC_Cost_Center__c 				= String.isNotBlank(employee.MasrafYeriKodu) ? employee.MasrafYeriKodu  : ''; 
                        usr.RC_Job__c 						= String.isNotBlank(employee.MeslekKodu) ? employee.MeslekKodu  : ''; 
                        usr.RC_Norm_Staff__c 				= String.isNotBlank(employee.NormKadro) ? employee.NormKadro  : '';
                        usr.RC_Office_Name__c 				= String.isNotBlank(employee.OfisAdi) ? employee.OfisAdi  : '';   
                        usr.RC_Position__c 					= String.isNotBlank(employee.PozisyonKodu) ? employee.PozisyonKodu  : '';  
                        usr.CompanyName 					= String.isNotBlank(employee.SirketIsmi) ? employee.SirketIsmi  : ''; 
                        usr.RC_Company__c					= String.isNotBlank(employee.SirketKodu) ? employee.SirketKodu  : '';
                        usr.LastName 						= String.isNotBlank(employee.Soyad) ? employee.Soyad  : '';   
                        usr.Phone 							= String.isNotBlank(employee.Telefon) ? employee.Telefon  : '';   
                        usr.RC_Upper_Departmant__c		    = String.isNotBlank(employee.UstDepartmanKodu) ? employee.UstDepartmanKodu  : '';    
                        usr.RC_Werks_Definition__c          = String.isNotBlank(employee.WerksKodu) ? employee.WerksKodu  : ''; 
                        usr.IsActive 						= true;

                        
                        if(employee.GirisTarihi != null){
                            DateTime dT 					= employee.GirisTarihi;
                            Date myDate 					= date.newinstance(dT.year(), dT.month(), dT.day());
                            usr.RC_Start_Date__c 			= myDate;  
                        } 
                        if(employee.CikisTarihi != null){
                            DateTime dT 					= employee.CikisTarihi;
                            Date myDate 					= date.newinstance(dT.year(), dT.month(), dT.day());
                            usr.RC_End_Date__c              = myDate;  
                        } 
                        system.debug('splittedName.FirstName:' + splittedName.FirstName + ' ' + 'splittedName.LastName:' + ' ' + splittedName.LastName);
                        userList.add(usr);       
                    

                    }
                    
                    
                }

                if(userList.size() >0)
                {
                    Set<Id> addedUsers = new Set<Id>();
                    Schema.SObjectField regNo = User.Fields.RC_Registiration_No__c;
                    Database.UpsertResult[] srList = Database.upsert(userList, regNo, false);
                    for (Database.UpsertResult sr : srList) {
                        if (sr.isSuccess()) {
                            addedUsers.add(sr.getId());
                            System.debug('Successfully inserted account. User ID: ' + sr.getId());
                        }
                        else {             
                            for(Database.Error err : sr.getErrors()) {          
                                System.debug('error::' + err.getStatusCode() + ': ' + err.getMessage());
                            }
                        }
                    }
                    
                    if(addedUsers.size()>0)
                    {
                        List<String> mappedMngrList = managerMap.values();
                        List<String> mappedMngr2List = manager2Map.values();
                        List<User> usrLst= [Select Id,RC_Registiration_No__c,ManagerId,RC_Job__c,RC_Position__c FROM User Where Id IN:addedUsers];
                        List<User> mngLst = [Select Id,RC_Registiration_No__c,ManagerId,RC_Job__c,RC_Position__c FROM User Where RC_Registiration_No__c IN:mappedMngrList OR RC_Registiration_No__c IN:mappedMngr2List];
                        Map<String,String> managers = new Map<String,String>();

                        for(User mng : mngLst)
                        {
                            managers.put(mng.RC_Registiration_No__c,mng.Id);

                        }
                        for(User usr : usrLst)
                        {
                            system.debug('usr:' + usr);
                            if(managerMap.containsKey(usr.RC_Registiration_No__c))
                            {
                                system.debug('usr.RC_Registiration_No__c:' +managerMap.get(usr.RC_Registiration_No__c));
                                if(managers.containsKey(managerMap.get(usr.RC_Registiration_No__c)))
                                {
                                    
                                    string managerId = managers.get(managerMap.get(usr.RC_Registiration_No__c));
                                    usr.ManagerId = managerId;
                                }
                                    
                            }
                            if(manager2Map.containsKey(usr.RC_Registiration_No__c))
                            {
                                if(managers.containsKey(manager2Map.get(usr.RC_Registiration_No__c)))
                                {
                                    string manager2Id = managers.get(manager2Map.get(usr.RC_Registiration_No__c));
                                    usr.RC_ManagerId_2__c  = manager2Id;
                                }
                                    
                            }
                        }
                        
                        Database.SaveResult[] updateList = Database.update(usrLst, false);
                        for (Database.SaveResult up : updateList) {
                            if (up.isSuccess()) {
                                
                                System.debug('Successfully updated account. User ID: ' + up.getId());
                            }
                            else {             
                                for(Database.Error err : up.getErrors()) {          
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                }
                            }
                        }
                    }
                }
                
            }
            
            
        } 
    }
    public static PreparedName NameSplitter(string fullName)
    {
        string[] nameRecords=fullName.split(' ');
        
        PreparedName splittedNames= new PreparedName();
        if(nameRecords.size()==1) return splittedNames;
        
        switch on nameRecords.size()
        {
            when 2
            {
                splittedNames.FirstName=nameRecords[0];
                splittedNames.LastName =nameRecords[1];
            }
            when 3
            {
                splittedNames.FirstName= nameRecords[0] + ' ' + nameRecords[1];
                splittedNames.LastName = nameRecords[2];
            }
            when else
            {
                splittedNames.FirstName= nameRecords[0] + ' ' + nameRecords[1];
                splittedNames.LastName = nameRecords[2] + ' ' + nameRecords[3];
            }
        }
        
        return splittedNames;
    }
    
    public class ProfileAndRoles
    {
        public Map<string,string> profiles{get;set;}
        public Map<string,string> roles{get;set;}
    }
    
    public static ProfileAndRoles GetProfileAndRoleList()
    {
        ProfileAndRoles result = new ProfileAndRoles();
        Map<string,string> profileList = new Map<string,string>();
        Map<string,string> roleList = new Map<string,string>();
        Map<string,string> profileMap = new Map<string,string>();
        Map<string,string> roleMap = new Map<string,string>();
        
        for(Profile profileItem : [SELECT Id,Name FROM Profile]){
            profileMap.put(profileItem.Name,profileItem.Id);
        }
        for(UserRole roleItem : [SELECT Id,Name,DeveloperName From UserRole]){
            roleMap.put(roleItem.DeveloperName,roleItem.Id);
        }
        
        List<RC_Definition__c> profileAndRoleList = [SELECT Id, Name, RC_Employee_Positions__c, RC_Department__c, RC_Value__c, Type__c FROM RC_Definition__c WHERE Type__c='Profile' OR Type__c='Role'];
        
        if(profileAndRoleList!=null && profileAndRoleList.size()>0)
        {
            for(RC_Definition__c item : profileAndRoleList){
                
                if(item.Type__c=='Profile')
                {
                    profileList.put(item.RC_Employee_Positions__c,profileMap.get(item.RC_Value__c));
                }
                if(item.Type__c=='Role')
                {
                    roleList.put(item.RC_Department__c + '-' + item.RC_Employee_Positions__c, roleMap.get(item.RC_Value__c));   
                }
            }
            result.profiles = profileList;
            result.roles = roleList;
            system.debug('roleList:' + roleList);
        }

        return result;
    }
}