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
                component.set('v.creditAnalysisIsSucess', false);
            }
            else if(component.isValid() && response.getState() == "SUCCESS"){ 
                component.set('v.creditAnalysisIsSucess', result.isSuccess);
            }
            
            helper.setBusy(component,false);
            
        });
        
        $A.enqueueAction(action);
    },
    handleCloseModal : function(component, event, helper){
        window.location.reload();     
    }
})