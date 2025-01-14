//
//  LLCalendarView.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 07/01/2025.
//  Copyright © 2025 WangZhaomeng. All rights reserved.
//

import UIKit

class LLCalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, LLCalendarCellDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //总年份
        return (endYear-startYear+1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //12个月
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendar", for: indexPath) as! LLCalendarCell
        cell.delegate = self
        cell.indexPath = indexPath
        if cellLoaded == false {
            cellLoaded = true
            setupCellUI(cell, isShowLunar: is_ShowLunar)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = 0
        if self.direction == .horizontal {
            offset = Int(round(collectionView.contentOffset.x/collectionView.bounds.size.width))
        }
        else {
            offset = Int(round(collectionView.contentOffset.y/collectionView.bounds.size.height))
        }
        if offset == currIndex {
            return
        }
        currIndex = offset
        let indexPath = IndexPath(item: currIndex%12, section: currIndex/12)
        if let cell = collectionView.cellForItem(at: indexPath) as? LLCalendarCell {
            if cell.indexPath.section == indexPath.section, cell.indexPath.item == indexPath.item {
                setupCellUI(cell, isShowLunar: is_ShowLunar)
            }
        }
    }
    
    //cell代理
    func calendarCell(_ cell: LLCalendarCell, selectedDay day: LLSolarDay) {
        selectedModel?.selected = false
        selectedModel = day
        selectedModel?.selected = true
        self.didSelectedDayBlock?(day)
    }
    
    //cell加载数据
    private func setupCellUI(_ cell: LLCalendarCell, isShowLunar: Bool) {
        let monthModel = getMonthFrom(indexPath: cell.indexPath)
        cell.setupUI(month: monthModel, isShowLunar: is_ShowLunar)
        layoutFrame(with: cell)
        self.monthDidChangedBlock?(monthModel)
    }
    
    private func getMonthFrom(indexPath: IndexPath) -> LLSolarMonth {
        let year = startYear+indexPath.section
        let month = indexPath.item+1
        let yearModel = LLCalendarTool.loadSolarYear(year)
        return yearModel.month(of: month)
    }
    //重新计算frame
    private func layoutFrame(with cell: LLCalendarCell) {
        if cell.cellRow > 0.0 {
            let tool = LLCalendarTool.tool
            var rect = self.frame
            rect.size.height = weekHeight+cell.cellRow*tool.itemW+(cell.cellRow-1.0)*tool.spacing_v+10.0
            UIView.animate(withDuration: 0.2) {
                self.frame = rect
            }
        }
    }
    
    enum LLScrollDirection {
        case horizontal
        case vertical
    }
    
    //1950年-2050年
    private let startYear = 1950
    private let endYear = 2050
    private var is_ShowLunar = false
    private var cellLoaded = true
    private var direction: LLScrollDirection!
    private var currIndex = 0
    private var selectedModel: LLSolarDay?
    private var currentMonth: LLSolarMonth?
    private var collectionView: UICollectionView!
    private var didSelectedDayBlock: ((_ day: LLSolarDay) -> Void)?
    private var monthDidChangedBlock: ((_ month: LLSolarMonth) -> Void)?
    private var weekHeight = 0.0
    //isShowLunar 是否显示农历
    init(frame: CGRect, direction: LLScrollDirection = .horizontal, isShowLunar: Bool = true) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.direction = direction
        self.is_ShowLunar = isShowLunar
        let tool = LLCalendarTool.tool
        //星期高度
        weekHeight = 45.0
        //itemW
        tool.itemW = 40.0
        //左右间距
        tool.leftSpacing = 10.0
        //纵向间距
        tool.spacing_v = (self.bounds.size.height-45.0-tool.itemW*6.0-10.0)/5.0
        //横向间距
        tool.spacing_h = (self.bounds.size.width-tool.itemW*7.0-tool.leftSpacing*2.0)/6.0
        //星期
        for (idx, item) in LLCalendar.share.weekdays.enumerated() {
            let weekLabel = UILabel(frame: CGRect(x: tool.leftSpacing+CGFloat(idx)*(tool.itemW+tool.spacing_h), y: 0.0, width: tool.itemW, height: weekHeight))
            weekLabel.text = item
            weekLabel.textColor = .brown
            weekLabel.font = .systemFont(ofSize: 15.0)
            weekLabel.textAlignment = .center
            self.addSubview(weekLabel)
        }
        //days
        let itemSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height-weekHeight)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = (direction == .horizontal ? .horizontal : .vertical)
        flowLayout.itemSize = itemSize
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: CGRect(x: 0.0, y: weekHeight, width: itemSize.width, height: itemSize.height), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.register(LLCalendarCell.self, forCellWithReuseIdentifier: "calendar")
        self.addSubview(collectionView)
        
        //自定义今天的日期
        //self.resetToday(date: Date())
        //选中日期
        //self.scrollTo(date: Date(), selected: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollTo(date: Date, selected: Bool = true) {
        let coms = LLCalendar.share.calendar_gl.dateComponents([.year, .month, .day], from: date)
        scrollTo(year: coms.year!, month: coms.month!, day: coms.day!, selected: selected)
    }
    
    func scrollTo(year: Int, month: Int, day: Int = 1, selected: Bool = true) {
        cellLoaded = false
        let indexPath = IndexPath(item: (month-1), section: (year-startYear))
        let monthModel = self.getMonthFrom(indexPath: indexPath)
        if selected {
            self.selectedModel?.selected = false
            self.selectedModel = monthModel.day(of: day)
            self.selectedModel?.selected =  true
            if let model = selectedModel {
                self.didSelectedDayBlock?(model)
            }
        }
        self.currentMonth = monthModel
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        collectionView.reloadData()
    }
    
    //自定义今天的日期
    func resetToday(date: Date = Date()) {
        let todayComs = LLCalendar.share.calendar_gl.dateComponents([.year, .month, .day], from: date)
        let yearModel = LLCalendarTool.loadSolarYear(todayComs.year!)
        let monthModel = yearModel.month(of: todayComs.month!)
        let today = monthModel.day(of: todayComs.day!)
        today.today = true
    }
    
    //设置点击日期时的回调block
    func valueChanged(selectedDay: ((_ day: LLSolarDay) -> Void)?) {
        self.didSelectedDayBlock = selectedDay
        //设置后立即调用
        if let model = selectedModel {
            self.didSelectedDayBlock?(model)
        }
    }
    
    //设置月份改变时的回调block
    func valueChanged(showMonth: ((_ month: LLSolarMonth) -> Void)?) {
        self.monthDidChangedBlock = showMonth
        //设置后立即调用
        if let model = currentMonth {
            self.monthDidChangedBlock?(model)
        }
    }
}
