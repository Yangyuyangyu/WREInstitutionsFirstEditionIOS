//
//  AppDelegate.h
//  Institutions
//
//  Created by waycubeIOSb on 16/5/27.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>{
    BMKMapManager * _mapManager;
}

@property (strong, nonatomic) UIWindow *window;


@end

