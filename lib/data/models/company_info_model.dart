class CompanyInfo{
  String? clientName;
  String? loginName;
  String? serviceName;
  String? dbName;
  String? pubUrl;

  CompanyInfo({this.clientName, this.loginName, this.serviceName,  this.dbName, this.pubUrl});


  factory CompanyInfo.fromJson(Map<String,dynamic> json){
    CompanyInfo c = CompanyInfo();
    c.clientName = json['CLIENT_NAME'];
    c.loginName = json['LOGIN_NAME'];
    c.serviceName = json['SERVICE_NAME'];
    c.dbName = json['DB_NAME'];
    c.pubUrl = json['DB_NAME'];
    return c;
  }
}