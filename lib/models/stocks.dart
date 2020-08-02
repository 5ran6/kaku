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
//class Stocks{
//final  String name;
//final  String cost_price;
//final  String selling_price;
//final  String date;
//
//
//Stocks(this.name, this.cost_price, this.selling_price, this.date);
//}
//

class Stock {
  Data data;
  String message;
  bool error;

  Stock({this.data, this.message, this.error});

  Stock.fromJson(Map<String, dynamic> json) {
    data = json['data']['product_stock'] != null ? json['data']['product_stock'] : null;
    message = json['message'];
    error = json['error'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data']['product_stock'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}

class Data {
  String name;
  String selling_price;
  String quantity;

  Data({this.name, this.selling_price, this.quantity });

  Data.fromJson(Map<String, dynamic> json) {
    name = json['id'];
  //  name = json['name'];
    selling_price = json['selling_price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['selling_price'] = this.selling_price;
    data['quantity'] = this.quantity;

    return data;
  }
}
