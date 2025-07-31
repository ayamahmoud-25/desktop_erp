import 'package:desktop_erp_4s/util/spinner_model.dart';

class FormUtils {
  static String getNameFromIndex(int index) {
    // Note: If you update the index here, you must compare and update also getPartsDataLists(from, to).

    Map<int, String> fromToIndexList = {
      0: "لا يوجد",
      1: "عميل",     // Customer
      2: "مورد",    // Vendor
      3: "جهه",    // Agent
      4: "مخزن",   // stores
      5: "جهه تشغيل", // works areas
      6: "اداره", // Department
      8: "مقاولون", // Contractors
      9: "افراد", // persons
    };

    if (index == 7 || index > 9) {
      throw RangeError("Index is out of bounds.");
    }

    return fromToIndexList[index] ?? "لا يوجد";
  }
  static List<SpinnerModel> getPaymentMethod() {
    // Note: If you update the index here, you must compare and update also getPartsDataLists(from, to).
    List<SpinnerModel> paymentMethods = [
      SpinnerModel(id: "0", name: "طريقة الدفع"),
      SpinnerModel(id: "1", name: "نقدي"),     // Cash
      SpinnerModel(id: "2", name: "كارت ئتمان"),    // Check
      SpinnerModel(id: "3", name: "اجل"),    // Bank Transfer
      SpinnerModel(id: "4", name: "تحت التحصيل"),   // Credit Card
    ];
    return paymentMethods;

  }
// Methods
  SpinnerModel? getSpinnerModelById(List<SpinnerModel> spinnerModels, String id) {
    return spinnerModels.firstWhere(
          (model) => model.id == id,
      orElse: () => SpinnerModel(id: id, name: "غير معروف"),
    );
  }

  SpinnerModel? getSpinnerModelByIndex(List<SpinnerModel> spinnerModels, int index) {
    if (index >= 0 && index < spinnerModels.length) {
      return spinnerModels[index];
    }
    return null;
  }
}