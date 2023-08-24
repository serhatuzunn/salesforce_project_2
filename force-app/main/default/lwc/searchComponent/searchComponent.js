import {
    LightningElement,
    api,
    track,
    wire
} from 'lwc';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import {
    getObjectInfo
} from 'lightning/uiObjectInfoApi';
import search from '@salesforce/apex/SearchController.search';
const DELAY = 300;
export default class SearchComponent extends LightningElement {

    @api valueId;
    @api valueName;
    @api objName = 'Account';
    @api iconName = 'standard:account';
    @api labelName;
    @api whereClause;
    @api readOnly = false;
    @api currentRecordId;
    @api placeholder = 'Search';
    @api createRecord;
    @api fields = ['Name', 'RC_SAP_ID__c'];
    @api displayFields = 'Name,RC_SAP_ID__c';
    @api selectedValue;
    @api selectedValueId;

    @track error;

    searchTerm;
    delayTimeout;

    searchRecords;
    selectedRecord;
    objectLabel;
    isLoading = false;

    field;
    field1;
    field2;

    ICON_URL = '/apexpages/slds/latest/assets/icons/{0}-sprite/svg/symbols.svg#{1}';

    connectedCallback() {

        let icons = this.iconName.split(':');
        this.ICON_URL = this.ICON_URL.replace('{0}', icons[0]);
        this.ICON_URL = this.ICON_URL.replace('{1}', icons[1]);
        if (this.objName.includes('__c')) {
            this.objectLabel = this.objName;
        } else {
            this.objectLabel = this.objName;
        }
        this.objectLabel = this.titleCase(this.objectLabel);
        let fieldList;
        if (!Array.isArray(this.displayFields)) {
            fieldList = this.displayFields.split(',');
        } else {
            fieldList = this.displayFields;
        }

        if (fieldList.length == 1) {
            this.field = fieldList[0].trim();
        }
        if (fieldList.length > 1) {
            this.field = fieldList[0].trim();
            this.field1 = fieldList[1].trim();
        }
        if (fieldList.length > 2) {
            this.field2 = fieldList[2].trim();
        }
        let combinedFields = [];
        fieldList.forEach(field => {
            if (!this.fields.includes(field.trim())) {
                combinedFields.push(field.trim());
            }
        });

        this.fields = combinedFields.concat(JSON.parse(JSON.stringify(this.fields)));
        console.log('TEST12345' + this.selectedValue);

        if(this.selectedValue)
            this.handleInputChange();
    }

    handleInputChange(event) {
        window.clearTimeout(this.delayTimeout);
        console.log('handleInputChange' + this.selectedValue);
        const searchKey = this.selectedValue ? this.selectedValue : event.target.value;
        this.isLoading = true;
        this.delayTimeout = setTimeout(() => {
            if (searchKey.length >= 2) {
                search({
                        objectName: this.objName,
                        fields: this.fields,
                        searchTerm: searchKey,
                        whereClause: this.whereClause
                    })
                    .then(result => {
                        let stringResult = JSON.stringify(result);
                        let allResult = JSON.parse(stringResult);
                        allResult.forEach(record => {
                            record.Name = record[this.field];
                            record.RC_SAP_ID__c = record[this.field1];
                        });
                        this.searchRecords = allResult;

                        if(this.selectedValue)
                            this.handleSelect();
                    })
                    .catch(error => {
                        console.error('Error:', error);
                    })
                    .finally(() => {
                        this.isLoading = false;
                    });
            } else {
                this.searchRecords = [];
                this.isLoading = false;
            }
        }, DELAY);
    }

    handleSelect(event) {
        console.log('handleSelect' + this.selectedValueId);


        let recordId = this.selectedValueId ? this.selectedValueId :  event.currentTarget.dataset.recordId;
        this.valueId = recordId;
        let selectRecord = this.searchRecords.find((item) => {
            return item.Id === recordId;
        });
        this.selectedRecord = selectRecord;
        this.currentRecordId = recordId;

        const selectEvent = new CustomEvent('lookup', {
            bubbles: true,
            composed: true,
            cancelable: true,
            detail: {
                data: {
                    objectName: this.objName,
                    record: selectRecord,
                    recordId: recordId,
                    currentRecordId: this.currentRecordId
                }
            }
        });
        this.dispatchEvent(selectEvent);
    }

    handleClose(event) {
        let selectedRecordId = this.valueId;

        this.selectedRecord = undefined;
        this.searchRecords = undefined;
        this.currentRecordId = undefined;
        const closeEvent = new CustomEvent('lookup', {
            bubbles: true,
            composed: true,
            cancelable: true,
            detail: {
                data: {
                    objectName: this.objName,
                    record: this.selectedRecord,
                    recordId: selectedRecordId,
                    currentRecordId: this.currentRecordId
                }
            }
        });
        this.dispatchEvent(closeEvent);
    }

    titleCase(string) {
        var sentence = string.toLowerCase().split(" ");
        for (var i = 0; i < sentence.length; i++) {
            sentence[i] = sentence[i][0].toUpperCase() + sentence[i].slice(1);
        }
        return sentence;
    }
}