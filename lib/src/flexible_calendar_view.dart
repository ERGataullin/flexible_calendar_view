import 'package:flutter/widgets.dart';

import 'extended_date_time.dart';
import 'flexible_calendar_controller.dart';
import 'flexible_calendar_mode.dart';

typedef DayBuilder = Widget Function(
  BuildContext context,
  DateTime date,
  DayState state,
);

typedef DayButtonBuilder = Widget Function(
  BuildContext context,
  Widget day,
  VoidCallback onPressed,
);

typedef OnDateSelected = void Function(DateTime date);
typedef OnDateRangeSelected = void Function(DateTime start, DateTime end);

class FlexibleCalendarView extends StatefulWidget {
  const FlexibleCalendarView({
    Key? key,
    this.controller,
    this.mode,
    this.initialMonth,
    this.firstWeekday,
    required this.dayBuilder,
    DayBuilder? todayBuilder,
    this.dayButtonBuilder,
    this.onDateSelected,
    this.onDateRangeSelected,
  })  : assert(
          controller == null
              ? mode != null && firstWeekday != null
              : mode == null && initialMonth == null && firstWeekday == null,
        ),
        assert(
          mode == FlexibleCalendarMode.calendar
              ? dayButtonBuilder == null
              : dayButtonBuilder != null,
        ),
        assert(
          firstWeekday == null ||
              DateTime.monday <= firstWeekday &&
                  firstWeekday <= DateTime.sunday,
        ),
        assert(
          mode == FlexibleCalendarMode.calendar &&
                  onDateSelected == null &&
                  onDateRangeSelected == null ||
              mode == FlexibleCalendarMode.datePicker &&
                  onDateSelected != null &&
                  onDateRangeSelected == null ||
              mode == FlexibleCalendarMode.dateRangePicker &&
                  onDateSelected == null &&
                  onDateRangeSelected != null,
        ),
        todayBuilder = todayBuilder ?? dayBuilder,
        super(key: key);

  const FlexibleCalendarView.calendar({
    Key? key,
    FlexibleCalendarController? controller,
    DateTime? initialMonth,
    int? firstWeekday,
    required DayBuilder dayBuilder,
    DayBuilder? todayBuilder,
  }) : this(
          key: key,
          controller: controller,
          mode: controller == null ? FlexibleCalendarMode.calendar : null,
          initialMonth: initialMonth,
          firstWeekday: firstWeekday,
          dayBuilder: dayBuilder,
          todayBuilder: todayBuilder,
        );

  const FlexibleCalendarView.datePicker({
    Key? key,
    FlexibleCalendarController? controller,
    DateTime? initialMonth,
    int? firstWeekday,
    required DayBuilder dayBuilder,
    DayBuilder? todayBuilder,
    required DayButtonBuilder dayButtonBuilder,
  }) : this(
          key: key,
          controller: controller,
          mode: controller == null ? FlexibleCalendarMode.datePicker : null,
          initialMonth: initialMonth,
          firstWeekday: firstWeekday,
          dayBuilder: dayBuilder,
          todayBuilder: todayBuilder,
          dayButtonBuilder: dayButtonBuilder,
        );

  const FlexibleCalendarView.dateRangePicker({
    Key? key,
    FlexibleCalendarController? controller,
    DateTime? initialMonth,
    int? firstWeekday,
    required DayBuilder dayBuilder,
    DayBuilder? todayBuilder,
    required DayButtonBuilder dayButtonBuilder,
  }) : this(
          key: key,
          controller: controller,
          mode:
              controller == null ? FlexibleCalendarMode.dateRangePicker : null,
          initialMonth: initialMonth,
          firstWeekday: firstWeekday,
          dayBuilder: dayBuilder,
          todayBuilder: todayBuilder,
          dayButtonBuilder: dayButtonBuilder,
        );

  final FlexibleCalendarController? controller;
  final FlexibleCalendarMode? mode;
  final DateTime? initialMonth;
  final int? firstWeekday;
  final DayBuilder dayBuilder, todayBuilder;
  final DayButtonBuilder? dayButtonBuilder;
  final OnDateSelected? onDateSelected;
  final OnDateRangeSelected? onDateRangeSelected;

  @override
  State<FlexibleCalendarView> createState() => _FlexibleCalendarViewState();
}

class _FlexibleCalendarViewState extends State<FlexibleCalendarView> {
  late final FlexibleCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        FlexibleCalendarController(
          mode: widget.mode!,
          initialMonth: widget.initialMonth,
          firstWeekday: widget.firstWeekday!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _CalendarView(
          controller: _controller,
          dayBuilder: widget.dayBuilder,
          todayBuilder: widget.todayBuilder,
          dayButtonBuilder: widget.dayButtonBuilder,
        ),
      ],
    );
  }
}

class _CalendarView extends StatelessWidget {
  const _CalendarView({
    Key? key,
    required this.controller,
    required this.dayBuilder,
    required this.todayBuilder,
    this.dayButtonBuilder,
  }) : super(key: key);

  final FlexibleCalendarController controller;
  final DayBuilder dayBuilder, todayBuilder;
  final DayButtonBuilder? dayButtonBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        13,
        (index) {
          return index.isEven
              ? _buildWeekdayDays(context, weekday: index ~/ 2)
              : const Spacer();
        },
      ),
    );
  }

  Widget _buildWeekdayDays(
    BuildContext context, {
    required int weekday,
  }) {
    return Column(
      children: List.generate(
        (controller.days.length / 7).ceil(),
        (weekdayDayIndex) => _buildDay(
          context,
          date: controller.days[weekdayDayIndex * 7 + weekday],
        ),
      ),
    );
  }

  Widget _buildDay(
    BuildContext context, {
    required DateTime date,
  }) {
    return _DayContainer(
      key: ValueKey(date),
      controller: controller,
      date: date,
      dayBuilder: dayBuilder,
      todayBuilder: todayBuilder,
      dayButtonBuilder: dayButtonBuilder,
    );
  }
}

class _DayContainer extends StatefulWidget {
  const _DayContainer({
    Key? key,
    required this.controller,
    required this.date,
    required this.dayBuilder,
    required this.todayBuilder,
    this.dayButtonBuilder,
  }) : super(key: key);

  final FlexibleCalendarController controller;
  final DateTime date;
  final DayBuilder dayBuilder, todayBuilder;
  final DayButtonBuilder? dayButtonBuilder;

  @override
  State<_DayContainer> createState() => _DayContainerState();
}

class _DayContainerState extends State<_DayContainer> {
  late DayState _dayState;

  @override
  void initState() {
    super.initState();
    widget.controller.addDatePickListener(_onDatePick);
    // TODO: Implement initial date range selection
    _dayState = widget.controller.getDayState(widget.date);
  }

  void _onDatePick() {
    final newDayState = widget.controller.getDayState(widget.date);
    if (_dayState != newDayState) {
      setState(() => _dayState = newDayState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final builder =
        widget.date.isToday ? widget.todayBuilder : widget.dayBuilder;
    final day = builder(context, widget.date, _dayState);

    return widget.dayButtonBuilder?.call(
          context,
          day,
          () => widget.controller.onDayPicked(widget.date),
        ) ??
        day;
  }
}
