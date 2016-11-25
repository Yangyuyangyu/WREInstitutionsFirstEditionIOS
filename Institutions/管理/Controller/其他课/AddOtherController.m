//
//  AddOtherController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/8.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AddOtherController.h"
#import "AddOtherCell.h"
#import "NavigationView.h"

@interface AddOtherController ()<UITextViewDelegate, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITableView *AddOtherTab;
//取消
@property (weak, nonatomic) IBOutlet UIButton *cancel;
//确认
@property (weak, nonatomic) IBOutlet UIButton *confirm;

@property (nonatomic, strong)AddOtherCell *cell;

@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UITextView *content1;

@property (weak, nonatomic) IBOutlet UILabel *teacherName1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextView *content2;



@end

@implementation AddOtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"其他课" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _AddOtherTab.tableHeaderView = _backView;
    _AddOtherTab.delegate = self;
    
    
    _cancel.layer.borderWidth = 1;
    _cancel.layer.borderColor = [UIColor grayColor].CGColor;
    _cancel.layer.cornerRadius = 5;
    _cancel.layer.masksToBounds = YES;
    
    _confirm.layer.borderWidth = 1;
    _confirm.layer.borderColor = [UIColor grayColor].CGColor;
    _confirm.layer.cornerRadius = 5;
    _confirm.layer.masksToBounds = YES;
    
    _content1.delegate = self;
    _content2.delegate = self;
}

#pragma mark--UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        switch (textView.tag) {
            case 0:
                _label1.text = @"";
                break;
            case 1:
                _label2.text = @"";
                break;
            default:
                break;
        }
        //        如果输入有中文，且没有出现文字备选框就对字数统计和限制
        //        出现了备选框就暂不统计
        UITextRange *range = [textView markedTextRange];
        
        UITextPosition *position = [textView positionFromPosition:range.start offset:0];
        if (!position)
        {
            
            [self checkText:textView];
            
        }
    }
    else
    {
        [self checkText:textView];
    }
}

- (void)checkText:(UITextView *)textView{
    switch (textView.tag) {
        case 0:
            self.content1.text = textView.text;
            break;
        case 1:
            self.content2.text = textView.text;
            break;
        default:
            break;
    }
    if (textView.text.length == 0) {
        switch (textView.tag) {
            case 0:
                _label1.text = @"说点什么吧...";
                break;
            case 1:
                _label2.text = @"说点什么吧...";
                break;
            default:
                break;
        }
    }else{
        switch (textView.tag) {
            case 0:
                _label1.text = @"";
                break;
            case 1:
                _label2.text = @"";
                break;
            default:
                break;
        }
    }

}

//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect frame = textView.superview.frame;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 216, 0.0);
    
    int offset = frame.origin.y - (self.view.frame.size.height - 216.0);//键盘高度216
    _AddOtherTab.contentInset = contentInsets;
    _AddOtherTab.scrollIndicatorInsets = contentInsets;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    CGPoint scrollPoint = CGPointMake(0.0, offset + 210);
    [_AddOtherTab setContentOffset:scrollPoint animated:YES];
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
- (void)textViewDidEndEditing:(UITextView *)textView{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _AddOtherTab.contentInset = contentInsets;
        _AddOtherTab.scrollIndicatorInsets = contentInsets;
        _AddOtherTab.contentSize=CGSizeMake(64, _backView.bounds.size.height);
    }];
}

- (IBAction)time:(UIButton *)sender {
}
//选择
- (IBAction)choose:(UIButton *)sender {
}

- (IBAction)confirm:(UIButton *)sender {
}
//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}
//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
