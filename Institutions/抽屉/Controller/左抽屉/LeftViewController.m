//
//  LeftViewController.m
//  DeepBreathing
//
//  Created by rimi on 15/12/15.
//  Copyright © 2015年 肖恩. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftCell.h"
#import "AgencyHomePageController.h"
#import "BankCardController.h"
#import "SetController.h"
#import "AboutUsController.h"
#import "FeedbackController.h"
#import "CommunityManagementController.h"
#import <UIImageView+WebCache.h>
#import "NetworkingManager.h"

static NSString *identify = @"LeftCell";
@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSource1;
    NSArray *dataSource2;
    NSDictionary *dic;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *backPic;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UITableView *leftTab;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _leftTab.dataSource = self;
    _leftTab.delegate = self;
    _leftTab.tableHeaderView = _backView;
    [self initializeDataSource];
}
- (void)initializeDataSource {
    dataSource1 = @[@"机构信息",@"我的银行卡",@"社团管理制度",@"设置"];
    dataSource2 = @[@"关于我们",@"意见反馈"];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/AgencyApi/info?id=%@",Basicurl,uid];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        XNLog(@"机构信息成功%@",object);
        dic = object[@"data"];
        NSString *pic = dic[@"img"];
        [_headPic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"default_load_img.png"]];
        _name.text = dic[@"name"];
    } failureBlock:^(id object) {
        XNLog(@"机构信息失败%@",object);
    }];
}

#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LeftCell" owner:self options:nil]lastObject];
    }
    if (indexPath.section == 0) {
        cell.titel.text = dataSource1[indexPath.row];
    }else{
        cell.titel.text = dataSource2[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AgencyHomePageController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AgencyHomePageController"];
                appendVC.dic = dic;
                [self.navigationController pushViewController:appendVC animated:YES];
            }
                break;
            case 1:
            {
                UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                BankCardController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"BankCardController"];
                [self.navigationController pushViewController:appendVC animated:YES];
            }
                break;
            case 2:
            {
                CommunityManagementController *commVC = [[CommunityManagementController alloc]init];
                [self.navigationController pushViewController:commVC animated:YES];
            }
                break;
            case 3:
            {
                SetController *setVc= [[SetController alloc] init];
                [self.navigationController pushViewController:setVc animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AboutUsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AboutUsController"];
                [self.navigationController pushViewController:appendVC animated:YES];
            }
                break;
            case 1:
            {
                UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                FeedbackController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"FeedbackController"];
                [self.navigationController pushViewController:appendVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor colorWithWhite:0.808 alpha:1.000];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithWhite:0.255 alpha:1.000];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    headerLabel.frame = CGRectMake(15, 0.0, 300.0, 35);
    headerLabel.text =  @"其他";
    [customView addSubview:headerLabel];
    return customView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 35;
    }else{
        return 0;
    }
}

@end
