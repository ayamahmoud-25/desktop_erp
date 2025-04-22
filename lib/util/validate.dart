import 'Strings.dart';

class Validator{

  String? validate(String? value) {
    if(value!.trim().isEmpty){
      return Strings.ERROR_NO_DATA_FIELD;
    }
    return null;
  }


}
