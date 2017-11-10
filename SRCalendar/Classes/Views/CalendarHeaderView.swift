
//  CalendarHeaderView.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/2.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//

import UIKit

struct CalendarHVDefault {
    static let VWidth:CGFloat = (CalendarConst.ScreenW - CalendarConst.TrainMargin * 2) / 7
}

enum SRCalendarHeaderViewType {
    case SRCalendarHeaderViewTypeEn //Default Value : Mon Tur Wen Thr Fri Sat Sun
    case SRCalendarHeaderViewTypeCh //Default Value : 一 二 三 四 五 六 日
    case SRCalendarHeaderViewTypeWeek //Default Value : 周一 周二 周三 周四 周五 周六 周日
}

class CalendarHeaderView: UIView {
    
    var type:SRCalendarHeaderViewType = .SRCalendarHeaderViewTypeCh
    var components:[UILabel] = Array()
    var characters:[String] = ["日", "一", "二", "三", "四", "五", "六"]{
        didSet{
            self.resetHeaderCharacters()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 0..<7 {
            let label = UILabel()
            label.text = characters[i]
            label.font = UIFont.boldSystemFont(ofSize: 13)
            label.textColor = ColorConst.a1_gray
            label.textAlignment = .center
            self.components.append(label)
            self.addSubview(label)
            self.backgroundColor = ColorConst.a2_white
        }
    }
    
    convenience init(headerType:SRCalendarHeaderViewType) {
        self.init(frame: CGRect(x: 0, y: 0 , width: CalendarConst.ScreenW, height: 40))
        self.type = headerType
        switch headerType {
        case .SRCalendarHeaderViewTypeEn:
            self.characters = ["Sun", "Mon", "Thu", "Wen", "Thr", "Fri", "Sat"]
        case .SRCalendarHeaderViewTypeWeek:
            self.characters = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        default:
            self.characters = ["日", "一", "二", "三", "四", "五", "六"]
        }
        self.resetHeaderCharacters()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for i in 0..<7 {
            let view = self.subviews[i]
            view.frame = CGRect(x:CalendarConst.TrainMargin + CalendarHVDefault.VWidth * CGFloat(i), y: 0, width: CalendarHVDefault.VWidth, height: self.frame.height)
        }
    }

    private func resetHeaderCharacters(){
        for (idx,label) in self.components.enumerated() {
            label.text = self.characters[idx]
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
