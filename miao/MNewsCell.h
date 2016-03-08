//
//  MNewsCell.h
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MNewsFrame;

@interface MNewsCell : UITableViewCell
@property(nonatomic,strong) MNewsFrame *newsFrame;
@property(nonatomic,weak) UIButton *shareBtn;
@end
