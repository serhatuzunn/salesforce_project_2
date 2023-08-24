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
                var sapId=result.acc.RC_SAP_ID__c;
                var token=result.token_info;
                console.log('link:' + 'https://bw.vestel.com.tr:8443/BOE/OpenDocument/opendoc/openDocument.jsp?sIDType=CUID&iDocID=AYwfUrw5urhHntLgUFPuwCw&lsSCustomer=' + sapId + '&token=' +token);
                component.set("v.reportLink",'https://bw.vestel.com.tr:8443/BOE/OpenDocument/opendoc/openDocument.jsp?sIDType=CUID&iDocID=AYwfUrw5urhHntLgUFPuwCw&lsSCustomer=' + sapId + '&token=' +token);
                component.set("v.reportLinkRetail",'https://bw.vestel.com.tr:8443/BOE/OpenDocument/opendoc/openDocument.jsp?sIDType=CUID&iDocID=AY9a9eMBa7xNncXXHkh3h0g&lsSCustomer=' + sapId + '&token=' +token);
                component.set("v.reportLinkTotal",'https://bw.vestel.com.tr:8443/BOE/OpenDocument/opendoc/openDocument.jsp?sIDType=CUID&iDocID=AT2CuzQR4BZNt2GU4IYvngg&lsSCustomer=' + sapId + '&token=' +token);
                component.set("v.reportSalesPerformance",'https://bw.vestel.com.tr:8443/BOE/OpenDocument/opendoc/openDocument.jsp?sIDType=CUID&iDocID=ASu2NxTd8vlDpSL6YeTfnAI&X_BAYI=' + sapId + '&token=' +token);
                component.set("v.reportAccrualBonus",'https://bw.vestel.com.tr:8443/BOE/OpenDocument/opendoc/openDocument.jsp?sIDType=CUID&iDocID=AazOUfjpga9OgvdZa_3kEfc&X_BAYI=' + sapId + '&token=' +token);
                component.set("v.reportRetailBonus",'https://bw.vestel.com.tr:8443/BOE/OpenDocument/opendoc/openDocument.jsp?sIDType=CUID&iDocID=Af_zIulDHLlHh.if1Aeg5U8&X_BAYI=' + sapId + '&token=' +token);
            } 
           
        });
        $A.enqueueAction(action);
    }
})