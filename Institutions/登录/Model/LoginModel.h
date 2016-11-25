//
//  loginModel.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
/*!
 *  @brief 短信验证码
 */
- (void)smsCodeInfoList:(NSString *)mobile;
/*!
 *  @brief 注册
 *
 *  @param account 账号
 *  @param name    机构名称
 *  @param mobile  手机号码
 *  @param pass    密码
 *  @param code    验证码
 *  @param log_id  短信记录id
 */
- (void)registerInfoList:(NSString *)account name:(NSString *)name mobile:(NSString *)mobile pass:(NSString *)pass code:(NSString *)code log_id:(NSString *)log_id type:(NSString *)type;
/*!
 *  @brief 登录
 *
 *  @param mobile 手机号码
 *  @param pass   密码
 */
- (void)loginInfoList:(NSString *)mobile pass:(NSString *)pass;
/*!
 *  @brief 忘记密码
 *
 *  @param mobile 手机号码
 *  @param pass   密码
 *  @param code   验证码
 *  @param log_id 短信记录id
 */
- (void)editPwdInfoList:(NSString *)mobile pass:(NSString *)pass code:(NSString *)code log_id:(NSString *)log_id;

@end
