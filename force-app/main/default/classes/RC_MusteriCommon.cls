public class RC_MusteriCommon {
   @future(callout=true)
     public static void getMusteri(String reqString){
          RC_MusteriIntegrator.RequestModel req = (RC_MusteriIntegrator.RequestModel)Json.deserialize(reqString, RC_MusteriIntegrator.RequestModel.class);
         
         RC_MusteriIntegrator.getMusteri(req);
     }
}