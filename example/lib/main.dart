import 'package:flexible_calendar_view/flexible_calendar_view.dart';
import 'package:flutter/material.dart';

void main() => const FlexibleCalendarViewExample().run();

class FlexibleCalendarViewExample extends MaterialApp {
  const FlexibleCalendarViewExample({Key? key})
      : super(
          key: key,
          debugShowCheckedModeBanner: false,
          title: 'Flexible calendar view example',
          home: const HomePage(),
        );

  void run() => runApp(this);
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const fontSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Date range picker'),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildWeekdays(context),
        _buildCalendarView(context),
      ],
    );
  }

  Widget _buildWeekdays(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
          .map((weekday) => _buildWeekday(context, weekday: weekday))
          .toList(growable: false),
    );
  }

  Widget _buildWeekday(
    BuildContext context, {
    required String weekday,
  }) {
    return _buildCell(
      context,
      text: weekday,
      textStyle: const TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildCalendarView(BuildContext context) {
    return FlexibleCalendarView(
      controller: FlexibleCalendarController(
        mode: FlexibleCalendarMode.dateRangePicker,
      ),
      dayBuilder: _buildDay,
      todayBuilder: _buildToday,
      dayButtonBuilder: _buildDayButton,
      onDateRangeSelected: (_, __) {},
    );
  }

  Widget _buildDay(
    BuildContext context,
    DateTime date,
    DayState state, [
    TextStyle textStyle = const TextStyle(fontSize: fontSize),
  ]) {
    return Container(
      color: state.isSelectedRangeStart || state.isSelectedRangeEnd
          ? Theme.of(context).primaryColor
          : state.isSelectedRangePart
              ? Theme.of(context).highlightColor
              : null,
      child: _buildCell(
        context,
        text: date.day.toString(),
        textStyle: textStyle,
      ),
    );
  }

  Widget _buildToday(BuildContext context, DateTime date, DayState state) =>
      _buildDay(
        context,
        date,
        state,
        const TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      );

  Widget _buildCell(
    BuildContext context, {
    required String text,
    TextStyle textStyle = const TextStyle(fontSize: 20),
  }) {
    const size = 48.0;
    return Container(
      // width: size,
      // height: size,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(8),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }

  Widget _buildDayButton(
    BuildContext context,
    Widget day,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: day,
    );
  }
}
