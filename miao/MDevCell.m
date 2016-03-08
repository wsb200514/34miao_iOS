//
//  MDevCell.m
//  miao
//
//  Created by 魏素宝 on 15/9/20.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MDevCell.h"
#import "MDev.h"
#import "MDevFrame.h"

@interface MDevCell()
@property(nonatomic,weak) UILabel *categoryLabel;
@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,weak) UILabel *sourceLabel;
@property(nonatomic,weak) UILabel *dateLabel;
@end

@implementation MDevCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *categoryLabel=[[UILabel alloc]init];
        categoryLabel.font=[UIFont boldSystemFontOfSize:11];
        categoryLabel.textColor=[UIColor whiteColor];
        categoryLabel.textAlignment=NSTextAlignmentCenter;
        categoryLabel.layer.cornerRadius=2;
        categoryLabel.layer.masksToBounds=YES;
        [self.contentView addSubview:categoryLabel];
        self.categoryLabel=categoryLabel;
        
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.numberOfLines=0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel=titleLabel;
        
        UILabel *dateLabel=[[UILabel alloc]init];
        dateLabel.font=[UIFont systemFontOfSize:12];
        dateLabel.numberOfLines=0;
        dateLabel.textColor=[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        [self.contentView addSubview:dateLabel];
        self.dateLabel=dateLabel;
        
        UILabel *sourceLabel=[[UILabel alloc]init];
        sourceLabel.font=[UIFont systemFontOfSize:12];
        sourceLabel.textColor=[UIColor colorWithRed:0.92 green:0.39 blue:0.39 alpha:0.5];
        [self.contentView addSubview:sourceLabel];
        self.sourceLabel=sourceLabel;
        
        //添加分享按钮
        UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:shareBtn];
        self.shareBtn=shareBtn;
    }
    return self;
}

-(void)setDevFrame:(MDevFrame *)devFrame{
    MDev *dev=devFrame.dev;
    _devFrame=devFrame;
    _devFrame.dev=devFrame.dev;
    
    if ([dev.dev_category isEqualToString:@"top"]) {
        self.categoryLabel.text=@"头条";
        self.categoryLabel.backgroundColor=[UIColor colorWithRed:0.87 green:0.37 blue:0.32 alpha:1];
    }else if ([dev.dev_category isEqualToString:@"front"]){
        self.categoryLabel.text=@"前端";
        self.categoryLabel.backgroundColor=[UIColor colorWithRed:0.89 green:0.5 blue:0.26 alpha:1];
    }else if ([dev.dev_category isEqualToString:@"python"]){
        self.categoryLabel.text=@"Py";
        self.categoryLabel.backgroundColor=[UIColor colorWithRed:0.38 green:0.55 blue:0.4 alpha:1];
    }else if ([dev.dev_category isEqualToString:@"iOS"]){
        self.categoryLabel.text=@"iOS";
        self.categoryLabel.backgroundColor=[UIColor colorWithRed:0.55 green:0.77 blue:0.78 alpha:1];
    }else if ([dev.dev_category isEqualToString:@"mySQL"]){
        self.categoryLabel.text=@"DB";
        self.categoryLabel.backgroundColor=[UIColor colorWithRed:0.45 green:0.61 blue:0.78 alpha:1];
    }else if ([dev.dev_category isEqualToString:@"operation"]){
        self.categoryLabel.text=@"运维";
        self.categoryLabel.backgroundColor=[UIColor colorWithRed:0.69 green:0.39 blue:0.61 alpha:1];
    }
    
    self.titleLabel.text=dev.dev_title;
    self.dateLabel.text=dev.dev_date;
    self.sourceLabel.text=dev.dev_source;
    
    self.categoryLabel.frame=devFrame.categoryF;
    self.titleLabel.frame=devFrame.titleF;
    self.dateLabel.frame=devFrame.dateF;
    self.sourceLabel.frame=devFrame.sourceF;
    self.shareBtn.frame=devFrame.shareBtnF;
}

//当处于编辑取消收藏状态时，因为左边有删除按钮占据空间，导致cell右移，所以右边滑出的“取消收藏”会被遮挡，所以此处把cell放底层，“取消收藏”放在上面
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.isEditing) {
        [self sendSubviewToBack:self.contentView];
    }
}

@end
