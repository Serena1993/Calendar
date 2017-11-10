//
//  CalendarLogic.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/2.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//

import Foundation



class CalendarLogic: NSObject {
    var today = Date() //今天的日期
    var before = Date() //之后的日期
    var select = Date() //选择的日期
    var startDate = Date() //最早的可选日期
    var selectcalendarDay = CalendarDayModel()
    var datesAndTags:[(String,String)]?
    //    - (NSMutableArray *)reloadCalendarView:(Date *)date  selectDate:(Date *)date1 needDays:(int)days_number;
    //    - (void)selectLogic:(CalendarDayModel *)day;
    func reloadCalendarView(_ date: Date,startDate:Date, selectDate: Date, days_number: NSInteger) -> [AnyObject]{

        today = date //起始日期
        before = date.dayInTheFollowingDay(days_number) //计算它days天以后的时间
        select = selectDate //选择的日期
        self.startDate = startDate
        
        let todayDC = today.YMDComponents()
        let beforeDC = before.YMDComponents()
        let todayYear = todayDC.year
        let todayMonth = todayDC.month
        let beforeYear = beforeDC.year;
        let beforeMonth = beforeDC.month;
        let months = (beforeYear!-todayYear!) * 12 + (beforeMonth! - todayMonth!)
        var calendarMonth = [AnyObject]()
        for i in 0..<months+1 {
            let month = today.dayInTheFollowingMonth(i)
            var calendarDays = [AnyObject]()
            calendarDays = calculateDaysInPreviousMonthWithDate(month, array: &calendarDays)
            
            calendarDays = calculateDaysInCurrentMonthWithDate(month, array: &calendarDays)
            
            calendarDays = calculateDaysInFollowingMonthWithDate(month, array: &calendarDays)
            
            calendarMonth.insert(calendarDays as AnyObject, at: i)
        }
        return calendarMonth;
    }
    
    //计算上月份的天数
    
    func calculateDaysInPreviousMonthWithDate(_ date:Date, array:inout [AnyObject]) -> [AnyObject]{
        let weeklyOrdinality = date.firstDayOfCurrentMonth().weeklyOrdinality()//计算这个的第一天是礼拜几,并转为int型
        let dayInThePreviousMonth = date.dayInThePreviousMonth() //上一个月的Date对象
        let daysCount = dayInThePreviousMonth.numberOfDaysInCurrentMonth() //计算上个月有多少天
        let partialDaysCount = weeklyOrdinality - 1     //获取上月在这个月的日历上显示的天数
        let components = dayInThePreviousMonth.YMDComponents()  //获取年月日对象
        
        for i in daysCount - partialDaysCount + 1..<daysCount + 1 {
            let calendarDay = CalendarDayModel.calendarDayWithYear(components.year!, month: components.month!, day: i)
            calendarDay.style = .CellDayTypeEmpty
            array.append(calendarDay)
        }
        

        return array
        
    }
    
    //计算下月份的天数
    func calculateDaysInFollowingMonthWithDate(_ date: Date, array: inout [AnyObject]) -> [AnyObject]{
        
        let weeklyOrdinality = date.lastDayOfCurrentMonth().weeklyOrdinality()
        if weeklyOrdinality == 7{
            return array
        }
        let partialDaysCount = 7 - weeklyOrdinality
        let components = date.dayInTheFollowingMonth().YMDComponents()
        for i in 0..<partialDaysCount - 1 {
            let calendarDay = CalendarDayModel.calendarDayWithYear(components.year!, month: components.month! , day: i)
            calendarDay.style = .CellDayTypeEmpty
            array.append(calendarDay)
        }
        return array
        
    }
    
    //计算当月的天数
    func calculateDaysInCurrentMonthWithDate(_ date: Date, array:inout [AnyObject]) -> [AnyObject]{
        let daysCount = date.numberOfDaysInCurrentMonth()
        let components = date.YMDComponents()
        
        for i in 1..<daysCount + 1{
            let calendarDay = CalendarDayModel.calendarDayWithYear(components.year!, month: components.month! , day: i)
//            print(calendarDay.month)
            calendarDay.week = calendarDay.date().getWeekIntValueWithDate()
            LunarForSolarYear(calendarDay)
            changStyle(calendarDay)
            setTag(calendarDay)
            setValid(calendarDay)
            array.append(calendarDay)
        }
        return array
    }
    
    func changStyle(_ calendarDay: CalendarDayModel){
        let calendarToDay  = today.YMDComponents() //今天
        let calendarbefore = before.YMDComponents()//最后一天
        let calendarSelect = select.YMDComponents() //默认选择的那一天
        let calendarValid = startDate.YMDComponents() //有效期的第一天
        
        if calendarSelect.year == calendarDay.year && calendarSelect.month == calendarDay.month && calendarSelect.day == calendarDay.day {
            selectcalendarDay = calendarDay
            selectcalendarDay.style = .CellDayTypeClick
            
        //没被点击选中
        }else{
            if calendarValid.year! >= calendarDay.year &&
                calendarValid.month! >= calendarDay.month &&
                calendarValid.day! > calendarDay.day{
                
                calendarDay.style = .CellDayTypeInvalid
                //昨天乃至过去的时间设置一个灰度
            }else if (calendarToDay.year! >= calendarDay.year &&
                calendarToDay.month! >= calendarDay.month &&
                calendarToDay.day! > calendarDay.day) {
                    
                    calendarDay.style = .CellDayTypePast;
                    
                    //之后的时间时间段
            }else if (calendarbefore.year! <= calendarDay.year &&
                calendarbefore.month! <= calendarDay.month &&
                calendarbefore.day! <= calendarDay.day) {
                    
                    calendarDay.style = .CellDayTypePast;
                    
                    //需要正常显示的时间段
            }else{
                
                //周末
                if (calendarDay.week == 1 || calendarDay.week == 7){
                    calendarDay.style = .CellDayTypeWeek;
                    
                    //工作日
                }else{
                    calendarDay.style = .CellDayTypeFuture;
                }
            }
        }
        
        
        //===================================
        //这里来判断节日
        //今天
        if (calendarToDay.year == calendarDay.year &&
            calendarToDay.month == calendarDay.month &&
            calendarToDay.day == calendarDay.day) {
                calendarDay.holiday = "今天";
                
                //明天
        }else if(calendarToDay.year! == calendarDay.year &&
            calendarToDay.month! == calendarDay.month &&
            calendarToDay.day! - calendarDay.day == -1){
                calendarDay.holiday = "明天";
                
                //后天
        }else if(calendarToDay.year! == calendarDay.year &&
            calendarToDay.month! == calendarDay.month &&
            calendarToDay.day! - calendarDay.day == -2){
                calendarDay.holiday = "后天";
                
                //1.1元旦
        }else if (calendarDay.month == 1 &&
            calendarDay.day == 1){
                calendarDay.holiday = "元旦";
                
                //2.14情人节
        }else if (calendarDay.month == 2 &&
            calendarDay.day == 14){
                calendarDay.holiday = "情人节";
                
                //3.8妇女节
        }else if (calendarDay.month == 3 &&
            calendarDay.day == 8){
                calendarDay.holiday = "妇女节";
                
                //5.1劳动节
        }else if (calendarDay.month == 5 &&
            calendarDay.day == 1){
                calendarDay.holiday = "劳动节";
                
                //6.1儿童节
        }else if (calendarDay.month == 6 &&
            calendarDay.day == 1){
                calendarDay.holiday = "儿童节";
                
                //8.1建军节
        }else if (calendarDay.month == 8 &&
            calendarDay.day == 1){
                calendarDay.holiday = "建军节";
                
                //9.10教师节
        }else if (calendarDay.month == 9 &&
            calendarDay.day == 10){
                calendarDay.holiday = "教师节";
                
                //10.1国庆节
        }else if (calendarDay.month == 10 &&
            calendarDay.day == 1){
                calendarDay.holiday = "国庆节";
                
                //11.1植树节
        }else if (calendarDay.month == 3 &&
            calendarDay.day == 12){
                calendarDay.holiday = "植树节";
                
                //11.11光棍节
        }else if (calendarDay.month == 11 &&
            calendarDay.day == 11){
                calendarDay.holiday = "光棍节";
                
        }else{
            
            
            calendarDay.holiday = "";
            
        }
    }
    func LunarForSolarYear(_ calendarDay: CalendarDayModel){
        let solarYear = LunarForSolarYear(calendarDay.year, Month: calendarDay.month, Day: calendarDay.day)
        
        let solarYear_arr = solarYear.components(separatedBy: "-")
        
        if (solarYear_arr[0] == "正" && solarYear_arr[1] == "初一"){
            //正月初一：春节
            calendarDay.holiday = "春节"

        }else if solarYear_arr[0] == "正" &&
             solarYear_arr[1] == "十五" {
                
                
                //正月十五：元宵节
                calendarDay.holiday = "元宵"
                
        }else if solarYear_arr[0] == "二" &&
             solarYear_arr[1] == "初二" {
                
                //二月初二：春龙节(龙抬头)
                calendarDay.holiday = "龙抬头"
                
        }else if solarYear_arr[0] == "五" &&
             solarYear_arr[1] == "初五" {
                
                //五月初五：端午节
                calendarDay.holiday = "端午"
                
        }else if solarYear_arr[0] == "七" &&
             solarYear_arr[1] == "初七" {
                
                //七月初七：七夕情人节
                calendarDay.holiday = "七夕"
                
        }else if solarYear_arr[0] == "八" &&
             solarYear_arr[1] == "十五" {
                
                //八月十五：中秋节
                calendarDay.holiday = "中秋"
                
        }else if solarYear_arr[0] == "九" &&
             solarYear_arr[1] == "初九" {
                
                //九月初九：重阳节、中国老年节（义务助老活动日）
                calendarDay.holiday = "重阳"
                
        }else if solarYear_arr[0] == "腊" &&
             solarYear_arr[1] == "初八" {
                
                //腊月初八：腊八节
                calendarDay.holiday = "腊八"
                
        }else if solarYear_arr[0] == "腊" &&
             solarYear_arr[1] == "二十四" {
                
                
                //腊月二十四 小年
                calendarDay.holiday = "小年"
                
        }else if solarYear_arr[0] == "腊" &&
             solarYear_arr[1] == "三十" {
                
                //腊月三十（小月二十九）：除夕
                calendarDay.holiday = "除夕"
                
        }
        calendarDay.Chinese_calendar = solarYear_arr[1];
    }

    
    func LunarForSolarYear(_ wCurYear: NSInteger,Month:Int,Day:Int) -> String{
        var _wCurYear = wCurYear
        var _month = Month
        var _day = Day
        let cDayName = ["*","初一","初二","初三","初四","初五","初六","初七","初八","初九","初十",
            "十一","十二","十三","十四","十五","十六","十七","十八","十九","二十",
            "廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"]
        let cMonName = ["*","正","二","三","四","五","六","七","八","九","十","十一","腊"]
        let WMonthAdd = [0,31,59,90,120,151,181,212,243,273,304,334]
        let wNongliData = [2635,333387,1701,1748,267701,694,2391,133423,1175,396438
            ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
            ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
            ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
            ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
            ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
            ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
            ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
            ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
            ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877]
        var nTheDate,nIsEnd,m,k,n,nBit:Int!
         //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
        nTheDate = (_wCurYear - 1921) * 365 + (_wCurYear - 1921) / 4
        nTheDate = nTheDate + _day + WMonthAdd[_month - 1] - 38
        if((_wCurYear % 4 == 0) && (_month > 2)){
            nTheDate = nTheDate + 1
        }
        
        //计算农历天干、地支、月、日
        nIsEnd = 0;
        m = 0;
        while(nIsEnd != 1)
        {
            if(wNongliData[m] < 4095){k = 11}
            else{k = 12;}
            n = k;
            while(n>=0)
            {
                //获取wNongliData(m)的第n个二进制位的值
                nBit = wNongliData[m];
                for _ in 1..<n + 1{nBit = nBit / 2}
                nBit = nBit % 2;
                if (nTheDate <= (29 + nBit)){
                    nIsEnd = 1;
                    break;
                }
                nTheDate = nTheDate - 29 - nBit;
                n = n - 1;
            }
            if(nIsEnd != 0){break}
            m = m + 1;
        }
        _wCurYear = 1921 + m;
        _month = k - n + 1;
        _day = nTheDate;
        if (k == 12)
        {
            if (_month == wNongliData[m] / 65536 + 1){
                _month = 1 - _month}
            else if (_month > wNongliData[m] / 65536 + 1){
                _month = _month - 1}
        }
        
        //生成农历月
        var szNongliMonth = ""
        if (_month < 1){
            szNongliMonth = "闰\(cMonName[-1 * _month])"
        }else{
            szNongliMonth = "\(cMonName[_month])"
        }
        
        //生成农历日
        let szNongliDay = cDayName[_day]
        return "\(szNongliMonth)-\(szNongliDay)"
    }
    
    func selectLogic(_ day: CalendarDayModel){
        if day.style == .CellDayTypeClick {
            return
        }
        day.style = .CellDayTypeClick
        if (selectcalendarDay.week == 1 || selectcalendarDay.week == 7){
            selectcalendarDay.style = .CellDayTypeWeek
        }else{
            selectcalendarDay.style = .CellDayTypeFuture
        }
        selectcalendarDay = day
    }
    
    func setTag(_ calendarDay:CalendarDayModel){
        if datesAndTags != nil && datesAndTags!.count > 0{
            for tag in datesAndTags!{
                if calendarDay.toString("yyyy-MM-dd") == tag.0 {
                    calendarDay.tag = tag.1
                }
            }
        }
    }
    
    
    func setValid(_ calendarDay:CalendarDayModel){
        if datesAndTags != nil{
            if (datesAndTags?.count)! > 0{
                for tag in datesAndTags!{
                    if calendarDay.toString("yyyy-MM-dd") == tag.0 || tag.0 == ""{
                        return
                    }
                }
            }
            calendarDay.style = .CellDayTypeInvalid
        }
    }
}
