//
//  AgencyHomePageController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/13.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AgencyHomePageController.h"
#import "AgencyCell.h"
#import "NavigationView.h"
#import "LocationController.h"
#import "IntroductionController.h"
#import <UIImageView+WebCache.h>
#import "CharacteristicsController.h"
#import "CCTags.h"

static NSString *identify = @"AgencyCell";
@interface AgencyHomePageController ()<UITableViewDelegate, UITableViewDataSource, Characteristics>{
    NSArray *dataArray;
    NSArray *array;
    NSArray *dataSource;
    NSMutableArray *mutaData;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *titel;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UITableView *agencyTab;

@end

@implementation AgencyHomePageController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
    NSString *brief = [[NSUserDefaults standardUserDefaults] objectForKey:@"brief"];
    NSString *feature = [[NSUserDefaults standardUserDefaults] objectForKey:@"feature"];
    dataSource = [feature componentsSeparatedByString:@","];
    _content.text = brief;
    array = @[location,feature,brief];
    mutaData = [NSMutableArray array];
    CCTags *tags = [[CCTags alloc] init];
    tags.tagsArray = dataSource;
    [mutaData addObject:tags];
    [_agencyTab reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"机构主页" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _agencyTab.delegate = self;
    _agencyTab.dataSource = self;
    _agencyTab.tableHeaderView = _backView;
    
    [_headPic sd_setImageWithURL:[NSURL URLWithString:_dic[@"img"]] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
    _titel.text = _dic[@"name"];
    
    dataArray = @[@"位置:",@"特点:",@"简介:"];
    
}

#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AgencyCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AgencyCell" owner:self options:nil]lastObject];
    }
    cell.titel.text = dataArray[indexPath.row];
    if (indexPath.row == 1) {
        cell.tags = mutaData[0];
    }else{
        cell.content.text = array[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _agencyTab.contentSize=CGSizeMake(0, 35 * dataArray.count + _backView.bounds.size.height);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LocationController *locationVc = [mainSB instantiateViewControllerWithIdentifier:@"LocationController"];
            [self.navigationController pushViewController:locationVc animated:YES];
        }
            break;
        case 2:
        {
            UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            IntroductionController *locationVc = [mainSB instantiateViewControllerWithIdentifier:@"IntroductionController"];
            locationVc.isAsk = -1;
            [self.navigationController pushViewController:locationVc animated:YES];
        }
            break;
        case 1:
        {
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CharacteristicsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"CharacteristicsController"];
            appendVC.delegate = self;
            appendVC.isCharacter = NO;
            appendVC.array = dataSource;
            [self.navigationController pushViewController:appendVC animated:YES];
        }
            break;
        default:
            break;
    }
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return [mutaData[0] tagsHeight];
    }else{
    return 35;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor whiteColor];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:14];
    headerLabel.frame = CGRectMake(15, 0.0, 300.0, 35);
    headerLabel.text =  @"机构简介";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerLabel.frame), XN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:0.737 green:0.733 blue:0.757 alpha:1.000];
    [customView addSubview:view];
    [customView addSubview:headerLabel];
    return customView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

@end
