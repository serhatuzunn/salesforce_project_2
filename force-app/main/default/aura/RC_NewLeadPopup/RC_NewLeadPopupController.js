({
    init : function(component, event, helper) {
        console.log('fired:');
        component.set("v.showModal", true);
        //var createRecordEvent = $A.get("e.force:createRecord");
        /* createRecordEvent.setParams({
            "entityApiName": "Lead",  
            "defaultFieldValues": {
                "Company" : "Vestel Ticaret AŞ" ,
                "LastName" : "Soyisim"
            }           
        }); */
        
        
        /*
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        var action = component.get("c.getRecordTypeIdByDeveloperName");
        action.setParams({recordTypeId : recordTypeId});
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if(state == "SUCCESS")
            {
                var recordTypeIdResponse = response.getReturnValue();
                createRecordEvent.setParams({
                    "entityApiName": "MYS_Open_Request__c"  ,
                    "recordTypeId": recordTypeIdResponse
                }); 
                createRecordEvent.fire();
                
                
            }
            else
            {
                console.log(JSON.stringfy(response.getError()));
            }
        });
*/        
        /** $A.enqueueAction(action);
             createRecordEvent.setParams({
                    "entityApiName": "MYS_Open_Request__c"  
               }); 
                createRecordEvent.fire();*/
        
        var action = component.get("c.getRecordTypes");
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if(state == "SUCCESS")
            {
                var response =response.getReturnValue();
                component.set('v.options',JSON.parse(response));
                component.set('v.value',JSON.parse(response)[0].value);
                //debugger;
            }
            else
            {
                console.log(JSON.stringfy(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    openActionWindowCan : function(component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        
        createRecordEvent.setParams({
            "entityApiName": "MYS_Open_Request__c" ,
            "recordTypeId": "0123L00000011bmQAA"
        }); 
        createRecordEvent.fire();
        /*window.open("https://vestel--vtsbxdev.lightning.force.com/lightning/o/MYS_Open_Request__c/new?count=2&recordTypeId=0123L00000011bmQAA&nooverride=1","_self");*/
        
        
        
    },
    openActionWindowExpress : function(component, event, helper) {
        
        var createRecordEvent = $A.get("e.force:createRecord");
        
        createRecordEvent.setParams({
            "entityApiName": "MYS_Open_Request__c" ,
            "recordTypeId": "0123L00000011brQAA"
        }); 
        createRecordEvent.fire();
        // window.open("https://vestel--vtsbxdev.lightning.force.com/lightning/o/MYS_Open_Request__c/new?count=2&recordTypeId=0123L00000011brQAA&nooverride=1","_self");
    },
    showModel: function(component, event, helper) {
        component.set("v.showModal", true);
        
    },
    
    hideModel: function(component, event, helper) {
        component.set("v.showModal", false);
        window.open("/00Q/o","_self");
        
        //aşağıdaki kodlar sayfayı yeniden yüklemediğinden custom lead ekranı yeniden açıldığından sayfa çalışmıyor.
       /* var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/00Q/o"
        });
        urlEvent.fire();*/
        /*
        var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                //"listViewId": listviews.Id,
                "listViewName": null,
                "scope": "Lead"
            });
            navEvent.fire();
        */
        
    },
    
    saveDetails: function(component, event, helper) {
        //component.set("v.showModal", false);
        
        var recordType = component.get("v.value");
        if(recordType != null && recordType != '')
        {
            var createRecordEvent = $A.get("e.force:createRecord");
            var objectName = '';
            var recordTypes = component.get('v.options');
            for(var i=0; i< recordTypes.length ; i++)
            {
                if(recordType == recordTypes[i].value) 
                {
                    objectName = recordTypes[i].sobjectName;
                    break;
                }
            }
            if(objectName != '')
            {
                createRecordEvent.setParams({
                    "entityApiName": objectName ,
                    "recordTypeId": recordType
                }); 
                createRecordEvent.fire();
            }
            else
            {
                alert('object not defined');
            }
        }
    },
})