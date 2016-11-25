//
//  DrawerModel.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/17.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "DrawerModel.h"
#import "NetworkingManager.h"

@implementation DrawerModel

- (void)infoInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/info?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"机构信息成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"infoInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"机构信息失败%@",object);
    }];
}

- (void)editInfoList:(NSString *)type content:(NSString *)content{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/editInfo",Basicurl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSDictionary *dic = @{@"id":uid ,@"type":type, @"content":content};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"修改信息成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"修改信息失败%@",object);
    }];
}

- (void)myCardsInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/myCards?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"已绑定的银行卡成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"myCardsInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"已绑定的银行卡失败%@",object);
    }];
}

- (void)addCardInfoList:(NSString *)holder cardNo:(NSString *)cardNo type:(NSString *)type{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/addCard",Basicurl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSDictionary *dic = @{@"id":uid ,@"holder":holder, @"cardNo":cardNo, @"type":type};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"添加银行卡成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addCardInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"添加银行卡失败%@",object);
    }];
}

- (void)delCardInfoList:(NSString *)cardId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/delCard",Basicurl];
    NSDictionary *dic = @{@"id":cardId};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"解绑银行卡成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"delCardInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"解绑银行卡失败%@",object);
    }];
}

- (void)editPassInfoList:(NSString *)oldPass newPass:(NSString *)newPass{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/editPass",Basicurl];
    NSDictionary *dic = @{@"id":uid, @"oldPass":oldPass,@"newPass":newPass};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"修改密码成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editPassInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"修改密码失败%@",object);
    }];
}

- (void)feedbackInfoList:(NSString *)content email:(NSString *)email{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/feedback",Basicurl];
    NSDictionary *dic = @{@"id":uid, @"content":content,@"email":email};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"意见反馈成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"feedbackInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"意见反馈失败%@",object);
    }];
}

- (void)aboutUsInfoList{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/aboutUs",Basicurl];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"关于我们成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"aboutUsInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"关于我们失败%@",object);
    }];
}

- (void)rankInfoList:(NSString *)type groupId:(NSString *)groupId course:(NSString *)course{
    NSString *uid = @"";
    if (type.length == 0) {
        uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    }
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/rank?id=%@&type=%@&groupId=%@&course=%@",Basicurl,uid,type,groupId,course];
    NSLog(@"%@",urlstr);
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"排名成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rankInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"排名失败%@",object);
    }];
}
@end
