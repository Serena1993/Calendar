//
//  NSDate+CalendarLogic.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/2.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//

import Foundation

extension Date{
    /*计算这个月有多少天*/
    func numberOfDaysInCurrentMonth() -> NSInteger{
        return (Calendar.current as NSCalendar).range(of: .day , in: .month, for: self).length
    }
    
    //获取这个月有多少周
    func numberOfWeeksInCurrentMonth() -> NSInteger{
        let weekday = firstDayOfCurrentMonth().weeklyOrdinality()
        var days = numberOfDaysInCurrentMonth()
        var weeks = 0
        
        if weekday > 1{
            weeks += 1; days -= (7 - weekday + 1)
        }
        weeks += (days / 7)
        weeks += (days % 7 > 0) ? 1 : 0
        return weeks
    }
    
    /*计算这个月的第一天是礼拜几*/
    func weeklyOrdinality() -> NSInteger{
        return (Calendar.current as NSCalendar).ordinality(of: NSCalendar.Unit.day , in: NSCalendar.Unit.weekOfMonth , for: self)
    }
    
    //计算这个月最开始的一天
    func firstDayOfCurrentMonth() -> Date{
        var startDate : Date = Date()
        var timeInterval: TimeInterval = 0.0
        //        let ok = (Calendar.current as Calendar).range(of: .month, in: startDate, for: self)
        let _ = Calendar.current.dateInterval(of: .month, start: &startDate, interval: &timeInterval, for: self)
        return startDate
    }
    
    func lastDayOfCurrentMonth() -> Date{
        var dateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: self)
        dateComponents.day = numberOfDaysInCurrentMonth()
        return Calendar.current.date(from: dateComponents)!
    }
    
    //上一个月
    func dayInThePreviousMonth() -> Date{
        var dateComponents = DateComponents()
        dateComponents.month = -1;
        return (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: self, options: .matchStrictly)!
    }
    
    //下一个月
    func dayInTheFollowingMonth() -> Date{
        var dateComponents = DateComponents()
        dateComponents.month = 1;
        return (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: self, options: .matchStrictly)!
    }
    
    //获取当前日期之后的几个月
    func dayInTheFollowingMonth(_ month: NSInteger) -> Date{
        var dateComponents = DateComponents()
        dateComponents.month = month;
        return (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: self, options: .matchStrictly)!
    }
    
    //获取当前日期之后的几个天
    func dayInTheFollowingDay(_ day: NSInteger) -> Date{
        var dateComponents = DateComponents()
        dateComponents.day = day
        return (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: self, options: .matchStrictly)!
    }
    
    
    
    //获取年月日对象
    func YMDComponents() -> DateComponents{
        return (Calendar.current as NSCalendar).components([.year,.month,.day,.weekday], from: self)
    }
    
    
    //-----------------------------------------
    
    //NSString转Date
    static func dateFromString(_ dateString: String, formate: String) -> Date?{
        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600*8)
        dateFormatter.dateFormat = formate
        return dateFormatter.date(from: dateString)
    }
    
    
    
    //Date转NSString
    static func stringFromDate(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600*8)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    static func stringFromDate(_ date:Date,format:String) -> String{
        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600*8)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func getDayNumbertoDay(_ today: Date, beforDay: Date) -> NSInteger{
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = (calendar as NSCalendar?)?.components(NSCalendar.Unit.day, from: today, to: beforDay, options: .matchStrictly)
        return (components?.day)!
    }
    
    //周日是“1”，周一是“2”...
    func getWeekIntValueWithDate() -> NSInteger{
        let calendar = Calendar(identifier: Calendar.Identifier.chinese)
        let comps = (calendar as NSCalendar?)?.components([.year, .month, .day, .weekday], from: self)
        return (comps?.weekday)!
    }
    
    func getWeekIntValueDesc()->String{
        let day = getWeekIntValueWithDate()
        switch day {
        case 1:
            return "周日"
        case 2:
            return "周一"
        case 3:
            return "周二"
        case 4:
            return "周三"
        case 5:
            return "周四"
        case 6:
            return "周五"
        case 7:
            return "周六"
        default:
            return ""
        }
    }
    
    //判断日期是今天,明天,后天,周几
    func compareIfTodayWithDate() -> String{
        let todate = Date()
        let calendar = Calendar(identifier: Calendar.Identifier.chinese)
        let comps_today = (calendar as NSCalendar?)?.components([.year, .month, .day, .weekday], from: todate)
        let comps_other = (calendar as NSCalendar?)?.components([.year, .month, .day, .weekday], from: self)
        let weekIntValue = getWeekIntValueWithDate()
        if comps_today?.year == comps_other?.year && comps_today?.month == comps_other?.month && comps_today?.day == comps_other?.day{
            return "今天"
        }
        if comps_today?.year == comps_other?.year && comps_today?.month == comps_other?.month && ((comps_today?.day)! - (comps_other?.day)!) ==  -1{
            return "明天"
        }
        if comps_today?.year == comps_other?.year && comps_today?.month == comps_other?.month && ((comps_today?.day)! - (comps_other?.day)!) ==  -2{
            return "后天"
        }else{
            return Date.getWeekStringFromInteger(weekIntValue)
        }
        
    }
    
    
    
    //通过数字返回星期几
    static func getWeekStringFromInteger(_ week: NSInteger) -> String{
        var str_week = ""
        switch (week) {
        case 1:
            str_week = "周日"
            break;
        case 2:
            str_week = "周一"
            break;
        case 3:
            str_week = "周二"
            break;
        case 4:
            str_week = "周三"
            break;
        case 5:
            str_week = "周四"
            break;
        case 6:
            str_week = "周五"
            break;
        case 7:
            str_week = "周六"
            break;
        default:
            break
        }
        return str_week;
    }
    
    
}
