class CompanyInfoResponse{
  String? clientName;
  String? loginName;
  String? serviceName;
  String? dbName;
  String? pubUrl;

  CompanyInfoResponse({this.clientName, this.loginName, this.serviceName,  this.dbName, this.pubUrl});


  Map<String, dynamic> toJson() {
    return {
      'CLIENT_NAME': clientName,
      'LOGIN_NAME': loginName,
      'SERVICE_NAME': serviceName,
      'DB_NAME': dbName,
      'PUB_URL': pubUrl,
    };
  }
  factory CompanyInfoResponse.fromJson(Map<String,dynamic> json){
    CompanyInfoResponse c = CompanyInfoResponse();
    c.clientName = json['CLIENT_NAME'];
    c.loginName = json['LOGIN_NAME'];
    c.serviceName = json['SERVICE_NAME'];
    c.dbName = json['DB_NAME'];
    c.pubUrl = json['PUB_URL'];
    return c;
  }
}