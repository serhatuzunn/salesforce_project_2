({
	    Init : function(component, event, helper) {

        helper.setBusy(component,true);
        var recordId = component.get("v.recordId");
        var action = component.get("c.initialize");

        action.setParams({"recordId": recordId});
        action.setCallback(this, function(response) { 
            console.log(response.getReturnValue());
            console.log(response.getError());
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){  
                  if(result.Message == ''){
                component.set("v.currentRecordName", result.AccountName); 
                component.set("v.referanceRecordName", result.ReferanceName); 
                  }
                else{
                     var toggleText = component.find("Save");
                      $A.util.toggleClass(toggleText, "toggle");
                    
                }
            }
			 helper.setBusy(component,false);
        });
        $A.enqueueAction(action);
                
    },
    
        handleClick : function (component, event, helper) {
     
        helper.setBusy(component,true);
      	var recordId = component.get("v.recordId");
        var action = component.get("c.sendcustomer");
        
        action.setParams({"recordId": recordId});
        action.setCallback(this, function(response) { 
            console.log(response.getReturnValue());
            console.log(response.getError());
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){  
                 if(result.Message == ''){
                     	var warningStockMessage = "Oluştururken Hata! :(";
                        helper.showMessageToast(warningStockMessage,'Warning');
                        
                 }
                else if(result.Message == 'Test')
                {
                    helper.showMessageToast('Test Request','Warning');
                }
                    else{
                        helper.showMessageToast(result.Message,'Warning');
                             $A.get('e.force:refreshView').fire();
                    }
            }
			 helper.setBusy(component,false);
        });
        $A.enqueueAction(action);
        
    },
    
})