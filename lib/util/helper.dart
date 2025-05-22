import 'package:intl/intl.dart';

class Helper{

  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }


  static String getDateTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
  }

  static String getDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  static String getTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    return "${dateTime.hour}:${dateTime.minute}";
  }

  static String getDateWithMonthName(String date) {
    DateTime dateTime = DateTime.parse(date);
    return "${dateTime.day} ${getMonthName(dateTime.month)} ${dateTime.year}";
  }

  static String getMonthName(int month) {
    List<String> monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return monthNames[month - 1];
  }
}