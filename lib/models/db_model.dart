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

class Stocks {
  final String id;
  final String vendor_id;
  final String product_id;
  final String cost_price;
  final String selling_price;
  final String initial_quantity;
  final String current_quantity;
  final String cost_value;
  final String discount;
  final String expiry_date;
  final String total_value;
  final String description;
  final String authorizer;
  final String deleted_at;
  final String created_at;
  final String updated_at;

  Stocks(
      this.id,
      this.vendor_id,
      this.product_id,
      this.cost_price,
      this.selling_price,
      this.initial_quantity,
      this.current_quantity,
      this.cost_value,
      this.discount,
      this.expiry_date,
      this.total_value,
      this.description,
      this.authorizer,
      this.deleted_at,
      this.created_at,
      this.updated_at);
}

class Payments {
  final String id;
  final String vendor_id;
  final String invoice_id;
  final String receipt_no;
  final String amount_paid;
  final String note;
  final String payment_method;
  final String authorizer;
  final String status;
  final String deleted_at;
  final String created_at;
  final String updated_at;

  Payments(
      this.id,
      this.vendor_id,
      this.invoice_id,
      this.receipt_no,
      this.amount_paid,
      this.note,
      this.payment_method,
      this.authorizer,
      this.status,
      this.deleted_at,
      this.created_at,
      this.updated_at);
}

class Stock {
  Data data;
  String message;
  bool error;

  Stock({this.data, this.message, this.error});

  Stock.fromJson(Map<String, dynamic> json) {
    data = json['data']['stocks'] != null ? json['data']['stocks'] : null;
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data']['stocks'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}

//
class Data {
  String id;
  String vendor_id;
  String product_id;
  String cost_price;
  String selling_price;
  String initial_quantity;
  String current_quantity;
  String cost_value;
  String discount;
  String expiry_date;
  String total_value;
  String description;
  String authorizer;
  String deleted_at;
  String created_at;
  String updated_at;

  Data(
      {this.id,
      this.vendor_id,
      this.product_id,
      this.cost_price,
      this.selling_price,
      this.initial_quantity,
      this.current_quantity,
      this.cost_value,
      this.discount,
      this.expiry_date,
      this.total_value,
      this.description,
      this.authorizer,
      this.deleted_at,
      this.created_at,
      this.updated_at});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    //  name = json['name'];
    selling_price = json['selling_price'];
    vendor_id = json['vendor_id'];
    product_id = json['product_id'];
    cost_price = json['cost_price'];
    selling_price = json['selling_price'];
    initial_quantity = json['initial_quantity'];
    current_quantity = json['current_quantity'];
    cost_value = json['cost_value'];
    discount = json['discount'];
    expiry_date = json['expiry_date'];
    total_value = json['total_value'];
    description = json['description'];
    authorizer = json['authorizer'];
    deleted_at = json['deleted_at'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendor_id;
    data['product_id'] = this.product_id;
    data['cost_price'] = this.cost_price;
    data['selling_price'] = this.selling_price;
    data['initial_quantity'] = this.initial_quantity;
    data['current_quantity'] = this.current_quantity;
    data['cost_value'] = this.cost_value;
    data['discount'] = this.discount;
    data['expiry_date'] = this.expiry_date;
    data['total_value'] = this.total_value;
    data['description'] = this.description;
    data['authorizer'] = this.authorizer;
    data['deleted_at'] = this.deleted_at;
    data['created_at'] = this.created_at;
    data['updated_at'] = this.updated_at;

    return data;
  }
}
