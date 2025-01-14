//
//  LLLunarDay.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 10/01/2025.
//  农历模型

import UIKit

class LLLunarDay: NSObject {
    
    var day = 0
    var yearModel: LLLunarYear!
    var monthModel: LLLunarMonth!
    
    ///如: 初十
    private var _dayStr: String?
    var dayStr: String {
        get {
            if _dayStr == nil {
                _dayStr = LLCalendar.lunar_DayStr(self.day)
            }
            return _dayStr!
        }
    }
    
    ///对应的公历日期
    private var _solarDay: LLSolarDay?
    var solarDay: LLSolarDay {
        get {
            if _solarDay == nil {
                let lunars = LLCalendar.solarFrom(self.monthModel.yearModel.year, self.monthModel.month, self.day, self.monthModel.isLeap)
                _solarDay = LLSolarDay(lunars[0], lunars[1], lunars[2])
            }
            return _solarDay!
        }
    }
    
    init(_ aYear: Int, _ aMonth: Int, _ aDay: Int, _ aIsLeap: Bool) {
        super.init()
        yearModel = LLCalendarTool.loadLunarYear(aYear)
        monthModel = yearModel.month(of: aMonth, isLeap: aIsLeap)
        day = aDay
    }
    
#if DEBUG
    func ll_description() -> String {
        //天干地支
        let heaEar = self.yearModel.heaEarStr
        //生肖
        let zodiac = self.yearModel.zodiacStr
        //是否是闰月
        let leap = self.monthModel.leapStr
        return "\(self.yearModel.year)\(heaEar)\(zodiac)年\(leap)\(self.monthModel.monthStr)月\(self.dayStr)"
    }
#else
    func ll_description() -> String {
        return ""
    }
#endif
}
