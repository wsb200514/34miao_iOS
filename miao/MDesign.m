//
//  MDesign.m
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MDesign.h"

@implementation MDesign
+(instancetype)designWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.design_title=[dict[@"fields"][@"design_title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.design_date=dict[@"fields"][@"design_date"];
        self.design_link=dict[@"fields"][@"design_link"];
        self.design_source=dict[@"fields"][@"design_source"];
        self.design_img_url=dict[@"fields"][@"design_img_url"];
        self.design_id=dict[@"pk"];
    }
    return self;
}

-(NSString *)design_date{
    //获取当前的时间元素
    NSCalendar *calendar=[NSCalendar currentCalendar];
    int unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour;
    NSDateComponents *currentCmps=[calendar components:unit fromDate:[NSDate date]];
    //获取产品的时间元素
    NSString *design_date_year=[_design_date substringWithRange:NSMakeRange(0, 4)];
    NSString *design_date_month=[_design_date substringWithRange:NSMakeRange(5, 2)];
    NSString *design_date_day=[_design_date substringWithRange:NSMakeRange(8, 2)];
    NSString *design_date_hour=[_design_date substringWithRange:NSMakeRange(11, 2)];
    NSString *design_date_minute=[_design_date substringWithRange:NSMakeRange(14, 2)];
    int deltaYear=(int)currentCmps.year-[design_date_year intValue];
    int deltaMonth=(int)currentCmps.month-[design_date_month intValue];
    int deltaDay=(int)currentCmps.day-[design_date_day intValue];
    if ((deltaYear==0)&&(deltaMonth==0)&&(deltaDay==0)) {
        int deltaHours=(int)currentCmps.hour-[design_date_hour intValue];
        int deltaMinutes=(int)currentCmps.minute-[design_date_minute intValue];
        if (deltaHours>=1) {
            return [NSString stringWithFormat:@"%ld小时前",(long)deltaHours];
        }else if (deltaMinutes>=1){
            return [NSString stringWithFormat:@"%ld分钟前",(long)deltaMinutes];
        }else{
            return @"刚刚";
        }
    }else{
        return [_design_date substringWithRange:NSMakeRange(0, 10)];
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_design_title forKey:@"design_title"];
    [aCoder encodeObject:_design_date forKey:@"design_date"];
    [aCoder encodeObject:_design_link forKey:@"design_link"];
    [aCoder encodeObject:_design_source forKey:@"design_source"];
    [aCoder encodeObject:_design_img_url forKey:@"design_img_url"];
    [aCoder encodeObject:_design_id forKey:@"design_id"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _design_title=[aDecoder decodeObjectForKey:@"design_title"];
        _design_date=[aDecoder decodeObjectForKey:@"design_date"];
        _design_link=[aDecoder decodeObjectForKey:@"design_link"];
        _design_source=[aDecoder decodeObjectForKey:@"design_source"];
        _design_img_url=[aDecoder decodeObjectForKey:@"design_img_url"];
        _design_id=[aDecoder decodeObjectForKey:@"design_id"];
    }
    return self;
}

@end
