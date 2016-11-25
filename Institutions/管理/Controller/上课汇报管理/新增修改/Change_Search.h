//
//  Change_Search.h
//  Institutions
//
//  Created by waycubeOXA on 16/9/22.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Change_SearchProtocol <NSObject>

-(void)check:(NSString*)startTime endtime:(NSString*)endTime className:(NSString*)className
 teacherName:(NSString*)teacherName state:(NSString*)state;

@end

@interface Change_Search : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textStartTime;
@property (weak, nonatomic) IBOutlet UITextField *textEndTime;



@property (weak, nonatomic) IBOutlet UITextField *className;
@property (weak, nonatomic) IBOutlet UITextField *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *sateLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (weak, nonatomic) IBOutlet UIButton *check;

@property(weak,nonatomic) id<Change_SearchProtocol> theDelegate;


@end
