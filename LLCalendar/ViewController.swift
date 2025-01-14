//
//  ViewController.swift
//  LLCalendar
//
//  Created by chuanshuo on 14/01/2025.
//

import UIKit

class ViewController: UIViewController {
    
    var calendarView: LLCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = LLLabel(CGRect(x: 0.0, y: 88.0, width: LL_SCREEN_WIDTH, height: 25.0))
            .ll_font(.boldSystemFont(ofSize: 20.0))
            .ll_textColor(.brown)
            .ll_textAlignment(.center)
            .ll_text("当前月份")
            .ll_adjustsFontSizeToFitWidth(true)
            .ll_showInView(self.view)
        
        let myLabel = LLLabel(CGRect(x: 0.0, y: CGRectGetMaxY(titleLabel.frame)+10.0, width: LL_SCREEN_WIDTH, height: 35.0))
            .ll_font(.boldSystemFont(ofSize: 15.0))
            .ll_textColor(.darkText)
            .ll_textAlignment(.center)
            .ll_numberOfLines(0)
            .ll_adjustsFontSizeToFitWidth(true)
            .ll_isUserInteractionEnabled(true)
            .ll_showInView(self.view) as! UILabel
        
        let myLabel2 = LLLabel(CGRect(x: 0.0, y: CGRectGetMaxY(myLabel.frame)+5.0, width: LL_SCREEN_WIDTH, height: 35.0))
            .ll_font(.boldSystemFont(ofSize: 15.0))
            .ll_textColor(.darkText)
            .ll_textAlignment(.center)
            .ll_numberOfLines(0)
            .ll_adjustsFontSizeToFitWidth(true)
            .ll_isUserInteractionEnabled(true)
            .ll_showInView(self.view) as! UILabel
        
        // 添加点击事件
        myLabel.tag = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        myLabel.addGestureRecognizer(tapGesture)
        
        // 添加点击事件
        myLabel2.tag = 1
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        myLabel2.addGestureRecognizer(tapGesture2)
        
        //日历配置
        //文字颜色
        LLCalendarTool.tool.normalTextColor = .darkText
        //文字颜色 选中
        LLCalendarTool.tool.selectedTextColor = .white
        //文字颜色 今天
        LLCalendarTool.tool.todayTextColor = .red
        //背景色
        LLCalendarTool.tool.normalBgColor = .purple.withAlphaComponent(0.2)
        //背景色 选中
        LLCalendarTool.tool.selectedBgColor = .blue.withAlphaComponent(0.2)
        //日历视图 可设置纵向或横向滑动 是否显示农历日期
        let rect = CGRect(x: 10.0, y: CGRectGetMaxY(myLabel2.frame)+10.0, width: LL_SCREEN_WIDTH-20.0, height: 380.0)
        calendarView = LLCalendarView(frame: rect, direction: .vertical, isShowLunar: true)
        //设置今天的日期
        calendarView.resetToday(date: Date())
        //跳转到对应日期并选中
        calendarView.scrollTo(date: Date(), selected: true)
        calendarView.backgroundColor = .blue.withAlphaComponent(0.1)
        self.view.addSubview(calendarView)
        
        let titleLabel2 = LLLabel(CGRect(x: 0.0, y: CGRectGetMaxY(calendarView.frame)+10.0, width: LL_SCREEN_WIDTH, height: 25.0))
            .ll_font(.boldSystemFont(ofSize: 20.0))
            .ll_textColor(.brown)
            .ll_textAlignment(.center)
            .ll_text("选中日期")
            .ll_adjustsFontSizeToFitWidth(true)
            .ll_showInView(self.view)
        
        let myLabel3 = LLLabel(CGRect(x: 0.0, y: CGRectGetMaxY(titleLabel2.frame)+10.0, width: LL_SCREEN_WIDTH, height: 35.0))
            .ll_font(.boldSystemFont(ofSize: 15.0))
            .ll_textColor(.darkText)
            .ll_textAlignment(.center)
            .ll_numberOfLines(0)
            .ll_adjustsFontSizeToFitWidth(true)
            .ll_showInView(self.view) as! UILabel
        
        let myLabel4 = LLLabel(CGRect(x: 0.0, y: CGRectGetMaxY(myLabel3.frame)+5.0, width: LL_SCREEN_WIDTH, height: 35.0))
            .ll_font(.boldSystemFont(ofSize: 15.0))
            .ll_textColor(.darkText)
            .ll_textAlignment(.center)
            .ll_numberOfLines(0)
            .ll_adjustsFontSizeToFitWidth(true)
            .ll_showInView(self.view) as! UILabel
        
        //当前月份
        calendarView.valueChanged(showMonth: { [weak self] month in
            guard let `self` = self else {return}
            //公历月份
            myLabel.text = "公历: " + month.ll_description() + "\n点击可选择公历日期"
            //农历月份 取当前月的第一天对应的农历月份
            let lunarMonth = month.day(of: 1).lunarDay.monthModel!
            myLabel2.text = "农历: " + lunarMonth.ll_description() + "\n点击可选择农历日期"
            
            //这里可以处理日历视图的frame改变后 适配其他视图frame
            UIView.animate(withDuration: 0.2) {
                var rect2 = titleLabel2.frame
                rect2.origin.y = CGRectGetMaxY(self.calendarView.frame)+10.0
                titleLabel2.frame = rect2
                
                var rect3 = myLabel3.frame
                rect3.origin.y = CGRectGetMaxY(titleLabel2.frame)+10.0
                myLabel3.frame = rect3
                
                var rect4 = myLabel4.frame
                rect4.origin.y = CGRectGetMaxY(myLabel3.frame)+5.0
                myLabel4.frame = rect4
            }
        })
        
        //选中日期
        calendarView.valueChanged(selectedDay: { day in
            //公历
            myLabel3.text = "公历: " + "\(day.ll_description())"
            //转为农历
            let lunarDay = day.lunarDay
            myLabel4.text = "农历: " + "\(lunarDay.ll_description())"
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            
        }
    }
    
    @objc func labelTapped(sender: UITapGestureRecognizer) {
        //日期选择器
        var pickerView: LLDatePickerView!
        if sender.view?.tag == 0 {
            //默认公历
            pickerView = LLDatePickerView(frame: CGRect(x: 0.0, y: 0.0, width: LL_SCREEN_WIDTH, height: 300.0))
        }
        else {
            //农历
            pickerView = LLDatePickerView(frame: CGRect(x: 0.0, y: 0.0, width: LL_SCREEN_WIDTH, height: 300.0), type: .LLLunar)
        }
        //跳转到指定日期
        pickerView.scroll(to: Date())
        //选中日期后回调 回调day为公历LLSolarDay对象 可使用day.lunarDay转换为农历对象
        pickerView.valueChanged { [weak self] day in
            guard let `self` = self else {return}
            //公历
            print("公历: \(day.ll_description())")
            //转为农历
            let lunarDay = day.lunarDay
            print("农历: \(lunarDay.ll_description())")
            self.calendarView.scrollTo(date: day.toDate(), selected: true)
        }
        LLPopupAnimator.animator.popUp(view: pickerView, style: .down, inView: self.view)
    }
}

