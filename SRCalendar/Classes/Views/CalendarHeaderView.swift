
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

class CalendarHeaderView: UIView {
    let weeks = ["日", "一", "二", "三", "四", "五", "六"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 0..<7 {
            let label = UILabel()
            label.text = weeks[i]
            label.font = UIFont.boldSystemFont(ofSize: 13)
            label.textColor = ColorConst.a1_gray
            label.textAlignment = .center
        self.addSubview(label)
        self.backgroundColor = ColorConst.a2_white
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for i in 0..<7 {
            let view = self.subviews[i]
            view.frame = CGRect(x:CalendarConst.TrainMargin + CalendarHVDefault.VWidth * CGFloat(i), y: 0, width: CalendarHVDefault.VWidth, height: self.frame.height)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
