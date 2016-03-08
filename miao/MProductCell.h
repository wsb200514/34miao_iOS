//
//  MProductCell.h
//  sansimiao
//
//  Created by 魏素宝 on 15/8/27.
//  Copyright (c) 2015年 SUBAOWEI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MProductFrame;

@interface MProductCell : UITableViewCell
@property(nonatomic,strong) MProductFrame *productFrame;
@property(nonatomic,weak) UIButton *shareBtn;
@end
