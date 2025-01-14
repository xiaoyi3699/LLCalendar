//
//  LLSolarYear.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 10/01/2025.
//  公历模型

import UIKit

class LLSolarYear: NSObject {
    
    ///公历年 如: 2025
    var year = 0
    
    ///公历年 如: 二〇二五
    var yearStr: String {
        get {
            return LLCalendar.chineseYearStr(self.year)
        }
    }
    
    private var months = [String: LLSolarMonth]()
    init(_ aYear: Int) {
        super.init()
        year = aYear
    }
    
    ///获取month
    func month(of month: Int) -> LLSolarMonth {
        return loadMonth(month)
    }
    
    private func loadMonth(_ month: Int) -> LLSolarMonth {
        let key = "\(month)"
        if let m = self.months[key] {
            return m
        }
        let m = LLSolarMonth(self.year, month)
        saveMonth(m)
        m.loadAllLunarDays()
        return m
    }
    
    private func saveMonth(_ month: LLSolarMonth) {
        let key = "\(month.month)"
        self.months[key] = month
    }
}
