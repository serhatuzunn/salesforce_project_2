public class RC_UploadExcelIntegratorParser {

	public String cek_no;
	public String vade_tarihi;
	public String tutar;
	public String tckn_vergi_no;
	public String banka_anahtari;
	public String banka_hesap_no;
	public String kesideci_bolge;

	
	public static List<RC_UploadExcelIntegratorParser> parse(String json) {
		return (List<RC_UploadExcelIntegratorParser>) System.JSON.deserialize(json, List<RC_UploadExcelIntegratorParser>.class);
	}
}