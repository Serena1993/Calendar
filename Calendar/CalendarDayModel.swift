
//  CalendarDayModel.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/2.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//

import Foundation

enum CalendarDayStyle:String{
    case CellDayTypeEmpty = "CellDayTypeEmpty"
    case CellDayTypeClick = "CellDayTypeClick"
    case Invalid = "invalid"
    case CellDayTypePast = "CellDayTypePast"
    case CellDayTypeWeek = "CellDayTypeWeek"
    case CellDayTypeFuture = "CellDayTypeFuture"
}

class CalendarDayModel: NSObject {
    var style = CalendarDayStyle.CellDayTypeEmpty
    var day = 0
    var month = 0
    var year = 0
    var week = 0
    var Chinese_calendar = ""
    var holiday = ""
    var tag = ""
    
    class func calendarDayWithYear(_ year:Int, month:Int, day:Int) -> CalendarDayModel{
        let calendarDay = CalendarDayModel()
        calendarDay.year = year
        calendarDay.month = month
        calendarDay.day = day
        
        return calendarDay
    }
    
    func date() -> Date{
        var c = DateComponents()
        c.year = self.year
        c.month = self.month
        c.day = self.day
       
        return Calendar.current.date(from: c)!
    }
    
    func toString(_ format: String) -> String{
        let date = self.date()
        let matter = DateFormatter()
        matter.dateFormat = format
        let string = matter.string(from: date as Date)
        return string
    }
    
    func getWeek() -> String{
        let date = self.date()
        let week_str = date.compareIfTodayWithDate()
        return week_str
    }
    
    func isEqualTo(_ day:CalendarDayModel) -> Bool{
        return (self.year == day.year) && (self.month == day.month) && (self.day == day.day)
    }
}
