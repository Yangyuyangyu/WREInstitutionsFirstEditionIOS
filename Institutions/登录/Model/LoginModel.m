//
//  loginModel.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "LoginModel.h"
#import "NetworkingManager.h"

@implementation LoginModel

- (void)smsCodeInfoList:(NSString *)mobile{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/smsCode?mobile=%@",Basicurl,mobile];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"验证码成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"smsCodeInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"验证码失败%@",object);
    }];
}

- (void)registerInfoList:(NSString *)account name:(NSString *)name mobile:(NSString *)mobile pass:(NSString *)pass code:(NSString *)code log_id:(NSString *)log_id type:(NSString *)type{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/register",Basicurl];
    NSDictionary *dic = @{@"account":account ,@"name":name ,@"mobile":mobile,@"pass":pass,@"code":code,@"type":type,@"log_id":log_id};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"注册成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"registerInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"注册失败%@",object);
    }];
}

- (void)loginInfoList:(NSString *)mobile pass:(NSString *)pass{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/login?mobile=%@&pass=%@",Basicurl,mobile,pass];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        
        NSDictionary *dic = [self deleteAllNullValue:object];
        XNLog(@"登录成功%@",dic);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginInfoList" object:nil userInfo:dic];
    } failureBlock:^(id object) {
        XNLog(@"登录失败%@",object);
    }];
}

- (void)editPwdInfoList:(NSString *)mobile pass:(NSString *)pass code:(NSString *)code log_id:(NSString *)log_id{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/editPwd",Basicurl];
    NSDictionary *dic = @{@"mobile":mobile,@"pass":pass,@"code":code,@"log_id":log_id};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"忘记密码成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editPwdInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"忘记密码失败%@",object);
    }];
}
/*!
 *  @brief 去除字典空值
 */
- (NSDictionary *)deleteAllNullValue:(NSDictionary *)dic
{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in dic.allKeys) {
        if ([[dic  objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[dic objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

@end
