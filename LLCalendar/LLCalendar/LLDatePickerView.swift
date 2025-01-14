//
//  LLDatePickerView.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 13/01/2025.
//

import UIKit

class LLDatePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return (endYear-startYear+1)
        }
        let year = pickerView.selectedRow(inComponent: 0)+startYear
        if l_type == .LLLunar {
            let yearModel = LLCalendarTool.loadLunarYear(year)
            if component == 1 {
                return yearModel.totalMonthCount
            }
            let maxMonth = yearModel.totalMonthCount
            let selMonth = pickerView.selectedRow(inComponent: 1) + 1
            let month = min(maxMonth, selMonth)
            let monthModel = yearModel.getMonth(month)
            return monthModel.totalDayCount
        }
        else {
            if component == 1 {
                return 12
            }
            let month = pickerView.selectedRow(inComponent: 1) + 1
            let yearModel = LLCalendarTool.loadSolarYear(year)
            let monthModel = yearModel.month(of: month)
            return monthModel.totalDayCount
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var string = ""
        if component == 0 {
            let year = startYear+row
            if self.l_type == .LLLunar {
                let yearModel = LLCalendarTool.loadLunarYear(year)
                string = "\(yearModel.year)" + yearModel.heaEarStr + yearModel.zodiacStr + "年"
            }
            else {
                let yearModel = LLCalendarTool.loadSolarYear(year)
                string = "\(yearModel.year)" + "年"
            }
        }
        else {
            if self.l_type == .LLLunar {
                if component == 1 {
                    let year = pickerView.selectedRow(inComponent: 0)+startYear
                    let yearModel = LLCalendarTool.loadLunarYear(year)
                    let maxMonth = yearModel.totalMonthCount
                    let selMonth = row+1
                    let month = min(maxMonth, selMonth)
                    let monthModel = yearModel.getMonth(month)
                    string =  monthModel.leapStr + monthModel.monthStr + "月"
                }
                else {
                    string =  LLCalendar.lunar_DayStr(row+1)
                }
            }
            else {
                if component == 1 {
                    string =  "\(row + 1)" + "月"
                }
                else {
                    string =  "\(row + 1)"
                }
            }
        }
        let rstLabel = (view as? UILabel) ?? UILabel()
        rstLabel.text = string
        rstLabel.textAlignment = .center
        rstLabel.font = .systemFont(ofSize: 17.0)
        rstLabel.adjustsFontSizeToFitWidth = true
        return rstLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 150.0
        }
        if component == 1 {
            return 80.0
        }
        return 80.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        }
        else if component == 1 {
            pickerView.reloadComponent(2)
        }
        let s_year = pickerView.selectedRow(inComponent: 0) + startYear
        let s_month = pickerView.selectedRow(inComponent: 1) + 1
        let s_day = pickerView.selectedRow(inComponent: 2) + 1
        if l_type == .LLLunar {
            let yearModel = LLCalendarTool.loadLunarYear(s_year)
            let maxMonth = yearModel.totalMonthCount
            let month = min(maxMonth, s_month)
            let monthModel = yearModel.getMonth(month)
            let dayModel = LLLunarDay(s_year, monthModel.month, s_day, monthModel.isLeap)
            l_selectedModel = dayModel.solarDay
        }
        else {
            l_selectedModel = LLSolarDay(s_year, s_month, s_day)
        }
    }
    
    enum LLDateType {
    case LLLunar //农历
    case LLSolar //公历
    }
    
    //1950年-2050年
    private let startYear = 1950
    private let endYear = 2050
    private var l_type: LLDateType = .LLSolar
    private var l_pickerView: UIPickerView!
    private var didSelectedDayBlock: ((_ day: LLSolarDay) -> Void)?
    private var l_selectedModel: LLSolarDay?
    init(frame: CGRect, type aType: LLDateType = .LLSolar) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        let dayLabel = UILabel(frame: CGRect(x: 0.0, y: 5.0, width: self.bounds.size.width, height: 40.0))
        dayLabel.font = .systemFont(ofSize: 15.0)
        dayLabel.textAlignment = .center
        dayLabel.textColor = .gray
        dayLabel.text = "请选择日期"
        self.addSubview(dayLabel)
        
        let dayLabelH = CGRectGetMaxY(dayLabel.frame)
        var rect = self.bounds
        rect.origin.y = dayLabelH
        //rect.size.height = dayLabelH
        l_type = aType
        l_pickerView = UIPickerView(frame: rect)
        l_pickerView.delegate = self
        l_pickerView.dataSource = self
        addSubview(l_pickerView)
        
        let colBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        colBtn.tag = 0
        colBtn.addTarget(self, action: #selector(btnCilck), for: .touchUpInside)
        addSubview(colBtn)
        let imgView = UIImageView(frame: CGRect(x: 10.0, y: 12.0, width: 16.0, height: 16.0))
        imgView.image = UIImage.init(named: "ll_colse_cg")
        colBtn.addSubview(imgView)
        
        let okBtn = UIButton(frame: CGRect(x: self.bounds.size.width-40.0, y: 0.0, width: 40.0, height: 40.0))
        okBtn.tag = 1
        okBtn.addTarget(self, action: #selector(btnCilck), for: .touchUpInside)
        addSubview(okBtn)
        let imgView2 = UIImageView(frame: CGRect(x: 10.0, y: 10.0, width: 20.0, height: 18.0))
        imgView2.image = UIImage.init(named: "ll_ok_dg")
        okBtn.addSubview(imgView2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scroll(to date: Date) {
        let coms = LLCalendar.share.calendar_gl.dateComponents([.year, .month, .day], from: date)
        if l_type == .LLLunar {
            let lunar = LLCalendar.lunarFrom(coms.year!, coms.month!, coms.day!)
            scrollTo(year: lunar[0], month: lunar[1], day: lunar[2], isLeap: (lunar[3] == 1), coms: coms)
        }
        else {
            scrollTo(year: coms.year!, month: coms.month!, day: coms.day!)
        }
    }
    
    func scrollTo(year: Int, month: Int, day: Int, isLeap: Bool = false, coms aComs: DateComponents? = nil) {
        let com0 = year-startYear
        var com1 = month-1
        let com2 = day-1
        if l_type == .LLLunar {
            if isLeap {
                com1 += 1
            }
            else {
                let leapMonth = LLCalendar.getLeapMonthInYear(year)
                if leapMonth > 0, leapMonth < month {
                    com1 += 1
                }
            }
        }
        if let coms = aComs {
            l_selectedModel = LLSolarDay(coms.year!, coms.month!, coms.day!)
        }
        else {
            if l_type == .LLLunar {
                let lunar = LLLunarDay(year, month, day, isLeap)
                l_selectedModel = lunar.solarDay
            }
            else {
                l_selectedModel = LLSolarDay(year, month, day)
            }
        }
        l_pickerView.selectRow(com0, inComponent: 0, animated: false)
        l_pickerView.selectRow(com1, inComponent: 1, animated: false)
        l_pickerView.selectRow(com2, inComponent: 2, animated: false)
    }
    
    //设置点击日期时的回调block
    func valueChanged(selectedDay: ((_ day: LLSolarDay) -> Void)?) {
        self.didSelectedDayBlock = selectedDay
    }
    
    @objc func btnCilck(btn: UIButton) {
        if btn.tag == 1 {
            if let model = l_selectedModel {
                self.didSelectedDayBlock?(model)
            }
        }
        LLPopupAnimator.animator.dismiss()
    }
}
