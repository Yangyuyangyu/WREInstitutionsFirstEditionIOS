//
//  CharacteristicsController.h
//  Institutions
//
//  Created by Mac OSX on 16/6/22.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CharacteristicsController;

@protocol Characteristics <NSObject>

@optional
- (void)viewController:(UIViewController *)viewController passValueInfo: (NSArray *)info;
@end

@interface CharacteristicsController : UIViewController

@property (nonatomic, assign) id<Characteristics> delegate;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, assign) BOOL isCharacter;

@end
