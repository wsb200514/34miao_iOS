//
//  MProductFrame.m
//  sansimiao
//
//  Created by 魏素宝 on 15/8/27.
//  Copyright (c) 2015年 SUBAOWEI. All rights reserved.
//

#import "MProductFrame.h"
#import "MProduct.h"

@implementation MProductFrame
-(void)setProduct:(MProduct *)product{
    _product=product;
    CGFloat marginLeft=15;
    CGFloat marginRight=10;
    CGFloat marginTop=10;
    //设置cell宽度
    CGFloat cellW=[UIScreen mainScreen].bounds.size.width;
    
    //设置来源
    CGFloat sourceW=24;
    CGFloat sourceH=24;
    CGFloat sourceX=marginLeft;
    CGFloat sourceY=marginTop;
    _sourceF=CGRectMake(sourceX, sourceY, sourceW, sourceH);
    
    //设置名称
    CGFloat nameX=CGRectGetMaxX(_sourceF)+marginLeft;
    CGFloat nameY=sourceY;
    CGFloat nameW=cellW-marginLeft-sourceW-marginRight*3;
    NSDictionary *nameAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGSize nameLabelSize=[product.p_name boundingRectWithSize:CGSizeMake(nameW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nameAttrDict context:nil].size;
    _nameF=(CGRect){{nameX,nameY},nameLabelSize};
    
    //设置描述
    CGFloat descX=nameX;
    CGFloat descY=CGRectGetMaxY(_nameF)+8;
    CGFloat descW=nameW;
    NSDictionary *descAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGSize descLabelSize=[product.p_desc boundingRectWithSize:CGSizeMake(descW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:descAttrDict context:nil].size;
    _descF=(CGRect){{descX,descY},descLabelSize};
    
    //设置日期
    CGFloat dateX=descX;
    CGFloat dateY=CGRectGetMaxY(_descF)+8;
    NSDictionary *dateAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
    CGSize dateLabelSize=[product.p_date boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:dateAttrDict context:nil].size;
    _dateF=(CGRect){{dateX,dateY},dateLabelSize};
    
    //设置分享按钮
    CGFloat shareBtnX=CGRectGetMaxX(_dateF)+10;
    CGFloat shareBtnY=dateY;
    CGFloat shareBtnW=21;
    CGFloat shareBtnH=14;
    _shareBtnF=CGRectMake(shareBtnX, shareBtnY, shareBtnW, shareBtnH);
    
    //设置cell高度
    _cellH=CGRectGetMaxY(_dateF)+6;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_product forKey:@"product"];
    [aCoder encodeCGRect:_nameF forKey:@"nameF"];
    [aCoder encodeCGRect:_descF forKey:@"descF"];
    [aCoder encodeCGRect:_sourceF forKey:@"sourceF"];
    [aCoder encodeCGRect:_dateF forKey:@"dateF"];
    [aCoder encodeCGRect:_shareBtnF forKey:@"shareBtnF"];
    [aCoder encodeFloat:_cellH forKey:@"cellH"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _product=[aDecoder decodeObjectForKey:@"product"];
        _nameF=[aDecoder decodeCGRectForKey:@"nameF"];
        _descF=[aDecoder decodeCGRectForKey:@"descF"];
        _sourceF=[aDecoder decodeCGRectForKey:@"sourceF"];
        _dateF=[aDecoder decodeCGRectForKey:@"dateF"];
        _shareBtnF=[aDecoder decodeCGRectForKey:@"shareBtnF"];
        _cellH=[aDecoder decodeFloatForKey:@"cellH"];
    }
    return self;
}


@end
