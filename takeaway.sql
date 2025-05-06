/*
 Navicat Premium Dump SQL

 Source Server         : takeaway
 Source Server Type    : MySQL
 Source Server Version : 80035 (8.0.35)
 Source Host           : 119.3.157.192:3306
 Source Schema         : takeaway

 Target Server Type    : MySQL
 Target Server Version : 80035 (8.0.35)
 File Encoding         : 65001

 Date: 06/05/2025 21:53:32
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收货地址',
  `user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收货人',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '收货地址表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (4, '123', '123', '123', 4);
INSERT INTO `address` VALUES (5, '12432', '123432', '1324', 4);
INSERT INTO `address` VALUES (6, 'wef', 'wer', '124', 4);
INSERT INTO `address` VALUES (7, '123123', '123', '123123', 8);
INSERT INTO `address` VALUES (8, '123', '123', '123', 10);
INSERT INTO `address` VALUES (9, 'tes', 'test', '123', 10);
INSERT INTO `address` VALUES (10, '123', '1', '1234123', 14);
INSERT INTO `address` VALUES (11, '123', '123', '123', 15);

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `business_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES (9, 'http://localhost:9090/files/1746372023122-Screenshot 2023-09-05 200343.png', 13);

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goods_id` int NULL DEFAULT NULL COMMENT '商品ID',
  `num` int NULL DEFAULT NULL COMMENT '数量',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `business_id` int NULL DEFAULT NULL COMMENT '商家ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 79 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '购物车' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES (47, 26, 1, 4, NULL);
INSERT INTO `cart` VALUES (50, 26, 4, 4, NULL);
INSERT INTO `cart` VALUES (53, 26, 2, 4, NULL);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `business_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (5, 'MilkTea', 16);
INSERT INTO `category` VALUES (6, '234', 16);
INSERT INTO `category` VALUES (8, 'Apple1', 16);
INSERT INTO `category` VALUES (12, '5678', 13);
INSERT INTO `category` VALUES (13, '1234', 13);
INSERT INTO `category` VALUES (14, 'wqe', 12);

-- ----------------------------
-- Table structure for collect
-- ----------------------------
DROP TABLE IF EXISTS `collect`;
CREATE TABLE `collect`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `business_id` int NULL DEFAULT NULL COMMENT '商家ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户收藏' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of collect
-- ----------------------------
INSERT INTO `collect` VALUES (3, 13, 14, '2025-05-01 13:39:26');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '评论',
  `star` double(10, 1) NULL DEFAULT 0.0 COMMENT '评分',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `business_id` int NULL DEFAULT NULL COMMENT '商家iD',
  `goods_id` int NULL DEFAULT NULL COMMENT '商品ID',
  `order_id` int NULL DEFAULT NULL COMMENT '订单ID',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC, `order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '评价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (1, 'good', 4.0, 15, 13, NULL, 56, '2025-05-04 23:55:15');
INSERT INTO `comment` VALUES (2, '1232123', 5.0, 14, 13, NULL, 58, '2025-05-05 07:14:26');
INSERT INTO `comment` VALUES (3, 'qwer', 3.0, 15, 12, NULL, 59, '2025-05-05 18:10:36');
INSERT INTO `comment` VALUES (4, '123123', 4.0, 14, 13, NULL, 63, '2025-05-06 17:37:46');
INSERT INTO `comment` VALUES (5, '123', 4.0, 14, 13, NULL, 62, '2025-05-06 18:00:52');

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `price` decimal(10, 2) NULL DEFAULT NULL,
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `origin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `taste` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `specs` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '上架' COMMENT '上架状态',
  `discount` double(11, 1) NULL DEFAULT 1.0,
  `business_id` int NULL DEFAULT NULL,
  `category_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (26, 'BOBo', 128.00, 'http://localhost:9090/files/1713835431035-OIP-C.jpg', 'GOOOD', 'Milk', 'Sweet', 'BIG', '2023-12-13', '上架', 0.9, 16, 5);
INSERT INTO `goods` VALUES (27, 'ThaiTEA', 123.00, NULL, 'GOOOOD', 'Milk', 'GOOD', 'BIG', '2023-12-07', '下架', 0.9, 16, 6);
INSERT INTO `goods` VALUES (38, 'test1', 100.00, 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'qwretg', NULL, 'sweet', NULL, '2025-05-04', '上架', 1.0, 13, 13);
INSERT INTO `goods` VALUES (42, 'test222', 222.00, 'http://localhost:9090/files/1746439658894-Screenshot 2023-08-21 094103.png', NULL, NULL, 'sweet', 'big', '2025-05-05', '上架', 1.0, 13, 12);
INSERT INTO `goods` VALUES (43, '12345', 1111.00, 'http://localhost:9090/files/1746439743340-屏幕截图 2024-10-20 203213.png', NULL, NULL, 'sweet', 'big', NULL, '上架', 1.0, 12, 14);

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '今天系统正式上线，开始内测', '今天系统正式上线，开始内测', '2023-09-05', 'admin');
INSERT INTO `notice` VALUES (2, '所有功能都已完成，可以正常使用', '所有功能都已完成，可以正常使用', '2023-09-05', 'admin');
INSERT INTO `notice` VALUES (4, 'Today is last day of SD', 'Are you ready?', '2023-12-13', 'admin');
INSERT INTO `notice` VALUES (5, 'MEETING', '3;30pm', '2024-04-23', 'admin');

-- ----------------------------
-- Table structure for order_notice
-- ----------------------------
DROP TABLE IF EXISTS `order_notice`;
CREATE TABLE `order_notice`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL COMMENT '订单id',
  `is_delete` int NULL DEFAULT 0 COMMENT '是否删除 0 未删除 1 已删除',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_notice
-- ----------------------------
INSERT INTO `order_notice` VALUES (1, 53, 0, '2025-05-03 13:13:32');
INSERT INTO `order_notice` VALUES (2, 52, 1, '2025-05-03 22:17:13');
INSERT INTO `order_notice` VALUES (3, 54, 1, '2025-05-04 08:25:39');
INSERT INTO `order_notice` VALUES (4, 54, 1, '2025-05-04 08:25:48');
INSERT INTO `order_notice` VALUES (5, 55, 1, '2025-05-04 20:14:03');
INSERT INTO `order_notice` VALUES (6, 55, 1, '2025-05-04 20:14:09');
INSERT INTO `order_notice` VALUES (7, 56, 1, '2025-05-04 23:53:02');
INSERT INTO `order_notice` VALUES (8, 56, 1, '2025-05-04 23:53:06');
INSERT INTO `order_notice` VALUES (9, 56, 1, '2025-05-04 23:53:15');
INSERT INTO `order_notice` VALUES (10, 56, 1, '2025-05-04 23:53:22');
INSERT INTO `order_notice` VALUES (11, 56, 1, '2025-05-04 23:55:14');
INSERT INTO `order_notice` VALUES (12, 57, 1, '2025-05-04 23:57:45');
INSERT INTO `order_notice` VALUES (13, 57, 1, '2025-05-04 23:58:01');
INSERT INTO `order_notice` VALUES (14, 57, 1, '2025-05-04 23:58:20');
INSERT INTO `order_notice` VALUES (15, 58, 1, '2025-05-05 07:13:46');
INSERT INTO `order_notice` VALUES (16, 58, 1, '2025-05-05 07:13:50');
INSERT INTO `order_notice` VALUES (17, 58, 1, '2025-05-05 07:14:09');
INSERT INTO `order_notice` VALUES (18, 58, 1, '2025-05-05 07:14:15');
INSERT INTO `order_notice` VALUES (19, 58, 1, '2025-05-05 07:14:26');
INSERT INTO `order_notice` VALUES (20, 59, 0, '2025-05-05 18:09:31');
INSERT INTO `order_notice` VALUES (21, 59, 0, '2025-05-05 18:09:49');
INSERT INTO `order_notice` VALUES (22, 59, 0, '2025-05-05 18:10:09');
INSERT INTO `order_notice` VALUES (23, 59, 0, '2025-05-05 18:10:26');
INSERT INTO `order_notice` VALUES (24, 59, 0, '2025-05-05 18:10:36');
INSERT INTO `order_notice` VALUES (25, 60, 1, '2025-05-06 17:27:17');
INSERT INTO `order_notice` VALUES (26, 60, 1, '2025-05-06 17:28:06');
INSERT INTO `order_notice` VALUES (27, 60, 1, '2025-05-06 17:31:14');
INSERT INTO `order_notice` VALUES (28, 60, 1, '2025-05-06 17:31:18');
INSERT INTO `order_notice` VALUES (29, 61, 0, '2025-05-06 17:36:01');
INSERT INTO `order_notice` VALUES (30, 61, 0, '2025-05-06 17:36:04');
INSERT INTO `order_notice` VALUES (31, 61, 0, '2025-05-06 17:36:06');
INSERT INTO `order_notice` VALUES (32, 62, 1, '2025-05-06 17:36:36');
INSERT INTO `order_notice` VALUES (33, 62, 1, '2025-05-06 17:36:47');
INSERT INTO `order_notice` VALUES (34, 62, 1, '2025-05-06 17:36:51');
INSERT INTO `order_notice` VALUES (35, 62, 1, '2025-05-06 17:36:58');
INSERT INTO `order_notice` VALUES (36, 63, 1, '2025-05-06 17:37:28');
INSERT INTO `order_notice` VALUES (37, 63, 1, '2025-05-06 17:37:29');
INSERT INTO `order_notice` VALUES (38, 63, 1, '2025-05-06 17:37:33');
INSERT INTO `order_notice` VALUES (39, 63, 1, '2025-05-06 17:37:40');
INSERT INTO `order_notice` VALUES (40, 63, 1, '2025-05-06 17:37:48');
INSERT INTO `order_notice` VALUES (41, 64, 0, '2025-05-06 17:41:10');
INSERT INTO `order_notice` VALUES (42, 65, 0, '2025-05-06 17:46:51');
INSERT INTO `order_notice` VALUES (43, 66, 0, '2025-05-06 17:51:18');
INSERT INTO `order_notice` VALUES (44, 67, 0, '2025-05-06 18:00:42');
INSERT INTO `order_notice` VALUES (45, 62, 0, '2025-05-06 18:00:52');
INSERT INTO `order_notice` VALUES (46, 68, 0, '2025-05-06 21:28:17');
INSERT INTO `order_notice` VALUES (47, 69, 0, '2025-05-06 21:28:20');
INSERT INTO `order_notice` VALUES (48, 66, 0, '2025-05-06 21:42:06');
INSERT INTO `order_notice` VALUES (49, 66, 0, '2025-05-06 21:42:24');
INSERT INTO `order_notice` VALUES (50, 66, 0, '2025-05-06 21:42:29');
INSERT INTO `order_notice` VALUES (51, 65, 0, '2025-05-06 21:42:34');
INSERT INTO `order_notice` VALUES (52, 64, 0, '2025-05-06 21:42:41');
INSERT INTO `order_notice` VALUES (53, 70, 0, '2025-05-06 21:48:16');
INSERT INTO `order_notice` VALUES (54, 71, 0, '2025-05-06 21:49:27');
INSERT INTO `order_notice` VALUES (55, 72, 0, '2025-05-06 21:51:44');
INSERT INTO `order_notice` VALUES (56, 72, 0, '2025-05-06 21:51:50');

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `pay_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `pay_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单状态',
  `business_id` int NULL DEFAULT NULL,
  `user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_id` int NULL DEFAULT NULL,
  `amount` decimal(10, 2) NULL DEFAULT NULL,
  `discount` decimal(10, 2) NULL DEFAULT NULL,
  `actual` decimal(10, 2) NULL DEFAULT NULL,
  `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 73 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (56, '1919057692396625920', '2025-05-04 23:52:58', '2025-05-04 23:53:06', '支付宝', 'complete', 13, '123', '123', '123', 15, 112.00, 9.60, 102.40, '', 'http://localhost:9090/files/1746373914232-屏幕截图 2024-10-31 095108.png', '123等2件商品');
INSERT INTO `orders` VALUES (57, '1919058880097689600', '2025-05-04 23:57:46', '2025-05-04 23:58:01', '支付宝', 'refunded', 13, '123', '123', '123', 15, 24.00, 19.20, 4.80, '', 'http://localhost:9090/files/1746373914232-屏幕截图 2024-10-31 095108.png', '123等2件商品');
INSERT INTO `orders` VALUES (58, '1919168603423072256', '2025-05-05 07:13:46', '2025-05-05 07:13:50', '支付宝', 'complete', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (59, '1919333631844282368', '2025-05-05 18:09:26', '2025-05-05 18:09:49', '支付宝', 'complete', 12, '123', '123', '123', 15, 1111.00, 0.00, 1111.00, '', 'http://localhost:9090/files/1746439743340-屏幕截图 2024-10-20 203213.png', '12345等1件商品');
INSERT INTO `orders` VALUES (60, '1919685379160723456', '2025-05-06 17:27:09', '2025-05-06 17:28:04', '支付宝', 'awaitcomments', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (62, '1919687725311774720', '2025-05-06 17:36:34', '2025-05-06 17:36:45', '支付宝', 'complete', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (63, '1919687942320869376', '2025-05-06 17:37:26', '2025-05-06 17:37:27', '支付宝', 'complete', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (64, '1919688882667048960', '2025-05-06 17:41:03', NULL, '支付宝', 'awaitshipping', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (65, '1919690311242764288', '2025-05-06 17:46:45', NULL, '支付宝', 'awaitshipping', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (66, '1919691434632646656', '2025-05-06 17:51:06', NULL, '支付宝', 'awaitcomments', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (67, '1919693799129546752', '2025-05-06 18:00:37', NULL, '支付宝', 'awaitpayment', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (68, '1919746038782795776', '2025-05-06 21:28:06', NULL, '支付宝', 'awaitpayment', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (69, '1919746049478270976', '2025-05-06 21:28:08', NULL, '支付宝', 'awaitpayment', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (70, '1919751067098992640', '2025-05-06 21:48:11', NULL, '支付宝', 'awaitpayment', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (71, '1919751364303151104', '2025-05-06 21:49:22', NULL, '支付宝', 'awaitpayment', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');
INSERT INTO `orders` VALUES (72, '1919751940592181248', '2025-05-06 21:51:39', '2025-05-06 21:51:50', '支付宝', 'awaitshipping', 13, '1', '1234123', '123', 14, 100.00, 0.00, 100.00, '', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 'test1等1件商品');

-- ----------------------------
-- Table structure for orders_item
-- ----------------------------
DROP TABLE IF EXISTS `orders_item`;
CREATE TABLE `orders_item`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_id` int NULL DEFAULT NULL,
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `goods_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `price` decimal(10, 2) NULL DEFAULT NULL,
  `num` int NULL DEFAULT NULL,
  `goods_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders_item
-- ----------------------------
INSERT INTO `orders_item` VALUES (2, NULL, 'ThaiTEA', NULL, 110.70, 1, NULL);
INSERT INTO `orders_item` VALUES (3, NULL, 'ThaiTEA', NULL, 110.70, 1, NULL);
INSERT INTO `orders_item` VALUES (4, NULL, 'ThaiTEA', NULL, 110.70, 1, NULL);
INSERT INTO `orders_item` VALUES (5, NULL, 'BOBo', NULL, 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (6, 2, 'BOBo', NULL, 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (7, 3, 'BOBo', NULL, 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (8, 4, 'BOBo', NULL, 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (9, 5, 'BOBo', NULL, 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (10, 6, 'BOBo', NULL, 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (11, 7, 'BOBo', NULL, 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (12, 8, 'ThaiTEA', NULL, 110.70, 1, NULL);
INSERT INTO `orders_item` VALUES (13, 8, 'ThaiTEA', NULL, 110.70, 1, NULL);
INSERT INTO `orders_item` VALUES (14, 9, 'ThaiTEA', NULL, 110.70, 1, NULL);
INSERT INTO `orders_item` VALUES (15, 10, 'ThaiTEA', NULL, 110.70, 1, NULL);
INSERT INTO `orders_item` VALUES (16, 11, 'ThaiTEA', NULL, 110.70, 1, NULL);
INSERT INTO `orders_item` VALUES (17, 12, 'BOBo', NULL, 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (18, 13, 'BOBo', NULL, 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (19, 14, 'ThaiTEA', NULL, 110.70, 1, NULL);
INSERT INTO `orders_item` VALUES (20, 15, 'ThaiTEA', NULL, 110.70, 1, NULL);
INSERT INTO `orders_item` VALUES (21, 16, 'BOBo', 'http://localhost:9090/files/1713835431035-OIP-C.jpg', 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (22, 17, 'BOBo', 'http://localhost:9090/files/1713835431035-OIP-C.jpg', 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (24, 19, 'BOBo', 'http://localhost:9090/files/1713835431035-OIP-C.jpg', 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (26, 21, 'BOBo', 'http://localhost:9090/files/1713835431035-OIP-C.jpg', 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (27, 22, 'ThaiTEA', NULL, 110.70, 1, NULL);
INSERT INTO `orders_item` VALUES (29, 24, 'BOBo', 'http://localhost:9090/files/1713835431035-OIP-C.jpg', 115.20, 1, NULL);
INSERT INTO `orders_item` VALUES (39, 56, '123', 'http://localhost:9090/files/1746373914232-屏幕截图 2024-10-31 095108.png', 2.40, 1, 41);
INSERT INTO `orders_item` VALUES (40, 56, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (41, 57, '123', 'http://localhost:9090/files/1746373914232-屏幕截图 2024-10-31 095108.png', 2.40, 1, 41);
INSERT INTO `orders_item` VALUES (42, 57, '123', 'http://localhost:9090/files/1746373914232-屏幕截图 2024-10-31 095108.png', 2.40, 1, 41);
INSERT INTO `orders_item` VALUES (43, 58, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (44, 59, '12345', 'http://localhost:9090/files/1746439743340-屏幕截图 2024-10-20 203213.png', 1111.00, 1, 43);
INSERT INTO `orders_item` VALUES (45, 60, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (47, 62, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (48, 63, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (49, 64, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (50, 65, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (51, 66, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (52, 67, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (53, 68, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (54, 69, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (55, 70, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (56, 71, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);
INSERT INTO `orders_item` VALUES (57, 72, 'test1', 'http://localhost:9090/files/1746373808201-Screenshot 2023-09-05 200343.png', 100.00, 1, 38);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `gender` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `business_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `company_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `registration_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `is_active` int NULL DEFAULT 1 COMMENT '是否禁用 0 禁用 1启用',
  `last_login` datetime NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Awaitingreview',
  `question` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '找回密码问题',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '$2a$10$ZNCJ8HujbwIxkTla3UatcOwPe7F7Vq3ahxa9AV7Nn.lhK4ChIsoCi', '管理员', 'http://localhost:9090/files/1746399775773-6d8dd1b2a8ae610d2315287082729cf3.jpg', 'ADMIN', '女', '13677889922', 'admin@xm.com', NULL, NULL, NULL, NULL, NULL, '2025-04-28 22:28:34', 1, NULL, NULL, NULL);
INSERT INTO `user` VALUES (12, 'sj3', '$2a$10$jrgLVq8uaqfti82EA/qzOeOB2xxhvtume1P20aWopk7C1tuAXawdK', 'sj3', NULL, 'BUSINESS', NULL, '13412341231', NULL, '123', NULL, NULL, NULL, NULL, '2025-04-30 16:48:52', 1, NULL, 'pass', NULL);
INSERT INTO `user` VALUES (13, 'sj1', '$2a$10$ARMnpUF.JpwGxitT/qmf2eS71Ktg9wwaT2NPYHF300ihH9HS.Jc86', 'sj1', 'http://localhost:9090/files/1746371426355-微信图片_20231109180909.jpg', 'BUSINESS', NULL, '123123', NULL, '123123', '商家啊1111', NULL, NULL, NULL, '2025-05-01 13:31:00', 1, NULL, 'pass', NULL);
INSERT INTO `user` VALUES (14, 'qwe', '$2a$10$vZZYgtYBPYXOOGhlmNEEWuO49/nzh/wIDzq86UgAvXyipEdsBtyty', 'qwe', 'http://localhost:9090/files/1746432379898-6d8dd1b2a8ae610d2315287082729cf3.jpg', 'CUSTOMER', 'male', '13412341234', NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-01 13:34:23', 1, NULL, 'Awaitingreview', NULL);
INSERT INTO `user` VALUES (15, 'zdw', '$2a$10$kbHZ7swu4emEzj4rQCwdnulChTNcFxjphvITkIUhReSWFnyXZQqqG', 'zdw', 'http://localhost:9090/files/1746371739734-I31U8lYynzK87f158b6abf7b983fe0bf6433ec47dca9.png', 'CUSTOMER', '女', '1234', NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-04 23:05:15', 0, NULL, 'Awaitingreview', NULL);
INSERT INTO `user` VALUES (16, 'sj2', '$2a$10$RAaJbjkS.UwT9RMUp9e73uUrnmQZ/jq1FKxNl3sCbCPxMOy2lhr3O', 'sj2', NULL, 'BUSINESS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-05 00:17:36', 0, NULL, 'Awaitingreview', NULL);
INSERT INTO `user` VALUES (17, 'sj4', '$2a$10$h26yNIq0R8YU6zBPS6qV.e0oatxw2OQEPGroCGnBwR4N2NDa/BG5W', 'sj4', NULL, 'BUSINESS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-05 00:33:25', 0, NULL, 'Awaitingreview', '[\n    {\n        \"question\": \"我喜欢什么看什么电影?\",\n        \"answer\": \"无间道\"\n    },\n    {\n        \"question\": \"我喜欢吃什么?\",\n        \"answer\": \"西瓜\"\n    }\n]');
INSERT INTO `user` VALUES (18, 'qwe1', '$2a$10$hogKGluLhnhmhtdSTAzwZuWzZRZNJGv8qXnryYDv5Nags0b2Mje1e', 'qwe1', NULL, 'CUSTOMER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-05 16:28:27', 0, NULL, 'Awaitingreview', NULL);
INSERT INTO `user` VALUES (19, 'qwe2', '$2a$10$sLp7JnuOF.6OzZNh2A52rOdyaOE61flFbxoIPSDiLfXL8hP2axFym', 'qwe2', NULL, 'CUSTOMER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-05 16:31:06', 0, NULL, 'Awaitingreview', NULL);
INSERT INTO `user` VALUES (20, 'qwe3', '$2a$10$OKcfRIAmGFxAGOC8tWqE.eJMFV2nwPrBs3SKgSLEAEMsv3gP9mcU6', 'qwe3', NULL, 'CUSTOMER', '女', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-05 16:36:59', 0, NULL, 'Awaitingreview', '[{\"question\":\"1\",\"answer\":\"1\"},{\"question\":\"2\",\"answer\":\"2\"}]');
INSERT INTO `user` VALUES (21, 'sj5', '$2a$10$/J2o72gY894vQgyu4pj7/.aGuESger5qk84UOGJk6NvLgbZRy2dKi', 'sj5', NULL, 'BUSINESS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-05 16:51:33', 0, NULL, 'Awaitingreview', '[{\"question\":\"1\",\"answer\":\"1\"},{\"question\":\"2\",\"answer\":\"2\"}]');
INSERT INTO `user` VALUES (22, 'test1', '$2a$10$IdTC3UocYP97opvcdKz64eRo/Q22zdHv9d2h4zPVK5DlzkdfUC6Nu', 'test1', NULL, 'BUSINESS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-05 19:48:58', 1, NULL, 'Awaitingreview', '[{\"question\":\"111\",\"answer\":\"111\"},{\"question\":\"1112\",\"answer\":\"1112\"}]');

SET FOREIGN_KEY_CHECKS = 1;
