import { LightningElement, api, track,wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from "lightning/navigation";
import GetRequestParameters from '@salesforce/apex/RC_MyOrdersController.GetRequestParameters';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TotalAmount from '@salesforce/schema/Order.TotalAmount';
import getOrderStatuses from '@salesforce/apex/RC_MyOrdersController.getOrderStatuses'
import getCategory1 from '@salesforce/apex/RC_MyOrdersController.getCategory1'
import getCategory2 from '@salesforce/apex/RC_MyOrdersController.getCategory2'
import getCategory3 from '@salesforce/apex/RC_MyOrdersController.getCategory3'
import GetOrders from '@salesforce/apex/RC_MyOrdersController.GetOrders';
import GetOrderDetails from '@salesforce/apex/RC_MyOrdersController.GetOrderDetails';
import GetOrderDetailsProduct from '@salesforce/apex/RC_MyOrdersController.GetOrderDetailsProduct';
import GetOrderDeliveryBillings from '@salesforce/apex/RC_MyOrdersController.GetOrderDeliveryBillings';
import CargoStatuDetails from '@salesforce/apex/RC_MyOrdersController.CargoStatuDetails';
import getCities from '@salesforce/apex/RC_MyOrdersController.getCities'
import getCounties from '@salesforce/apex/RC_MyOrdersController.getCounties'
import getDistricts from '@salesforce/apex/RC_MyOrdersController.getDistricts'
import getServices from '@salesforce/apex/RC_MyOrdersController.getServices'
import shipToAddress from '@salesforce/apex/RC_MyOrdersController.shipToAddress';

import getInvoicesNew  from '@salesforce/apex/RC_MyInvoicesController.getInvoicesNew';
import getBillingDetail from '@salesforce/apex/RC_MyInvoicesController.getBillingDetail';
import getBillingIptIade from '@salesforce/apex/RC_MyInvoicesController.getBillingIptIade';
// RC_FileSaver içeride oluşturulan Static Resources, loadScript ise yüklenen js static resource unu load etmek amacıyla tanımlandı.
import RC_FileSaver from '@salesforce/resourceUrl/RC_FileSaver';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import getAssecoPaymentLink  from '@salesforce/apex/RC_MyOrdersController.getAssecoPaymentLink';
import getInvoicePDFLink  from '@salesforce/apex/RC_MyInvoicesController.getInvoicePDFLink';
import MyOrdersCSS from '@salesforce/resourceUrl/myordersCSS';

const actions = [{ label: 'Detay', name: 'detail', iconName: 'utility:info' },{
    'label': 'Sipariş Belgesi PDF',
    'iconName': 'doctype:pdf',
    'name': 'orderPDF'
}];
const actionsInvoice = [{
    label: 'Detay',
    name: 'detay',
    iconName: 'utility:info',
    },
    {
    'label': 'Fatura PDF',
    'iconName': 'doctype:pdf',
    'name': 'invoicePDF'
    }];

const columns = [];

const orderdetailColumns = [];
const orderDeliveryColumns = [];

export default class RC_MyOrders extends NavigationMixin(LightningElement) {
    @wire(getOrderStatuses) 
    objectOrderStasuses;

    @wire(getCategory1) 
    objectCategory1s;
    
    @track loaded = false;   

    getRowActions(row, doneCallback) {       
        const actionList = [];

            actions.forEach(action => {
                actionList.push(action);
            });

            if (row['canPayable']) {
            
                actionList.push({
                    'label': 'Ödeme Yap',
                    'iconName': 'utility:money',
                    'name': 'pay'
                });               
            }
        
        doneCallback(actionList);    
    }  
    
    getRowActionsInvoice(row, doneCallback) {       

        const actionListInvoice = [];

        actionsInvoice.forEach(action => {
            actionListInvoice.push(action);
        });        
        if (row['canPayable']) {
            
            actionListInvoice.push({
                'label': 'Ödeme Yap',
                'iconName': 'utility:money',
                'name': 'pay'
            });               
        }
            
        doneCallback(actionListInvoice);    
    }


    @track productId = null;
    @track startDate = null;
    @track endDate = null;
    @track orderNo= null;    
    @track orderReason= null;    
    @track orderStatus = null;
    @track productCategory1 = null;
    @track productCategory2 = null;
    @track productCategory3 = null;
    @track Info =null;  
    @track orderStatuDetail =null;    
    @track DetailTitle ="Sipariş Ürünleri";
    @track DeliveryAndBillingTitle ="Teslimat Ve Fatura";
    @track InfoAddressTransfer =null;
    @track InfoAddressTransferInfo = null;
    @track listType = null;
    @track page = 1; 
    @track items = []; 
    @track orderdetailData; 
    @track cargoDetailData; 
    @track orderDeliveryData; 
    @track data; 
    @track sourceData = []; 
    @track startingRecord = 1;
    @track endingRecord = 0; 
    @track pageSize = 20; 
    @track totalRecountCount = 0;
    @track totalPage = 0;
    @track isModalOpen = false;
    @track isModalOpenCargoStatus = false;
    @track isModalOpenTransferAddress = false;
    @track isProductDetail = false;
    @track isAddressTransfer = false;

    @track PageTitle ="";
    @track OrderNo = '';
    @track productCode = '';
    @track city=null;
    @track county=null;
    @track countyName=null;
    @track district=null;
    @track districtName=null;
    @track serviceCode=null;
    @track address=null;
    @track customerName=null;
    @track customerSurname=null;
    @track phoneArea=null;
    @track phone=null;
    @track deliveryQuantity=null;
    @track orderQuantity=null;
    @track note=null;
    @track deliveryProduct=null;
    @track positionNo=null;

    @track isShowed = false;
    @track detailData;
    @track detailColumn;
    @track invoiceNo;   
    @track deliveryNumber;
    @track iptalIadeData;
    @track assecoPaymentLink;
    @track invoicePDFLink;

     cityList=[];
     countyList=[];
     districtList=[];
     serviceList=[];
     ProductCategory2 = [];
     ProductCategory3 = [];     
     fields = ["Description", "ProductCode"];  
     displayFields = "Description,ProductCode"; 

    connectedCallback() {
        getAssecoPaymentLink().
        then(data => {
            this.assecoPaymentLink = data;
            console.debug('assecoPaymentLink : '+ this.assecoPaymentLink);           
        }).catch();

        getInvoicePDFLink().
        then(data => {
            this.invoicePDFLink = data;
            console.debug('invoicePDFLink : '+ this.invoicePDFLink);           
        }).catch();
      }


     handleLookup(event) {     
         console.log(event);
         console.log(event.detail.data.recordId);
        this.productId = event.detail.data.recordId;    
      }
     handleSearchStartDate(event) {
        this.startDate = event.detail.value;
    }
     handleSearchEndDate(event) {
        this.endDate = event.detail.value;
    }
      handleSearchOrderNo(event) {
        this.orderNo = event.detail.value;
    }
      handleSearchOrderReason(event) {
        this.orderReason = event.detail.value;
    }
      handleSearchOrderStatu(event) {       
        
        this.orderStatus = event.detail.value;
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

    handleSearchListType(event)
    {
        this.listType = event.detail.value;       
    }
    handleSearchCategory3(event)
    {
         this.productCategory3 = event.detail.value;
    }
    
    get OrderStausesOptions(){
        return this.objectOrderStasuses.data;
    }

    get ListType() {
        return [
          { label: "Ürüne Göre Listele", value: "1" },
          { label: "Siparişe Göre Listele", value: "2" },
          { label: "Faturaya Göre Listele", value: "3" }
        ];
      }

    get ProductCategory1(){
        return this.objectCategory1s.data;
    }
     handlePrepareColumns()
     {
        if(this.listType ==2){
            this.columns =  [    
            { label: 'Sipariş No', fieldName: 'orderNo'},
            { label: 'Sipariş Durumu', fieldName: 'statu'},           
            { label: 'Sipariş Tarihi', fieldName: 'orderDate', type: 'date-local', typeAttributes: { month: '2-digit', day: '2-digit' }},           
            { label: 'Sipariş Tutarı', fieldName: 'totalAmount', type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' }},    
            { label: 'Ödenen Tutar', fieldName: 'payedAmount', type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' }},
            { label: 'Ödenecek Tutar', fieldName: 'payableAmount', editable: true, type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' }},
            {type: 'button-icon', label:'Adrese Teslim', typeAttributes: {iconName: 'custom:custom98',name: 'AddressTransfer',iconClass: 'slds-icon_large',title:'Adrese Teslim Sipariş Girişi'}},

            {  label: 'İşlem',  type: 'action', typeAttributes: { rowActions: this.getRowActions }, initialWidth: 150} ];
             
                              
            }
            else if(this.listType==3){
                this.columns =  [
                {
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
                { label: 'Ödenen Tutar', fieldName: 'payedAmount', type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' }},
                { label: 'Ödenecek Tutar', fieldName: 'payableAmount', editable: true, type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' }},
                {  label: 'İşlem',  type: 'action', typeAttributes: { rowActions: this.getRowActionsInvoice }, initialWidth: 150}
            ]
            }
            else
            {
                this.columns =  [    
                    { label: 'Alt Ürün Grubu', fieldName: 'category'},
                    { label: 'Ürün Kodu', fieldName: 'productCode'},
                    { label: 'Ürün Adı', fieldName: 'productName'},
                    { label: 'Adet', fieldName: 'quantity', type: 'decimal' },
                    { label: 'Toplam Tutar', fieldName: 'totalPrice', type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' }},                      
                    { label: 'İşlem', type: 'button', typeAttributes:{ title: 'Detay', name: 'detail', iconName: 'utility:info', variant : 'base' }, initialWidth: 150} ];
                    this.orderdetailColumns = [
                        { label: 'Sipariş No', fieldName: 'orderNo' },    
                        { label: 'Sipariş Tarihi', fieldName: 'orderDate', type: 'date-local', typeAttributes: { month: '2-digit', day: '2-digit' }},  
                        { label: 'Birim Fiyatı', fieldName: 'unitPrice', type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' } },
                        { label: 'Toplam Fiyatı', fieldName: 'totalAmount', type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' } },
                        { label: 'Adet', fieldName: 'quantity' }                        
                    ];                       
            }
             this.orderDeliveryColumns = [                
                 { type:'button', label : 'Teslimat No', typeAttributes:{ label : {fieldName:'deliveryNo'}, variant : 'base'} },
                 { label: 'Ürün Bilgisi', fieldName:'productInfo', title:'productInfo'},
                 { label: 'Fatura No', fieldName:'invoiceNo'},
                 { label: 'Teslimat Durumu', fieldName: 'deliveryStatus' },
                 { label: 'Teslim Tarihi', fieldName: 'deliveryDate' }
             ];                                         
        }
     
    handleSearch(){
        this.loaded = true;
        var message= '';
         debugger;  
        if(this.listType ==null || this.listType.length ==0)
         {
             message='Liste Gösterim Şeklini Seçiniz.';
         }
        
         if(message !='')
         {
            const event = new ShowToastEvent({
                title: 'Hata',
                message: message,
                mode:'sticky',
                variant:'Warning'

            });
            this.dispatchEvent(event); 
            this.loaded = false;

         }
         else
         {
            if(this.listType =="3"){

                getInvoicesNew({
                    startDate: this.startDate,
                    endDate: this.endDate,
                    invoiceNo: this.orderNo,
                    accountId: null,
                    productCode : this.productId,
                    category1 : this.productCategory1,
                    category2 : this.productCategory2,
                    category3 : this.productCategory3
                })
                .then(result => {
                    if (result != null) {
                        console.debug('result: '+ JSON.stringify(result));
                        this.handlePrepareColumns();
                        this.items = result;
                        this.totalRecountCount = result.length; 
                        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
                        this.data = this.items.slice(0,this.pageSize);
                        this.endingRecord = this.pageSize;
                        this.sourceData = this.data;
    
                        this.isSearched = true;
                    } else {
                        this.data = null;             
                        this.showWarningToast('No records found in the criteria you searched for.','Not Found');
                    }
                    this.loaded = false;
                })
                .catch(error => {
                    this.loaded = false;
                    this.data = null;
                    if (error) {
                        this.errorMsg = JSON.stringify(error.body.message);
                        console.log('getInvoicesNew -> ERROR : ', error); 
                    }
                })
            }
            else{
                GetOrders({ startDate: this.startDate, endDate: this.endDate, orderNo: this.orderNo, orderReason : this.orderReason, orderStatus : this.orderStatus, category1 : this.productCategory1,
                category2 : this.productCategory2,category3 : this.productCategory3,listType:this.listType,productId:this.productId })
                .then(GetOrdersResult => {  
                    if(GetOrdersResult != null)
                    {
                        this.handlePrepareColumns();
                        this.items = GetOrdersResult;                
                        this.totalRecountCount = GetOrdersResult.length; 
                        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
                        this.data = this.items.slice(0,this.pageSize);
                        this.endingRecord = this.pageSize;
                        this.sourceData = this.data;                
                    }
                    else{   
                        this.data = null;             
                        this.showWarningToast('No records found in the criteria you searched for.','Not Found');
                    }
                    this.loaded = false;
                }).catch(GetOrdersResultError => {
                console.log('GetOrdersResult -> ERROR : ', GetOrdersResultError);        
                });
            }
         }

    };
    handleRowActionDetail(event)
    {
         const actionName = event.detail.action.name;
         const row = event.detail.row;
         this.AddressTransfer(row);  
    }

    handleRowActionCargoStatus(event)
    {
         const row = event.detail.row;
         this.CargoStatus(row);  
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
             case 'pay':
                
                    this.Pay(row);                
                 break;
             case 'detail':
                 if(this.listType =="2")
                 {
                     this.Detail(row);
                 }
                 else if(this.listType=="3"){
                     this.openDetail(row);
                 }
                 else
                 {
                     this.DetailProduct(row);
                 }
                 break;
             case 'orderPDF':
                     this.ShowPDF(row);
                     break;
             case 'AddressTransfer':
                      this.DetailForAddressTransfer(row);
                     break;
             case 'detay':
                this.openDetail(row);
                break;
             case 'invoicePDF':
                    this.ShowInvPDF(row);
                    break;
           
             default:
        }
    };

    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }

    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);            
        }             
    }

    displayRecordPerPage(page){

        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 
        this.data = this.items.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }

    sortColumns(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        return refreshApex(this.result);        
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

    Pay(row) {
        const { id } = row;
        const index = this.findRowIndexById(id);
        if(row.payableAmount <=0)
        {
            this.showErrorToast('Ödenecek tutar 0 dan büyük olmalıdır.','Error');
            return;
        }
        if (index !== -1) {    
                var  documentNo = row.orderNo;
               if(this.listType == 3)     
               {
                documentNo = row.invNo;
               }
            GetRequestParameters({site : window.location.pathname, 
                returnUrl : window.location.href, orderNo : documentNo, amount : row.payableAmount,listType:this.listType })
            .then(GetRequestParametersResult => {
                console.log('GetRequestParametersResult : ', JSON.stringify(GetRequestParametersResult));
                console.log('assecoPaymentLink : ', JSON.stringify(this.assecoPaymentLink));
                const formElement = this.template.querySelector('[data-id="assecoForm"]');
                for (var key in GetRequestParametersResult) 
                {
                    let inputElement = document.createElement('input');
                    inputElement.name = key;
                    inputElement.value = GetRequestParametersResult[key];
                    formElement.appendChild(inputElement);
                }
                this.template.querySelector('[data-id="assecoForm"]').action = this.assecoPaymentLink;
                this.template.querySelector('[data-id="assecoSubmit"]').click();     
            })
            .catch(GetRequestParametersError => {
                this.showErrorToast('Error occurred during payment.','Error');
                console.log('GetRequestParameters -> ERROR : ', GetRequestParametersError);  
            });                        
        }
    };   
    
    //Navigate to visualforce page
    ShowPDF(row) {       
    this[NavigationMixin.GenerateUrl]({
	    type: 'standard__webPage',
	    attributes: {
		    url: 'https://vtsbxqa-vestelqa.cs127.force.com/vestelb2b/apex/R C_VestelOrderDocPdfView?id=' + row.id
	    }
    }).then(vfURL => {
	window.open(vfURL);
    });
     }

     //Navigate to visualforce page
ShowInvPDF(row) {       
    this[NavigationMixin.GenerateUrl]({
        type: 'standard__webPage',
        attributes: {
            url: this.invoicePDFLink + row.uuid
        }
    }).then(vfURL => {
    window.open(vfURL);
    });
}

     Detail(row) {         
        this.OrderNo = row.orderNo;
        this.Info = row.orderNo;   
        this.orderStatuDetail = row.statu;                 
        this.isProductDetail =false;
        this.PageTitle ="Siparis Detay";
        this.orderdetailColumns = [
            { label: 'Kalem No', fieldName: 'orderProductNo' },    
            { label: 'Ürün Kodu', fieldName: 'productCode' },    
            { label: 'Ürün Adı', fieldName: 'productName' },
            { label: 'Sipariş Durumu', fieldName: 'itemStatuDefinition' },
            { label: 'Adet', fieldName: 'quantity' },
            { label: 'Birim Fiyat', fieldName: 'unitPrice', type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' } },
            { label: 'Toplam Fiyat', fieldName: 'totalPrice', type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' } }                               
        ];
        GetOrderDetails({ orderId: row.id,addresTransfer:false })
        .then(GetOrderDetailsResult => {  
            if(GetOrderDetailsResult != null)
            {                
                this.DetailTitle = "Siparis Ürünleri (" + GetOrderDetailsResult.length + ")";
                this.orderdetailData = GetOrderDetailsResult;  
                
                return GetOrderDeliveryBillings({ orderId: row.id });
            }
            else{   
                this.orderdetailData = null;             
                this.showWarningToast('No records found.','Not Found');
            }
        })
        .then(GetOrderDeliveryBillingsResult => {         
            if(GetOrderDeliveryBillingsResult != null)
            {
                this.DeliveryAndBillingTitle = "Teslimat ve Fatura ("+ GetOrderDeliveryBillingsResult.length+ ")";
                this.orderDeliveryData = GetOrderDeliveryBillingsResult;                 
            }
            else{   
                this.orderDeliveryData = null;                            
            }
            this.openModal();  
       })
        .catch(GetOrdersResultError => {
            console.log('GetOrderDetails -> ERROR : ', GetOrdersResultError);        
        });
    }
    DetailForAddressTransfer(row) {
        this.OrderNo = row.orderNo;
        this.Info = row.orderNo + ' Adrese Sevk' ;                  
        this.isProductDetail =true;
        this.PageTitle ="Adrese Transfer";  
        this.orderdetailColumns = [
            { label: 'Kalem No', fieldName: 'orderProductNo' },    
            { label: 'Ürün Kodu', fieldName: 'productCode' },    
            { label: 'Ürün Adı', fieldName: 'productName' },
            { label: 'Sipariş Durumu', fieldName: 'itemStatuDefinition' },
            { label: 'Bekleyen Adet', fieldName: 'quantity' },
            { label: 'Birim Fiyat', fieldName: 'unitPrice', type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' } },
            { label: 'Toplam Fiyat', fieldName: 'totalPrice', type: 'currency', typeAttributes: { currencyCode: 'TRY', step: '0.01' } },
            { type: 'button-icon', label:'Adrese Teslim', typeAttributes: {iconName: 'custom:custom98',name: 'AddressTransfer',iconClass: 'slds-icon_large',title:'Adrese Teslim Sipariş Girişi'}}
        ];                  
        GetOrderDetails({ orderId: row.id ,addresTransfer:true})
        .then(GetOrderDetailsResult => {  
            if(GetOrderDetailsResult != null)
            {   
                this.orderdetailData = GetOrderDetailsResult;
                this.openModal();

            }
            else{   
                this.orderdetailData = null;             
                this.showWarningToast('No records found.','Not Found');
            }
        })        
        .catch(GetOrderDetailsProductResultError => {
            console.log('GetOrderDetails -> ERROR : ', GetOrderDetailsProductResultError);        
        });
    }
    DetailProduct(row) {
        this.productCode = row.productCode;
        this.Info = row.productCode + ' - ' + row.productName;      
        this.DetailTitle='Siparisler';
        this.PageTitle ='Ürün Detay';
        this.isProductDetail = true;

        GetOrderDetailsProduct({ productCode: row.productCode })
        .then(GetOrderDetailsProductResult => {  
            if(GetOrderDetailsProductResult != null)
            {
                console.log('GetOrderDetailsProductResult', GetOrderDetailsProductResult);
                this.orderdetailData = GetOrderDetailsProductResult;     
                this.openModal();

            }
            else{   
                this.orderdetailData = null;             
                this.showWarningToast('No records found.','Not Found');
            }
        })
        
        .catch(GetOrderDetailsProductResultError => {
            console.log('GetOrderDetailsProduct -> ERROR : ', GetOrderDetailsProductResultError);        
        });
    }

    openDetail(row){
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

    CargoStatus(row) {
        this.openModalCargoStatus(); 
        this.closeModal();                
        CargoStatuDetails({ deliveryNo: row.deliveryNo })

        .then(CargoStatuDetailsResult => {  
            if(CargoStatuDetailsResult != null)
            {              
                console.log("cargoStau:" +CargoStatuDetailsResult )
                this.cargoDetailData = CargoStatuDetailsResult;                              
            }
            else{   
                this.cargoDetailData = null;             
                this.showWarningToast('No records found.','Not Found');
            }
        })
        .catch(CargoStatuDetailsResultError => {
            console.log('CargoStatuDetails -> ERROR : ', CargoStatuDetailsResultError);        
        });

    }

    AddressTransfer(row) {
        this.openModalAddressTransfer(); 
        this.closeModal();
        this.InfoAddressTransfer ="Sipariş No : "+ this.OrderNo+ " / Ürün Kodu: "+ row.productCode + " - Ürün Adı: " + row.productName  ;
        this.InfoAddressTransferInfo="Adrese teslim siparişler için adres ve adet bilgisi giriniz.";
        this.deliveryProduct= row.productCode;    
        this.positionNo= row.orderProductNo;    
        this.orderQuantity = row.quantity;
        getCities().then(CitiesResult => {
             this.cityList = [];
             for(const list of CitiesResult){                 
                const option = {
                    label: list.label,
                    value: list.value
                };
                this.cityList = [...this.cityList, option];             
            }
        })  
        .catch(CargoStatuDetailsResultError => {
            console.log('CargoStatuDetails -> ERROR : ', CargoStatuDetailsResultError);        
        });
    }

    handleCity(event) {
        
        this.city = event.detail.value;       
        this.districtList = [];
        this.serviceList = [];

        getCounties({            
            cityCode: this.city
        })        
        .then(Countiesresult => {
            this.countyList = [];
            for(const list of Countiesresult){   
                const option = {
                    label: list.label,
                    value: list.value
                };
                this.countyList = [...this.countyList, option];             
            }
        })
        .catch(error => {
            window.console.log('data alınamadı. ');
        });
    }
    handleCounty(event) {        
        this.county = event.detail.value;     
        this.countyName = event.target.options.find(opt => opt.value === event.detail.value).label;               

        this.serviceList = [];
        getDistricts({            
            countyCode: this.county
        })        
        .then(Countiesresult => {
            this.districtList = [];
            for(const list of Countiesresult){   
                const option = {
                    label: list.label,
                    value: list.value
                };
                this.districtList = [...this.districtList, option];             
            }
        })
        .catch(error => {
            window.console.log('data alınamadı. ');
        });
    }
    handleDistrict(event) {
        
        this.district = event.detail.value;      
        this.districtName = event.target.options.find(opt => opt.value === event.detail.value).label;               

        getServices({   
            cityCode:this.city,         
            countyCode: this.county,
            districtCode:this.district,
            productCode:this.deliveryProduct
        })        
        .then(Servicesresult => {
            this.serviceList = [];
            for(const list of Servicesresult){   
                const option = {
                    label: list.label,
                    value: list.value
                };
                this.serviceList = [...this.serviceList, option];             
            }
        })
        .catch(error => {
            window.console.log('data alınamadı. ');
        });
    }
    handleCustomerName(event) {
        this.customerName = event.detail.value;
    }
    handleCustomerSurname(event) {
        this.customerSurname = event.detail.value;
    }
    handlePhoneAreaCode(event) {
        this.phoneArea = event.detail.value;        
    }
    handlePhone(event) {
        this.phone = event.detail.value;        
    }
    handleDeliveryQuantity(event) {
        this.deliveryQuantity = event.detail.value;
    }
    handleNote(event) {
        this.note = event.detail.value;
    }   
    handleAddress(event) {
        this.address = event.detail.value;
    }   
    handleService(event) {
        this.serviceCode = event.detail.value;
    } 
    handleShipTo(){
        this.loaded = true;
        var message= '';
        if(this.city ==null || this.city.length ==0)
        {
           message ='İl Seçiniz.';
        }
       
       if(this.countyName ==null || this.countyName.length ==0)
        {
           message ='İlçe Seçiniz.';
        }
        if(this.districtName ==null || this.districtName.length ==0)
        {
           message ='Semt Seçiniz.';
        }
        if(this.serviceCode ==null || this.serviceCode.length ==0)
        {
           message ='Servis Seçiniz.';
        }
        if(this.address ==null || this.address.length ==0)
        {
           message ='Adres Giriniz.';
        }
        if(this.deliveryQuantity ==null || this.deliveryQuantity.length ==0 || this.deliveryQuantity =='0')
        {
           message ='Adet Giriniz.';
        }
        if(this.deliveryQuantity > this.orderQuantity)
        {
           message ='Adet Sipariş Adetinden Fazla Olamaz.';
        }
        if(this.customerName ==null || this.customerName.length ==0)
        {
           message ='Müşteri Adı Giriniz.';
        }
        if(this.customerSurname ==null || this.customerSurname.length ==0)
        {
           message ='Müşteri Soyadı Giriniz.';
        }
        if(this.phoneArea ==null || this.phoneArea.length ==0)
        {
           message ='Telefon Alan Kodu Giriniz.';
        }
        if(this.phone ==null || this.phone.length ==0 )
        {
           message ='Telefon Numarası Giriniz.';
        }

        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                message ='Geçerli Bir Telefon Numarası Giriniz.';
            }
        });
        
      
       
        if(message !='')
        {
           const event = new ShowToastEvent({
               title: 'Hata',
               message: message,
               mode:'sticky',
               variant:'Warning'

           });
           this.dispatchEvent(event); 
           this.loaded = false;

        }
        else
        {   
             var qnt = this.deliveryQuantity;
             if(this.orderQuantity == this.deliveryQuantity )          
             {
                 qnt =0;
             }
             

             shipToAddress({ orderNo: this.OrderNo, positionNo: this.positionNo, quantity: qnt, 
                countyName : this.countyName, districtName : this.districtName, name : this.customerName,
                surname : this.customerSurname,deliveryAddress : this.address,areaCode:this.phoneArea,
                 phone:this.phone,cityCode: this.city,serviceCode:this.serviceCode
                 })
             .then(shipToResult => {  
                 if(shipToResult != '')
                 {
                    const event = new ShowToastEvent({
                        title: 'Hata',
                        message: shipToResult,
                        mode:'sticky',
                        variant:'Error'         
                    });
                    this.dispatchEvent(event); 
                    this.loaded = false;   
                 }
                 else{   
                    const event = new ShowToastEvent({
                        title: 'Başarılı',
                        message: 'İşlem Başarıyla Tamamlandı',
                        mode:'sticky',
                        variant:'success'    
                             
                    });
                    this.dispatchEvent(event); 
                    this.loaded = false;   
                     this.closeModalAddressTransfer(); 
                     this.openModal();
                 }
                 this.loaded = false;
             }).catch(GetOrdersResultError => {
             console.log('GetOrdersResult -> ERROR : ', GetOrdersResultError);        
             });
        }

    };
    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    openModalCargoStatus() {
        this.isModalOpenCargoStatus = true;
    }
    closeModalCargoStatus() {
        this.isModalOpenCargoStatus = false;
        this.isModalOpen = true;
    }    
    openModalAddressTransfer() {
        this.isModalOpenTransferAddress = true;
    }
    closeModalAddressTransfer() {
        this.isModalOpenTransferAddress = false;
        this.isModalOpen = true;
    }
   
    findRowIndexById(id) {
        let ret = -1;
        this.data.some((row, index) => {
            if (row.id === id) {
                ret = index;
                return true;
            }
            return false;
        });
        return ret;
    };

    handleCellChange(event) {
        debugger;
        let draftValues = event.detail.draftValues;
        var relatedData = this.sourceData.filter(data => {
            return data.id === draftValues[0].id
        });

        if(draftValues[0].payableAmount <= relatedData[0].payableAmount)
        {
            let tempDataList = JSON.parse(JSON.stringify(relatedData));
            tempDataList.map(e => {
                e.payableAmount = parseFloat(draftValues[0].payableAmount);
            });

            this.sourceData = this.sourceData.filter(data => {
                data.id !== draftValues[0].id
            });
            this.sourceData.push.apply(this.sourceData, tempDataList);
            this.data = this.sourceData;
            draftValues = [];
        }
        else
        {            
            this.showErrorToast('Ödenecek tutar, kalan tutardan büyük olamaz.','Error');
            this.handleSearch();
        }
    }

    // Download Data as CSV
    downloadTable(){
        debugger;
        this.prepareData();
    };

    prepareData(){
        debugger;

        this.loaded = true;

        if(this.items != null && this.items.length > 0){
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
        try{       
            // call the helper function which "return" the CSV data as a String   
            var csv = this.convertArrayOfObjectsToCSV(this.items);
            if (csv == null) { return; }
            
            var blob = new Blob(["\ufeff",csv], { type: "" });
            var fileName = 'Siparişlerim.csv';
            
            window.saveAs(blob, fileName);    
            
            this.loaded = false;
        }
        catch(e){
            console.log(e);
        } 
    };

    convertArrayOfObjectsToCSV(objectRecords) {
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
        for (var i = 0; i < this.columns.length; i++) {
            var column = this.columns[i];

            if(column.label == "") continue;

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

                if(skey == 'totalAmount' || skey == 'payedAmount' || skey == 'payableAmount'){
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