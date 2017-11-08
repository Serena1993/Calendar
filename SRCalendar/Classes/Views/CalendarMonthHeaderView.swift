//
//  CalendarMonthHeaderView.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/2.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//
import UIKit

class CalendarMonthHeaderView: UICollectionReusableView {
    var masterLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        clipsToBounds = true
        masterLabel.frame = self.bounds
        masterLabel.textAlignment = .center
        masterLabel.font = UIFont.boldSystemFont(ofSize: 13)
        masterLabel.textColor = ColorConst.a1_gray
        addSubview(masterLabel)
    }
}
