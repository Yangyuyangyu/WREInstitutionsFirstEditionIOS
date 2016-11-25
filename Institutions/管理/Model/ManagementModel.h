//
//  ManagementModel.h
//  Institutions
//
//  Created by waycubeIOSb on 16/6/17.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagementModel : NSObject
/*!
 *  @brief 日常管理
 *
 *  @param type   所进行的管理操作的类型
 *  @param typeId 机构或社团id，有type决定
 */
- (void)manageInfoList:(NSString *)type typeId:(NSString *)typeId;

//新增查询课程报告 id：社团id 查询条件：
//status：审核状态，未审核、通过、拒绝分别传0、1、2
//courseName：课程名称
//teacher：上课老师姓名
//startDate：开始日期
//endDate：结束日期
-(void)manageCheckInfoList:(NSString *)type typeId:(NSString *)typeId status:(NSString*)status
                courseName:(NSString*)courseName teacher:(NSString*)teacher startDate:(NSString*)startDate
                   endDate:(NSString*)endDate;

/*!
 *  @brief 维修搜索
 *
 *  @param typeId     社团id
 *  @param start_date 开始时间
 *  @param end_date   结束时间
 *  @param subject_id 科目id
 *  @param course_id  课程id
 *  @param user       维修人
 */
- (void)manageInfoListMore:(NSString *)typeId start_date:(NSString *)start_date end_date:(NSString *)end_date subject_id:(NSString *)subject_id course_id:(NSString *)course_id user:(NSString *)user;
/*!
 *  @brief 动态管理
 */
- (void)newsInfoList;
/*!
 *  @brief 添加动态
 *
 *  @param name   标题
 *  @param type   社团id
 *  @param img    图片
 *  @param brief  简介
 *  @param detail 详情
 */
- (void)addNewsInfoList:(NSString *)name type:(NSString *)type img:(NSString *)img brief:(NSString *)brief detail:(NSString *)detail;
/*!
 *  @brief 动态详情
 *
 *  @param dynamicId 动态id
 */
- (void)newsDetailInfoList:(NSString *)dynamicId;
/*!
 *  @brief 课程规划
 *
 *  @param groupId 社团id
 */
- (void)coursePlanInfoList:(NSString *)groupId;
/*!
 *  @brief 添加课程规划
 *
 *  @param groupId 社团id
 *  @param content 内容
 */
- (void)addTrainInfoList:(NSString *)groupId content:(NSString *)content;
/*!
 *  @brief 请假数据
 */
- (void)leaveDataInfoList;
/*!
 *  @brief 请假详情
 *
 *  @param recordId 请假详情Id
 */
- (void)leaveInfoInfoList:(NSString *)recordId;
/*!
 *  @brief 请假审批
 *
 *  @param recordId 请假记录ID
 *  @param result   结果，通过传1，拒绝传2
 *  @param refuse   拒绝原因
 */
- (void)leaveAuthInfoList:(NSString *)recordId result:(NSString *)result refuse:(NSString *)refuse;
/*!
 *  @brief 临时账号数据
 */
- (void)tmpAccountInfoList;
/*!
 *  @brief 临时账号详情
 *
 *  @param temporaryId 临时帐号数据id
 */
- (void)tmpInfoInfoList:(NSString *)temporaryId;
/*!
 *  @brief 临时账号审核
 *
 *  @param dataId 数据id
 *  @param result 结果，通过传1，拒绝传2
 *  @param refuse 拒绝原因
 */
- (void)tmpAuthInfoList:(NSString *)dataId result:(NSString *)result refuse:(NSString *)refuse;
/*!
 *  @brief 乐器维修记录
 *
 *  @param user       报修人
 *  @param subject    科目id
 *  @param instrument 维修器材
 */
- (void)repairInfoList:(NSString *)user subject:(NSString *)subject instrument:(NSString *)instrument;
/*!
 *  @brief 维修详情
 *
 *  @param dataId 数据id
 */
- (void)repairInfoInfoList:(NSString *)dataId;
/*!
 *  @brief 添加维修记录
 *
 *  @param user_name  报修人
 *  @param subject    科目id
 *  @param group      社团id
 *  @param instrument 乐器
 *  @param remark     说明
 */
- (void)addRepairInfoList:(NSString *)user_name subject:(NSString *)subject course:(NSString *)course group:(NSString *)group instrument:(NSString *)instrument remark:(NSString *)remark;
/*!
 *  @brief 追访记录
 *
 *  @param communityId 社团id
 */
- (void)followUpInfoList:(NSString *)communityId;
/*!
 *  @brief 追访详情
 *
 *  @param dataId 数据id
 */
- (void)followInfoInfoList:(NSString *)dataId;
/*!
 *  @brief 添加追访
 *
 *  @param student  学生
 *  @param teacher  老师
 *  @param groupId  社团id
 *  @param content  内容
 *  @param feedback 反馈
 *  @param solution 解决办法
 *  @param reason   原因
 *  @param solved   是否解决1是，2否
 */
- (void)addFollowInfoList:(NSString *)student teacher:(NSString *)teacher groupId:(NSString *)groupId content:(NSString *)content feedback:(NSString *)feedback solution:(NSString *)solution reason:(NSString *)reason solved:(NSString *)solved;
/*!
 *  @brief 更改追访记录状态
 *
 *  @param changeId 追访记录id
 */
- (void)changeFollowStateInfoList:(NSString *)changeId;
/*!
 *  @brief 修改社团打分项
 *
 *  @param groupId 社团id
 *  @param item    项目，多个用逗号隔开
 */
- (void)scoreItemInfoList:(NSString *)groupId item:(NSString *)item;
/*!
 *  @brief 其他课
 */
- (void)otherCourseInfoList;
/*!
 *  @brief 其他课详情
 *
 *  @param dataId 数据详情
 */
- (void)otherInfoInfoList:(NSString *)dataId;
/*!
 *  @brief 添加其他课
 *
 *  @param name      名称
 *  @param time      上课时间
 *  @param advice    老师意见
 *  @param execution 执行情况
 */
- (void)addOtherInfoList:(NSString *)name time:(NSString *)time advice:(NSString *)advice execution:(NSString *)execution;
/*!
 *  @brief 审核报告时查询社团
 */
- (void)reportGroupInfoList;
/*!
 *  @brief 课程报告列表
 *
 *  @param groupId 社团id
 */
- (void)courseReportInfoList:(NSString *)groupId;
/*!
 *  @brief 课程报告详情
 *
 *  @param dataId 数据id
 */
- (void)reportInfoInfoList:(NSString *)dataId;
/*!
 *  @brief 打分详情
 *
 *  @param report 课程报告id
 */
- (void)scoreInfoInfoList:(NSString *)report;
/*!
 *  @brief 审核报告
 *
 *  @param dataId 数据id
 *  @param result 通过1，拒绝2
 *  @param reason 拒绝原因
 */
- (void)reportAuthInfoList:(NSString *)dataId result:(NSString *)result reason:(NSString *)reason;
/*!
 *  @brief 考试列表
 */
- (void)examListInfoList;
/*!
 *  @brief 添加考试
 *
 *  @param courseId 课程id
 *  @param time     考试时间
 */
- (void)addExamInfoList:(NSString *)courseId time:(NSString *)time;
/*!
 *  @brief 录入成绩时查询学生
 *
 *  @param examId 考试记录id
 */
- (void)examStudentInfoList:(NSString *)examId;
/*!
 *  @brief 保存成绩
 *
 *  @param examId 考试记录id
 *  @param sid    学生id
 *  @param score  成绩
 */
- (void)saveScoreInfoList:(NSString *)examId sid:(NSString *)sid score:(NSString *)score;
/*!
 *  @brief 管理制度详情
 *
 *  @param groupId 社团id
 */
- (void)ruleInfoList:(NSString *)groupId;
/*!
 *  @brief 添加管理制度
 *
 *  @param groupId 社团id
 *  @param name    标题
 *  @param img     图片
 *  @param detail  详情
 */
- (void)addRuleInfoList:(NSString *)groupId name:(NSString *)name img:(NSString *)img detail:(NSString *)detail;
/*!
 *  @brief 上传头像
 *
 *  @param name 图片
 */
- (void)imgUploadInfokInfoList:(NSData *)name;
/*!
 *  @brief 查询课程下的学生
 *
 *  @param courseId 课程id
 */
- (void)studentOfCourseInfoList:(NSString *)courseId;

/**
 *  获取课程报告详情 学生列表
 *
 *  @param courseId 课程id
 */
-(void)getCourseStudentInfo:(NSString*)courseId;
@end
