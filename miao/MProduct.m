//
//  MProduct.m
//  sansimiao
//
//  Created by 魏素宝 on 15/8/27.
//  Copyright (c) 2015年 SUBAOWEI. All rights reserved.
//

#import "MProduct.h"

@implementation MProduct

+(instancetype)productWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.p_name=[dict[@"fields"][@"p_name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.p_desc=dict[@"fields"][@"p_desc"];
        self.p_date=dict[@"fields"][@"p_date"];
        self.p_link=dict[@"fields"][@"p_link"];
        self.p_source=dict[@"fields"][@"p_source"];
        self.p_source_link=dict[@"fields"][@"p_source_link"];
        self.p_id=dict[@"pk"];
    }
    return self;
}

-(NSString *)p_date{
    //获取当前的时间元素
    NSCalendar *calendar=[NSCalendar currentCalendar];
    int unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour;
    NSDateComponents *currentCmps=[calendar components:unit fromDate:[NSDate date]];
    //获取产品的时间元素
    NSString *p_date_year=[_p_date substringWithRange:NSMakeRange(0, 4)];
    NSString *p_date_month=[_p_date substringWithRange:NSMakeRange(5, 2)];
    NSString *p_date_day=[_p_date substringWithRange:NSMakeRange(8, 2)];
    NSString *p_date_hour=[_p_date substringWithRange:NSMakeRange(11, 2)];
    NSString *p_date_minute=[_p_date substringWithRange:NSMakeRange(14, 2)];
    int deltaYear=(int)currentCmps.year-[p_date_year intValue];
    int deltaMonth=(int)currentCmps.month-[p_date_month intValue];
    int deltaDay=(int)currentCmps.day-[p_date_day intValue];
    if ((deltaYear==0)&&(deltaMonth==0)&&(deltaDay==0)) {
        int deltaHours=(int)currentCmps.hour-[p_date_hour intValue];
        int deltaMinutes=(int)currentCmps.minute-[p_date_minute intValue];
        if (deltaHours>=1) {
            return [NSString stringWithFormat:@"%ld小时前",(long)deltaHours];
        }else if (deltaMinutes>=1){
            return [NSString stringWithFormat:@"%ld分钟前",(long)deltaMinutes];
        }else{
            return @"刚刚";
        }
    }else{
        return [_p_date substringWithRange:NSMakeRange(0, 10)];
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_p_name forKey:@"p_name"];
    [aCoder encodeObject:_p_desc forKey:@"p_desc"];
    [aCoder encodeObject:_p_date forKey:@"p_date"];
    [aCoder encodeObject:_p_link forKey:@"p_link"];
    [aCoder encodeObject:_p_source forKey:@"p_source"];
    [aCoder encodeObject:_p_source_link forKey:@"p_source_link"];
    [aCoder encodeObject:_p_id forKey:@"p_id"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _p_name=[aDecoder decodeObjectForKey:@"p_name"];
        _p_desc=[aDecoder decodeObjectForKey:@"p_desc"];
        _p_date=[aDecoder decodeObjectForKey:@"p_date"];
        _p_link=[aDecoder decodeObjectForKey:@"p_link"];
        _p_source=[aDecoder decodeObjectForKey:@"p_source"];
        _p_source_link=[aDecoder decodeObjectForKey:@"p_source_link"];
        _p_id=[aDecoder decodeObjectForKey:@"p_id"];
    }
    return self;
}
@end
