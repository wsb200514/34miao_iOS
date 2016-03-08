//
//  MMarketing.m
//  miao
//
//  Created by 魏素宝 on 15/9/20.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MMarketing.h"

@implementation MMarketing
+(instancetype)marketingWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.m_title=[dict[@"fields"][@"m_title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.m_date=dict[@"fields"][@"m_date"];
        self.m_link=dict[@"fields"][@"m_link"];
        self.m_source=dict[@"fields"][@"m_source"];
        self.m_img_url=dict[@"fields"][@"m_img_url"];
        self.m_id=dict[@"pk"];
    }
    return self;
}

-(NSString *)m_date{
    //获取当前的时间元素
    NSCalendar *calendar=[NSCalendar currentCalendar];
    int unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour;
    NSDateComponents *currentCmps=[calendar components:unit fromDate:[NSDate date]];
    //获取产品的时间元素
    NSString *m_date_year=[_m_date substringWithRange:NSMakeRange(0, 4)];
    NSString *m_date_month=[_m_date substringWithRange:NSMakeRange(5, 2)];
    NSString *m_date_day=[_m_date substringWithRange:NSMakeRange(8, 2)];
    NSString *m_date_hour=[_m_date substringWithRange:NSMakeRange(11, 2)];
    NSString *m_date_minute=[_m_date substringWithRange:NSMakeRange(14, 2)];
    int deltaYear=(int)currentCmps.year-[m_date_year intValue];
    int deltaMonth=(int)currentCmps.month-[m_date_month intValue];
    int deltaDay=(int)currentCmps.day-[m_date_day intValue];
    if ((deltaYear==0)&&(deltaMonth==0)&&(deltaDay==0)) {
        int deltaHours=(int)currentCmps.hour-[m_date_hour intValue];
        int deltaMinutes=(int)currentCmps.minute-[m_date_minute intValue];
        if (deltaHours>=1) {
            return [NSString stringWithFormat:@"%ld小时前",(long)deltaHours];
        }else if (deltaMinutes>=1){
            return [NSString stringWithFormat:@"%ld分钟前",(long)deltaMinutes];
        }else{
            return @"刚刚";
        }
    }else{
        return [_m_date substringWithRange:NSMakeRange(0, 10)];
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_m_title forKey:@"m_title"];
    [aCoder encodeObject:_m_date forKey:@"m_date"];
    [aCoder encodeObject:_m_link forKey:@"m_link"];
    [aCoder encodeObject:_m_source forKey:@"m_source"];
    [aCoder encodeObject:_m_img_url forKey:@"m_img_url"];
    [aCoder encodeObject:_m_id forKey:@"m_id"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _m_title=[aDecoder decodeObjectForKey:@"m_title"];
        _m_date=[aDecoder decodeObjectForKey:@"m_date"];
        _m_link=[aDecoder decodeObjectForKey:@"m_link"];
        _m_source=[aDecoder decodeObjectForKey:@"m_source"];
        _m_img_url=[aDecoder decodeObjectForKey:@"m_img_url"];
        _m_id=[aDecoder decodeObjectForKey:@"m_id"];
    }
    return self;
}
@end
