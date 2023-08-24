({
    setBusy : function(component, state){
        component.set("v.loading", state); 
    },
    showMessageToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type,
            duration : 10
        });
        toastEvent.fire();
    },
    prepareData : function(component, event, helper){   
        helper.fileDownload(component, event, helper);
        helper.setBusy(component, false);
    },
    convertArrayOfObjectsToCSV: function (component, objectRecords) {
        debugger;
        var columns = [
            { label: $A.get("$Label.c.MATNR"), fieldName: 'MATNR'},
            { label: $A.get("$Label.c.KUNNR"), fieldName: 'KUNNR'},
            { label: $A.get("$Label.c.MAKTX"), fieldName: 'MAKTX'},
            { label: $A.get("$Label.c.WERK"), fieldName: 'WERKS'},
            { label: $A.get("$Label.c.KULAB"), fieldName: 'KULAB'},
            { label: $A.get("$Label.c.CHARG"), fieldName: 'CHARG'},
            { label: $A.get("$Label.c.Brand"), fieldName: 'ZZMARKA'},
            { label: $A.get("$Label.c.Mal_Grubu"), fieldName: 'KONDM'}
        ];
        
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider, keysHeader;
        debugger;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords.StockResponseModel == null || !objectRecords.StockResponseModel.StockItemList.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ';';
        lineDivider = '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        
        var keys = [];
        var keysHeader = [];
        for (var i = 0; i < columns.length; i++) {
            var column = columns[i];
            
            keys.push(column.fieldName);
            keysHeader.push(column.label.replace(/(\r\n|\n|\r)/gm, ""));
        }
        
        csvStringResult = '';
        csvStringResult += "\"" + keysHeader.join("\"" + columnDivider + "\"") + "\"";
        csvStringResult += lineDivider;
        
        for (var i = 0; i < objectRecords.StockResponseModel.StockItemList.length; i++) {
            counter = 0;
            
            for (var sTempkey in keys) {
                var skey = keys[sTempkey];
                
                // add , [comma] after every String value,. [except first]
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                var data = objectRecords.StockResponseModel.StockItemList[i][skey];
                if (data == undefined) {
                    data = '';
                }

                csvStringResult += '"' + data + '"';

                counter++;
            } 
            csvStringResult += lineDivider;
        }
        
        return csvStringResult;
    },
    
    fileDownload: function (component, event, helper) {        
        var exportData = component.get("v.AllStockResponse");
        console.log(JSON.stringify(exportData));
        
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component, exportData);
        if (csv == null) { return; }
        
        var blob = new Blob(["\ufeff",csv], { type: "" });
        var fileName = 'Emanet_Stok_Rapor.csv';
        
        window.saveAs(blob, fileName);       
    },
    
     getVariants : function (component, event) {
        this.setBusy(component,true);
        var action = component.get("c.GetVariantList");
        
        action.setCallback(this, function(response) { 
            var result = response.getReturnValue();
            var error = response.getError();
            
            if(component.isValid() && response.getState() == "SUCCESS")
            {
                if(result!=null)
                {
                    component.set("v.userVariantList", result);
                    
                }
                else{
                    this.showMessageToast('Tanımlı Variant Bulunamadı.','Warning');
                    component.set("v.createVariantModal", false);
                    
                }
            }
            else
            {
                this.showMessageToast('Tanımlı Variant Bulunamadı.','Warning');
                component.set("v.createVariantModal", false);
            }
        });
        this.setBusy(component,false);
        component.set("v.variantListModal", true);
        $A.enqueueAction(action);
    },
    
})