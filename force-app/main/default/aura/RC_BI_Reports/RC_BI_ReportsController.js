({
    Init : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.initialize");
        
        action.setParams({"recordId": recordId});
        
        action.setCallback(this, function(response) { 
            console.log(response.getReturnValue());
            console.log(response.getError());
            var result = response.getReturnValue();
            var error = response.getError();
            if(component.isValid() && response.getState() == "SUCCESS"){  
                console.log('result:' + JSON.stringify(result));
                var token=result.token_info;
                console.log('link:' + 'https://bw.vestel.com.tr:8443/BOE/OpenDocument/opendoc/openDocument.jsp?sIDType=CUID&iDocID=AeIozCtV7CpGoSmbCflmXWI&token=' +token);
                component.set("v.reportLink",'https://bw.vestel.com.tr:8443/BOE/OpenDocument/opendoc/openDocument.jsp?sIDType=CUID&iDocID=AeIozCtV7CpGoSmbCflmXWI&token=' +token);
            } 
           
        });
        $A.enqueueAction(action);
    }
})