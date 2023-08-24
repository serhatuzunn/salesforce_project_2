public class RC_EmanetSiparisComponentController {
    
    public class EmanetSiparisWrapper{
        @AuraEnabled
        public List<EmanetSiparisTable> EmanetSiparisTableList {get;set;}
    }
    
    public class EmanetSiparisTable{
        @AuraEnabled
        public String UrunKodu {get;set;}
        @AuraEnabled
        public String UrunAdi {get;set;}
        @AuraEnabled
        public Integer EmanetteStok {get;set;}
        @AuraEnabled
        public Integer EmanettenStok {get;set;}  
    }
    
    public class EmanetSiparis{
        @AuraEnabled
        public String UrunKodu {get;set;}
        @AuraEnabled
        public String UrunAdi {get;set;}
        @AuraEnabled
        public Integer SiparisteBekleyen {get;set;}
        @AuraEnabled
        public Integer TeslimattaBekleyen {get;set;}
        @AuraEnabled
        public Integer Kulab {get;set;}
    }
    
    
    @AuraEnabled
    public static EmanetSiparisWrapper buttonClick(string productCode){ 
        system.debug('productCode : ' + productCode);
        
        
        String userId = UserInfo.getUserId();
        system.debug('userId : ' + userId);
        
        String accountId = [SELECT Id, AccountId FROM User WHERE Id =: userId LIMIT 1].AccountId;
        system.debug('accountId : ' + accountId);
        
        if(String.isNotBlank(accountId)){
            String sapId = [SELECT RC_SAP_ID__c FROM Account WHERE Id =: accountId LIMIT 1].RC_SAP_ID__c;
            system.debug('sapId : ' + sapId);
            
            if(String.isNotBlank(sapId)){
                //SiparisBekleyen API
                RC_SiparisBekleyenIntegrator.Item siparisBekleyenItem = new RC_SiparisBekleyenIntegrator.Item();
                siparisBekleyenItem.BAYINO = sapId;
                siparisBekleyenItem.URUNKODU = productCode;
                
                RC_SiparisBekleyenIntegrator.SIPARISTEBEKLEYEN siparisBekleyen = new RC_SiparisBekleyenIntegrator.SIPARISTEBEKLEYEN();
                siparisBekleyen.item = new List<RC_SiparisBekleyenIntegrator.Item>();
                
                siparisBekleyen.item.add(siparisBekleyenItem);
                
                RC_SiparisBekleyenIntegrator.RequestModel siparisBekleyenReq = new RC_SiparisBekleyenIntegrator.RequestModel();
                siparisBekleyenReq.BAYINO = sapId;
                siparisBekleyenReq.SIPARISTEBEKLEYEN = siparisBekleyen;
                
                RC_SiparisBekleyenIntegratorParser siparisBekleyenParser = RC_SiparisBekleyenIntegrator.getSiparisBekleyen(siparisBekleyenReq);
                system.debug('siparisBekleyenParser : ' + siparisBekleyenParser);
                
                //TeslimatBekleyen API
                RC_TeslimatBekleyenIntegrator.Item teslimatBekleyenItem = new RC_TeslimatBekleyenIntegrator.Item();
                teslimatBekleyenItem.BAYINO = sapId;
                teslimatBekleyenItem.URUNKODU = productCode;
                
                RC_TeslimatBekleyenIntegrator.TESLIMATTABEKLEYEN teslimatBekleyen = new RC_TeslimatBekleyenIntegrator.TESLIMATTABEKLEYEN();
                teslimatBekleyen.item = new List<RC_TeslimatBekleyenIntegrator.Item>();
                
                teslimatBekleyen.item.add(teslimatBekleyenItem);
                
                RC_TeslimatBekleyenIntegrator.RequestModel teslimatBekleyenReq = new RC_TeslimatBekleyenIntegrator.RequestModel();
                teslimatBekleyenReq.BAYINO = sapId;
                teslimatBekleyenReq.TESLIMATTABEKLEYEN = teslimatBekleyen;
                
                RC_TeslimatBekleyenIntegratorParser teslimatBekleyenParser = RC_TeslimatBekleyenIntegrator.getTeslimatBekleyen(teslimatBekleyenReq);
                system.debug('teslimatBekleyenParser : ' + teslimatBekleyenParser);
                
                //EmanetStok API
                RC_EmanetStokListIntegrator.Item item = new RC_EmanetStokListIntegrator.Item();
                item.MATNR = productCode;
                
                RC_EmanetStokListIntegrator.IT_MATNR itMatnr = new RC_EmanetStokListIntegrator.IT_MATNR();
                itMatnr.item = new List<RC_EmanetStokListIntegrator.Item>();
                itMatnr.item.add(item);
                
                RC_EmanetStokListIntegrator.Item_Z itemZ1 = new RC_EmanetStokListIntegrator.Item_Z();
                itemZ1.WERKS = '9205';
                
                RC_EmanetStokListIntegrator.Item_Z itemZ2 = new RC_EmanetStokListIntegrator.Item_Z();
                itemZ2.WERKS = 'D230';
                
                RC_EmanetStokListIntegrator.IT_WERKS itWerks = new RC_EmanetStokListIntegrator.IT_WERKS();
                itWerks.item = new List<RC_EmanetStokListIntegrator.Item_Z>();
                itWerks.item.add(itemZ1);
                itWerks.item.add(itemZ2);
                
                RC_EmanetStokListIntegrator.RequestModel req = new RC_EmanetStokListIntegrator.RequestModel();
                req.IT_MATNR = itMatnr;
                req.IT_WERKS = itWerks;
                req.IV_KUNNR = sapId;
                req.IV_SOBKZ = 'W';
                req.IV_YALNIZCA_STOKLU = 'X';
                
                RC_EmanetStokListIntegratorParser emanetStokParser = RC_EmanetStokListIntegrator.getEmanetStokList(req);
                system.debug('emanetStokParser : ' + emanetStokParser);
                
                
                //Hesaplama
                Map<String, EmanetSiparis> emanetSiparisMap = new Map<String, EmanetSiparis>();
                
                for(RC_SiparisBekleyenIntegratorParser.Item siparisItem : siparisBekleyenParser.SIPARISTEBEKLEYEN.item){
                    system.debug('siparisItem : ' + siparisItem.URUNTANIM);
                    
                    if(siparisItem.VSART == '08'){
                        EmanetSiparis emanetSipraisItem = emanetSiparisMap.get(siparisItem.URUNKODU);
                        if(emanetSipraisItem != null){
                            if(siparisItem.SIPARISTEBEKLEYEN.isNumeric()){
                                emanetSipraisItem.SiparisteBekleyen = Integer.valueOf(siparisItem.SIPARISTEBEKLEYEN);
                                emanetSiparisMap.put(siparisItem.URUNKODU, emanetSipraisItem);
                            }
                        }
                        else{
                            EmanetSiparis newEmanetSiparisItem = new EmanetSiparis();
                            newEmanetSiparisItem.UrunKodu = siparisItem.URUNKODU;
                            newEmanetSiparisItem.UrunAdi = siparisItem.URUNTANIM;
                            if(String.isNotEmpty(siparisItem.SIPARISTEBEKLEYEN)){
                                newEmanetSiparisItem.SiparisteBekleyen =  Integer.valueOf(siparisItem.SIPARISTEBEKLEYEN);
                            }
                            else{
                                newEmanetSiparisItem.SiparisteBekleyen = 0;
                            }
                            
                            emanetSiparisMap.put(siparisItem.URUNKODU, newEmanetSiparisItem);
                            
                        }
                    }
                }
                
                for(RC_TeslimatBekleyenIntegratorParser.Item teslimatItem : teslimatBekleyenParser.TESLIMATTABEKLEYEN.item){
                    system.debug('teslimatItem : ' + teslimatItem.URUNTANIM);
                    
                    if(teslimatItem.VSART == '08'){
                        EmanetSiparis emanetTeslimatItem = emanetSiparisMap.get(teslimatItem.URUNKODU);
                        if(emanetTeslimatItem != null){
                            if(teslimatItem.TESLIMATTABEKLEYEN.isNumeric()){
                                emanetTeslimatItem.TeslimattaBekleyen = Integer.valueOf(teslimatItem.TESLIMATTABEKLEYEN);
                                emanetSiparisMap.put(teslimatItem.URUNKODU, emanetTeslimatItem);
                            }
                        }
                        else{
                            EmanetSiparis newEmanetTeslimatItem = new EmanetSiparis();
                            newEmanetTeslimatItem.UrunKodu = teslimatItem.URUNKODU;
                            newEmanetTeslimatItem.UrunAdi = teslimatItem.URUNTANIM;
                            if(String.isNotEmpty(teslimatItem.TESLIMATTABEKLEYEN)){
                                newEmanetTeslimatItem.TeslimattaBekleyen =  Integer.valueOf(teslimatItem.TESLIMATTABEKLEYEN);
                            }
                            else{
                                newEmanetTeslimatItem.TeslimattaBekleyen = 0;
                            }
                            
                            emanetSiparisMap.put(teslimatItem.URUNKODU, newEmanetTeslimatItem);
                            
                        }
                    }
                }
                
                for(RC_EmanetStokListIntegratorParser.Item emanetItem : emanetStokParser.ET_OUTPUT.item){
                    system.debug('emanetItem : ' + emanetItem.MAKTX);
                    
                    EmanetSiparis emanetEmanetItem = emanetSiparisMap.get(emanetItem.MATNR);
                    if(emanetEmanetItem != null){
                        if(emanetItem.KULAB.isNumeric()){
                            emanetEmanetItem.Kulab = Integer.valueOf(emanetItem.KULAB);
                            emanetSiparisMap.put(emanetEmanetItem.UrunKodu, emanetEmanetItem);
                        }
                    }
                    else{
                        EmanetSiparis newEmanetItem = new EmanetSiparis();
                        newEmanetItem.UrunKodu = emanetItem.MATNR;
                        newEmanetItem.UrunAdi = emanetItem.MAKTX;
                        if(String.isNotEmpty(emanetItem.KULAB)){
                            newEmanetItem.Kulab =  Integer.valueOf(emanetItem.KULAB);
                        }
                        else{
                            newEmanetItem.Kulab = 0;
                        }
                        
                        emanetSiparisMap.put(emanetItem.MATNR, newEmanetItem); 
                    }
                }
                
                system.debug('emanetSiparisMap : ' + emanetSiparisMap);
                
                List<EmanetSiparis> emanetSiparisList = new List<EmanetSiparis>();
                emanetSiparisList = emanetSiparisMap.values();
                
                system.debug('emanetSiparisList : ' + emanetSiparisList);
                
                List<EmanetSiparisTable> emanetSiparisTableList = new List<EmanetSiparisTable>(); 
                
                for(EmanetSiparis emanetSiparis : emanetSiparisList){
                    
                    system.debug('emanetSiparis : ' + emanetSiparis);
                    
                    EmanetSiparisTable emanetSiparisTable = new EmanetSiparisTable();
                    emanetSiparisTable.UrunKodu = emanetSiparis.UrunKodu;
                    emanetSiparisTable.UrunAdi = emanetSiparis.UrunAdi;
                    
                    if(string.valueOf(emanetSiparis.SiparisteBekleyen)==null){
                        emanetSiparis.SiparisteBekleyen = 0;
                    }
                    if(string.valueOf(emanetSiparis.TeslimattaBekleyen)==null){
                        emanetSiparis.TeslimattaBekleyen = 0;
                    }
                    
                    if(string.valueOf(emanetSiparis.Kulab)==null){
                        emanetSiparis.Kulab = 0;
                    }
                    
                    system.debug('emanetSiparis.SiparisteBekleyen : ' + emanetSiparis.SiparisteBekleyen);
                    system.debug('emanetSiparis.TeslimattaBekleyen : ' + emanetSiparis.TeslimattaBekleyen);
                    system.debug('emanetSiparis.Kulab : ' + emanetSiparis.Kulab);
                    
                    
                    emanetSiparisTable.EmanetteStok = emanetSiparis.SiparisteBekleyen + emanetSiparis.TeslimattaBekleyen;
                    emanetSiparisTable.EmanettenStok = emanetSiparis.Kulab;
                    
                    emanetSiparisTableList.add(emanetSiparisTable);
                }
                
                EmanetSiparisWrapper emanetSiparisWrapper = new EmanetSiparisWrapper();
                emanetSiparisWrapper.EmanetSiparisTableList = emanetSiparisTableList;
                
                system.debug('emanetSiparisWrapper : ' + emanetSiparisWrapper);
                
                return emanetSiparisWrapper;
            }
        }
        
        return null;
        
    }
    
    
}