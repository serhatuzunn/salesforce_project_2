public with sharing class RC_AddressMapPinningController {
    
    public string recordId { get; set; }
    public string objectName { get; set; }    
    public string address { get; set; }
    public string Location {get;set;}
    public decimal lat { get; set; }
    public decimal lon { get; set; }
    
    public string City {get;set;}
    public string Region {get;set;}
    public string District {get;set;}
    
    public RC_AddressMapPinningController()
    {  
        recordId = apexpages.currentpage().getparameters().get('recordId');
        objectName = apexpages.currentpage().getparameters().get('objectName');
        system.debug('recordIdConstractor : ' + recordId);
        system.debug('objectNameConstractor : ' + objectName);
        
        GetAddres();
        system.debug('address : ' + address);
    }
    
    //public string lexOrigin { get { return URL.getOrgDomainUrl().toExternalForm().split('.my.')[0]+'.lightning.force.com';} set;}
    
    public string GetAddres()
    {      
        try{            
            if (recordId != null && objectName != null) 
            {
                String searchedQuery = 'SELECT Id, RC_City__r.Name, RC_Region__r.Name, RC_Geolocation__Latitude__s, RC_Geolocation__Longitude__s FROM '+ objectName + ' WHERE Id= \'' + recordId + '\'' + ' LIMIT 1';
                SObject objectList = Database.query(searchedQuery);
                system.debug('objectList : ' + objectList);
                string city = (String) objectList.getSobject('RC_City__r').get('Name');          
                string region = (String) objectList.getSobject('RC_Region__r').get('Name');            
                address = region + ', ' + city + ', ' + 'Türkiye';
                
                decimal latitude = (decimal) objectList.get('RC_Geolocation__Latitude__s'); 
                system.debug('lat : ' + latitude);
                decimal longitude = (decimal) objectList.get('RC_Geolocation__Longitude__s');
                system.debug('lon : ' + longitude);
                lat = latitude;
                lon = longitude;
            }        
        }
        catch(Exception ex)
        {
            system.debug('Exception : ' + ex.getMessage());
        }
        return address;            
    }
    
    public void SetLocation()
    {
        try{
            system.debug('Location : ' + Location);
            system.debug('City : ' + City.toUpperCase('tr-TR'));
            system.debug('Region : ' + Region.toUpperCase('tr-TR'));
            system.debug('District : ' + District.toUpperCase('tr-TR'));
            if (recordId != null && objectName != null && Location != null) 
            {
                Location = Location.replace('(', '').replace(')', '');
                string Latitude = Location.split(',')[0];
                string Longitude = Location.split(',')[1];
                system.debug('Latitude, Longitude : ' + Latitude +', '+Longitude);
                
                String searchedQuery = 'SELECT Id, RC_Geolocation__Latitude__s, RC_Geolocation__Longitude__s,RC_City__c,RC_Region__c,RC_District__c FROM '+ objectName + ' WHERE Id= \'' + recordId + '\'' + ' LIMIT 1';
                SObject objectList = Database.query(searchedQuery);
                system.debug('objectList : ' + objectList);
                
                objectList.put('RC_Geolocation__Latitude__s', decimal.valueof(Latitude.trim()));          
                objectList.put('RC_Geolocation__Longitude__s', decimal.valueof(Longitude.trim())); 
                system.debug('objectList : ' + objectList);
                
                update objectList;
                
                Id cityId;
                Id regionId;
                Id districtId;
                if(City != null && Region != null && District != null)
                {                 
                    List<RC_City_Region__c> cities = [SELECT Id, RC_Country__c, RC_City__c, RC_Region__c, RC_District__c, Name, RC_Type__c, RC_Code__c FROM RC_City_Region__c where RC_Type__c='City' and Name=:City.toUpperCase('tr-TR') LIMIT 1];
                    system.debug('Cities : ' + cities);
                    if(cities != null && cities.size() > 0)
                        cityId = cities.get(0).Id;
                    
                    system.debug('cityId : ' + cityId);
                    if(cityId != null)
                    {
                        List<RC_City_Region__c> regions = [SELECT Id, RC_Country__c, RC_City__c, RC_Region__c, RC_District__c, Name, RC_Type__c, RC_Code__c FROM RC_City_Region__c where RC_Type__c='Region' and Name=:Region.toUpperCase('tr-TR') and RC_City__c=:cityId LIMIT 1];
                        system.debug('Regions : ' + regions);
                        if(regions != null && regions.size() > 0)
                            regionId = regions.get(0).Id;
                        
                        system.debug('regionId : ' + regionId);
                        if(regionId != null)
                        {
                            string likeValue = '%'+District.toUpperCase('tr-TR')+'%';
                            List<RC_City_Region__c> districts = [SELECT Id, RC_Country__c, RC_City__c, RC_Region__c, RC_District__c, Name, RC_Type__c, RC_Code__c FROM RC_City_Region__c where RC_Type__c='District' and Name LIKE : likeValue and RC_City__c=:cityId and RC_Region__c=:regionId LIMIT 1];
                            system.debug('Districts : ' + districts);
                            if(districts != null && districts.size() > 0)
                                districtId = districts.get(0).Id;
                            
                            system.debug('districtId : ' + districtId);
                            if(districtId != null)
                            {
                                objectList.put('RC_City__c', cityId);          
                                objectList.put('RC_Region__c', regionId); 
                                objectList.put('RC_District__c', districtId); 
                                system.debug('objectList after address set : ' + objectList);                                
                                update objectList;
                            }
                        }
                    }   
                }
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Record save successfully'));
            }   
        }
        catch(Exception ex)
        {
            system.debug('Exception : ' + ex.getMessage());
        }
    }
}