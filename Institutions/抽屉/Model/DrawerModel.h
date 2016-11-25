//
//  DrawerModel.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/17.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawerModel : NSObject
/*!
 *  @brief 机构信息
 */
- (void)infoInfoList;
/*!
 *  @brief 修改信息
 *
 *  @param type    要修改的数据，1修改地址，2修改特点，3修改简介
 *  @param content 内容
 */
- (void)editInfoList:(NSString *)type content:(NSString *)content;
/*!
 *  @brief 已绑定的银行卡
 */
- (void)myCardsInfoList;
/*!
 *  @brief 添加银行卡
 *
 *  @param holder 持卡人
 *  @param cardNo 卡号
 *  @param type   银行
 */
- (void)addCardInfoList:(NSString *)holder cardNo:(NSString *)cardNo type:(NSString *)type;
/*!
 *  @brief 解绑银行卡
 *
 *  @param cardId 选择的银行卡id
 */
- (void)delCardInfoList:(NSString *)cardId;
/*!
 *  @brief 修改密码
 *
 *  @param oldPass 旧密码
 *  @param newPass 新密码 
 */
- (void)editPassInfoList:(NSString *)oldPass newPass:(NSString *)newPass;
/*!
 *  @brief 意见反馈
 *
 *  @param content 内容
 *  @param email   邮箱
 */
- (void)feedbackInfoList:(NSString *)content email:(NSString *)email;
/*!
 *  @brief 关于我们
 */
- (void)aboutUsInfoList;
/*!
 *  @brief 排名
 *
 *  @param type    排名类型，日常排名为1，考试排名为2
 *  @param groupId 社团id，当type为1时传入
 *  @param course  课程id，当type为2时传入
 */
- (void)rankInfoList:(NSString *)type groupId:(NSString *)groupId course:(NSString *)course;
@end
