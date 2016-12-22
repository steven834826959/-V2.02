//
//  YTUserModel.h
//  爱理不离
//
//  Created by ios on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface YTUserModel : NSObject
singleton_interface(YTUserModel)

@property(nonatomic,copy)NSString *ID;//身份id

/**
 昵称
 */
@property(nonatomic,copy)NSString *nickName;//昵称
/**
 真实姓名
 */
@property(nonatomic,copy)NSString *realName;//真名
/**
 头像
 */
@property(nonatomic,copy)NSString *avatar;//头像
/**
 性别
 */
@property(nonatomic,assign)int gender;//性别
@property(nonatomic,copy)NSString *password;//密码
/**
 邮件
 */
@property(nonatomic,copy)NSString *email;//邮件

@property(nonatomic,assign)int isCertification;//是否认证

@property(nonatomic,copy)NSString *idCard;//身份证
/**
 地区
 */
@property(nonatomic,copy)NSString *city;//地址
@property(nonatomic,copy)NSString *createTime;//创建时间
@property(nonatomic,copy)NSString *credits;
@property(nonatomic,copy)NSString *deviceNum;
/**
 是否恋爱过
 */
@property(nonatomic,assign)int isLoved;
/**
 情感状态
 */
@property(nonatomic,assign)int loveStatus;
/**
 手机号
 */
@property(nonatomic,copy)NSString *mobile;
/**
 配偶生日
 */
@property(nonatomic,copy)NSString *birthday;
/**
 恋爱日期
 */
@property(nonatomic,copy)NSString *loverBirthday;
/**
 结婚日期
 */
@property(nonatomic,copy)NSString *marriedDate;

/**
 分手日期
 */
@property(nonatomic,copy)NSString *breakDate;


/**
 支付账号
 */
@property(nonatomic,copy)NSString *payAccount;
/**
 支付密码
 */
@property(nonatomic,copy)NSString *payPassword;

/**
 邀请码
 */
@property(nonatomic,copy)NSString *inviteCode;
@end

/*
 
 ---------登录后拿到个人信息 {
 avatar = "<null>";
 birthday = "<null>";
 breakDate = "<null>";
 city = "<null>";
 createTime = 1479975578000;
 credits = "<null>";
 deviceId = "<null>";
 deviceNum = 111;
 email = "<null>";
 gender = "<null>";
 id = 3;
 idCard = "<null>";
 isCertification = "<null>";
 isLoved = "<null>";
 loginFromIp = "101.81.89.185";
 loginTime = 1481246696831;
 loveStatus = 1;
 loverBirthday = "<null>";
 marriedDate = "<null>";
 mobile = 13012875055;
 nickName = "<null>";
 password = ad73363dff3189101a0983a2b4cf0e9e843b0c84;
 payAccount = "<null>";
 payCreateTime = "<null>";
 payPassword = "<null>";
 postAddress = "<null>";
 realName = "<null>";
 recommendMobile = "<null>";
 status = 1;
 tm = "<null>";
 versionNum = "<null>";
 }

 */






