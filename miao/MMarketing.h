//
//  MMarketing.h
//  miao
//
//  Created by 魏素宝 on 15/9/20.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMarketing : NSObject
@property(nonatomic,copy) NSString *m_title;
@property(nonatomic,copy) NSString *m_date;
@property(nonatomic,copy) NSString *m_link;
@property(nonatomic,copy) NSString *m_img_url;
@property(nonatomic,copy) NSString *m_source;
@property(nonatomic,copy) NSString *m_id;

+(instancetype)marketingWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
@end
