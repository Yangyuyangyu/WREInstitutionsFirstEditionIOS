//
//  HomeModel.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "HomeModel.h"
#import "NetworkingManager.h"

@implementation HomeModel

- (void)countInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/count?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSDictionary *dic = [self deleteAllNullValue:object];
        XNLog(@"首页统计老师和课程数成功%@",dic);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"countInfoList" object:nil userInfo:dic];
    } failureBlock:^(id object) {
        XNLog(@"首页统计老师和课程数失败%@",object);
    }];
}

- (void)myTeacherInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/myTeacher?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"查询已加入该机构的老师成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"myTeacherInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"查询已加入该机构的老师失败%@",object);
    }];
}

- (void)teacherInfoList:(NSString *)teacherId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/teacherInfo?id=%@",Basicurl,teacherId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"老师基本信息成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"teacherInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"老师基本信息失败%@",object);
    }];
}

- (void)chooseInfoList:(NSString *)mobile{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/choose?mobile=%@",Basicurl,mobile];
    NSLog(@"%@",urlstr);
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"搜索已有老师成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"搜索已有老师失败%@",object);
    }];
}

- (void)saveInfoList:(NSString *)teacherId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/save",Basicurl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSDictionary *dic = @{@"id":uid ,@"tid":teacherId};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"选择老师后保存成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"选择老师后保存失败%@",object);
    }];
}

- (void)addTeacherInfoList:(NSString *)head_img name:(NSString *)name mobile:(NSString *)mobile pass:(NSString *)pass email:(NSString *)email feature:(NSString *)feature intro:(NSString *)intro{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/addTeacher",Basicurl];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"id",head_img,@"head_img",name,@"name",mobile,@"mobile",pass,@"pass",email,@"email",feature,@"feature",intro,@"intro", nil];
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"直接新增老师成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addTeacherInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"直接新增老师失败%@",object);
    }];
}

- (void)myStudentInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/myStudent?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"查询已加入机构的学生成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"myStudentInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"查询已加入机构的学生失败%@",object);
    }];
}

- (void)myStudentInfoList:(NSString *)subject_id course_id:(NSString *)course_id start_time:(NSString *)start_time end_time:(NSString *)end_time name:(NSString *)name mobile:(NSString *)mobile{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *name_ = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *mobile_ = [mobile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/myStudent?id=%@&subject_id=%@&course_id=%@&start_time=%@&end_time=%@&name=%@&mobile=%@",Basicurl,uid,subject_id,course_id,start_time,end_time,name_,mobile_];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"查询已加入机构的学生成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"myStudentInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"查询已加入机构的学生失败%@",object);
    }];
}

- (void)studentInfoList:(NSString *)studentId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/studentInfo?sid=%@",Basicurl,studentId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"学生主页成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"studentInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"学生主页失败%@",object);
    }];
}

- (void)chooseStudentInfoList:(NSString *)mobile{
    NSString *urlstr = @"";
    if (mobile.length != 0) {
        urlstr = [NSString stringWithFormat:@"%@/Api/AgencyApi/chooseStudent?mobile=%@",Basicurl,mobile];
    }else{
        urlstr = [NSString stringWithFormat:@"%@/Api/AgencyApi/chooseStudent",Basicurl];
    }
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"搜索已有学生成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseStudentInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"搜索已有学生失败%@",object);
    }];
}


- (void)studentSelectedInfoList:(NSString *)studentId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/studentSelected?sid=%@",Basicurl,studentId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"读取已选择的学生信息成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"studentSelectedInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"读取已选择的学生信息失败%@",object);
    }];
}

- (void)getGroupsInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/getGroups?agencyId=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"查询机构下的社团成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getGroupsInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"查询机构下的社团失败%@",object);
    }];
}

- (void)addStudentInfoList:(NSString *)communityId sid:(NSString *)sid subject:(NSString *)subject name:(NSString *)name mobile:(NSString *)mobile pass:(NSString *)pass email:(NSString *)email{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/addStudent",Basicurl];
    NSDictionary *dic = [NSDictionary dictionary];
    if (sid.length == 0) {
        dic = @{@"id":communityId ,@"subject":subject, @"name":name, @"mobile":mobile, @"pass":pass,@"email":email};
    }else{
        dic = @{@"id":communityId ,@"sid":sid,@"subject":subject, @"name":name, @"mobile":mobile, @"pass":pass,@"email":email};
    }
    
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"保存学生信息成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addStudentInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"保存学生信息失败%@",object);
    }];
}

- (void)myCourseInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/myCourse?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"课程列表成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"myCourseInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"课程列表失败%@",object);
    }];
}

- (void)courseInfoList:(NSString *)courseId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/courseInfo?id=%@",Basicurl,courseId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"课程详情成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"courseInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"课程详情失败%@",object);
    }];
}

- (void)callInfoList:(NSString *)classId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/callInfo?classId=%@",Basicurl,classId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"上课点名数据成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"callInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"上课点名数据失败%@",object);
    }];
}

- (void)groupBuildInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/groupBuild?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"社团建设下的社团列表成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupBuildInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"社团建设下的社团列表失败%@",object);
    }];
}

- (void)myAdminInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/myAdmin?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"查询管理员成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"myAdminInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"查询管理员失败%@",object);
    }];
}

- (void)saveAdminInfoList:(NSString *)groupId adminId:(NSString *)adminId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/saveAdmin",Basicurl];
    NSDictionary *dic = @{@"groupId":groupId ,@"adminId":adminId};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"保存修改后的管理员成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveAdminInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"保存修改后的管理员失败%@",object);
    }];
}

- (void)subjectOfGroupInfoList:(NSString *)communityId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/subjectOfGroup?id=%@",Basicurl,communityId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"社团的科目成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"subjectOfGroupInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"社团的科目失败%@",object);
    }];
}

- (void)financeInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/finance?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"资金管理成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"financeInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"资金管理失败%@",object);
    }];
}

- (void)cashAccountInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/cashAccount?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"提现时查询银行卡成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cashAccountInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"提现时查询银行卡失败%@",object);
    }];
}

- (void)addCashInfoList:(NSString *)money account:(NSString *)account{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/addCash",Basicurl];
    NSDictionary *dic = @{@"money":money ,@"account":account, @"id":uid};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        XNLog(@"保存修改后的管理员成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addCashInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"保存修改后的管理员失败%@",object);
    }];
}

- (void)courseListInfoList:(NSString *)week{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/courseList?id=%@&week=%@",Basicurl,uid,week];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"课程表成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"courseListInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"课程表失败%@",object);
    }];
}

- (void)mySubjectInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/mySubject?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"机构下的所有科目成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mySubjectInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"机构下的所有科目失败%@",object);
    }];
}

- (void)subjectListInfoList:(NSString *)communityId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/subjectList?id=%@",Basicurl,communityId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"选择社团后查询科目成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"subjectListInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"选择社团后查询科目失败%@",object);
    }];
}

- (void)coursesInfoList:(NSString *)subjectId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/courses?id=%@",Basicurl,subjectId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"选择科目后查询课程成功%@",object);
        XNLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"coursesInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        XNLog(@"选择科目后查询课程失败%@",object);
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
