//
//  CalendarViewController.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/2.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//
import UIKit


public class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    typealias CalendarBlock = (_ model:CalendarDayModel)->Void

    var collectionView = UICollectionView(frame: CGRect(x: 0, y: 40, width: CalendarConst.ScreenW, height: CalendarConst.ScreenH - CalendarConst.naviHeight - 40), collectionViewLayout: CalendarMonthCollectionViewLayout())//网格视图
    var calendarMonth = [AnyObject]()//每个月份的中的daymodel容器数组
    
    var logic = CalendarLogic()
    var calendarblock : CalendarBlock? //回调
    var timer = Timer()
    var isReturn = false
    let MonthHeader = "MonthHeaderView"
    let MonthFooter = "MonthFooterView"
    let DayCell = "DayCell"
    var first :CalendarDayModel!
    var last  :CalendarDayModel!
    
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        initData()
        self.automaticallyAdjustsScrollViewInsets = false
        initView()
    }
    
    func initwithblock(_ block: @escaping CalendarBlock){
        
        calendarblock = block
    }
    
    func initView(){
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: DayCell)
        collectionView.register(CalendarMonthHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MonthHeader)
        collectionView.register(CalendarMonthFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter , withReuseIdentifier: MonthFooter)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        view.addSubview(CalendarHeaderView(frame: CGRect(x: 0, y: 0 , width: CalendarConst.ScreenW, height: 40)))
        
        indicator.frame.size = CGSize(width: 50, height: 50)
        indicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        indicator.backgroundColor = ColorConst.a3_black
        indicator.layer.cornerRadius = 8
        self.view.addSubview(indicator)
    }
    
    func initWithStartDate(_ today:Date,startDate:Date,selectDate:Date,period:NSInteger){
        indicator.startAnimating()
        DispatchQueue.global().async {
            
            self.calendarMonth = self.logic.reloadCalendarView(today,startDate:startDate, selectDate: selectDate, days_number: period)
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
            })
        }
    }
    
    func setTags(_ datesAndTags:[(String,String)]){
        logic.datesAndTags = datesAndTags
    }
    
    func setDaysInvalid(_ validDate:[String]){
        
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        initView()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let back = UIButton(type: .custom)
        back.setTitle("Back", for: .normal)
        back.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        back.setTitleColor(ColorConst.a1_gray, for: .normal)
        back.sizeToFit()
        back.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        back.addTarget(self, action: #selector(pop), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back)

    }

    @objc func pop(){
        let _ = self.navigationController?.popViewController(animated: true)
    }
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return calendarMonth.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return calendarMonth[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell, for: indexPath as IndexPath)
        if let cacell = cell as?CalendarDayCell{
            let monthArray = calendarMonth[indexPath.section]as![NSObject]
            let model  = monthArray[indexPath.row] as? CalendarDayModel
            cacell.model = model!
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        var reusableview = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader{
            let month_Array = calendarMonth[indexPath.section]as![NSObject]
            let model = month_Array[15] as?CalendarDayModel
            let monthHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MonthHeader, for: indexPath as IndexPath)as? CalendarMonthHeaderView
            monthHeader?.masterLabel.text = "\(model!.year)年 \(model!.month)月"
//            monthHeader?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
            reusableview = monthHeader!
        }
        if kind == UICollectionElementKindSectionFooter{
            let monthFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: MonthFooter , for: indexPath as IndexPath)as? CalendarMonthFooterView
            if indexPath.section == calendarMonth.count - 1{
                monthFooter!.backgroundColor = ColorConst.a1_white
            }else{
                monthFooter!.backgroundColor = ColorConst.a2_white
            }
                reusableview = monthFooter!
        }
        return reusableview
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let month_Array = calendarMonth[indexPath.section]as![NSObject]
        let model = month_Array[indexPath.row]as?CalendarDayModel
        if model?.style == .CellDayTypeFuture || model?.style == .CellDayTypeWeek || model?.style == .CellDayTypeClick{
            logic.selectLogic(model!)
            if !isReturn{
                if (calendarblock  != nil){
                    calendarblock!(model!)
                }
            }else{

            }
            collectionView.reloadData()
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func onTimer(){
        timer.invalidate()
        let _ = self.navigationController?.popViewController(animated: true)
    }

}
