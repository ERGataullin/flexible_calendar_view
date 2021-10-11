enum FlexibleCalendarMode { calendar, datePicker, dateRangePicker }

extension IsThatMode on FlexibleCalendarMode {
  bool get isCalendar => this == FlexibleCalendarMode.calendar;
  bool get isDatePicker => this == FlexibleCalendarMode.datePicker;
  bool get isDateRangePicker => this == FlexibleCalendarMode.dateRangePicker;
}
