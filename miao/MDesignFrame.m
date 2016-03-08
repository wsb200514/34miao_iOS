//
//  MDesignFrame.m
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MDesignFrame.h"
#import "MDesign.h"

@implementation MDesignFrame
-(void)setDesign:(MDesign *)design{
    _design=design;
    CGFloat marginLeft=14;
    CGFloat marginRight=80;
    CGFloat marginBottom=1;
    //设置cell宽度
    CGFloat cellW=[UIScreen mainScreen].bounds.size.width;
    
    //设置图片
    CGFloat imgViewW=cellW;
    CGFloat imgViewH=190;
    CGFloat imgViewX=0;
    CGFloat imgViewY=0;
    _imgViewF=CGRectMake(imgViewX, imgViewY, imgViewW, imgViewH);
    
    //设置遮罩
    _shieldViewF=_imgViewF;
    
    //设置日期
    CGFloat dateX=marginLeft;
    CGFloat dateY=CGRectGetMaxY(_imgViewF)-24;
    NSDictionary *dateAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
    CGSize dateLabelSize=[design.design_date boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:dateAttrDict context:nil].size;
    _dateF=(CGRect){{dateX,dateY},dateLabelSize};
    
    //设置来源
    CGFloat sourceW=cellW;
    CGFloat sourceX=CGRectGetMaxX(_dateF)+10;
    CGFloat sourceY=dateY;
    NSDictionary *sourceAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
    CGSize sourceLabelSize=[design.design_source boundingRectWithSize:CGSizeMake(sourceW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:sourceAttrDict context:nil].size;
    _sourceF=(CGRect){{sourceX,sourceY},sourceLabelSize};
    
    //设置标题
    //CGFloat titleX=marginLeft;
    //CGFloat titleW=cellW-marginLeft-marginRight;
    CGFloat titleW=cellW-60;
    NSDictionary *titleAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    CGSize titleLabelSize=[design.design_title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttrDict context:nil].size;
    CGFloat titleX=0.5*(cellW-titleLabelSize.width);
    CGFloat titleY=0.5*(190-titleLabelSize.height);
    //CGFloat titleY=CGRectGetMinY(_dateF)-titleLabelSize.height-8;
    _titleF=(CGRect){{titleX,titleY},titleLabelSize};
    
    //设置分享按钮
    CGFloat shareBtnX=CGRectGetMaxX(_sourceF)+10;
    CGFloat shareBtnY=dateY;
    CGFloat shareBtnW=21;
    CGFloat shareBtnH=14;
    _shareBtnF=CGRectMake(shareBtnX, shareBtnY, shareBtnW, shareBtnH);
    
    //设置cell高度
    _cellH=CGRectGetMaxY(_imgViewF)+marginBottom;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_design forKey:@"design"];
    [aCoder encodeCGRect:_titleF forKey:@"titleF"];
    [aCoder encodeCGRect:_imgViewF forKey:@"imgViewF"];
    [aCoder encodeCGRect:_sourceF forKey:@"sourceF"];
    [aCoder encodeCGRect:_dateF forKey:@"dateF"];
    [aCoder encodeCGRect:_shareBtnF forKey:@"shareBtnF"];
    [aCoder encodeFloat:_cellH forKey:@"cellH"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _design=[aDecoder decodeObjectForKey:@"design"];
        _titleF=[aDecoder decodeCGRectForKey:@"titleF"];
        _imgViewF=[aDecoder decodeCGRectForKey:@"imgViewF"];
        _sourceF=[aDecoder decodeCGRectForKey:@"sourceF"];
        _dateF=[aDecoder decodeCGRectForKey:@"dateF"];
        _shareBtnF=[aDecoder decodeCGRectForKey:@"shareBtnF"];
        _cellH=[aDecoder decodeFloatForKey:@"cellH"];
    }
    return self;
}
@end
