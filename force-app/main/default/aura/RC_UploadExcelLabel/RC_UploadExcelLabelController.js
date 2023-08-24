({
    excelImport: function(component, event, helper) {
        helper.setBusy(component,true);
        if (component.find("excelUploadButton").get("v.files").length > 0) {
            helper.uploadHelper(component, event,helper);
        } else {
            helper.showMessage(component, "error","Please Select A File.");
        }
        helper.setBusy(component,false);
    },
 
    removeFiles: function(component, event, helper) {
        component.find('excelUploadButton').set('v.files', []);
        component.set("v.fileName", "");
        component.set("v.isExistFile",false);
        component.set("v.isUploaded",false);
    },
    
    downloadExampleExcelFile : function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        
        window.open(baseURL+'/resource/Product_Label_Excel','_blank');
    },	
    
    SaveExcel : function(component, event, helper){
        helper.setBusy(component,true);
        debugger;
        var isVisibleChecked = component.get("v.isVisibleChecked");
       var excelResult =  component.get("v.excel");
         helper.setBusy(component,true);
            var action=component.get("c.saveExcel")
            action.setParams({"excel" : excelResult,
                              "isVisibleChecked":isVisibleChecked});
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result=response.getReturnValue();
                console.log("result" , JSON.stringify(result));
                if (result) {
                        helper.setBusy(component,false);
                        helper.showMessage(component, "success","Dosya Başarıyla Yüklendi.");
                }else{
                    helper.showMessage(component, "error",'Dosya Aktarılamadı.!');
                    helper.setBusy(component,false);
                }
                 helper.setBusy(component,false);
            });
            $A.enqueueAction(action);
    },
    
    isVisibleChange : function(component,event,helper){
        //Tali Bayi Checkbox On Change.
    }

})