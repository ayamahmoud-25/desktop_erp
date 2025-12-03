class SpinnerModel {
  String? _id;
  String? _extraId;
  String? _name;
  String? _extraItem;

  SpinnerModel({
    required String id,
    required String name,
    String? extraItem
  })  : _id = id,
        _name = name,
    _extraItem = extraItem;

  SpinnerModel.DataReportModel({
    required String id,
    required String extraId,
    required String name,
    required String? extraItem
  })  : _id = id,
       _extraId = extraId,
        _name = name,
        _extraItem = extraItem;


  // Getter for id
  String? get id => _id;

  // Setter for id
  set id(String? value) {
    _id = value;
  }


  // Getter for extraId
  String? get extraId => _extraId;

  // Setter for extraId
  set extraId(String? value) {
    _extraId= value;
  }
  // Getter for name
  String? get name => _name;

  // Setter for name
  set name(String? value) {
    _name = value;
  }


  // Getter for extraItem
  String? get extraItem => _extraItem;

  // Setter for name
  set extraItem(String? extraItem) {
    _extraItem = extraItem;
  }
}