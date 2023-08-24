@IsTest
public class RC_IptalIadeGetOrdersParserTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"ET_RESULT\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"KUNAG\": \"0020400818\",'+
		'                \"MATNR\": \"000000000020273156\",'+
		'                \"MAKTX\": \"SMART 43FD7500 43\\\" LED TV\",'+
		'                \"PRODH\": \"02\",'+
		'                \"KONDM\": \"Y3\",'+
		'                \"ONAY_DURUM\": \"\",'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"SIP_NO\": \"0021209026\",'+
		'                \"SIP_KLM\": \"000010\",'+
		'                \"SIP_TUR\": \"ZRVZ\",'+
		'                \"SIP_GRKC\": \"0AG\",'+
		'                \"SIP_GRKC_TNM\": \"HT Revizyon B class 30gn(\",'+
		'                \"SIP_MIK\": \"1.000\",'+
		'                \"SIP_IADE_MIK\": 0,'+
		'                \"SIP_AL_MIK\": \"-1.000\",'+
		'                \"TES_NO\": \"0319408703\",'+
		'                \"TES_KALEM\": \"000001\",'+
		'                \"FAT_NO\": \"0516377605\",'+
		'                \"FAT_KLM\": \"000010\",'+
		'                \"FAT_TRH\": \"2021-03-16\",'+
		'                \"FAT_VADE\": \"2021-04-15\",'+
		'                \"FAT_TTR\": 928.22,'+
		'                \"FAT_KDV\": \"1.80\",'+
		'                \"FAT_MIK\": \"1.000\",'+
		'                \"FAT_IADE_MIK\": 0,'+
		'                \"FAT_AL_MIK\": \"1.000\",'+
		'                \"URETIM_YERI\": 2704,'+
		'                \"DEPO_YERI\": \"0067\",'+
		'                \"EMANET\": \"\",'+
		'                \"EMANET_SIP\": \"\",'+
		'                \"EMANET_SIP_KLM\": \"000000\",'+
		'                \"EMANET_SIP_MIK\": 0,'+
		'                \"EMANET_TESLIMAT\": \"\",'+
		'                \"EMANET_TESLIMAT_KLM\": \"000000\",'+
		'                \"EMANET_SEVK_MIK\": 0,'+
		'                \"EMANET_MC_TIPI\": \"\",'+
		'                \"EMANET_LOKASYON\": \"\",'+
		'                \"EMANET_UY\": \"\",'+
		'                \"PAKET_GOSTERGE\": \"\",'+
		'                \"PAKET_TANIM\": \"\"'+
		'            },'+
		'            {'+
		'                \"KUNAG\": \"0020400818\",'+
		'                \"MATNR\": \"000000000020273861\",'+
		'                \"MAKTX\": \"SATELLITE 50FD5400 50\'\' LED TV\",'+
		'                \"PRODH\": \"02\",'+
		'                \"KONDM\": \"Y3\",'+
		'                \"ONAY_DURUM\": \"\",'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"SIP_NO\": \"0021209026\",'+
		'                \"SIP_KLM\": \"000020\",'+
		'                \"SIP_TUR\": \"ZRVZ\",'+
		'                \"SIP_GRKC\": \"0AG\",'+
		'                \"SIP_GRKC_TNM\": \"HT Revizyon B class 30gn(\",'+
		'                \"SIP_MIK\": \"1.000\",'+
		'                \"SIP_IADE_MIK\": 0,'+
		'                \"SIP_AL_MIK\": \"-1.000\",'+
		'                \"TES_NO\": \"0319408703\",'+
		'                \"TES_KALEM\": \"000002\",'+
		'                \"FAT_NO\": \"0516377605\",'+
		'                \"FAT_KLM\": \"000020\",'+
		'                \"FAT_TRH\": \"2021-03-16\",'+
		'                \"FAT_VADE\": \"2021-04-15\",'+
		'                \"FAT_TTR\": 1001.44,'+
		'                \"FAT_KDV\": \"1.80\",'+
		'                \"FAT_MIK\": \"1.000\",'+
		'                \"FAT_IADE_MIK\": 0,'+
		'                \"FAT_AL_MIK\": \"1.000\",'+
		'                \"URETIM_YERI\": 2704,'+
		'                \"DEPO_YERI\": \"0067\",'+
		'                \"EMANET\": \"\",'+
		'                \"EMANET_SIP\": \"\",'+
		'                \"EMANET_SIP_KLM\": \"000000\",'+
		'                \"EMANET_SIP_MIK\": 0,'+
		'                \"EMANET_TESLIMAT\": \"\",'+
		'                \"EMANET_TESLIMAT_KLM\": \"000000\",'+
		'                \"EMANET_SEVK_MIK\": 0,'+
		'                \"EMANET_MC_TIPI\": \"\",'+
		'                \"EMANET_LOKASYON\": \"\",'+
		'                \"EMANET_UY\": \"\",'+
		'                \"PAKET_GOSTERGE\": \"\",'+
		'                \"PAKET_TANIM\": \"\"'+
		'            },'+
		'            {'+
		'                \"KUNAG\": \"0020400818\",'+
		'                \"MATNR\": \"000000000020275348\",'+
		'                \"MAKTX\": \"43F9500 43\\\" SMART TV\",'+
		'                \"PRODH\": \"02\",'+
		'                \"KONDM\": \"Y3\",'+
		'                \"ONAY_DURUM\": \"\",'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"SIP_NO\": \"0021209026\",'+
		'                \"SIP_KLM\": \"000040\",'+
		'                \"SIP_TUR\": \"ZRVZ\",'+
		'                \"SIP_GRKC\": \"0AG\",'+
		'                \"SIP_GRKC_TNM\": \"HT Revizyon B class 30gn(\",'+
		'                \"SIP_MIK\": \"1.000\",'+
		'                \"SIP_IADE_MIK\": 0,'+
		'                \"SIP_AL_MIK\": \"-1.000\",'+
		'                \"TES_NO\": \"0319408703\",'+
		'                \"TES_KALEM\": \"000003\",'+
		'                \"FAT_NO\": \"0516377605\",'+
		'                \"FAT_KLM\": \"000040\",'+
		'                \"FAT_TRH\": \"2021-03-16\",'+
		'                \"FAT_VADE\": \"2021-04-15\",'+
		'                \"FAT_TTR\": 1133.88,'+
		'                \"FAT_KDV\": \"1.80\",'+
		'                \"FAT_MIK\": \"1.000\",'+
		'                \"FAT_IADE_MIK\": 0,'+
		'                \"FAT_AL_MIK\": \"1.000\",'+
		'                \"URETIM_YERI\": 2704,'+
		'                \"DEPO_YERI\": \"0067\",'+
		'                \"EMANET\": \"\",'+
		'                \"EMANET_SIP\": \"\",'+
		'                \"EMANET_SIP_KLM\": \"000000\",'+
		'                \"EMANET_SIP_MIK\": 0,'+
		'                \"EMANET_TESLIMAT\": \"\",'+
		'                \"EMANET_TESLIMAT_KLM\": \"000000\",'+
		'                \"EMANET_SEVK_MIK\": 0,'+
		'                \"EMANET_MC_TIPI\": \"\",'+
		'                \"EMANET_LOKASYON\": \"\",'+
		'                \"EMANET_UY\": \"\",'+
		'                \"PAKET_GOSTERGE\": \"\",'+
		'                \"PAKET_TANIM\": \"\"'+
		'            },'+
		'            {'+
		'                \"KUNAG\": \"0020400818\",'+
		'                \"MATNR\": \"000000000020275682\",'+
		'                \"MAKTX\": \"55UA9600 55\\\" 4K ANDROID TV\",'+
		'                \"PRODH\": \"02\",'+
		'                \"KONDM\": \"Y3\",'+
		'                \"ONAY_DURUM\": \"\",'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"SIP_NO\": \"0021209026\",'+
		'                \"SIP_KLM\": \"000050\",'+
		'                \"SIP_TUR\": \"ZRVZ\",'+
		'                \"SIP_GRKC\": \"0AG\",'+
		'                \"SIP_GRKC_TNM\": \"HT Revizyon B class 30gn(\",'+
		'                \"SIP_MIK\": \"2.000\",'+
		'                \"SIP_IADE_MIK\": 0,'+
		'                \"SIP_AL_MIK\": \"-2.000\",'+
		'                \"TES_NO\": \"0319408703\",'+
		'                \"TES_KALEM\": \"000004\",'+
		'                \"FAT_NO\": \"0516377605\",'+
		'                \"FAT_KLM\": \"000050\",'+
		'                \"FAT_TRH\": \"2021-03-16\",'+
		'                \"FAT_VADE\": \"2021-04-15\",'+
		'                \"FAT_TTR\": 3571.84,'+
		'                \"FAT_KDV\": \"1.80\",'+
		'                \"FAT_MIK\": \"2.000\",'+
		'                \"FAT_IADE_MIK\": 0,'+
		'                \"FAT_AL_MIK\": \"2.000\",'+
		'                \"URETIM_YERI\": 2704,'+
		'                \"DEPO_YERI\": \"0067\",'+
		'                \"EMANET\": \"\",'+
		'                \"EMANET_SIP\": \"\",'+
		'                \"EMANET_SIP_KLM\": \"000000\",'+
		'                \"EMANET_SIP_MIK\": 0,'+
		'                \"EMANET_TESLIMAT\": \"\",'+
		'                \"EMANET_TESLIMAT_KLM\": \"000000\",'+
		'                \"EMANET_SEVK_MIK\": 0,'+
		'                \"EMANET_MC_TIPI\": \"\",'+
		'                \"EMANET_LOKASYON\": \"\",'+
		'                \"EMANET_UY\": \"\",'+
		'                \"PAKET_GOSTERGE\": \"\",'+
		'                \"PAKET_TANIM\": \"\"'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		RC_IptalIadeGetOrdersParser obj = RC_IptalIadeGetOrdersParser.parse(json);
		System.assert(obj != null);
	}
}