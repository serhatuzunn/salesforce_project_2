@isTest
public class RC_BordroReportIntegrator_Test {
@isTest
    public static void UnitTest(){
        RC_BordroReportIntegrator.item itm  = new RC_BordroReportIntegrator.item();
        itm.item = new List<RC_BordroReportController.item>();
        
		RC_BordroReportController.cancelRequestWrapper cancelReq = new RC_BordroReportController.cancelRequestWrapper();
    	RC_BordroReportController.approveRequestWrapper appReq = new RC_BordroReportController.approveRequestWrapper();
        RC_BordroReportController.DTSApproveRequestWrapper dtsAppReq = new RC_BordroReportController.DTSApproveRequestWrapper();
        
        RC_BordroReportIntegrator.bordroCancelInt(cancelReq);
        RC_BordroReportIntegrator.bordroApproveInt(appReq);
        RC_BordroReportIntegrator.bordroDTSApproveInt(dtsAppReq);
    }
}