//
//  BuyDateViewController.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/3.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//

import Foundation

class BuyDateViewController: CalendarViewController {
    
    static let sharedInstance = BuyDateViewController()

    var priceList = [(String,String)]()
    var daynumber = 0     //天数
    var optiondaynumber = 0//选择日期数
    var fromDate = Date()
    var selectdate = Date()
    
    
    
    //设置日历选中今天
    func setTrainToDay(_ day: NSInteger, ToDateForString todate:String , _ tags:[(String,String)]?){
        
        daynumber = day
        optiondaynumber = 1
        
        if todate != "" {
            if let date = Date.dateFromString(todate, formate: "yyyy-MM-dd"){
                selectdate = date
            }
        }
        
        if tags == nil {
            loadPrice()
        }
        //初始化界面
        self.initWithStartDate(self.fromDate,startDate: self.fromDate, selectDate: self.selectdate, period: self.daynumber)
    }
    
    //请求最低价格
    func loadPrice(){
            let dateAndPrices = [("2017-04-01","¥120"),("2017-04-02","¥120"),("2017-04-03","¥120"),("2017-04-04","¥120"),("2017-04-05","¥120")]
            self.priceList = dateAndPrices
            self.setTags(self.priceList)
    }
    
    
    
    override func initWithStartDate(_ today:Date,startDate:Date,selectDate:Date,period:NSInteger){
        indicator.startAnimating()
        DispatchQueue(label: "reset", attributes: []).async(execute: {
            self.calendarMonth = self.logic.reloadCalendarView(today,startDate:startDate, selectDate: selectDate, days_number: period)
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
            })
        })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func setTags(_ datesAndTags:[(String,String)]){
        
        if datesAndTags.count == 0 {
            logic.datesAndTags = nil
        }else{
            logic.datesAndTags = datesAndTags
        }
    }
    
}




