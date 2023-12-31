//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class RC_IptalIadeOpenRetOrderParserTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"ET_RESULT\": {'+
		'        \"item\": ['+
		'            {'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"MUSTERI\": \"0020400452\",'+
		'                \"SAS_NO\": \"AEF2021000000022\",'+
		'                \"SIP_NO\": \"0090131373\",'+
		'                \"SIP_KLM\": \"000010\",'+
		'                \"SIP_UST_KLM\": \"000000\",'+
		'                \"SIP_TUR\": \"V14\",'+
		'                \"SIP_GRKC\": \"VD1\",'+
		'                \"SIP_KULLANIM\": \"09\",'+
		'                \"ODEME_KSL\": \"VPNK\",'+
		'                \"VALOR\": \"0000-00-00\",'+
		'                \"EK_VALOR\": \"00\",'+
		'                \"PARA_BRM\": \"TRY\",'+
		'                \"SIP_YRT_TRH\": \"2021-02-09\",'+
		'                \"SIP_BLG_TRH\": \"2021-02-09\",'+
		'                \"SIP_IST_TSL\": \"2021-02-09\",'+
		'                \"TESLIM_ALAN\": \"0020400452\",'+
		'                \"TSLM_ALAN_UNVAN\": \"AVCILAR TİCARET TURİZM İNŞAAT VE SANAYİ LİMİTED ŞİRKETİ.\",'+
		'                \"TSLM_ALAN_ADRES\": \"CUMHURİYET CAD.NO.44/B .\",'+
		'                \"TSLM_ALAN_SEMT\": \"CUMHURİYET MAH.\",'+
		'                \"TSLM_ALAN_ILCE\": \"YATAĞAN\",'+
		'                \"TSLM_ALAN_IL\": \"048\",'+
		'                \"TSLM_ALAN_TEL\": 2525725784,'+
		'                \"TSLM_ALAN_EMAIL\": \"avcilar.ticaret.beyazesya@hotmail.com\",'+
		'                \"REF_SIP_NO\": \"0021178441\",'+
		'                \"REF_SIP_KLM\": \"000020\",'+
		'                \"MALZEME\": \"000000000020263180\",'+
		'                \"MALZEME_TANIM\": \"CMI 97102 WIFI\",'+
		'                \"SIP_MIK\": \"1.000\",'+
		'                \"SIP_IADE_FAT_MIK\": 0,'+
		'                \"SIP_NET_DEGER\": 2297.46,'+
		'                \"SIP_KDV_DEGER\": 413.54,'+
		'                \"SIP_TPL_DEGER\": \"2711.00\",'+
		'                \"SIP_UY\": 2204,'+
		'                \"SIP_DEPO\": \"0001\",'+
		'                \"MLZ_GRUP\": 23,'+
		'                \"MLZ_GRUP_TNM\": \"Solo Çamaşır Makines\",'+
		'                \"MLZ_GRUP1\": \"\",'+
		'                \"MLZ_GRUP1_TNM\": \"\",'+
		'                \"MLZ_GRUP2\": 17,'+
		'                \"MLZ_GRUP2_TNM\": \"Beyaz Eşya\",'+
		'                \"MLZ_GRUP3\": \"\",'+
		'                \"MLZ_GRUP3_TNM\": \"\",'+
		'                \"MLZ_GRUP4\": \"\",'+
		'                \"MLZ_GRUP4_TNM\": \"\",'+
		'                \"MLZ_GRUP5\": \"\",'+
		'                \"MLZ_GRUP5_TNM\": \"\",'+
		'                \"URUN_HYR\": \"010201080201010304\",'+
		'                \"URUN_HYR_TNM\": \"A+++ Enerji\",'+
		'                \"URUN_HYR_KDM1\": \"01\",'+
		'                \"URUN_HYR_KDM1_TNM\": \"Beyaz Eşya\",'+
		'                \"URUN_HYR_KDM2\": \"0102\",'+
		'                \"URUN_HYR_KDM2_TNM\": \"Yıkayıcı Grubu\",'+
		'                \"URUN_HYR_KDM3\": \"010201\",'+
		'                \"URUN_HYR_KDM3_TNM\": \"Solo Çamaşır Makinesi\",'+
		'                \"URUN_HYR_KDM4\": \"01020108\",'+
		'                \"URUN_HYR_KDM4_TNM\": \"9 kg\",'+
		'                \"URUN_HYR_KDM5\": \"0102010802\",'+
		'                \"URUN_HYR_KDM5_TNM\": \"1001-1200 devir\",'+
		'                \"URUN_HYR_KDM6\": \"010201080201\",'+
		'                \"URUN_HYR_KDM6_TNM\": \"OÇM\",'+
		'                \"URUN_HYR_KDM7\": \"01020108020101\",'+
		'                \"URUN_HYR_KDM7_TNM\": \"Beyaz\"'+
		'            },'+
		'            {'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"MUSTERI\": \"0020400452\",'+
		'                \"SAS_NO\": \"AEF2021000000035\",'+
		'                \"SIP_NO\": \"0090131375\",'+
		'                \"SIP_KLM\": \"000010\",'+
		'                \"SIP_UST_KLM\": \"000000\",'+
		'                \"SIP_TUR\": \"V14\",'+
		'                \"SIP_GRKC\": \"VT8\",'+
		'                \"SIP_KULLANIM\": \"09\",'+
		'                \"ODEME_KSL\": \"VPNK\",'+
		'                \"VALOR\": \"0000-00-00\",'+
		'                \"EK_VALOR\": \"00\",'+
		'                \"PARA_BRM\": \"TRY\",'+
		'                \"SIP_YRT_TRH\": \"2021-02-09\",'+
		'                \"SIP_BLG_TRH\": \"2021-02-09\",'+
		'                \"SIP_IST_TSL\": \"2021-02-09\",'+
		'                \"TESLIM_ALAN\": \"0020400452\",'+
		'                \"TSLM_ALAN_UNVAN\": \"AVCILAR TİCARET TURİZM İNŞAAT VE SANAYİ LİMİTED ŞİRKETİ.\",'+
		'                \"TSLM_ALAN_ADRES\": \"CUMHURİYET CAD.NO.44/B .\",'+
		'                \"TSLM_ALAN_SEMT\": \"CUMHURİYET MAH.\",'+
		'                \"TSLM_ALAN_ILCE\": \"YATAĞAN\",'+
		'                \"TSLM_ALAN_IL\": \"048\",'+
		'                \"TSLM_ALAN_TEL\": 2525725784,'+
		'                \"TSLM_ALAN_EMAIL\": \"avcilar.ticaret.beyazesya@hotmail.com\",'+
		'                \"REF_SIP_NO\": \"0021187015\",'+
		'                \"REF_SIP_KLM\": \"000010\",'+
		'                \"MALZEME\": \"000000000020275259\",'+
		'                \"MALZEME_TANIM\": \"55U9500 55\\\" 4K SMART TV\",'+
		'                \"SIP_MIK\": \"5.000\",'+
		'                \"SIP_IADE_FAT_MIK\": 0,'+
		'                \"SIP_NET_DEGER\": \"20089.00\",'+
		'                \"SIP_KDV_DEGER\": 3616.02,'+
		'                \"SIP_TPL_DEGER\": 23705.02,'+
		'                \"SIP_UY\": 2204,'+
		'                \"SIP_DEPO\": \"0001\",'+
		'                \"MLZ_GRUP\": 3,'+
		'                \"MLZ_GRUP_TNM\": \"LCD TV\",'+
		'                \"MLZ_GRUP1\": 22,'+
		'                \"MLZ_GRUP1_TNM\": \"Elektronik Eşya\",'+
		'                \"MLZ_GRUP2\": 16,'+
		'                \"MLZ_GRUP2_TNM\": \"Elektronik\",'+
		'                \"MLZ_GRUP3\": \"\",'+
		'                \"MLZ_GRUP3_TNM\": \"\",'+
		'                \"MLZ_GRUP4\": \"01\",'+
		'                \"MLZ_GRUP4_TNM\": \"Kategori 1 (Elekt.)\",'+
		'                \"MLZ_GRUP5\": \"\",'+
		'                \"MLZ_GRUP5_TNM\": \"\",'+
		'                \"URUN_HYR\": \"02010423050310\",'+
		'                \"URUN_HYR_TNM\": \"9 Serisi\",'+
		'                \"URUN_HYR_KDM1\": \"02\",'+
		'                \"URUN_HYR_KDM1_TNM\": \"Elektronik\",'+
		'                \"URUN_HYR_KDM2\": \"0201\",'+
		'                \"URUN_HYR_KDM2_TNM\": \"Ses ve Görüntü Sistemleri Grubu\",'+
		'                \"URUN_HYR_KDM3\": \"020104\",'+
		'                \"URUN_HYR_KDM3_TNM\": \"LCD TV\",'+
		'                \"URUN_HYR_KDM4\": \"02010423\",'+
		'                \"URUN_HYR_KDM4_TNM\": \"55\\\"\",'+
		'                \"URUN_HYR_KDM5\": \"0201042305\",'+
		'                \"URUN_HYR_KDM5_TNM\": \"Smart\",'+
		'                \"URUN_HYR_KDM6\": \"020104230503\",'+
		'                \"URUN_HYR_KDM6_TNM\": \"Ultra HD\",'+
		'                \"URUN_HYR_KDM7\": \"02010423050310\",'+
		'                \"URUN_HYR_KDM7_TNM\": \"9 Serisi\"'+
		'            },'+
		'            {'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"MUSTERI\": \"0020400468\",'+
		'                \"SAS_NO\": \"GIB2021000000013...\",'+
		'                \"SIP_NO\": \"0090131386\",'+
		'                \"SIP_KLM\": \"000010\",'+
		'                \"SIP_UST_KLM\": \"000000\",'+
		'                \"SIP_TUR\": \"V14\",'+
		'                \"SIP_GRKC\": \"TU5\",'+
		'                \"SIP_KULLANIM\": \"09\",'+
		'                \"ODEME_KSL\": \"VPNK\",'+
		'                \"VALOR\": \"0000-00-00\",'+
		'                \"EK_VALOR\": \"00\",'+
		'                \"PARA_BRM\": \"TRY\",'+
		'                \"SIP_YRT_TRH\": \"2021-02-09\",'+
		'                \"SIP_BLG_TRH\": \"2021-02-09\",'+
		'                \"SIP_IST_TSL\": \"2021-02-09\",'+
		'                \"TESLIM_ALAN\": \"0020400468\",'+
		'                \"TSLM_ALAN_UNVAN\": \"AK İNŞAAT TURİZM ELEKTRİK ELEKTRO. İTH.İHR.VE TİC.LTD.ŞTİ.\",'+
		'                \"TSLM_ALAN_ADRES\": \"\",'+
		'                \"TSLM_ALAN_SEMT\": \"KEMERALTI MAH.\",'+
		'                \"TSLM_ALAN_ILCE\": \"MARMARİS\",'+
		'                \"TSLM_ALAN_IL\": \"048\",'+
		'                \"TSLM_ALAN_TEL\": 2524122598,'+
		'                \"TSLM_ALAN_EMAIL\": \"akticaret@vestelbayi.com\",'+
		'                \"REF_SIP_NO\": \"0021152112\",'+
		'                \"REF_SIP_KLM\": \"000010\",'+
		'                \"MALZEME\": \"000000000020275899\",'+
		'                \"MALZEME_TANIM\": \"39H9400 39\\\" SMART TV\",'+
		'                \"SIP_MIK\": \"3.000\",'+
		'                \"SIP_IADE_FAT_MIK\": 0,'+
		'                \"SIP_NET_DEGER\": \"5915.40\",'+
		'                \"SIP_KDV_DEGER\": 1064.77,'+
		'                \"SIP_TPL_DEGER\": 6980.17,'+
		'                \"SIP_UY\": 2204,'+
		'                \"SIP_DEPO\": \"0001\",'+
		'                \"MLZ_GRUP\": 3,'+
		'                \"MLZ_GRUP_TNM\": \"LCD TV\",'+
		'                \"MLZ_GRUP1\": 22,'+
		'                \"MLZ_GRUP1_TNM\": \"Elektronik Eşya\",'+
		'                \"MLZ_GRUP2\": 16,'+
		'                \"MLZ_GRUP2_TNM\": \"Elektronik\",'+
		'                \"MLZ_GRUP3\": \"\",'+
		'                \"MLZ_GRUP3_TNM\": \"\",'+
		'                \"MLZ_GRUP4\": \"01\",'+
		'                \"MLZ_GRUP4_TNM\": \"Kategori 1 (Elekt.)\",'+
		'                \"MLZ_GRUP5\": \"\",'+
		'                \"MLZ_GRUP5_TNM\": \"\",'+
		'                \"URUN_HYR\": \"020104150501\",'+
		'                \"URUN_HYR_TNM\": \"Full HD\",'+
		'                \"URUN_HYR_KDM1\": \"02\",'+
		'                \"URUN_HYR_KDM1_TNM\": \"Elektronik\",'+
		'                \"URUN_HYR_KDM2\": \"0201\",'+
		'                \"URUN_HYR_KDM2_TNM\": \"Ses ve Görüntü Sistemleri Grubu\",'+
		'                \"URUN_HYR_KDM3\": \"020104\",'+
		'                \"URUN_HYR_KDM3_TNM\": \"LCD TV\",'+
		'                \"URUN_HYR_KDM4\": \"02010415\",'+
		'                \"URUN_HYR_KDM4_TNM\": \"39\\\"\",'+
		'                \"URUN_HYR_KDM5\": \"0201041505\",'+
		'                \"URUN_HYR_KDM5_TNM\": \"Smart\",'+
		'                \"URUN_HYR_KDM6\": \"020104150501\",'+
		'                \"URUN_HYR_KDM6_TNM\": \"Full HD\",'+
		'                \"URUN_HYR_KDM7\": \"020104150501\",'+
		'                \"URUN_HYR_KDM7_TNM\": \"Full HD\"'+
		'            },'+
		'            {'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"MUSTERI\": \"0020400775\",'+
		'                \"SAS_NO\": \"CYL2021000000070\",'+
		'                \"SIP_NO\": \"0090131393\",'+
		'                \"SIP_KLM\": \"000020\",'+
		'                \"SIP_UST_KLM\": \"000000\",'+
		'                \"SIP_TUR\": \"V14\",'+
		'                \"SIP_GRKC\": \"TD2\",'+
		'                \"SIP_KULLANIM\": 12,'+
		'                \"ODEME_KSL\": \"1/3\",'+
		'                \"VALOR\": \"2020-11-30\",'+
		'                \"EK_VALOR\": \"00\",'+
		'                \"PARA_BRM\": \"TRY\",'+
		'                \"SIP_YRT_TRH\": \"2021-02-10\",'+
		'                \"SIP_BLG_TRH\": \"2021-02-10\",'+
		'                \"SIP_IST_TSL\": \"2021-02-10\",'+
		'                \"TESLIM_ALAN\": \"0020400775\",'+
		'                \"TSLM_ALAN_UNVAN\": \"HÜSEYİN CEYLAN .\",'+
		'                \"TSLM_ALAN_ADRES\": \"YENİ MAH. CUMHURİYET CAD. NO:120/B\",'+
		'                \"TSLM_ALAN_SEMT\": \"YENİ MAH.\",'+
		'                \"TSLM_ALAN_ILCE\": \"DİDİM\",'+
		'                \"TSLM_ALAN_IL\": \"009\",'+
		'                \"TSLM_ALAN_TEL\": 2568111592,'+
		'                \"TSLM_ALAN_EMAIL\": \"muhasebe@ceylanstore.com\",'+
		'                \"REF_SIP_NO\": \"0021144832\",'+
		'                \"REF_SIP_KLM\": \"000020\",'+
		'                \"MALZEME\": \"000000000020275260\",'+
		'                \"MALZEME_TANIM\": \"58U9500 58\\\" 4K SMART TV\",'+
		'                \"SIP_MIK\": \"1.000\",'+
		'                \"SIP_IADE_FAT_MIK\": 0,'+
		'                \"SIP_NET_DEGER\": 3532.47,'+
		'                \"SIP_KDV_DEGER\": 635.84,'+
		'                \"SIP_TPL_DEGER\": 4168.31,'+
		'                \"SIP_UY\": 2210,'+
		'                \"SIP_DEPO\": \"0008\",'+
		'                \"MLZ_GRUP\": 3,'+
		'                \"MLZ_GRUP_TNM\": \"LCD TV\",'+
		'                \"MLZ_GRUP1\": 22,'+
		'                \"MLZ_GRUP1_TNM\": \"Elektronik Eşya\",'+
		'                \"MLZ_GRUP2\": 16,'+
		'                \"MLZ_GRUP2_TNM\": \"Elektronik\",'+
		'                \"MLZ_GRUP3\": \"\",'+
		'                \"MLZ_GRUP3_TNM\": \"\",'+
		'                \"MLZ_GRUP4\": \"01\",'+
		'                \"MLZ_GRUP4_TNM\": \"Kategori 1 (Elekt.)\",'+
		'                \"MLZ_GRUP5\": \"\",'+
		'                \"MLZ_GRUP5_TNM\": \"\",'+
		'                \"URUN_HYR\": \"020104320202\",'+
		'                \"URUN_HYR_TNM\": \"Ultra HD\",'+
		'                \"URUN_HYR_KDM1\": \"02\",'+
		'                \"URUN_HYR_KDM1_TNM\": \"Elektronik\",'+
		'                \"URUN_HYR_KDM2\": \"0201\",'+
		'                \"URUN_HYR_KDM2_TNM\": \"Ses ve Görüntü Sistemleri Grubu\",'+
		'                \"URUN_HYR_KDM3\": \"020104\",'+
		'                \"URUN_HYR_KDM3_TNM\": \"LCD TV\",'+
		'                \"URUN_HYR_KDM4\": \"02010432\",'+
		'                \"URUN_HYR_KDM4_TNM\": \"58\\\"\",'+
		'                \"URUN_HYR_KDM5\": \"0201043202\",'+
		'                \"URUN_HYR_KDM5_TNM\": \"LED TV\",'+
		'                \"URUN_HYR_KDM6\": \"020104320202\",'+
		'                \"URUN_HYR_KDM6_TNM\": \"Ultra HD\",'+
		'                \"URUN_HYR_KDM7\": \"020104320202\",'+
		'                \"URUN_HYR_KDM7_TNM\": \"Ultra HD\"'+
		'            },'+
		'            {'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"MUSTERI\": \"0020400468\",'+
		'                \"SAS_NO\": \"GIB2021000000017.. .\",'+
		'                \"SIP_NO\": \"0090131441\",'+
		'                \"SIP_KLM\": \"000010\",'+
		'                \"SIP_UST_KLM\": \"000000\",'+
		'                \"SIP_TUR\": \"V14\",'+
		'                \"SIP_GRKC\": \"VF1\",'+
		'                \"SIP_KULLANIM\": \"09\",'+
		'                \"ODEME_KSL\": \"VPNK\",'+
		'                \"VALOR\": \"0000-00-00\",'+
		'                \"EK_VALOR\": \"00\",'+
		'                \"PARA_BRM\": \"TRY\",'+
		'                \"SIP_YRT_TRH\": \"2021-02-12\",'+
		'                \"SIP_BLG_TRH\": \"2021-02-12\",'+
		'                \"SIP_IST_TSL\": \"2021-02-12\",'+
		'                \"TESLIM_ALAN\": \"0020400468\",'+
		'                \"TSLM_ALAN_UNVAN\": \"AK İNŞAAT TURİZM ELEKTRİK ELEKTRO. İTH.İHR.VE TİC.LTD.ŞTİ.\",'+
		'                \"TSLM_ALAN_ADRES\": \"\",'+
		'                \"TSLM_ALAN_SEMT\": \"KEMERALTI MAH.\",'+
		'                \"TSLM_ALAN_ILCE\": \"MARMARİS\",'+
		'                \"TSLM_ALAN_IL\": \"048\",'+
		'                \"TSLM_ALAN_TEL\": 2524122598,'+
		'                \"TSLM_ALAN_EMAIL\": \"akticaret@vestelbayi.com\",'+
		'                \"REF_SIP_NO\": \"0021170425\",'+
		'                \"REF_SIP_KLM\": \"000020\",'+
		'                \"MALZEME\": \"000000000020242831\",'+
		'                \"MALZEME_TANIM\": \"VESTEL RETRO BORDO KAHVE MAKİNESİ\",'+
		'                \"SIP_MIK\": \"4.000\",'+
		'                \"SIP_IADE_FAT_MIK\": 0,'+
		'                \"SIP_NET_DEGER\": 1833.88,'+
		'                \"SIP_KDV_DEGER\": \"330.10\",'+
		'                \"SIP_TPL_DEGER\": 2163.98,'+
		'                \"SIP_UY\": 2204,'+
		'                \"SIP_DEPO\": \"0001\",'+
		'                \"MLZ_GRUP\": 2,'+
		'                \"MLZ_GRUP_TNM\": \"Küçük Ev Aletleri\",'+
		'                \"MLZ_GRUP1\": 21,'+
		'                \"MLZ_GRUP1_TNM\": \"Beyaz Eşya\",'+
		'                \"MLZ_GRUP2\": 17,'+
		'                \"MLZ_GRUP2_TNM\": \"Beyaz Eşya\",'+
		'                \"MLZ_GRUP3\": \"\",'+
		'                \"MLZ_GRUP3_TNM\": \"\",'+
		'                \"MLZ_GRUP4\": \"04\",'+
		'                \"MLZ_GRUP4_TNM\": \"Kategori 4 (KEA & Süpürge)\",'+
		'                \"MLZ_GRUP5\": \"\",'+
		'                \"MLZ_GRUP5_TNM\": \"\",'+
		'                \"URUN_HYR\": \"0105010402\",'+
		'                \"URUN_HYR_TNM\": \"Kahve Makineleri\",'+
		'                \"URUN_HYR_KDM1\": \"01\",'+
		'                \"URUN_HYR_KDM1_TNM\": \"Beyaz Eşya\",'+
		'                \"URUN_HYR_KDM2\": \"0105\",'+
		'                \"URUN_HYR_KDM2_TNM\": \"Küçük Ev Aletleri Grubu\",'+
		'                \"URUN_HYR_KDM3\": \"010501\",'+
		'                \"URUN_HYR_KDM3_TNM\": \"Küçük Ev Aletleri\",'+
		'                \"URUN_HYR_KDM4\": \"01050104\",'+
		'                \"URUN_HYR_KDM4_TNM\": \"İçecek Hazırlama Grubu\",'+
		'                \"URUN_HYR_KDM5\": \"0105010402\",'+
		'                \"URUN_HYR_KDM5_TNM\": \"Kahve Makineleri\",'+
		'                \"URUN_HYR_KDM6\": \"0105010402\",'+
		'                \"URUN_HYR_KDM6_TNM\": \"Kahve Makineleri\",'+
		'                \"URUN_HYR_KDM7\": \"0105010402\",'+
		'                \"URUN_HYR_KDM7_TNM\": \"Kahve Makineleri\"'+
		'            },'+
		'            {'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"MUSTERI\": \"0020400468\",'+
		'                \"SAS_NO\": \"GIB2021000000019.. .\",'+
		'                \"SIP_NO\": \"0090131443\",'+
		'                \"SIP_KLM\": \"000010\",'+
		'                \"SIP_UST_KLM\": \"000000\",'+
		'                \"SIP_TUR\": \"V14\",'+
		'                \"SIP_GRKC\": \"VU9\",'+
		'                \"SIP_KULLANIM\": \"09\",'+
		'                \"ODEME_KSL\": \"VPNK\",'+
		'                \"VALOR\": \"0000-00-00\",'+
		'                \"EK_VALOR\": \"00\",'+
		'                \"PARA_BRM\": \"TRY\",'+
		'                \"SIP_YRT_TRH\": \"2021-02-12\",'+
		'                \"SIP_BLG_TRH\": \"2021-02-12\",'+
		'                \"SIP_IST_TSL\": \"2021-02-12\",'+
		'                \"TESLIM_ALAN\": \"0020400468\",'+
		'                \"TSLM_ALAN_UNVAN\": \"AK İNŞAAT TURİZM ELEKTRİK ELEKTRO. İTH.İHR.VE TİC.LTD.ŞTİ.\",'+
		'                \"TSLM_ALAN_ADRES\": \"\",'+
		'                \"TSLM_ALAN_SEMT\": \"KEMERALTI MAH.\",'+
		'                \"TSLM_ALAN_ILCE\": \"MARMARİS\",'+
		'                \"TSLM_ALAN_IL\": \"048\",'+
		'                \"TSLM_ALAN_TEL\": 2524122598,'+
		'                \"TSLM_ALAN_EMAIL\": \"akticaret@vestelbayi.com\",'+
		'                \"REF_SIP_NO\": \"0021185458\",'+
		'                \"REF_SIP_KLM\": \"000010\",'+
		'                \"MALZEME\": \"000000000020262665\",'+
		'                \"MALZEME_TANIM\": \"SF 7400\",'+
		'                \"SIP_MIK\": \"5.000\",'+
		'                \"SIP_IADE_FAT_MIK\": 0,'+
		'                \"SIP_NET_DEGER\": 6100.95,'+
		'                \"SIP_KDV_DEGER\": 1098.17,'+
		'                \"SIP_TPL_DEGER\": 7199.12,'+
		'                \"SIP_UY\": 2204,'+
		'                \"SIP_DEPO\": \"0001\",'+
		'                \"MLZ_GRUP\": 25,'+
		'                \"MLZ_GRUP_TNM\": \"Solo Fırın\",'+
		'                \"MLZ_GRUP1\": 21,'+
		'                \"MLZ_GRUP1_TNM\": \"Beyaz Eşya\",'+
		'                \"MLZ_GRUP2\": 17,'+
		'                \"MLZ_GRUP2_TNM\": \"Beyaz Eşya\",'+
		'                \"MLZ_GRUP3\": \"\",'+
		'                \"MLZ_GRUP3_TNM\": \"\",'+
		'                \"MLZ_GRUP4\": \"02\",'+
		'                \"MLZ_GRUP4_TNM\": \"Kategori 2 (Beyazeşya)\",'+
		'                \"MLZ_GRUP5\": \"\",'+
		'                \"MLZ_GRUP5_TNM\": \"\",'+
		'                \"URUN_HYR\": \"01030704010102\",'+
		'                \"URUN_HYR_TNM\": \"Tek Bölmeli Solo Fırın\",'+
		'                \"URUN_HYR_KDM1\": \"01\",'+
		'                \"URUN_HYR_KDM1_TNM\": \"Beyaz Eşya\",'+
		'                \"URUN_HYR_KDM2\": \"0103\",'+
		'                \"URUN_HYR_KDM2_TNM\": \"Pişirici Grubu\",'+
		'                \"URUN_HYR_KDM3\": \"010307\",'+
		'                \"URUN_HYR_KDM3_TNM\": \"Solo Fırın\",'+
		'                \"URUN_HYR_KDM4\": \"01030704\",'+
		'                \"URUN_HYR_KDM4_TNM\": \"Fırın Elek.(Turbo)\",'+
		'                \"URUN_HYR_KDM5\": \"0103070401\",'+
		'                \"URUN_HYR_KDM5_TNM\": \"3 GG + 1GE\",'+
		'                \"URUN_HYR_KDM6\": \"010307040101\",'+
		'                \"URUN_HYR_KDM6_TNM\": \"Beyaz\",'+
		'                \"URUN_HYR_KDM7\": \"01030704010102\",'+
		'                \"URUN_HYR_KDM7_TNM\": \"Tek Bölmeli Solo Fırın\"'+
		'            },'+
		'            {'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"MUSTERI\": \"0020400775\",'+
		'                \"SAS_NO\": \"CYL2021000000085\",'+
		'                \"SIP_NO\": \"0090131556\",'+
		'                \"SIP_KLM\": \"000090\",'+
		'                \"SIP_UST_KLM\": \"000000\",'+
		'                \"SIP_TUR\": \"V14\",'+
		'                \"SIP_GRKC\": \"VP2\",'+
		'                \"SIP_KULLANIM\": 12,'+
		'                \"ODEME_KSL\": \"1/3\",'+
		'                \"VALOR\": \"0000-00-00\",'+
		'                \"EK_VALOR\": 30,'+
		'                \"PARA_BRM\": \"TRY\",'+
		'                \"SIP_YRT_TRH\": \"2021-02-19\",'+
		'                \"SIP_BLG_TRH\": \"2021-02-19\",'+
		'                \"SIP_IST_TSL\": \"2021-03-13\",'+
		'                \"TESLIM_ALAN\": \"0020400775\",'+
		'                \"TSLM_ALAN_UNVAN\": \"HÜSEYİN CEYLAN .\",'+
		'                \"TSLM_ALAN_ADRES\": \"YENİ MAH. CUMHURİYET CAD. NO:120/B\",'+
		'                \"TSLM_ALAN_SEMT\": \"YENİ MAH.\",'+
		'                \"TSLM_ALAN_ILCE\": \"DİDİM\",'+
		'                \"TSLM_ALAN_IL\": \"009\",'+
		'                \"TSLM_ALAN_TEL\": 2568111592,'+
		'                \"TSLM_ALAN_EMAIL\": \"muhasebe@ceylanstore.com\",'+
		'                \"REF_SIP_NO\": \"0021176487\",'+
		'                \"REF_SIP_KLM\": \"000090\",'+
		'                \"MALZEME\": \"000000000020275211\",'+
		'                \"MALZEME_TANIM\": \"65U9500 65\\\" 4K SMART TV\",'+
		'                \"SIP_MIK\": \"1.000\",'+
		'                \"SIP_IADE_FAT_MIK\": 0,'+
		'                \"SIP_NET_DEGER\": \"2877.30\",'+
		'                \"SIP_KDV_DEGER\": 517.91,'+
		'                \"SIP_TPL_DEGER\": 3395.21,'+
		'                \"SIP_UY\": 2210,'+
		'                \"SIP_DEPO\": \"0008\",'+
		'                \"MLZ_GRUP\": 3,'+
		'                \"MLZ_GRUP_TNM\": \"LCD TV\",'+
		'                \"MLZ_GRUP1\": 22,'+
		'                \"MLZ_GRUP1_TNM\": \"Elektronik Eşya\",'+
		'                \"MLZ_GRUP2\": 16,'+
		'                \"MLZ_GRUP2_TNM\": \"Elektronik\",'+
		'                \"MLZ_GRUP3\": \"\",'+
		'                \"MLZ_GRUP3_TNM\": \"\",'+
		'                \"MLZ_GRUP4\": \"01\",'+
		'                \"MLZ_GRUP4_TNM\": \"Kategori 1 (Elekt.)\",'+
		'                \"MLZ_GRUP5\": \"\",'+
		'                \"MLZ_GRUP5_TNM\": \"\",'+
		'                \"URUN_HYR\": \"02010424050310\",'+
		'                \"URUN_HYR_TNM\": \"9 Serisi\",'+
		'                \"URUN_HYR_KDM1\": \"02\",'+
		'                \"URUN_HYR_KDM1_TNM\": \"Elektronik\",'+
		'                \"URUN_HYR_KDM2\": \"0201\",'+
		'                \"URUN_HYR_KDM2_TNM\": \"Ses ve Görüntü Sistemleri Grubu\",'+
		'                \"URUN_HYR_KDM3\": \"020104\",'+
		'                \"URUN_HYR_KDM3_TNM\": \"LCD TV\",'+
		'                \"URUN_HYR_KDM4\": \"02010424\",'+
		'                \"URUN_HYR_KDM4_TNM\": \"65\\\"\",'+
		'                \"URUN_HYR_KDM5\": \"0201042405\",'+
		'                \"URUN_HYR_KDM5_TNM\": \"Smart\",'+
		'                \"URUN_HYR_KDM6\": \"020104240503\",'+
		'                \"URUN_HYR_KDM6_TNM\": \"Ultra HD\",'+
		'                \"URUN_HYR_KDM7\": \"02010424050310\",'+
		'                \"URUN_HYR_KDM7_TNM\": \"9 Serisi\"'+
		'            },'+
		'            {'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"MUSTERI\": \"0020400452\",'+
		'                \"SAS_NO\": \"AEF2021000000041\",'+
		'                \"SIP_NO\": \"0090131568\",'+
		'                \"SIP_KLM\": \"000010\",'+
		'                \"SIP_UST_KLM\": \"000000\",'+
		'                \"SIP_TUR\": \"V14\",'+
		'                \"SIP_GRKC\": \"ZH1\",'+
		'                \"SIP_KULLANIM\": \"09\",'+
		'                \"ODEME_KSL\": \"VPNK\",'+
		'                \"VALOR\": \"0000-00-00\",'+
		'                \"EK_VALOR\": \"00\",'+
		'                \"PARA_BRM\": \"TRY\",'+
		'                \"SIP_YRT_TRH\": \"2021-02-23\",'+
		'                \"SIP_BLG_TRH\": \"2021-02-23\",'+
		'                \"SIP_IST_TSL\": \"2021-02-22\",'+
		'                \"TESLIM_ALAN\": \"0020400452\",'+
		'                \"TSLM_ALAN_UNVAN\": \"AVCILAR TİCARET TURİZM İNŞAAT VE SANAYİ LİMİTED ŞİRKETİ.\",'+
		'                \"TSLM_ALAN_ADRES\": \"CUMHURİYET CAD.NO.44/B .\",'+
		'                \"TSLM_ALAN_SEMT\": \"CUMHURİYET MAH.\",'+
		'                \"TSLM_ALAN_ILCE\": \"YATAĞAN\",'+
		'                \"TSLM_ALAN_IL\": \"048\",'+
		'                \"TSLM_ALAN_TEL\": 2525725784,'+
		'                \"TSLM_ALAN_EMAIL\": \"avcilar.ticaret.beyazesya@hotmail.com\",'+
		'                \"REF_SIP_NO\": \"0021198751\",'+
		'                \"REF_SIP_KLM\": \"000010\",'+
		'                \"MALZEME\": \"000000000020263216\",'+
		'                \"MALZEME_TANIM\": \"BMA 4201 X\",'+
		'                \"SIP_MIK\": \"5.000\",'+
		'                \"SIP_IADE_FAT_MIK\": 0,'+
		'                \"SIP_NET_DEGER\": 10230.55,'+
		'                \"SIP_KDV_DEGER\": \"1841.50\",'+
		'                \"SIP_TPL_DEGER\": 12072.05,'+
		'                \"SIP_UY\": 2204,'+
		'                \"SIP_DEPO\": \"0001\",'+
		'                \"MLZ_GRUP\": 87,'+
		'                \"MLZ_GRUP_TNM\": \"Ankastre Bulaşık Mak\",'+
		'                \"MLZ_GRUP1\": 21,'+
		'                \"MLZ_GRUP1_TNM\": \"Beyaz Eşya\",'+
		'                \"MLZ_GRUP2\": 4,'+
		'                \"MLZ_GRUP2_TNM\": \"Ankastre_Komple\",'+
		'                \"MLZ_GRUP3\": \"\",'+
		'                \"MLZ_GRUP3_TNM\": \"\",'+
		'                \"MLZ_GRUP4\": \"02\",'+
		'                \"MLZ_GRUP4_TNM\": \"Kategori 2 (Beyazeşya)\",'+
		'                \"MLZ_GRUP5\": \"\",'+
		'                \"MLZ_GRUP5_TNM\": \"\",'+
		'                \"URUN_HYR\": \"0102050202\",'+
		'                \"URUN_HYR_TNM\": \"Yarı Ankastre\",'+
		'                \"URUN_HYR_KDM1\": \"01\",'+
		'                \"URUN_HYR_KDM1_TNM\": \"Beyaz Eşya\",'+
		'                \"URUN_HYR_KDM2\": \"0102\",'+
		'                \"URUN_HYR_KDM2_TNM\": \"Yıkayıcı Grubu\",'+
		'                \"URUN_HYR_KDM3\": \"010205\",'+
		'                \"URUN_HYR_KDM3_TNM\": \"Ankastre Bulaşık Makinesi\",'+
		'                \"URUN_HYR_KDM4\": \"01020502\",'+
		'                \"URUN_HYR_KDM4_TNM\": \"4 Program\",'+
		'                \"URUN_HYR_KDM5\": \"0102050202\",'+
		'                \"URUN_HYR_KDM5_TNM\": \"Yarı Ankastre\",'+
		'                \"URUN_HYR_KDM6\": \"0102050202\",'+
		'                \"URUN_HYR_KDM6_TNM\": \"Yarı Ankastre\",'+
		'                \"URUN_HYR_KDM7\": \"0102050202\",'+
		'                \"URUN_HYR_KDM7_TNM\": \"Yarı Ankastre\"'+
		'            },'+
		'            {'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"MUSTERI\": \"0020700295\",'+
		'                \"SAS_NO\": \"VFK2021000000015\",'+
		'                \"SIP_NO\": \"0090131593\",'+
		'                \"SIP_KLM\": \"000010\",'+
		'                \"SIP_UST_KLM\": \"000000\",'+
		'                \"SIP_TUR\": \"V14\",'+
		'                \"SIP_GRKC\": \"ZH1\",'+
		'                \"SIP_KULLANIM\": \"01\",'+
		'                \"ODEME_KSL\": \"VPNK\",'+
		'                \"VALOR\": \"0000-00-00\",'+
		'                \"EK_VALOR\": \"00\",'+
		'                \"PARA_BRM\": \"TRY\",'+
		'                \"SIP_YRT_TRH\": \"2021-02-25\",'+
		'                \"SIP_BLG_TRH\": \"2021-02-25\",'+
		'                \"SIP_IST_TSL\": \"2021-02-25\",'+
		'                \"TESLIM_ALAN\": \"0020700295\",'+
		'                \"TSLM_ALAN_UNVAN\": \"ABDULLAH BÜYÜKERKMEN İBRAHİM BÜYÜKERKMEN PAMUKOĞLU MOTOR GRUP\",'+
		'                \"TSLM_ALAN_ADRES\": \"\",'+
		'                \"TSLM_ALAN_SEMT\": \"DUMLUPINAR MAH.\",'+
		'                \"TSLM_ALAN_ILCE\": \"MERKEZ\",'+
		'                \"TSLM_ALAN_IL\": \"003\",'+
		'                \"TSLM_ALAN_TEL\": 2722132202,'+
		'                \"TSLM_ALAN_EMAIL\": \"elif_apaydin@msn.com\",'+
		'                \"REF_SIP_NO\": \"0021201166\",'+
		'                \"REF_SIP_KLM\": \"000010\",'+
		'                \"MALZEME\": \"000000000020263336\",'+
		'                \"MALZEME_TANIM\": \"KM 9601\",'+
		'                \"SIP_MIK\": \"5.000\",'+
		'                \"SIP_IADE_FAT_MIK\": 0,'+
		'                \"SIP_NET_DEGER\": 12563.55,'+
		'                \"SIP_KDV_DEGER\": 2261.44,'+
		'                \"SIP_TPL_DEGER\": 14824.99,'+
		'                \"SIP_UY\": 2204,'+
		'                \"SIP_DEPO\": \"0001\",'+
		'                \"MLZ_GRUP\": 7,'+
		'                \"MLZ_GRUP_TNM\": \"Solo Kurutma Makines\",'+
		'                \"MLZ_GRUP1\": 21,'+
		'                \"MLZ_GRUP1_TNM\": \"Beyaz Eşya\",'+
		'                \"MLZ_GRUP2\": 17,'+
		'                \"MLZ_GRUP2_TNM\": \"Beyaz Eşya\",'+
		'                \"MLZ_GRUP3\": \"\",'+
		'                \"MLZ_GRUP3_TNM\": \"\",'+
		'                \"MLZ_GRUP4\": \"02\",'+
		'                \"MLZ_GRUP4_TNM\": \"Kategori 2 (Beyazeşya)\",'+
		'                \"MLZ_GRUP5\": \"\",'+
		'                \"MLZ_GRUP5_TNM\": \"\",'+
		'                \"URUN_HYR\": \"01020305\",'+
		'                \"URUN_HYR_TNM\": \"9 kg\",'+
		'                \"URUN_HYR_KDM1\": \"01\",'+
		'                \"URUN_HYR_KDM1_TNM\": \"Beyaz Eşya\",'+
		'                \"URUN_HYR_KDM2\": \"0102\",'+
		'                \"URUN_HYR_KDM2_TNM\": \"Yıkayıcı Grubu\",'+
		'                \"URUN_HYR_KDM3\": \"010203\",'+
		'                \"URUN_HYR_KDM3_TNM\": \"Solo Kurutma Makinesi\",'+
		'                \"URUN_HYR_KDM4\": \"01020305\",'+
		'                \"URUN_HYR_KDM4_TNM\": \"9 kg\",'+
		'                \"URUN_HYR_KDM5\": \"01020305\",'+
		'                \"URUN_HYR_KDM5_TNM\": \"9 kg\",'+
		'                \"URUN_HYR_KDM6\": \"01020305\",'+
		'                \"URUN_HYR_KDM6_TNM\": \"9 kg\",'+
		'                \"URUN_HYR_KDM7\": \"01020305\",'+
		'                \"URUN_HYR_KDM7_TNM\": \"9 kg\"'+
		'            },'+
		'            {'+
		'                \"SATIS_ORG\": 2201,'+
		'                \"DGTM_KANALI\": \"01\",'+
		'                \"BOLUM\": 21,'+
		'                \"MUSTERI\": \"0020400244\",'+
		'                \"SAS_NO\": \"M012021000000051\",'+
		'                \"SIP_NO\": \"0320054294\",'+
		'                \"SIP_KLM\": \"000010\",'+
		'                \"SIP_UST_KLM\": \"000000\",'+
		'                \"SIP_TUR\": \"TSIA\",'+
		'                \"SIP_GRKC\": \"VI2\",'+
		'                \"SIP_KULLANIM\": 12,'+
		'                \"ODEME_KSL\": \"VPNK\",'+
		'                \"VALOR\": \"0000-00-00\",'+
		'                \"EK_VALOR\": \"00\",'+
		'                \"PARA_BRM\": \"TRY\",'+
		'                \"SIP_YRT_TRH\": \"2021-02-08\",'+
		'                \"SIP_BLG_TRH\": \"2021-02-08\",'+
		'                \"SIP_IST_TSL\": \"2021-02-08\",'+
		'                \"TESLIM_ALAN\": \"0020400244\",'+
		'                \"TSLM_ALAN_UNVAN\": \"ALEVGAZ DAYANIKLI TÜKETİM MALLARI SANAYİ VE TİCARET LİMİTED ŞİRKETİ\",'+
		'                \"TSLM_ALAN_ADRES\": \"SARAYLAR MAH. 2.TİCARİ YOL NO:48/A\",'+
		'                \"TSLM_ALAN_SEMT\": \"SARAYLAR MAH.\",'+
		'                \"TSLM_ALAN_ILCE\": \"MERKEZEFENDİ\",'+
		'                \"TSLM_ALAN_IL\": \"020\",'+
		'                \"TSLM_ALAN_TEL\": 2582410538,'+
		'                \"TSLM_ALAN_EMAIL\": \"eda@alevgaz.com\",'+
		'                \"REF_SIP_NO\": \"0353057872\",'+
		'                \"REF_SIP_KLM\": \"000010\",'+
		'                \"MALZEME\": \"000000000020275259\",'+
		'                \"MALZEME_TANIM\": \"55U9500 55\\\" 4K SMART TV\",'+
		'                \"SIP_MIK\": \"1.000\",'+
		'                \"SIP_IADE_FAT_MIK\": 0,'+
		'                \"SIP_NET_DEGER\": 3585.75,'+
		'                \"SIP_KDV_DEGER\": 645.44,'+
		'                \"SIP_TPL_DEGER\": 4231.19,'+
		'                \"SIP_UY\": 2210,'+
		'                \"SIP_DEPO\": \"0008\",'+
		'                \"MLZ_GRUP\": 3,'+
		'                \"MLZ_GRUP_TNM\": \"LCD TV\",'+
		'                \"MLZ_GRUP1\": 22,'+
		'                \"MLZ_GRUP1_TNM\": \"Elektronik Eşya\",'+
		'                \"MLZ_GRUP2\": 16,'+
		'                \"MLZ_GRUP2_TNM\": \"Elektronik\",'+
		'                \"MLZ_GRUP3\": \"\",'+
		'                \"MLZ_GRUP3_TNM\": \"\",'+
		'                \"MLZ_GRUP4\": \"01\",'+
		'                \"MLZ_GRUP4_TNM\": \"Kategori 1 (Elekt.)\",'+
		'                \"MLZ_GRUP5\": \"\",'+
		'                \"MLZ_GRUP5_TNM\": \"\",'+
		'                \"URUN_HYR\": \"02010423050310\",'+
		'                \"URUN_HYR_TNM\": \"9 Serisi\",'+
		'                \"URUN_HYR_KDM1\": \"02\",'+
		'                \"URUN_HYR_KDM1_TNM\": \"Elektronik\",'+
		'                \"URUN_HYR_KDM2\": \"0201\",'+
		'                \"URUN_HYR_KDM2_TNM\": \"Ses ve Görüntü Sistemleri Grubu\",'+
		'                \"URUN_HYR_KDM3\": \"020104\",'+
		'                \"URUN_HYR_KDM3_TNM\": \"LCD TV\",'+
		'                \"URUN_HYR_KDM4\": \"02010423\",'+
		'                \"URUN_HYR_KDM4_TNM\": \"55\\\"\",'+
		'                \"URUN_HYR_KDM5\": \"0201042305\",'+
		'                \"URUN_HYR_KDM5_TNM\": \"Smart\",'+
		'                \"URUN_HYR_KDM6\": \"020104230503\",'+
		'                \"URUN_HYR_KDM6_TNM\": \"Ultra HD\",'+
		'                \"URUN_HYR_KDM7\": \"02010423050310\",'+
		'                \"URUN_HYR_KDM7_TNM\": \"9 Serisi\"'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"EV_SUCCESS\": \"S\"'+
		'}';
		RC_IptalIadeOpenRetOrderParser obj = RC_IptalIadeOpenRetOrderParser.parse(json);
		System.assert(obj != null);
	}
}