import 'package:intl/intl.dart';

class DateConvert {
  static String convertStringToDayAndNameOfMonth(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var monthFormat = DateFormat("MMMM");
    var month = monthFormat.format(inputDate);
    var dayFormat = DateFormat("d");
    var day = dayFormat.format(inputDate);
    return month + ' ' + day;
  }

  static String convertStringToDayForCommentCard(String date) {
    return date.split('T')[0] + ' ' + (date.split('T')[1]).split('.')[0];
  }
}
