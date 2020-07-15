//class Employee {
//  final String firstname;
//  final String lastname;
//  final String email;
//  final String id;
//  final String is_active;
//
//  Employee(
//      {this.firstname, this.lastname, this.id, this.email, this.is_active});
//}

class Stock {
  Data data;
  String message;
  bool error;

  Stock({this.data, this.message, this.error});

  Stock.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}

class Data {
  String stocks;
  String stocks_count;

  Data({this.stocks, this.stocks_count});

  Data.fromJson(Map<String, dynamic> json) {
    stocks = json['stocks'];
    stocks_count = json['stocks_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stocks'] = this.stocks;
    data['stocks_count'] = this.stocks_count;
    return data;
  }
}
