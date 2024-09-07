package cn.rootvip.famd.util;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class AESUtil {

    public static byte[] decrypt(byte[] data,byte[] key,byte[] iv) throws Exception {
        if(key==null) return null;
        if(iv==null) return null;
        try {
            SecretKey secretKey = new SecretKeySpec(key, "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            IvParameterSpec ips = new IvParameterSpec(iv);
            cipher.init(Cipher.DECRYPT_MODE, secretKey, ips);
            return cipher.doFinal(data);
        }catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
