//
//  MDesignCell.h
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDesignFrame;

@interface MDesignCell : UITableViewCell
@property(nonatomic,strong) MDesignFrame *designFrame;
@property(nonatomic,weak) UIButton *shareBtn;
@end
