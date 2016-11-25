//
//  AddTeacherController.m
//  Institutions
//
//  Created by waycubeIOSb on 16/6/2.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AddTeacherController.h"
#import "NavigationView.h"
#import "ManagementModel.h"
#import "HomeModel.h"
#import "CharacteristicsController.h"
#import "CharacteristicsCollectionCell.h"

typedef NS_ENUM(NSInteger,ChosePhontType)
{
    
    ChosePhontTypeAlbum,
    ChosePhontTypeCamera
};
@interface AddTeacherController ()<UITextFieldDelegate, UITableViewDelegate ,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,Characteristics,UICollectionViewDataSource, UICollectionViewDelegate>{
    NSArray *dataSource;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (weak, nonatomic) IBOutlet UITableView *addTeachTab;
//特点线
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1;
@property (weak, nonatomic) IBOutlet UIImageView *pic;

@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property (weak, nonatomic) IBOutlet UITextView *IintroductionTextView;
//邮箱
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UICollectionView *characteristics;

@property (nonatomic, copy) NSString *header;

@property (nonatomic, strong) ManagementModel *management;
@property (nonatomic, strong) HomeModel *home;

@end

@implementation AddTeacherController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imgUpload:) name:@"imgUploadInfokInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addTeacher:) name:@"addTeacherInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"新增老师" leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
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
    
    _management = [[ManagementModel alloc] init];
    _home = [[HomeModel alloc] init];
    
    _email.delegate = self;
    _phone.delegate = self;
    _password.delegate = self;
    _name.delegate = self;
    _addTeachTab.delegate = self;
    _IintroductionTextView.delegate = self;
    _introductionLabel.enabled = NO;//lable必须设置为不可用
    _introductionLabel.backgroundColor = [UIColor clearColor];
    
    _pic.layer.cornerRadius = 30;
    _pic.layer.masksToBounds = YES;
    
    _characteristics.delegate = self;
    _characteristics.dataSource = self;
    
    [_characteristics registerNib:[UINib nibWithNibName:@"CharacteristicsCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
}

- (void)imgUpload:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        _header = bitice.userInfo[@"data"];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}

- (void)addTeacher:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:bitice.userInfo[@"msg"]];
    }
}
#pragma mark--按钮点击
- (IBAction)characteristics:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CharacteristicsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"CharacteristicsController"];
    appendVC.delegate = self;
    appendVC.isCharacter = YES;
    appendVC.array = dataSource;
    [self.navigationController pushViewController:appendVC animated:YES];
}
//修改头像
- (IBAction)portrait:(UIButton *)sender {
    [self picture];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
}
//提交
- (void)handleEvent:(UIButton *)sender{
    NSMutableString *feature1 = [[NSMutableString alloc] init];
    for (int i = 0; i < dataSource.count; i ++) {
        if (i == dataSource.count - 1) {
            [feature1 appendString:[NSString stringWithFormat:@"%@",dataSource[i]]];
        }else{
            [feature1 appendString:[NSString stringWithFormat:@"%@,",dataSource[i]]];
        }
    }
    NSString *feature = [NSString stringWithString:feature1];
    if (_header.length == 0) {
        [MBProgressHUD showError:@"请选择头像"];
    }else if (_name.text.length == 0){
        [MBProgressHUD showError:@"请填写昵称"];
    }else if (_phone.text.length == 0){
        [MBProgressHUD showError:@"请填写电话号码"];
    }else if (feature.length == 0){
        [MBProgressHUD showError:@"请添加特点"];
    }else if (_IintroductionTextView.text.length == 0){
        [MBProgressHUD showError:@"请填写简介"];
    }else if (![CManager validateMobile:_phone.text]){
        [MBProgressHUD showError:@"电话号码不正确"];
    }else{
        if (_email.text.length == 0) {
            _email.text = @"";
            [_home addTeacherInfoList:_header name:_name.text mobile:_phone.text pass:_password.text email:_email.text feature:feature intro:_IintroductionTextView.text];
        }else{
            if (![CManager validateEmail:_email.text]) {
                [MBProgressHUD showError:@"邮箱格式不正确"];
            }else{
                [_home addTeacherInfoList:_header name:_name.text mobile:_phone.text pass:_password.text email:_email.text feature:feature intro:_IintroductionTextView.text];
            }
        }
    }
    
}
#pragma mark -- Characteristics

- (void)viewController:(UIViewController *)viewController passValueInfo:(NSArray *)info {
    dataSource = info;
    if (dataSource.count != 0) {
        _line2.constant = XN_WIDTH - 70;
    }
    [_characteristics reloadData];
}

#pragma mark--UITextFieldDelegate,UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        _introductionLabel.text = @"";
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
    self.IintroductionTextView.text = textView.text;
    if (textView.text.length == 0) {
        _introductionLabel.text = @"请输入简介...";
    }else{
        _introductionLabel.text = @"";
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect frame = textView.superview.frame;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 216, 0.0);
    
    int offset = frame.origin.y + 125 - (self.view.frame.size.height - 216.0);//键盘高度216
    _addTeachTab.contentInset = contentInsets;
    _addTeachTab.scrollIndicatorInsets = contentInsets;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0){
        CGPoint scrollPoint = CGPointMake(0.0, offset + 100);
        [_addTeachTab setContentOffset:scrollPoint animated:YES];
    }
    [UIView commitAnimations];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 235, 0.0);
    _addTeachTab.contentInset = contentInsets;
    _addTeachTab.scrollIndicatorInsets = contentInsets;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _addTeachTab.contentInset = contentInsets;
        _addTeachTab.scrollIndicatorInsets = contentInsets;
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _addTeachTab.contentInset = contentInsets;
        _addTeachTab.scrollIndicatorInsets = contentInsets;
    }];
}
//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phone) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    return YES;
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
    cell.remove.hidden = YES;
    cell.characteristics.text = dataSource[indexPath.row];
    cell.characteristics.layer.cornerRadius = 5;
    cell.characteristics.layer.masksToBounds = YES;
    cell.characteristics.layer.borderWidth = 1;
    cell.characteristics.layer.borderColor = XN_COLOR_RED_MINT.CGColor;

    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CharacteristicsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"CharacteristicsController"];
    appendVC.delegate = self;
    appendVC.array = dataSource;
    [self.navigationController pushViewController:appendVC animated:YES];
}
#pragma mark--自定义
//修改头像
- (void)picture {
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
            [MBProgressHUD showError:@"相机不可用"];
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
    UIImage * theImg = [self zipImageWithData:imgData limitedWith:140];
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
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* totalPath = [documentPath stringByAppendingPathComponent:imageName];
    
    //保存到 document
    [imageData writeToFile:totalPath atomically:NO];
    
    //保存到 NSUserDefaults
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:totalPath forKey:@"avatar"];
    //    NSString *string = [userDefaults objectForKey:@"avatar"];
    //    _usericon.image = [UIImage imageWithContentsOfFile:string];
    //上传头像
    [_management imgUploadInfokInfoList:imageData];
}


#pragma mark--回收键盘
//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _addTeachTab.contentInset = contentInsets;
        _addTeachTab.scrollIndicatorInsets = contentInsets;
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
        _addTeachTab.contentInset = contentInsets;
        _addTeachTab.scrollIndicatorInsets = contentInsets;
    }];
    [self.view endEditing:YES];
}
@end
