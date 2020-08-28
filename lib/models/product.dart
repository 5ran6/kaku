class Product {
  int id;
  String name;

  Product({this.id, this.name});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}
