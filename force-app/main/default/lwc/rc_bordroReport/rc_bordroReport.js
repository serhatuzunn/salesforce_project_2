import { LightningElement, track } from 'lwc';
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CSS from "@salesforce/resourceUrl/bordroReportCSS";
import initialize from "@salesforce/apex/RC_BordroReportController.initialize";
import getConnectionPeriodData from "@salesforce/apex/RC_BordroReportController.getConnectionPeriodData";
import bordroApprove from "@salesforce/apex/RC_BordroReportController.bordroApprove";
import bordroCancel from "@salesforce/apex/RC_BordroReportController.bordroCancel";
import getHistory from '@salesforce/apex/RC_BordroReportController.getHistory';
import UserPreferencesRecordHomeSectionCollapseWTShown from '@salesforce/schema/User.UserPreferencesRecordHomeSectionCollapseWTShown';

export default class Rc_bordroReport extends LightningElement {
    //init parameters
    @track tableDataList;
    @track dataList;
    @track historyDataList;
    @track connectionPeriods = [];
    @track connectionPeriodOptions = [];
    @track selectedConnectionPeriod;

    //pagging 
    @track currentPage = 1;
    @track totalPage = 1;
    @track totalRecord;

    @track isLoading = false;
    @track isShowCekComponent = false;
    @track showHistoryModal =false;
    @track showApproveModal = false;
    @track showCancelModal = false;

    @track approveList =[];
    @track cancelBordroId;

    @track paymentForm;
    @track comment; 
    @track bordroType;

    radioButtonOptions = [
        { label: 'Tümü', value: 'all' },
        { label: 'DTS', value: 'D' },
        { label: 'Çek Senet', value: 'BZ' }
    ];
    @track selectedRadioButton = "all";

    constructor() {
        super();
        this.initComponent();
    }


    renderedCallback() {
        //loadScript(this, jQuery),
        loadStyle(this, CSS)
            .then(() => {
            console.log("Style Loaded.");
            })
            .catch((error) => console.log(error));
    }

    initComponent(event) {
        this.isLoading = true;
        initialize()
          .then((data) => {
            //Data
            this.dataList = data.allTableData;
            
            this.bordroType = data.bordroTypes;
            this.dataList.forEach((q) => {
                let bordroTypeInfo = this.bordroType.find(a => a.RC_Bordro_Types__c == q.RC_Bordro_Types__c);
                q.bordroTypeDesc = bordroTypeInfo.RC_Bordro_Type_Definations__c;
            });
            this.tableDataList = this.dataList.slice(0,25);
            //Pagging
            this.totalRecord = this.dataList.length;
            if(this.dataList.length > 0){
                this.totalPage = Math.ceil(this.totalRecord / 25);
                this.currentPage = 1;
                
            } 
            //Connection Period
            //console.log(data.connectionPeriodPickList);
            this.connectionPeriodOptions = data.connectionPeriodPickList;
            this.selectedConnectionPeriod = data.connectionPeriodPickList.find(period => period.value = "H").value;
            this.comment = this.connectionPeriodOptions.find(period => period.value === this.selectedConnectionPeriod).description;
            //console.log(this.dataList);
            this.isLoading = false;
          })
          .catch((error) => {
            this.isLoading = false;
            console.log(error);
          });
    }

    next(){
        if(this.currentPage != this.totalPage){          
            this.tableDataList = this.dataList.slice(this.currentPage * 25, (this.currentPage + 1) * 25);
            this.currentPage = this.currentPage + 1;
        }   
    }

    previous(){
        if(this.currentPage != 1){   
            this.currentPage = this.currentPage -1;       
            this.tableDataList = this.dataList.slice((this.currentPage - 1 ) * 25, this.currentPage * 25);      
        }
    }

    first(){
        if(this.currentPage != 1){   
            this.currentPage = 1;       
            this.tableDataList = this.dataList.slice(0, 25);      
        }
    }

    last(){
        if(this.currentPage != this.totalPage){   
            this.currentPage = this.totalPage;       
            this.tableDataList = this.dataList.slice((this.totalPage - 1) * 25, this.totalPage * 25);      
        }
    }

    radioChange(event){
        this.selectedRadioButton = event.detail.value;
        this.getConnectionData();
    }

    cbxChange(event){
        this.selectedConnectionPeriod = event.detail.value;
        this.comment = this.connectionPeriodOptions.find(period => period.value === this.selectedConnectionPeriod).description;
        this.getConnectionData();
    }

    getConnectionData(){
        this.isLoading = true;        
        getConnectionPeriodData({
            paymentForm : this.selectedConnectionPeriod , 
            comment : this.comment,
            bordroType: this.selectedRadioButton
        })
            .then((data) => {
                //console.log(data);
                this.dataList = data;
                this.dataList.forEach((q) => {
                    let bordroTypeInfo = this.bordroType.find(a => a.RC_Bordro_Types__c == q.RC_Bordro_Types__c);
                    q.bordroTypeDesc = bordroTypeInfo.RC_Bordro_Type_Definations__c;
                });
                this.tableDataList = this.dataList.slice(0,25);

                this.totalRecord = this.dataList.length;
                this.currentPage = 1;
                if(this.dataList.length > 0){
                    this.totalPage = Math.ceil(this.totalRecord / 25);
                }
                else{
                    this.totalPage = 1;
                } 
                this.isLoading = false;
            })
            .catch((error) => {
                this.isLoading = false;
                console.log(error);
            })
    }
   
    showDetail(event){
        debugger;
        this.isLoading = true;
        //this.showHistoryModal = true;
        const bordroId = event.currentTarget.dataset.value
        console.log(bordroId);

        const bordro = this.tableDataList.find(data => data.Id === bordroId);

        console.log(bordro);
        
        getHistory({
            accId: bordro.RC_Account__c,
            bordroTip: bordro.RC_Bordro_Types__c,
            cariDonemId: bordro.RC_Term_ID__c,
            kka: bordro.RC_KKA_Defination__c
        }).
        then(data => {
            console.log(data);
            let mainData = data.find(q => q.entryId == bordro.Id);
            console.log(mainData);
            if (mainData != undefined && mainData.approvalHistory != undefined && mainData.approvalHistory.length > 0) {
                this.historyDataList = mainData.approvalHistory;
                this.showHistoryModal = true;
            }
            else{
                this.showToast('Onay Geçmişi Yoktur.', 'Approval History', 'warning');
            }

            this.isLoading = false;
        }).
        catch(error => {
            this.isLoading = false;
            console.log(error);
        });
    }

    closeModal() {
        this.showHistoryModal = false;
    }

    showToast(msg, msgTitle, msgType) {
        const evt = new ShowToastEvent({
            title: msgTitle,
            message: msg,
            variant: msgType,
        });

        this.dispatchEvent(evt);
    }

    cbxOnChange(event){
        const bordoId = event.currentTarget.dataset.value;
        if(event.detail.checked && !this.approveList.includes(bordoId)){
            this.approveList.push(bordoId)
        }
        if(!event.detail.checked && this.approveList.includes(bordoId)){
            const index = this.approveList.indexOf(bordoId);
            this.approveList.splice(index,1);
        }
        console.log(this.approveList);
    }

    resetCheckboxes(){
        let checkboxes = this.template.querySelectorAll('[data-id="cbx"]');
        Array.from(checkboxes).forEach(cbx =>{
            cbx.checked = false;
        })
        /*this.approveList.forEach(Id => { 
            let checkbox = Array.from(checkboxes).find(cbx =>cbx.dataset.value === Id );
            checkbox.checked = false;    
        })*/
    }

    approveBordo(){
        this.showApproveModal = false;
        this.isLoading = true;
        console.log(this.approveList);

        bordroApprove({
            bordroList: this.approveList
        })
        .then((data) =>{
            console.log(data); 
            if(data == "Success"){
                this.showToast("Bordrolar oluşturuldu.", "Onay İşlemi", "Success");
            }
            else{
                this.showToast(data, "Onay İşlemi", "Error");
            }
            this.isLoading = false;
            this.resetCheckboxes();
            this.approveList = [];
            this.initComponent();
        })
        .catch((error) => {
            this.showToast(error, "Onay İşlemi", "Error");
            this.resetCheckboxes();
            this.approveList = [];
            this.isLoading = false;
            this.initComponent();
        })
        
    }

    cancelBordro(){
        this.showCancelModal = false;
        this.isLoading = true;
        bordroCancel({
            bordroId: this.cancelBordroId
        })
        .then((data) => {
            console.log(data);
            if(data === "Success"){
                this.showToast("Bordro İptal Edildi.", "İptal İşlemi", "Success");
            }
            else{
                this.showToast(data, "İptal İşlemi", "Error");
            }
            this.initComponent();
            this.cancelBordroId = null;
            
        })
        .catch((error) => {
            this.isLoading = false;
            this.cancelBordroId = null;
            this.showToast(error, "İptal İşlemi", "Error");
        })
    }

    openApproveModal(){
        if(this.approveList.length > 0){
            this.showApproveModal = true;
        }
        else {
            this.showToast("Lütfen en az 1 bordro seçiniz.", "", "Error");
        }
    }

    closeApproveModal(){
        this.showApproveModal = false;
    }

    openCancelModal(event){
        this.cancelBordroId = event.currentTarget.dataset.value;
        this.showCancelModal = true;
    }
    
    closeCancelModal(){
        this.cancelBordroId = null;
        this.showCancelModal = false;
    }
    

}