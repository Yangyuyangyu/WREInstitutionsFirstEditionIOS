//
//  CharacteristicsController.m
//  Institutions
//
//  Created by Mac OSX on 16/6/22.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "CharacteristicsController.h"
#import "CharacteristicsCollectionCell.h"
#import "NavigationView.h"
#import "DrawerModel.h"

@interface CharacteristicsController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>{
    NSMutableArray *dataSource;
}

@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UICollectionView *characteristics;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) DrawerModel *drawer;
//特点
@property (nonatomic, copy) NSString *str;
@end

@implementation CharacteristicsController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(edit:) name:@"editInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"添加特点" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(XN_WIDTH - 64, 37, 60, 15);
    [button setTintColor:[UIColor whiteColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    _characteristics.delegate = self;
    _characteristics.dataSource = self;
    
    
    
    _number = -1;
    _name.delegate = self;
    
    if (_isCharacter == NO) {
        _name.placeholder = @"请输入机构的特点";
        _drawer = [[DrawerModel alloc] init];
    }
    
    dataSource = [NSMutableArray array];
    [dataSource addObjectsFromArray:_array];
    
    [_characteristics registerNib:[UINib nibWithNibName:@"CharacteristicsCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
    
}

//修改特点
- (void)edit:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSUserDefaults *defailts = [NSUserDefaults standardUserDefaults];
        [defailts setObject:_str forKey:@"feature"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"修改特点失败"];
    }
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataSource.count;
}
//设定各个item的size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = dataSource[indexPath.row];
    //中英混合字符串计算大小
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [string dataUsingEncoding:enc];
    return CGSizeMake([data length] * 7 + 20, 30);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CharacteristicsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    if (_number == indexPath.row) {
        cell.remove.hidden = NO;
    }else{
        cell.remove.hidden = YES;
    }
    cell.remove.tag = indexPath.row;
    [cell.remove addTarget:self action:@selector(deleteMessage:) forControlEvents:UIControlEventTouchUpInside];
    cell.characteristics.text = dataSource[indexPath.row];
    cell.characteristics.layer.cornerRadius = 5;
    cell.characteristics.layer.masksToBounds = YES;
    cell.characteristics.layer.borderWidth = 1;
    cell.characteristics.layer.borderColor = XN_COLOR_RED_MINT.CGColor;
    return cell;

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _number = indexPath.row;
    [_characteristics reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_name resignFirstResponder];
    [dataSource addObject:textField.text];
    _number = -1;
    [_characteristics reloadData];
    _name.text = nil;
    return YES;
}

- (void)deleteMessage:(UIButton *)sender{
    [dataSource removeObjectAtIndex:sender.tag];
    _number = -1;
    [_characteristics reloadData];
}

- (void)handleEvent:(UIButton *)sender{
    if (_isCharacter == YES) {
        if (_delegate && [_delegate respondsToSelector:@selector(viewController:passValueInfo:)]) {
            [_delegate viewController:self passValueInfo:dataSource];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSMutableString *mutaStr = [NSMutableString string];
        for (int i = 0; i < dataSource.count; i ++) {
            if (i == dataSource.count - 1) {
                [mutaStr appendString:[NSString stringWithFormat:@"%@",dataSource[i]]];
            }else{
                [mutaStr appendString:[NSString stringWithFormat:@"%@,",dataSource[i]]];
            }
        }
        _str = (NSString *)mutaStr;
        [_drawer editInfoList:@"2" content:_str];
    }
    
    
}
@end
