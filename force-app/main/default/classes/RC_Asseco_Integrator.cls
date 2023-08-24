public class RC_Asseco_Integrator {    
    public static String GenerateRandomKey(Integer len) 
    {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }        
        system.debug('randStr : ' + randStr);
        return randStr; 
    }       
    
    public static String GenerateHashCode(String channel, String dealerCode, String random, String secretKey)
    {        
        String key = String.format('{0}|{1}|{2}|{3}', new String[]{channel, dealerCode, random, secretKey});        
        return EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(key)));
    }
}