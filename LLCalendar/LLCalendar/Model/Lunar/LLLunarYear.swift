//
//  LLLunarYear.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 10/01/2025.
//  农历模型

import UIKit

class LLLunarYear: NSObject {
    
    ///如: 2025
    var year = 0
    ///如: 二〇二五
    private var _yearStr: String?
    var yearStr: String {
        get {
            if _yearStr == nil {
                _yearStr = LLCalendar.chineseYearStr(self.year)
            }
            return _yearStr!
        }
    }
    
    ///生肖 如: 虎
    private var _zodiacStr: String?
    var zodiacStr: String {
        get {
            if _zodiacStr == nil {
                _zodiacStr = LLCalendar.lunar_zodiacStr(self.year)
            }
            return _zodiacStr!
        }
    }
    
    ///天干地支 Heavenly Stems and Earthly Branches
    ///农历年 如: 甲辰
    private var _heaEarStr: String?
    var heaEarStr: String {
        get {
            if _heaEarStr == nil {
                _heaEarStr = LLCalendar.lunar_yearStr(self.year)
            }
            return _heaEarStr!
        }
    }
    
    //本年月数
    private var _totalMonthCount = 0
    var totalMonthCount: Int {
        get {
            if _totalMonthCount == 0 {
                _totalMonthCount = (self.leapMonth > 0 ? 13 : 12)
            }
            return _totalMonthCount
        }
    }
    
    //本年闰月的月份
    private var _leapMonth = 0
    var leapMonth: Int {
        get {
            if _leapMonth == 0 {
                _leapMonth = LLCalendar.getLeapMonthInYear(self.year)
            }
            return _leapMonth
        }
    }
    
    private var months = [String: LLLunarMonth]()
    init(_ aYear: Int) {
        super.init()
        year = aYear
    }
    
    ///不一定是真实的month 如: 闰六月 month=7
    ///根据monthNum取monthModel 不需要提供是否是闰月 monthNum最大值为13
    func getMonth(_ monthNum: Int) -> LLLunarMonth {
        var monthModel: LLLunarMonth!
        if self.leapMonth > 0 {
            //如: 闰6月
            if monthNum <= self.leapMonth {
                //1-6月
                monthModel = self.month(of: monthNum, isLeap: false)
            }
            else if (monthNum-1 == self.leapMonth) {
                //7月 即闰6月
                monthModel = self.month(of: monthNum-1, isLeap: true)
            }
            else {
                //8 9 10 11 12 13 即7 8 9 10 11 12月
                monthModel = self.month(of: monthNum-1, isLeap: false)
            }
        }
        else {
            monthModel = self.month(of: monthNum, isLeap: false)
        }
        return monthModel
    }
    
    ///获取month
    ///根据真实的month取monthModel 需要提供是否是闰月 month最大值为12
    func month(of month: Int, isLeap: Bool) -> LLLunarMonth {
        return loadMonth(of: month, isLeap: isLeap)
    }
    
    private func loadMonth(of month: Int, isLeap: Bool) -> LLLunarMonth {
        let key = "\(month)" + (isLeap ? "_l" : "")
        if let m = self.months[key] {
            return m
        }
        let m = LLLunarMonth(self.year, month, isLeap)
        saveMonth(m, isLeap: isLeap)
        return m
    }
    
    private func saveMonth(_ month: LLLunarMonth, isLeap: Bool) {
        let key = "\(month.month)" + (isLeap ? "_l" : "")
        self.months[key] = month
    }
}
