// import 'package:flutter/cupertino.dart' show CupertinoIcons;
// import 'package:flutter/material.dart';

// typedef OnRangeSelected = void Function(DateTime, DateTime);
// typedef OnMonthSelected = void Function(DateTime);

// const _rangeColor = Color(0xFFF3F3F7);

// class CalendarController {
//   final _onRangeSelectedListeners = <OnRangeSelected>[];
//   final _onMonthSelectedListeners = <OnMonthSelected>[];
//   late DateTime _monthDate;
//   DateTime? selectedRangeStart, selectedRangeEnd;

//   DateTime get monthDate => _monthDate;

//   List<DateTime> get days {
//     final daysCount = DateTime(_monthDate.year, _monthDate.month + 1)
//         .difference(_monthDate)
//         .inDays;

//     return List.generate(
//       daysCount,
//       (index) => DateTime(_monthDate.year, _monthDate.month, index + 1),
//     );
//   }

//   CalendarController() {
//     final todayDate = DateTime.now();
//     _monthDate = DateTime(todayDate.year, todayDate.month);
//   }

//   void onDateClicked(DateTime date) {
//     if (selectedRangeStart == null) {
//       selectedRangeStart = date;
//     } else if (selectedRangeEnd == null) {
//       if (date.isBefore(selectedRangeStart!)) {
//         selectedRangeEnd = selectedRangeStart;
//         selectedRangeStart = date;
//       } else {
//         selectedRangeEnd = date;
//       }
//     } else {
//       selectedRangeStart = date;
//       selectedRangeEnd = null;
//     }
//     for (final listener in _onRangeSelectedListeners) {
//       listener(selectedRangeStart!, selectedRangeEnd!);
//     }
//   }

//   void onMonthSelected(DateTime monthDate) {
//     _monthDate = monthDate;
//     for (final listener in _onMonthSelectedListeners) listener(_monthDate);
//   }

//   void addOnRangeSelectedListener(OnRangeSelected onRangeSelected) =>
//       _onRangeSelectedListeners.add(onRangeSelected);

//   void addOnMonthSelectedListener(OnMonthSelected onMonthSelected) =>
//       _onMonthSelectedListeners.add(onMonthSelected);

//   void removeOnRangeSelectedListener(OnRangeSelected onRangeSelected) =>
//       _onRangeSelectedListeners.remove(onRangeSelected);

//   void removeOnMonthSelectedListener(OnMonthSelected onMonthSelected) =>
//       _onMonthSelectedListeners.remove(onMonthSelected);
// }

// class Calendar extends StatefulWidget {
//   final List<String> months, weekdays;
//   final int firstWeekday;

//   const Calendar({
//     Key? key,
//     required this.months,
//     required this.weekdays,
//     required this.firstWeekday,
//   }) : super(key: key);

//   @override
//   _CalendarState createState() => _CalendarState();
// }

// class _CalendarState extends State<Calendar> {
//   final _controller = CalendarController();
//   late final ThemeData _theme;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildMonthRow(),
//         const SizedBox(height: 24),
//         CalendarDaysGrid(
//           weekdays: widget.weekdays,
//           firstWeekday: widget.firstWeekday,
//           controller: _controller,
//         ),
//       ],
//     );
//   }

//   Widget _buildMonthRow() {
//     return Row(
//       children: [
//         _MonthView(
//           months: widget.months,
//           controller: _controller,
//         ),
//         _buildIconButton(
//           CupertinoIcons.right_chevron,
//           () {},
//         ),
//         const Spacer(),
//         _buildIconButton(
//           CupertinoIcons.left_chevron,
//           () => _controller.onMonthSelected(DateTime(
//             _controller.monthDate.year,
//             _controller.monthDate.month - 1,
//           )),
//         ),
//         const SizedBox(width: 16),
//         _buildIconButton(
//           CupertinoIcons.right_chevron,
//           () => _controller.onMonthSelected(DateTime(
//             _controller.monthDate.year,
//             _controller.monthDate.month + 1,
//           )),
//         ),
//       ],
//     );
//   }

//   Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
//     return InkWell(
//       onTap: onPressed,
//       child: Icon(
//         icon,
//         color: _theme.accentColor,
//       ),
//     );
//   }
// }

// class _MonthView extends StatefulWidget {
//   final List<String> months;
//   final CalendarController controller;

//   const _MonthView({
//     Key? key,
//     required this.months,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   __MonthViewState createState() => __MonthViewState();
// }

// class __MonthViewState extends State<_MonthView> {
//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addOnMonthSelectedListener(
//       (_) => setState(() {}),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final date = widget.controller.monthDate;
//     return Text(
//       '${widget.months[date.month - 1]} ${date.year}',
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.w800,
//         color: _theme.accentColor,
//       ),
//     );
//   }
// }

// // TODO: Add size animation on month change
// class CalendarDaysGrid extends StatefulWidget {
//   final List<String>? weekdays;
//   final int firstWeekday;
//   final CalendarController? controller;

//   const CalendarDaysGrid({
//     Key? key,
//     this.weekdays,
//     required this.firstWeekday,
//     this.controller,
//   }) : super(key: key);

//   @override
//   _CalendarDaysGridState createState() => _CalendarDaysGridState();
// }

// class _CalendarDaysGridState extends State<CalendarDaysGrid> {
//   late CalendarController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller ?? CalendarController();
//     _controller.addOnMonthSelectedListener(_onMonthSelected);
//   }

//   void _onMonthSelected(DateTime monthDate) => setState(() {});

//   @override
//   Widget build(BuildContext context) {
//     final days = _controller.days;
//     final nullGenerator = (_) => DateTime.now();
//     if (days[0].weekday != widget.firstWeekday) {
//       days.insertAll(
//         0,
//         List.generate(
//           days[0].weekday - (widget.firstWeekday == DateTime.monday ? 1 : 0),
//           nullGenerator,
//           growable: false,
//         ),
//       );
//     }
//     final daysRowsCount = (days.length / 7).ceil();
//     days.addAll(
//       List.generate(
//         7 * daysRowsCount - days.length,
//         nullGenerator,
//         growable: false,
//       ),
//     );

//     final cells = [
//       ...widget.weekdays!.map(_buildWeekday),
//       ...days.map(_buildCell),
//     ];
//     const spacer = SizedBox(height: 16);

//     return Table(
//       children: List.generate(
//         daysRowsCount + 1,
//         (columnIndex) => TableRow(
//           children: List.generate(
//             7,
//             (rowIndex) => cells[columnIndex * 7 + rowIndex],
//           ),
//         ),
//       ).separated(
//         const TableRow(children: [
//           spacer,
//           spacer,
//           spacer,
//           spacer,
//           spacer,
//           spacer,
//           spacer,
//         ]),
//         separateFrom: 1,
//       ),
//     );
//   }

//   Widget _buildCell(DateTime date) =>
//       date == null ? const SizedBox() : _buildDay(date);

//   Widget _buildWeekday(String name) {
//     return Container(
//       width: 32,
//       height: 24,
//       alignment: Alignment.center,
//       margin: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         name,
//         style: textTheme.bodyText1?.copyWith(
//           color: _theme.colorScheme.primaryVariant,
//         ),
//       ),
//     );
//   }

//   Widget _buildDay(DateTime dayDate) {
//     return Day(
//       key: UniqueKey(),
//       date: dayDate,
//       controller: _controller,
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.removeOnMonthSelectedListener(_onMonthSelected);
//   }
// }

// class Day extends StatefulWidget {
//   final DateTime date;
//   final CalendarController controller;

//   const Day({
//     Key? key,
//     required this.date,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   _DayState createState() => _DayState();
// }

// class _DayState extends ContextDependentState<Day> {
//   var _isInSelectedRange;
//   var _isSelectedRangeStart;
//   var _isSelectedRangeEnd;
//   var _isSelected;
//   var _isTheOnlyOneSelected;

//   @override
//   void initState() {
//     super.initState();
//     final controller = widget.controller;
//     controller.addOnRangeSelectedListener(_onRangeSelected);
//     if (controller.selectedRangeStart != null) {
//       _updateValues(
//           controller.selectedRangeStart!, controller.selectedRangeEnd!);
//     } else {
//       _isInSelectedRange = false;
//       _isSelectedRangeStart = false;
//       _isSelectedRangeEnd = false;
//       _isSelected = false;
//       _isTheOnlyOneSelected = false;
//     }
//   }

//   bool _updateValues(DateTime start, DateTime? end) {
//     final isSelectedRangeStartNow = widget.date == start;
//     final isTheOnlyOneSelectedNow = end == null;
//     final isSelectedRangeEndNow = isTheOnlyOneSelectedNow || widget.date == end;
//     final isSelectedNow = widget.date == start || widget.date == end;
//     final isInSelectedRangeNow = isSelectedNow ||
//         start.isBefore(widget.date) && (end?.isAfter(widget.date) ?? false);

//     final shouldRebuild = _isInSelectedRange != isInSelectedRangeNow ||
//         _isSelectedRangeStart != isSelectedRangeStartNow ||
//         _isSelectedRangeEnd != isSelectedRangeEndNow;

//     if (shouldRebuild) {
//       _isInSelectedRange = isInSelectedRangeNow;
//       _isSelectedRangeStart = isSelectedRangeStartNow;
//       _isSelectedRangeEnd = isSelectedRangeEndNow;
//       _isSelected = isSelectedNow;
//       _isTheOnlyOneSelected = isTheOnlyOneSelectedNow;
//     }

//     return shouldRebuild;
//   }

//   void _onRangeSelected(DateTime start, DateTime end) {
//     if (_updateValues(start, end)) setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     const size = 32.0;

//     final day = InkWell(
//       onTap: () => widget.controller.onDateClicked(widget.date),
//       borderRadius: const BorderRadius.all(Radius.circular(32)),
//       child: Container(
//         width: size,
//         height: size,
//         alignment: Alignment.center,
//         decoration: _isSelected
//             ? BoxDecoration(
//                 color: _theme.colorScheme.primaryVariant,
//                 borderRadius: const BorderRadius.all(Radius.circular(16)),
//               )
//             : null,
//         child: Text(
//           widget.date.day.toString(),
//           style: TextStyle(
//             fontSize: 20,
//             color: _isSelected ? Colors.white : null,
//           ),
//         ),
//       ),
//     );

//     return Align(
//       alignment: _isTheOnlyOneSelected
//           ? Alignment.center
//           : _isSelectedRangeStart
//               ? Alignment.centerRight
//               : _isSelectedRangeEnd
//                   ? Alignment.centerLeft
//                   : Alignment.center,
//       child: !_isInSelectedRange || _isTheOnlyOneSelected
//           ? day
//           : LayoutBuilder(
//               builder: (_, constraints) {
//                 final spacing = (constraints.maxWidth - size) / 2;
//                 return Container(
//                   width: _isSelected ? size + spacing : null,
//                   alignment: _isSelectedRangeStart
//                       ? Alignment.centerLeft
//                       : _isSelectedRangeEnd
//                           ? Alignment.centerRight
//                           : Alignment.center,
//                   decoration: !_isTheOnlyOneSelected
//                       ? BoxDecoration(
//                           color: _rangeColor,
//                           borderRadius: _isSelected
//                               ? BorderRadius.horizontal(
//                                   left: Radius.circular(
//                                     _isSelectedRangeStart ? 16 : 0,
//                                   ),
//                                   right: Radius.circular(
//                                     _isSelectedRangeEnd ? 16 : 0,
//                                   ),
//                                 )
//                               : null,
//                         )
//                       : null,
//                   child: day,
//                 );
//               },
//             ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     widget.controller.removeOnRangeSelectedListener(_onRangeSelected);
//   }
// }
