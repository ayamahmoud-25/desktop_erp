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
  static List<String> getPaymentMethod() {
    // Note: If you update the index here, you must compare and update also getPartsDataLists(from, to).
    List<String> fromToIndexList = [
        "طريقة الدفع",
        "نقدي",     // Cash
        "كارت ئتمان",    // Check
        "اجل",    // Bank Transfer
        "تحت التحصيل",   // Credit Card
    ];

    return fromToIndexList;
  }

}