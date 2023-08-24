({

    MAX_FILE_SIZE: 3000000, //Max file size 4.5 MB 

    uploadHelper: function(component, event,helper) {
		helper.setBusy(component,true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("excelUploadButton").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var fileName = file.name;
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
			helper.showMessage(component, "error","Dosya 3MB boyuntundan büyük olamaz.");
            helper.setBusy(component,false);
            return;
        }
 
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var acceptList = component.get("v.acceptList");
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            var splitted = file.name.split("."); 
            
            fileContents = fileContents.substring(dataStart);
			
			if(splitted.length > 1){
                    var uploadedExtension = splitted[splitted.length-1];
                    var invalidType = true;
                    for(var k = 0;k<acceptList.length;k++)
                    {
                        if(acceptList[k] == "."+uploadedExtension.toLowerCase())
                        {
                            invalidType = false;
                            helper.setBusy(component,false);
                            break;
                        }
                    }
                    if(invalidType) 
                    {
                        helper.showMessage(component, "error","Yanlış formatta bir dosya yüklediniz.");
                        component.set("v.isUploaded",false);
                        component.set("v.isExistFile",false);
                        helper.setBusy(component,false);
                        return;
                    }
                }else{
                    helper.showMessage(component, "error","HATA. ");
                    component.set("v.isUploaded",false);
                    component.set("v.isExistFile",false);
                    helper.setBusy(component,false);
                    return;
                }
            
            var action=component.get("c.getExcelData");
            action.setParams({"base64String" : fileContents});
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result=response.getReturnValue();
                console.log("result" , JSON.stringify(result));
                if (result.State) {
                    if(result!=null && result!=''){
                        component.set("v.isUploaded",true);
                        component.set("v.isExistFile",true);
                        component.set("v.fileName",fileName);
                        component.set("v.excel",result);
                        helper.setBusy(component,false);
                        helper.showMessage(component, "success","Dosya Başarıyla Yüklendi.");
                    }
                }else{
                    helper.showMessage(component, "error",result.ErrorMsg);
                }
            });
            $A.enqueueAction(action); 

        });
 
        objFileReader.readAsDataURL(file);
        
    },
    
    setBusy : function(component, state){
        component.set("v.loading", state); 
    },

	showMessage: function (component, type, message) {
        console.log('toast');
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                title: "",
                message: message,
                type: type
            });
            toastEvent.fire();
        }
    },
})