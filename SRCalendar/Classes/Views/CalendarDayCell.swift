//
//  CalendarDayCell.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/2.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//

import UIKit

class CalendarDayCell: UICollectionViewCell {
    var day_lab = UILabel() //今天的日期或者节日 农历
    var day_title = UILabel()  //显示标签 日期 公历
    var imgview = UIImageView()  //选中时的图片
    var model = CalendarDayModel() {
        didSet {
//            if model == oldValue {
//                return
//            }
            initView()
            
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //日期
        day_lab = UILabel(frame: CGRect(x: 0, y: 5, width: bounds.size.width, height: 20))
        day_lab.textAlignment = .center
        day_lab.font = UIFont.systemFont(ofSize: 14)
        addSubview(day_lab)
        //农历
        day_title = UILabel(frame: CGRect(x: 0, y: bounds.size.height - 20, width: bounds.size.width, height: 20))
        day_title.textColor = UIColor.black
        day_title.font = UIFont.boldSystemFont(ofSize: 9)
        day_title.textAlignment = .center
        addSubview(day_title)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func initView(){
        func showTag(){
            if model.tag != ""{
                day_title.text = model.tag
                day_title.textColor = ColorConst.tintColor
            }else{
                day_title.text = model.Chinese_calendar
            }
        }
        switch (model.style) {
        case .CellDayTypeEmpty: //不显示
            hidden_true()
            self.backgroundColor = UIColor.clear
            
        case .CellDayTypePast,.Invalid: //过去的日期和不可选的日期
            hidden_false()
            if model.holiday != "" {
                day_lab.text = model.holiday
            }else{
                day_lab.text = "\(model.day)"
            }
            day_title.textColor = UIColor.lightGray
            day_lab.textColor = UIColor.lightGray
            showTag()
            self.backgroundColor = UIColor.clear
        case .CellDayTypeFuture://将来的日期
            self.hidden_false()
            
            if model.holiday != "" {
                day_lab.text = model.holiday;
                day_lab.textColor = ColorConst.tintColor
                print(model.toString("yyyy-MM-dd"))
            }else{
                day_lab.text = "\(model.day)"
                day_lab.textColor = UIColor.black
            }
            day_title.textColor = UIColor.black
            showTag()
            imgview.isHidden = true
            self.backgroundColor = UIColor.clear
            
        case .CellDayTypeWeek://周末
            hidden_false()
            
            if model.holiday != "" {
                day_lab.text = model.holiday
                day_lab.textColor = ColorConst.tintColor
                print(model.toString("yyyy-MM-dd"))
            }else{
                day_lab.text = "\(model.day)"
                day_lab.textColor = UIColor.black
            }
            day_title.textColor = UIColor.black
            showTag()
            imgview.isHidden = true
            self.backgroundColor = UIColor.clear
            
        case .CellDayTypeClick://被点击的日期
            hidden_false()
            day_lab.text = "\(model.day)"
            showTag()
            day_lab.textColor = UIColor.white
            day_title.textColor = UIColor.white
            self.layer.cornerRadius = 5
            self.layer.masksToBounds = true
            self.backgroundColor = ColorConst.tintColor
        }
    }
    
    func hidden_true(){
        day_lab.isHidden = true
        day_title.isHidden = true
    }
    
    func hidden_false(){
        day_lab.isHidden = false
        day_title.isHidden = false
    }
    
    
}
