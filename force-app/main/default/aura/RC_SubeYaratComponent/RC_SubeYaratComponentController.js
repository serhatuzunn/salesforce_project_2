({
    Init : function(component, event, helper) {
        
        helper.setBusy(component,true);
        
        var recordId = component.get("v.recordId");
        var action = component.get("c.initialize");
        
        console.log('recordId: ' + recordId);
        
        action.setParams({recordId: recordId});
        action.setCallback(this, function(response) { 
            console.log('response: ' + JSON.stringify(response.getReturnValue()));
            console.log('response: ' + response.getError());
            var result = response.getReturnValue();
            var error = response.getError();
            if(response == null){
                component.set('v.subeYaratResponse', false);
            }
            else if(component.isValid() && response.getState() == "SUCCESS"){ 
                component.set('v.subeYaratResponse', result.isSuccess);
                component.set('v.subeYaratAccountId', result.accountId);
            }
            
            helper.setBusy(component,false);
            
        });
        
        $A.enqueueAction(action);
    } ,
    
    handleCloseModal : function(component, event, helper){
        var modalResult = component.get('v.subeYaratAccountId');
        console.log('modalResult : ' + modalResult);
        
        if(modalResult == ''){
            $A.get("e.force:closeQuickAction").fire();         
        }
        else{        
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/lightning/r/Account/" + modalResult +"/view"
            });
            urlEvent.fire();
        } 
    }
    
    
    
    
    
    
    
    
})