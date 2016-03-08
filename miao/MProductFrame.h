//
//  MProductFrame.h
//  sansimiao
//
//  Created by 魏素宝 on 15/8/27.
//  Copyright (c) 2015年 SUBAOWEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MProduct;

@interface MProductFrame : NSObject <NSCoding>
@property(nonatomic,strong) MProduct *product;
@property(nonatomic,assign,readonly) CGRect nameF;
@property(nonatomic,assign,readonly) CGRect descF;
@property(nonatomic,assign,readonly) CGRect sourceF;
@property(nonatomic,assign,readonly) CGRect dateF;
@property(nonatomic,assign,readonly) CGRect shareBtnF;
@property(nonatomic,assign,readonly) CGFloat cellH;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
@end
