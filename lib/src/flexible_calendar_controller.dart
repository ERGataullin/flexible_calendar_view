import 'extended_date_time.dart';
import 'flexible_calendar_mode.dart';

typedef DatePickListener = void Function();

enum DayState {
  normal,
  selectedRangeStart,
  selectedRangePart,
  selectedRangeEnd,
}

extension IsThatDayState on DayState {
  bool get isNormal => this == DayState.normal;
  bool get isSelectedRangeStart => this == DayState.selectedRangeStart;
  bool get isSelectedRangePart => this == DayState.selectedRangePart;
  bool get isSelectedRangeEnd => this == DayState.selectedRangeEnd;
}

abstract class FlexibleCalendarControllerBase {
  int get firstWeekday;
  int get lastWeekday;
  set firstWeekday(int firstWeekday);

  DateTime get month;
  set month(DateTime targetMonth);

  List<DateTime> get days;

  DateTime? get selectedRangeStart;
  DateTime? get selectedRangeEnd;

  void addDatePickListener(DatePickListener listener);

  void onDayPicked(DateTime date);

  void notifyDatePickListeners();

  void checkDaysStates();

  DayState getDayState(DateTime date);

  void removeDatePickListener(DatePickListener listener);
}

class FlexibleCalendarController extends FlexibleCalendarControllerBase
    with
        _FlexibleCalendarViewingController,
        _FlexibleCalendarDatePickingController {
  FlexibleCalendarController({
    FlexibleCalendarMode mode = FlexibleCalendarMode.calendar,
    DateTime? initialMonth,
    int firstWeekday = DateTime.monday,
  }) {
    this.mode = mode;
    month = initialMonth ?? DateTime.now();
    this.firstWeekday = firstWeekday;
  }
}

mixin _FlexibleCalendarViewingController on FlexibleCalendarControllerBase {
  late int _firstWeekday;
  late int _lastWeekday;
  late DateTime _month;
  List<DateTime>? _days;

  @override
  int get firstWeekday => _firstWeekday;

  @override
  int get lastWeekday => _lastWeekday;

  @override
  set firstWeekday(int firstWeekday) {
    _firstWeekday = firstWeekday;

    _lastWeekday = firstWeekday - 1;
    if (_lastWeekday < 1) _lastWeekday += 7;

    _days = null;
  }

  @override
  DateTime get month => _month;

  @override
  set month(DateTime targetMonth) {
    _month = DateTime(targetMonth.year, targetMonth.month);
    _days = null;
  }

  @override
  List<DateTime> get days {
    if (_days == null) {
      _days = [
        ..._daysBeforeTargetMonth,
        ..._targetMonthDays,
        ..._daysAfterTargetMonth,
      ];
      checkDaysStates();
    }

    return _days!;
  }

  List<DateTime> get _targetMonthDays {
    final targetMonthDaysCount = DateTime(
      _month.year,
      _month.month + 1,
    ).difference(_month).inDays;

    return List.generate(
      targetMonthDaysCount,
      (dayIndex) => DateTime(_month.year, _month.month, dayIndex + 1),
    );
  }

  List<DateTime> get _daysBeforeTargetMonth {
    var daysBeforeTargetMonthCount = _month.weekday - _firstWeekday;
    if (daysBeforeTargetMonthCount < 0) daysBeforeTargetMonthCount += 7;

    return List.generate(
      daysBeforeTargetMonthCount,
      (index) => DateTime(
        _month.year,
        _month.month,
        index - daysBeforeTargetMonthCount + 1,
      ),
    );
  }

  List<DateTime> get _daysAfterTargetMonth {
    final lastTargetMonthDay = DateTime(
      _month.year,
      _month.month + 1,
      0,
    );
    var daysAfterTargetMonthCount = _lastWeekday - lastTargetMonthDay.weekday;
    if (daysAfterTargetMonthCount < 0) daysAfterTargetMonthCount += 7;

    return List.generate(
      daysAfterTargetMonthCount,
      (index) => DateTime(
        lastTargetMonthDay.year,
        lastTargetMonthDay.month,
        lastTargetMonthDay.day + index + 1,
      ),
    );
  }
}

mixin _FlexibleCalendarDatePickingController on FlexibleCalendarControllerBase {
  final _datePickListeners = <DatePickListener>[];
  late final FlexibleCalendarMode mode;
  Map<DateTime, DayState>? _daysStates;

  @override
  DateTime? selectedRangeStart;

  @override
  DateTime? selectedRangeEnd;

  @override
  void addDatePickListener(DatePickListener listener) =>
      _datePickListeners.add(listener);

  @override
  void onDayPicked(DateTime date) {
    if (mode.isCalendar) {
      throw StateError(
        'The current mode is `FlexibleCalendarMode.calendar`, '
        'not a `FlexibleCalendarMode.datePicker` or `FlexibleCalendarMode.dateRangePicker`',
      );
    }

    if (selectedRangeStart == null || mode.isDatePicker) {
      selectedRangeStart = date;
    } else {
      if (selectedRangeEnd != null) {
        selectedRangeStart = date;
        selectedRangeEnd = null;
      } else if (selectedRangeStart! <= date) {
        selectedRangeEnd = date;
      } else {
        selectedRangeEnd = selectedRangeStart;
        selectedRangeStart = date;
      }
    }
    checkDaysStates();

    notifyDatePickListeners();
  }

  @override
  void notifyDatePickListeners() {
    for (final listener in _datePickListeners) {
      listener();
    }
  }

  @override
  void checkDaysStates() {
    _daysStates = {};
    for (final day in days) {
      _daysStates!.putIfAbsent(
        day,
        () {
          final isSelectedRangeStart =
              selectedRangeStart?.isTheSameDayAs(day) ?? false;
          final isSelectedRangeEnd =
              selectedRangeEnd?.isTheSameDayAs(day) ?? false;
          final isSelectedRangePart =
              selectedRangeStart == null || selectedRangeEnd == null
                  ? false
                  : selectedRangeStart! <= day && day <= selectedRangeEnd!;

          return isSelectedRangeStart
              ? DayState.selectedRangeStart
              : isSelectedRangeEnd
                  ? DayState.selectedRangeEnd
                  : isSelectedRangePart
                      ? DayState.selectedRangePart
                      : DayState.normal;
        },
      );
    }
  }

  @override
  DayState getDayState(DateTime date) {
    if (_daysStates == null) {
      throw StateError('Days\' states have not been initialized');
    }

    final state = _daysStates![date];
    if (state == null) {
      throw ArgumentError.value(date);
    }

    return state;
  }

  @override
  void removeDatePickListener(DatePickListener listener) =>
      _datePickListeners.remove(listener);
}
