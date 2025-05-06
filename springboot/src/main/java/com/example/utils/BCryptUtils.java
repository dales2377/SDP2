package com.example.utils;

import org.mindrot.jbcrypt.BCrypt;

public class BCryptUtils {

    /**
     * 加密密码
     * @param plainPassword 明文密码
     * @return 加密后的哈希值
     */
    public static String hashPassword(String plainPassword) {
        // 自动生成盐值并哈希密码
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());

        // 可以指定计算复杂度（4-31，默认10）
        // return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * 验证密码
     * @param plainPassword 用户输入的密码
     * @param hashedPassword 存储的哈希密码
     * @return 是否匹配
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }

    public static void main(String[] args) {
        String password = "admin";
        String hash = hashPassword(password);
        System.out.println(hash);
    }
}
