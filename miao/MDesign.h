//
//  MDesign.h
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDesign : NSObject
@property(nonatomic,copy) NSString *design_title;
@property(nonatomic,copy) NSString *design_date;
@property(nonatomic,copy) NSString *design_link;
@property(nonatomic,copy) NSString *design_img_url;
@property(nonatomic,copy) NSString *design_source;
@property(nonatomic,copy) NSString *design_id;

+(instancetype)designWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
@end
