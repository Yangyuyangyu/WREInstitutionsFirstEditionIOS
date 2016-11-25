//
//  AddDynamicController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/7.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AddDynamicController.h"
#import "NavigationView.h"
#import "ManagementModel.h"
#import "CZCover.h"
#import "HomeModel.h"

static NSString *identify = @"CELL";
typedef NS_ENUM(NSInteger,ChosePhontType)
{
    
    ChosePhontTypeAlbum,
    ChosePhontTypeCamera
};
@interface AddDynamicController ()<UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, CZCoverDelegate>{
    NSMutableDictionary *mutableDic;
    NSMutableArray *imageArray;
    NSArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UIButton *image1;
//动态名称
@property (weak, nonatomic) IBOutlet UITextField *name;
//简介1
@property (weak, nonatomic) IBOutlet UITextView *introduction1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
//类型
@property (weak, nonatomic) IBOutlet UILabel *type;

@property (weak, nonatomic) IBOutlet UIButton *image2;
@property (weak, nonatomic) IBOutlet UITextView *introduction2;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIButton *image3;
@property (weak, nonatomic) IBOutlet UITextView *introduction3;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UIButton *image4;
@property (weak, nonatomic) IBOutlet UITextView *introduction4;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UIView *backView;


@property (nonatomic, strong)UIImageView *pic;
@property (nonatomic, assign)int isButtonTag;

@property (weak, nonatomic) IBOutlet UITableView *dynamicTab;
@property (nonatomic, assign)NSInteger number;

@property (nonatomic, strong)UITableView *czTabel;
@property (nonatomic, strong) ManagementModel *management;
@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong) HomeModel *home;
//社团id
@property (nonatomic, copy) NSString *institutionsId;
@property (nonatomic, assign) BOOL isFirstPic;

@property (nonatomic, assign) BOOL isDetail1;
@property (nonatomic, assign) BOOL isDetail2;
@property (nonatomic, assign) BOOL isDetail3;

@property (nonatomic, strong) NSMutableArray *mutaArray;
@end

@implementation AddDynamicController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imgUpload:) name:@"imgUploadInfokInfoList" object:nil];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGroups:) name:@"getGroupsInfoList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addNews:) name:@"addNewsInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _introduction1.delegate = self;
    _introduction2.delegate = self;
    _introduction3.delegate = self;
    _introduction4.delegate = self;
    _label1.enabled = NO;//lable必须设置为不可用
    _label1.backgroundColor = [UIColor clearColor];
    _label2.enabled = NO;//lable必须设置为不可用
    _label2.backgroundColor = [UIColor clearColor];
    _label3.enabled = NO;//lable必须设置为不可用
    _label3.backgroundColor = [UIColor clearColor];
    _label4.enabled = NO;//lable必须设置为不可用
    _label4.backgroundColor = [UIColor clearColor];
    _isButtonTag = 100;
    _pic = [[UIImageView alloc] init];
    
    _mutaArray = [NSMutableArray array];
    mutableDic = [NSMutableDictionary dictionary];
    imageArray = [NSMutableArray array];
    _management = [[ManagementModel alloc] init];
    _home = [[HomeModel alloc] init];
    _isFirstPic = NO;
    _isDetail1 = NO;
    _isDetail2 = NO;
    _isDetail3 = NO;
    //    让分割线顶头
    if ([self.czTabel respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.czTabel setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.czTabel respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.czTabel setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

- (void)addNews:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [MBProgressHUD showSuccess:@"添加动态成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"添加动态失败"];
    }
}

- (void)imgUpload:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSString *str = bitice.userInfo[@"data"];
        [imageArray addObject:str];
        if (imageArray.count == _mutaArray.count) {
            NSMutableString *mutaStr = [NSMutableString string];
            for (int i = 1; i < imageArray.count; i ++) {
                if (i == 1 && _isDetail1 == YES) {
                    if (_introduction2.text.length != 0) {
                        [mutaStr appendString:[NSString stringWithFormat:@"<p><img alt=\"img.jpg\"src=\%@\title=\"img.jpg\"/></p><p>%@</p>",imageArray[i],_introduction2.text]];
                    }else{
                        [mutaStr appendString:[NSString stringWithFormat:@"<p><img alt=\"img.jpg\"src=\%@\title=\"img.jpg\"/></p>",imageArray[i]]];
                    }
                }else if (i == 2 && _isDetail2 == YES){
                    if (_introduction3.text.length != 0) {
                        [mutaStr appendString:[NSString stringWithFormat:@"<p><img alt=\"img.jpg\"src=\%@\title=\"img.jpg\"/></p><p>%@</p>",imageArray[i],_introduction3.text]];
                    }else{
                        [mutaStr appendString:[NSString stringWithFormat:@"<p><img alt=\"img.jpg\"src=\%@\title=\"img.jpg\"/></p>",imageArray[i]]];
                    }
                }else if (i == 3 && _isDetail3 == YES){
                    if (_introduction4.text.length != 0) {
                        [mutaStr appendString:[NSString stringWithFormat:@"<p><img alt=\"img.jpg\"src=\%@\title=\"img.jpg\"/></p><p>%@</p>",imageArray[i],_introduction4.text]];
                    }else{
                        [mutaStr appendString:[NSString stringWithFormat:@"<p><img alt=\"img.jpg\"src=\%@\title=\"img.jpg\"/></p>",imageArray[i]]];
                    }
                }
                
            }
            NSString *img = imageArray[0];
            NSString *detail = (NSString *)mutaStr;
            [_management addNewsInfoList:_name.text type:_institutionsId img:img brief:_introduction1.text detail:detail];
        }
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
- (void)getGroups:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = self;
        [self.view addSubview:_cover];
        [_cover addSubview:self.czTabel];
    }
}
#pragma mark--自定义方法
//提示框
- (void)tooltip:(NSString *)string {
    //提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:string preferredStyle:UIAlertControllerStyleAlert];
    //添加行为
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
//上传图片
- (void)pictur:(NSInteger)number {
    _isButtonTag = number;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择相片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chosePhoto:ChosePhontTypeAlbum];
    }];
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chosePhoto:ChosePhontTypeCamera];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:album];
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{
        self.hidesBottomBarWhenPushed = YES;
        
    }];
    
}

//选择照片
- (void)chosePhoto:(ChosePhontType)type
{
    UIImagePickerController * piker = [[UIImagePickerController alloc]init];
    piker.allowsEditing = YES;
    piker.delegate = self;

    
    if (type == ChosePhontTypeAlbum) {
        piker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if(type == ChosePhontTypeCamera)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            piker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else
        {
            [self tooltip:@"相机不可用"];
            return;
        }
    }
    [self presentViewController:piker animated:YES completion:^{
    }];
    
    
}

#pragma mark - 选择图片

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _pic.image = info[UIImagePickerControllerOriginalImage];
    NSData * imgData = nil;
    
    if (UIImagePNGRepresentation(_pic.image)) {
        imgData = UIImagePNGRepresentation(_pic.image);
    }else if (UIImageJPEGRepresentation(_pic.image, 1))
    {
        imgData = UIImageJPEGRepresentation(_pic.image, 1);
    }
    
    //压缩处理
    imgData = UIImageJPEGRepresentation(_pic.image, 0.00001);
    
    //将图片尺寸变小
    UIImage * theImg = [self zipImageWithData:imgData limitedWith:340];
    [self saveImage:theImg WithName:@"userAvatar"];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    
    
}

//压缩处理
- (UIImage *)zipImageWithData:(NSData *)imgData limitedWith:(CGFloat)width
{
    //获取图片
    UIImage * img = [UIImage imageWithData:imgData];
    
    CGSize oldImgSize = img.size;
    
    if (width > oldImgSize.width) {
        width = oldImgSize.width;
    }
    
    CGFloat newHeight = oldImgSize.height *((CGFloat)width / oldImgSize.width);
    
    //创建新的图片大小
    CGSize size = CGSizeMake(width, newHeight);
    
    //开启一个图片句柄
    UIGraphicsBeginImageContext(size);
    
    //将图片画入新的size
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //将图片句柄中获取一张新的图片
    UIImage * newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图片句柄
    UIGraphicsEndImageContext();
    
    return newImg;
}

//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    
//    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString* totalPath = [documentPath stringByAppendingPathComponent:imageName];
    
    //保存到 document
//    [imageData writeToFile:totalPath atomically:NO];
    if (_isButtonTag == 0) {
        //保存到 NSUserDefaults
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:totalPath forKey:@"avatar0"];
//        NSString *string = [userDefaults objectForKey:@"avatar0"];
//        NSLog(@"沙盒路径：%@",NSHomeDirectory());
        _isFirstPic = YES;
        [mutableDic setObject:tempImage forKey:@"avatar0"];
        if (!_image1.selected) {
            _image1.selected = !_image1.selected;
        }
        [_image1 setBackgroundImage:tempImage forState:UIControlStateNormal];
    }else if (_isButtonTag == 1){
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:totalPath forKey:@"avatar1"];
//        NSString *string = [userDefaults objectForKey:@"avatar1"];
        _isDetail1 = YES;
        [mutableDic setObject:tempImage forKey:@"avatar1"];
        if (!_image2.selected) {
            _image2.selected = !_image2.selected;
        }
        [_image2 setBackgroundImage:tempImage forState:UIControlStateNormal];
    }else if (_isButtonTag == 2){
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:totalPath forKey:@"avatar2"];
//        NSString *string = [userDefaults objectForKey:@"avatar2"];
        _isDetail2 = YES;
        [mutableDic setObject:tempImage forKey:@"avatar2"];
        if (!_image3.selected) {
            _image3.selected = !_image3.selected;
        }
        [_image3 setBackgroundImage:tempImage forState:UIControlStateNormal];
    }else{
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:totalPath forKey:@"avatar3"];
//        NSString *string = [userDefaults objectForKey:@"avatar3"];
        _isDetail3 = YES;
        [mutableDic setObject:tempImage forKey:@"avatar3"];
        if (!_image4.selected) {
            _image4.selected = !_image4.selected;
        }
        [_image4 setBackgroundImage:tempImage forState:UIControlStateNormal];
    }
    
    //上传头像
//    [_myself imgUploadInfokInfoList:imageData];
}


#pragma mark--UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        switch (textView.tag) {
            case 10:
                _label1.text = @"";
                break;
            case 11:
                _label2.text = @"";
                break;
            case 12:
                _label3.text = @"";
                break;
            case 13:
                _label4.text = @"";
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
        case 10:
            self.introduction1.text = textView.text;
            break;
        case 11:
            self.introduction2.text = textView.text;
            break;
        case 12:
            self.introduction3.text = textView.text;
            break;
        case 13:
            self.introduction4.text = textView.text;
            break;
        default:
            break;
    }
    if (textView.text.length == 0) {
        switch (textView.tag) {
            case 10:
                _label1.text = @"添加简介";
                break;
            case 11:
                _label2.text = @"添加简介";
                break;
            case 12:
                _label3.text = @"添加简介";
                break;
            case 13:
                _label4.text = @"添加简介";
                break;
            default:
                break;
        }
    }else{
        switch (textView.tag) {
            case 10:
                _label1.text = @"";
                break;
            case 11:
                _label2.text = @"";
                break;
            case 12:
                _label3.text = @"";
                break;
            case 13:
                _label4.text = @"";
                break;
            default:
                break;
        }
    }
}

//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect frame = textView.frame;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 216, 0.0);
    
    int offset = frame.origin.y - (self.view.frame.size.height - 216.0);//键盘高度216
    _dynamicTab.contentInset = contentInsets;
    _dynamicTab.scrollIndicatorInsets = contentInsets;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0){
        CGPoint scrollPoint = CGPointMake(0.0, offset + 100);
        [_dynamicTab setContentOffset:scrollPoint animated:YES];
    }
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
- (void)textViewDidEndEditing:(UITextView *)textView{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _dynamicTab.contentInset = contentInsets;
        _dynamicTab.scrollIndicatorInsets = contentInsets;
    }];
}

#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = dataSource[indexPath.row][@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _type.text = dataSource[indexPath.row][@"name"];
    _institutionsId = dataSource[indexPath.row][@"id"];
    [_cover remove];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

//让分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//类型
- (IBAction)type:(UIButton *)sender {
    [self.view endEditing:YES];
    [_home getGroupsInfoList];
}
//图片按钮
- (IBAction)imageButton:(UIButton *)sender {
    [self pictur:sender.tag];
}
//发布
- (IBAction)release:(UIButton *)sender {
    NSArray *name = @[@"avatar0",@"avatar1",@"avatar2",@"avatar3"];
    for (int i = 0; i < name.count; i ++) {
        [self image:name[i]];
    }
    if (_isFirstPic == NO) {
        [MBProgressHUD showError:@"请添加动态图片"];
    }else if (_name.text.length == 0){
        [MBProgressHUD showError:@"请添加标题名称"];
    }else if (_institutionsId.length == 0){
        [MBProgressHUD showError:@"请选择社团"];
    }else if (_introduction1.text.length == 0){
        [MBProgressHUD showError:@"请添加标题图片的简介"];
    }else{
        for (int i = 0; i < _mutaArray.count; i ++) {
            //上传头像
            [_management imgUploadInfokInfoList:_mutaArray[i]];
        }
    }
}

- (void)image:(NSString *)image{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:image]) {
//        NSString *imagePath = [defaults objectForKey:image];
//        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
//        [_image4 setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
//        [_mutaArray addObject:imageData];
//    }
    if ([mutableDic objectForKey:image]) {
        NSData* imageData = UIImagePNGRepresentation([mutableDic objectForKey:image]);
        [_mutaArray addObject:imageData];
    }
    
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

#pragma mark--getter
- (UITableView *)czTabel{
    if (!_czTabel) {
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(0, XN_HEIGHT - 90, XN_WIDTH, 90)];
        _czTabel.tableFooterView = [[UIView alloc] init];
        _czTabel.dataSource = self;
        _czTabel.delegate = self;
//        _czTabel.layer.cornerRadius = 5;
//        _czTabel.layer.masksToBounds = YES;
//        _czTabel.layer.borderWidth = 1;
//        _czTabel.layer.borderColor = XN_COLOR_RED_MINT.CGColor;
        _czTabel.tag = 100;
    }
    return _czTabel;
}
@end
