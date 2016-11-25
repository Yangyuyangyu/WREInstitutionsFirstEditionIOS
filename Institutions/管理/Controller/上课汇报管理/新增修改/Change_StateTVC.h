//
//  Change_StateTVC.h
//  Institutions
//
//  Created by waycubeOXA on 16/9/23.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Change_StateTVCProtocol<NSObject>

-(void)selectNS:(NSString*)sate;
@end

@interface Change_StateTVC : UITableViewController

@property(weak,nonatomic) id<Change_StateTVCProtocol> theDelegate;
@end
