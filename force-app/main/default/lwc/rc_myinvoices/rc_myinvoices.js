import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';

import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent'

import { NavigationMixin } from "lightning/navigation";
import getInvoicesNew  from '@salesforce/apex/RC_MyInvoicesController.getInvoicesNew';
import getBillingDetail from '@salesforce/apex/RC_MyInvoicesController.getBillingDetail';
import getBillingIptIade from '@salesforce/apex/RC_MyInvoicesController.getBillingIptIade';
import initialize from '@salesforce/apex/RC_MyInvoicesController.initialize';


import getCategory1 from '@salesforce/apex/RC_MyInvoicesController.getCategory1';
import getCategory2 from '@salesforce/apex/RC_MyInvoicesController.getCategory2';
import getCategory3 from '@salesforce/apex/RC_MyInvoicesController.getCategory3';

// RC_FileSaver içeride oluşturulan Static Resources, loadScript ise yüklenen js static resource unu load etmek amacıyla tanımlandı.
import RC_FileSaver from '@salesforce/resourceUrl/RC_FileSaver';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import MyOrdersCSS from '@salesforce/resourceUrl/myordersCSS';

const actions = [{
    label: 'Detay',
    name: 'detay',
    iconName: 'utility:info',
},
{
    label: 'Fatura PDF',
    iconName: 'doctype:pdf',
    name: 'orderPDF'
}];

const columns = [];

export default class Rc_MyInvoices extends  NavigationMixin(LightningElement) {   
    
    columns = columns;
    searchedStartDateValue = null;
    searchedEndDateValue = null;
    searchedInvoiceValue = '';
    searchedProductCode = '';
    sourceData = [];

    @wire(getCategory1) 
    objectCategory1s;

    @track productCategory1 = null;
    @track productCategory2 = null;
    @track productCategory3 = null;

    ProductCategory2 = [];
    ProductCategory3 = [];

    @track loaded = false;
    @track isSearched = false;
    @track page = 1;
    @track startingRecord = 0;
    @track endingRecord = 0;
    @track pageSize = 15;
    @track totalPage = 0;
    @track productId = null;
    @track accountId = null;
    @track isCommunity = false;
    @track invoicesData;
    @track errorMsg = ''
    @track isShowed = false;
    @track detailData;
    @track detailColumn;
    @track invoiceNo;   
    @track deliveryNumber;
    @track iptalIadeData;
    
    fields = ["Description", "ProductCode"];  
    displayFields = "Description,ProductCode";
    fieldsAccount = ["Name", "RC_SAP_ID__c"];
  displayFieldsAccount = "Name,RC_SAP_ID__c";
    constructor() {
        super();
        this.columns = [{
                label: 'Fatura No',
                fieldName: 'invNo'
            },
            {
                label: 'Fatura Tarihi',
                fieldName: 'invDate',
                type: "date-local",
                typeAttributes: {
                    month: "2-digit",
                    day: "2-digit"
                }
            },
            {
                label: 'Ürün Adı',
                fieldName: 'productNames',
                wrapText: true,
                initialWidth: 400,
             },
            {
                label: 'Adet',
                fieldName: 'invQuantity',
                type:"Integer"
            },
            {
                label: 'Tutar (KDV Hariç)',
                fieldName: 'totalWithoutTaxx',
                type: 'currency',
                typeAttributes: {
                    currencyCode: 'TRY',
                    step: '0.01'
                }
            }, 
            
            {
               type: 'action',
               typeAttributes: {
                   rowActions: this.getRowActions
               }
            },
        ]
        this.detailColumn = [
            {
                label: 'Ürün Kodu',
                fieldName: 'productCodes'
            },
            {
                label: 'Ürün Adı',
                fieldName: 'productNames'
            },
            {
                label: 'Miktar',
                fieldName: 'RC_Billing_Item_Quantity__c'
            },
            {
                label: 'Net Tutar',
                fieldName: 'RC_Net_Price__c',
                type: 'currency',
                typeAttributes: {
                    currencyCode: 'TRY',
                    step: '0.01'
                }
            },
            {
                label: 'Vergi Total',
                fieldName: 'RC_Tax_Total__c',
                type: 'currency',
                typeAttributes: {
                    currencyCode: 'TRY',
                    step: '0.01'
                }
            },
            {
                label: 'Total',
                fieldName: 'RC_Total__c',
                type: 'currency',
                typeAttributes: {
                    currencyCode: 'TRY',
                    step: '0.01'
                }
            }
        ]
        this.iptalIadeColumns = [
           
            {
                label: 'Sipariş Gerekçesi',
                fieldName: 'SIP_GRKC'
            },
            {
                label: 'Paket Bilgisi',
                fieldName: 'PAKET_TANIM'
            },
            {
                label: 'İade Edilmiş Adet',
                fieldName: 'FAT_IADE_MIK',
                type: 'number',
            },
            {
                label: 'İade Edilebilir Adet',
                fieldName: 'FAT_AL_MIK',
                type: 'number',

            },
            {
                label: 'İade Edilecek Adet',
                fieldName: 'IAD_AL_MIK',
                editable: true,
                type: 'number',
            },
            {
                label: 'Malzeme Kodu',
                fieldName: 'MATNR'
            },
            {
                label: 'Malzeme Adı',
                fieldName: 'MAKTX'
              
            }
        ];
        this.init();
        
    }

    init()
    {
        initialize().then(result => {
            console.log('result : ' + JSON.stringify(result));

            if(result.isCommunity)  
            {          
                this.isCommunity = true;
                console.log('serkan23432'+ this.isCommunity);
                this.accountId = result.selectedAccountId;               
        }
        })
        .catch(error => {
            this.isCommunity = false;          
        })
    }
     
    handleLookup(event) {   
       this.productId = event.detail.data.recordId;    
     }

     handleLookupAccount(event) {   
        this.accountId = event.detail.data.recordId;    
      }

    get ProductCategory1(){
        return this.objectCategory1s.data;
    }

    handleSearchCategory1(event) {
        
        this.productCategory1 = event.detail.value;       
        this.ProductCategory3 = [];

        getCategory2({            
            category1: this.productCategory1
        })        
        .then(result => {
            this.ProductCategory2 = [];
            for(const list of result){   
            window.console.log(list.label);

                const option = {
                    label: list.label,
                    value: list.value
                };
                this.ProductCategory2 = [...this.ProductCategory2, option];             
            }
        })
        .catch(error => {
            window.console.log('data alınamadı. ');
        });
    }    

    handleSearchCategory2(event) {
        
        this.productCategory2 = event.detail.value;       

        getCategory3({            
            category2: this.productCategory2
        })        
        .then(result => {
            this.ProductCategory3 = [];
            for(const list of result){   
            
                const option = {
                    label: list.label,
                    value: list.value
                };
                this.ProductCategory3 = [...this.ProductCategory3, option];             
            }
        })
        .catch(error => {
            window.console.log('data alınamadı. ');
        });
    }
    
    handleSearchCategory3(event)
    {
        this.productCategory3 = event.detail.value;
    }

    handleSearchStartDate(event) {
        this.searchedStartDateValue = event.detail.value;
    }
     handleSearchEndDate(event) {
        this.searchedEndDateValue = event.detail.value;
    }

    handleSearchElements(event) {
        const srcName = event.srcElement.name;
        window.console.log('srcName : ' +  srcName);
        switch (srcName) {
            case 'startDate':
                this.searchedStartDateValue = event.detail.value;
                break;
            case 'endDate':
                this.searchedEndDateValue = event.detail.value;
                break;
            case 'invoiceNo':
                this.searchedInvoiceValue = event.detail.value;
                break;
             case 'productCode':
                this.searchedProductCode = event.detail.value;
                break;
                case 'category1':
                this.productCategory1 = event.detail.value;
                break;
                case 'category2':
                this.productCategory2 = event.detail.value;
                break;
                case 'category3':
                this.productCategory3 = event.detail.value;
                break;

            default:
        }
    }

    handleSearch() {
        this.loaded = true;    
        if(this.accountId ==null || this.accountId.length ==0)
        {
            const event = new ShowToastEvent({
                title: 'Hata',
                message: 'Bayi seçiniz',
                mode:'sticky',
                variant:'Warning'

            });
            this.dispatchEvent(event); 
            this.loaded = false;
        }

        getInvoicesNew({
                startDate: this.searchedStartDateValue,
                endDate: this.searchedEndDateValue,
                invoiceNo: this.searchedInvoiceValue,
                accountId: this.accountId,
                productCode : this.productId,
                category1 : this.productCategory1,
                category2 : this.productCategory2,
                category3 : this.productCategory3
            })
            .then(result => {
                if (result != null) {
                    result.forEach((q) => {
                        q.isCommunity = this.isCommunity;
                    });
                    this.sourceData = result;
                    this.errorMsg = '';

                    this.isSearched = true;
                    this.totalPage = Math.ceil(result.length / this.pageSize);

                    this.invoicesData = result.slice(0, this.pageSize);
                } else {
                    this.showWarningToast('Filtreleme üzerinden geçerli bir kayıt bulunamamıştır.', 'Faturalar Hakkında');
                    this.invoicesData = null;
                }
                this.loaded = false;
            })
            .catch(error => {
                this.loaded = false;
                this.invoicesData = null;
                if (error) {
                    this.errorMsg = JSON.stringify(error.body.message);
                }
            })
    }

    handleCellChange(event) {
        let draftValues = event.detail.draftValues;

        draftValues.forEach((modifiedData) => {
            var relatedData = this.sourceData.filter(data => {
                return data.id === modifiedData.id
            });

            let tempDataList = JSON.parse(JSON.stringify(relatedData));

            tempDataList.map(e => {
                if(e.payableAmount <= parseFloat(modifiedData.payableAmount)){
                    const event = new ShowToastEvent({
                        title: 'Ödenebilir Tutar Hakkında',
                        message: 'Girilen tutar ödenebilir tutardan büyük olamaz.',
                    });

                    this.dispatchEvent(event);

                    this.draftValues = [];
                }
                else{
                    e.payableAmount = parseFloat(modifiedData.payableAmount);
                }
            });

            this.sourceData = this.sourceData.filter(data => {
                data.id !== modifiedData.id
            });
            this.sourceData.push.apply(this.sourceData, tempDataList);
        });

        draftValues = [];

        this.invoicesData = this.sourceData;
    }

    

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        switch (actionName) {           
            case 'detay':
                this.openDetail(row);
                break;
             case 'iptalIade':
                this.redirectIptalIade(row);
                break;
            case 'orderPDF':
                this.ShowPDF(row);
                break;
            default:
        }
    }

    getRowActions(row, doneCallback) {
        const actionList = [];
        

        try {
            actions.forEach(action => {
                actionList.push(action);
            });            
            
            console.log(row['isCommunity']);
    
            if (!row['isCommunity']) {
                
                actionList.push({
                    label: 'İptal İade',
                    name: 'iptalIade',
                    iconName: 'utility:info',
                });               
            }   
            doneCallback(actionList);
        } catch (error) {
            console.log("Err : " + error);
        }
    }

    runPayProcess(row) {
        // const formElement = this.template.querySelector('form');
        const formElement = this.template.querySelector('[data-id="assecoForm"]');
        prepareMapForPayActionNew({
                site : window.location.pathname, 
                returnUrl : window.location.href, 
                invoiceNo : row.invNo, 
                amount : row.payableAmount 
            })
            .then(result => {
                console.log('prepareMapForPayActionNew : ', JSON.stringify(result));                
                debugger;
                for (var key in result) {
                    let inputElement = document.createElement('input');
                    inputElement.name = key;
                    inputElement.value = result[key];

                    formElement.appendChild(inputElement);
                }

                const submitBtnElement = this.template.querySelector('[data-id="assecoSubmit"]');
                submitBtnElement.click();
            })
            .catch(error => {
                this.showErrorToast('Ödeme işlemi esnasında bir hata meydana geldi.','Error');
                window.console.log('Ödeme işlemi esnasında bir hata meydana geldi. Hata : ' + JSON.stringify(error.body.message[0].message));
            });
    }

//Navigate to visualforce page
ShowPDF(row) {       
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://poqa.zorlu.com/RESTAdapter/vestelpazarlama/eCommerce/getInvoiceHTML?InvoiceNumber=' + row.uuid
            }   
        },false
        );
    }


    openDetail(row){
        getBillingDetail({
            billingId: row['id'],
        })
        .then(result => {
            result.forEach((q) => {
                q.productCodes = q.RC_Billing_Item_Product__r.ProductCode;
                q.productNames = q.RC_Billing_Item_Product__r.Name;
            })
            this.detailData = result;
            this.invoiceNo = row['invNo'];
            this.template.querySelector("c-rc_detail-modal").handleStatuChange();
        })
        .catch(error => {
            window.console.log('Detay bilgisi sorgulanırken hata alındı. Hata : ' + JSON.stringify(error.body.message[0].message));
        });
    }

    
    redirectIptalIade(row){        
        getBillingIptIade({            
            deliveryNo: row['deliveryNo']
        })        
        .then(result => {
            this.iptalIadeData = result;
            this.invoiceNo = row['invNo'];
            this.deliveryNumber= row['deliveryNo'];
            this.template.querySelector("c-rc_iptaliadeislemleri").handleStatuChange(this.accountId);
        })
        .catch(error => {
            window.console.log('Detay HATA - redirectIptalIade: '+JSON.stringify(error));
        });
    }

    previous() {
        if (this.page > 1) {
          this.page = this.page - 1;
          this.displayRecordsPerPage(this.page);
        }
    }

    next() {
        if (this.page < this.totalPage && this.page !== this.totalPage) {
          this.page = this.page + 1;
          this.displayRecordsPerPage(this.page);
        }
    }

    displayRecordsPerPage(page) {
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.sourceData.length) 
                            ? this.sourceData.length : this.endingRecord; 

        this.invoicesData = this.sourceData.slice(this.startingRecord, this.endingRecord);

        this.startingRecord = this.startingRecord + 1;    
    }

    showErrorToast(message, title) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showSuccessToast(message, title) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showWarningToast(message, title) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'warning',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showInfoToast(message, title) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'info',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

     // Download Data as CSV
     downloadTable(){
        debugger;
        this.prepareData();
    };

    prepareData(){
        debugger;

        this.loaded = true;
        if(this.sourceData != null && this.sourceData.length > 0){
            this.fileDownload();
        }
    };

    //RenderedCallback fonksiyonun amacı import edilen static resource js i load etmek için gereklidir.
    renderedCallback() {
         debugger;
        loadScript(this, RC_FileSaver)
        .then(() => console.log('Loaded sayHello'))
        .catch(error => console.log(error));   
        loadStyle(this, MyOrdersCSS)
        .then()
        .catch(error => console.log(error));
    };

    fileDownload() {        
        // call the helper function which "return" the CSV data as a String   
        var csv = this.convertArrayOfObjectsToCSV(this.sourceData);
        if (csv == null) { return; }
        
        var blob = new Blob(["\ufeff",csv], { type: "" });
        var fileName = 'Faturalarım.csv';
    
        window.saveAs(blob, fileName);
        this.loaded = false;
    }

    convertArrayOfObjectsToCSV(objectRecords) {        
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
        for (var i = 0; i < this.columns.length; i++) {
            var column = this.columns[i];
            
            if(column.label == "" || column.label == undefined) continue;

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

                if(skey == 'payedAmount' || skey == 'payableAmount'){
                    console.log(parseFloat(data).toFixed(2));
                    data = parseFloat(data).toFixed(2);
                }
                                            
                csvStringResult += '"' + data + '"';

                counter++;
            } 
            csvStringResult += lineDivider;
        }

        return csvStringResult;
    };
}