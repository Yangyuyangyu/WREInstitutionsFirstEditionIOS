//
//  Change_Search.m
//  Institutions
//
//  Created by waycubeOXA on 16/9/22.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "Change_Search.h"
#import "Change_StateTVC.h"

@interface Change_Search ()<Change_StateTVCProtocol,UIPopoverPresentationControllerDelegate,UITextFieldDelegate>{
    Change_StateTVC*stateTVC;
    UIPopoverPresentationController*popover;
}

@end

@implementation Change_Search
-(void)selectNS:(NSString *)sate{
    self.sateLabel.text=sate;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.className.delegate=self;
    self.teacherName.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startTime:(id)sender {
    [self dateDialog:0];
}
- (IBAction)endTime:(id)sender {
    [self dateDialog:1];
}
- (IBAction)className:(id)sender {
}

- (IBAction)state:(id)sender {
    [self initPop];
}


- (IBAction)check:(id)sender {
    
    [self.theDelegate check:self.textStartTime.text endtime:self.textEndTime.text className:_className.text teacherName:_teacherName.text state:_sateLabel.text];
}

-(void)dateDialog:(NSInteger)index{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n" message:nil 　　preferredStyle:UIAlertControllerStyleAlert];
    alert.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        //求出当天的时间字符串
        NSLog(@"%@",dateString);
        switch (index) {
            case 0:
                self.textStartTime.text=dateString;
                break;
                
            case 1:
                self.textEndTime.text=dateString;
                break;
            default:
                break;
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        　 }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];
}


-(void)initPop{
    stateTVC=[[Change_StateTVC alloc] init];
    stateTVC.preferredContentSize=CGSizeMake(100, 150);
    stateTVC.theDelegate=self;
    // 设置弹出效果
    stateTVC.modalPresentationStyle = UIModalPresentationPopover;
    //初始化一个popover
    popover = stateTVC.popoverPresentationController;
    popover.delegate = self;
    //设置弹出视图的颜色
    popover.backgroundColor = [UIColor whiteColor];
    //设置popover的来源按钮（以button谁为参照）
    popover.sourceView =self.stateBtn;
    //设置弹出视图的位置（以button谁为参照）
    popover.sourceRect = self.stateBtn.bounds;
    //箭头的方向 设置成UIPopoverArrowDirectionAny 会自动转换方向
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //模态出弹框
    [self presentViewController:stateTVC animated:YES completion:nil];//推出popover
}

#pragma mark --  实现代理方法
//默认返回的是覆盖整个屏幕，需设置成UIModalPresentationNone。
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

//点击蒙版是否消失，默认为yes；

-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}

//弹框消失时调用的方法
-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
    NSLog(@"弹框已经消失");
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.className resignFirstResponder];
    [self.teacherName resignFirstResponder];
    return YES;
}




@end
