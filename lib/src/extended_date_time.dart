extension ExtendedDateTime on DateTime {
  bool get isToday => isTheSameDayAs(DateTime.now());

  bool isTheSameDayAs(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }

  operator <=(DateTime other) => isBefore(other);

  operator >=(DateTime other) => isAfter(other);
}
