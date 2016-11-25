//
//  ManagementModel.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/17.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ManagementModel.h"
#import "NetworkingManager.h"
#import "AFNetworking.h"

@implementation ManagementModel

- (void)manageInfoList:(NSString *)type typeId:(NSString *)typeId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/manage?type=%@&id=%@",Basicurl,type,typeId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"日常管理成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"manageInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"日常管理失败%@",object);
    }];
}

//新增查询
-(void)manageCheckInfoList:(NSString *)type typeId:(NSString *)typeId status:(NSString *)status courseName:(NSString *)courseName teacher:(NSString *)teacher startDate:(NSString *)startDate endDate:(NSString *)endDate{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/manage?type=%@&id=%@&status=%@&courseName=%@&teacher=%@&startDate=%@&endDate=%@",Basicurl,type,typeId,status,courseName,teacher,startDate,endDate];
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"查询课程报告%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"manageCheckInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"查询失败%@",object);
    }];
}

- (void)manageInfoListMore:(NSString *)typeId start_date:(NSString *)start_date end_date:(NSString *)end_date subject_id:(NSString *)subject_id course_id:(NSString *)course_id user:(NSString *)user{
    NSString *reason_ = [user stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (subject_id.length != 0 || start_date.length != 0 || end_date.length != 0 || course_id.length != 0 || user.length != 0) {
        typeId = @"";
    }
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/manage?type=%@&id=%@&start_date=%@&end_date=%@&subject_id=%@&course_id=%@&user=%@",Basicurl,@"5",typeId,start_date,end_date,subject_id,course_id,reason_];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"搜索维修成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"manageInfoListMore" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"搜索维修失败%@",object);
    }];
}

- (void)newsInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/news?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"动态管理成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newsInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"动态管理失败%@",object);
    }];
}

- (void)addNewsInfoList:(NSString *)name type:(NSString *)type img:(NSString *)img brief:(NSString *)brief detail:(NSString *)detail{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/addNews",Basicurl];
    NSDictionary *dic = @{@"name":name ,@"type":type, @"img":img,@"brief":brief,@"detail":detail};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"添加动态成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewsInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"添加动态失败%@",object);
    }];
}

- (void)newsDetailInfoList:(NSString *)dynamicId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/newsDetail?id=%@",Basicurl,dynamicId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"动态详情成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newsDetailInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"动态详情失败%@",object);
    }];
}

- (void)coursePlanInfoList:(NSString *)groupId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/coursePlan?groupId=%@",Basicurl,groupId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"课程规划成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"coursePlanInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"课程规划失败%@",object);
    }];
}

- (void)addTrainInfoList:(NSString *)groupId content:(NSString *)content{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/addTrain",Basicurl];
    NSDictionary *dic = @{@"groupId":groupId ,@"content":content};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"添加课程规划成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addTrainInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"添加课程规划失败%@",object);
    }];
}

- (void)leaveDataInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/leaveData?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"请假数据成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveDataInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"请假数据失败%@",object);
    }];
}



- (void)leaveInfoInfoList:(NSString *)recordId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/leaveInfo?id=%@",Basicurl,recordId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"请假详情成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveInfoInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"请假详情失败%@",object);
    }];
}

- (void)leaveAuthInfoList:(NSString *)recordId result:(NSString *)result refuse:(NSString *)refuse{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/leaveAuth",Basicurl];
    NSDictionary *dic = @{@"id":recordId ,@"result":result, @"refuse":refuse};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"请假审批成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveAuthInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"请假审批失败%@",object);
    }];
}

- (void)tmpAccountInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/tmpAccount?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"临时账号数据成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tmpAccountInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"临时账号数据失败%@",object);
    }];
}

- (void)tmpInfoInfoList:(NSString *)temporaryId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/tmpInfo?id=%@",Basicurl,temporaryId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"临时账号详情成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tmpInfoInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"临时账号详情失败%@",object);
    }];
}

- (void)tmpAuthInfoList:(NSString *)dataId result:(NSString *)result refuse:(NSString *)refuse{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/tmpAuth",Basicurl];
    NSDictionary *dic = @{@"id":dataId ,@"result":result, @"refuse":refuse};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"临时账号审核成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tmpAuthInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"临时账号审核失败%@",object);
    }];
}

- (void)repairInfoList:(NSString *)user subject:(NSString *)subject instrument:(NSString *)instrument{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/repair?id=%@&user=%@&subject=%@&instrument=%@",Basicurl,uid,user,subject,instrument];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"乐器维修记录成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"repairInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"乐器维修记录失败%@",object);
    }];
}

- (void)repairInfoInfoList:(NSString *)dataId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/repairInfo?id=%@",Basicurl,dataId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"维修详情成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"repairInfoInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"维修详情失败%@",object);
    }];
}

- (void)addRepairInfoList:(NSString *)user_name subject:(NSString *)subject course:(NSString *)course group:(NSString *)group instrument:(NSString *)instrument remark:(NSString *)remark{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/addRepair",Basicurl];
    NSDictionary *dic = @{@"user_name":user_name ,@"subject":subject,@"course":course, @"group":group, @"instrument":instrument, @"remark":remark};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"添加维修记录成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addRepairInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"添加维修记录失败%@",object);
    }];
}


- (void)followUpInfoList:(NSString *)communityId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/followUp?id=%@",Basicurl,communityId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"追访记录成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"followUpInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"追访记录失败%@",object);
    }];
}

- (void)followInfoInfoList:(NSString *)dataId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/followInfo?id=%@",Basicurl,dataId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"追访详情成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"followInfoInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"追访详情失败%@",object);
    }];
}

- (void)addFollowInfoList:(NSString *)student teacher:(NSString *)teacher groupId:(NSString *)groupId content:(NSString *)content feedback:(NSString *)feedback solution:(NSString *)solution reason:(NSString *)reason solved:(NSString *)solved{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/addFollow",Basicurl];
    NSDictionary *dic = @{@"student":student ,@"teacher":teacher, @"groupId":groupId, @"content":content, @"feedback":feedback, @"solution":solution, @"reason":reason, @"solved":solved};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"添加追访成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addFollowInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"添加追访失败%@",object);
    }];
}

- (void)changeFollowStateInfoList:(NSString *)changeId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/changeFollowState",Basicurl];
    NSDictionary *dic = @{@"id":changeId};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"更改追访记录状态成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFollowStateInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"更改追访记录状态失败%@",object);
    }];
}

- (void)scoreItemInfoList:(NSString *)groupId item:(NSString *)item{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/scoreItem",Basicurl];
    NSDictionary *dic = @{@"groupId":groupId, @"item":item};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"修改社团打分项成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scoreItemInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"修改社团打分项失败%@",object);
    }];
}

- (void)otherCourseInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/otherCourse?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"其他课成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"otherCourseInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"其他课失败%@",object);
    }];
}

- (void)otherInfoInfoList:(NSString *)dataId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/otherInfo?id=%@",Basicurl,dataId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"其他课详情成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"otherInfoInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"其他课详情失败%@",object);
    }];
}

- (void)addOtherInfoList:(NSString *)name time:(NSString *)time advice:(NSString *)advice execution:(NSString *)execution{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/addOther",Basicurl];
    NSDictionary *dic = @{@"name":name, @"time":time, @"advice":advice,@"execution":execution};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"添加其他课成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addOtherInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"添加其他课失败%@",object);
    }];
}

- (void)reportGroupInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/getGroups?agencyId=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"审核报告时查询社团成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reportGroupInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"审核报告时查询社团失败%@",object);
    }];
}

- (void)courseReportInfoList:(NSString *)groupId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/courseReport?groupId=%@",Basicurl,groupId];
    XNLog(@"%@",urlstr);
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"课程报告列表成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"courseReportInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"课程报告列表失败%@",object);
    }];
}

- (void)reportInfoInfoList:(NSString *)dataId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/reportInfo?id=%@",Basicurl,dataId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"课程报告详情成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reportInfoInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"课程报告详情失败%@",object);
    }];
}

- (void)scoreInfoInfoList:(NSString *)report{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/scoreInfo?id=%@",Basicurl,report];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"打分详情成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scoreInfoInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"打分详情失败%@",object);
    }];
}

- (void)reportAuthInfoList:(NSString *)dataId result:(NSString *)result reason:(NSString *)reason{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/reportAuth",Basicurl];
    NSDictionary *dic = @{@"id":dataId, @"result":result, @"reason":reason};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"审核报告成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reportAuthInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"审核报告失败%@",object);
    }];
}

- (void)examListInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/examLists?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"考试列表成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"examListInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"考试列表失败%@",object);
    }];
}

- (void)addExamInfoList:(NSString *)courseId time:(NSString *)time{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/addExam",Basicurl];
    NSDictionary *dic = @{@"id":uid, @"courseId":courseId, @"time":time};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"添加考试成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addExamInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"添加考试失败%@",object);
    }];
}

- (void)examStudentInfoList:(NSString *)examId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/examStudent?id=%@",Basicurl,examId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"录入成绩时查询学生成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"examStudentInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"录入成绩时查询学生失败%@",object);
    }];
}

- (void)saveScoreInfoList:(NSString *)examId sid:(NSString *)sid score:(NSString *)score{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/saveScore",Basicurl];
    NSDictionary *dic = @{@"id":examId, @"sid":sid, @"score":score};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"保存成绩成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveScoreInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"保存成绩失败%@",object);
    }];
}

- (void)ruleInfoList:(NSString *)groupId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/rule?id=%@",Basicurl,groupId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"管理制度详情成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ruleInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"管理制度详情失败%@",object);
    }];
}

- (void)addRuleInfoList:(NSString *)groupId name:(NSString *)name img:(NSString *)img detail:(NSString *)detail{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/addRule",Basicurl];
    NSDictionary *dic = @{@"groupId":groupId, @"name":name, @"img":img, @"detail":detail};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"添加管理制度成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addRuleInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"添加管理制度失败%@",object);
    }];
}

- (void)imgUploadInfokInfoList:(NSData *)name {
    
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/CommonApi/imgUpload",Basicurl];
    NSDictionary *dic = @{@"name":name};
    [session POST:urlstr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
        [formData appendPartWithFileData:name name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"%@",uploadProgress);//进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"图片上传接口成功%@",responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imgUploadInfokInfoList" object:nil userInfo:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"图片上传接口失败%@",error);
    }];
    
}

- (void)studentOfCourseInfoList:(NSString *)courseId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/studentOfCourse?id=%@",Basicurl,courseId];
    NSLog(@"%@",urlstr);
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"查询课程下的学生成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"studentOfCourseInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"查询课程下的学生失败%@",object);
    }];
}

-(void)getCourseStudentInfo:(NSString *)courseId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/callInfo2?id=%@",Basicurl,courseId];
    NSLog(@"%@",urlstr);
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"获取课程报告学生点名%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"studentOfCourseInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"查询课程下的学生失败%@",object);
    }];
}

@end
