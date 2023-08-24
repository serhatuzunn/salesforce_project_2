import { LightningElement, api, track } from 'lwc';

export default class Rc_detailModal extends LightningElement {
   
    @api isShowed = false;
    @api detailData;
    @api columns;
    @api invoiceNo;
    
    @api handleStatuChange(){
        this.isShowed = true;
    }

    closeModal() {
        this.isShowed = false;
    }
}