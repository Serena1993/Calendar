//
//  CalendarDayCell.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/2.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//

import UIKit
/*
*   普通样式
*
*/
class CalendarDayDefualtCell: UICollectionViewCell {
    
    var dateLabel = UILabel() //今天的日期或者节日 农历
    var imgView = UIImageView()  //选中时的图片
    var model = CalendarDayModel() {
        didSet {
            initView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //日期
        dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 20))
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        dateLabel.center = self.center
        addSubview(dateLabel)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func initView(){
        switch (model.style) {
        case .CellDayTypeEmpty: //不显示
            hidden_true()
            self.backgroundColor = UIColor.clear
            
        case .CellDayTypePast,.CellDayTypeInvalid: //过去的日期和不可选的日期
            hidden_false()
            if model.holiday != "" {
                dateLabel.text = model.holiday
            }else{
                dateLabel.text = "\(model.day)"
            }
            dateLabel.textColor = UIColor.lightGray

            self.backgroundColor = UIColor.clear
        case .CellDayTypeFuture://将来的日期
            self.hidden_false()
            
            if model.holiday != "" {
                dateLabel.text = model.holiday;
                dateLabel.textColor = ColorConst.tintColor
                print(model.toString("yyyy-MM-dd"))
            }else{
                dateLabel.text = "\(model.day)"
                dateLabel.textColor = UIColor.black
            }
            imgView.isHidden = true
            self.backgroundColor = UIColor.clear
            
        case .CellDayTypeWeek://周末
            hidden_false()
            
            if model.holiday != "" {
                dateLabel.text = model.holiday
                dateLabel.textColor = ColorConst.tintColor
                print(model.toString("yyyy-MM-dd"))
            }else{
                dateLabel.text = "\(model.day)"
                dateLabel.textColor = UIColor.black
            }
            imgView.isHidden = true
            self.backgroundColor = UIColor.clear
            
        case .CellDayTypeClick://被点击的日期
            hidden_false()
            dateLabel.text = "\(model.day)"
            dateLabel.textColor = UIColor.white
            self.backgroundColor = ColorConst.tintColor
        }
    }
    
    func hidden_true(){
        dateLabel.isHidden = true
    }
    
    func hidden_false(){
        dateLabel.isHidden = false
    }
}


class CalendarDayTagCell: CalendarDayDefualtCell {
    
    var tagLabel = UILabel()  //显示标签 日期 公历
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //日期
        dateLabel = UILabel(frame: CGRect(x: 0, y: 5, width: bounds.size.width, height: 20))
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(dateLabel)
        //农历
        tagLabel = UILabel(frame: CGRect(x: 0, y: bounds.size.height - 20, width: bounds.size.width, height: 20))
        tagLabel.textColor = UIColor.black
        tagLabel.font = UIFont.boldSystemFont(ofSize: 9)
        tagLabel.textAlignment = .center
        addSubview(tagLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func initView(){
        func showTag(){
            if model.tag != ""{
                tagLabel.text = model.tag
                tagLabel.textColor = ColorConst.tintColor
            }else{
                tagLabel.text = model.Chinese_calendar
            }
        }
        switch (model.style) {
        case .CellDayTypeEmpty: //不显示
            hidden_true()
            self.backgroundColor = UIColor.clear
            
        case .CellDayTypePast,.CellDayTypeInvalid: //过去的日期和不可选的日期
            hidden_false()
            if model.holiday != "" {
                dateLabel.text = model.holiday
            }else{
                dateLabel.text = "\(model.day)"
            }
            tagLabel.textColor = UIColor.lightGray
            dateLabel.textColor = UIColor.lightGray
            showTag()
            self.backgroundColor = UIColor.clear
        case .CellDayTypeFuture://将来的日期
            self.hidden_false()
            
            if model.holiday != "" {
                dateLabel.text = model.holiday;
                dateLabel.textColor = ColorConst.tintColor
                print(model.toString("yyyy-MM-dd"))
            }else{
                dateLabel.text = "\(model.day)"
                dateLabel.textColor = UIColor.black
            }
            tagLabel.textColor = UIColor.black
            showTag()
            imgView.isHidden = true
            self.backgroundColor = UIColor.clear
            
        case .CellDayTypeWeek://周末
            hidden_false()
            
            if model.holiday != "" {
                dateLabel.text = model.holiday
                dateLabel.textColor = ColorConst.tintColor
                print(model.toString("yyyy-MM-dd"))
            }else{
                dateLabel.text = "\(model.day)"
                dateLabel.textColor = UIColor.black
            }
            tagLabel.textColor = UIColor.black
            showTag()
            imgView.isHidden = true
            self.backgroundColor = UIColor.clear
            
        case .CellDayTypeClick://被点击的日期
            hidden_false()
            dateLabel.text = "\(model.day)"
            showTag()
            dateLabel.textColor = UIColor.white
            tagLabel.textColor = UIColor.white
            self.layer.cornerRadius = 5
            self.layer.masksToBounds = true
            self.backgroundColor = ColorConst.tintColor
        }
    }
}
