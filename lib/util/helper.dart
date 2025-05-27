import 'package:intl/intl.dart';

class Helper{

  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('yyyy/MM/dd').format(parsedDate);
    } catch (e) {
      return 'Invalid Date';
    }

  }

  String getNameFromIndex(int index) {
    // Note: If you update the index here,
    // you must compare and update also getPartsDataLists(from, to).

    const Map<int, String> fromToIndexList = {
      0: "لا يوجد",
      1: "عميل",
      2: "مورد",
      3: "جهه",
      4: "مخزن",
      5: "جهه تشغيل",
      6: "اداره",
      8: "مقاولون",
      9: "افراد",
    };

    if (index == 7 || index > 9) {
      throw RangeError('Index is out of bounds.');
    }

    // Returns null if index not found, so handle that:
    if (!fromToIndexList.containsKey(index)) {
      throw RangeError('Index is out of bounds.');
    }
    return fromToIndexList[index]!;
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