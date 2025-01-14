
**一、效果图**

![效果图](https://github.com/xiaoyi3699/LLCalendar/blob/main/preview1.jpeg?raw=true)

**二、集成方式**

**直接将文件夹`LLCalendar`导入项目即可**

**三、调用方式**

**日历视图**

```
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

//可设置纵向或横向滑动 是否显示农历日期
let rect = CGRect(x: 10.0, y: CGRectGetMaxY(myLabel2.frame)+10.0, width: LL_SCREEN_WIDTH-20.0, height: 380.0)
calendarView = LLCalendarView(frame: rect, direction: .vertical, isShowLunar: true)
//设置今天的日期
calendarView.resetToday(date: Date())
//跳转到对应日期并选中
calendarView.scrollTo(date: Date(), selected: true)
calendarView.backgroundColor = .blue.withAlphaComponent(0.1)
self.view.addSubview(calendarView)

```

**日期选择器视图**

```
//可设置公历或者农历
let pickerView = LLDatePickerView(frame: CGRect(x: 0.0, y: 0.0, width: LL_SCREEN_WIDTH, height: 300.0), type: .LLLunar)
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

```
