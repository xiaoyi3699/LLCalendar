//
//  LLSolarMonth.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 10/01/2025.
//  公历模型

import UIKit

class LLSolarMonth: NSObject {
    
    var month = 0
    var yearModel: LLSolarYear!
    
    ///如: 一
    private var _monthStr: String?
    var monthStr: String {
        get {
            if _monthStr == nil {
                _monthStr = LLCalendar.solar_monthStr(self.month)
            }
            return _monthStr!
        }
    }
    //所有day
    private var days = [String: LLSolarDay]()
    //本月天数
    private var _totalDayCount = 0
    var totalDayCount: Int {
        get {
            if _totalDayCount == 0 {
                _totalDayCount = LLCalendar.getTotaldays(year: yearModel.year, month: month)
            }
            return _totalDayCount
        }
    }
    
    //本月第一天的星期值索引
    //["日", "一", "二", "三", "四", "五", "六"]
    private var _firstWeekIndex = 0
    var firstWeekIndex: Int {
        get {
            if _firstWeekIndex == 0 {
                _firstWeekIndex = LLCalendar.getWeekIndex(year: yearModel.year, month: month, day: 1)
            }
            return _firstWeekIndex
        }
    }
    
    init(_ aYear: Int, _ aMonth: Int) {
        super.init()
        yearModel = LLCalendarTool.loadSolarYear(aYear)
        month = aMonth
    }
    
    func day(of day: Int) -> LLSolarDay {
        return self.loadDay(day)
    }
    
    private func loadDay(_ day: Int) -> LLSolarDay {
        let key = "\(day)"
        if let m = self.days[key] {
            return m
        }
        let m = LLSolarDay(self.yearModel.year, self.month, day)
        saveDay(m)
        return m
    }
    
    private func saveDay(_ day: LLSolarDay) {
        let key = "\(day.day)"
        self.days[key] = day
    }
    
    ///最多计算3次 即可加载本月所有日期对应的农历
    func loadAllLunarDays() {
        loadIndex(index: 1)
    }
    
    func loadIndex(index: Int) {
        //第1次计算
        var dayIdx = index
        if dayIdx > totalDayCount {
             return
        }
        let lunarDay1 = self.day(of: dayIdx).lunarDay
        var dayNum = lunarDay1.day
        while dayNum < 29 && dayIdx < totalDayCount {
            dayIdx += 1
            dayNum += 1
            let day = self.day(of: dayIdx)
            day.createLunarDay(lunarDay1.yearModel.year, lunarDay1.monthModel.month, dayNum, lunarDay1.monthModel.isLeap)
        }
        dayIdx += 1
        if dayIdx > totalDayCount {
             return
        }
        //第2次计算
        let lunarDay2 = self.day(of: dayIdx).lunarDay
        if lunarDay2.day == 30 {
            dayIdx += 1
            if dayIdx > totalDayCount {
                 return
            }
            //第3次计算
            loadIndex(index: dayIdx)
            return
        }
        //第3次计算
        dayIdx += 1
        loadIndex(index: dayIdx)
    }
    
#if DEBUG
    func ll_description() -> String {
        return "\(self.yearModel.year)年\(self.month)月"
    }
#else
    func ll_description() -> String {
        return ""
    }
#endif
}
