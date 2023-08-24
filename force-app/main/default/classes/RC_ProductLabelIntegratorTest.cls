@isTest
public class RC_ProductLabelIntegratorTest {
    @isTest
    public static void UnitTest(){
        
        RC_ProductLabelIntegrator.requestModel r = new RC_ProductLabelIntegrator.requestModel();
        List<RC_ProductLabelIntegrator.LabelDetail> ldList = new List<RC_ProductLabelIntegrator.LabelDetail>();
        
        
        RC_ProductLabelIntegrator.LabelDetail ld = new RC_ProductLabelIntegrator.LabelDetail();
        ld.LabelName='Title';
        ld.LabelValue='BZE-XL3303 XEH A+ NF';
        ld.DisplayName='Baslik';
        ld.MaxLength=33;
        ld.IsMultiLine=false;
        ldList.Add(ld);
        
        
        ld = new RC_ProductLabelIntegrator.LabelDetail();
        ld.LabelName='factory';
        ld.LabelValue='Türkiye';
        ld.DisplayName='Üretim Yeri';
        ld.MaxLength=33;
        ld.IsMultiLine=false;
        ldList.Add(ld);
        
        ld = new RC_ProductLabelIntegrator.LabelDetail();
        ld.LabelName='Description';
        ld.LabelValue='A';
        ld.DisplayName='Açiklama';
        ld.MaxLength=385;
        ld.IsMultiLine=true;
        ldList.Add(ld);
        
        
        ld = new RC_ProductLabelIntegrator.LabelDetail();
        ld.LabelName='Amount';
        ld.LabelValue='2299.00';
        ld.DisplayName='Tutar';
        ld.MaxLength=8;
        ld.IsMultiLine=false;
        ldList.Add(ld);
        
        
        ld = new RC_ProductLabelIntegrator.LabelDetail();
        ld.LabelName='amountchangeddate';
        ld.LabelValue='28.09.2018';
        ld.DisplayName='Fiyat Degisiklik Tarihi';
        ld.MaxLength=10;
        ld.IsMultiLine=false;
        ldList.Add(ld);
        
        
        r.LabelName = 'Etiket Buzdolabi Dikey Standard.pdf';
        r.labelDetail = ldList;
        
        Test.startTest();
        
        RC_ProductLabelIntegrator.getCreatePDF(r,true);
        RC_ProductLabelIntegrator.getCreatePDF(r,false);
        
        Test.stopTest();
    }
}