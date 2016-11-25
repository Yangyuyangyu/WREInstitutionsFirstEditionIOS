//
//  ExamResultsController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/12.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ExamResultsController.h"
#import "NavigationView.h"
#import "ExanResultsCell.h"

static NSString *identify = @"ExanResultsCell";
@interface ExamResultsController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    NSMutableArray *dataArray;
}
@property (nonatomic, strong)UITableView *resultsTab;
@end

@implementation ExamResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"考核管理" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    dataArray = [NSMutableArray array];
    for (int i = 0; i < 23; i ++) {
        [dataArray insertObject:@"" atIndex:i];
    }
    [self.view addSubview:self.resultsTab];

}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 23;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExanResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExanResultsCell" owner:self options:nil]lastObject];
    }
    cell.score.delegate = self;
    cell.score.tag = indexPath.row;
    cell.score.text = dataArray[indexPath.row];
    if (cell.score.text.length == 0) {
        cell.name.textColor = XN_COLOR_RED_MINT;
    }else{
        cell.name.textColor = [UIColor blackColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark--UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 235, 0.0);
    _resultsTab.contentInset = contentInsets;
    _resultsTab.scrollIndicatorInsets = contentInsets;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%ld",(long)textField.tag);
    for (int i = 0; i < dataArray.count; i ++) {
        if (textField.tag == i) {
            [dataArray removeObjectAtIndex:textField.tag];
            [dataArray insertObject:textField.text atIndex:textField.tag];
            
            [_resultsTab reloadData];
            return;
        }
    }
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _resultsTab.contentInset = contentInsets;
        _resultsTab.scrollIndicatorInsets = contentInsets;
    }];
}
- (void)handleEvent:(UIButton *)sender{
    
}


#pragma mark--getter
- (UITableView *)resultsTab{
    if (!_resultsTab) {
        _resultsTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _resultsTab.tableFooterView = [[UIView alloc] init];
        _resultsTab.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
        _resultsTab.dataSource = self;
        _resultsTab.delegate = self;
    }
    return _resultsTab;
}

//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _resultsTab.contentInset = contentInsets;
        _resultsTab.scrollIndicatorInsets = contentInsets;
    }];
    [self.view endEditing:YES];
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _resultsTab.contentInset = contentInsets;
        _resultsTab.scrollIndicatorInsets = contentInsets;
    }];
    [self.view endEditing:YES];
}
@end
