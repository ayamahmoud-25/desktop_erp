import 'package:desktop_erp_4s/ui/reports/model/agent_data_model.dart';
import 'package:desktop_erp_4s/util/spinner_model.dart';
import 'package:desktop_erp_4s/util/strings.dart';
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

   List<AgentData> getListOfAgentData(){
    List<dynamic> jsonData = [
      {
        "AGENT_CODE": "005",
        "AGENT_NAME": "البنك التجارى الدولى الجنيه المصري",
        "BEGIN_DEBIT": 1300093.71,
        "BEGIN_CREDIT": 0.0,
        "TRNS_DEBIT": 0.0,
        "TRNS_CREDIT": 0.0,
        "END_DEBIT": 1300093.71,
        "END_CREDIT": 0.0
      },
      {
        "AGENT_CODE": "004",
        "AGENT_NAME": "البنك الاهلى المصرى جنيه مصرى",
        "BEGIN_DEBIT": 5739713.73,
        "BEGIN_CREDIT": 0.0,
        "TRNS_DEBIT": 0.0,
        "TRNS_CREDIT": 900.0,
        "END_DEBIT": 5738813.73,
        "END_CREDIT": 0.0
      },
      {
        "AGENT_CODE": "008",
        "AGENT_NAME": "ابو ظبى الاول - ج.م",
        "BEGIN_DEBIT": 0.0,
        "BEGIN_CREDIT": 955613.98,
        "TRNS_DEBIT": 800.0,
        "TRNS_CREDIT": 0.0,
        "END_DEBIT": 0.0,
        "END_CREDIT": 955613.98
      },
      {
        "AGENT_CODE": "010",
        "AGENT_NAME": "بنك ابو ظبى الاول تسهيلات ائتمانية - مرتبات وعمولات",
        "BEGIN_DEBIT": 0.0,
        "BEGIN_CREDIT": 3416351.68,
        "TRNS_DEBIT": 0.0,
        "TRNS_CREDIT": 0.0,
        "END_DEBIT": 0.0,
        "END_CREDIT": 3416351.68
      },
      {
        "AGENT_CODE": "002",
        "AGENT_NAME": "بنك القاهرة جنيه مصرى",
        "BEGIN_DEBIT": 129800.0,
        "BEGIN_CREDIT": 0.0,
        "TRNS_DEBIT": 0.0,
        "TRNS_CREDIT": 0.0,
        "END_DEBIT": 129800.0,
        "END_CREDIT": 0.0
      },
      {
        "AGENT_CODE": "006",
        "AGENT_NAME": "بنك قطر الوطنى جنيه مصرى",
        "BEGIN_DEBIT": 474488.48,
        "BEGIN_CREDIT": 0.0,
        "TRNS_DEBIT": 0.0,
        "TRNS_CREDIT": 0.0,
        "END_DEBIT": 474488.48,
        "END_CREDIT": 0.0
      },
      {
        "AGENT_CODE": "001",
        "AGENT_NAME": "بنك مصر الجنيه المصري",
        "BEGIN_DEBIT": 1781402.09,
        "BEGIN_CREDIT": 0.0,
        "TRNS_DEBIT": 0.0,
        "TRNS_CREDIT": 0.0,
        "END_DEBIT": 1781402.09,
        "END_CREDIT": 0.0
      },
      {
        "AGENT_CODE": "007",
        "AGENT_NAME": "البنك الاهلى المتحد جنيه مصرى",
        "BEGIN_DEBIT": 0.0,
        "BEGIN_CREDIT": 40000.0,
        "TRNS_DEBIT": 0.0,
        "TRNS_CREDIT": 0.0,
        "END_DEBIT": 0.0,
        "END_CREDIT": 40000.0
      },
      {
        "AGENT_CODE": "009",
        "AGENT_NAME": "ابو ظبى الاول تسهيلات ائتمانية",
        "BEGIN_DEBIT": 0.0,
        "BEGIN_CREDIT": 62861649.65,
        "TRNS_DEBIT": 0.0,
        "TRNS_CREDIT": 0.0,
        "END_DEBIT": 0.0,
        "END_CREDIT": 62861649.65
      },
      {
        "AGENT_CODE": "003",
        "AGENT_NAME": "البنك العربى الافريقى الدولى جنيه مصرى",
        "BEGIN_DEBIT": 3431796.22,
        "BEGIN_CREDIT": 0.0,
        "TRNS_DEBIT": 100.0,
        "TRNS_CREDIT": 0.0,
        "END_DEBIT": 3431896.22,
        "END_CREDIT": 0.0
      }
    ];

    List<AgentData> agents = jsonData.map((e) => AgentData.fromJson(e)).toList();

     return agents;

  }


  List<SpinnerModel> getReportTypeList() {
    return [
      SpinnerModel.DataReportModel(id: Strings.CUSTOMER_TYPE,extraId: "العميل", name: "عميل", extraItem: "أرصدة العملاء بالحركة"),
      SpinnerModel.DataReportModel(id:Strings.VENDOR_TYPE,extraId: "المورد", name:"مورد", extraItem:"أرصدة الموردين بالحركة"),
      SpinnerModel.DataReportModel(id:Strings.CONTRACTOR_TYPE, extraId:"المقاول", name:"مقاول", extraItem:""),
      SpinnerModel.DataReportModel(id:Strings.AGENT_TYPE, extraId:"الجهه", name:"جهه", extraItem:"أرصدة الجهات بالحركة"),
      SpinnerModel.DataReportModel(id:Strings.BANK_TYPE,extraId: "البنك", name:"بنوك",extraItem: "أرصدة البنوك"),
      SpinnerModel.DataReportModel(id:Strings.TREASURE_BAS_TYPE, extraId:"الخزنه",name: "خزن",extraItem: "أرصدة الخزن"),
    ];
  }

  String getCurrentFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat("yyyy/MM/dd'T'HH:mm:ss");
    return formatter.format(now);
  }
}