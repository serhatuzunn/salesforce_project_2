import { LightningElement, api, track, wire  } from 'lwc';
import getInit from '@salesforce/apex/RC_DocFlowComponentController.initialize';


export default class Rc_docflow extends LightningElement {
    @api recordId;

    @track isLoading = false;
    @track isWarning = false;
    @track cargoList = [];
  

    connectedCallback(){
        console.log('lwc record id : ' + this.recordId)
        this.isLoading = true;
        try {
            getInit({
                recordId: this.recordId
          })
            .then((result) => {

              console.log(JSON.stringify(result.cargoResponseModel.CargoItemList));

              if(result != null && result.cargoResponseModel != null && result.cargoResponseModel.CargoItemList.length != 0){
                this.cargoList = result.cargoResponseModel.CargoItemList;
                this.isWarning = false;
              }
              else{
                this.isWarning = true;
              }


              this.isLoading = false;
            })
            .catch((error) => {
              console.log(error);
              this.isLoading = false;
              this.isWarning = true;
             
            });
            console.log('Cargo List : ' + JSON.stringify(this.cargoList));
        } catch (err) {
          console.log(err);
        }
    }

    get detayColumns() {
      return [
        {
          label: "Teslimat No",
          fieldName: "ZTM_DELIVEY_NO",
          cellAttributes: { alignment: "left" }
        },
        {
          label: "Kalem No",
          fieldName: "POSNR_VA",
          cellAttributes: { alignment: "left" }
        },
        {
          label: "Teslimat Durumu",
          fieldName: "ZZ_ENH_DELIVERY_ST_TXT",
          cellAttributes: { alignment: "left" }
        },
        {
          label: "Kargo Firması",
          fieldName: "CARGO_COMPANY",
          cellAttributes: { alignment: "left" }
        },
        {
          label: "Fatura No",
          fieldName: "VBELN_VF",
          cellAttributes: { alignment: "left" }
        },
        {
          label: "Belge Çıkış No",
          fieldName: "VBELN_CKS",
          cellAttributes: { alignment: "left" }
        }
      ];
    }

   
}