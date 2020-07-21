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
class Stocks{
final  String name;
final  String cost_price;
final  String selling_price;
final  String date;


Stocks(this.name, this.cost_price, this.selling_price, this.date);
}


//class Stocks {
//  Data data;
//  String message;
//  bool error;
//
//  Stocks({this.data, this.message, this.error});
//
//  Stocks.fromJson(Map<String, dynamic> json) {
//    data = json['data']['stocks'] != null ? json['data']['stocks'] : null;
//    message = json['message'];
//    error = json['error'];
//
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    if (this.data != null) {
//      data['data']['stocks'] = this.data.toJson();
//    }
//    data['message'] = this.message;
//    data['error'] = this.error;
//    return data;
//  }
//}
//
//class Data {
//  String name;
//  String cost_price;
//  String selling_price;
//  String date;
//
//  Data({this.name, this.cost_price, this.selling_price, this.date});
//
//  Data.fromJson(Map<String, dynamic> json) {
//    name = json['product']['name'];
//    cost_price = json['cost_price'];
//    selling_price = json['selling_price'];
//    date = json['created_at'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['product']['name'] = this.name;
//    data['cost_price'] = this.cost_price;
//    data['selling_price'] = this.selling_price;
//    data['created_at'] = this.date;
//    return data;
//  }
//}
