import 'package:intl/intl.dart';

sealed class DMYFormat {}

class DateMonthYearWithDot extends DMYFormat {}

class DateMonthYearWithDash extends DMYFormat {}

class DateTimeUtils {
  DateTimeUtils._();
  static const dotDMYFormat = "yyyy.MM.dd";
  static const dashDMYFormat = "yyyy-MM-dd";

  ///2021-11-12T16:57:19.000Z
  static String toFormattedStr(String createAt, {DMYFormat? dateMonthYear}) {
    var format = switch (dateMonthYear) {
      DateMonthYearWithDot() => dotDMYFormat,
      DateMonthYearWithDash() => dashDMYFormat,
      null => dotDMYFormat
    };

    final dateTimeFormat = DateFormat(format, "en_US");
    final result = DateTime.parse(createAt);
    return dateTimeFormat.format(result);
  }

  static String dateTimeToStr(DateTime dateTime, {DMYFormat? dateMonthYear}) {
    var format = switch (dateMonthYear) {
      DateMonthYearWithDot() => dotDMYFormat,
      DateMonthYearWithDash() => dashDMYFormat,
      null => dotDMYFormat
    };

    final dateTimeFormat = DateFormat(format, "en_US");
    return dateTimeFormat.format(dateTime);
  }

  static DateTime strTodDateTime(String dayTimeStr) {
    final dateTimeFormat = DateFormat("yyyy-MM-dd", "en_US");
    return dateTimeFormat.parse(dayTimeStr);
  }

  static String timeStampToStr(int timeStamp) {
    final dateTimeFormat = DateFormat("yyyy-MM-dd", "en_US");
    final result =
        dateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(timeStamp));
    return result;
  }

  static int justifyTimestamp(int timestamp) {
    var displayTimeStr = DateTimeUtils.timeStampToStr(timestamp);
    var displayTime = DateTimeUtils.strTodDateTime(displayTimeStr);
    return displayTime.millisecondsSinceEpoch;
  }
}
