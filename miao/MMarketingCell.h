//
//  MMarketingCell.h
//  miao
//
//  Created by 魏素宝 on 15/9/20.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMarketingFrame;

@interface MMarketingCell : UITableViewCell
@property(nonatomic,strong) MMarketingFrame *marketingFrame;
@property(nonatomic,weak) UIButton *shareBtn;
@end
