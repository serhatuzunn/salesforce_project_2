public class TcmbCurrencyReader implements Database.AllowsCallouts{
    
    @Future(Callout=true)
    public static void parseResponseDom(){
        
        system.debug('Currency Reader');
        
        try{
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint('callout:TCMB/kurlar/today.xml');
            //req.setEndpoint('https://185.98.252.10/kurlar/today.xml');
            req.setMethod('GET');
            
            Dom.Document doc;
            Dom.XMLNode curr;
            
            if(test.isRunningTest()){
                string expectedResult = '<?xml version="1.0" encoding="UTF-8"?>' +
                    '<?xml-stylesheet type="text/xsl" href="isokur.xsl"?>' +
                    '<Tarih_Date Tarih="18.08.2017" Date="08/18/2017"  Bulten_No="2017/161" >' +
                    '<Currency CrossOrder="0" Kod="USD" CurrencyCode="USD">' +
                    '<Unit>1</Unit>' +
                    '<Isim>ABD DOLARI</Isim>' +
                    '<CurrencyName>US DOLLAR</CurrencyName>' +
                    '<ForexBuying>3.5213</ForexBuying>' +
                    '<ForexSelling>3.5276</ForexSelling>' +
                    '<BanknoteBuying>3.5188</BanknoteBuying>' +
                    '<BanknoteSelling>3.5329</BanknoteSelling>' +
                    '<CrossRateUSD/>' +
                    '<CrossRateOther/>' +		
                    '</Currency>' +
                    '<Currency CrossOrder="9" Kod="EUR" CurrencyCode="EUR">' +
                    '<Unit>1</Unit>' +
                    '<Isim>EURO</Isim>' +
                    '<CurrencyName>EURO</CurrencyName>' +
                    '<ForexBuying>4.1333</ForexBuying>' +
                    '<ForexSelling>4.1408</ForexSelling>' +
                    '<BanknoteBuying>4.1304</BanknoteBuying>' +
                    '<BanknoteSelling>4.1470</BanknoteSelling>' +
                    '<CrossRateUSD/>' +
                    '<CrossRateOther>1.1738</CrossRateOther>' +
                    '</Currency>' +
                    '</Tarih_Date>';
                
                doc = new Dom.Document();
                doc.load(expectedResult);
                
            }else{    
                HttpResponse res = h.send(req);
                doc = res.getBodyDocument();
            }
            
            curr = doc.getRootElement();
            String tarih = curr.getAttribute('Date','');
            tarih = tarih.subString(3,5) + '/' + tarih.subString(0,2) + '/' + tarih.subString(6,10);
            String bulten_no = curr.getAttribute('Bulten_No','');
            
           
            String nodeName;
            String nodeText;
            String kod;             
            String reqBody;

            
            string metaCODE = '';
            decimal metaRATE = 0.0;
            Date metaDATE = system.now().date();
            
            //aktif kurları almak için kullanılır
            List<CurrencyType> currencyTypes = [SELECT ISOCode,IsCorporate , ConversionRate FROM CurrencyType WHERE IsActive=TRUE AND IsCorporate =false];
			
            List<DatedConversionRate> conversionDates = [SELECT Id, IsoCode, StartDate, NextStartDate, ConversionRate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp 
                                                         FROM DatedConversionRate];
            
            List<string> currentCurrencyIDs = new List<string>();
            for(DatedConversionRate x : conversionDates){
                if(x.StartDate == metaDATE){
                    currentCurrencyIDs.add(x.id);
                }
            }

            for(Dom.XMLNode child : curr.getChildElements()) {
                nodeName = child.getName();
                nodeText = child.getText();
                
                if(nodeName == 'Currency'){
                    kod = child.getAttribute('Kod','');                      
                    for(CurrencyType currencyType : currencyTypes){
                        if(currencyType.ISOCode == kod){
                            metaCODE = kod;  
                            for(Dom.XMLNode node1 : child.getChildElements()) {
                                nodeName = node1.getName();
                                nodeText = node1.getText();
                                if(nodeName == 'ForexBuying'){
                                    metaRATE = 1/decimal.valueOf(nodeText);
                                    break;
                                }
                            }      
                            system.debug('metaCODE :' + metaCODE + ' metaRATE : ' + metaRATE.setScale(4) + ' metaDATE : ' + metaDATE);
							saveCurrency(metaCODE,metaRATE,metaDATE);
                            break;
                        }
                    }   
                }                
            }
            
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    public static boolean saveCurrency(string code , decimal rate,date curDate){
        boolean retVal = true;
        
        system.debug('SessionId : ' + UserInfo.getSessionId());
        
        DatedConversionRate dcR = new DatedConversionRate ();
        dcR.IsoCode = code;
        dcR.ConversionRate = rate.setScale(6);
        dcR.StartDate = curDate;
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v43.0/sobjects/DatedConversionRate/');
        req.setBody(JSON.serialize(dcR));
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        system.debug('req :' + req.getBody());
        HttpResponse res = h.send(req);
        system.debug('res :' + res.getBody());
        
        if(res.getStatusCode() == 201){
            retVal = true;
        }else{
            retVal = false;
        }
        
        return retVal;
    }
    
}