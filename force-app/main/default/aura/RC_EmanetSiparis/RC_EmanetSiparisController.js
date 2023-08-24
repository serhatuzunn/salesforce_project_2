({
    emanetSiparisClick : function (component, event, helper) {
        
        helper.setBusy(component,true);
        
        var productCodeText = component.find("inputUrunKod").get("v.value");
        console.log(productCodeText);
        
        var action = component.get("c.buttonClick");
        
        action.setParams({productCode: productCodeText});
        
        action.setCallback(this, function(response) { 
            console.log('response: ' + JSON.stringify(response.getReturnValue()));
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                component.set('v.AllEmanetSiparis', result.EmanetSiparisTableList);  
                component.set('v.AllEmanetSiparisTrue', true);
            }
            else{ 
                console.log('HATA response: ' + response);
                component.set('v.AllEmanetSiparis', null);
                component.set('v.AllEmanetSiparisTrue', false);
            }
            
            helper.setBusy(component,false);
        });
        
        $A.enqueueAction(action);
        
    }
})