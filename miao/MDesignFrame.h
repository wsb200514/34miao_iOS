//
//  MDesignFrame.h
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MDesign;

@interface MDesignFrame : NSObject
@property(nonatomic,strong) MDesign *design;
@property(nonatomic,assign,readonly) CGRect titleF;
@property(nonatomic,assign,readonly) CGRect imgViewF;
@property(nonatomic,assign,readonly) CGRect shieldViewF;
@property(nonatomic,assign,readonly) CGRect sourceF;
@property(nonatomic,assign,readonly) CGRect dateF;
@property(nonatomic,assign,readonly) CGRect shareBtnF;
@property(nonatomic,assign,readonly) CGFloat cellH;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
@end
