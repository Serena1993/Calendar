//
//  LREventService.swift
//  Pods-SRCalendar_Example
//
//  Created by Serena_R on 2017/12/20.
//

import Foundation
import EventKit
import EventKitUI

class LREventService: NSObject {
    
    static let sharedInstance = LREventService()
    
    override init() {
        super.init()
    }
    
    func addEventNotify(title:String,location:String = "",start:Date,end:Date) {
        
        let eventStore = EKEventStore()
        if eventStore.responds(to: #selector(EKEventStore.requestAccess(to:completion:))) {
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                guard error == nil else{
                    print("error")
                    return
                }
                
                guard granted == true else{
                    print("grant")
                    return
                }
                
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.location = location
                
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY/MM/dd"
                event.startDate = start
                event.endDate = end
                
                event.addAlarm(EKAlarm.init(relativeOffset: 60 * -60 * 24))
                event.addAlarm(EKAlarm.init(relativeOffset: 60 * -15))
                event.calendar = eventStore.defaultCalendarForNewEvents

                try? eventStore.save(event, span: EKSpan.thisEvent)
                
            })
        }
    }
    
    func addRiminderNotify(title:String,location:String = "",date:Date){
        
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            guard error == nil else{
                print("error")
                return
            }
            
            guard granted == true else{
                print("grant")
                return
            }
            let reminder = EKReminder(eventStore: eventStore)
            reminder.title = title;
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.system
        
            let components:Set<Calendar.Component> = [Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second]
            
            var dateComponents = calendar.dateComponents(components, from: date)
            dateComponents.timeZone = NSTimeZone.system
            reminder.startDateComponents = dateComponents
            reminder.dueDateComponents = dateComponents
            reminder.priority = 1
            let alarm = EKAlarm(absoluteDate: date)
            reminder.addAlarm(alarm)
            try? eventStore.save(reminder, commit: true)
            
        }
    }
}

