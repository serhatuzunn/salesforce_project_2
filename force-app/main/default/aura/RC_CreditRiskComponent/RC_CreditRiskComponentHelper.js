({
    setBusy : function(component, state){
        component.set("v.loading", state); 
    },
    
    showMessageToast : function(message, type) {
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
    
    formatDate : function(component,event,helper,date){
        debugger;
        
        var y = date.substring(0,4);
        var m = date.substring(5,7);
        var d = date.substring(8,10);
        
        return [d, m, y].join('-');
        
    },
    
    prepareIpotekData : function(component, event, helper){
        var exportData = component.get("v.CreditRiskResponse.itemZ.IPOTEK_DETAY.item");
        var columns = [
            { label: $A.get("$Label.c.Document_Number"), fieldName: 'BELNR'},
            { label: $A.get("$Label.c.Period"), fieldName: 'GJAHR'},
            { label: $A.get("$Label.c.Document_Date"), fieldName: 'BUDAT'},
            { label: $A.get("$Label.c.Amount"), fieldName: 'DMBTR'},
            { label: $A.get("$Label.c.Expiry_Date"), fieldName: 'NETDT'},
            { label: $A.get("$Label.c.Bank"), fieldName: 'XBLNR'}
        ];
        
        helper.fileDownload(component, event, helper, exportData, columns);
        helper.setBusy(component, false);
    },
    prepareTeminatData : function(component, event, helper){
        var exportData = component.get("v.CreditRiskResponse.itemZ.TEMINAT_DETAY.item");
        var columns = [
            { label: $A.get("$Label.c.Document_Number"), fieldName: 'BELNR'},
            { label: $A.get("$Label.c.Period"), fieldName: 'GJAHR'},
            { label: $A.get("$Label.c.Document_Date"), fieldName: 'BUDAT'},
            { label: $A.get("$Label.c.Amount"), fieldName: 'DMBTR'},
            { label: $A.get("$Label.c.Expiry_Date"), fieldName: 'NETDT'},
            { label: $A.get("$Label.c.Bank"), fieldName: 'XBLNR'}
        ];
        
        helper.fileDownload(component, event, helper, exportData, columns);
        helper.setBusy(component, false);
    },
    prepareTeminatIpotegiData : function(component, event, helper){
        var exportData = component.get("v.CreditRiskResponse.itemZ.TEMINATIPOTEK_DETAY.item");
        var columns = [
            { label: $A.get("$Label.c.Document_Number"), fieldName: 'BELNR'},
            { label: $A.get("$Label.c.Period"), fieldName: 'GJAHR'},
            { label: $A.get("$Label.c.Document_Date"), fieldName: 'BUDAT'},
            { label: $A.get("$Label.c.Amount"), fieldName: 'DMBTR'},
            { label: $A.get("$Label.c.Expiry_Date"), fieldName: 'NETDT'},
            { label: $A.get("$Label.c.Bank"), fieldName: 'XBLNR'}
        ];
        
        helper.fileDownload(component, event, helper, exportData, columns);
        helper.setBusy(component, false);
    },
    
    prepareDtsKasaCekiData : function(component, event, helper){
        var exportData = component.get("v.CreditRiskResponse.itemZ.DTSTEMCEK_DETAY.item");
        var columns = [
            { label: $A.get("$Label.c.Document_Number"), fieldName: 'BELNR'},
            { label: $A.get("$Label.c.Period"), fieldName: 'GJAHR'},
            { label: $A.get("$Label.c.Document_Date"), fieldName: 'BUDAT'},
            { label: $A.get("$Label.c.Amount"), fieldName: 'DMBTR'},
            { label: $A.get("$Label.c.Expiry_Date"), fieldName: 'NETDT'},
            { label: $A.get("$Label.c.Bank"), fieldName: 'XBLNR'}
        ];
        
        helper.fileDownload(component, event, helper, exportData, columns);
        helper.setBusy(component, false);
    },
    
    prepareYenilenecekTeminatData : function(component, event, helper){
        var exportData = component.get("v.CreditRiskResponse.itemZ.YENILENECEK_KLM.item");
        var columns = [
            { label: $A.get("$Label.c.e_fiscal_year"), fieldName: 'GJAHR'},
            { label: $A.get("$Label.c.Document_Number"), fieldName: 'BELNR'},
            { label: $A.get("$Label.c.Document_Date"), fieldName: 'BUDAT'}
        ];
        
        helper.fileDownload(component, event, helper, exportData, columns);
        helper.setBusy(component, false);
    },
    
    prepareCekSenetDetayData : function(component, event, helper){
        debugger;
        var selectedComponentArray = component.get("v.SelectedGroupedCekSenet");
        var exportData = [];
        for(var i=0; i< selectedComponentArray.length; i++){
            for(var y=0; y<selectedComponentArray[i].ItemList.length; y++){
                exportData.push(selectedComponentArray[i].ItemList[y]);
            }
            
        }
        
        console.log(exportData);
        
        var columns = [
            { label: $A.get("$Label.c.Number"), fieldName: 'BOENO'},
            { label: $A.get("$Label.c.Maturity"), fieldName: 'VADE'},
            { label: $A.get("$Label.c.portfolio"), fieldName: 'PORTF'},
            { label: $A.get("$Label.c.Amount"), fieldName: 'TUTAR'}
        ];
        
        helper.fileDownload(component, event, helper, exportData, columns);
        helper.setBusy(component, false);
    },
    
    prepareKarsiliksizCekSenetData : function(component, event, helper){
        debugger;
        
        var exportData = [];
        var selectedComponentArray = component.get("v.SelectedKarsiliksizCekSenet").SelectedModalKarsiliksizList;
        console.log(JSON.stringify(selectedComponentArray));
        for(var i=0; i<selectedComponentArray.length; i++){
            for(var y=0; y<selectedComponentArray[i].ItemList.length; y++){
                exportData.push(selectedComponentArray[i].ItemList[y]);
            }
        }
        
        var columns = [
            { label: $A.get("$Label.c.Number"), fieldName: 'BOENO'},
            { label: $A.get("$Label.c.Maturity"), fieldName: 'VADE'},
            { label: $A.get("$Label.c.portfolio"), fieldName: 'PORTF'},
            { label: $A.get("$Label.c.Amount"), fieldName: 'TUTAR'}
        ];
        
        helper.fileDownload(component, event, helper, exportData, columns);
        helper.setBusy(component, false);
    },
    
    prepareBaglantiCekDetayData : function(component, event, helper){
        debugger;
        var exportData = component.get("v.SelectedBaglantiCekDetay.item");
        var columns = [
            { label: $A.get("$Label.c.Document_Number"), fieldName: 'BELNR'},
            { label: $A.get("$Label.c.Period"), fieldName: 'GJAHR'},
            { label: $A.get("$Label.c.Date"), fieldName: 'NETDT'},
            { label: $A.get("$Label.c.Amount"), fieldName: 'DMBTR'},
            { label: $A.get("$Label.c.Expiry_Date"), fieldName: 'H_BUDAT'},
            { label: $A.get("$Label.c.portfolio"), fieldName: 'PORTF'}
        ];
        
        helper.fileDownload(component, event, helper, exportData, columns);
        helper.setBusy(component, false);
    },
    
    fileDownload: function (component, event, helper, exportData, columns) {        
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component, exportData, columns);
        if (csv == null) { return; }
        
        var blob = new Blob(["\ufeff",csv], { type: "" });
        var fileName = 'Excel' + '.csv';
        
        window.saveAs(blob, fileName);       
    },
    
    convertArrayOfObjectsToCSV: function (component, objectRecords, columns) {
        debugger;
        
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider, keysHeader;
        debugger;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
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
        
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            
            for (var sTempkey in keys) {
                var skey = keys[sTempkey];
                
                // add , [comma] after every String value,. [except first]
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                var data = objectRecords[i][skey];
                if (data == undefined) {
                    data = '';
                }
                
                if(skey == 'TUTAR' || skey == 'DMBTR'){
                    data = parseFloat(data).toFixed(2);
                }
                
                csvStringResult += '"' + data + '"';
                
                counter++;
            } 
            csvStringResult += lineDivider;
        }
        
        return csvStringResult;
    }
    
})