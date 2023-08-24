public with sharing class RC_AllReportController {
    public RC_AllReportController() {

    }

    @AuraEnabled(cacheable = true)
    public static List<ReportMainWrapper> GetAllReports(){
        List<ReportMainWrapper> allReportList = new List<ReportMainWrapper>();

        Map<String, List<ReportDetailWrapper>> allReportMap = new Map<String, List<ReportDetailWrapper>>();
        for(Report r : [SELECT Id, DeveloperName, FolderName, Name, Description, CreatedBy.Name, CreatedDate FROM Report]){
            if(allReportMap.containsKey(r.FolderName)){
                List<ReportDetailWrapper> relatedReportList = allReportMap.get(r.FolderName);

                ReportDetailWrapper rdw = new ReportDetailWrapper(
                    r.Name,
                    r.Description,
                    prepareReportLink(r.Id),
                    r.CreatedBy.Name,
                    r.CreatedDate
                );

                relatedReportList.add(rdw);

                allReportMap.put(r.FolderName, relatedReportList);
            }
            else{
                List<ReportDetailWrapper> relatedReportList = new List<ReportDetailWrapper>();

                ReportDetailWrapper rdw = new ReportDetailWrapper(
                    r.Name,
                    r.Description,
                    prepareReportLink(r.Id),
                    r.CreatedBy.Name,
                    r.CreatedDate
                );

                relatedReportList.add(rdw);

                allReportMap.put(r.FolderName, relatedReportList);
            }
        }

        for(Folder f : [SELECT Id, Name, DeveloperName, AccessType, IsReadonly, Type, CreatedBy.Name, LastModifiedBy.Name, CreatedDate, LastModifiedDate FROM Folder where Type = 'Report' and DeveloperName != '' AND Name IN :allReportMap.keySet() ORDER BY Name]){
            ReportMainWrapper rmw = new ReportMainWrapper(
                f.Id,
                f.CreatedBy.Name,
                f.CreatedDate,
                f.Name,
                f.LastModifiedBy.Name,
                f.LastModifiedDate,
                allReportMap.get(f.Name)
            );

            allReportList.add(rmw);
        }

        return allReportList;
    }

    @AuraEnabled
    public static String saveFolder(String fl, String fn){
        try {
            Map<String, String> requestBodyMap = new Map<String, String>();
            requestBodyMap.put('label', fl);
            requestBodyMap.put('name', fn);
            requestBodyMap.put('type', 'report');

            HttpRequest req = new HttpRequest();
            Http http = new Http();

            req.setMethod('POST');
            req.setEndpoint(Url.getSalesforceBaseUrl().toExternalForm() + '/services/data/v51.0/folders/');
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(requestBodyMap));
			System.debug(JSON.serialize(requestBodyMap));
            HttpResponse response = http.send(req);
            
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                return 'Folder başarılı bir şekilde yaratılmıştır.';
            }
            else{
                throw new AuraHandledException('Folder yaratılırken bir hata oluştu.');
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String prepareReportLink(String reportId){
        String preparedLink = '';

        preparedLink = String.format('{0}/{1}/{2}/{3}', new List<Object>{URL.getSalesforceBaseUrl().toExternalForm(), 'lightning/r/Report', reportId, 'view'});

        return preparedLink;
    }
    
    public class ReportMainWrapper{
        @AuraEnabled
        public String id {get; set;}
        @AuraEnabled
        public String folderCreator {get; set;}
        @AuraEnabled
        public Datetime folderCreationDate {get; set;}
        @AuraEnabled
        public String folderName {get; set;}
        @AuraEnabled
        public String folderLastChanger {get; set;}
        @AuraEnabled
        public Datetime folderLastModificationDate {get; set;}
        @AuraEnabled
        public List<ReportDetailWrapper> relatedReportList {get; set;}

        public ReportMainWrapper(){}
        public ReportMainWrapper(String dataId, String fc, Datetime fcd, String fn, String flc, Datetime flmd, List<ReportDetailWrapper> rrl){
            this.id = dataId;
            this.folderCreator = fc;
            this.folderCreationDate = fcd;
            this.folderName = fn;
            this.folderLastChanger = flc;
            this.folderLastModificationDate = flmd;
            this.relatedReportList = rrl;
        }
    }

    public class ReportDetailWrapper{
        @AuraEnabled
        public String reportName {get; set;}
        @AuraEnabled
        public String reportDescription {get; set;}
        @AuraEnabled
        public String reportLink {get; set;}
        @AuraEnabled
        public String reportCreator {get; set;}
        @AuraEnabled
        public Datetime reportCreationDate {get; set;}

        public ReportDetailWrapper(){}
        public ReportDetailWrapper(String rn, String rd, String rl, String rc, Datetime rcd){
            this.reportName = rn;
            this.reportDescription = rd;
            this.reportLink = rl;
            this.reportCreator = rc;
            this.reportCreationDate = rcd;
        }
    }
}