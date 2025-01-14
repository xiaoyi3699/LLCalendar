//
//  LLLunarMonth.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 10/01/2025.
//  农历模型

import UIKit

class LLLunarMonth: NSObject {
    
    var month = 0
    var yearModel: LLLunarYear!
    ///是否是闰月
    var isLeap = false
    
    ///农历月 如: 正月/闰正月
    private var _monthStr: String?
    var monthStr: String {
        get {
            if _monthStr == nil {
                _monthStr = LLCalendar.lunar_monthStr(self.month)
            }
            return _monthStr!
        }
    }
    
    ///闰月 如: 闰 或者 ""
    private var _leapStr: String?
    var leapStr: String {
        get {
            if _leapStr == nil {
                _leapStr = (self.isLeap ? "闰" : "")
            }
            return _leapStr!
        }
    }
    
    //本月天数
    private var _totalDayCount = 0
    var totalDayCount: Int {
        get {
            if _totalDayCount == 0 {
                var month = self.month
                if self.isLeap {
                    month += 1
                }
                else {
                    let leapMonth = LLCalendar.getLeapMonthInYear(yearModel.year)
                    if leapMonth > 0, leapMonth < month {
                        month += 1
                    }
                }
                _totalDayCount = LLCalendar.getMonthDaysInYear(yearModel.year, month)
            }
            return _totalDayCount
        }
    }
    
    init(_ aYear: Int, _ aMonth: Int, _ aIsLeap: Bool) {
        super.init()
        yearModel = LLCalendarTool.loadLunarYear(aYear)
        month = aMonth
        isLeap = aIsLeap
    }
    
#if DEBUG
    func ll_description() -> String {
        //天干地支
        let heaEar = self.yearModel.heaEarStr
        //生肖
        let zodiac = self.yearModel.zodiacStr
        //是否是闰月
        let leap = self.leapStr
        return "\(self.yearModel.year)\(heaEar)\(zodiac)年\(leap)\(self.monthStr)月"
    }
#else
    func ll_description() -> String {
        return ""
    }
#endif
}
