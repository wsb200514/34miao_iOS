//
//  MMarketingFrame.h
//  miao
//
//  Created by 魏素宝 on 15/9/20.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MMarketing;

@interface MMarketingFrame : NSObject
@property(nonatomic,strong) MMarketing *marketing;
@property(nonatomic,assign,readonly) CGRect titleF;
@property(nonatomic,assign,readonly) CGRect imgViewF;
@property(nonatomic,assign,readonly) CGRect sourceF;
@property(nonatomic,assign,readonly) CGRect dateF;
@property(nonatomic,assign,readonly) CGRect shareBtnF;
@property(nonatomic,assign,readonly) CGFloat cellH;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
@end
