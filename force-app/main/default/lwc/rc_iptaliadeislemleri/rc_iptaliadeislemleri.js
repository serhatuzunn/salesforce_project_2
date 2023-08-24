import { LightningElement, api, track, wire } from 'lwc';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent'
import getCancelRefundReason from '@salesforce/apex/RC_MyInvoicesController.getCancelRefundReason'
import getInfoByCancelRefundCode from '@salesforce/apex/RC_MyInvoicesController.getInfoByCancelRefundCode'
import getDelivering from '@salesforce/apex/RC_MyInvoicesController.getDelivering'
import sendSap from '@salesforce/apex/RC_MyInvoicesController.sendSap'


export default class Rc_IptalIadeIslemleri extends LightningElement {

    @api recordId;
    @api deliveryNumber;


   

    @api isShowed = false;
    @api detailData;
    @api selectedData;
    @api cancelRefundReasonOptions;
    @track selectedObj;
    @track selectedObjDeliverings;
    @api accountId;
    @track objectDeliverings;
    @track invoicingCustomerNo ="";
    objects = [];
    @api columns;
    @api invoiceNo;
    @api deliveryNo;
    @track status = "";
    @track isInvoiceStatus = "";
    @track deliveringSelected = "";
    @track depoYeriKodu = "";
    @track uretimYeriKodu = "";
    @track toplamaYeriKodu = "";
    @track tmLocalCode = "";
    @track teslimEden = "";

    @track cancelRefundCode = "";
    @api handleStatuChange(accountId){
        this.isShowed = true;
        this.accountId = accountId;
        console.log(this.accountId);
        getDelivering({accountId:this.accountId}).
        then(data => {
            console.log(JSON.stringify(data));
            this.objectDeliverings = data
            console.log(this.objectDeliverings);
        }).
    catch();
    }
    

    @api handleProductStatuChange(event){
        this.status = event.detail.value;
 
        if(this.status !='' && this.isInvoiceStatus!='')
        {
            getCancelRefundReason({            
                isInvoiceStatus: this.isInvoiceStatus,
                status : this.status
            })        
            .then(result => {
                this.objects = [];
                for(const list of result){                                      
                    const option = {
                        label: list.NAME,
                        value: list.CODE
                    };
                    this.objects = [...this.objects, option];             
                }
                this.selectedObj = this.objects[0].value;
                
            })
            .catch(error => {
                window.console.log('data alınamadı. ');
            });
        }      
    }

    @api handleCancelRefundChange(event){
        this.cancelRefundCode = event.detail.value; 
        if(this.status !='' && this.isInvoiceStatus!='' && this.cancelRefundCode !='')        
        {
            this.depoYeriKodu='';
            this.uretimYeriKodu='';
            this.toplamaYeriKodu='';
            this.tmLocalCode ='';
    
            getInfoByCancelRefundCode({            
                isInvoiceStatus: this.isInvoiceStatus,
                status : this.status,
                cancelRefundCode : this.cancelRefundCode,
                deliveryNo : this.deliveryNumber
            })        
            .then(result => {               
                        this.depoYeriKodu= result.STOREPLACE;
                        this.uretimYeriKodu = result.PRODUCTIONPLACE;
                        this.toplamaYeriKodu = result.TOPLAMAYERI; 
                        this.tmLocalCode = result.TMLOCALCODE;
            })
            .catch(error => {
                window.console.log('data alınamadı. ');
            });
        }    
    }
    
    @api handleInvoiceStatuChange(event){
        this.isInvoiceStatus= event.detail.value;       
        if(this.status !='' && this.isInvoiceStatus!='')
        {   
            getCancelRefundReason({            
                isInvoiceStatus: this.isInvoiceStatus,
                status : this.status
            })        
            .then(result => {
                this.objects = [];
                for(const list of result){   
                    const option = {
                        label: list.NAME,
                        value: list.CODE
                    };
                    this.objects = [...this.objects, option];             
                }
                this.selectedObj = this.objects[0].value;
                
            })
            .catch(error => {
                window.console.log('data alınamadı. ');
            });
        }      
    }
    @api handleDelivering(event){
        this.teslimEden= event.detail.value;
        
    }

    @api handleCustomerName(event){
        this.invoicingCustomerNo= event.detail.value;
        
    }
    closeModal() {
        this.isShowed = false;
    }

    sendSap() {
        
         this.selectedData = this.template.querySelector("lightning-datatable").getSelectedRows();
         var message= '';
         if(this.selectedData ==null || this.selectedData.length ==0)
         {
             message='İade edilecek kalemi seçiniz.';
         }

         if(this.cancelRefundCode =='')
         {
            message='İade nedeni seçiniz.';
         }
         if(this.teslimEden =='')
         {
            message='Malı teslim eden bilgisi seçiniz.';
         }
           
         if(message !='')
         {
            const event = new ShowToastEvent({
                title: 'İade Hata',
                message: message,
                mode:'sticky',
                variant:'Warning'

            });
            this.dispatchEvent(event);  
         }
         else
         {
             sendSap({            
            lst: this.selectedData,
            depoYeri : this.depoYeriKodu,
            uretimYeri : this.uretimYeriKodu,
            toplamaYeri : this.toplamaYeriKodu,
            tmEventCode : this.tmLocalCode,
            refundReason : this.cancelRefundCode,
            invoiceCustomer : this.invoicingCustomerNo,
            teslimEden : this.teslimEden,

        }).then(result => {               
            
            console.log(result.EV_SALESDOCUMENT);
            if(result.EV_SUCCESS=="S")
            {
                const event = new ShowToastEvent({
                    title: 'İade Bilgilendirme',
                    message: 'SAP Siparişi oluştu. Sipariş No'+ result.EV_SALESDOCUMENT,
                    mode:'sticky',
                    variant:'Info'

                });
                this.dispatchEvent(event);  
            }
            else{
                const event = new ShowToastEvent({
                    title: 'İade Hata',
                    message: 'SAP Siparişi oluşurken hata oluştu. Hata Mesajı : ' + result.MESSAGE,
                    mode:'sticky',
                    variant:'Error'

                });
                this.dispatchEvent(event);  
            }
            })
           .catch(error => {
            console.log("sendSapError");
           
           });   
         }
         
    }

  
    get statuses() {
        return [
          { label: "Sağlam", value: "1" },
          { label: "Hasarlı", value: "2" }
        ];
      }
      get isInvoiceStatuses() {         
        return [
          { label: "Var", value: "1" },
          { label: "Yok", value: "2" }
        ];

      }    

    get deliveryOptions(){
        return this.objectDeliverings;
    }

    constructor(){        
        super();

    }

    selectedRow(event){
        this.selectedData = this.template.querySelector("lightning-datatable").getSelectedRows();  
    }

    handleCellChangeIptIade(event) {        
        let draftValues = event.detail.draftValues;        
        draftValues.forEach((modifiedData) => {
                    var relatedData = this.detailData.filter(data => {
                    return data.UNIQECODE === modifiedData.UNIQECODE
            });
             let tempDataList = JSON.parse(JSON.stringify(relatedData));
             tempDataList.map(e => {
                 if(e.FAT_AL_MIK < parseFloat(modifiedData.IAD_AL_MIK)){
                    const event = new ShowToastEvent({
                        title: 'İade Alınacak Adet Hakkında',
                        message: 'Girilen adet iade alınabilecek adetten büyük olamaz.',
                    });
                    this.dispatchEvent(event);
                    this.draftValues = [];
                }
                else{
                    e.IAD_AL_MIK = parseFloat(modifiedData.IAD_AL_MIK);
                }
            });

            this.detailData = this.detailData.filter(data => {
                data.UNIQECODE !== modifiedData.UNIQECODE
            });
            this.detailData.push.apply(this.detailData, tempDataList);
        });      
       

    }
}