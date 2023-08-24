({	
	
    handlePdfSelection: function(component, event, helper){
        var name = event.getSource().get('v.name');
        var label = event.getSource().get('v.label');
        
        /*var selectedPdfLanguage = component.get("v.languageRadio");*/
        /*var selectedPdfLanguage = component.get("v.languageRadio");
        component.set("v.languageRadio", selectedPdfLanguage);
        alert(selectedPdfLanguage);*/
        
        component.set("v.selectedPdf", name);
        component.set("v.selectedPdfLabel", label);
       
    },
    
    getData: function(component,event,helper)
    {
        
        var recordId = component.get("v.recordId");
        var action = component.get("c.getCanalData"); // backend
        action.setParams({"recordId": recordId});// backend
        action.setCallback(this, function(response) { 
            var result = response.getReturnValue();
            
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){
                	component.set("v.activeVPO",result.responseWrp.activeVPO);
                	component.set("v.activeKamu",result.responseWrp.activeKamu);
                     component.set("v.activeOther",result.responseWrp.activeOther);
                    component.set("v.canalName",result.responseWrp.canalName);
              }
        
        });
     	$A.enqueueAction(action);
    },
    
    handleCloseNavigate: function (component,event,helper)
    {
        component.set("v.isShow","false");
        return;
    },
    
    handleConfirmedNavigate: function (component, event, helper) {

        var operation = event.getSource().get('v.name');
        var selectedPdf = component.get("v.selectedPdf");
        var selectedPdfLanguage = component.get("v.languageRadio");
        
        if(selectedPdf == null || selectedPdf == '' || !selectedPdf){
            helper.showMessage(component, 'error', 'PDF seçiniz!');
            return;
        }
        
        var recordId = component.get("v.recordId");
        
             /*var url = "/apex/" + selectedPdf + operation + "?id=" + recordId;*/
        			
        			var url = "";
                    
                    if(selectedPdfLanguage == "TR")
                    {
                        url = "/apex/" + selectedPdf + operation + "?id=" + recordId;
                    }
                    else
                    {
                        url = "/apex/" + selectedPdf + "ENG" + operation + "?id=" + recordId;
                    }
        
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": url,
                            "isredirect": false
                        });
                        urlEvent.fire();
    },
    
    onLanguageRadio: function(component, event, helper) {
	var selected = event.currentTarget.value;
        
    component.set("v.languageRadio", selected);
    
    //console.log(event.currentTarget.id);
    //console.log(event.currentTarget.name);
    //console.log(selected);
	},
    
    handleNavigate: function (component, event, helper) {

        var operation = event.getSource().get('v.name');
        var selectedPdf = component.get("v.selectedPdf");
        var selectedPdfLanguage = component.get("v.languageRadio");
        
        if(selectedPdf == null || selectedPdf == '' || !selectedPdf){
            helper.showMessage(component, 'error', 'PDF seçiniz!');
            return;
        }
        
        /******************************************************/
        var recordId = component.get("v.recordId");
        
        if(operation == "View")
        {
             var action = component.get("c.initialize"); // backend
        action.setParams({"recordId": recordId});// backend
        action.setCallback(this, function(response) { 
            var result = response.getReturnValue();
            
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){
                if(result.responseWrp.isShow == true)
                {
                	component.set("v.isShow",result.responseWrp.isShow);
                	component.set("v.emptyQuoteConditions",result.responseWrp.ReturnValue);
                }else
                {
                    var url = "";
                    
                    if(selectedPdfLanguage == "TR")
                    {
                        url = "/apex/" + selectedPdf + operation + "?id=" + recordId;
                    }
                    else
                    {
                        url = "/apex/" + selectedPdf + "ENG" + operation + "?id=" + recordId;
                    }
                    
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": url,
                            "isredirect": false
                        });
                        urlEvent.fire();
                }
            } 
        });
     $A.enqueueAction(action);
        }
        else
        {
            var action = component.get("c.savePdf"); // backend
            
            action.setParams({"recordId": recordId, "selectedPdf": selectedPdf, "selectedPdfLanguage": selectedPdfLanguage });// backend
            
        	action.setCallback(this, function(response) { 
            var result = response.getReturnValue();
            var error = response.getError();
               
            if(component.isValid() && response.getState() == "SUCCESS"){ 
                     location.reload();
            } 
        });
            $A.enqueueAction(action);
        } 
    }
})