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

class Products {
  Data data;
  String message;
  bool error;

  Products({this.data, this.message, this.error});

  Products.fromJson(Map<String, dynamic> json) {
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
/*
* cost_price: null,
                  selling_price: null,
                  quantity: null,
                  description: null,
                  discount: null),
* */

  String product_name;
  String product_id;
  String category;
  String sub_category, selling_price, cost_price;

  Data({this.product_name, this.product_id, this.category, this.sub_category, this.cost_price, this.selling_price});

  Data.fromJson(Map<String, dynamic> json) {
    product_name = json['name'];
    product_id = json['id'];
    category = json['product_category']['name'];
    sub_category = json['product_subcategory']['name'];

    cost_price = json['cost_price'];
    selling_price = json['selling_price'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.product_name;
    data['id'] = this.product_id;
    data['product_category']['name'] = this.category;
    data['product_subcategory']['name'] = this.sub_category;
    return data;
  }
}
