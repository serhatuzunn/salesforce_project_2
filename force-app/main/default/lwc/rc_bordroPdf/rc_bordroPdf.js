import { api, LightningElement, track } from 'lwc';
import getEmail from '@salesforce/apex/RC_BordroPdf.getEmail';
import sendEmail from '@salesforce/apex/RC_BordroPdf.sendEmail';

export default class Rc_bordroPdf extends LightningElement {
    @api bordroId;
    @api musteriNo;

    @track email;

    connectedCallback() {
        console.log('bordroId : ' + this.bordroId);
        console.log('musteriNo : ' + this.musteriNo);
        getEmail({ musteriNo: this.musteriNo }).then(response => {
            this.email = response;
        }).catch(e => {
            console.log(e);
        });
    }

    emailSendClick(){
        this.email = this.template.querySelector('lightning-input').value;
        sendEmail({sendEmail : this.email, bordroId : this.bordroId}).then(response => {
            if (response) {
                const closeModalEvent = new CustomEvent('sendemailclose', {
                    detail: {
                        data: {
                            close: false,
                            variant: "success",
                            message: "Email gönderildi."
                        }
                    }
                });
                this.dispatchEvent(closeModalEvent);


            }
            else {
                this.errorToast(response);
            }
        }).catch(e => {
            console.log(e);
        });
    }

    closeModal(event) {
        const closeModalEvent = new CustomEvent('sendemailclose', {
            detail: {
                data: {
                    close: false
                }
            }
        });
        this.dispatchEvent(closeModalEvent);
    }

    errorToast(title) {
        const toastEvent = new ShowToastEvent({
            title,
            variant: "error"
        });
        this.dispatchEvent(toastEvent);
    }

}