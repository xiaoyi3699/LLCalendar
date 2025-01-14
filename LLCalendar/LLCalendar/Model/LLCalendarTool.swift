//
//  LLCalendarTool.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 08/01/2025.
//  Copyright © 2025 WangZhaomeng. All rights reserved.
//

import UIKit

class LLCalendarTool: NSObject {
    static var tool = LLCalendarTool()
    var itemW = 0.0
    var leftSpacing = 0.0
    var spacing_h = 0.0
    var spacing_v = 0.0
    //文字颜色
    var normalTextColor: UIColor = .darkText
    //文字颜色 选中
    var selectedTextColor: UIColor = .white
    //文字颜色 今天
    var todayTextColor: UIColor = .red
    //背景色
    var normalBgColor: UIColor = .purple.withAlphaComponent(0.2)
    //背景色 选中
    var selectedBgColor: UIColor = .blue.withAlphaComponent(0.2)
    
    private var solarYears = [String: LLSolarYear]()
    private var lunarYears = [String: LLLunarYear]()
    
    class func loadSolarYear(_ year: Int) -> LLSolarYear {
        let key = "\(year)"
        if let m = tool.solarYears[key] {
            return m
        }
        let m = LLSolarYear(year)
        saveSolarYear(m)
        return m
    }
    
    class func loadLunarYear(_ year: Int) -> LLLunarYear {
        let key = "\(year)"
        if let m = tool.lunarYears[key] {
            return m
        }
        let m = LLLunarYear(year)
        saveLunarYear(m)
        return m
    }
    
    private class func saveSolarYear(_ solarYear: LLSolarYear) {
        let key = "\(solarYear.year)"
        tool.solarYears[key] = solarYear
    }
    
    private class func saveLunarYear(_ lunarYear: LLLunarYear) {
        let key = "\(lunarYear.year)"
        tool.lunarYears[key] = lunarYear
    }
}

extension String {
    func ll_ranges(of substr: String) -> [NSRange] {
        var positions = [NSRange]()
        var searchRange = self.startIndex..<self.endIndex
        while let range = self.range(of: substr, options: [], range: searchRange) {
            let location = self.distance(from: self.startIndex, to: range.lowerBound)
            let length = substr.count
            let nsRange = NSRange(location: location, length: length)
            positions.append(nsRange)
            // 更新搜索范围，跳过已找到的子字符串
            searchRange = range.upperBound..<self.endIndex
        }
        return positions
    }
}
