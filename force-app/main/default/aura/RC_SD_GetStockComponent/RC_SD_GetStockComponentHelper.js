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
            { label: $A.get("$Label.c.Product_Code"), fieldName: 'MATNR'},
            { label: $A.get("$Label.c.Product_Name"), fieldName: 'MALZEME_TANIM'},
            { label: $A.get("$Label.c.Production_Location"), fieldName: 'WERKS'},
            { label: $A.get("$Label.c.Warehouse_Location"), fieldName: 'LGORT'},
            { label: $A.get("$Label.c.Category"), fieldName: 'MAL_TANIM'},
            { label: $A.get("$Label.c.Brand"), fieldName: 'MARKA'},
            { label: $A.get("$Label.c.Salable_Stock"), fieldName: 'SAT_STOK'},
            { label: $A.get("$Label.c.Marketing_Stock"), fieldName: 'VESTEL_STOK'},
            { label: $A.get("$Label.c.Manufacturer_Stock"), fieldName: 'URETICI_STOK'},
            { label: $A.get("$Label.c.Delivery_Amount"), fieldName: 'TES_MIK'},
            { label: $A.get("$Label.c.Unlimited_Amount"), fieldName: 'TAHDITSIZ'},
            { label: $A.get("$Label.c.Sliding_Average_Price"), fieldName: 'KAYAR_ORT_FIYAT'}
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
        var fileName = 'Stok_Rapor.csv';
        
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
    selectedUretimYeriHelper : function (component, event){
               var selectedProductionPlace =  component.find("uretimYeriDrp").get("v.value");
        
        var allWarehousePlaceList = component.get('v.GetInitResponse').InitResponseModel.WarehousePlaceList;
        var optionsDepoYeri = [];
        
        selectedProductionPlace.forEach(function(firtSelect)  {
            var selectedList = allWarehousePlaceList.filter(element => element.ProductionPlace == firtSelect);
            
            selectedList.forEach(function(selectedList)  {
                optionsDepoYeri.push({ value: selectedList.Value, label: selectedList.ApiName});
            });
        });
        
        component.set("v.listDepoYeri", optionsDepoYeri); 
    }
})