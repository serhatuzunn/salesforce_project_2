({
    setBusy : function(component, state){
        component.set("v.loading", state); 
    },
    showMessageToast : function(message, type) {
        console.log('toast');
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({
                title: "",
                message: message,
                type: type
            });
            toastEvent.fire();
        }
    },
    getConnections: function(component)
    {
        this.setBusy(component,true);
        var action = component.get("c.GetConnections");
        action.setParams({"selectedAccount": component.get("v.selectedAccount"),"selectedConnectionPeriod" : component.get("v.selectedConnection"),
                          "selectedBordroType" : component.get("v.selectedPayrollType"), "selectedPayroll"  : component.get("v.selectedPayroll")
                         });
        
        action.setCallback(this, function(response) { 
            
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                var result = response.getReturnValue();
                if(result!=null && result.length>0)
                {
                    console.log('result: ' + JSON.stringify(result));
                    component.set("v.connectionData", result);                    
                }
                else{
                    this.showMessageToast('Kayıt Bulunamadı', 'warning');
                    
                }
                
                
            }
            else
            {   
                this.setBusy(component,false);
                this.showMessageToast('Kayıtlar Çekilirken Hata Oluştu', 'error');
            }
            this.setBusy(component,false);
        });
        $A.enqueueAction(action);
    }
})