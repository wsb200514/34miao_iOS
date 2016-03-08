//
//  MProductCell.m
//  sansimiao
//
//  Created by 魏素宝 on 15/8/27.
//  Copyright (c) 2015年 SUBAOWEI. All rights reserved.
//

#import "MProductCell.h"
#import "MProduct.h"
#import "MProductFrame.h"

@interface MProductCell()
@property(nonatomic,weak) UIImageView *sourceImgView;
@property(nonatomic,weak) UILabel *nameLabel;
@property(nonatomic,weak) UILabel *descLabel;
@property(nonatomic,weak) UILabel *dateLabel;

@end

@implementation MProductCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加控件
        UIImageView *sourceImgView=[[UIImageView alloc]init];
        sourceImgView.layer.cornerRadius=4;
        sourceImgView.layer.masksToBounds=YES;
        [self.contentView addSubview:sourceImgView];
        self.sourceImgView=sourceImgView;
        
        UILabel *nameLabel=[[UILabel alloc]init];
        nameLabel.font=[UIFont systemFontOfSize:15];
        nameLabel.numberOfLines=0;
        [self.contentView addSubview:nameLabel];
        self.nameLabel=nameLabel;
        
        UILabel *descLabel=[[UILabel alloc]init];
        descLabel.font=[UIFont systemFontOfSize:14];
        descLabel.numberOfLines=0;
        descLabel.textColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        [self.contentView addSubview:descLabel];
        self.descLabel=descLabel;
        
        UILabel *dateLabel=[[UILabel alloc]init];
        dateLabel.font=[UIFont systemFontOfSize:12];
        dateLabel.textColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        [self.contentView addSubview:dateLabel];
        self.dateLabel=dateLabel;
        
        //添加分享按钮
        UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:shareBtn];
        self.shareBtn=shareBtn;
    }
    return self;
}

-(void)setProductFrame:(MProductFrame *)productFrame{
    MProduct *product=productFrame.product;
    _productFrame=productFrame;
    _productFrame.product=product;
    
    self.sourceImgView.image=[UIImage imageNamed:product.p_source];
    self.nameLabel.text=product.p_name;
    self.descLabel.text=product.p_desc;
    self.dateLabel.text=product.p_date;
    
    self.sourceImgView.frame=productFrame.sourceF;
    self.nameLabel.frame=productFrame.nameF;
    self.descLabel.frame=productFrame.descF;
    self.dateLabel.frame=productFrame.dateF;
    self.shareBtn.frame=productFrame.shareBtnF;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//当处于编辑取消收藏状态时，因为左边有删除按钮占据空间，导致cell右移，所以右边滑出的“取消收藏”会被遮挡，所以此处把cell放底层，“取消收藏”放在上面
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.isEditing) {
        [self sendSubviewToBack:self.contentView];
    }
}

@end
