//
//  HomeModel.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
/*!
 *  @brief 首页统计老师和课程数
 */
- (void)countInfoList;
/*!
 *  @brief 查询已加入该机构的老师
 */
- (void)myTeacherInfoList;
/*!
 *  @brief 老师基本信息
 *
 *  @param teacherId 老师Id
 */
- (void)teacherInfoList:(NSString *)teacherId;
/*!
 *  @brief 搜索已有老师
 *
 *  @param mobile 手机号
 */
- (void)chooseInfoList:(NSString *)mobile;
/*!
 *  @brief 选择老师后保存
 *
 *  @param teacherId 老师id
 */
- (void)saveInfoList:(NSString *)teacherId;
/*!
 *  @brief 直接新增老师
 *
 *  @param head_img 头像
 *  @param name     姓名
 *  @param mobile   手机号
 *  @param pass     密码
 *  @param email    邮箱
 *  @param feature  特点
 *  @param intro    简介
 */
- (void)addTeacherInfoList:(NSString *)head_img name:(NSString *)name mobile:(NSString *)mobile pass:(NSString *)pass email:(NSString *)email feature:(NSString *)feature intro:(NSString *)intro;
/*!
 *  @brief 查询已加入机构的学生
 */
- (void)myStudentInfoList;
/*!
 *  @brief 查询已加入机构的学生
 *
 *  @param groupId   社团id
 *  @param sign_time 注册时间
 *  @param name      学生姓名
 *  @param mobile    电话
 */
- (void)myStudentInfoList:(NSString *)subject_id course_id:(NSString *)course_id start_time:(NSString *)start_time end_time:(NSString *)end_time name:(NSString *)name mobile:(NSString *)mobile;
/*!
 *  @brief 学生主页
 *
 *  @param studentId 学生id
 */
- (void)studentInfoList:(NSString *)studentId;
/*!
 *  @brief 搜索已有学生
 *
 *  @param mobile 手机号
 */
- (void)chooseStudentInfoList:(NSString *)mobile;
/*!
 *  @brief 读取已选择的学生信息
 *
 *  @param studentId 学生id
 */
- (void)studentSelectedInfoList:(NSString *)studentId;
/*!
 *  @brief 查询机构下的社团
 */
- (void)getGroupsInfoList;
/*!
 *  @brief 保存学生信息
 *
 *  @param communityId 选择的社团id
 *  @param sid         学生id
 *  @param subject     科目id
 *  @param name        姓名
 *  @param mobile      手机号
 *  @param pass        密码
 *  @param email       邮箱
 */
- (void)addStudentInfoList:(NSString *)communityId sid:(NSString *)sid subject:(NSString *)subject name:(NSString *)name mobile:(NSString *)mobile pass:(NSString *)pass email:(NSString *)email;
/*!
 *  @brief 课程列表
 */
- (void)myCourseInfoList;
/*!
 *  @brief 课程详情
 *
 *  @param courseId 课程id
 */
- (void)courseInfoList:(NSString *)courseId;
/*!
 *  @brief 上课点名数据
 *
 *  @param classId 上课记录id
 */
- (void)callInfoList:(NSString *)classId;
/*!
 *  @brief 社团建设下的社团列表
 */
- (void)groupBuildInfoList;
/*!
 *  @brief 查询管理员
 */
- (void)myAdminInfoList;
/*!
 *  @brief 保存修改后的管理员
 *
 *  @param groupId 社团id
 *  @param adminId 管理员id
 */
- (void)saveAdminInfoList:(NSString *)groupId adminId:(NSString *)adminId;
/*!
 *  @brief 社团的科目
 *
 *  @param communityId 社团id
 */
- (void)subjectOfGroupInfoList:(NSString *)communityId;
/*!
 *  @brief 资金管理
 */
- (void)financeInfoList;
/*!
 *  @brief 提现时查询银行卡
 */
- (void)cashAccountInfoList;
/*!
 *  @brief 保存提现申请
 *
 *  @param money   金额
 *  @param account 银行卡id
 */
- (void)addCashInfoList:(NSString *)money account:(NSString *)account;
/*!
 *  @brief 课程表
 */
- (void)courseListInfoList:(NSString *)week;
/*!
 *  @brief 机构下的所有科目
 */
- (void)mySubjectInfoList;
/*!
 *  @brief 选择社团后查询科目
 */
- (void)subjectListInfoList:(NSString *)communityId;
/*!
 *  @brief 选择科目后查询课程
 *
 *  @param subjectId 科目id
 */
- (void)coursesInfoList:(NSString *)subjectId;
@end
