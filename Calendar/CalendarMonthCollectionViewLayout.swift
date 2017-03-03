//
//  CalendarMonthCollectionViewLayout.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/2.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//
import UIKit

class CalendarMonthCollectionViewLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        
            headerReferenceSize = CGSize(width: CalendarConst.ScreenW, height: CalendarConst.headHeight)//头部视图的框架大小
            footerReferenceSize = CGSize(width: CalendarConst.ScreenW, height: CalendarConst.headMargin)
            sectionInset = UIEdgeInsets(top: 0, left: CalendarConst.TrainMargin, bottom: 0, right: CalendarConst.TrainMargin)
    
            itemSize = CGSize(width: (CalendarConst.ScreenW - CalendarConst.TrainMargin * 2) / 7 - 2, height: 40)////每个cell的大小
            
            minimumLineSpacing = 0  //每行的最小间距
            
            minimumInteritemSpacing = 0 //每列的最小间距
        
        
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var answer = super.layoutAttributesForElements(in: rect)
        let missingSections = NSMutableIndexSet()
        for layoutAttributes in answer!{
            if layoutAttributes.representedElementCategory == .cell {
                missingSections.add(layoutAttributes.indexPath.section)
            }
        }
        
        for layoutAttributes in answer!{
            if layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader{
                missingSections.remove(layoutAttributes.indexPath.section)
            }
        }
        
        missingSections.enumerate({ (idx: NSInteger, stop) -> Void in
            let indexPath = IndexPath(item: 0, section: idx)
            let layoutAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
            
            answer?.append(layoutAttributes!)
        })

        return answer
    }

    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
