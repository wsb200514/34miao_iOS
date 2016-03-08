//
//  MDesignCell.m
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MDesignCell.h"
#import "MDesign.h"
#import "MDesignFrame.h"
#import "UIImageView+WebCache.h"

@interface MDesignCell()
@property(nonatomic,weak) UIImageView *designImgView;
@property(nonatomic,weak) UIView *shieldView;
@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,weak) UILabel *sourceLabel;
@property(nonatomic,weak) UILabel *dateLabel;
@end

@implementation MDesignCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加控件
        UIImageView *designImgView=[[UIImageView alloc]init];
        designImgView.layer.cornerRadius=0;
        designImgView.layer.masksToBounds=YES;
        designImgView.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:designImgView];
        self.designImgView=designImgView;
        
        UIView *shieldView=[[UIView alloc]init];
        shieldView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self.contentView addSubview:shieldView];
        self.shieldView=shieldView;
        
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.font=[UIFont boldSystemFontOfSize:22];
        titleLabel.textColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        titleLabel.numberOfLines=0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel=titleLabel;
        
        UILabel *dateLabel=[[UILabel alloc]init];
        dateLabel.font=[UIFont systemFontOfSize:12];
        dateLabel.numberOfLines=0;
        dateLabel.textColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
        [self.contentView addSubview:dateLabel];
        self.dateLabel=dateLabel;
        
        UILabel *sourceLabel=[[UILabel alloc]init];
        sourceLabel.font=[UIFont systemFontOfSize:12];
        sourceLabel.textColor=[UIColor colorWithRed:0.92 green:0.39 blue:0.39 alpha:0.7];
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

-(void)setDesignFrame:(MDesignFrame *)designFrame{
    MDesign *design=designFrame.design;
    _designFrame=designFrame;
    _designFrame.design=designFrame.design;
    
    [self.designImgView sd_setImageWithURL:[NSURL URLWithString:design.design_img_url]];
    self.titleLabel.text=design.design_title;
    self.dateLabel.text=design.design_date;
    self.sourceLabel.text=design.design_source;
    
    self.designImgView.frame=designFrame.imgViewF;
    self.shieldView.frame=designFrame.shieldViewF;
    self.titleLabel.frame=designFrame.titleF;
    self.dateLabel.frame=designFrame.dateF;
    self.sourceLabel.frame=designFrame.sourceF;
    self.shareBtn.frame=designFrame.shareBtnF;
}

//当处于编辑取消收藏状态时，因为左边有删除按钮占据空间，导致cell右移，所以右边滑出的“取消收藏”会被遮挡，所以此处把cell放底层，“取消收藏”放在上面
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.isEditing) {
        [self sendSubviewToBack:self.contentView];
    }
}

@end
