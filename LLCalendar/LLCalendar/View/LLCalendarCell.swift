//
//  LLCalendarCell.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 08/01/2025.
//  Copyright © 2025 WangZhaomeng. All rights reserved.
//

import UIKit

@objc protocol LLCalendarCellDelegate: NSObjectProtocol {
    @objc optional func calendarCell(_ cell: LLCalendarCell, selectedDay day: LLSolarDay)
}

class LLCalendarCell: UICollectionViewCell {
    var cellRow = 0.0
    var indexPath: IndexPath!
    weak var delegate: LLCalendarCellDelegate?
    private var currentMonth: LLSolarMonth!
    private var dayLabels = [UILabel]()
    private var is_ShowLunar = false
    private var normalTextColor = LLCalendarTool.tool.normalTextColor
    private var selectedTextColor = LLCalendarTool.tool.selectedTextColor
    private var todayTextColor = LLCalendarTool.tool.todayTextColor
    private var normalBgColor = LLCalendarTool.tool.normalBgColor
    private var selectedBgColor = LLCalendarTool.tool.selectedBgColor
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        let tool = LLCalendarTool.tool
        for idx in 0..<42 {
            let dayLabel = UILabel(frame: CGRect(x: tool.leftSpacing+CGFloat(idx%7)*(tool.itemW+tool.spacing_h), y: CGFloat(idx/7)*(tool.itemW+tool.spacing_v), width: tool.itemW, height: tool.itemW))
            dayLabel.layer.cornerRadius = tool.itemW/2.0
            dayLabel.layer.masksToBounds = true
            dayLabel.font = .systemFont(ofSize: 15.0)
            dayLabel.textAlignment = .center
            dayLabel.numberOfLines = 0
            self.contentView.addSubview(dayLabel)
            dayLabels.append(dayLabel)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dayLabelTapped))
            dayLabel.addGestureRecognizer(tapGesture)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(month: LLSolarMonth, isShowLunar: Bool) {
        self.currentMonth = month
        self.is_ShowLunar = isShowLunar
        let allDaysCount = month.totalDayCount
        let firstDayWeek = month.firstWeekIndex
        let maxCount = firstDayWeek+allDaysCount
        cellRow = ceil(CGFloat(maxCount)/7.0)
        for idx in 0..<42 {
            let dayLabel = dayLabels[idx]
            if idx >= firstDayWeek, idx < maxCount {
                let dayIdx = idx-firstDayWeek+1
                let day = month.day(of: dayIdx)
                dayLabel.tag = dayIdx
                //textColor
                if day.today {
                    //今天
                    dayLabel.textColor = todayTextColor
                }
                else {
                    if day.selected {
                        //选中
                        dayLabel.textColor = selectedTextColor
                    }
                    else {
                        dayLabel.textColor = normalTextColor
                    }
                }
                //backgroundColor
                if day.selected {
                    //选中
                    dayLabel.backgroundColor = selectedBgColor
                }
                else {
                    dayLabel.backgroundColor = normalBgColor
                }
                var dayText = ""
                if self.is_ShowLunar {
                    var lunarDay = ""
                    if day.lunarDay.day == 1 {
                        lunarDay = day.lunarDay.monthModel.leapStr + day.lunarDay.monthModel.monthStr + "月"
                    }
                    else {
                        lunarDay = "\(day.lunarDay.dayStr)"
                    }
                    dayText = "\(day.day)\n\(lunarDay)"
                }
                else {
                    dayText = "\(day.day)"
                }
                dayLabel.attributedText = getAttStr(dayText)
                dayLabel.isUserInteractionEnabled = true
            }
            else {
                dayLabel.tag = 0
                dayLabel.attributedText = nil
                dayLabel.textColor = normalTextColor
                dayLabel.backgroundColor = .clear
                dayLabel.isUserInteractionEnabled = false
            }
        }
    }
    
    @objc func dayLabelTapped(sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        let day = self.currentMonth.day(of: label.tag)
        self.delegate?.calendarCell?(self, selectedDay: day)
        self.setupUI(month: currentMonth, isShowLunar: self.is_ShowLunar)
    }
    
    func getAttStr(_ text: String) -> NSAttributedString? {
        let attStr = NSMutableAttributedString(string: text)
        if self.is_ShowLunar {
            let arr = text.components(separatedBy: "\n")
            let range = text.ll_ranges(of: arr.first!).first!
            let range2 = text.ll_ranges(of: arr.last!).first!
            attStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0)], range: range)
            attStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 9.0)], range: range2)
        }
        else {
            attStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0)], range: NSMakeRange(0, attStr.length))
        }
        return attStr
    }
}
