public class RC_SelectPricebookController {
    
    public class responseModel{
        @AuraEnabled
        public Boolean success {get;set;}
        @AuraEnabled
        public Boolean hasItem {get;set;}
        @AuraEnabled
        public String msg {get;set;}

    }


    @AuraEnabled
    public static responseModel updateOPP(string selectedPricebookID,string oppID){
        responseModel response = new responseModel();
        response.hasItem = false;
        List<OpportunityLineItem> oppLineItemList = [SELECT id FROM OpportunityLineItem WHERE OpportunityId =: oppID];

        if(oppLineItemList.size() > 0){
            response.success = false;
            response.hasItem = true;
            return response;
        }

        List<Opportunity> oppList = [SELECT id FROM Opportunity WHERE Id =: oppID];
        Opportunity opp = new Opportunity();
        if (oppList.size() > 0 ) {
            opp =  oppList.get(0);
            opp.Pricebook2Id = selectedPricebookID;
            Database.SaveResult sr = Database.Update(opp);
            if (sr.isSuccess()) {
                response.success = true;
                return response;
            }else {
                response.success = false;
                return response;
            }
        }else {
                response.success = false;
                return response;
        }
    }

    @AuraEnabled
    public static responseModel updateOPPWithWithDeleting(string selectedPricebookID,string oppID){
        responseModel response = new responseModel();
        response.success = true;
        response.msg = '';

        List<OpportunityLineItem> oppLineItemList = [SELECT id FROM OpportunityLineItem WHERE OpportunityId =: oppID];
        if(oppLineItemList.size() > 0){
           List<Database.DeleteResult> drList = Database.delete(oppLineItemList,true);

           for (Database.DeleteResult dr : drList) {
               if (dr.isSuccess()) {
                   continue;
               }else {
                    response.success = false;
                    response.msg = 'Firsat kalemleri silinirken hata olustu !!';
                    return response;
               }
           }
        }

        List<Opportunity> oppList = [SELECT id FROM Opportunity WHERE Id =: oppID];
        Opportunity opp = new Opportunity();
        if (oppList.size() > 0 ) {
            opp =  oppList.get(0);
            opp.Pricebook2Id = selectedPricebookID;
            Database.SaveResult sr = Database.Update(opp);
            if (sr.isSuccess()) {
                response.success = true;
                return response;
            }else {
                response.success = false;
                response.msg     = 'Fiyat listesi guncellenirken hata olustu !!';
                return response;
            }
        }else {
                response.success = false;
                response.msg     = 'Firsat bulunamadi !!';
                return response;
        }

    }

}