//
//  LRMainTableVIewController.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/2.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//

import Foundation
import UIKit

public class MainTableViewController: UITableViewController {

    private var timeView = UILabel()

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "Wonder4Calender"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        view.addSubview(timeView)
        timeView.frame = CGRect.init(x: 0, y: 0, width: CalendarConst.ScreenW, height: 80)
        timeView.font = UIFont.boldSystemFont(ofSize: 18)
        timeView.textAlignment = .center
        timeView.backgroundColor = UIColor.white
        timeView.textColor = ColorConst.a1_gray
        timeView.text = "Try To Select A Calendar."
        tableView.tableHeaderView = timeView
    }
    
 
    func calendarblock(_ model: CalendarDayModel){
        
        let _ = self.navigationController?.popViewController(animated: true)
        timeView.text = "\(model.toString("MM月dd日")) \(model.getWeek())"
        let eventService = LREventService.sharedInstance
        eventService.addRiminderNotify(title: "Test", date: model.date())
        eventService.addEventNotify(title: "Test", start: Date(), end: model.date())
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = UIColor.black
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Season Style"
        case 1:
            cell.textLabel?.text = "Month Style"
        case 2:
            cell.textLabel?.text = "Week Style"
        default:
            break
        }
        
        return cell
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //可选择天数
        let canSelectLimit = 60
        switch indexPath.row {
        case 0:
            let chvc = BuyDateViewController()
            chvc.navigationItem.title = "Default Style"
            chvc.calendarblock = calendarblock
            chvc.setMarkToDay(canSelectLimit, ToDateForString:Date.stringFromDate(Date()),[("","")])
            self.navigationController?.pushViewController(chvc, animated: true)
        case 1:
            let chvc = CalendarViewController()
            chvc.navigationItem.title = "Holiday Style"
            chvc.calendarblock = calendarblock
            chvc.initWithStartDate(Date(), startDate: Date(), selectDate: Date(), period: canSelectLimit)
            self.navigationController?.pushViewController(chvc, animated: true)
        case 2:
            let chvc = BuyDateViewController()
            chvc.navigationItem.title = "Tag Style"
            chvc.calendarblock = calendarblock
            chvc.setMarkToDay(canSelectLimit, ToDateForString:Date.stringFromDate(Date()) , nil)
            self.navigationController?.pushViewController(chvc, animated: true)

        default:
            break
        }
 
    }
}

