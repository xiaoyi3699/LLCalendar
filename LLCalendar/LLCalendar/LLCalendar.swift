//
//  LLCalendar.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 09/01/2025.
//  Copyright © 2025 WangZhaomeng. All rights reserved.
//

import UIKit

class LLCalendar: NSObject {
    static var share = LLCalendar()
    //公历日历
    lazy var calendar_gl = Calendar(identifier: .gregorian)
    //公历
    lazy var years_gl = ["〇", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
    lazy var months_gl = ["一", "二", "三", "四", "五", "六",
                          "七", "八", "九", "十", "十一", "十二"]
    lazy var days_gl = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十",
                        "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
                        "二十一", "二十二", "二十三", "二十四", "二十五", "二十六", "二十七", "二十八", "二十九", "三十", "三十一"]
    //农历
    lazy var tianGan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    lazy var diZhi = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
    
    lazy var months_nl = ["正", "二", "三", "四", "五", "六",
                          "七", "八", "九", "十", "冬", "腊"]
    lazy var days_nl = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
                        "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
                        "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
    //星期
    lazy var weekdays = ["日", "一", "二", "三", "四", "五", "六"]
    //生肖
    lazy var zodiacs = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
    
    //起止日期
    lazy var START_YEAR = 1901
    lazy var END_YEAR = 2050
    
    //数组中每一个元素存放1901~2050期间每一年的闰月月份，取值范围0~12（0表示该年没有闰月
    let ll_leapMonth = [
        0x00, 0x00, 0x05, 0x00, 0x00, 0x04, 0x00, 0x00, 0x02, 0x00, //1910
        0x06, 0x00, 0x00, 0x05, 0x00, 0x00, 0x02, 0x00, 0x07, 0x00, //1920
        0x00, 0x05, 0x00, 0x00, 0x04, 0x00, 0x00, 0x02, 0x00, 0x06, //1930
        0x00, 0x00, 0x05, 0x00, 0x00, 0x03, 0x00, 0x07, 0x00, 0x00, //1940
        0x06, 0x00, 0x00, 0x04, 0x00, 0x00, 0x02, 0x00, 0x07, 0x00, //1950
        0x00, 0x05, 0x00, 0x00, 0x03, 0x00, 0x08, 0x00, 0x00, 0x06, //1960
        0x00, 0x00, 0x04, 0x00, 0x00, 0x03, 0x00, 0x07, 0x00, 0x00, //1970
        0x05, 0x00, 0x00, 0x04, 0x00, 0x08, 0x00, 0x00, 0x06, 0x00, //1980
        0x00, 0x04, 0x00, 0x0A, 0x00, 0x00, 0x06, 0x00, 0x00, 0x05, //1990
        0x00, 0x00, 0x03, 0x00, 0x08, 0x00, 0x00, 0x05, 0x00, 0x00, //2000
        0x04, 0x00, 0x00, 0x02, 0x00, 0x07, 0x00, 0x00, 0x05, 0x00, //2010
        0x00, 0x04, 0x00, 0x09, 0x00, 0x00, 0x06, 0x00, 0x00, 0x04, //2020
        0x00, 0x00, 0x02, 0x00, 0x06, 0x00, 0x00, 0x05, 0x00, 0x00, //2030
        0x03, 0x00, 0x0B, 0x00, 0x00, 0x06, 0x00, 0x00, 0x05, 0x00, //2040
        0x00, 0x02, 0x00, 0x07, 0x00, 0x00, 0x05, 0x00, 0x00, 0x03, //2050
    ]
    
    //公农历转换使用 适用范围1887--2110 如要更多年份 自行增加数据
    let solar_1_1 = [
        1887, 0xec04c, 0xec23f, 0xec435, 0xec649, 0xec83e, 0xeca51, 0xecc46, 0xece3a,
        0xed04d, 0xed242, 0xed436, 0xed64a, 0xed83f, 0xeda53, 0xedc48, 0xede3d, 0xee050, 0xee244, 0xee439, 0xee64d,
        0xee842, 0xeea36, 0xeec4a, 0xeee3e, 0xef052, 0xef246, 0xef43a, 0xef64e, 0xef843, 0xefa37, 0xefc4b, 0xefe41,
        0xf0054, 0xf0248, 0xf043c, 0xf0650, 0xf0845, 0xf0a38, 0xf0c4d, 0xf0e42, 0xf1037, 0xf124a, 0xf143e, 0xf1651,
        0xf1846, 0xf1a3a, 0xf1c4e, 0xf1e44, 0xf2038, 0xf224b, 0xf243f, 0xf2653, 0xf2848, 0xf2a3b, 0xf2c4f, 0xf2e45,
        0xf3039, 0xf324d, 0xf3442, 0xf3636, 0xf384a, 0xf3a3d, 0xf3c51, 0xf3e46, 0xf403b, 0xf424e, 0xf4443, 0xf4638,
        0xf484c, 0xf4a3f, 0xf4c52, 0xf4e48, 0xf503c, 0xf524f, 0xf5445, 0xf5639, 0xf584d, 0xf5a42, 0xf5c35, 0xf5e49,
        0xf603e, 0xf6251, 0xf6446, 0xf663b, 0xf684f, 0xf6a43, 0xf6c37, 0xf6e4b, 0xf703f, 0xf7252, 0xf7447, 0xf763c,
        0xf7850, 0xf7a45, 0xf7c39, 0xf7e4d, 0xf8042, 0xf8254, 0xf8449, 0xf863d, 0xf8851, 0xf8a46, 0xf8c3b, 0xf8e4f,
        0xf9044, 0xf9237, 0xf944a, 0xf963f, 0xf9853, 0xf9a47, 0xf9c3c, 0xf9e50, 0xfa045, 0xfa238, 0xfa44c, 0xfa641,
        0xfa836, 0xfaa49, 0xfac3d, 0xfae52, 0xfb047, 0xfb23a, 0xfb44e, 0xfb643, 0xfb837, 0xfba4a, 0xfbc3f, 0xfbe53,
        0xfc048, 0xfc23c, 0xfc450, 0xfc645, 0xfc839, 0xfca4c, 0xfcc41, 0xfce36, 0xfd04a, 0xfd23d, 0xfd451, 0xfd646,
        0xfd83a, 0xfda4d, 0xfdc43, 0xfde37, 0xfe04b, 0xfe23f, 0xfe453, 0xfe648, 0xfe83c, 0xfea4f, 0xfec44, 0xfee38,
        0xff04c, 0xff241, 0xff436, 0xff64a, 0xff83e, 0xffa51, 0xffc46, 0xffe3a, 0x10004e, 0x100242, 0x100437,
        0x10064b, 0x100841, 0x100a53, 0x100c48, 0x100e3c, 0x10104f, 0x101244, 0x101438, 0x10164c, 0x101842, 0x101a35,
        0x101c49, 0x101e3d, 0x102051, 0x102245, 0x10243a, 0x10264e, 0x102843, 0x102a37, 0x102c4b, 0x102e3f, 0x103053,
        0x103247, 0x10343b, 0x10364f, 0x103845, 0x103a38, 0x103c4c, 0x103e42, 0x104036, 0x104249, 0x10443d, 0x104651,
        0x104846, 0x104a3a, 0x104c4e, 0x104e43, 0x105038, 0x10524a, 0x10543e, 0x105652, 0x105847, 0x105a3b, 0x105c4f,
        0x105e45, 0x106039, 0x10624c, 0x106441, 0x106635, 0x106849, 0x106a3d, 0x106c51, 0x106e47, 0x10703c, 0x10724f,
        0x107444, 0x107638, 0x10784c, 0x107a3f, 0x107c53, 0x107e48
    ]
    
    let lunar_month_days = [
        1887, 0x1694, 0x16aa, 0x4ad5, 0xab6, 0xc4b7, 0x4ae, 0xa56, 0xb52a,
        0x1d2a, 0xd54, 0x75aa, 0x156a, 0x1096d, 0x95c, 0x14ae, 0xaa4d, 0x1a4c, 0x1b2a, 0x8d55, 0xad4, 0x135a, 0x495d,
        0x95c, 0xd49b, 0x149a, 0x1a4a, 0xbaa5, 0x16a8, 0x1ad4, 0x52da, 0x12b6, 0xe937, 0x92e, 0x1496, 0xb64b, 0xd4a,
        0xda8, 0x95b5, 0x56c, 0x12ae, 0x492f, 0x92e, 0xcc96, 0x1a94, 0x1d4a, 0xada9, 0xb5a, 0x56c, 0x726e, 0x125c,
        0xf92d, 0x192a, 0x1a94, 0xdb4a, 0x16aa, 0xad4, 0x955b, 0x4ba, 0x125a, 0x592b, 0x152a, 0xf695, 0xd94, 0x16aa,
        0xaab5, 0x9b4, 0x14b6, 0x6a57, 0xa56, 0x1152a, 0x1d2a, 0xd54, 0xd5aa, 0x156a, 0x96c, 0x94ae, 0x14ae, 0xa4c,
        0x7d26, 0x1b2a, 0xeb55, 0xad4, 0x12da, 0xa95d, 0x95a, 0x149a, 0x9a4d, 0x1a4a, 0x11aa5, 0x16a8, 0x16d4,
        0xd2da, 0x12b6, 0x936, 0x9497, 0x1496, 0x1564b, 0xd4a, 0xda8, 0xd5b4, 0x156c, 0x12ae, 0xa92f, 0x92e, 0xc96,
        0x6d4a, 0x1d4a, 0x10d65, 0xb58, 0x156c, 0xb26d, 0x125c, 0x192c, 0x9a95, 0x1a94, 0x1b4a, 0x4b55, 0xad4,
        0xf55b, 0x4ba, 0x125a, 0xb92b, 0x152a, 0x1694, 0x96aa, 0x15aa, 0x12ab5, 0x974, 0x14b6, 0xca57, 0xa56, 0x1526,
        0x8e95, 0xd54, 0x15aa, 0x49b5, 0x96c, 0xd4ae, 0x149c, 0x1a4c, 0xbd26, 0x1aa6, 0xb54, 0x6d6a, 0x12da, 0x1695d,
        0x95a, 0x149a, 0xda4b, 0x1a4a, 0x1aa4, 0xbb54, 0x16b4, 0xada, 0x495b, 0x936, 0xf497, 0x1496, 0x154a, 0xb6a5,
        0xda4, 0x15b4, 0x6ab6, 0x126e, 0x1092f, 0x92e, 0xc96, 0xcd4a, 0x1d4a, 0xd64, 0x956c, 0x155c, 0x125c, 0x792e,
        0x192c, 0xfa95, 0x1a94, 0x1b4a, 0xab55, 0xad4, 0x14da, 0x8a5d, 0xa5a, 0x1152b, 0x152a, 0x1694, 0xd6aa,
        0x15aa, 0xab4, 0x94ba, 0x14b6, 0xa56, 0x7527, 0xd26, 0xee53, 0xd54, 0x15aa, 0xa9b5, 0x96c, 0x14ae, 0x8a4e,
        0x1a4c, 0x11d26, 0x1aa4, 0x1b54, 0xcd6a, 0xada, 0x95c, 0x949d, 0x149a, 0x1a2a, 0x5b25, 0x1aa4, 0xfb52,
        0x16b4, 0xaba, 0xa95b, 0x936, 0x1496, 0x9a4b, 0x154a, 0x136a5, 0xda4, 0x15ac
    ]
    
    //数组中每一个元素存放1901~2050期间每一年的12个月或13个月（有闰月）的月天数
    //数组元素的低12位或13位（有闰月）分别对应着这12个月或13个月（有闰月），最低位对应着最小月（1月）
    //如果月份对应的位为1则表示该月有30天，否则表示该月有29天。
    //注：农历中每个月的天数只有29天或者30天
    lazy var ll_monthDay = [
        0x0752, 0x0EA5, 0x164A, 0x064B, 0x0A9B, 0x1556, 0x056A, 0x0B59, 0x1752, 0x0752, //1910
        0x1B25, 0x0B25, 0x0A4B, 0x12AB, 0x0AAD, 0x056A, 0x0B69, 0x0DA9, 0x1D92, 0x0D92, //1920
        0x0D25, 0x1A4D, 0x0A56, 0x02B6, 0x15B5, 0x06D4, 0x0EA9, 0x1E92, 0x0E92, 0x0D26, //1930
        0x052B, 0x0A57, 0x12B6, 0x0B5A, 0x06D4, 0x0EC9, 0x0749, 0x1693, 0x0A93, 0x052B, //1940
        0x0A5B, 0x0AAD, 0x056A, 0x1B55, 0x0BA4, 0x0B49, 0x1A93, 0x0A95, 0x152D, 0x0536, //1950
        0x0AAD, 0x15AA, 0x05B2, 0x0DA5, 0x1D4A, 0x0D4A, 0x0A95, 0x0A97, 0x0556, 0x0AB5, //1960
        0x0AD5, 0x06D2, 0x0EA5, 0x0EA5, 0x064A, 0x0C97, 0x0A9B, 0x155A, 0x056A, 0x0B69, //1970
        0x1752, 0x0B52, 0x0B25, 0x164B, 0x0A4B, 0x14AB, 0x02AD, 0x056D, 0x0B69, 0x0DA9, //1980
        0x0D92, 0x1D25, 0x0D25, 0x1A4D, 0x0A56, 0x02B6, 0x05B5, 0x06D5, 0x0EC9, 0x1E92, //1990
        0x0E92, 0x0D26, 0x0A56, 0x0A57, 0x14D6, 0x035A, 0x06D5, 0x16C9, 0x0749, 0x0693, //2000
        0x152B, 0x052B, 0x0A5B, 0x155A, 0x056A, 0x1B55, 0x0BA4, 0x0B49, 0x1A93, 0x0A95, //2010
        0x052D, 0x0AAD, 0x0AAD, 0x15AA, 0x05D2, 0x0DA5, 0x1D4A, 0x0D4A, 0x0C95, 0x152E, //2020
        0x0556, 0x0AB5, 0x15B2, 0x06D2, 0x0EA9, 0x0725, 0x064B, 0x0C97, 0x0CAB, 0x055A, //2030
        0x0AD6, 0x0B69, 0x1752, 0x0B52, 0x0B25, 0x1A4B, 0x0A4B, 0x04AB, 0x055B, 0x05AD, //2040
        0x0B6A, 0x1B52, 0x0D92, 0x1D25, 0x0D25, 0x0A55, 0x14AD, 0x04B6, 0x05B5, 0x0DAA, //2050
    ]
    
    // 储存每一年的天数 计算一次更新一个
    lazy var hw_yearDay = Array(0...149)
    
    ///这个月有几天
    class func getTotaldays(year: Int, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8 ,10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        default:
            //被400整除 闰年
            let rst = year%400
            if rst == 0 {
                return 29
            }
            //能被4整除但不能被100整除 闰年
            let rst2 = year%4
            let rst3 = year%100
            if rst2 == 0, rst3 != 0 {
                return 29
            }
            return 28
        }
    }
    
    ///计算指定日期的星期索引值 索引对应 ["日", "一", "二", "三", "四", "五", "六"]
    class func getWeekIndex(year: Int, month: Int, day: Int) -> Int {
        let share = LLCalendar.share
        share.calendar_gl.firstWeekday = 1
        let comp = DateComponents(year: year, month: month, day: day)
        var idx = 0
        if let date = share.calendar_gl.date(from: comp), let first = share.calendar_gl.ordinality(of: .weekday, in: .weekOfMonth, for: date) {
            idx = first - 1
        }
        return idx
    }
    
    ///星期 ["日", "一", "二", "三", "四", "五", "六"]
    class func weekDayStr(_ weekDay: Int) -> String {
        return LLCalendar.share.weekdays[weekDay]
    }
    
    ///生肖 如: 虎
    class func lunar_zodiacStr(_ lunar_year: Int) -> String {
        let i = (lunar_year - 3) % 12
        let idx = (i == 0) ? 12 - 1 : i - 1
        return LLCalendar.share.zodiacs[idx]
    }
    
    ///农历年 如: 甲辰年
    class func lunar_yearStr(_ lunar_year: Int) -> String {
        let index_tg = (lunar_year - 4) % 10
        let tiangan = LLCalendar.share.tianGan[index_tg >= 0 ? index_tg : index_tg + 10]
        
        let index_dz = (lunar_year - 4) % 12
        let dizhi = LLCalendar.share.diZhi[index_dz >= 0 ? index_dz : index_dz + 12]
        
        return tiangan + dizhi
    }
    
    ///农历月 如: 正月/闰正月
    class func lunar_monthStr(_ lunar_month: Int) -> String {
        return LLCalendar.share.months_nl[lunar_month-1]
    }
    
    ///农历日 如: 初十
    class func lunar_DayStr(_ lunar_day: Int) -> String {
        return LLCalendar.share.days_nl[lunar_day-1]
    }
    
    ///公历月 如: 一月
    class func solar_monthStr(_ solarMonth: Int) -> String {
        return LLCalendar.share.months_gl[solarMonth-1]
    }
    
    ///公历日 如: 十
    class func solar_DayStr(_ solar_day: Int) -> String {
        return LLCalendar.share.days_gl[solar_day-1]
    }
    
    ///年份数字转中文
    class func chineseYearStr(_ year: Int) -> String {
        let share = LLCalendar.share
        var result = ""
        var number = year
        if number == 0 {
            return share.years_gl[0]
        }
        while number > 0 {
            let digit = number % 10
            result = share.years_gl[digit] + result
            number /= 10
        }
        return result
    }
    
    //MARK: - 公历农历相互转换
    ///公历转农历
    class func lunarFrom(_ solarYear: Int, _ solarMonth: Int, _ solarDay: Int) -> [Int] {
        let share = LLCalendar.share
        var index = solarYear - share.solar_1_1[0]
        let data = (solarYear << 9) | (solarMonth << 5) | (solarDay)
        var solar11 = 0
        if (share.solar_1_1[index] > data) {
            index -= 1
        }
        solar11 = share.solar_1_1[index]
        let y = GetBitInt(solar11, 12, 9)
        let m = GetBitInt(solar11, 4, 5)
        let d = GetBitInt(solar11, 5, 0)
        var offset = SolarToInt(solarYear, solarMonth, solarDay) - SolarToInt(y, m, d)
        let days = share.lunar_month_days[index]
        let leap = GetBitInt(days, 4, 13)
        let lunarY = index + share.solar_1_1[0]
        var lunarM = 1
        var lunarD = 1
        offset += 1
        for i in 0...12 {
            let dm = GetBitInt(days, 1, 12 - i) == 1 ? 30 : 29
            if (offset > dm) {
                lunarM += 1
                offset -= dm
            } else {
                break
            }
        }
        lunarD = offset
        var lunarM2 = lunarM
        var isLeap = 0
        if (leap != 0 && lunarM > leap) {
            lunarM2 = lunarM - 1
            if (lunarM == leap + 1) {
                //是否是闰月
                isLeap = 1
            }
        }
        var lunars = [Int]()
        lunars.append(lunarY)
        lunars.append(lunarM2)
        lunars.append(lunarD)
        lunars.append(isLeap)
        return lunars
    }
    
    ///农历转公历
    class func solarFrom(_ lunarYear: Int, _ lunarMonth: Int, _ lunarDay: Int, _ isLeap: Bool = false) -> [Int] {
        //闰月范围1950---2050 如需要更多 添加闰月数据到
        let share = LLCalendar.share
        let days = share.lunar_month_days[lunarYear - share.lunar_month_days[0]]
        let leap = GetBitInt(days, 4, 13)
        var offset = 0
        var loopend = leap
        //默认计算非闰月日期
        var is_Leap = false
        if isLeap {
            //验证该日期是否是闰月日期
            let leepMonth = getLeapMonthInYear(lunarYear)
            if lunarMonth == leepMonth {
                is_Leap = true
            }
        }
        if (is_Leap == false) {
            if (lunarMonth <= leap || leap == 0) {
                loopend = lunarMonth - 1
            } else {
                loopend = lunarMonth
            }
        }
        for i in 0..<loopend {
            offset += GetBitInt(days, 1, 12 - i) == 1 ? 30 : 29
        }
        offset += lunarDay
        let solar11 = share.solar_1_1[lunarYear - share.solar_1_1[0]]
        
        let y = GetBitInt(solar11, 12, 9)
        let m = GetBitInt(solar11, 4, 5)
        let d = GetBitInt(solar11, 5, 0)
        
        return SolarFromInt(SolarToInt(y, m, d) + offset - 1)
    }
    
    class func GetBitInt(_ data: Int, _ length: Int, _ shift: Int) -> Int {
        return (data & (((1 << length) - 1) << shift)) >> shift
    }
    
    class func SolarToInt(_ y: Int, _ m: Int, _ d: Int) -> Int {
        let m2 = (m + 9) % 12
        let y2 = y - m2 / 10
        return 365 * y2 + y2 / 4 - y2 / 100 + y2 / 400 + (m2 * 306 + 5) / 10 + (d - 1)
    }
    
    class func SolarFromInt(_ g: Int) -> [Int] {
        var y = (10000 * g + 14780) / 3652425
        var ddd = g - (365 * y + y / 4 - y / 100 + y / 400)
        if (ddd < 0) {
            y -= 1
            ddd = g - (365 * y + y / 4 - y / 100 + y / 400)
        }
        let mi = (100 * ddd + 52) / 3060
        let mm = (mi + 2) % 12 + 1
        y = y + (mi + 2) / 12
        let dd = ddd - (mi * 306 + 5) / 10 + 1
        var lunars = [Int]()
        lunars.append(y)
        lunars.append(mm)
        lunars.append(dd)
        return lunars
    }
}

//农历计算
extension LLCalendar {
    //1950年 - 2050年
    class func judgeYearLegal(_ year: Int) -> Bool {
        return (year >= self.share.START_YEAR || (year < self.share.END_YEAR))
    }
    
    class func getLeapMonthInYear(_ year: Int) -> Int {
        if(judgeYearLegal(year) == false) {
            return -1
        }
        return self.share.ll_leapMonth[year - self.share.START_YEAR]
    }
    
    //这个月有几天
    //若是闰月 如: 闰六月 则month=7的数据即为闰六月的数据 month=8即为七月的数据 依次类推
    class func getMonthDaysInYear(_ year: Int, _ month: Int) -> Int {
        if(judgeYearLegal(year) == false) {
            return -1
        }
        let monthNum = 12 + ((self.share.ll_leapMonth[year - self.share.START_YEAR] > 0) ? 1 : 0)
        if(month < 1 || month > monthNum) {
            return -1
        }
        return ((self.share.ll_monthDay[year - self.share.START_YEAR] & (1 << (month - 1))) > 0) ? 30 : 29
    }
    
    class func getYearDaysInYear(_ year: Int) -> Int {
        if(judgeYearLegal(year) == false) {
            return -1
        }
        var yearDayNum = self.share.hw_yearDay[year - self.share.START_YEAR]
        if((yearDayNum) > 0) {
            return yearDayNum
        }
        var num = self.share.ll_monthDay[year - self.share.START_YEAR]
        // 计算num的二进制位中“1”的个数
        num = ((num >> 1) & 0x5555) + (num & 0x5555)
        num = ((num >> 2) & 0x3333) + (num & 0x3333)
        num = ((num >> 4) & 0x0F0F) + (num & 0x0F0F)
        num = ((num >> 8) & 0x00FF) + (num & 0x00FF)
        
        let monthNum = 12 + ((self.share.ll_leapMonth[year - self.share.START_YEAR] > 0) ? 1 : 0)
        yearDayNum = monthNum * 29 + num
        self.share.hw_yearDay[year - self.share.START_YEAR] = yearDayNum
        return yearDayNum
    }
}
