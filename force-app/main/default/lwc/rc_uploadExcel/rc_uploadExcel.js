import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getExcelData from '@salesforce/apex/RC_UploadExcel.getExcelData';
import insertChequeList from '@salesforce/apex/RC_CreateChequeAndBond.insertChequeList';
import TopluCekSablon from '@salesforce/resourceUrl/TopluCekEkleOrnek';

export default class Rc_uploadExcel extends LightningElement {
    @api bordroId;
    @api musteriNo;
    fileData;
    MAX_FILE_SIZE = 3000000; //Max file size 4.5 MB 
    @track successData = [];
    @track errorData = [];
    @track columns = [];

    @track renderSuccess = false;
    @track renderError = false;

    openfileUpload(event) {
        const file = event.target.files[0];
        var reader = new FileReader();
        reader.onload = () => {
            // var base64 = reader.result.split(',')[1];

            var fileContents = reader.result;
            var base64t = 'base64,';
            var dataStart = fileContents.indexOf(base64t) + base64t.length;
            fileContents = fileContents.substring(dataStart);
            var base64 = fileContents;

            //console.log('Base64  : ' + JSON.stringify(base64));

            this.fileData = {
                'filename': file.name,
                'filesize': file.size,
                'base64': base64
            };
            //console.log(this.fileData);
        }
        reader.readAsDataURL(file);
    }

    handleClick() {
        const { filename, filesize, base64 } = this.fileData;

        //console.log('filename : ' + filename);
        //console.log('base64 : ' + base64);
        //console.log('filesize : ' + filesize);

        if (filesize > this.MAX_FILE_SIZE) {
            let title = `${filename} - dosya 3MB boyutundan büyük olamaz."`;
            this.errorToast(title);
        }
        else {
            this.renderSuccess = false;
            this.renderError = false;
            getExcelData({ base64String: base64, musteriNo: this.musteriNo, bordroId: this.bordroId }).then(response => {
                this.columns = [
                    { label: 'Çek No', fieldName: 'RC_Cheque_Number__c' },
                    { label: 'Vade Tarihi', fieldName: 'RC_Due_Date__c' },
                    { label: 'Tutar', fieldName: 'RC_Amount__c' },
                    { label: 'Banka Anahtarı', fieldName: 'bankKey' },
                    { label: 'TCKN Vergi No', fieldName: 'RC_Identification_Number__c' },
                    { label: 'Banka Hesap No', fieldName: 'RC_Bank_Account_Number__c' },
                    { label: 'Kesideci Bölge', fieldName: 'RC_Drawer_Region__c' },
                    { label: "Mesaj", fieldName: "RC_Description__c", wrapText: true }
                ];

                response.successList.forEach((data) => {
                    let relatedBankInfo = response.bankInfoList.find(q => q.Id == data.RC_Bank_Key__c);

                    if (relatedBankInfo != undefined) {
                        data.bankKey = relatedBankInfo.RC_BANKL__c;
                    }
                });
                this.successData = response.successList;

                response.errorList.forEach((data) => {
                    let relatedBankInfo = response.bankInfoList.find(q => q.Id == data.RC_Bank_Key__c);

                    if (relatedBankInfo != undefined) {
                        data.bankKey = relatedBankInfo.RC_BANKL__c;
                    }
                });
                this.errorData = response.errorList;

                if (response.successList != undefined && response.successList.length > 0) {
                    this.renderSuccess = true;
                }
                if (response.errorList != undefined && response.errorList.length > 0) {
                    this.renderError = true;
                }
            }).catch(e => {
                console.log(e);
            });
        }
    }

    closeModal(event) {

        const closeModalEvent = new CustomEvent('toplucekclose', {
            detail: {
                data: {
                    close: false
                }
            }
        });
        this.dispatchEvent(closeModalEvent);
    }

    successButtonClick(event) {
        insertChequeList({ insertList: this.successData }).
            then(response => {
                if (response.isSuccess) {
                    const closeModalEvent = new CustomEvent('toplucekclose', {
                        detail: {
                            data: {
                                close: false,
                                variant: "success",
                                message: "Çekler başarılı bir şekilde kaydedildi."
                            }
                        }
                    });
                    this.dispatchEvent(closeModalEvent);


                }
                else {
                    this.errorToast(response.message);
                }
            }).catch(e => {
                this.errorToast(e);
            });

    }

    downloadSampleFile(event) {
        window.open(TopluCekSablon, '_blank');
    }

    errorToast(title) {
        const toastEvent = new ShowToastEvent({
            title,
            variant: "error"
        });
        this.dispatchEvent(toastEvent);
    }
}