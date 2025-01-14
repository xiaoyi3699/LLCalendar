//
//  LLSolarDay.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 10/01/2025.
//  公历模型

import UIKit

class LLSolarDay: NSObject {
    
    var day = 0
    var yearModel: LLSolarYear!
    var monthModel: LLSolarMonth!
    ///如: 十
    var dayStr: String {
        get {
            return LLCalendar.solar_DayStr(self.day)
        }
    }
    ///如: 周四
    private var _weekDayStr: String?
    var weekDayStr: String {
        get {
            if _weekDayStr == nil {
                let idx = LLCalendar.getWeekIndex(year: self.monthModel.yearModel.year, month: self.monthModel.month, day: self.day)
                _weekDayStr = LLCalendar.weekDayStr(idx)
            }
            return _weekDayStr!
        }
    }
    
    var today = false
    var selected = false
    
    init(_ aYear: Int, _ aMonth: Int, _ aDay: Int) {
        super.init()
        yearModel = LLCalendarTool.loadSolarYear(aYear)
        monthModel = yearModel.month(of: aMonth)
        day = aDay
    }
    
    func isSameDay(_ coms: DateComponents) -> Bool {
        if self.day == coms.day, self.monthModel.month == coms.month, self.monthModel.yearModel.year == coms.year {
            return true
        }
        return false
    }
    
    ///对应的农历日期
    private var _lunarDay: LLLunarDay?
    var lunarDay: LLLunarDay {
        get {
            if _lunarDay == nil {
                let lunars = LLCalendar.lunarFrom(self.monthModel.yearModel.year, self.monthModel.month, self.day)
                _lunarDay = LLLunarDay(lunars[0], lunars[1], lunars[2], (lunars[3] == 1))
            }
            return _lunarDay!
        }
    }
    
    func createLunarDay(_ aYear: Int, _ aMonth: Int, _ aDay: Int, _ aIsLeap: Bool) {
        _lunarDay = LLLunarDay(aYear, aMonth, aDay, aIsLeap)
    }
    
    func toDate() -> Date {
        var coms = DateComponents()
        coms.year = self.yearModel.year
        coms.month = self.monthModel.month
        coms.day = self.day
        return LLCalendar.share.calendar_gl.date(from: coms) ?? Date()
    }
    
#if DEBUG
    func ll_description() -> String {
        return "\(self.yearModel.year)年\(self.monthModel.month)月\(self.day)日  周\(self.weekDayStr)"
    }
#else
    func ll_description() -> String {
        return ""
    }
#endif
}
