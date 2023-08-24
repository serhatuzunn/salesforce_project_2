public with sharing class CollectionReportController {
  public class initModel {
    @AuraEnabled
    public List<SelectOption> odemeBicimiPicklist { get; set; }
    @AuraEnabled
    public List<SelectOption> surecTipiPicklist { get; set; }
    @AuraEnabled
    public List<SelectOption> belgeTuruPicklist { get; set; }
    @AuraEnabled
    public List<SelectOption> krediKontrolPicklist { get; set; }
    @AuraEnabled
    public List<SelectOption> OdemeBlokajPicklist { get; set; }
    @AuraEnabled  
    public Boolean isCommunity {get;set;}
    @AuraEnabled  
    public String selectedAccountId {get;set;}
    @AuraEnabled
    public boolean isDTS { get; set; }
  }

  public class SelectOption {
    @AuraEnabled
    public string label { get; set; }
    @AuraEnabled
    public string value { get; set; }
  }

  public class dataTableModel {
    @AuraEnabled
    public List<RC_AcikKalemlerParser.Item_Z> itemList { get; set; }
    @AuraEnabled
    public integer EV_TOTAL_IND { get; set; }
    @AuraEnabled
    public string message { get; set; }
    @AuraEnabled
    public boolean isDTS { get; set; }
  }

  public class OrtalamaVadeModel {
    @AuraEnabled
    public string BAKIYE { get; set; }
    @AuraEnabled
    public string ORTVADE { get; set; }
  }

  public class bordroYaratDTSResponseModel{
    @AuraEnabled
    public string message {get;set;}
    @AuraEnabled
    public boolean success {get;set;}
    @AuraEnabled 
    public string bordroId {get;set;}
  }

  @AuraEnabled
  public static initModel initialize() {
    initModel result = new initModel();
    result.isCommunity = false;
    List<RC_Financial_Process_Definition__c> FPDList = new List<RC_Financial_Process_Definition__c>();
    List<RC_Financial_Process_Definition__c> existConnectionList = new List<RC_Financial_Process_Definition__c>();
    
    if(String.isNotBlank(Network.getNetworkId())){
        system.debug('Network.getNetworkId() :' + Network.getNetworkId());
      result.isCommunity = true;
      result.selectedAccountId = [SELECT id, AccountId, Account.RC_SAP_ID__c  FROM User WHERE id =: UserInfo.getUserId()].AccountId;
      result.isDTS = [SELECT RC_IsDTS__c FROM Account WHERE id =: result.selectedAccountId].RC_IsDTS__c;

      Date newDate = System.today().addDays(-1);
      existConnectionList = [SELECT id 
                              FROM RC_Financial_Process_Definition__c 
                              WHERE RC_Account__c =: result.selectedAccountId 
                              AND RecordType.DeveloperName ='Connection_Bordro_Entry' AND CreatedDate >=: newDate];
    }

    FPDList = [SELECT RecordTypeId,RC_Comments__c,RC_Document_Type_Defination__c,RecordType.DeveloperName,RC_Fiscal_Year__c,RC_Document_Type__c,RC_KKA__c,RC_KKA_Defination__c,RC_Payment_Form__c,RC_Bordro_Type_Definations__c,RC_Bordro_Types__c,RC_Process_Type__c,RC_Process_Type_Definition__c FROM RC_Financial_Process_Definition__c 
            WHERE RecordType.DeveloperName = 'Payment_Forms'
            OR RecordType.DeveloperName = 'Document_Types'
            OR (RecordType.DeveloperName = 'Process_Types' AND (RC_Process_Type__c = '01' OR RC_Process_Type__c = '02' OR RC_Process_Type__c = '03'))
            OR RecordType.DeveloperName = 'Credit_Control_Sales_Organization'
            OR RecordType.DeveloperName ='Payment_Blockage'];

    result.belgeTuruPicklist = new List<SelectOption>();
    result.krediKontrolPicklist = new List<SelectOption>();
    result.odemeBicimiPicklist = new List<SelectOption>();
    result.OdemeBlokajPicklist = new List<SelectOption>();
    result.surecTipiPicklist = new List<SelectOption>();


    SelectOption optionEmpty = new SelectOption();
    optionEmpty.label = '';
    optionEmpty.value = '';

    result.belgeTuruPicklist.add(optionEmpty);
    result.krediKontrolPicklist.add(optionEmpty);
    result.odemeBicimiPicklist.add(optionEmpty);
    result.OdemeBlokajPicklist.add(optionEmpty);
    result.surecTipiPicklist.add(optionEmpty);

    if (FPDList.size() > 0) {
      for (RC_Financial_Process_Definition__c FPD : FPDList) {
        SelectOption option = new SelectOption();
        if (FPD.RecordType.DeveloperName == 'Payment_Forms') {
          option.label =FPD.RC_Payment_Form__c;
          option.value = FPD.RC_Payment_Form__c;
          result.odemeBicimiPicklist.add(option);

        } else if (FPD.RecordType.DeveloperName == 'Document_Types') {
            if (String.isNotBlank(FPD.RC_Document_Type__c)) {
              option.value = FPD.RC_Document_Type__c;
              if (String.isEmpty(FPD.RC_Document_Type_Defination__c)) {
                option.label = FPD.RC_Document_Type__c;
              } else {
                option.label = FPD.RC_Document_Type_Defination__c;
              }
              result.belgeTuruPicklist.add(option);
            }

        } else if (FPD.RecordType.DeveloperName == 'Process_Types') {
          if (FPD.RC_Process_Type__c == '03') {
            if (result.isCommunity == true) {
              if (existConnectionList.size() > 0) {
                option.value = FPD.RC_Process_Type__c;
                option.label = FPD.RC_Process_Type_Definition__c;
                result.surecTipiPicklist.add(option);
              }
            }else {
              option.value = FPD.RC_Process_Type__c;
              option.label = FPD.RC_Process_Type_Definition__c;
              result.surecTipiPicklist.add(option);
            }
          }else if(FPD.RC_Process_Type__c == '02') {
            if (result.isCommunity == true) {
              if (result.isDTS) {
                  option.value = FPD.RC_Process_Type__c;
                  if (String.isEmpty(FPD.RC_Process_Type_Definition__c)) {
                    option.label = FPD.RC_Process_Type__c;
                  } else {
                    option.label = FPD.RC_Process_Type_Definition__c;
                  }
                  result.surecTipiPicklist.add(option);
              }
            }else {
              option.value = FPD.RC_Process_Type__c;
              if (String.isEmpty(FPD.RC_Process_Type_Definition__c)) {
                option.label = FPD.RC_Process_Type__c;
              } else {
                option.label = FPD.RC_Process_Type_Definition__c;
              }
              result.surecTipiPicklist.add(option);
            }
          }else {
            option.value = FPD.RC_Process_Type__c;
            if (String.isEmpty(FPD.RC_Process_Type_Definition__c)) {
              option.label = FPD.RC_Process_Type__c;
            } else {
              option.label = FPD.RC_Process_Type_Definition__c;
            }
            result.surecTipiPicklist.add(option);
          }

        } else if (FPD.RecordType.DeveloperName == 'Credit_Control_Sales_Organization') {
          option.value = FPD.RC_KKA__c;
          if (String.isEmpty(FPD.RC_KKA_Defination__c)) {
            option.label = FPD.RC_KKA__c;
          } else {
            option.label = FPD.RC_KKA_Defination__c;
          }
          result.krediKontrolPicklist.add(option);

        } else if (FPD.RecordType.DeveloperName == 'Payment_Blockage') {
          option.value = FPD.RC_Document_Type__c;
          if (String.isEmpty(FPD.RC_Document_Type__c )) {
            option.label = FPD.RC_Document_Type__c;
          } else {
            option.label = FPD.RC_Document_Type__c;
          }
          result.OdemeBlokajPicklist.add(option);
        }


      }
    }
      system.debug('result :::' + JSON.serialize(result));
    return result;
  }

  @AuraEnabled
  public static dataTableModel getDocumentOnDemand(string accountId,string surID,string KKBER,string KEYDATE,string VADETARIHI,string ODK,integer packageSize,integer INDEX) {
    Account acc = [
      SELECT RC_SAP_ID__c,RC_IsDTS__c
      FROM Account
      WHERE id = :accountId
      LIMIT 1
    ];

    RC_AcikKalemlerIntegrator.RequestModel req = new RC_AcikKalemlerIntegrator.RequestModel();

    if (string.isEmpty(KEYDATE)) {
      req.IV_KEYDATE = '99991231';
    } else {
      req.IV_KEYDATE = KEYDATE.remove('-');
    }

    if (string.isEmpty(VADETARIHI)) {
      req.IV_VADET = '';
    } else {
      req.IV_VADET = VADETARIHI.remove('-');
    }

    req.IV_BUKRS = '2002';
    req.IV_KKBER = KKBER;
    req.IV_KUNNR = acc.RC_SAP_ID__c;
    req.IV_ODK = ODK;
    req.IV_SURID = surID;
    req.IV_PACKAGE = packageSize;
    req.IV_INDEX = INDEX;

    dataTableModel dataModel = new dataTableModel();
    if(acc.RC_IsDTS__c){
      dataModel.isDTS = true;
    }else{
      dataModel.isDTS = false;
    }
 
 
    RC_AcikKalemlerIntegrator.ResponseModel response = RC_AcikKalemlerIntegrator.getAcikKalemler(req);
    system.debug('response controller : ' + JSON.serialize(response));
    if(response.acikKalemlerResponse != null){
      if (response.acikKalemlerResponse.ET_ITEMS != null) {
        if (response.acikKalemlerResponse.ET_ITEMS.item.size() > 0) {
          dataModel.EV_TOTAL_IND = response.acikKalemlerResponse.EV_TOTAL_IND;
          dataModel.itemList = response.acikKalemlerResponse.ET_ITEMS.item;
        } else {
          dataModel.itemList = new List<RC_AcikKalemlerParser.Item_Z>();
          dataModel.message = 'Seçilen değerler ile veri bulunamadı .';
        }
      } else {
        dataModel.message = 'Seçilen değerler ile veri bulunamadı .';
      }
    }else{
      dataModel.itemList = new List<RC_AcikKalemlerParser.Item_Z>();
      dataModel.message = 'Seçilen değerler ile veri bulunamadı .';
    }

    

    system.debug('dataModel.EV_TOTAL_IND : ' + dataModel.EV_TOTAL_IND);
    system.debug('dataModel.itemList : ' + JSON.serialize(dataModel.itemList));

    return dataModel;
  }

  @AuraEnabled
  public static OrtalamaVadeModel ortalamaVadeBul(string dataList) {
    List<RC_AcikKalemlerParser.Item_Z> dataItemList = (List<RC_AcikKalemlerParser.Item_Z>) JSON.deserialize(
      dataList,
      List<RC_AcikKalemlerParser.Item_Z>.class
    );

    RC_FI_OrtalamaVadeIntegrator.requestModel reqModel = new RC_FI_OrtalamaVadeIntegrator.requestModel();
    reqModel.IT_LINEITEMS = new RC_FI_OrtalamaVadeIntegrator.IT_LINEITEMS();

    reqModel.IT_LINEITEMS.item = new List<RC_FI_OrtalamaVadeIntegrator.item>();

    for (RC_AcikKalemlerParser.Item_Z item : dataItemList) {
      RC_FI_OrtalamaVadeIntegrator.item reqItem = new RC_FI_OrtalamaVadeIntegrator.item();

      List<string> splittedStrZFBDT = item.ZFBDT.split('-');
      string d = splittedStrZFBDT[0];
      string m = splittedStrZFBDT[1];
      string y = splittedStrZFBDT[2];
      reqItem.BLINE_DATE = y + m + d;

      List<string> splittedStrBUDAT = item.BUDAT.split('-');
      d = splittedStrBUDAT[0];
      m = splittedStrBUDAT[1];
      y = splittedStrBUDAT[2];
      reqItem.PSTNG_DATE = y + m + d;

      reqItem.DSCT_DAYS1 = '';
      decimal tempAmount = Decimal.valueOf(item.DMBTR);
      if (tempAmount > 0) {
        reqItem.DB_CR_IND = 'S';
      } else {
        reqItem.DB_CR_IND = 'H';
      }

      reqItem.LC_AMOUNT = item.DMBTR.replace('-', '');
      System.debug(reqItem);
      reqModel.IT_LINEITEMS.item.add(reqItem);
    }

    RC_FI_OrtalamaVadeIntegrator.responseModel responseIntegrator = RC_FI_OrtalamaVadeIntegrator.FI_OrtalamaVadeBul(
      reqModel
    );
    OrtalamaVadeModel ortVadeModel = new OrtalamaVadeModel();
    ortVadeModel.BAKIYE = responseIntegrator.EV_BAKIYE;
    ortVadeModel.ORTVADE = responseIntegrator.EV_ORTVADE;

    return ortVadeModel;
  }

  @AuraEnabled
  public static RC_FI_BordroGirIntegrator.responseModel BordroKaydet(string accountId,string selectedODK,string selectedKKBER,string selectedKEYDATE,string dataItemList) {
    Account acc = [
      SELECT RC_SAP_ID__c
      FROM Account
      WHERE id = :accountId
      LIMIT 1
    ];
    List<RC_AcikKalemlerParser.Item_Z> dataItemListParsed = (List<RC_AcikKalemlerParser.Item_Z>) JSON.deserialize(dataItemList,List<RC_AcikKalemlerParser.Item_Z>.class);

    RC_FI_BordroGirIntegrator.requestModel request = new RC_FI_BordroGirIntegrator.requestModel();
    request.IT_ITEMS = new RC_FI_BordroGirIntegrator.IT_ITEMS();
    request.IT_ITEMS.item = new List<RC_FI_BordroGirIntegrator.Item>();

    request.IV_ODK = 'C';
    request.IV_KUNNR = acc.RC_SAP_ID__c;
    request.IV_KKBER = selectedKKBER;

    for (RC_AcikKalemlerParser.Item_Z item : dataItemListParsed) {
      RC_FI_BordroGirIntegrator.Item reqItem = new RC_FI_BordroGirIntegrator.Item();

      List<string> splittedStrZFBDT = item.ZFBDT.split('-');
      string d = splittedStrZFBDT[0];
      string m = splittedStrZFBDT[1];
      string y = splittedStrZFBDT[2];
      reqItem.ZFBDT = y + m + d;

      List<string> splittedStrBUDAT = item.BUDAT.split('-');
      d = splittedStrBUDAT[0];
      m = splittedStrBUDAT[1];
      y = splittedStrBUDAT[2];
      reqItem.BUDAT = y + m + d;

      reqItem.DMBTR = item.DMBTR;
      reqItem.BELNR = item.BELNR;
      reqItem.BUZEI = item.BUZEI;
      reqItem.KUNNR = acc.RC_SAP_ID__c;
      reqItem.WAERS = item.WAERS;
      reqItem.SGTXT = '';
      reqItem.BLART = '';
      reqItem.VKBUR = '';
      reqItem.UMSKZ = selectedODK;

      System.debug(reqItem);
      request.IT_ITEMS.item.add(reqItem);
    }
    RC_FI_BordroGirIntegrator.responseModel resp = RC_FI_BordroGirIntegrator.BordroGir(request);

    if (resp.EV_SUCCESS == 'X') {
      RC_Bordro__c bordro = new RC_Bordro__c();
      bordro.RC_Bordro_No__c = resp.BORDRONO;
      bordro.RC_Amount__c = decimal.valueOf(resp.EV_BAKIYE);
      bordro.RC_Dealer_Number__c = acc.RC_SAP_ID__c;
      bordro.RC_Kkber__c = resp.EV_KKBER;
      bordro.RC_ST_Approval_Date__c = system.Date.today();
      bordro.RC_Bordro_Status_ID__c = '1';
      bordro.RC_Bordro_Type__c  = 'C';
      bordro.RC_Process_Type__c = '01';

      List<string> splittedDate2 = resp.EV_ORTVADE.split('-');
      bordro.RC_Average_Due_Date__c = Date.newInstance(
        integer.valueOf(splittedDate2[2]),
        integer.valueOf(splittedDate2[1]),
        integer.valueOf(splittedDate2[0])
      );

      Database.SaveResult sr = database.insert(bordro);
      if (sr.isSuccess()) {
        System.debug('BORDRO ID : ' + sr.getId());
        resp.bordroId = sr.getId();
        System.debug('BORDRO ID RESP : ' + resp.bordroId);
        List<RC_Cheques__c> invList = new List<RC_Cheques__c>();

        for (RC_AcikKalemlerParser.Item_Z itm : dataItemListParsed) {
          RC_Cheques__c cheq = new RC_Cheques__c();

          cheq.RC_Bordro__c = resp.bordroId;
          cheq.RC_Amount__c = decimal.valueof(itm.DMBTR);
          cheq.RC_Invoice_Number__c = itm.BELNR;
          cheq.RC_SD_Invoice_Number__c = itm.BELNR;
          cheq.RC_Description__c = itm.LTEXT;
          cheq.RC_Product_Info__c = itm.formattedProductInfo;
          cheq.RC_Type__c = 'Invoice';

          List<string> splittedDate = itm.ZFBDT.split('-');
          cheq.RC_Due_Date__c = Date.newInstance(
            integer.valueOf(splittedDate[2]),
            integer.valueOf(splittedDate[1]),
            integer.valueOf(splittedDate[0])
          );
          invList.add(cheq);
        }

        if (invList.size() > 0) {
          List<Database.SaveResult> srInvList = Database.insert(invList, true);
        }
      }

      resp.EV_MESSAGE =+resp.EV_BAKIYE +' Bakiyeli ' +resp.BORDRONO +' Numaralı Bordro Başarıyla Kaydedildi.';
      return resp;
    } else {
      return resp;
    }
  }

  @AuraEnabled
  public static bordroYaratDTSResponseModel BordroYaratDTS(string accountId,string dataItemList ,string dataItemListUnChecked, string bakiye,string selectedKKBER,string ortVadeTarihi) {
    bordroYaratDTSResponseModel result = new bordroYaratDTSResponseModel();

    List<RC_AcikKalemlerParser.Item_Z> dataItemListParsed = (List<RC_AcikKalemlerParser.Item_Z>) JSON.deserialize(dataItemList,List<RC_AcikKalemlerParser.Item_Z>.class);
    List<RC_AcikKalemlerParser.Item_Z> dataItemListUnCheckedParsed = (List<RC_AcikKalemlerParser.Item_Z>) JSON.deserialize(dataItemListUnChecked,List<RC_AcikKalemlerParser.Item_Z>.class);
    System.debug('dataItemListUnChecked ::' + dataItemListUnChecked);
    System.debug('dataItemListUnCheckedParsed ::' + dataItemListUnCheckedParsed);

    decimal bakiyeDecimal = decimal.valueOf(bakiye);

    Account acc = [
      SELECT id, RC_DTS_Bank__c, RC_SAP_ID__c,RC_IsDTS__c ,RC_Mobile__c
      FROM Account
      WHERE id = :accountId
      LIMIT 1
    ];

    Set<string> invoiceNumberSet = new Set<string>();

    for (RC_AcikKalemlerParser.Item_Z itm : dataItemListUnCheckedParsed) {
      invoiceNumberSet.add(itm.BELNR.trim()+String.ValueOf(itm.GJAHR).trim());
    }
    
    List<RC_Bordro__c> openCheques = [SELECT id , RC_Dealer_Number__c ,
    (SELECT Id,RC_SD_Invoice_Number__c, RC_City__c, RC_City__r.Name, RC_Drawer_Region__c, RC_Due_Date__c, RC_Cheque_Bill__c, RC_Cheque_Number__c, RC_Amount__c, RC_Identification_Number__c, RC_Bank_Key__c,
     RC_Bank_Key__r.Name, RC_Bank_Key__r.RC_BANK__c, RC_Bank_Key__r.RC_BRINCH__c, RC_Bank_Key__r.RC_BANKL__c, RC_Bank_Account_Number__c, RC_IsSent__c, RC_Check_Status_ID__c, RC_Bill_Number__c
    FROM Cheques__r WHERE RC_Type__c = 'Seperated Invoices' AND RC_Invoice_Number__c IN: invoiceNumberSet)
    FROM RC_Bordro__c WHERE RC_Dealer_Number__c =: acc.RC_SAP_ID__c];

    string openChequeMessage = '';
    for (RC_Bordro__c brd : openCheques) {
      if (brd.Cheques__r != null && brd.Cheques__r.size() > 0) {
        openChequeMessage = brd.Cheques__r[0].RC_SD_Invoice_Number__c + ' Numaralı açık bırakılan belgeyi eklemeden yeni bordro yaratamazsınız !';
        break;
      }
    }

    //Açık belge kontrolü 
    if (String.isNotBlank(openChequeMessage)) {
      result.success = false;
      result.message = openChequeMessage;
      return result;
    }else{
        ZFI_SF_BordroYapIntegrator.requestModel request = new ZFI_SF_BordroYapIntegrator.requestModel();
        ZFI_SF_BordroYapIntegrator.item itm_IN_TAUGRU = new ZFI_SF_BordroYapIntegrator.item();
        ZFI_SF_BordroYapIntegrator.item itm_IO_TKUNNR = new ZFI_SF_BordroYapIntegrator.item();
        ZFI_SF_BordroYapIntegrator.IN_TAUGRU IN_TAUGRU = new ZFI_SF_BordroYapIntegrator.IN_TAUGRU();
        ZFI_SF_BordroYapIntegrator.IO_TKUNNR IO_TKUNNR = new ZFI_SF_BordroYapIntegrator.IO_TKUNNR();

        IN_TAUGRU.item = new List<ZFI_SF_BordroYapIntegrator.item>();
        IO_TKUNNR.item = new List<ZFI_SF_BordroYapIntegrator.item>();

        Integer currentYear = system.today().year();
        string currentMonth = string.ValueOf(system.today().month());
        string currentDay = string.ValueOf(system.today().day());

        string prevYear = string.ValueOf(currentYear - 1);

        // request.IV_BEG_DATE = prevYear + '0101';
        //  request.IV_END_DATE = string.ValueOf(currentYear) + currentMonth + '05';
        request.IV_BEG_DATE = '';  
        request.IV_END_DATE = '';
        //request.PBANKA = acc.RC_DTS_Bank__c;
        request.PBANKA = '';
        request.PBGLNT = '';
        request.PBRDTYP = 'C';
        request.PKUNSCR = 'X';
        request.PSIMUL = ' ';
        request.PTAKSIT = '6';
        request.PKKBER =selectedKKBER;

        itm_IN_TAUGRU.AUGRU = '';

        itm_IO_TKUNNR.KUNNR = acc.RC_SAP_ID__c;
        itm_IO_TKUNNR.BORDROTYPE = 'C';
        itm_IO_TKUNNR.SONUC = '';
        itm_IO_TKUNNR.BORDRONO = '';
        itm_IO_TKUNNR.MSG = '';
        itm_IO_TKUNNR.KKBER = '';

        IN_TAUGRU.item.add(itm_IN_TAUGRU);
        IO_TKUNNR.item.add(itm_IO_TKUNNR);

        request.IN_TAUGRU = IN_TAUGRU;
        request.IO_TKUNNR = IO_TKUNNR;

        ZFI_SF_BordroYapIntegrator.responseModel resp = ZFI_SF_BordroYapIntegrator.bordroYap(request);
        
        System.debug('BORDRONO :' + resp.bordroYapResponse.IO_TKUNNR.item[0].BORDRONO);
        System.debug('EV_MESSAGE :' + resp.bordroYapResponse.EV_MESSAGE);

        if (string.isBlank(resp.bordroYapResponse.IO_TKUNNR.item[0].BORDRONO)) {
          result.message = 'Bordro yaratılamadı : ' + resp.bordroYapResponse.IO_TKUNNR.item[0].MSG;
          result.success = false;
          return result;
        } else {
          RC_DTSBordroKalemSilIntegrator.requestModel kalemSilRequest = new RC_DTSBordroKalemSilIntegrator.requestModel();
          kalemSilRequest.T_ITEMS = new RC_DTSBordroKalemSilIntegrator.T_ITEMS();
          kalemSilRequest.T_ITEMS.item =  new List<RC_DTSBordroKalemSilIntegrator.item>();

          string bordroNoForDeleting = resp.bordroYapResponse.IO_TKUNNR.item[0].BORDRONO;

          Boolean isSuccessKalemSil = true;
          if(dataItemListUnCheckedParsed.size() > 0 ){
            for (RC_AcikKalemlerParser.Item_Z itm : dataItemListUnCheckedParsed) {
              RC_DTSBordroKalemSilIntegrator.item kalemSilItem = new RC_DTSBordroKalemSilIntegrator.item();
              kalemSilItem.BORDRO = resp.bordroYapResponse.IO_TKUNNR.item[0].BORDRONO;
              kalemSilItem.BELNR = itm.BELNR;
              kalemSilItem.GJAHR = string.valueOf(itm.GJAHR);
      
              kalemSilRequest.T_ITEMS.item.add(kalemSilItem);
            }

            RC_DTSBordroKalemSilIntegrator.responseModel kalemSilResponse = RC_DTSBordroKalemSilIntegrator.DTSBordroKalemSil(kalemSilRequest);
            List<RC_DTSBordroKalemSilParser.Item> itemList = new List<RC_DTSBordroKalemSilParser.Item>();
            itemList = kalemSilResponse.kalemSilResponse.T_RETURN.item;

            for (RC_DTSBordroKalemSilParser.Item kalemSilResponseItem : itemList) {
              if(kalemSilResponseItem.RESULT == 'F'){
                isSuccessKalemSil = false;
                break;
              }
            }
          }

          if(!isSuccessKalemSil){
            //Bordroyu sil
            //..

            RC_FI_DTS_BordroSilIntegrator.requestModel bordroSilRequest = new RC_FI_DTS_BordroSilIntegrator.requestModel();
            bordroSilRequest.T_BORDRO = new RC_FI_DTS_BordroSilIntegrator.T_BORDRO();
            bordroSilRequest.T_BORDRO.item = new List<RC_FI_DTS_BordroSilIntegrator.Item>();

            RC_FI_DTS_BordroSilIntegrator.Item bordroSilItem = new RC_FI_DTS_BordroSilIntegrator.Item();
            bordroSilItem.BORDRO = bordroNoForDeleting;
            bordroSilRequest.T_BORDRO.item.add(bordroSilItem);
            RC_FI_DTS_BordroSilIntegrator.responseModel bordroSilResponse = new RC_FI_DTS_BordroSilIntegrator.responseModel();

            bordroSilResponse.DURUM = RC_FI_DTS_BordroSilIntegrator.bordroSil(bordroSilRequest);//Response == 'OK' ise bordro silinmiştir.
            if(bordroSilResponse.DURUM == 'OK'){
              result.message = 'Bordro yaratılırken hata oluştu !';
              result.success = false;
              return result;
            }else{
              result.message = 'Hatalı bordro yaratıldı lütfen yetkili ile iletişime geçiniz !';
              result.success = false;
              return result;
            }
          }else{
              // bordro objesine yaratılan DTS bordrosunu kayıt at
              RC_Bordro__c bordro = new RC_Bordro__c();
              bordro.RC_Bordro_No__c        = resp.bordroYapResponse.IO_TKUNNR.item[0].BORDRONO;
              bordro.RC_Amount__c           = bakiyeDecimal;
              bordro.RC_Dealer_Number__c    = acc.RC_SAP_ID__c;
              bordro.RC_Kkber__c            = selectedKKBER;
              bordro.RC_ST_Approval_Date__c = system.Date.today();
              bordro.RC_Bordro_Status_ID__c = '1'; 
              bordro.RC_Bordro_Type__c      = 'C'; 
              bordro.RC_Process_Type__c     = '02';


              System.debug('ortVadeTarihi ::' + ortVadeTarihi);
              List<string> splittedDate2 = ortVadeTarihi.split('-');
              bordro.RC_Average_Due_Date__c = Date.newInstance(integer.valueOf(splittedDate2[0]),integer.valueOf(splittedDate2[1]),integer.valueOf(splittedDate2[2]));

              
              Database.SaveResult sr = database.insert(bordro);

              // seçili kalemleri fatura tipinde çek objesine kayıt at
              //..
              if (sr.isSuccess()) {
                  result.bordroId = sr.getId();
                  List<RC_Cheques__c> invList = new List<RC_Cheques__c>();
                  for (RC_AcikKalemlerParser.Item_Z itm : dataItemListParsed) {
                  RC_Cheques__c cheq = new RC_Cheques__c();

                  cheq.RC_Bordro__c             = sr.getId();
                  cheq.RC_Amount__c             = decimal.valueof(itm.DMBTR);
                  cheq.RC_Invoice_Number__c     = itm.BELNR;
                  cheq.RC_SD_Invoice_Number__c  = itm.BELNR;
                  cheq.RC_Description__c        = itm.LTEXT;
                  cheq.RC_Product_Info__c       = itm.formattedProductInfo;
                  cheq.RC_Type__c               = 'Invoice';

                  List<string> splittedDate = itm.ZFBDT.split('-');
                  cheq.RC_Due_Date__c = Date.newInstance(
                    integer.valueOf(splittedDate[2]),
                    integer.valueOf(splittedDate[1]),
                    integer.valueOf(splittedDate[0])
                  );
                  invList.add(cheq);
                }

                if (invList.size() > 0) {
                  List<Database.SaveResult> srInvList = Database.insert(invList, true);
                  for (Database.SaveResult srInv : srInvList) {
                    if(!srInv.isSuccess()){
                      System.debug('Invoice Insert Result : ' + srInv.isSuccess());
                      break;
                    }
                  }
                }

                // Seçili olmayan kalemleri seperated tipinde objeye kayıt at
                List<RC_Cheques__c> invSeperatedList = new List<RC_Cheques__c>();
                  for (RC_AcikKalemlerParser.Item_Z itm : dataItemListUnCheckedParsed) {
                  RC_Cheques__c cheq = new RC_Cheques__c();

                  cheq.RC_Bordro__c             = sr.getId();
                  cheq.RC_Amount__c             = decimal.valueof(itm.DMBTR);
                  cheq.RC_Invoice_Number__c     = itm.BELNR.trim()+String.ValueOf(itm.GJAHR).trim();  //unique değer elde etmek için ikisini birleştirip yazdık.
                  cheq.RC_SD_Invoice_Number__c  = itm.BELNR;
                  cheq.RC_Description__c        = itm.LTEXT;
                  cheq.RC_Product_Info__c       = itm.formattedProductInfo;
                  cheq.RC_Type__c               = 'Seperated Invoices';

                  List<string> splittedDate = itm.ZFBDT.split('-');
                  cheq.RC_Due_Date__c = Date.newInstance(
                    integer.valueOf(splittedDate[2]),
                    integer.valueOf(splittedDate[1]),
                    integer.valueOf(splittedDate[0])
                  );
                  invSeperatedList.add(cheq);
                }

                if (invSeperatedList.size() > 0) {
                  List<Database.SaveResult> srInvList = Database.insert(invSeperatedList, true);
                  for (Database.SaveResult srSeperated : srInvList) {
                    if(!srSeperated.isSuccess()){
                      System.debug('Seperated Invoice Insert Result : ' + srSeperated.isSuccess());
                      break;
                    }
                  }
                  
                }
            }

            string messageBody = resp.bordroYapResponse.IO_TKUNNR.item[0].BORDRONO + ' nolu bordro için ödeme planı oluşturulması gerekmektedir, 18.00 saatine kadar işlem yapılmaması durumunda bordro otomatik silinecektir.';
            string accountMobileNum = string.ValueOf(acc.RC_Mobile__c);
            if(accountMobileNum.length() == 10 && accountMobileNum.left(1) != '0'){
              accountMobileNum = '0' + accountMobileNum;
            }else if (accountMobileNum.length() == 13) {
              accountMobileNum = '0' + accountMobileNum.substring(3,13);
            }

            RC_NotificationSmsService.sendSMS(accountMobileNum , messageBody);

            result.message = resp.bordroYapResponse.IO_TKUNNR.item[0].BORDRONO + ' Numaralı Bordro yaratılmıştır.';
            result.success = true;
            return result;
          }
        }
      } 





    
  }
}